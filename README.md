# Rustos

This repository represents my attempt at getting started with simple OS development in rust
Targeted architecture is a NEORV32 soft-core CPU running on a Basys3 dev board.


## FPGA build and programming steps:

1. `cd fpga/vivado/`
2. `vivado -mode batch -source create_prj.tcl`
3. `vivado -mode batch -source build.tcl`
4. Plug in basys3 baord to host PC
5. `vivado -mode batch -source prog_flash.tcl`


## Software build and programming steps:

1. cd to the top level project directory
2. `cp -r rustos/ fpga/lib/neorv32/sw/example/`
3. `cd fpga/lib/neorv32/sw/example/`
4. `make all`
5. follow the steps outlined here https://stnolting.github.io/neorv32/ug/#_uploading_and_starting_of_a_binary_executable_image_via_uart
   to upload and execute the binary on the device.


## Modifying the FPGA version

Update the values of the constants in this file: rustos/fpga/vivado/version.tcl

These values will only be applied to the build if the build script is run. Manual builds done 
using the vivado gui will show a version of 0.0.0.


## Modifying the FPGA registers

1. Update this file: rustos/fpga/regs/examp_regs.rdl
2. `cd rustos/fpga/regs/`
3. `./generate.sh` to regenerate the VHDL source code and associated documentation.
