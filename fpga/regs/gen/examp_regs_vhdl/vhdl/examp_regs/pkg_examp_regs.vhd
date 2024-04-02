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
  constant C_ADDR_WIDTH : integer := 5;
  constant C_DATA_WIDTH : integer := 32;

  -- ===========================================================================
  -- ---------------------------------------------------------------------------
  -- registers
  -- ---------------------------------------------------------------------------

  -- ===========================================================================
  -- REGISTERS interface
  -- ---------------------------------------------------------------------------
  -- register type: scratchpad
  -----------------------------------------------
  type t_field_signals_scratchpad_scratchpad_in is record
    -- no data if field cannot be written from hw
    data : std_logic_vector(-1 downto 0); --
  end record;

  type t_field_signals_scratchpad_scratchpad_out is record
    data : std_logic_vector(32-1 downto 0); --
  end record; --

  -- The actual register types
  type t_reg_scratchpad_in is record--
    scratchpad : t_field_signals_scratchpad_scratchpad_in; --
  end record;
  type t_reg_scratchpad_out is record--
    scratchpad : t_field_signals_scratchpad_scratchpad_out; --
  end record;
  type t_reg_scratchpad_2d_in is array (integer range <>) of t_reg_scratchpad_in;
  type t_reg_scratchpad_2d_out is array (integer range <>) of t_reg_scratchpad_out;
  type t_reg_scratchpad_3d_in is array (integer range <>, integer range <>) of t_reg_scratchpad_in;
  type t_reg_scratchpad_3d_out is array (integer range <>, integer range <>) of t_reg_scratchpad_out;
  -----------------------------------------------
  -- register type: version
  -----------------------------------------------
  type t_field_signals_version_minor_in is record
    data : std_logic_vector(16-1 downto 0); --
  end record;

  type t_field_signals_version_minor_out is record
    -- no data if field cannot be written from hw
    data : std_logic_vector(-1 downto 0); --
  end record; --
  type t_field_signals_version_major_in is record
    data : std_logic_vector(16-1 downto 0); --
  end record;

  type t_field_signals_version_major_out is record
    -- no data if field cannot be written from hw
    data : std_logic_vector(-1 downto 0); --
  end record; --

  -- The actual register types
  type t_reg_version_in is record--
    minor : t_field_signals_version_minor_in; --
    major : t_field_signals_version_major_in; --
  end record;
  type t_reg_version_out is record--
    minor : t_field_signals_version_minor_out; --
    major : t_field_signals_version_major_out; --
  end record;
  type t_reg_version_2d_in is array (integer range <>) of t_reg_version_in;
  type t_reg_version_2d_out is array (integer range <>) of t_reg_version_out;
  type t_reg_version_3d_in is array (integer range <>, integer range <>) of t_reg_version_in;
  type t_reg_version_3d_out is array (integer range <>, integer range <>) of t_reg_version_out;
  -----------------------------------------------
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
  -- register type: mixed
  -----------------------------------------------
  type t_field_signals_mixed_counter_field_t_name_2674884d_in is record
    data : std_logic_vector(8-1 downto 0); --
    incr : std_logic; --
  end record;

  type t_field_signals_mixed_counter_field_t_name_2674884d_out is record
    data : std_logic_vector(8-1 downto 0); --
  end record; --
  type t_field_signals_mixed_event_flag_field_t_desc_d257f7c2_name_1a3888d4_in is record
    data : std_logic_vector(8-1 downto 0); --
    hwset: std_logic; --
  end record;

  type t_field_signals_mixed_event_flag_field_t_desc_d257f7c2_name_1a3888d4_out is record
    -- no data if field cannot be written from hw
    data : std_logic_vector(-1 downto 0); --
  end record; --

  -- The actual register types
  type t_reg_mixed_in is record--
    counter_field_t_name_2674884d : t_field_signals_mixed_counter_field_t_name_2674884d_in; --
    event_flag_field_t_desc_d257f7c2_name_1a3888d4 : t_field_signals_mixed_event_flag_field_t_desc_d257f7c2_name_1a3888d4_in; --
  end record;
  type t_reg_mixed_out is record--
    counter_field_t_name_2674884d : t_field_signals_mixed_counter_field_t_name_2674884d_out; --
    event_flag_field_t_desc_d257f7c2_name_1a3888d4 : t_field_signals_mixed_event_flag_field_t_desc_d257f7c2_name_1a3888d4_out; --
  end record;
  type t_reg_mixed_2d_in is array (integer range <>) of t_reg_mixed_in;
  type t_reg_mixed_2d_out is array (integer range <>) of t_reg_mixed_out;
  type t_reg_mixed_3d_in is array (integer range <>, integer range <>) of t_reg_mixed_in;
  type t_reg_mixed_3d_out is array (integer range <>, integer range <>) of t_reg_mixed_out;
  -----------------------------------------------

  ------------------------------------------------------------------------------
  -- Register types in regfiles --

  -- ===========================================================================
  -- REGFILE interface
  -- -----------------------------------------------------------------------------

  -- ===========================================================================
  -- MEMORIES interface
  -- ---------------------------------------------------------------------------

  -- ===========================================================================
  -- examp_regs : Top module address map interface
  -- ---------------------------------------------------------------------------
  type t_addrmap_examp_regs_in is record
    --
    scratchpad : t_reg_scratchpad_in; --
    version : t_reg_version_in; --
    control : t_reg_control_in; --
    status : t_reg_status_in; --
    mixed : t_reg_mixed_2d_in(0 to 4-1); --
    --
    --
    --
  end record;

  type t_addrmap_examp_regs_out is record
    --
    scratchpad : t_reg_scratchpad_out; --
    version : t_reg_version_out; --
    control : t_reg_control_out; --
    status : t_reg_status_out; --
    mixed : t_reg_mixed_2d_out(0 to 4-1); --
    --
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
-- register type: scratchpad
-----------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.pkg_examp_regs.all;

