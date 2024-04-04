
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library rustos;
use rustos.pkg_examp_regs.all;

library vunit_lib;
context vunit_lib.vunit_context;
context vunit_lib.vc_context;
use vunit_lib.axi_lite_master_pkg.all;

entity examp_regs_tb is
  generic (
    runner_cfg : string
  );
end;

architecture bench of examp_regs_tb is
  -- Clock period
  constant clk_period : time := 10 ns;
  constant CLK_TO_Q : time := 1 ns; 
  -- Ports
  signal clk : std_logic := '1';
  signal srst : std_logic := '1';
  signal examp_regs_m2s : t_examp_regs_m2s;
  signal examp_regs_s2m : t_examp_regs_s2m;
  signal regi : t_addrmap_examp_regs_in;
  signal rego : t_addrmap_examp_regs_out;

  -- Version and ID info
  constant FPGA_ID        : std_logic_vector(31 downto 0) := x"0000_0001"; 
  constant FPGA_VER_MAJOR : std_logic_vector(7 downto 0)  := x"00";
  constant FPGA_VER_MINOR : std_logic_vector(7 downto 0)  := x"01";
  constant FPGA_VER_PATCH : std_logic_vector(7 downto 0)  := x"00";
  constant G_GIT_HASH     : std_logic_vector(31 downto 0) := x"0000_0000"; 

  constant axim : bus_master_t := new_bus(data_length => 32, address_length => 32);

  signal we : std_logic;

