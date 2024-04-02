------------------------------------------------------------------------------
--          ____  _____________  __                                         --
--         / __ \/ ____/ ___/\ \/ /                 _   _   _               --
--        / / / / __/  \__ \  \  /                 / \ / \ / \              --
--       / /_/ / /___ ___/ /  / /               = ( M | S | K )=            --
--      /_____/_____//____/  /_/                   \_/ \_/ \_/              --
--                                                                          --
------------------------------------------------------------------------------
--! @copyright Copyright 2021-2022 DESY
--! SPDX-License-Identifier: Apache-2.0
------------------------------------------------------------------------------
--! @date 2021-04-07
--! @author Michael Büchler <michael.buechler@desy.de>
--! @author Lukasz Butkowski <lukasz.butkowski@desy.de>
------------------------------------------------------------------------------
--! @brief
--! Top component of DesyRDL address space decoder for {node.type_name}
------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library desyrdl;
use desyrdl.common.all;

use work.pkg_examp_regs.all;

entity examp_regs is
  port (
    pi_clock : in std_logic;
    pi_reset : in std_logic;
    -- TOP subordinate memory mapped interface
    pi_s_reset : in std_logic := '0';
    pi_s_top   : in  t_examp_regs_m2s;
    po_s_top   : out t_examp_regs_s2m;
    -- to logic interface
    pi_addrmap : in  t_addrmap_examp_regs_in;
    po_addrmap : out t_addrmap_examp_regs_out
  );
end entity examp_regs;

architecture arch of examp_regs is

  type t_data_out is array (natural range<>) of std_logic_vector(C_DATA_WIDTH-1 downto 0) ;

  --
  signal reg_data_out_vect : t_data_out(7-1 downto 0);
  signal reg_rd_stb   : std_logic_vector(7-1 downto 0);
  signal reg_wr_stb   : std_logic_vector(7-1 downto 0);
  signal reg_data_in  : std_logic_vector(C_DATA_WIDTH-1 downto 0);
  signal reg_data_out : std_logic_vector(C_DATA_WIDTH-1 downto 0) := (others => '0');
  --
  signal rgf_reg_data_out_vect : t_data_out(4-1 downto 0);
  signal rgf_reg_rd_stb   : std_logic_vector(4-1 downto 0);
  signal rgf_reg_wr_stb   : std_logic_vector(4-1 downto 0);
  signal rgf_reg_data_in  : std_logic_vector(C_DATA_WIDTH-1 downto 0);
  signal rgf_reg_data_out : std_logic_vector(C_DATA_WIDTH-1 downto 0) := (others => '0');
  --