entity examp_regs_scratchpad is
  port (
    pi_clock        : in  std_logic;
    pi_reset        : in  std_logic;
    -- to/from adapter
    pi_decoder_rd_stb : in  std_logic;
    pi_decoder_wr_stb : in  std_logic;
    pi_decoder_data   : in  std_logic_vector(C_DATA_WIDTH-1 downto 0);
    po_decoder_data   : out std_logic_vector(C_DATA_WIDTH-1 downto 0);

    pi_reg  : in t_reg_scratchpad_in ;
    po_reg  : out t_reg_scratchpad_out
  );
end entity examp_regs_scratchpad;

architecture rtl of examp_regs_scratchpad is
  signal data_out : std_logic_vector(C_DATA_WIDTH-1 downto 0) := (others => '0');
begin
  --

  -- resize field data out to the register bus width
  -- do only if 1 field and signed--
  po_decoder_data <= data_out; --

  ------------------------------------------------------------STORAGE
  scratchpad_storage: block
    signal l_field_reg   : std_logic_vector(32-1 downto 0) :=
                           std_logic_vector(to_signed(0,32));
  begin
    prs_write : process(pi_clock)
    begin
      if rising_edge(pi_clock) then
        if pi_reset = '1' then
          l_field_reg <= std_logic_vector(to_signed(0,32));
        else
          -- HW --
          -- SW -- TODO: handle software access side effects (rcl/rset, woclr/woset, swacc/swmod)
          if pi_decoder_wr_stb = '1' then
            l_field_reg <= pi_decoder_data(31 downto 0);
          end if;
        end if;
      end if;
    end process;
    --
    po_reg.scratchpad.data <= l_field_reg; --
    data_out(31 downto 0) <= l_field_reg;

  end block scratchpad_storage;
  ----------------------------------------------------------
end rtl;
-----------------------------------------------
-- register type: version
-----------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.pkg_examp_regs.all;

entity examp_regs_version is
  port (
    pi_clock        : in  std_logic;
    pi_reset        : in  std_logic;
    -- to/from adapter
    pi_decoder_rd_stb : in  std_logic;
    pi_decoder_wr_stb : in  std_logic;
    pi_decoder_data   : in  std_logic_vector(C_DATA_WIDTH-1 downto 0);
    po_decoder_data   : out std_logic_vector(C_DATA_WIDTH-1 downto 0);

    pi_reg  : in t_reg_version_in ;
    po_reg  : out t_reg_version_out
  );
end entity examp_regs_version;

architecture rtl of examp_regs_version is
  signal data_out : std_logic_vector(C_DATA_WIDTH-1 downto 0) := (others => '0');
