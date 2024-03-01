# 
# Synthesis run script generated by Vivado
# 

set TIME_start [clock seconds] 
namespace eval ::optrace {
  variable script "/home/david/prj/my_repos/rustos/fpga/vivado/rustos/rustos.runs/synth_1/rustos_fpga_top.tcl"
  variable category "vivado_synth"
}

# Try to connect to running dispatch if we haven't done so already.
# This code assumes that the Tcl interpreter is not using threads,
# since the ::dispatch::connected variable isn't mutex protected.
if {![info exists ::dispatch::connected]} {
  namespace eval ::dispatch {
    variable connected false
    if {[llength [array get env XILINX_CD_CONNECT_ID]] > 0} {
      set result "true"
      if {[catch {
        if {[lsearch -exact [package names] DispatchTcl] < 0} {
          set result [load librdi_cd_clienttcl[info sharedlibextension]] 
        }
        if {$result eq "false"} {
          puts "WARNING: Could not load dispatch client library"
        }
        set connect_id [ ::dispatch::init_client -mode EXISTING_SERVER ]
        if { $connect_id eq "" } {
          puts "WARNING: Could not initialize dispatch client"
        } else {
          puts "INFO: Dispatch client connection id - $connect_id"
          set connected true
        }
      } catch_res]} {
        puts "WARNING: failed to connect to dispatch server - $catch_res"
      }
    }
  }
}
if {$::dispatch::connected} {
  # Remove the dummy proc if it exists.
  if { [expr {[llength [info procs ::OPTRACE]] > 0}] } {
    rename ::OPTRACE ""
  }
  proc ::OPTRACE { task action {tags {} } } {
    ::vitis_log::op_trace "$task" $action -tags $tags -script $::optrace::script -category $::optrace::category
  }
  # dispatch is generic. We specifically want to attach logging.
  ::vitis_log::connect_client
} else {
  # Add dummy proc if it doesn't exist.
  if { [expr {[llength [info procs ::OPTRACE]] == 0}] } {
    proc ::OPTRACE {{arg1 \"\" } {arg2 \"\"} {arg3 \"\" } {arg4 \"\"} {arg5 \"\" } {arg6 \"\"}} {
        # Do nothing
    }
  }
}

proc create_report { reportName command } {
  set status "."
  append status $reportName ".fail"
  if { [file exists $status] } {
    eval file delete [glob $status]
  }
  send_msg_id runtcl-4 info "Executing : $command"
  set retval [eval catch { $command } msg]
  if { $retval != 0 } {
    set fp [open $status w]
    close $fp
    send_msg_id runtcl-5 warning "$msg"
  }
}
OPTRACE "synth_1" START { ROLLUP_AUTO }
set_param checkpoint.writeSynthRtdsInDcp 1
set_param synth.incrementalSynthesisCache ./.Xil/Vivado-20702-krusty-krab/incrSyn
set_msg_config -id {Synth 8-256} -limit 10000
set_msg_config -id {Synth 8-638} -limit 10000
OPTRACE "Creating in-memory project" START { }
create_project -in_memory -part xc7a35tcpg236-1

set_param project.singleFileAddWarning.threshold 0
set_param project.compositeFile.enableAutoGeneration 0
set_param synth.vivado.isSynthRun true
set_property webtalk.parent_dir /home/david/prj/my_repos/rustos/fpga/vivado/rustos/rustos.cache/wt [current_project]
set_property parent.project_path /home/david/prj/my_repos/rustos/fpga/vivado/rustos/rustos.xpr [current_project]
set_property default_lib xil_defaultlib [current_project]
set_property target_language VHDL [current_project]
set_property ip_output_repo /home/david/prj/my_repos/rustos/fpga/vivado/rustos/rustos.cache/ip [current_project]
set_property ip_cache_permissions {read write} [current_project]
OPTRACE "Creating in-memory project" END { }
OPTRACE "Adding files" START { }
read_vhdl -vhdl2008 -library rustos {
  /home/david/prj/my_repos/rustos/fpga/rtl/gen_types_pkg.vhd
  /home/david/prj/my_repos/rustos/fpga/rtl/bit_sync.vhd
  /home/david/prj/my_repos/rustos/fpga/rtl/clocking.vhd
  /home/david/prj/my_repos/rustos/fpga/rtl/reset_sync.vhd
  /home/david/prj/my_repos/rustos/fpga/rtl/rustos_fpga.vhd
  /home/david/prj/my_repos/rustos/fpga/rtl/rustos_fpga_top.vhd
}
read_vhdl -vhdl2008 -library neorv32 {
  /home/david/prj/my_repos/rustos/fpga/lib/neorv32/rtl/core/neorv32_package.vhd
  /home/david/prj/my_repos/rustos/fpga/lib/neorv32/rtl/system_integration/neorv32_SystemTop_axi4lite.vhd
  /home/david/prj/my_repos/rustos/fpga/lib/neorv32/rtl/core/neorv32_application_image.vhd
  /home/david/prj/my_repos/rustos/fpga/lib/neorv32/rtl/core/neorv32_boot_rom.vhd
  /home/david/prj/my_repos/rustos/fpga/lib/neorv32/rtl/core/neorv32_bootloader_image.vhd
  /home/david/prj/my_repos/rustos/fpga/lib/neorv32/rtl/core/neorv32_cfs.vhd
  /home/david/prj/my_repos/rustos/fpga/lib/neorv32/rtl/core/neorv32_clockgate.vhd
  /home/david/prj/my_repos/rustos/fpga/lib/neorv32/rtl/core/neorv32_fifo.vhd
  /home/david/prj/my_repos/rustos/fpga/lib/neorv32/rtl/core/neorv32_cpu_decompressor.vhd
  /home/david/prj/my_repos/rustos/fpga/lib/neorv32/rtl/core/neorv32_cpu_control.vhd
  /home/david/prj/my_repos/rustos/fpga/lib/neorv32/rtl/core/neorv32_cpu_regfile.vhd
  /home/david/prj/my_repos/rustos/fpga/lib/neorv32/rtl/core/neorv32_cpu_cp_shifter.vhd
  /home/david/prj/my_repos/rustos/fpga/lib/neorv32/rtl/core/neorv32_cpu_cp_muldiv.vhd
  /home/david/prj/my_repos/rustos/fpga/lib/neorv32/rtl/core/neorv32_cpu_cp_bitmanip.vhd
  /home/david/prj/my_repos/rustos/fpga/lib/neorv32/rtl/core/neorv32_cpu_cp_fpu.vhd
  /home/david/prj/my_repos/rustos/fpga/lib/neorv32/rtl/core/neorv32_cpu_cp_cfu.vhd
  /home/david/prj/my_repos/rustos/fpga/lib/neorv32/rtl/core/neorv32_cpu_cp_cond.vhd
  /home/david/prj/my_repos/rustos/fpga/lib/neorv32/rtl/core/neorv32_cpu_alu.vhd
  /home/david/prj/my_repos/rustos/fpga/lib/neorv32/rtl/core/neorv32_cpu_lsu.vhd
  /home/david/prj/my_repos/rustos/fpga/lib/neorv32/rtl/core/neorv32_cpu_pmp.vhd
  /home/david/prj/my_repos/rustos/fpga/lib/neorv32/rtl/core/neorv32_cpu.vhd
  /home/david/prj/my_repos/rustos/fpga/lib/neorv32/rtl/core/neorv32_crc.vhd
  /home/david/prj/my_repos/rustos/fpga/lib/neorv32/rtl/core/neorv32_dcache.vhd
  /home/david/prj/my_repos/rustos/fpga/lib/neorv32/rtl/core/neorv32_debug_dm.vhd
  /home/david/prj/my_repos/rustos/fpga/lib/neorv32/rtl/core/neorv32_debug_dtm.vhd
  /home/david/prj/my_repos/rustos/fpga/lib/neorv32/rtl/core/neorv32_dma.vhd
  /home/david/prj/my_repos/rustos/fpga/lib/neorv32/rtl/core/neorv32_dmem.entity.vhd
  /home/david/prj/my_repos/rustos/fpga/lib/neorv32/rtl/core/mem/neorv32_dmem.default.vhd
  /home/david/prj/my_repos/rustos/fpga/lib/neorv32/rtl/core/neorv32_gpio.vhd
  /home/david/prj/my_repos/rustos/fpga/lib/neorv32/rtl/core/neorv32_gptmr.vhd
  /home/david/prj/my_repos/rustos/fpga/lib/neorv32/rtl/core/neorv32_icache.vhd
  /home/david/prj/my_repos/rustos/fpga/lib/neorv32/rtl/core/neorv32_imem.entity.vhd
  /home/david/prj/my_repos/rustos/fpga/lib/neorv32/rtl/core/mem/neorv32_imem.default.vhd
  /home/david/prj/my_repos/rustos/fpga/lib/neorv32/rtl/core/neorv32_intercon.vhd
  /home/david/prj/my_repos/rustos/fpga/lib/neorv32/rtl/core/neorv32_mtime.vhd
  /home/david/prj/my_repos/rustos/fpga/lib/neorv32/rtl/core/neorv32_neoled.vhd
  /home/david/prj/my_repos/rustos/fpga/lib/neorv32/rtl/core/neorv32_onewire.vhd
  /home/david/prj/my_repos/rustos/fpga/lib/neorv32/rtl/core/neorv32_pwm.vhd
  /home/david/prj/my_repos/rustos/fpga/lib/neorv32/rtl/core/neorv32_sdi.vhd
  /home/david/prj/my_repos/rustos/fpga/lib/neorv32/rtl/core/neorv32_slink.vhd
  /home/david/prj/my_repos/rustos/fpga/lib/neorv32/rtl/core/neorv32_spi.vhd
  /home/david/prj/my_repos/rustos/fpga/lib/neorv32/rtl/core/neorv32_sysinfo.vhd
  /home/david/prj/my_repos/rustos/fpga/lib/neorv32/rtl/core/neorv32_xip.vhd
  /home/david/prj/my_repos/rustos/fpga/lib/neorv32/rtl/core/neorv32_wishbone.vhd
  /home/david/prj/my_repos/rustos/fpga/lib/neorv32/rtl/core/neorv32_wdt.vhd
  /home/david/prj/my_repos/rustos/fpga/lib/neorv32/rtl/core/neorv32_uart.vhd
  /home/david/prj/my_repos/rustos/fpga/lib/neorv32/rtl/core/neorv32_twi.vhd
  /home/david/prj/my_repos/rustos/fpga/lib/neorv32/rtl/core/neorv32_trng.vhd
  /home/david/prj/my_repos/rustos/fpga/lib/neorv32/rtl/core/neorv32_xirq.vhd
  /home/david/prj/my_repos/rustos/fpga/lib/neorv32/rtl/core/neorv32_top.vhd
}
OPTRACE "Adding files" END { }
# Mark all dcp files as not used in implementation to prevent them from being
# stitched into the results of this synthesis run. Any black boxes in the
# design are intentionally left as such for best results. Dcp files will be
# stitched into the design at a later time, either when this synthesis run is
# opened, or when it is stitched into a dependent implementation run.
foreach dcp [get_files -quiet -all -filter file_type=="Design\ Checkpoint"] {
  set_property used_in_implementation false $dcp
}
read_xdc /home/david/prj/my_repos/rustos/fpga/constrs/vivado_managed.xdc
set_property used_in_implementation false [get_files /home/david/prj/my_repos/rustos/fpga/constrs/vivado_managed.xdc]

read_xdc /home/david/prj/my_repos/rustos/fpga/constrs/timing.xdc
set_property used_in_implementation false [get_files /home/david/prj/my_repos/rustos/fpga/constrs/timing.xdc]

read_xdc /home/david/prj/my_repos/rustos/fpga/constrs/physical.xdc
set_property used_in_implementation false [get_files /home/david/prj/my_repos/rustos/fpga/constrs/physical.xdc]

set_param ips.enableIPCacheLiteLoad 1

read_checkpoint -auto_incremental -incremental /home/david/prj/my_repos/rustos/fpga/vivado/rustos/rustos.srcs/utils_1/imports/synth_1/rustos_fpga_top.dcp
close [open __synthesis_is_running__ w]

OPTRACE "synth_design" START { }
synth_design -top rustos_fpga_top -part xc7a35tcpg236-1
OPTRACE "synth_design" END { }
if { [get_msg_config -count -severity {CRITICAL WARNING}] > 0 } {
 send_msg_id runtcl-6 info "Synthesis results are not added to the cache due to CRITICAL_WARNING"
}


OPTRACE "write_checkpoint" START { CHECKPOINT }
# disable binary constraint mode for synth run checkpoints
set_param constraints.enableBinaryConstraints false
write_checkpoint -force -noxdef rustos_fpga_top.dcp
OPTRACE "write_checkpoint" END { }
OPTRACE "synth reports" START { REPORT }
create_report "synth_1_synth_report_utilization_0" "report_utilization -file rustos_fpga_top_utilization_synth.rpt -pb rustos_fpga_top_utilization_synth.pb"
OPTRACE "synth reports" END { }
file delete __synthesis_is_running__
close [open __synthesis_is_complete__ w]
OPTRACE "synth_1" END { }