begin

  ins_decoder_axi4l : entity work.examp_regs_decoder_axi4l
  generic map (
    g_addr_width    => C_ADDR_WIDTH,
    g_data_width    => C_DATA_WIDTH
  )
  port map (
    pi_clock      => pi_clock,
    pi_reset      => pi_reset,

    --
    po_reg_rd_stb => reg_rd_stb,
    po_reg_wr_stb => reg_wr_stb,
    po_reg_data   => reg_data_in,
    pi_reg_data   => reg_data_out,
    --
    --
    po_rgf_reg_rd_stb  => rgf_reg_rd_stb,
    po_rgf_reg_wr_stb  => rgf_reg_wr_stb,
    po_rgf_reg_data    => rgf_reg_data_in,
    pi_rgf_reg_data    => rgf_reg_data_out,
    --
    --
    --
    pi_s_reset  => pi_s_reset,
    pi_s_top    => pi_s_top,
    po_s_top    => po_s_top
  );
  --
  prs_reg_rd_mux: process(pi_clock)
  begin
    if rising_edge(pi_clock) then
      for idx in 0 to 7-1 loop
        if reg_rd_stb(idx) = '1' then
          reg_data_out <= reg_data_out_vect(idx);
        end if;
      end loop;
    end if;
  end process prs_reg_rd_mux;
  --
  --
  prs_rgf_reg_rd_mux: process(pi_clock)
  begin
    if rising_edge(pi_clock) then
      for idx in 0 to 4-1 loop
        if rgf_reg_rd_stb(idx) = '1' then
          rgf_reg_data_out <= rgf_reg_data_out_vect(idx);
        end if;
      end loop;
    end if;
  end process prs_rgf_reg_rd_mux;
  --
  --

  -- ===========================================================================
  -- generated registers instances
  -- ---------------------------------------------------------------------------
  -- reg name: control  reg type: control
  -- ---------------------------------------------------------------------------
  blk_control : block
  begin  --
    inst_control: entity work.examp_regs_control
      port map(
        pi_clock        => pi_clock,
        pi_reset        => pi_reset,
        -- to/from adapter
        pi_decoder_rd_stb => reg_rd_stb(0),
        pi_decoder_wr_stb => reg_wr_stb(0),
        pi_decoder_data   => reg_data_in,
        po_decoder_data   => reg_data_out_vect(0),

        pi_reg  => pi_addrmap.control,
        po_reg  => po_addrmap.control
      ); --
  end block; --
  -- ---------------------------------------------------------------------------
  -- reg name: status  reg type: status
  -- ---------------------------------------------------------------------------
  blk_status : block
  begin  --
    inst_status: entity work.examp_regs_status
      port map(
        pi_clock        => pi_clock,
        pi_reset        => pi_reset,
        -- to/from adapter
        pi_decoder_rd_stb => reg_rd_stb(1),
        pi_decoder_wr_stb => reg_wr_stb(1),
        pi_decoder_data   => reg_data_in,
        po_decoder_data   => reg_data_out_vect(1),

        pi_reg  => pi_addrmap.status,
        po_reg  => po_addrmap.status
      ); --
  end block; --
  -- ---------------------------------------------------------------------------
  -- reg name: hwrw  reg type: hwrw
  -- ---------------------------------------------------------------------------
  blk_hwrw : block
  begin  --
    inst_hwrw: entity work.examp_regs_hwrw
      port map(
        pi_clock        => pi_clock,
        pi_reset        => pi_reset,
        -- to/from adapter
        pi_decoder_rd_stb => reg_rd_stb(2),
        pi_decoder_wr_stb => reg_wr_stb(2),
        pi_decoder_data   => reg_data_in,
        po_decoder_data   => reg_data_out_vect(2),

        pi_reg  => pi_addrmap.hwrw,
        po_reg  => po_addrmap.hwrw
      ); --
  end block; --
  -- ---------------------------------------------------------------------------
  -- reg name: wr_pulse  reg type: wr_pulse
  -- ---------------------------------------------------------------------------
  blk_wr_pulse : block
  begin  --
    gen_m: for idx_m in 0 to 2-1 generate
      inst_wr_pulse: entity work.examp_regs_wr_pulse
        port map(
          pi_clock        => pi_clock,
          pi_reset        => pi_reset,
          -- to/from adapter
          pi_decoder_rd_stb => reg_rd_stb(3+idx_m),
          pi_decoder_wr_stb => reg_wr_stb(3+idx_m),
          pi_decoder_data   => reg_data_in,
          po_decoder_data   => reg_data_out_vect(3+idx_m),

          pi_reg  => pi_addrmap.wr_pulse(idx_m),
          po_reg  => po_addrmap.wr_pulse(idx_m)
        );
    end generate; --
  end block; --
  -- ---------------------------------------------------------------------------
  -- reg name: cntr  reg type: cntr
  -- ---------------------------------------------------------------------------
  blk_cntr : block
  begin  --
    gen_m: for idx_m in 0 to 2-1 generate
      inst_cntr: entity work.examp_regs_cntr
        port map(
          pi_clock        => pi_clock,
          pi_reset        => pi_reset,
          -- to/from adapter
          pi_decoder_rd_stb => reg_rd_stb(5+idx_m),
          pi_decoder_wr_stb => reg_wr_stb(5+idx_m),
          pi_decoder_data   => reg_data_in,
          po_decoder_data   => reg_data_out_vect(5+idx_m),

          pi_reg  => pi_addrmap.cntr(idx_m),
          po_reg  => po_addrmap.cntr(idx_m)
        );
    end generate; --
  end block; --

  -- ===========================================================================
  -- generated registers instances in regfiles 
  -- ---------------------------------------------------------------------------
  -- regfile instance name: common  reg file type: common_regfile
  -- ---------------------------------------------------------------------------
  blk_common : block
  begin--
    blk_scratchpad : block
    begin  --
      inst_scratchpad: entity work.examp_regs_common_regfile_scratchpad
        port map(
          pi_clock        => pi_clock,
          pi_reset        => pi_reset,
          -- to/from adapter
          pi_decoder_rd_stb => rgf_reg_rd_stb(0),
          pi_decoder_wr_stb => rgf_reg_wr_stb(0),
          pi_decoder_data   => rgf_reg_data_in,
          po_decoder_data   => rgf_reg_data_out_vect(0),

          pi_reg  => pi_addrmap.common.scratchpad,
          po_reg  => po_addrmap.common.scratchpad--
        ); --
    end block; --
    blk_id : block
    begin  --
      inst_id: entity work.examp_regs_common_regfile_id
        port map(
          pi_clock        => pi_clock,
          pi_reset        => pi_reset,
          -- to/from adapter
          pi_decoder_rd_stb => rgf_reg_rd_stb(1),
          pi_decoder_wr_stb => rgf_reg_wr_stb(1),
          pi_decoder_data   => rgf_reg_data_in,
          po_decoder_data   => rgf_reg_data_out_vect(1),

          pi_reg  => pi_addrmap.common.id,
          po_reg  => po_addrmap.common.id--
        ); --
    end block; --
    blk_version : block
    begin  --
      inst_version: entity work.examp_regs_common_regfile_version
        port map(
          pi_clock        => pi_clock,
          pi_reset        => pi_reset,
          -- to/from adapter
          pi_decoder_rd_stb => rgf_reg_rd_stb(2),
          pi_decoder_wr_stb => rgf_reg_wr_stb(2),
          pi_decoder_data   => rgf_reg_data_in,
          po_decoder_data   => rgf_reg_data_out_vect(2),

          pi_reg  => pi_addrmap.common.version,
          po_reg  => po_addrmap.common.version--
        ); --
    end block; --
    blk_git : block
    begin  --
      inst_git: entity work.examp_regs_common_regfile_git
        port map(
          pi_clock        => pi_clock,
          pi_reset        => pi_reset,
          -- to/from adapter
          pi_decoder_rd_stb => rgf_reg_rd_stb(3),
          pi_decoder_wr_stb => rgf_reg_wr_stb(3),
          pi_decoder_data   => rgf_reg_data_in,
          po_decoder_data   => rgf_reg_data_out_vect(3),

          pi_reg  => pi_addrmap.common.git,
          po_reg  => po_addrmap.common.git--
        ); --
    end block; --
    --
  end block;
  -- ---------------------------------------------------------------------------

  -- ===========================================================================
  -- Generated Meme Instances
  --
  -- ---------------------------------------------------------------------------

  -- ===========================================================================
  -- External Busses

end architecture;
