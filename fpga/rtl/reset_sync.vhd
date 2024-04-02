--#############################################################################
--# File     : reset_sync.vhd
--# Author   : David Gussler
--# Language : VHDL '08
--# ===========================================================================
--# Copyright (c) 2023-2024, David Gussler. All rights reserved.
--# You may use, distribute and modify this code under the
--# terms of the BSD 2-Clause license. You should have received a copy of the 
--# license with this file. If not, please message: davndnguss@gmail.com. 
--# ===========================================================================
--! Reset synchronizer. If any of the async reset inputs match the reset level,
--! then all of the synchronous resets are pulsed for G_SYNC_LEN cycles.
--! This module initialized the reset shift registers at FPGA power-up, so if 
--! arsts_i is tied to 0, then the srsts_o pulses at power up then never again.
--! By setting a default value
--#############################################################################

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity reset_sync is
  generic (
    G_SYNC_LEN : positive := 1;
    G_NUM_ARST : positive := 1; 
    G_NUM_SRST : positive := 1; 
    G_ARST_LVL : std_logic_vector(G_NUM_ARST-1 downto 0) := (others=>'1');
    G_SRST_LVL : std_logic_vector(G_NUM_SRST-1 downto 0) := (others=>'1')
  );
  port (
    clks_i  : in std_logic_vector(G_NUM_SRST-1 downto 0);
    arsts_i : in std_logic_vector(G_NUM_ARST-1 downto 0) := (others=>'0');
    srsts_o : out std_logic_vector(G_NUM_SRST-1 downto 0) 
  );
end entity;

architecture rtl of reset_sync is

  type sr_t is array (natural range 0 to G_SYNC_LEN) of
    std_logic_vector(G_NUM_SRST - 1 downto 0);
  signal sr : sr_t := (others => G_SRST_LVL);

  -- Xilinx attributes
  attribute ASYNC_REG       : string;
  attribute ASYNC_REG of sr : signal is "TRUE";
  attribute SHREG_EXTRACT       : string;
  attribute SHREG_EXTRACT of sr : signal is "NO";

  -- Returns 1 if any of the async reset bits are asserted
  function fn_arst (
    arst_slv : std_logic_vector;
    arst_lvl : std_logic_vector
  )
    return std_logic
  is
    variable tmp : std_logic_vector(arst_slv'length-1 downto 0) := (others=>'0');
  begin
    for i in 0 to arst_slv'length-1 loop
      tmp(i) := '1' when arst_slv(i) = arst_lvl(i) else '0'; 
    end loop;
    return or tmp;
  end function;

  signal arst : std_logic;

begin

  arst <= fn_arst(arsts_i, G_ARST_LVL);

  gen_arst : for idx in 0 to G_NUM_SRST-1 generate
    prc_reset_sync : process (clks_i(idx), arst)
    begin
      if arst then
        for sr_bit in 0 to G_SYNC_LEN loop
          sr(sr_bit)(idx) <= G_SRST_LVL(idx);
        end loop;
      elsif rising_edge(clks_i(idx)) then
        sr(0)(idx) <= not G_SRST_LVL(idx); 
        for sr_bit in 1 to G_SYNC_LEN loop
          sr(sr_bit)(idx) <= sr(sr_bit-1)(idx);
        end loop;
      end if;
    end process;

    srsts_o(idx) <= sr(G_SYNC_LEN)(idx);
  
  end generate;

end architecture;