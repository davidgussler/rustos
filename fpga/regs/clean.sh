#!/bin/bash
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
OUT_DIR="${SCRIPT_DIR}/gen"
( rm -rf ${OUT_DIR} )
