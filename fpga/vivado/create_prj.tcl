################################################################################
# File     : create_prj.tcl
# Author   : David Gussler
# ==============================================================================
# Creates Vivado project
################################################################################

# Constants
set prj_name "rustos"
set part_num "xc7a35tcpg236-1"

# Create the project
create_project -force $prj_name $prj_name -part $part_num

# Add neorv32 vhdl files 
add_files -fileset sources_1 [ glob \
    ./../lib/neorv32/rtl/core/*.vhd \
    ./../lib/neorv32/rtl/core/mem/*default*.vhd \
    ./../lib/neorv32/rtl/system_integration/neorv32_SystemTop_axi4lite.vhd \
]

# Set neorv32 library
set_property library {neorv32} [get_files -filter {FILE_TYPE == VHDL}]

# Add top level vhdl files
add_files -fileset sources_1 [ glob \
    ./../rtl/*.vhd
]

# Set top level library
set_property library ${prj_name} [get_files [ glob ./../rtl/*.vhd ]]

# Set all VHDL files to VHDL'08
set_property file_type {VHDL 2008} [get_files -filter {FILE_TYPE == VHDL}]

# Update to set top file and compile order
update_compile_order -fileset sources_1



# Add constraints
add_files -fileset constrs_1 [ glob \
    ./../constrs/*.xdc \
]

# Constraints properties
set_property target_constrs_file ./../constrs/vivado_managed.xdc [current_fileset -constrset]

# Set project properties
set_property target_language VHDL [current_project]
set_property simulator_language VHDL [current_project]

# Done

