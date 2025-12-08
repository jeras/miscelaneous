#!/usr/bin/env bash

ghdl -i --std=08 rams_init_file.vhd rams_init_file_tb.vhd
ghdl -m --std=08 rams_init_file_tb
ghdl -r --std=08 rams_init_file_tb --wave=rams_init_file_tb.ghw
#  --max-stack-alloc=0 \
#  --ieee-asserts=disable \
#  --assert-level=error \
#  --stop-time=1000ms
