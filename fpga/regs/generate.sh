#!/bin/bash
################################################################################
# Script to generate register output products.
#
# Prerequisites:
#   pip install peakrdl
#   pip install desyrdl
################################################################################

OUT="examp_regs"
 
## Script start ##
# Setup vars
SRC="common.rdl ${OUT}.rdl"
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
OUT_DIR="${SCRIPT_DIR}/gen"

# Delete output dir
( rm -rf ${OUT_DIR} )
 
## Generate outputs ##

# SystemVerilog source code
peakrdl regblock $SRC -o "${OUT_DIR}/sv" --cpuif axi4-lite
if [[ $? -ne 0 ]]; then
    echo "Error: Failed to generate SV source code"
    exit 1
fi

# VHDL source code
desyrdl -f vhdl -i $SRC -o "${OUT_DIR}/vhdl"
if [[ $? -ne 0 ]]; then
    echo "Error: Failed to generate VHDL source code"
    exit 1
fi

# C header source code
mkdir "${OUT_DIR}/cheader/"
peakrdl c-header $SRC -o "${OUT_DIR}/cheader/${OUT}.h"
if [[ $? -ne 0 ]]; then
    echo "Error: Failed to generate C header source code"
    exit 1
fi

# Webpage documentation
peakrdl html $SRC -o "${OUT_DIR}/html"
if [[ $? -ne 0 ]]; then
    echo "Error: Failed to generate webpage documentation"
    exit 1
fi

# Markdown documentation
mkdir "${OUT_DIR}/md/"
peakrdl markdown $SRC -o "${OUT_DIR}/md/${OUT}.md"
if [[ $? -ne 0 ]]; then
    echo "Error: Failed to generate markdown documentaion"
    exit 1
fi

# IPXACT
mkdir "${OUT_DIR}/ipxact/"
peakrdl ip-xact $SRC -o "${OUT_DIR}/ipxact/${OUT}.xml"
if [[ $? -ne 0 ]]; then
    echo "Error: Failed to generate IPXACT"
    exit 1
fi

echo "Done"

# echo "Finished exporting the following registers:"
# peakrdl dump $SRC
