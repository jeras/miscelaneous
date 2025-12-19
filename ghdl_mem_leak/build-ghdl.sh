#!/usr/bin/env bash

#GHDL=ghdl
GHDL=/home/izi/VLSI/ghdl/ghdl_mcode

$GHDL --version
$GHDL -i --std=08 rams_init_file_tb.vhd
$GHDL -m --std=08 rams_init_file_tb
$GHDL -r --std=08 rams_init_file_tb --stop-time=4ms
