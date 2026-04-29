# LibreLane `pm32` example

```sh
nix-shell .../librelane/shell.nix
```

To select a PKD version first use `ciel` to fetch/enable it:

```sh
ciel fetch  --pdk-family sky130 c95f23a75038d54d60ecc7ca060f53851f8f25e5
ciel enable --pdk-family sky130 c95f23a75038d54d60ecc7ca060f53851f8f25e5
ciel ls --pdk-family sky130
```

To build/enable a PDK which has already been committed to [open_pdks](),
but not yet published do:

```sh
ciel build --pdk-family sky130 e2f6d053cc04966ddb857a3cc0d101bff7654ffa
ciel enable --pdk-family sky130 e2f6d053cc04966ddb857a3cc0d101bff7654ffa
```

Somehow enabling a PDK using `ciel` does not persuade LibreLane to use it,
you also have to change the hash in the LibreLane file `librelane/pdk_hashes.yaml`.

To rebuild a local version of the library use:

```sh
ciel build --pdk-family sky130 e11f4c42613de5269371782324cca97762f67401 --use-repo-at open_pdks=../../PDK/open_pdks/ --use-repo-at sky130_fd_sc_hdll=../../PDK/skywater-pdk-libs-sky130_fd_sc_hdll/ -l all
```

It might be better to compile with `-l sky130_fd_sc_hdll` and without (to get defaults) to speed up the build.

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

./test.sh --sim questa   --pdk ~/.ciel/sky130A --scl sky130_fd_sc_hdll --run runs/latest_sky130_fd_sc_hdll --interconnect nom --corner tt_025C_1v80

./test.sh --sim questa   --pdk ~/.ciel/sky130A --scl sky130_fd_sc_hs --run runs/latest_sky130_fd_sc_hs --interconnect nom --corner tt_025C_1v80
./test.sh --sim questa   --pdk ~/.ciel/sky130A --scl sky130_fd_sc_ms --run runs/latest_sky130_fd_sc_ms --interconnect nom --corner tt_025C_1v80
./test.sh --sim questa   --pdk ~/.ciel/sky130A --scl sky130_fd_sc_ls --run runs/latest_sky130_fd_sc_ls --interconnect nom --corner tt_025C_1v80

```

The script also creates an OpenSTA TCL script.

```sh
sta opensta_power.tcl
```
