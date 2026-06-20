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

| world    | tech           |`C`|`E`|`S`|`R`|`Q`| sky130 HD | sky130 HDLL | sky130 [HML]S | sky130 LP | sky130 HVL | gf180mcu [79]t |
|----------|----------------|---|---|---|---|---|-----------|-------------|---------------|-----------|------------|----------------|
| `$dff`   | `$_DFF_P_`     |`P`|   |   |   |`P`| `dfxtp`   |             | `dfxtp`       | `dfxtp`   | `dfxtp`    | `dffq`         |
| `$dff`   | `$_DFF_N_`     |`N`|   |   |   |`P`|           |             |               |           |            | `dffnq`        |
| `$dffe`  | `$_DFFE_PP_`   |`P`|`P`|   |   |`P`| `edfxtp`  |             | `edfxtp`      |           |            |                |
| `$dff`   | `$_DFF_P_`     |`P`|   |   |   |`C`| `dfxbp`   |             | `dfxbp`       | `dfxbp`   | `dfxbp`    |                |
| `$dffe`  | `$_DFFE_PP_`   |`P`|`P`|   |   |`C`| `edfxbp`  |             | `edfxbp`      | `edfxbp`  |            |                |
| `$dffsr` | `$_DFF_NN0_`   |`N`|   |   |`N`|`P`| `dfrtn`   |             | `dfrtn`       | `dfrtn`   |            |                |
| `$dffsr` | `$_DFF_PN0_`   |`P`|   |   |`N`|`P`| `dfrtp`   | `dfrtp`     | `dfrtp`       | `dfrtp`   | `dfrtp`    | `dffrnq`       |
| `$dffsr` |                |`P`|   |   |`N`|`C`| `dfrbp`   |             | `dfrbp`       | `dfrbp`   |            |                |
| `$dffsr` | `$_DFF_PN1_`   |`P`|   |`N`|   |`P`| `dfstp`   | `dfstp`     | `dfstp`       | `dfstp`   | `dfstp`    | `dffsnq`       |
| `$dffsr` |                |`P`|   |`N`|   |`C`| `dfsbp`   |             | `dfsbp`       | `dfsbp`   | `dfsbp`    |                |
| `$dffsr` | `$_DFF_NN0_`   |`N`|   |   |`N`|`P`|           |             |               |           |            | `dffnrnq`      |
| `$dffsr` | `$_DFF_NN1_`   |`N`|   |`N`|   |`P`|           |             |               |           |            | `dffnsnq`      |
| `$dffsr` | `$_DFFSR_NNN_` |`N`|   |`N`|`N`|`C`| `dfbbn`   |             | `dfbbn`       | `dfbbn`   |            |                |
| `$dffsr` | `$_DFFSR_PNN_` |`P`|   |`N`|`N`|`C`| `dfbbp`   |             | `dfbbp`       | `dfbbp`   |            |                |
| `$dffsr` | `$_DFFSR_PNN_` |`P`|   |`N`|`N`|`P`|           |             |               |           |            | `dffrsnq`      |
| `$dffsr` | `$_DFFSR_NNN_` |`N`|   |`N`|`N`|`P`|           |             |               |           |            | `dffnrsnq`     |


| world       | tech            |`G`|`E`|`S`|`R`|`Q`| sky130 HD | sky130 HDLL | sky130 [HML]S | sky130 LP | sky130 HVL | gf180mcu [79]t |
|-------------|-----------------|---|---|---|---|---|-----------|-------------|---------------|-----------|------------|----------------|
| `$dlatch`   | `$_DLATCH_P_`   |`P`|   |   |   |`P`| `dlxtp`   |             | `dlxtp`       | `dlxtp`   | `dlxtp`    | `latq`         |
| `$dlatch`   | `$_DLATCH_N_`   |`N`|   |   |   |`P`| `dlxtn`   | `dlxtn`     | `dlxtn`       | `dlxtn`   |            |                |
| `$dlatch`   | `$_DLATCH_P_`   |`P`|   |   |   |`C`| `dlxbp`   |             | `dlxbp`       | `dlxbp`   |            |                |
| `$dlatch`   | `$_DLATCH_N_`   |`N`|   |   |   |`C`| `dlxbn`   |             | `dlxbn`       | `dlxbn`   |            |                |
| `$dlatchsr` | `$_DLATCH_PN0_` |`P`|   |   |`N`|`P`| `dlrtp`   | `dlrtp`     | `dlrtp`       | `dlrtp`   |            | `latrnq`       |
| `$dlatchsr` | `$_DLATCH_NN0_` |`N`|   |   |`N`|`P`| `dlrtn`   | `dlrtn`     | `dlrtn`       | `dlrtn`   |            |                |
| `$dlatchsr` | `$_DLATCH_PN0_` |`P`|   |   |`N`|`C`| `dlrbp`   |             | `dlrbp`       | `dlrbp`   |            |                |
| `$dlatchsr` | `$_DLATCH_NN0_` |`N`|   |   |`N`|`C`| `dlrbn`   |             | `dlrbn`       | `dlrbn`   |            |                |
| `$dlatchsr` | `$_DLATCH_PN1_` |`P`|   |`N`|   |`P`|           |             |               |           |            | `latsnq`       |
| `$dlatchsr` | `$_DLATCH_PNN_` |`P`|   |`N`|`N`|`P`|           |             |               |           |            | `latrsnq`      |
