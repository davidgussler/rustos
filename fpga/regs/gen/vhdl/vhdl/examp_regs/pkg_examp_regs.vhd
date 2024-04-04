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
--! @date 2021-10-01
--! @author Michael Büchler <michael.buechler@desy.de>
--! @author Lukasz Butkowski <lukasz.butkowski@desy.de>
------------------------------------------------------------------------------
--! @brief
--! VHDL package of DesyRDL for address space decoder for {node.orig_type_name}
------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library desyrdl;
use desyrdl.common.all;

-- library desy;
-- use desy.common_axi.all;

package pkg_examp_regs is

  -----------------------------------------------
  -- per addrmap / module
  -----------------------------------------------
  constant C_ADDR_WIDTH : integer := 6;
  constant C_DATA_WIDTH : integer := 32;

  -- ===========================================================================
  -- ---------------------------------------------------------------------------
  -- registers
  -- ---------------------------------------------------------------------------

  -- ===========================================================================
  -- REGISTERS interface
  -- ---------------------------------------------------------------------------
  -- register type: control
  -----------------------------------------------
  type t_field_signals_control_ctl0_in is record
    -- no data if field cannot be written from hw
    data : std_logic_vector(-1 downto 0); --
  end record;

  type t_field_signals_control_ctl0_out is record
    data : std_logic_vector(1-1 downto 0); --
  end record; --
  type t_field_signals_control_ctl1_in is record
    -- no data if field cannot be written from hw
    data : std_logic_vector(-1 downto 0); --
  end record;

  type t_field_signals_control_ctl1_out is record
    data : std_logic_vector(1-1 downto 0); --
  end record; --

  -- The actual register types
  type t_reg_control_in is record--
    ctl0 : t_field_signals_control_ctl0_in; --
    ctl1 : t_field_signals_control_ctl1_in; --
  end record;
  type t_reg_control_out is record--
    ctl0 : t_field_signals_control_ctl0_out; --
    ctl1 : t_field_signals_control_ctl1_out; --
  end record;
  type t_reg_control_2d_in is array (integer range <>) of t_reg_control_in;
  type t_reg_control_2d_out is array (integer range <>) of t_reg_control_out;
  type t_reg_control_3d_in is array (integer range <>, integer range <>) of t_reg_control_in;
  type t_reg_control_3d_out is array (integer range <>, integer range <>) of t_reg_control_out;
  -----------------------------------------------
  -- register type: status
  -----------------------------------------------
  type t_field_signals_status_sts0_in is record
    data : std_logic_vector(1-1 downto 0); --
  end record;

  type t_field_signals_status_sts0_out is record
    -- no data if field cannot be written from hw
    data : std_logic_vector(-1 downto 0); --
  end record; --
  type t_field_signals_status_sts1_in is record
    data : std_logic_vector(1-1 downto 0); --
  end record;

  type t_field_signals_status_sts1_out is record
    -- no data if field cannot be written from hw
    data : std_logic_vector(-1 downto 0); --
  end record; --

  -- The actual register types
  type t_reg_status_in is record--
    sts0 : t_field_signals_status_sts0_in; --
    sts1 : t_field_signals_status_sts1_in; --
  end record;
  type t_reg_status_out is record--
    sts0 : t_field_signals_status_sts0_out; --
    sts1 : t_field_signals_status_sts1_out; --
  end record;
  type t_reg_status_2d_in is array (integer range <>) of t_reg_status_in;
  type t_reg_status_2d_out is array (integer range <>) of t_reg_status_out;
  type t_reg_status_3d_in is array (integer range <>, integer range <>) of t_reg_status_in;
  type t_reg_status_3d_out is array (integer range <>, integer range <>) of t_reg_status_out;
  -----------------------------------------------
  -- register type: hwrw
  -----------------------------------------------
  type t_field_signals_hwrw_data_in is record
    data : std_logic_vector(32-1 downto 0); --
    we   : std_logic; --
  end record;

  type t_field_signals_hwrw_data_out is record
    data : std_logic_vector(32-1 downto 0); --
    swacc : std_logic; --
    swmod : std_logic; --
  end record; --

  -- The actual register types
  type t_reg_hwrw_in is record--
    data : t_field_signals_hwrw_data_in; --
  end record;
  type t_reg_hwrw_out is record--
    data : t_field_signals_hwrw_data_out; --
  end record;
  type t_reg_hwrw_2d_in is array (integer range <>) of t_reg_hwrw_in;
  type t_reg_hwrw_2d_out is array (integer range <>) of t_reg_hwrw_out;
  type t_reg_hwrw_3d_in is array (integer range <>, integer range <>) of t_reg_hwrw_in;
  type t_reg_hwrw_3d_out is array (integer range <>, integer range <>) of t_reg_hwrw_out;
  -----------------------------------------------
  -- register type: wr_pulse
  -----------------------------------------------
  type t_field_signals_wr_pulse_data_in is record
    -- no data if field cannot be written from hw
    data : std_logic_vector(-1 downto 0); --
  end record;

  type t_field_signals_wr_pulse_data_out is record
    data : std_logic_vector(1-1 downto 0); --
    swmod : std_logic; --
  end record; --

  -- The actual register types
  type t_reg_wr_pulse_in is record--
    data : t_field_signals_wr_pulse_data_in; --
  end record;
  type t_reg_wr_pulse_out is record--
    data : t_field_signals_wr_pulse_data_out; --
  end record;
  type t_reg_wr_pulse_2d_in is array (integer range <>) of t_reg_wr_pulse_in;
  type t_reg_wr_pulse_2d_out is array (integer range <>) of t_reg_wr_pulse_out;
  type t_reg_wr_pulse_3d_in is array (integer range <>, integer range <>) of t_reg_wr_pulse_in;
  type t_reg_wr_pulse_3d_out is array (integer range <>, integer range <>) of t_reg_wr_pulse_out;
  -----------------------------------------------
  -- register type: cntr
  -----------------------------------------------
  type t_field_signals_cntr_cnt_in is record
    -- no data if field cannot be written from hw
    data : std_logic_vector(-1 downto 0); --
    incr : std_logic; --
  end record;

  type t_field_signals_cntr_cnt_out is record
    -- no data if field cannot be written from hw
    data : std_logic_vector(-1 downto 0); --
  end record; --

  -- The actual register types
  type t_reg_cntr_in is record--
    cnt : t_field_signals_cntr_cnt_in; --
  end record;
  type t_reg_cntr_out is record--
    cnt : t_field_signals_cntr_cnt_out; --
  end record;
  type t_reg_cntr_2d_in is array (integer range <>) of t_reg_cntr_in;
  type t_reg_cntr_2d_out is array (integer range <>) of t_reg_cntr_out;
  type t_reg_cntr_3d_in is array (integer range <>, integer range <>) of t_reg_cntr_in;
  type t_reg_cntr_3d_out is array (integer range <>, integer range <>) of t_reg_cntr_out;
  -----------------------------------------------

  ------------------------------------------------------------------------------
  -- Register types in regfiles --
  --
  -- register type: scratchpad
  -----------------------------------------------
  type t_field_signals_common_regfile_scratchpad_scratchpad_in is record
    -- no data if field cannot be written from hw
    data : std_logic_vector(-1 downto 0); --
  end record;

  type t_field_signals_common_regfile_scratchpad_scratchpad_out is record
    -- no data if field cannot be written from hw
    data : std_logic_vector(-1 downto 0); --
  end record; --

  -- The actual register types
  type t_reg_common_regfile_scratchpad_in is record--
    scratchpad : t_field_signals_common_regfile_scratchpad_scratchpad_in; --
  end record;
  type t_reg_common_regfile_scratchpad_out is record--
    scratchpad : t_field_signals_common_regfile_scratchpad_scratchpad_out; --
  end record;
  type t_reg_common_regfile_scratchpad_2d_in is array (integer range <>) of t_reg_common_regfile_scratchpad_in;
  type t_reg_common_regfile_scratchpad_2d_out is array (integer range <>) of t_reg_common_regfile_scratchpad_out;
  type t_reg_common_regfile_scratchpad_3d_in is array (integer range <>, integer range <>) of t_reg_common_regfile_scratchpad_in;
  type t_reg_common_regfile_scratchpad_3d_out is array (integer range <>, integer range <>) of t_reg_common_regfile_scratchpad_out;
  -----------------------------------------------
  -- register type: id
  -----------------------------------------------
  type t_field_signals_common_regfile_id_id_in is record
    data : std_logic_vector(32-1 downto 0); --
  end record;

  type t_field_signals_common_regfile_id_id_out is record
    -- no data if field cannot be written from hw
    data : std_logic_vector(-1 downto 0); --
  end record; --

  -- The actual register types
  type t_reg_common_regfile_id_in is record--
    id : t_field_signals_common_regfile_id_id_in; --
  end record;
  type t_reg_common_regfile_id_out is record--
    id : t_field_signals_common_regfile_id_id_out; --
  end record;
  type t_reg_common_regfile_id_2d_in is array (integer range <>) of t_reg_common_regfile_id_in;
  type t_reg_common_regfile_id_2d_out is array (integer range <>) of t_reg_common_regfile_id_out;
  type t_reg_common_regfile_id_3d_in is array (integer range <>, integer range <>) of t_reg_common_regfile_id_in;
  type t_reg_common_regfile_id_3d_out is array (integer range <>, integer range <>) of t_reg_common_regfile_id_out;
  -----------------------------------------------
  -- register type: version
  -----------------------------------------------
  type t_field_signals_common_regfile_version_patch_in is record
    data : std_logic_vector(8-1 downto 0); --
  end record;

  type t_field_signals_common_regfile_version_patch_out is record
    -- no data if field cannot be written from hw
    data : std_logic_vector(-1 downto 0); --
  end record; --
  type t_field_signals_common_regfile_version_minor_in is record
    data : std_logic_vector(8-1 downto 0); --
  end record;

  type t_field_signals_common_regfile_version_minor_out is record
    -- no data if field cannot be written from hw
    data : std_logic_vector(-1 downto 0); --
  end record; --
  type t_field_signals_common_regfile_version_major_in is record
    data : std_logic_vector(8-1 downto 0); --
  end record;

  type t_field_signals_common_regfile_version_major_out is record
    -- no data if field cannot be written from hw
    data : std_logic_vector(-1 downto 0); --
  end record; --

  -- The actual register types
  type t_reg_common_regfile_version_in is record--
    patch : t_field_signals_common_regfile_version_patch_in; --
    minor : t_field_signals_common_regfile_version_minor_in; --
    major : t_field_signals_common_regfile_version_major_in; --
  end record;
  type t_reg_common_regfile_version_out is record--
    patch : t_field_signals_common_regfile_version_patch_out; --
    minor : t_field_signals_common_regfile_version_minor_out; --
    major : t_field_signals_common_regfile_version_major_out; --
  end record;
  type t_reg_common_regfile_version_2d_in is array (integer range <>) of t_reg_common_regfile_version_in;
  type t_reg_common_regfile_version_2d_out is array (integer range <>) of t_reg_common_regfile_version_out;
  type t_reg_common_regfile_version_3d_in is array (integer range <>, integer range <>) of t_reg_common_regfile_version_in;
  type t_reg_common_regfile_version_3d_out is array (integer range <>, integer range <>) of t_reg_common_regfile_version_out;
  -----------------------------------------------
  -- register type: git
  -----------------------------------------------
  type t_field_signals_common_regfile_git_git_in is record
    data : std_logic_vector(32-1 downto 0); --
  end record;

  type t_field_signals_common_regfile_git_git_out is record
    -- no data if field cannot be written from hw
    data : std_logic_vector(-1 downto 0); --
  end record; --

  -- The actual register types
  type t_reg_common_regfile_git_in is record--
    git : t_field_signals_common_regfile_git_git_in; --
  end record;
  type t_reg_common_regfile_git_out is record--
    git : t_field_signals_common_regfile_git_git_out; --
  end record;
  type t_reg_common_regfile_git_2d_in is array (integer range <>) of t_reg_common_regfile_git_in;
  type t_reg_common_regfile_git_2d_out is array (integer range <>) of t_reg_common_regfile_git_out;
  type t_reg_common_regfile_git_3d_in is array (integer range <>, integer range <>) of t_reg_common_regfile_git_in;
  type t_reg_common_regfile_git_3d_out is array (integer range <>, integer range <>) of t_reg_common_regfile_git_out;
  -----------------------------------------------

  -- ===========================================================================
  -- REGFILE interface
  -- -----------------------------------------------------------------------------
  type t_rgf_common_regfile_in is record --
    scratchpad : t_reg_common_regfile_scratchpad_in; --
    id : t_reg_common_regfile_id_in; --
    version : t_reg_common_regfile_version_in; --
    git : t_reg_common_regfile_git_in; --
  end record;
  type t_rgf_common_regfile_out is record --
    scratchpad : t_reg_common_regfile_scratchpad_out; --
    id : t_reg_common_regfile_id_out; --
    version : t_reg_common_regfile_version_out; --
    git : t_reg_common_regfile_git_out; --
  end record;
  type t_rgf_common_regfile_2d_in is array (integer range <>) of t_rgf_common_regfile_in;
  type t_rgf_common_regfile_2d_out is array (integer range <>) of t_rgf_common_regfile_out;
  ------------------------------

  -- ===========================================================================
  -- MEMORIES interface
  -- ---------------------------------------------------------------------------

  -- ===========================================================================
  -- examp_regs : Top module address map interface
  -- ---------------------------------------------------------------------------
  type t_addrmap_examp_regs_in is record
    --
    control : t_reg_control_in; --
    status : t_reg_status_in; --
    hwrw : t_reg_hwrw_in; --
    wr_pulse : t_reg_wr_pulse_2d_in(0 to 2-1); --
    cntr : t_reg_cntr_2d_in(0 to 2-1); --
    --
    common : t_rgf_common_regfile_in; --
    --
    --
  end record;

  type t_addrmap_examp_regs_out is record
    --
    control : t_reg_control_out; --
    status : t_reg_status_out; --
    hwrw : t_reg_hwrw_out; --
    wr_pulse : t_reg_wr_pulse_2d_out(0 to 2-1); --
    cntr : t_reg_cntr_2d_out(0 to 2-1); --
    --
    common : t_rgf_common_regfile_out; --
    --
    --
  end record;

  -- ===========================================================================
  -- top level component declaration
  -- must come after defining the interfaces
  -- ---------------------------------------------------------------------------
  subtype t_examp_regs_m2s is t_axi4l_m2s;
  subtype t_examp_regs_s2m is t_axi4l_s2m;

  component examp_regs is
      port (
        pi_clock : in std_logic;
        pi_reset : in std_logic;
        -- TOP subordinate memory mapped interface
        pi_s_top  : in  t_examp_regs_m2s;
        po_s_top  : out t_examp_regs_s2m;
        -- to logic interface
        pi_addrmap : in  t_addrmap_examp_regs_in;
        po_addrmap : out t_addrmap_examp_regs_out
      );
  end component examp_regs;

