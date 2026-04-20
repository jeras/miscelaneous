#!/usr/bin/env bash

PDK_HASH=7b70722e33c03fcb5dabcf4d479fb0822d9251c9
LAST_RUN=$(ls -td runs/*/ | head -1)

## RTL simulation
#cvc64 spm.v -sv pm32.sv pm32_tb.sv
#./cvcsim
#
## netlist simulation
#cvc64 \
#~/.ciel/ciel/sky130/versions/$PDK_HASH/sky130A/libs.ref/sky130_fd_sc_hd/verilog/primitives.v \
#~/.ciel/ciel/sky130/versions/$PDK_HASH/sky130B/libs.ref/sky130_fd_sc_hd/verilog/sky130_fd_sc_hd.v \
#$LAST_RUN/final/nl/pm32.nl.v \
#-sv pm32_tb_sdf.sv
#./cvcsim

# RTL simulation
qrun -top pm32_tb \
spm.v pm32.sv \
pm32_tb.sv

# netlist simulation
qrun -top pm32_tb_sdf \
~/.ciel/ciel/sky130/versions/$PDK_HASH/sky130A/libs.ref/sky130_fd_sc_hd/verilog/primitives.v \
sky130_fd_sc_hd.v \
$LAST_RUN/final/nl/pm32.nl.v \
pm32_tb_sdf.sv
