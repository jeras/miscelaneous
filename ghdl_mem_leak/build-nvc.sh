#!/usr/bin/env bash

nvc --std=2008 -a rams_init_file.vhd rams_init_file_tb.vhd
nvc --std=2008 -e rams_init_file_tb
nvc --std=2008 -r rams_init_file_tb --wave=rams_init_file_tb.fst