begin
  --

  -- resize field data out to the register bus width
  -- do only if 1 field and signed--
  po_decoder_data <= data_out; --

  ------------------------------------------------------------WIRE
  minor_wire : block--
  begin
    --
    data_out(15 downto 0) <= pi_reg.minor.data(16-1 downto 0); --
    --no signal to read by HW
    po_reg.minor.data <= (others => '0'); --
  end block; ----WIRE
  major_wire : block--
  begin
    --
    data_out(31 downto 16) <= pi_reg.major.data(16-1 downto 0); --
    --no signal to read by HW
    po_reg.major.data <= (others => '0'); --
  end block; --
end rtl;
-----------------------------------------------
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
-- register type: mixed
-----------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.pkg_examp_regs.all;

entity examp_regs_mixed is
  port (
    pi_clock        : in  std_logic;
    pi_reset        : in  std_logic;
    -- to/from adapter
    pi_decoder_rd_stb : in  std_logic;
    pi_decoder_wr_stb : in  std_logic;
    pi_decoder_data   : in  std_logic_vector(C_DATA_WIDTH-1 downto 0);
    po_decoder_data   : out std_logic_vector(C_DATA_WIDTH-1 downto 0);

    pi_reg  : in t_reg_mixed_in ;
    po_reg  : out t_reg_mixed_out
  );
end entity examp_regs_mixed;

architecture rtl of examp_regs_mixed is
  signal data_out : std_logic_vector(C_DATA_WIDTH-1 downto 0) := (others => '0');
begin
  --
  data_out(C_DATA_WIDTH-1 downto 16) <= (others => '0'); --

  -- resize field data out to the register bus width
  -- do only if 1 field and signed--
  po_decoder_data <= data_out; --

  ------------------------------------------------------------STORAGE
  counter_field_t_name_2674884d_storage: block
    signal l_field_reg   : std_logic_vector(8-1 downto 0) :=
                           std_logic_vector(to_signed(0,8));
    signal l_incrvalue   : natural;
  begin
    prs_write : process(pi_clock)
    begin
      if rising_edge(pi_clock) then
        if pi_reset = '1' then
          l_field_reg <= std_logic_vector(to_signed(0,8));
        else
          -- HW --
          l_field_reg <= pi_reg.counter_field_t_name_2674884d.data;
          -- counter
          if  pi_reg.counter_field_t_name_2674884d.incr = '1' then
            l_field_reg <= std_logic_vector(unsigned(l_field_reg) + to_unsigned(l_incrvalue, 8));
          end if;
          -- SW -- TODO: handle software access side effects (rcl/rset, woclr/woset, swacc/swmod)
        end if;
      end if;
    end process;
    --
    po_reg.counter_field_t_name_2674884d.data <= l_field_reg; --
    data_out(7 downto 0) <= l_field_reg;

    l_incrvalue <= 1;
  end block counter_field_t_name_2674884d_storage;
  ------------------------------------------------------------STORAGE
  event_flag_field_t_desc_d257f7c2_name_1a3888d4_storage: block
    signal l_field_reg   : std_logic_vector(8-1 downto 0) :=
                           std_logic_vector(to_signed(0,8));
  begin
    prs_write : process(pi_clock)
    begin
      if rising_edge(pi_clock) then
        if pi_reset = '1' then
          l_field_reg <= std_logic_vector(to_signed(0,8));
        elsif pi_reg.event_flag_field_t_desc_d257f7c2_name_1a3888d4.hwset = '1' then
          l_field_reg <= (others => '1');
        else
          -- HW --
          l_field_reg <= pi_reg.event_flag_field_t_desc_d257f7c2_name_1a3888d4.data;
          -- SW -- TODO: handle software access side effects (rcl/rset, woclr/woset, swacc/swmod)
        end if;
      end if;
    end process;
    --no signal to read by HW
    po_reg.event_flag_field_t_desc_d257f7c2_name_1a3888d4.data <= (others => '0'); --
    data_out(15 downto 8) <= l_field_reg;

  end block event_flag_field_t_desc_d257f7c2_name_1a3888d4_storage;
  ----------------------------------------------------------
end rtl;
-----------------------------------------------

--------------------------------------------------------------------------------
-- Register types in regfiles
--------------------------------------------------------------------------------
--