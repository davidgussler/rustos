#!/usr/bin/env python3

from pathlib import Path
from vunit import VUnit

VU = VUnit.from_argv()
VU.add_vhdl_builtins()
VU.add_osvvm()
VU.add_verification_components()

SCRIPT_PATH = Path(__file__).parent
ROOT_PATH = SCRIPT_PATH / ".." / ".."

neorv32 = VU.add_library("neorv32")
neorv32.add_source_files(ROOT_PATH / "lib" / "neorv32" / "rtl" / "core" / "*.vhd")
neorv32.add_source_files(ROOT_PATH / "lib" / "neorv32" / "rtl" / "core" / "mem" / "*default*.vhd")
neorv32.add_source_files(ROOT_PATH / "lib" / "neorv32" / "rtl" / "system_integration" / "neorv32_SystemTop_axi4lite.vhd")

desyrdl = VU.add_library("desyrdl")
desyrdl.add_source_files(ROOT_PATH / "regs" / "gen" / "vhdl" / "vhdl" / "desyrdl" / "pkg_desyrdl_common.vhd")

rustos = VU.add_library("rustos")
rustos.add_source_files(ROOT_PATH / "regs" / "gen" / "vhdl" / "vhdl" / "examp_regs" / "*.vhd")
rustos.add_source_files(ROOT_PATH / "rtl" / "*.vhd")

VU.main()