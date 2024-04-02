------------------------------------------------------------------------------
--          ____  _____________  __                                         --
--         / __ \/ ____/ ___/\ \/ /                 _   _   _               --
--        / / / / __/  \__ \  \  /                 / \ / \ / \              --
--       / /_/ / /___ ___/ /  / /               = ( M | S | K )=            --
--      /_____/_____//____/  /_/                   \_/ \_/ \_/              --
--                                                                          --
------------------------------------------------------------------------------
--! @copyright Copyright 2020-2022 DESY
--! SPDX-License-Identifier: Apache-2.0
------------------------------------------------------------------------------
--! @date 2020-05-25/2021-10-12
--! @author Lukasz Butkowski <lukasz.butkowski@desy.de>
--! @author Michael Büchler <michael.buechler@desy.de>
------------------------------------------------------------------------------
--! @brief
--! ax4-lite address decoder for DesyRdl
------------------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library desyrdl;
use desyrdl.common.all;

entity examp_regs_decoder_axi4l is
  generic (
    G_ADDR_WIDTH    : integer := 32;
    G_DATA_WIDTH    : integer := 32
  );
  port (
    pi_clock  : in std_logic;
    pi_reset  : in std_logic;
    --
    po_reg_rd_stb  : out std_logic_vector(7-1 downto 0);
    po_reg_wr_stb  : out std_logic_vector(7-1 downto 0);
    po_reg_data    : out std_logic_vector(G_DATA_WIDTH-1 downto 0);
    pi_reg_data    : in  std_logic_vector(G_DATA_WIDTH-1 downto 0);
    --
    --
    po_rgf_reg_rd_stb  : out std_logic_vector(4-1 downto 0);
    po_rgf_reg_wr_stb  : out std_logic_vector(4-1 downto 0);
    po_rgf_reg_data    : out std_logic_vector(G_DATA_WIDTH-1 downto 0);
    pi_rgf_reg_data    : in  std_logic_vector(G_DATA_WIDTH-1 downto 0);
    --
    --
    --
    pi_s_reset : in std_logic;
    pi_s_top   : in  t_axi4l_m2s ;
    po_s_top   : out t_axi4l_s2m
);
end entity examp_regs_decoder_axi4l;

architecture arch of examp_regs_decoder_axi4l is

  type t_target is (REG, RGF,  NONE );

  signal rtarget, wtarget  : t_target := NONE;

  -- Standard  statements

-- INLINE statement with -- #
  ----------------------------------------------------------
  -- read
  type t_state_read is (
    ST_READ_IDLE,
    ST_READ_SELECT,
    ST_READ_VALID,
    ST_READ_REG_BUSY, -- when no address hit, dummy reg
    ST_READ_DONE
  );
  signal state_read : t_state_read;

  signal rdata_reg : std_logic_vector(G_DATA_WIDTH-1 downto 0);
  signal rdata_rgf : std_logic_vector(G_DATA_WIDTH-1 downto 0);
  signal rdata_mem : std_logic_vector(G_DATA_WIDTH-1 downto 0);
  signal rdata_ext : std_logic_vector(G_DATA_WIDTH-1 downto 0);

  signal rdata     : std_logic_vector(G_DATA_WIDTH-1 downto 0) := (others => '0');
  signal raddr     : std_logic_vector(G_ADDR_WIDTH-1 downto 0) := (others => '0');
  signal raddr_int : integer;

  ----------------------------------------------------------
  -- write
  type t_state_write is (
    ST_WRITE_IDLE,
    ST_WRITE_WAIT_DATA,
    ST_WRITE_WAIT_ADDR,
    ST_WRITE_SELECT,
    ST_WRITE_RESP
  );
  signal state_write : t_state_write;

  signal wdata     : std_logic_vector(G_DATA_WIDTH-1 downto 0) := (others => '0');
  signal wstrb     : std_logic_vector(G_DATA_WIDTH/8-1 downto 0) := (others => '0');
  signal waddr     : std_logic_vector(G_ADDR_WIDTH-1 downto 0) := (others => '0');
  signal waddr_int : integer;
  signal wvalid    : std_logic;

  -----------------------------------------------------------
  signal reg_rd_stb  : std_logic_vector(7-1 downto 0) := (others => '0');
  signal reg_wr_stb  : std_logic_vector(7-1 downto 0) := (others => '0');
  signal regf_rd_stb      : std_logic_vector(1-1 downto 0) := (others => '0');
  signal regf_wr_stb      : std_logic_vector(1-1 downto 0) := (others => '0');
  signal regf_reg_rd_stb  : std_logic_vector(4-1 downto 0) := (others => '0');
  signal regf_reg_wr_stb  : std_logic_vector(4-1 downto 0) := (others => '0');
  signal regf_raddr_int   : integer;
  signal regf_waddr_int   : integer;

  -- external bus

  constant read_timeout  : natural := 8191;
  constant write_timeout : natural := 8191;
  signal read_time_cnt   : natural := 0;
  signal write_time_cnt  : natural := 0;
  signal invalid_rdata   : std_logic ;

  signal reset : std_logic;
