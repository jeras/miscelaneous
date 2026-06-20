# `proc` is not infering `$_DLATCH_[NP][NP][01]_` type lathes properly

To reproduce the issue run:
```
yosys yosys_latch.ys
```

I wrote the [latch RTL](yosys_latch.sv) according to the [example from documentation](https://yosyshq.readthedocs.io/projects/yosys/en/latest/cell/gate_reg_latch.html#latch-cells).

```
    // delay latch
    always_latch
    if      (~dlatch_pn0_rn) dlatch_pn0_q <= 1'b0;
    else if ( dlatch_pn0_g ) dlatch_pn0_q <= dlatch_pn0_d;

    // delay latch
    always @*
    if      (dlatch_nn0_rn == 1'b0) dlatch_nn0_q <= 1'b0;
    else if (dlatch_nn0_gn == 1'b0) dlatch_nn0_q <= dlatch_nn0_d;
```

After `proc` the two `$_DLATCH_[NP]_` type lathes are inferred correctly,
while the lathes with reset (`$_DLATCH_[NP][NP][01]_`) are not,
instead they are interpreted as a lath without reset and some extra logic.

See the results in exported files `proc.v`, `techmap.v`.

The example should also perform a technology map to `sky130` HD latch cells,
and it does so correctly for the two `$_DLATCH_[NP]_` latches.

In the exported verilog files the `=` operator is used instead of `<=`,
there is a chance this might cause warnings in some tools (simulators),
but this is just speculation,
this are probably the first latches I wrote intentionally.

## Cell mapping tables

| world | tech         |`C`|`E`|`S`|`R`|`Q` | sky130 HD | sky130 HDLL | sky130 HS/MS/LS | sky130 HVL | gf180mcu mcu7t5v0
|-------|--------------|---|---|---|---|----|-----------|-------------|-----------------|------------|
| `$ff` | `$_FF_`      |     
|       | `$_DFFSR_
|       | `$_DFF_P_`   |`P`|   |   |   |`P` | `dfxtp`   |             | `dfxtp`         | `dfxtp`    |
|       | `$_DFF_N_`   |`N`|   |   |   |*   |           |             |                 |            |
|       | `$_DFFE_PP_` |`P`|`P`|   |   |`P` | `edfxtp`  |             | `edfxtp`        |            |
|       |              |`P`|   |   |   |`PN`| `dfxbp`   |             | `dfxbp`         | `dfxbp`    |
|       |              |`P`|`P`|   |   |`PN`| `edfxbp`  |             | `edfxbp`        |            |
|       | `$_DFF_NN0_` |`N`|   |   |`N`|`P` | `dfrtn`   |             | `dfrtn`         |            | 
|       | `$_DFF_PN0_` |`P`|   |   |`N`|`P` | `dfrtp`   | `dfrtp`     | `dfrtp`         | `dfrtp`    | 
|       |              |`P`|   |   |`N`|`PN`| `dfrbp`   |             | `dfrbp`         |            | 
|       | `$_DFF_PN1_` |`P`|   |`N`|   |`P` | `dfstp`   | `dfstp`     | `dfstp`         | `dfstp`    | 
|       |              |`P`|   |`N`|   |`PN`| `dfsbp`   |             | `dfsbp`         | `dfsbp`    | 

|       | ?            |`P`|   |`N`|`N`|`PN`| `dfbbn`   |             | `dfbbn`         |            | 
|       | ?            |`N`|   |`N`|`N`|`PN`| `dfbbp`   |             | `dfbbp`         |            | 

| world     | tech            |`G`|`E`|`S`|`R`|`Q` | sky130 HD | sky130 HDLL | sky130 HS/MS/LS | sky130 HVL | gf180mcu `mcu7t5v0`/`mcu9t5v0` |
|-----------|-----------------|---|---|---|---|----|-----------|-------------|-----------------|------------|--------------------------------|
| `$dlatch` | `$_DLATCH_P_`   |`P`|   |   |   |`P` |                                                        | `latq`                         |
| `$dlatch` | `$_DLATCH_PN0_` |`P`|   |   |`N`|`P` |                                                        | `latrnq`                       |
| `$dlatch` | `$_DLATCH_PN1_` |`P`|   |`N`|   |`P` |                                                        | `latsnq`                       |
| `$dlatch` | `$_DLATCH_PNN_` |`P`|   |`N`|`N`|`P` |                                                        | `latrsnq`                      |

|       | `$_DFF_P_`   |`P`|   |   |   | `sky130_fd_sc_hd__` | `sky130_fd_sc_*__` | `sky130_fd_sc_hvl__` | 

gf180mcu_fd_sc_mcu7t5v0__dffnq_1
gf180mcu_fd_sc_mcu7t5v0__dffnrnq_1
gf180mcu_fd_sc_mcu7t5v0__dffnrsnq_1
gf180mcu_fd_sc_mcu7t5v0__dffnsnq_1
gf180mcu_fd_sc_mcu7t5v0__dffq_1
gf180mcu_fd_sc_mcu7t5v0__dffrnq_1
gf180mcu_fd_sc_mcu7t5v0__dffrsnq_1
gf180mcu_fd_sc_mcu7t5v0__dffsnq_1