end package pkg_examp_regs;
--------------------------------------------------------------------------------
package body pkg_examp_regs is
end package body;

--==============================================================================


--------------------------------------------------------------------------------
-- Register types directly in addmap
--------------------------------------------------------------------------------
--
-- register type: control
-----------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.pkg_examp_regs.all;

entity examp_regs_control is
  port (
    pi_clock        : in  std_logic;
    pi_reset        : in  std_logic;
    -- to/from adapter
    pi_decoder_rd_stb : in  std_logic;
    pi_decoder_wr_stb : in  std_logic;
    pi_decoder_data   : in  std_logic_vector(C_DATA_WIDTH-1 downto 0);
    po_decoder_data   : out std_logic_vector(C_DATA_WIDTH-1 downto 0);

    pi_reg  : in t_reg_control_in ;
    po_reg  : out t_reg_control_out
  );
end entity examp_regs_control;

architecture rtl of examp_regs_control is
  signal data_out : std_logic_vector(C_DATA_WIDTH-1 downto 0) := (others => '0');
begin
  --
  data_out(C_DATA_WIDTH-1 downto 2) <= (others => '0'); --

  -- resize field data out to the register bus width
  -- do only if 1 field and signed--
  po_decoder_data <= data_out; --

  ------------------------------------------------------------STORAGE
  ctl0_storage: block
    signal l_field_reg   : std_logic_vector(1-1 downto 0) :=
                           std_logic_vector(to_signed(1,1));
  begin
    prs_write : process(pi_clock)
    begin
      if rising_edge(pi_clock) then
        if pi_reset = '1' then
          l_field_reg <= std_logic_vector(to_signed(1,1));
        else
          -- HW --
          -- SW -- TODO: handle software access side effects (rcl/rset, woclr/woset, swacc/swmod)
          if pi_decoder_wr_stb = '1' then
            l_field_reg <= pi_decoder_data(0 downto 0);
          end if;
        end if;
      end if;
    end process;
    --
    po_reg.ctl0.data <= l_field_reg; --
    data_out(0 downto 0) <= l_field_reg;

  end block ctl0_storage;
  ------------------------------------------------------------STORAGE
  ctl1_storage: block
    signal l_field_reg   : std_logic_vector(1-1 downto 0) :=
                           std_logic_vector(to_signed(1,1));
  begin
    prs_write : process(pi_clock)
    begin
      if rising_edge(pi_clock) then
        if pi_reset = '1' then
          l_field_reg <= std_logic_vector(to_signed(1,1));
        else
          -- HW --
          -- SW -- TODO: handle software access side effects (rcl/rset, woclr/woset, swacc/swmod)
          if pi_decoder_wr_stb = '1' then
            l_field_reg <= pi_decoder_data(1 downto 1);
          end if;
        end if;
      end if;
    end process;
    --
    po_reg.ctl1.data <= l_field_reg; --
    data_out(1 downto 1) <= l_field_reg;

  end block ctl1_storage;
  ----------------------------------------------------------
