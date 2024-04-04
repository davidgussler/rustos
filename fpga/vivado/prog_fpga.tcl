set prj_name "rustos"
set script_dir [file dirname [info script]]
set impl_dir "${script_dir}/${prj_name}/${prj_name}.runs/impl_1"

# Open the project if it is not already open
if {[catch current_project] != 0} {
  open_project ${script_dir}/${prj_name}/${prj_name}.xpr
}

set top_entity [lindex [find_top] 0]
if {$argc == 0} {
  puts "No bitfile explicitly specified... using bitfile from default location"
  set bit ${impl_dir}/${top_entity}.bit
} elseif {$argc > 1} {
  error "This script only supports one or zero input arguments"
} else {
  set bit [lindex $argv 0]
}

open_hw_manager
connect_hw_server -allow_non_jtag
open_hw_target
set_property PROGRAM.FILE "$bit" [get_hw_devices xc7a35t_0]

program_hw_devices [get_hw_devices xc7a35t_0]
refresh_hw_device [lindex [get_hw_devices xc7a35t_0] 0]