begin

  main : process

    -- Helper Procedures
    procedure prd_wait_clk(cnt : in positive) is 
    begin 
        for i in 0 to cnt-1 loop 
            wait until rising_edge(clk);
            wait for CLK_TO_Q;
        end loop; 
    end procedure; 

    procedure prd_rst(cnt : in positive) is 
    begin 
        prd_wait_clk(1);
        srst <= '1';
        prd_wait_clk(cnt);
        srst <= '0';
    end procedure; 

  begin

    -- This code is common to the entire test suite
    -- and is executed *once* prior to all test cases.
    test_runner_setup(runner, runner_cfg);
    
    while test_suite loop

      -- This code executed before *every* test case.
      prd_rst(16);
      info("Starting test...");

      if run("test_alive") then
        info("Hello world test_alive");
        
      elsif run("test_0") then
        info("Hello world test_0");

      elsif run("test_1") then
        info("Running test_1");

        info("Check scratchpad");
        check_axi_lite(net, axim, X"0000_0000", b"00", X"1234_5678");
        write_axi_lite(net, axim, X"0000_0000", X"1122_3344", b"00", x"F");
        check_axi_lite(net, axim, X"0000_0000", b"00", X"1122_3344");

        info("Check ID");
        check_axi_lite(net, axim, X"0000_0004", b"00", X"0000_0001");
        write_axi_lite(net, axim, X"0000_0004", X"1122_3344", b"00", x"F");
        check_axi_lite(net, axim, X"0000_0004", b"00", X"0000_0001");

        info("Check version");
        check_axi_lite(net, axim, X"0000_0008", b"00", X"0000_0100");
        write_axi_lite(net, axim, X"0000_0008", X"1122_3344", b"00", x"F");
        check_axi_lite(net, axim, X"0000_0008", b"00", X"0000_0100");

        info("Check git hash");
        check_axi_lite(net, axim, X"0000_000C", b"00", X"0000_0000");
        write_axi_lite(net, axim, X"0000_000C", X"1122_3344", b"00", x"F");
        check_axi_lite(net, axim, X"0000_000C", b"00", X"0000_0000");

        info("Control / status");
        check_axi_lite(net, axim, X"0000_0010", b"00", X"0000_0003");
        check_axi_lite(net, axim, X"0000_0014", b"00", X"0000_0003");
        write_axi_lite(net, axim, X"0000_0014", X"0000_0002", b"00", x"F");
        check_axi_lite(net, axim, X"0000_0010", b"00", X"0000_0003");
        check_axi_lite(net, axim, X"0000_0014", b"00", X"0000_0003");
        write_axi_lite(net, axim, X"0000_0010", X"0000_0002", b"00", x"F");
        check_axi_lite(net, axim, X"0000_0010", b"00", X"0000_0002");
        check_axi_lite(net, axim, X"0000_0014", b"00", X"0000_0002");

        info("Read should always return the last write unless the magic number, 123456678 is written, in which case, reads will rerun 23456789.");
        check_axi_lite(net, axim, X"0000_0018", b"00", X"0000_000A");
        write_axi_lite(net, axim, X"0000_0018", X"0000_0002", b"00", x"F");
        check_axi_lite(net, axim, X"0000_0018", b"00", X"0000_0002");
        write_axi_lite(net, axim, X"0000_0018", X"0004_0000", b"00", x"F");
        check_axi_lite(net, axim, X"0000_0018", b"00", X"0004_0000");
        write_axi_lite(net, axim, X"0000_0018", X"12345678", b"00", x"F");
        check_axi_lite(net, axim, X"0000_0018", b"00", X"23456789");

        info("Counter0");
        check_axi_lite(net, axim, X"0000_0024", b"00", X"0000_0000");
        write_axi_lite(net, axim, X"0000_001C", X"0000_0001", b"00", x"3");
        check_axi_lite(net, axim, X"0000_0024", b"00", X"0000_0001");
        write_axi_lite(net, axim, X"0000_001C", X"0000_0001", b"00", x"3");
        check_axi_lite(net, axim, X"0000_0024", b"00", X"0000_0002");
        write_axi_lite(net, axim, X"0000_001C", X"0000_0001", b"00", x"3");
        check_axi_lite(net, axim, X"0000_0024", b"00", X"0000_0003");
        write_axi_lite(net, axim, X"0000_001C", X"0000_0000", b"00", x"3");
        check_axi_lite(net, axim, X"0000_0024", b"00", X"0000_0003");

      end if;

      -- Put test case cleanup code here. This code executed after *every* test case.
      info("Test done");
      prd_wait_clk(16);

    end loop;

    -- Put test suite cleanup code here. This code is common to the entire test suite
    -- and is executed *once* after all test cases have been run.
    test_runner_cleanup(runner);

  end process main;

  -- Watchdog
  test_runner_watchdog(runner, 100 us);

  -- Clocks
  clk <= not clk after clk_period / 2;


  -- DUT
  examp_regs_inst : entity rustos.examp_regs
  port map (
    pi_clock => clk,
    pi_reset => srst,
    pi_s_reset => '0',
    pi_s_top => examp_regs_m2s,
    po_s_top => examp_regs_s2m,
    pi_addrmap => regi,
    po_addrmap => rego
  );

  -- AXI BFM
  u_axi_lite_master_bfm: entity vunit_lib.axi_lite_master
  generic map (
    bus_handle => axim
  )
  port map (
    aclk    => clk,
    arready => examp_regs_s2m.arready,
    arvalid => examp_regs_m2s.arvalid,
    araddr  => examp_regs_m2s.araddr,
    rready  => examp_regs_m2s.rready,
    rvalid  => examp_regs_s2m.rvalid,
    rdata   => examp_regs_s2m.rdata,
    rresp   => examp_regs_s2m.rresp,
    awready => examp_regs_s2m.awready,
    awvalid => examp_regs_m2s.awvalid,
    awaddr  => examp_regs_m2s.awaddr,
    wready  => examp_regs_s2m.wready,
    wvalid  => examp_regs_m2s.wvalid,
    wdata   => examp_regs_m2s.wdata,
    wstrb   => examp_regs_m2s.wstrb,
    bvalid  => examp_regs_s2m.bvalid,
    bready  => examp_regs_m2s.bready,
    bresp   => examp_regs_s2m.bresp
  );

  -- Test register logic
  regi.common.id.id.data <= FPGA_ID; 
  regi.common.version.major.data <= FPGA_VER_MAJOR;
  regi.common.version.minor.data <= FPGA_VER_MINOR; 
  regi.common.version.patch.data <= FPGA_VER_PATCH;
  regi.common.git.git.data <= G_GIT_HASH; 
  regi.status.sts0.data <= rego.control.ctl0.data;
  regi.status.sts1.data <= rego.control.ctl1.data;
  regi.cntr(0).cnt.incr <= '1' when rego.wr_pulse(0).data.swmod and rego.wr_pulse(0).data.data(0) else '0';
  regi.cntr(1).cnt.incr <= '1' when rego.wr_pulse(1).data.swmod and rego.wr_pulse(1).data.data(0) else '0'; 
  regi.hwrw.data.data <= x"2345_6789";
  regi.hwrw.data.we <= we;
  process (clk)
  begin
    if rising_edge(clk) then
      we <= '1' when rego.hwrw.data.swmod = '1' and rego.hwrw.data.data = x"1234_5678" else '0';
    end if;
  end process;


end;