end rtl;
-----------------------------------------------
-- register type: status
-----------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.pkg_examp_regs.all;

entity examp_regs_status is
  port (
    pi_clock        : in  std_logic;
    pi_reset        : in  std_logic;
    -- to/from adapter
    pi_decoder_rd_stb : in  std_logic;
    pi_decoder_wr_stb : in  std_logic;
    pi_decoder_data   : in  std_logic_vector(C_DATA_WIDTH-1 downto 0);
    po_decoder_data   : out std_logic_vector(C_DATA_WIDTH-1 downto 0);

    pi_reg  : in t_reg_status_in ;
    po_reg  : out t_reg_status_out
  );
end entity examp_regs_status;

architecture rtl of examp_regs_status is
  signal data_out : std_logic_vector(C_DATA_WIDTH-1 downto 0) := (others => '0');
begin
  --
  data_out(C_DATA_WIDTH-1 downto 2) <= (others => '0'); --

  -- resize field data out to the register bus width
  -- do only if 1 field and signed--
  po_decoder_data <= data_out; --

  ------------------------------------------------------------WIRE
  sts0_wire : block--
  begin
    --
    data_out(0 downto 0) <= pi_reg.sts0.data(1-1 downto 0); --
    --no signal to read by HW
    po_reg.sts0.data <= (others => '0'); --
  end block; ----WIRE
  sts1_wire : block--
  begin
    --
    data_out(1 downto 1) <= pi_reg.sts1.data(1-1 downto 0); --
    --no signal to read by HW
    po_reg.sts1.data <= (others => '0'); --
  end block; --
