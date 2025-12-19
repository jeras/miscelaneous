#!/usr/bin/env bash

nvc --std=2008 -a rams_init_file_tb.vhd
nvc --std=2008 -e rams_init_file_tb
nvc --std=2008 -H 64m -r rams_init_file_tb --stop-time=4ms
