#!/usr/bin/env bash

ghdl -i --std=08 rams_init_file.vhd rams_init_file_tb.vhd
ghdl -m --std=08 rams_init_file_tb
ghdl -r --std=08 rams_init_file_tb
#  --max-stack-alloc=0 \
#  --ieee-asserts=disable \
#  --assert-level=error \
#  --stop-time=4ms
