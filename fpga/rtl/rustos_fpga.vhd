library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library neorv32;
use neorv32.neorv32_package.all;

entity rustos_fpga is
  generic (
    G_VER_MAJOR : std_logic_vector(15 downto 0) := x"0000";
    G_VER_MINOR : std_logic_vector(15 downto 0) := x"0001"
  );
  port (
    clk_i : in std_logic; 
    arst_i : in std_logic;

    uart_tx_o : out std_logic;
    uart_rx_i : in std_logic;

    sw_i : in std_logic_vector(7 downto 0);
    led_o : out std_logic_vector(7 downto 0)
  );
end entity;

architecture rtl of rustos_fpga is

  -- CPU Configuration
  constant CLOCK_FREQUENCY            : natural                        := 100_000_000;
  constant HART_ID                    : std_ulogic_vector(31 downto 0) := x"00000000";
  constant VENDOR_ID                  : std_ulogic_vector(31 downto 0) := x"00000000";
  constant INT_BOOTLOADER_EN          : boolean                        := true;
  constant ON_CHIP_DEBUGGER_EN        : boolean                        := false;
  constant DM_LEGACY_MODE             : boolean                        := true;
  constant CPU_EXTENSION_RISCV_A      : boolean                        := true;
  constant CPU_EXTENSION_RISCV_B      : boolean                        := true;
  constant CPU_EXTENSION_RISCV_C      : boolean                        := true;
  constant CPU_EXTENSION_RISCV_E      : boolean                        := false;
  constant CPU_EXTENSION_RISCV_M      : boolean                        := true;
  constant CPU_EXTENSION_RISCV_U      : boolean                        := true;
  constant CPU_EXTENSION_RISCV_Zfinx  : boolean                        := false;
  constant CPU_EXTENSION_RISCV_Zicntr : boolean                        := true;
  constant CPU_EXTENSION_RISCV_Zihpm  : boolean                        := true;
  constant CPU_EXTENSION_RISCV_Zmmul  : boolean                        := false;
  constant CPU_EXTENSION_RISCV_Zxcfu  : boolean                        := false;
  constant FAST_MUL_EN                : boolean                        := true;
  constant FAST_SHIFT_EN              : boolean                        := true;
  constant PMP_NUM_REGIONS            : natural                        := 0;
  constant PMP_MIN_GRANULARITY        : natural                        := 4;
  constant HPM_NUM_CNTS               : natural                        := 1;
  constant HPM_CNT_WIDTH              : natural                        := 32;
  constant AMO_RVS_GRANULARITY        : natural                        := 4;
  constant MEM_INT_IMEM_EN            : boolean                        := true;
  constant MEM_INT_IMEM_SIZE          : natural                        := 128 * 1024; -- 128kB
  constant MEM_INT_DMEM_EN            : boolean                        := true;
  constant MEM_INT_DMEM_SIZE          : natural                        := 64 * 1024; -- 64kB
  constant ICACHE_EN                  : boolean                        := false;
  constant ICACHE_NUM_BLOCKS          : natural                        := 4;
  constant ICACHE_BLOCK_SIZE          : natural                        := 64;
  constant ICACHE_ASSOCIATIVITY       : natural                        := 1;
  constant DCACHE_EN                  : boolean                        := false;
  constant DCACHE_NUM_BLOCKS          : natural                        := 4;
  constant DCACHE_BLOCK_SIZE          : natural                        := 64;
  constant XIP_EN                     : boolean                        := false;
  constant XIP_CACHE_EN               : boolean                        := false;
  constant XIP_CACHE_NUM_BLOCKS       : natural range 1 to 256         := 8;
  constant XIP_CACHE_BLOCK_SIZE       : natural range 1 to 2 ** 16     := 256;
  constant XIRQ_NUM_CH                : natural                        := 1;
  constant XIRQ_TRIGGER_TYPE          : std_logic_vector(31 downto 0)  := x"FFFFFFFF";
  constant XIRQ_TRIGGER_POLARITY      : std_logic_vector(31 downto 0)  := x"FFFFFFFF";
  constant IO_GPIO_NUM                : natural                        := 8;
  constant IO_MTIME_EN                : boolean                        := true;
  constant IO_UART0_EN                : boolean                        := true;
  constant IO_UART0_RX_FIFO           : natural                        := 64;
  constant IO_UART0_TX_FIFO           : natural                        := 64;
  constant IO_UART1_EN                : boolean                        := false;
  constant IO_UART1_RX_FIFO           : natural                        := 64;
  constant IO_UART1_TX_FIFO           : natural                        := 64;
  constant IO_SPI_EN                  : boolean                        := false;
  constant IO_SPI_FIFO                : natural                        := 64;
  constant IO_SDI_EN                  : boolean                        := false;
  constant IO_SDI_FIFO                : natural                        := 1;
  constant IO_TWI_EN                  : boolean                        := false;
  constant IO_PWM_NUM_CH              : natural                        := 0;
  constant IO_WDT_EN                  : boolean                        := true;
  constant IO_TRNG_EN                 : boolean                        := true;
  constant IO_TRNG_FIFO               : natural                        := 1;
  constant IO_CFS_EN                  : boolean                        := false;
  constant IO_CFS_CONFIG              : std_logic_vector(31 downto 0)  := x"00000000";
  constant IO_CFS_IN_SIZE             : positive                       := 32;
  constant IO_CFS_OUT_SIZE            : positive                       := 32;
  constant IO_NEOLED_EN               : boolean                        := true;
  constant IO_NEOLED_TX_FIFO          : natural                        := 1;
  constant IO_GPTMR_EN                : boolean                        := true;
  constant IO_ONEWIRE_EN              : boolean                        := false;
  constant IO_DMA_EN                  : boolean                        := false;
  constant IO_SLINK_EN                : boolean                        := false;
  constant IO_SLINK_RX_FIFO           : natural                        := 1;
  constant IO_SLINK_TX_FIFO           : natural                        := 1;
  constant IO_CRC_EN                  : boolean                        := false;

  -- Ports
  signal m_axi_aclk : std_logic;
  signal m_axi_aresetn : std_logic;
  signal m_axi_awaddr : std_logic_vector(31 downto 0);
  signal m_axi_awprot : std_logic_vector(2 downto 0);
  signal m_axi_awvalid : std_logic;
  signal m_axi_awready : std_logic;
  signal m_axi_wdata : std_logic_vector(31 downto 0);
  signal m_axi_wstrb : std_logic_vector(3 downto 0);
  signal m_axi_wvalid : std_logic;
  signal m_axi_wready : std_logic;
  signal m_axi_araddr : std_logic_vector(31 downto 0);
  signal m_axi_arprot : std_logic_vector(2 downto 0);
  signal m_axi_arvalid : std_logic;
  signal m_axi_arready : std_logic;
  signal m_axi_rdata : std_logic_vector(31 downto 0);
  signal m_axi_rresp : std_logic_vector(1 downto 0);
  signal m_axi_rvalid : std_logic;
  signal m_axi_rready : std_logic;
  signal m_axi_bresp : std_logic_vector(1 downto 0);
  signal m_axi_bvalid : std_logic;
  signal m_axi_bready : std_logic;
  signal s0_axis_tdata : std_logic_vector(31 downto 0);
  signal s0_axis_tvalid : std_logic;
  signal s0_axis_tlast : std_logic;
  signal s0_axis_tready : std_logic;
  signal s1_axis_tdata : std_logic_vector(31 downto 0);
  signal s1_axis_tvalid : std_logic;
  signal s1_axis_tlast : std_logic;
  signal s1_axis_tready : std_logic;
  signal jtag_trst_i : std_logic;
  signal jtag_tck_i : std_logic;
  signal jtag_tdi_i : std_logic;
  signal jtag_tdo_o : std_logic;
  signal jtag_tms_i : std_logic;
  signal xip_csn_o : std_logic;
  signal xip_clk_o : std_logic;
  signal xip_dat_i : std_logic;
  signal xip_dat_o : std_logic;
  signal gpio_o : std_logic_vector(63 downto 0);
  signal gpio_i : std_logic_vector(63 downto 0);
  signal uart0_txd_o : std_logic;
  signal uart0_rxd_i : std_logic;
  signal uart0_rts_o : std_logic;
  signal uart0_cts_i : std_logic;
  signal uart1_txd_o : std_logic;
  signal uart1_rxd_i : std_logic;
  signal uart1_rts_o : std_logic;
  signal uart1_cts_i : std_logic;
  signal spi_clk_o : std_logic;
  signal spi_dat_o : std_logic;
  signal spi_dat_i : std_logic;
  signal spi_csn_o : std_logic_vector(07 downto 0);
  signal sdi_clk_i : std_logic;
  signal sdi_dat_o : std_logic;
  signal sdi_dat_i : std_logic;
  signal sdi_csn_i : std_logic;
  signal twi_sda_i : std_logic;
  signal twi_sda_o : std_logic;
  signal twi_scl_i : std_logic;
  signal twi_scl_o : std_logic;
  signal onewire_i : std_logic;
  signal onewire_o : std_logic;
  signal pwm_o : std_logic_vector(11 downto 0);
  signal cfs_in_i : std_logic_vector(IO_CFS_IN_SIZE-1  downto 0);
  signal cfs_out_o : std_logic_vector(IO_CFS_OUT_SIZE-1 downto 0);
  signal neoled_o : std_logic;
  signal xirq_i : std_logic_vector(31 downto 0);
  signal mtime_irq_i : std_logic;
  signal msw_irq_i : std_logic;
  signal mext_irq_i : std_logic;

  signal mmcm_locked : std_logic;
  signal srst : std_logic;
  signal arst : std_logic;

