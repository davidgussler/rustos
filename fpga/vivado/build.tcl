set prj_name "rustos"
set script_dir [file dirname [info script]]
set top_entity [lindex [find_top] 0]
set impl_dir "${script_dir}/${prj_name}/${prj_name}.runs/impl_1"
set bit ${impl_dir}/${top_entity}.bit
set mcs ${impl_dir}/${top_entity}.mcs

# Open the project if it is not already open
if {[catch current_project] != 0} {
  open_project ${script_dir}/${prj_name}/${prj_name}.xpr
}

# Get the version info (version.tcl should be manually updated)
source ${script_dir}/version.tcl
set maj [format %02X ${MAJOR}]
set min [format %02X ${MINOR}]
set pat [format %02X ${PATCH}]
set ver_string "v${MAJOR}.${MINOR}.${PATCH}"

# Get the 8 MSBs of the git hash for the HEAD commit
set saved_dir [pwd]
cd $script_dir
set git_hash [exec git rev-parse --short=8 HEAD]
cd $saved_dir

# Set build-time generics
set_property generic "G_VER_MAJOR=8'h$maj_hex" [current_fileset]
set_property generic "G_VER_MINOR=8'h$min_hex" [current_fileset]
set_property generic "G_VER_PATCH=8'h$pat_hex" [current_fileset]
set_property generic "G_GIT_HASH=32'h$git_hash" [current_fileset]

# Generate the bitstream
reset_run synth_1
launch_runs impl_1 -to_step write_bitstream
wait_on_run [get_runs impl_1]

# Generate the flash configuration
write_cfgmem -format mcs -size 4 -interface SPIx4 -force -loadbit "up 0x0 $bit" -file $mcs

file copy -force $bit ${script_dir}/${top_entity}_${ver_string}.bit 
file copy -force $mcs ${script_dir}/${top_entity}_${ver_string}.mcs