begin

  -- main reset - global or bus reset
  reset <= pi_reset or pi_s_reset;

  -- ===========================================================================
  -- ### read logic
  ------------------------------------------------------------------------------
  -- read channel state machine
  ------------------------------------------------------------------------------
  prs_state_read: process (pi_clock)
  begin
    if rising_edge(pi_clock) then
      if reset = '1' then
        state_read <= ST_READ_IDLE;
        invalid_rdata <= '0';
      else
        case state_read is
          when ST_READ_IDLE =>

            if pi_s_top.arvalid = '1' then
              state_read <= ST_READ_SELECT;
            end if;
            invalid_rdata <= '0';
          when ST_READ_SELECT =>
            case rtarget is
              when REG =>
                state_read <= ST_READ_VALID;
              when RGF =>
                state_read <= ST_READ_REG_BUSY;
              when others =>
                state_read <= ST_READ_REG_BUSY;
            end case;

          when ST_READ_REG_BUSY =>
            state_read <= ST_READ_VALID;

          when ST_READ_VALID =>
            if pi_s_top.rready = '1' then
              state_read <= ST_READ_DONE;
            end if;

          when ST_READ_DONE =>
              state_read <= ST_READ_IDLE;

          when others =>
            state_read <= ST_READ_IDLE;

        end case;

      end if;
    end if;
  end process;
  po_s_top.rresp <= "00";
  ------------------------------------------------------------------------------
  -- read data mux
  prs_rdata_mux: process(rtarget,rdata_reg,rdata_rgf,invalid_rdata)
  begin
    if invalid_rdata = '1' then
      po_s_top.rdata <= (others => '0' ) ;
    elsif rtarget = REG then
      po_s_top.rdata <= rdata_reg ;
    elsif rtarget = RGF then
      po_s_top.rdata <= rdata_rgf ;
    else
      po_s_top.rdata <= (others => '0' ) ;
    end if;
  end process prs_rdata_mux;

  ------------------------------------------------------------------------------
  -- ARREADY flag handling
  prs_axi_arready: process (state_read)
  begin
    case state_read is
      when ST_READ_IDLE =>
        po_s_top.arready <= '1';
      when others =>
        po_s_top.arready <= '0';
    end case;
  end process;

  -- RVALID flag handling
  prs_axi_rvalid: process (
      state_read)
  begin
    case state_read is
      when ST_READ_VALID =>
        po_s_top.rvalid <= '1';
      when others =>
        po_s_top.rvalid <= '0';
    end case;
  end process;

  ------------------------------------------------------------------------------
  -- Address decoder
  ------------------------------------------------------------------------------
  raddr_int <= to_integer(unsigned(pi_s_top.araddr(G_ADDR_WIDTH-1 downto 0)));

  prs_raddr_decoder: process(pi_clock)
  begin
    if rising_edge(pi_clock) then
      if state_read = ST_READ_IDLE and pi_s_top.arvalid = '1' then
        reg_rd_stb <= (others => '0');
        -- regf_rd_stb <= (others => '0');
        case raddr_int is
          when 16 =>
             rtarget  <= REG;
             reg_rd_stb(0) <= '1';
          when 20 =>
             rtarget  <= REG;
             reg_rd_stb(1) <= '1';
          when 24 =>
             rtarget  <= REG;
             reg_rd_stb(2) <= '1';
          when 28 =>
             rtarget  <= REG;
             reg_rd_stb(3) <= '1';
          when 32 =>
             rtarget  <= REG;
             reg_rd_stb(4) <= '1';
          when 36 =>
             rtarget  <= REG;
             reg_rd_stb(5) <= '1';
          when 40 =>
             rtarget  <= REG;
             reg_rd_stb(6) <= '1';
          when 0 to 15 =>
             rtarget  <= RGF;
             regf_raddr_int <= raddr_int - 0;
             regf_rd_stb(0) <= '1';
             -- regf_rd_req <= '1';
          when others =>
             rtarget    <= NONE;
        end case;

      elsif state_read = ST_READ_DONE then
        reg_rd_stb <= (others => '0');
        regf_rd_stb <= (others => '0');

      end if;
    end if;
  end process prs_raddr_decoder;
  ----------------------------------------------------------
  --
  prs_rf_0_rd_decoder: process(pi_clock)
  begin
    if rising_edge(pi_clock) then
      if regf_rd_stb(0) = '1' then
        case regf_raddr_int is --
          when 0 =>
            regf_reg_rd_stb(0) <= '1'; --
          when 4 =>
            regf_reg_rd_stb(1) <= '1'; --
          when 8 =>
            regf_reg_rd_stb(2) <= '1'; --
          when 12 =>
            regf_reg_rd_stb(3) <= '1'; --
          when others =>
        end case;
      else
        regf_reg_rd_stb(4-1 downto 0) <= (others => '0'); --
      end if;
    end if;
  end process; --

  -- ===========================================================================
  -- ### write logic
  ------------------------------------------------------------------------------
  -- Write channel state machine
  ------------------------------------------------------------------------------
  prs_state_write: process (pi_clock)
  begin
    if rising_edge (pi_clock) then
      if reset = '1' then
        state_write <= ST_WRITE_IDLE;
      else
        case state_write is
          when ST_WRITE_IDLE =>

            if pi_s_top.awvalid = '1' and pi_s_top.wvalid = '1' then
              state_write <= ST_WRITE_SELECT;
            elsif pi_s_top.awvalid = '1' and pi_s_top.wvalid = '0' then
              state_write <= ST_WRITE_WAIT_DATA;
            elsif pi_s_top.awvalid = '0' and pi_s_top.wvalid = '1' then
              state_write <= ST_WRITE_WAIT_ADDR;
            end if;

          when ST_WRITE_WAIT_DATA =>
            if pi_s_top.wvalid = '1' then
              state_write <= ST_WRITE_SELECT;
            end if;

          when ST_WRITE_WAIT_ADDR =>
            if pi_s_top.awvalid = '1' then
              state_write <= ST_WRITE_SELECT;
            end if;

          when ST_WRITE_SELECT =>
            case wtarget is
              when REG =>
                state_write <= ST_WRITE_RESP;
              when RGF =>
                state_write <= ST_WRITE_RESP;
              when others =>
                state_write <= ST_WRITE_RESP; -- every write transaction must end with response
            end case;

          when ST_WRITE_RESP =>
            if pi_s_top.bready = '1' then
              state_write <= ST_WRITE_IDLE;
            end if;

          when others =>
            state_write <= ST_WRITE_IDLE;

        end case;
      end if;
    end if;
  end process;

  ------------------------------------------------------------------------------
  -- WRITE AXI handshaking
  po_s_top.bresp <= "00";

  prs_axi_bvalid: process (state_write)
  begin
    case state_write is
      when ST_WRITE_RESP =>
        po_s_top.bvalid <= '1';
      when others =>
        po_s_top.bvalid <= '0';
    end case;
  end process;

  prs_axi_awready: process (state_write)
  begin
    case state_write is
      when ST_WRITE_IDLE | ST_WRITE_WAIT_ADDR =>
        po_s_top.awready <= '1';
      when others =>
        po_s_top.awready <= '0';
    end case;
  end process;

  prs_axi_wready: process (state_write)
  begin
    case state_write is
      when ST_WRITE_IDLE | ST_WRITE_WAIT_DATA =>
        po_s_top.wready <= '1';
      when others =>
        po_s_top.wready <= '0';
    end case;
  end process;

  ------------------------------------------------------------------------------
  -- write Address decoder
  ------------------------------------------------------------------------------
  waddr_int <= to_integer(unsigned(pi_s_top.awaddr(G_ADDR_WIDTH-1 downto 0)));

  prs_waddr_decoder: process(pi_clock)
  begin
    if rising_edge(pi_clock) then
      if (state_write = ST_WRITE_IDLE or state_write = ST_WRITE_WAIT_ADDR ) and pi_s_top.awvalid = '1' then
        reg_wr_stb <= (others => '0');
        regf_wr_stb <= (others => '0');
        case waddr_int is
          when 16 =>
             wtarget  <= REG;
             reg_wr_stb(0) <= '1';
          when 24 =>
             wtarget  <= REG;
             reg_wr_stb(2) <= '1';
          when 28 =>
             wtarget  <= REG;
             reg_wr_stb(3) <= '1';
          when 32 =>
             wtarget  <= REG;
             reg_wr_stb(4) <= '1';
          when 0 to 15 =>
             wtarget <= RGF;
             regf_waddr_int <= waddr_int - 0;
             regf_wr_stb(0) <= '1';
          when others =>
             wtarget    <= NONE;
        end case;

      elsif state_write = ST_WRITE_RESP then
        reg_wr_stb <= (others => '0');
        regf_wr_stb <= (others => '0');
      end if;
    end if;
  end process prs_waddr_decoder;
  ----------------------------------------------------------
  --
  prs_rf_0_wr_decoder: process(pi_clock)
  begin
    if rising_edge(pi_clock) then
      if regf_wr_stb(0) = '1' then
        case regf_waddr_int is --
          when 0 =>
            regf_reg_wr_stb(0) <= '1'; --
          when others =>
        end case;
      else
        regf_reg_wr_stb(4-1 downto 0) <= (others => '0'); --
      end if;
    end if;
  end process; --

  prs_wvalid_reg : process(pi_clock)
  begin
    if rising_edge(pi_clock) then
      if state_write  = ST_WRITE_IDLE or state_write = ST_WRITE_WAIT_DATA then
        wvalid <= pi_s_top.wvalid;
      elsif state_write = ST_WRITE_RESP then
        wvalid <= '0';
      end if;
    end if;
  end process;

  prs_wdata_reg : process(pi_clock)
  begin
    if rising_edge(pi_clock) then
      if state_write  = ST_WRITE_IDLE or state_write = ST_WRITE_WAIT_DATA then
        wdata <= pi_s_top.wdata;
      end if;
    end if;
  end process prs_wdata_reg ;

  -- ===========================================================================
  -- OUTPUT
  -- ===========================================================================
  -- registers
  ------------------------------------------------------------------------------
  gen_reg_wr_str: for ridx in 0 to 7-1 generate
    po_reg_wr_stb(ridx) <= reg_wr_stb(ridx) and wvalid;
  end generate;
  po_reg_data   <= wdata;
  po_reg_rd_stb <= reg_rd_stb;
  rdata_reg     <= pi_reg_data ;
  -- ===========================================================================
  -- reg files
  ------------------------------------------------------------------------------
  gen_rf_wr_str: for ridx in 0 to 4-1 generate
    po_rgf_reg_wr_stb(ridx) <= regf_reg_wr_stb(ridx) and wvalid;
  end generate;
  po_rgf_reg_data   <= wdata;
  po_rgf_reg_rd_stb <= regf_reg_rd_stb;
  rdata_rgf         <= pi_rgf_reg_data ;

end architecture arch;
