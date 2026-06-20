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

| world | tech         |`C`|`E`|`S`|`R`|`Q` |        sky130 HD/HDLL | sky130 HS/MS/LS | sky130 HVL |
|-------|--------------|---|---|---|---|----|--------------------|------------|
| `$ff` | `$_FF_`      |     
|       | `$_DFFSR_
|       | `$_DFF_P_`   |`P`|   |   |   |`P` | `sky130_fd_sc_hd__dfxtp`  | `sky130_fd_sc_*__dfxtp`  | `sky130_fd_sc_hvl__dfxtp`  |
|       | `$_DFF_N_`   |`N`|   |   |   |*   |                           |                          |                            |
|       | `$_DFFE_PP_` |`P`|`P`|   |   |`P` | `sky130_fd_sc_hd__edfxtp` | `sky130_fd_sc_*__edfxtp` | `sky130_fd_sc_hvl__edfxtp` |
|       |              |`P`|   |   |   |`PN`| `sky130_fd_sc_hd__dfxbp`  | `sky130_fd_sc_*__dfxbp`  | `sky130_fd_sc_hvl__dfxbp`  |
|       |              |`P`|`P`|   |   |`PN`| `sky130_fd_sc_hd__edfxbp` | `sky130_fd_sc_*__edfxbp` | `sky130_fd_sc_hvl__edfxbp` |
|       | `$_DFF_NN0_` |`N`|   |   |`N`|`P` | `sky130_fd_sc_hd__dfrtn`  | `sky130_fd_sc_*__dfrtn`  | `sky130_fd_sc_hvl__dfrtn`  | 
|       | `$_DFF_PN0_` |`P`|   |   |`N`|`P` | `sky130_fd_sc_hd__dfrtp`  | `sky130_fd_sc_*__dfrtp`  | `sky130_fd_sc_hvl__dfrtp`  | 
|       |              |`P`|   |   |`N`|`PN`| `sky130_fd_sc_hd__dfrbp`  | `sky130_fd_sc_*__dfrbp`  | `sky130_fd_sc_hvl__dfrbp`  | 
|       | `$_DFF_PN1_` |`P`|   |`N`|   |`P` | `sky130_fd_sc_hd__dfstp`  | `sky130_fd_sc_*__dfstp`  | `sky130_fd_sc_hvl__dfstp`  | 
|       |              |`P`|   |`N`|   |`PN`| `sky130_fd_sc_hd__dfsbp`  | `sky130_fd_sc_*__dfsbp`  | `sky130_fd_sc_hvl__dfsbp`  | 


|       | `$_DFF_P_`   |`P`|   |   |   | `sky130_fd_sc_hd__` | `sky130_fd_sc_*__` | `sky130_fd_sc_hvl__` | 

sky130_fd_sc_hd__dfbbn_1
sky130_fd_sc_hd__dfbbp_1
dfrbp_1
sky130_fd_sc_hd__dfrtn_1
dfrtp_1
dfsbp_1
dfstp_1
dfxbp_1
dfxtp_1

edfxbp_1
edfxtp_1

sky130_fd_sc_hd__dlrbn_1
sky130_fd_sc_hd__dlrbp_1
sky130_fd_sc_hd__dlrtn_1
sky130_fd_sc_hd__dlrtp_1
sky130_fd_sc_hd__dlxbn_1
sky130_fd_sc_hd__dlxbp_1
sky130_fd_sc_hd__dlxtn_1
sky130_fd_sc_hd__dlxtp_1

HVL

dfrbp/
dfrtp/
dfsbp/
dfstp/
dfxbp/
dfxtp/
