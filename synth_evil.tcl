#------------------------------------------------------------------------------
#
# Synthesis script for TRNG using Digilent Nexys 4 DDR board
#
# -----------------------------------------------------------------------------
#
create_project -part xc7a100t -force main
#
# -----------------------------------------------------------------------------
#

read_vhdl postprocessor.vhdl
read_vhdl rng1.vhdl
read_vhdl noise1.vhdl -vhdl2008
#read_vhdl SEPA.vhdl
read_vhdl trigger.vhdl -vhdl2008
read_vhdl SEPA_evil.vhdl
read_vhdl uart_tx.vhd
read_vhdl 7seg.vhdl
read_vhdl 7disp.vhdl
read_vhdl main.vhdl

read_xdc  main.xdc

#
# -----------------------------------------------------------------------------
#
synth_design -top main
#
# -----------------------------------------------------------------------------
#

opt_design
place_design
route_design

#
# -----------------------------------------------------------------------------
#
write_bitstream -force main.bit
#
# -----------------------------------------------------------------------------

report_utilization
