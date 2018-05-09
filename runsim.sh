#!/bin/bash

# Script to simulate VHDL design	

ghdl -s --std=08 uart_tx.vhd
ghdl -s --std=08 7seg.vhdl
ghdl -s --std=08 7disp.vhdl
ghdl -s --std=08 rng1.vhdl
ghdl -s --std=08 noise1.vhdl
ghdl -s --std=08 SEPA.vhdl
ghdl -s --std=08 postprocessor.vhdl
ghdl -s --std=08 main.vhdl
ghdl -s --std=08 main_TB.vhdl

ghdl -a --std=08 uart_tx.vhd
ghdl -a --std=08 7seg.vhdl
ghdl -a --std=08 7disp.vhdl
ghdl -a --std=08 rng1.vhdl
ghdl -a --std=08 noise1.vhdl
ghdl -a --std=08 SEPA.vhdl
ghdl -a --std=08 postprocessor.vhdl
ghdl -a --std=08 main.vhdl
ghdl -a --std=08 main_TB.vhdl

ghdl -e --std=08 uart_tx
ghdl -e --std=08 sevenseg
ghdl -e --std=08 sevendisp
ghdl -e --std=08 RO
ghdl -e --std=08 NOISE
ghdl -e --std=08 SEPA
ghdl -e --std=08 postprocessor
ghdl -e --std=08 main
ghdl -e --std=08 main_TB

ghdl -r --std=08 main_TB --vcd=main_TB.vcd --stop-time=21s


# Show simulation result as wave form
gtkwave main_TB.vcd
