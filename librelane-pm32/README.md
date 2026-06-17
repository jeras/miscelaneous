# LibreLane `pm32` example

```sh
nix-shell ../../librelane/shell.nix
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
ciel build --pdk-family sky130 e11f4c42613de5269371782324cca97762f67401 --use-repo-at open_pdks=../../PDK/open_pdks/ -l all
ciel build --pdk-family ihp-sg13g2 5048f974d267530ca038e208cab183ee4e548c9e --use-repo-at open_pdks=../../IHP-Open-PDK
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
| sky130_fd_sc_hd       | sky130_fd_sc_hdll     | named corner |
|-----------------------|-----------------------|--------------|
| ff_100C_1v65          | ff_100C_1v65          |              |
| ff_100C_1v95          | ff_100C_1v95          | fast         |
| ff_n40C_1v56          | ff_n40C_1v56          |              |
| ff_n40C_1v65          | ff_n40C_1v65          |              |
| ff_n40C_1v76          |                       |              |
| ff_n40C_1v95          | ff_n40C_1v95          |              |
| ff_n40C_1v95_ccsnoise | ff_n40C_1v95_ccsnoise |              |
| ss_100C_1v40          |                       |              |
| ss_100C_1v60          | ss_100C_1v60          | slow         |
| ss_n40C_1v28          | ss_n40C_1v28          |              |
| ss_n40C_1v35          |                       |              |
| ss_n40C_1v40          |                       |              |
| ss_n40C_1v44          | ss_n40C_1v44          |              |
| ss_n40C_1v60          | ss_n40C_1v60          |              |
| ss_n40C_1v60_ccsnoise | ss_n40C_1v60_ccsnoise |              |
| ss_n40C_1v76          | ss_n40C_1v76          |              |
| tt_025C_1v80          | tt_025C_1v80          | typical      |
| tt_100C_1v80          |                       |              |


| sky130_fd_sc_hs       | sky130_fd_sc_ms       | sky130_fd_sc_ls                          | named corner |
|-----------------------|-----------------------|------------------------------------------|--------------|
|                       |                       | ff_085C_1v95                             |              |
|                       | ff_085C_1v95_pwrlkg   |                                          |              |
|                       | ff_100C_1v65          |                                          |              |
|                       |                       | ff_100C_1v65_dest1v76_destvpb1v76_ka1v76 |              |
| ff_100C_1v95          | ff_100C_1v95          | ff_100C_1v95                             |              |
|                       | ff_100C_1v95_pwrlkg   |                                          |              |
| ff_150C_1v95          | ff_150C_1v95          | ff_150C_1v95                             |              |
| ff_n40C_1v56          | ff_n40C_1v56          | ff_n40C_1v56                             |              |
|                       | ff_n40C_1v65_ka1v76   | ff_n40C_1v65_dest1v76_destvpb1v76_ka1v76 |              |
| ff_n40C_1v76          | ff_n40C_1v76          | ff_n40C_1v76                             |              |
| ff_n40C_1v95          | ff_n40C_1v95          | ff_n40C_1v95                             | fast         |
| ff_n40C_1v95_ccsnoise | ff_n40C_1v95_ccsnoise | ff_n40C_1v95_ccsnoise                    |              |
|                       | ff_n40C_1v95_pwrlkg   |                                          |              |
|                       |                       | ss_100C_1v40                             |              |
| ss_100C_1v60          | ss_100C_1v60          | ss_100C_1v60                             | slow         |
| ss_150C_1v60          | ss_150C_1v60          | ss_150C_1v60                             |              |
| ss_n40C_1v28          | ss_n40C_1v28          | ss_n40C_1v28                             |              |
|                       |                       | ss_n40C_1v35                             |              |
|                       |                       | ss_n40C_1v40                             |              |
| ss_n40C_1v44          | ss_n40C_1v44          | ss_n40C_1v44                             |              |
| ss_n40C_1v60          | ss_n40C_1v60          | ss_n40C_1v60                             |              |
| ss_n40C_1v60_ccsnoise | ss_n40C_1v60_ccsnoise | ss_n40C_1v60_ccsnoise                    |              |
|                       |                       | ss_n40C_1v76                             |              |
| tt_025C_1v20          |                       |                                          |              |
| tt_025C_1v35          |                       |                                          |              |
| tt_025C_1v44          |                       |                                          |              |
| tt_025C_1v50          |                       |                                          |              |
| tt_025C_1v62          |                       |                                          |              |
| tt_025C_1v68          |                       |                                          |              |
| tt_025C_1v80          | tt_025C_1v80          | tt_025C_1v80                             | typical      |
| tt_025C_1v80_ccsnoise | tt_025C_1v80_ccsnoise | tt_025C_1v80_ccsnoise                    |              |
| tt_025C_1v89          |                       |                                          |              |
| tt_025C_2v10          |                       |                                          |              |
| tt_100C_1v80          | tt_100C_1v80          | tt_100C_1v80                             |              |
| tt_150C_1v80          |                       |                                          |              |

| sky130_fd_sc_lp | named corner |
|-----------------|--------------|
| ff_100C_1v95    |              |
| ff_125C_3v15    |              |
| ff_140C_1v95    |              |
| ff_150C_2v05    |              |
| ff_n40C_1v56    |              |
| ff_n40C_1v76    |              |
| ff_n40C_1v95    | fast         |
| ff_n40C_2v05    |              |
| ss_100C_1v60    | slow         |
| ss_140C_1v65    |              |
| ss_150C_1v65    |              |
| ss_n40C_1v55    |              |
| ss_n40C_1v60    |              |
| ss_n40C_1v65    |              |

| sky130_fd_sc_hvl                     | named corner |
|--------------------------------------|--------------|
| ff_085C_5v50                         |              |
| ff_085C_5v50_lv1v95                  |              |
| ff_100C_5v50                         |              |
| ff_100C_5v50_lowhv1v65_lv1v95        |              |
| ff_100C_5v50_lv1v95                  |              |
| ff_150C_5v50                         |              |
| ff_150C_5v50_lv1v95                  |              |
| ff_n40C_4v40                         |              |
| ff_n40C_4v40_lv1v95                  |              |
| ff_n40C_4v95                         |              |
| ff_n40C_4v95_lv1v95                  |              |
| ff_n40C_5v50                         | fast         |
| ff_n40C_5v50_ccsnoise                |              |
| ff_n40C_5v50_lowhv1v65_lv1v95        |              |
| ff_n40C_5v50_lv1v95                  |              |
| ff_n40C_5v50_lv1v95_ccsnoise         |              |
| hvff_lvss_100C_5v50_lowhv1v65_lv1v60 |              |
| hvff_lvss_100C_5v50_lv1v40           |              |
| hvff_lvss_100C_5v50_lv1v60           |              |
| hvff_lvss_n40C_5v50_lowhv1v65_lv1v60 |              |
| hvff_lvss_n40C_5v50_lv1v35           |              |
| hvff_lvss_n40C_5v50_lv1v60           |              |
| hvss_lvff_100C_1v65                  |              |
| hvss_lvff_100C_1v95                  |              |
| hvss_lvff_100C_1v95_lowhv1v65        |              |
| hvss_lvff_100C_5v50_lowhv1v65_lv1v95 |              |
| hvss_lvff_n40C_1v65                  |              |
| hvss_lvff_n40C_1v95                  |              |
| hvss_lvff_n40C_1v95_lowhv1v65        |              |
| hvss_lvff_n40C_5v50_lowhv1v65_lv1v95 |              |
| ss_100C_1v65                         |              |
| ss_100C_1v65_lv1v40                  |              |
| ss_100C_1v65_lv1v60                  |              |
| ss_100C_1v95                         |              |
| ss_100C_2v40_lowhv1v65_lv1v60        |              |
| ss_100C_2v70_lowhv1v65_lv1v60        |              |
| ss_100C_3v00                         |              |
| ss_100C_3v00_lowhv1v65_lv1v60        |              |
| ss_100C_5v50_lowhv1v65_lv1v60        |              |
| ss_150C_1v65                         | slow         |
| ss_150C_1v65_lv1v60                  |              |
| ss_150C_3v00_lowhv1v65_lv1v60        |              |
| ss_n40C_1v32                         |              |
| ss_n40C_1v32_lv1v28                  |              |
| ss_n40C_1v49                         |              |
| ss_n40C_1v49_lv1v44                  |              |
| ss_n40C_1v65                         |              |
| ss_n40C_1v65_ccsnoise                |              |
| ss_n40C_1v65_lv1v35                  |              |
| ss_n40C_1v65_lv1v40                  |              |
| ss_n40C_1v65_lv1v60                  |              |
| ss_n40C_1v65_lv1v60_ccsnoise         |              |
| ss_n40C_1v95                         |              |
| ss_n40C_5v50_lowhv1v65_lv1v60        |              |
| tt_025C_2v64_lv1v80                  |              |
| tt_025C_2v97_lv1v80                  |              |
| tt_025C_3v30                         | typical      |
| tt_025C_3v30_lv1v80                  |              |
| tt_100C_3v30                         |              |
| tt_100C_3v30_lv1v80                  |              |
| tt_150C_3v30_lv1v80                  |              |
