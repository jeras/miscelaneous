#! /bin/bash

yosys bmux.ys

nextpnr-himbaechel --json   bmux.json \
                   --device 'GW1NR-LV9QN88PC6/I5' \
                   --vopt   family='GW1N-9C' \
                   --vopt   cst=tangnano9k.cst \
                   --sdc    bmux.sdc \
                   --write  bmux.pnr.json \
                   --log    bmux.pnr.log \
                   --sdf    bmux.sdf