end rtl;
-----------------------------------------------
-- register type: hwrw
-----------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.pkg_examp_regs.all;

entity examp_regs_hwrw is
  port (
    pi_clock        : in  std_logic;
    pi_reset        : in  std_logic;
    -- to/from adapter
    pi_decoder_rd_stb : in  std_logic;
    pi_decoder_wr_stb : in  std_logic;
    pi_decoder_data   : in  std_logic_vector(C_DATA_WIDTH-1 downto 0);
    po_decoder_data   : out std_logic_vector(C_DATA_WIDTH-1 downto 0);

    pi_reg  : in t_reg_hwrw_in ;
    po_reg  : out t_reg_hwrw_out
  );
end entity examp_regs_hwrw;

architecture rtl of examp_regs_hwrw is
  signal data_out : std_logic_vector(C_DATA_WIDTH-1 downto 0) := (others => '0');
begin
  --

  -- resize field data out to the register bus width
  -- do only if 1 field and signed--
  po_decoder_data <= data_out; --

  ------------------------------------------------------------STORAGE
  data_storage: block
    signal l_field_reg   : std_logic_vector(32-1 downto 0) :=
                           std_logic_vector(to_signed(10,32));
    signal l_sw_wr_stb_q : std_logic;
    signal l_sw_rd_stb_q : std_logic;
  begin
    prs_write : process(pi_clock)
    begin
      if rising_edge(pi_clock) then
        if pi_reset = '1' then
          l_field_reg <= std_logic_vector(to_signed(10,32));
          l_sw_wr_stb_q <= '0';
          l_sw_rd_stb_q <= '0';
        else
          -- HW --
          if pi_reg.data.we = '1' then
            l_field_reg <= pi_reg.data.data;
          end if;
          -- SW -- TODO: handle software access side effects (rcl/rset, woclr/woset, swacc/swmod)
          if pi_decoder_wr_stb = '1' then
            l_field_reg <= pi_decoder_data(31 downto 0);
          end if;
          l_sw_wr_stb_q <= pi_decoder_wr_stb;
          l_sw_rd_stb_q <= pi_decoder_rd_stb;
        end if;
      end if;
    end process;
    --
    po_reg.data.data <= l_field_reg; --
    po_reg.data.swacc <= (not l_sw_wr_stb_q and pi_decoder_wr_stb) or (not l_sw_rd_stb_q and pi_decoder_rd_stb ) when rising_edge(pi_clock);
    po_reg.data.swmod <= (not l_sw_wr_stb_q and pi_decoder_wr_stb) when rising_edge(pi_clock);
    data_out(31 downto 0) <= l_field_reg;

  end block data_storage;
  ----------------------------------------------------------
