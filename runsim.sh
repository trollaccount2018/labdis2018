#!/bin/bash

# Script to simulate VHDL designs
#
# Usage:
#
#		runsim.sh <design-file> <top-entity>	

# Simulate design

ghdl -s --std=02 $1
ghdl -a --std=02 $1
ghdl -e --std=02 $2
ghdl -r --std=02 $2 --vcd=$2.vcd --stop-time=$3


# Show simulation result as wave form
gtkwave $2.vcd &