begin

  clocking_inst : entity work.clocking
  port map (
    clk_i => clk_i, 
    clk_o => m_axi_aclk, 
    locked_o => mmcm_locked 
  );

  reset_sync_inst : entity work.reset_sync
  port map (
    clk_i => m_axi_aclk, 
    arst_i => arst, 
    srst_o => srst 
  );
  arst <= arst_i or not mmcm_locked;
  m_axi_aresetn <= not srst;

  uart_bit_sync_inst : entity work.bit_sync
  generic map (
    G_WIDTH => 1
  )
  port map (
    clk_i => m_axi_aclk, 
    async_i(0) => uart_rx_i,
    sync_o(0) => uart0_rxd_i
  );
  uart_tx_o <= uart0_txd_o;
  
  
  switch_bit_sync_inst : entity work.bit_sync
  generic map (
    G_WIDTH => sw_i'length
  )
  port map (
    clk_i => m_axi_aclk, 
    async_i => sw_i,
    sync_o => gpio_i(sw_i'RANGE)
  );
  led_o <= gpio_o(led_o'RANGE); 
  

  neorv32_SystemTop_axi4lite_inst : entity neorv32.neorv32_SystemTop_axi4lite
  generic map (
    CLOCK_FREQUENCY            => CLOCK_FREQUENCY,
    HART_ID                    => HART_ID,
    VENDOR_ID                  => VENDOR_ID,
    INT_BOOTLOADER_EN          => INT_BOOTLOADER_EN,
    ON_CHIP_DEBUGGER_EN        => ON_CHIP_DEBUGGER_EN,
    DM_LEGACY_MODE             => DM_LEGACY_MODE,
    CPU_EXTENSION_RISCV_A      => CPU_EXTENSION_RISCV_A,
    CPU_EXTENSION_RISCV_B      => CPU_EXTENSION_RISCV_B,
    CPU_EXTENSION_RISCV_C      => CPU_EXTENSION_RISCV_C,
    CPU_EXTENSION_RISCV_E      => CPU_EXTENSION_RISCV_E,
    CPU_EXTENSION_RISCV_M      => CPU_EXTENSION_RISCV_M,
    CPU_EXTENSION_RISCV_U      => CPU_EXTENSION_RISCV_U,
    CPU_EXTENSION_RISCV_Zfinx  => CPU_EXTENSION_RISCV_Zfinx,
    CPU_EXTENSION_RISCV_Zicntr => CPU_EXTENSION_RISCV_Zicntr,
    CPU_EXTENSION_RISCV_Zihpm  => CPU_EXTENSION_RISCV_Zihpm,
    CPU_EXTENSION_RISCV_Zmmul  => CPU_EXTENSION_RISCV_Zmmul,
    CPU_EXTENSION_RISCV_Zxcfu  => CPU_EXTENSION_RISCV_Zxcfu,
    FAST_MUL_EN                => FAST_MUL_EN,
    FAST_SHIFT_EN              => FAST_SHIFT_EN,
    PMP_NUM_REGIONS            => PMP_NUM_REGIONS,
    PMP_MIN_GRANULARITY        => PMP_MIN_GRANULARITY,
    HPM_NUM_CNTS               => HPM_NUM_CNTS,
    HPM_CNT_WIDTH              => HPM_CNT_WIDTH,
    AMO_RVS_GRANULARITY        => AMO_RVS_GRANULARITY,
    MEM_INT_IMEM_EN            => MEM_INT_IMEM_EN,
    MEM_INT_IMEM_SIZE          => MEM_INT_IMEM_SIZE,
    MEM_INT_DMEM_EN            => MEM_INT_DMEM_EN,
    MEM_INT_DMEM_SIZE          => MEM_INT_DMEM_SIZE,
    ICACHE_EN                  => ICACHE_EN,
    ICACHE_NUM_BLOCKS          => ICACHE_NUM_BLOCKS,
    ICACHE_BLOCK_SIZE          => ICACHE_BLOCK_SIZE,
    ICACHE_ASSOCIATIVITY       => ICACHE_ASSOCIATIVITY,
    DCACHE_EN                  => DCACHE_EN,
    DCACHE_NUM_BLOCKS          => DCACHE_NUM_BLOCKS,
    DCACHE_BLOCK_SIZE          => DCACHE_BLOCK_SIZE,
    XIP_EN                     => XIP_EN,
    XIP_CACHE_EN               => XIP_CACHE_EN,
    XIP_CACHE_NUM_BLOCKS       => XIP_CACHE_NUM_BLOCKS,
    XIP_CACHE_BLOCK_SIZE       => XIP_CACHE_BLOCK_SIZE,
    XIRQ_NUM_CH                => XIRQ_NUM_CH,
    XIRQ_TRIGGER_TYPE          => XIRQ_TRIGGER_TYPE,
    XIRQ_TRIGGER_POLARITY      => XIRQ_TRIGGER_POLARITY,
    IO_GPIO_NUM                => IO_GPIO_NUM,
    IO_MTIME_EN                => IO_MTIME_EN,
    IO_UART0_EN                => IO_UART0_EN,
    IO_UART0_RX_FIFO           => IO_UART0_RX_FIFO,
    IO_UART0_TX_FIFO           => IO_UART0_TX_FIFO,
    IO_UART1_EN                => IO_UART1_EN,
    IO_UART1_RX_FIFO           => IO_UART1_RX_FIFO,
    IO_UART1_TX_FIFO           => IO_UART1_TX_FIFO,
    IO_SPI_EN                  => IO_SPI_EN,
    IO_SPI_FIFO                => IO_SPI_FIFO,
    IO_SDI_EN                  => IO_SDI_EN,
    IO_SDI_FIFO                => IO_SDI_FIFO,
    IO_TWI_EN                  => IO_TWI_EN,
    IO_PWM_NUM_CH              => IO_PWM_NUM_CH,
    IO_WDT_EN                  => IO_WDT_EN,
    IO_TRNG_EN                 => IO_TRNG_EN,
    IO_TRNG_FIFO               => IO_TRNG_FIFO,
    IO_CFS_EN                  => IO_CFS_EN,
    IO_CFS_CONFIG              => IO_CFS_CONFIG,
    IO_CFS_IN_SIZE             => IO_CFS_IN_SIZE,
    IO_CFS_OUT_SIZE            => IO_CFS_OUT_SIZE,
    IO_NEOLED_EN               => IO_NEOLED_EN,
    IO_NEOLED_TX_FIFO          => IO_NEOLED_TX_FIFO,
    IO_GPTMR_EN                => IO_GPTMR_EN,
    IO_ONEWIRE_EN              => IO_ONEWIRE_EN,
    IO_DMA_EN                  => IO_DMA_EN,
    IO_SLINK_EN                => IO_SLINK_EN,
    IO_SLINK_RX_FIFO           => IO_SLINK_RX_FIFO,
    IO_SLINK_TX_FIFO           => IO_SLINK_TX_FIFO,
    IO_CRC_EN                  => IO_CRC_EN
  )
  port map (
    m_axi_aclk     => m_axi_aclk,
    m_axi_aresetn  => m_axi_aresetn,
    m_axi_awaddr   => m_axi_awaddr,
    m_axi_awprot   => m_axi_awprot,
    m_axi_awvalid  => m_axi_awvalid,
    m_axi_awready  => m_axi_awready,
    m_axi_wdata    => m_axi_wdata,
    m_axi_wstrb    => m_axi_wstrb,
    m_axi_wvalid   => m_axi_wvalid,
    m_axi_wready   => m_axi_wready,
    m_axi_araddr   => m_axi_araddr,
    m_axi_arprot   => m_axi_arprot,
    m_axi_arvalid  => m_axi_arvalid,
    m_axi_arready  => m_axi_arready,
    m_axi_rdata    => m_axi_rdata,
    m_axi_rresp    => m_axi_rresp,
    m_axi_rvalid   => m_axi_rvalid,
    m_axi_rready   => m_axi_rready,
    m_axi_bresp    => m_axi_bresp,
    m_axi_bvalid   => m_axi_bvalid,
    m_axi_bready   => m_axi_bready,
    s0_axis_tdata  => s0_axis_tdata,
    s0_axis_tvalid => s0_axis_tvalid,
    s0_axis_tlast  => s0_axis_tlast,
    s0_axis_tready => s0_axis_tready,
    s1_axis_tdata  => s1_axis_tdata,
    s1_axis_tvalid => s1_axis_tvalid,
    s1_axis_tlast  => s1_axis_tlast,
    s1_axis_tready => s1_axis_tready,
    jtag_trst_i    => jtag_trst_i,
    jtag_tck_i     => jtag_tck_i,
    jtag_tdi_i     => jtag_tdi_i,
    jtag_tdo_o     => jtag_tdo_o,
    jtag_tms_i     => jtag_tms_i,
    xip_csn_o      => xip_csn_o,
    xip_clk_o      => xip_clk_o,
    xip_dat_i      => xip_dat_i,
    xip_dat_o      => xip_dat_o,
    gpio_o         => gpio_o,
    gpio_i         => gpio_i,
    uart0_txd_o    => uart0_txd_o,
    uart0_rxd_i    => uart0_rxd_i,
    uart0_rts_o    => uart0_rts_o,
    uart0_cts_i    => uart0_cts_i,
    uart1_txd_o    => uart1_txd_o,
    uart1_rxd_i    => uart1_rxd_i,
    uart1_rts_o    => uart1_rts_o,
    uart1_cts_i    => uart1_cts_i,
    spi_clk_o      => spi_clk_o,
    spi_dat_o      => spi_dat_o,
    spi_dat_i      => spi_dat_i,
    spi_csn_o      => spi_csn_o,
    sdi_clk_i      => sdi_clk_i,
    sdi_dat_o      => sdi_dat_o,
    sdi_dat_i      => sdi_dat_i,
    sdi_csn_i      => sdi_csn_i,
    twi_sda_i      => twi_sda_i,
    twi_sda_o      => twi_sda_o,
    twi_scl_i      => twi_scl_i,
    twi_scl_o      => twi_scl_o,
    onewire_i      => onewire_i,
    onewire_o      => onewire_o,
    pwm_o          => pwm_o,
    cfs_in_i       => cfs_in_i,
    cfs_out_o      => cfs_out_o,
    neoled_o       => neoled_o,
    xirq_i         => xirq_i,
    mtime_irq_i    => mtime_irq_i,
    msw_irq_i      => msw_irq_i,
    mext_irq_i     => mext_irq_i
  );
end architecture;