end rtl;
-----------------------------------------------
-- register type: wr_pulse
-----------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.pkg_examp_regs.all;

entity examp_regs_wr_pulse is
  port (
    pi_clock        : in  std_logic;
    pi_reset        : in  std_logic;
    -- to/from adapter
    pi_decoder_rd_stb : in  std_logic;
    pi_decoder_wr_stb : in  std_logic;
    pi_decoder_data   : in  std_logic_vector(C_DATA_WIDTH-1 downto 0);
    po_decoder_data   : out std_logic_vector(C_DATA_WIDTH-1 downto 0);

    pi_reg  : in t_reg_wr_pulse_in ;
    po_reg  : out t_reg_wr_pulse_out
  );
end entity examp_regs_wr_pulse;

architecture rtl of examp_regs_wr_pulse is
  signal data_out : std_logic_vector(C_DATA_WIDTH-1 downto 0) := (others => '0');
begin
  --
  data_out(C_DATA_WIDTH-1 downto 1) <= (others => '0'); --

  -- resize field data out to the register bus width
  -- do only if 1 field and signed--
  po_decoder_data <= data_out; --

  ------------------------------------------------------------STORAGE
  data_storage: block
    signal l_field_reg   : std_logic_vector(1-1 downto 0) :=
                           std_logic_vector(to_signed(0,1));
    signal l_sw_wr_stb_q : std_logic;
  begin
    prs_write : process(pi_clock)
    begin
      if rising_edge(pi_clock) then
        if pi_reset = '1' then
          l_field_reg <= std_logic_vector(to_signed(0,1));
          l_sw_wr_stb_q <= '0';
        else
          -- HW --
          -- SW -- TODO: handle software access side effects (rcl/rset, woclr/woset, swacc/swmod)
          if pi_decoder_wr_stb = '1' then
            l_field_reg <= pi_decoder_data(0 downto 0);
          end if;
          l_sw_wr_stb_q <= pi_decoder_wr_stb;
        end if;
      end if;
    end process;
    --
    po_reg.data.data <= l_field_reg; --
    po_reg.data.swmod <= (not l_sw_wr_stb_q and pi_decoder_wr_stb) when rising_edge(pi_clock);
    data_out(0 downto 0) <= l_field_reg;

  end block data_storage;
  ----------------------------------------------------------
