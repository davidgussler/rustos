#!/usr/bin/env python3

from pathlib import Path
from vunit import VUnit

VU = VUnit.from_argv()
VU.add_vhdl_builtins()
VU.add_osvvm()
VU.add_verification_components()

SCRIPT_PATH = Path(__file__).parent
ROOT_PATH = SCRIPT_PATH / ".." / ".."

desyrdl = VU.add_library("desyrdl")
desyrdl.add_source_files(ROOT_PATH / "regs" / "gen" / "vhdl" / "vhdl" / "desyrdl" / "pkg_desyrdl_common.vhd")

rustos = VU.add_library("rustos")
rustos.add_source_files(ROOT_PATH / "regs" / "gen" / "vhdl" / "vhdl" / "examp_regs" / "*.vhd")
rustos.add_source_files(SCRIPT_PATH / "*.vhd")

# Simulator settings
rustos.set_compile_option("ghdl.a_flags", ["-frelaxed-rules", "--std=08"]) # , "-Wall"
rustos.set_sim_option("disable_ieee_warnings", True)
#lib.set_compile_option("enable_coverage", True)
#lib.set_sim_option("enable_coverage", True)
rustos.set_sim_option("ghdl.gtkwave_script.gui", str(SCRIPT_PATH / "load_waves.tcl"))

VU.main()