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