end rtl;
-----------------------------------------------
-- register type: cntr
-----------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.pkg_examp_regs.all;

entity examp_regs_cntr is
  port (
    pi_clock        : in  std_logic;
    pi_reset        : in  std_logic;
    -- to/from adapter
    pi_decoder_rd_stb : in  std_logic;
    pi_decoder_wr_stb : in  std_logic;
    pi_decoder_data   : in  std_logic_vector(C_DATA_WIDTH-1 downto 0);
    po_decoder_data   : out std_logic_vector(C_DATA_WIDTH-1 downto 0);

    pi_reg  : in t_reg_cntr_in ;
    po_reg  : out t_reg_cntr_out
  );
end entity examp_regs_cntr;

architecture rtl of examp_regs_cntr is
  signal data_out : std_logic_vector(C_DATA_WIDTH-1 downto 0) := (others => '0');
begin
  --
  data_out(C_DATA_WIDTH-1 downto 16) <= (others => '0'); --

  -- resize field data out to the register bus width
  -- do only if 1 field and signed--
  po_decoder_data <= data_out; --

  ------------------------------------------------------------STORAGE
  cnt_storage: block
    signal l_field_reg   : std_logic_vector(16-1 downto 0) :=
                           std_logic_vector(to_signed(0,16));
    signal l_incrvalue   : natural;
  begin
    prs_write : process(pi_clock)
    begin
      if rising_edge(pi_clock) then
        if pi_reset = '1' then
          l_field_reg <= std_logic_vector(to_signed(0,16));
        else
          -- HW --
          -- counter
          if  pi_reg.cnt.incr = '1' then
            l_field_reg <= std_logic_vector(unsigned(l_field_reg) + to_unsigned(l_incrvalue, 16));
          end if;
          -- SW -- TODO: handle software access side effects (rcl/rset, woclr/woset, swacc/swmod)
        end if;
      end if;
    end process;
    --no signal to read by HW
    po_reg.cnt.data <= (others => '0'); --
    data_out(15 downto 0) <= l_field_reg;

    l_incrvalue <= 1;
  end block cnt_storage;
  ----------------------------------------------------------
