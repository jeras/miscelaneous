# LibreLane `pm32` example

```sh
nix-shell .../librelane/shell.nix
```

First synthesize/place/route/... using LibreLane,
the results placed into the `runs/latest` folder.

```sh
librelane --run-tag latest config.json
librelane --run-tag latest_sky130_fd_sc_hd --scl sky130_fd_sc_hd config.json
librelane --run-tag latest_sky130_fd_sc_hdll --scl sky130_fd_sc_hdll config.json
librelane --run-tag latest_sky130_fd_sc_hs --scl sky130_fd_sc_hs config.json
librelane --run-tag latest_sky130_fd_sc_ms --scl sky130_fd_sc_ms config.json
librelane --run-tag latest_sky130_fd_sc_ls --scl sky130_fd_sc_ls config.json
librelane --run-tag latest_sky130_fd_sc_lp --scl sky130_fd_sc_lp config.json
```

The interconnect and PVT corners are a variable in the `test.sh` file.
The tests (RTL and netlist simulation) can be run using `cvc` (not working), `questa` or `iverilog` (default).
The main output for the test is a VCD file of a netlist simulation annotated with a SDF for a given corner.

```sh
./test.sh --sim iverilog --pdk ~/.ciel/sky130A --scl sky130_fd_sc_hd --run runs/latest_sky130_fd_sc_hd --interconnect nom --corner tt_025C_1v80 --cells sky130_fd_sc_hd.v
./test.sh --sim questa   --pdk ~/.ciel/sky130A --scl sky130_fd_sc_hd --run runs/latest_sky130_fd_sc_hd --interconnect nom --corner tt_025C_1v80 --cells sky130_fd_sc_hd.v
```

The script also creates an OpenSTA TCL script.

```sh
sta opensta_power.tcl
```
