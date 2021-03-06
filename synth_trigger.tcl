#------------------------------------------------------------------------------
#
# Synthesis script for TRNG using Digilent Nexys 4 DDR board
#
# -----------------------------------------------------------------------------
#
create_project -part xc7a100t -force trigger
#
# -----------------------------------------------------------------------------
#

#read_vhdl postprocessor.vhdl
#read_vhdl rng1.vhdl
#read_vhdl noise1.vhdl -vhdl2008
#read_vhdl SEPA.vhdl
#read_vhdl uart_tx.vhd
#read_vhdl main.vhdl
#read_vhdl 7seg.vhdl
#read_vhdl 7display.vhdl
read_vhdl trigger.vhdl -vhdl2008

read_xdc  trigger.xdc

#
# -----------------------------------------------------------------------------
#
synth_design -top trigger
#
# -----------------------------------------------------------------------------
#

opt_design
place_design
route_design

#
# -----------------------------------------------------------------------------
#
write_bitstream -force trigger.bit
#
# -----------------------------------------------------------------------------