end rtl;
-----------------------------------------------

--------------------------------------------------------------------------------
-- Register types in regfiles
--------------------------------------------------------------------------------
--
--
-- register type: scratchpad
-----------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.pkg_examp_regs.all;

entity examp_regs_common_regfile_scratchpad is
  port (
    pi_clock        : in  std_logic;
    pi_reset        : in  std_logic;
    -- to/from adapter
    pi_decoder_rd_stb : in  std_logic;
    pi_decoder_wr_stb : in  std_logic;
    pi_decoder_data   : in  std_logic_vector(C_DATA_WIDTH-1 downto 0);
    po_decoder_data   : out std_logic_vector(C_DATA_WIDTH-1 downto 0);

    pi_reg  : in t_reg_common_regfile_scratchpad_in ;
    po_reg  : out t_reg_common_regfile_scratchpad_out
  );
end entity examp_regs_common_regfile_scratchpad;

architecture rtl of examp_regs_common_regfile_scratchpad is
  signal data_out : std_logic_vector(C_DATA_WIDTH-1 downto 0) := (others => '0');
begin
  --

  -- resize field data out to the register bus width
  -- do only if 1 field and signed--
  po_decoder_data <= data_out; --

  ------------------------------------------------------------STORAGE
  scratchpad_storage: block
    signal l_field_reg   : std_logic_vector(32-1 downto 0) :=
                           std_logic_vector(to_signed(305419896,32));
  begin
    prs_write : process(pi_clock)
    begin
      if rising_edge(pi_clock) then
        if pi_reset = '1' then
          l_field_reg <= std_logic_vector(to_signed(305419896,32));
        else
          -- HW --
          -- SW -- TODO: handle software access side effects (rcl/rset, woclr/woset, swacc/swmod)
          if pi_decoder_wr_stb = '1' then
            l_field_reg <= pi_decoder_data(31 downto 0);
          end if;
        end if;
      end if;
    end process;
    --no signal to read by HW
    po_reg.scratchpad.data <= (others => '0'); --
    data_out(31 downto 0) <= l_field_reg;

  end block scratchpad_storage;
  ----------------------------------------------------------
end rtl;
-----------------------------------------------
-- register type: id
-----------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.pkg_examp_regs.all;

