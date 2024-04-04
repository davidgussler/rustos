set prj_name "rustos"
set script_dir [file dirname [info script]]
set impl_dir "${script_dir}/${prj_name}/${prj_name}.runs/impl_1"

# Open the project if it is not already open
if {[catch current_project] != 0} {
  open_project ${script_dir}/${prj_name}/${prj_name}.xpr
}

set top_entity [lindex [find_top] 0]
if {$argc == 0} {
  puts "No mcs file explicitly specified... using mcs from default location"
  set mcs ${impl_dir}/${top_entity}.mcs
} elseif {$argc > 1} {
  error "This script only supports one or zero input arguments"
} else {
  set mcs [lindex $argv 0]
}

open_hw_manager
connect_hw_server -allow_non_jtag
open_hw_target

create_hw_cfgmem -hw_device [lindex [get_hw_devices xc7a35t_0] 0] [lindex [get_cfgmem_parts {mx25l3273f-spi-x1_x2_x4}] 0]
set_property PROGRAM.BLANK_CHECK  0 [ get_property PROGRAM.HW_CFGMEM [lindex [get_hw_devices xc7a35t_0] 0]]
set_property PROGRAM.ERASE  1 [ get_property PROGRAM.HW_CFGMEM [lindex [get_hw_devices xc7a35t_0] 0]]
set_property PROGRAM.CFG_PROGRAM  1 [ get_property PROGRAM.HW_CFGMEM [lindex [get_hw_devices xc7a35t_0] 0]]
set_property PROGRAM.VERIFY  1 [ get_property PROGRAM.HW_CFGMEM [lindex [get_hw_devices xc7a35t_0] 0]]
set_property PROGRAM.CHECKSUM  0 [ get_property PROGRAM.HW_CFGMEM [lindex [get_hw_devices xc7a35t_0] 0]]
refresh_hw_device [lindex [get_hw_devices xc7a35t_0] 0]
set_property PROGRAM.ADDRESS_RANGE  {use_file} [ get_property PROGRAM.HW_CFGMEM [lindex [get_hw_devices xc7a35t_0] 0]]
set_property PROGRAM.FILES [list "$mcs" ] [ get_property PROGRAM.HW_CFGMEM [lindex [get_hw_devices xc7a35t_0] 0]]
set_property PROGRAM.PRM_FILE {} [ get_property PROGRAM.HW_CFGMEM [lindex [get_hw_devices xc7a35t_0] 0]]
set_property PROGRAM.UNUSED_PIN_TERMINATION {pull-none} [ get_property PROGRAM.HW_CFGMEM [lindex [get_hw_devices xc7a35t_0] 0]]
set_property PROGRAM.BLANK_CHECK  0 [ get_property PROGRAM.HW_CFGMEM [lindex [get_hw_devices xc7a35t_0] 0]]
set_property PROGRAM.ERASE  1 [ get_property PROGRAM.HW_CFGMEM [lindex [get_hw_devices xc7a35t_0] 0]]
set_property PROGRAM.CFG_PROGRAM  1 [ get_property PROGRAM.HW_CFGMEM [lindex [get_hw_devices xc7a35t_0] 0]]
set_property PROGRAM.VERIFY  1 [ get_property PROGRAM.HW_CFGMEM [lindex [get_hw_devices xc7a35t_0] 0]]
set_property PROGRAM.CHECKSUM  0 [ get_property PROGRAM.HW_CFGMEM [lindex [get_hw_devices xc7a35t_0] 0]]
startgroup 
create_hw_bitstream -hw_device [lindex [get_hw_devices xc7a35t_0] 0] [get_property PROGRAM.HW_CFGMEM_BITFILE [ lindex [get_hw_devices xc7a35t_0] 0]]; program_hw_devices [lindex [get_hw_devices xc7a35t_0] 0]; refresh_hw_device [lindex [get_hw_devices xc7a35t_0] 0];
program_hw_cfgmem -hw_cfgmem [ get_property PROGRAM.HW_CFGMEM [lindex [get_hw_devices xc7a35t_0] 0]]
endgroup
