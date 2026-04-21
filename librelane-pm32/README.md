# LibreLane `pm32` example

```sh
nix-shell .../librelane/shell.nix
```

First synthesize/place/route/... using LibreLane,
the results placed into the `runs/latest` folder.

```sh
librelane --run-tag latest config.json
librelane --run-tag latest_sky130_fd_sc_hd --scl sky130_fd_sc_hd config.json
librelane --run-tag latest_sky130_fd_sc_lp --scl sky130_fd_sc_lp config.json
```

The interconnect and PVT corners are a variable in the `test.sh` file.
The tests (RTL and netlist simulation) can be run using `cvc` (not working), `questa` or `iverilog` (default).
The main output for the test is a VCD file of a netlist simulation annotated with a SDF for a given corner.

```sh
./test.sh iverilog
```

The script also creates an OpenSTA TCL script.

```sh
sta opensta_power.tcl
```