entity examp_regs_common_regfile_id is
  port (
    pi_clock        : in  std_logic;
    pi_reset        : in  std_logic;
    -- to/from adapter
    pi_decoder_rd_stb : in  std_logic;
    pi_decoder_wr_stb : in  std_logic;
    pi_decoder_data   : in  std_logic_vector(C_DATA_WIDTH-1 downto 0);
    po_decoder_data   : out std_logic_vector(C_DATA_WIDTH-1 downto 0);

    pi_reg  : in t_reg_common_regfile_id_in ;
    po_reg  : out t_reg_common_regfile_id_out
  );
end entity examp_regs_common_regfile_id;

architecture rtl of examp_regs_common_regfile_id is
  signal data_out : std_logic_vector(C_DATA_WIDTH-1 downto 0) := (others => '0');
begin
  --

  -- resize field data out to the register bus width
  -- do only if 1 field and signed--
  po_decoder_data <= data_out; --

  ------------------------------------------------------------WIRE
  id_wire : block--
  begin
    --
    data_out(31 downto 0) <= pi_reg.id.data(32-1 downto 0); --
    --no signal to read by HW
    po_reg.id.data <= (others => '0'); --
  end block; --
end rtl;
-----------------------------------------------
-- register type: version
-----------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.pkg_examp_regs.all;

entity examp_regs_common_regfile_version is
  port (
    pi_clock        : in  std_logic;
    pi_reset        : in  std_logic;
    -- to/from adapter
    pi_decoder_rd_stb : in  std_logic;
    pi_decoder_wr_stb : in  std_logic;
    pi_decoder_data   : in  std_logic_vector(C_DATA_WIDTH-1 downto 0);
    po_decoder_data   : out std_logic_vector(C_DATA_WIDTH-1 downto 0);

    pi_reg  : in t_reg_common_regfile_version_in ;
    po_reg  : out t_reg_common_regfile_version_out
  );
end entity examp_regs_common_regfile_version;

architecture rtl of examp_regs_common_regfile_version is
  signal data_out : std_logic_vector(C_DATA_WIDTH-1 downto 0) := (others => '0');
begin
  --
  data_out(C_DATA_WIDTH-1 downto 24) <= (others => '0'); --

  -- resize field data out to the register bus width
  -- do only if 1 field and signed--
  po_decoder_data <= data_out; --

  ------------------------------------------------------------WIRE
  patch_wire : block--
  begin
    --
    data_out(7 downto 0) <= pi_reg.patch.data(8-1 downto 0); --
    --no signal to read by HW
    po_reg.patch.data <= (others => '0'); --
  end block; ----WIRE
  minor_wire : block--
  begin
    --
    data_out(15 downto 8) <= pi_reg.minor.data(8-1 downto 0); --
    --no signal to read by HW
    po_reg.minor.data <= (others => '0'); --
  end block; ----WIRE
  major_wire : block--
  begin
    --
    data_out(23 downto 16) <= pi_reg.major.data(8-1 downto 0); --
    --no signal to read by HW
    po_reg.major.data <= (others => '0'); --
  end block; --
end rtl;
-----------------------------------------------
-- register type: git
-----------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.pkg_examp_regs.all;

entity examp_regs_common_regfile_git is
  port (
    pi_clock        : in  std_logic;
    pi_reset        : in  std_logic;
    -- to/from adapter
    pi_decoder_rd_stb : in  std_logic;
    pi_decoder_wr_stb : in  std_logic;
    pi_decoder_data   : in  std_logic_vector(C_DATA_WIDTH-1 downto 0);
    po_decoder_data   : out std_logic_vector(C_DATA_WIDTH-1 downto 0);

    pi_reg  : in t_reg_common_regfile_git_in ;
    po_reg  : out t_reg_common_regfile_git_out
  );
end entity examp_regs_common_regfile_git;

architecture rtl of examp_regs_common_regfile_git is
  signal data_out : std_logic_vector(C_DATA_WIDTH-1 downto 0) := (others => '0');
begin
  --

  -- resize field data out to the register bus width
  -- do only if 1 field and signed--
  po_decoder_data <= data_out; --

  ------------------------------------------------------------WIRE
  git_wire : block--
  begin
    --
    data_out(31 downto 0) <= pi_reg.git.data(32-1 downto 0); --
    --no signal to read by HW
    po_reg.git.data <= (others => '0'); --
  end block; --
end rtl;
-----------------------------------------------