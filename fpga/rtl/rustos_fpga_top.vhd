-- All this file does is map PCB net names to FPGA net names

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rustos_fpga_top is
  generic (
    G_VER_MAJOR : std_logic_vector(15 downto 0) := x"0000";
    G_VER_MINOR : std_logic_vector(15 downto 0) := x"0001"
  );
  port (
    clk : in std_logic; 
    btnC : in std_logic;

    RsRx : in std_logic;
    RsTx : out std_logic;

    sw : in std_logic_vector(7 downto 0);
    led : out std_logic_vector(7 downto 0)
  );
end entity;

architecture rtl of rustos_fpga_top is

begin

  rustos_fpga_inst : entity work.rustos_fpga
  generic map (
    G_VER_MAJOR => G_VER_MAJOR,
    G_VER_MINOR => G_VER_MINOR
  )
  port map (
    clk_i     => clk,
    arst_i    => btnC,
    uart_rx_i => RsRx,
    uart_tx_o => RsTx,
    sw_i      => sw,
    led_o     => led
  );

end architecture;
