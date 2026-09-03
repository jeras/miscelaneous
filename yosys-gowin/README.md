# Gowin FPGA mapping primitives to ALU

This would be some preliminary results.

After looking at the ALU schematic for some time I was wandering whether the LU4+LUT2 setup would allow me to do anything useful.
After writing a logic table things became clearer.

## `$reduce_and`

```
CIN = 1'b1;
result = COUT;
```

| idx | `DCBA` | `BA` | AND | OR  |
|-----|--------|------|:---:|:---:|
| `0` | `0000` | `00` | `0` |     |
| `1` | `0001` | `01` | `0` |     |
| `2` | `0010` | `10` | `0` |     |
| `3` | `0011` | `11` | `0` |     |
| `4` | `0100` |      | `0` |     |
| `5` | `0101` |      | `0` |     |
| `6` | `0110` |      | `0` |     |
| `7` | `0111` |      | `0` |     |
| `8` | `1000` |      | `0` | `1` |
| `9` | `1001` |      | `0` | `0` |
| `A` | `1010` |      | `0` | `0` |
| `B` | `1011` |      | `0` | `0` |
| `C` | `1100` |      | `0` | `0` |
| `D` | `1101` |      | `0` | `0` |
| `E` | `1110` |      | `0` | `0` |
| `F` | `1111` |      | `1` | `0` |

`$reduce_and` can be modelled by setting a single bit in the LUT.
If LUT inputs `DCAB` (`I[3:0]`) match the set `LUT4` bit, `CIN` will be propagated to `COUT`.
If the LUT4 input is not a match, `COUT` is driven by the `LUT2` output, which is `0` for all combinations.

I formally tested this with a `techmap` file [`gowin/reducealu.v`](gowin/reducealu.v)
and a model of the generalized `ALU` [`gowin/CSL.v`](gowin/CSL.v).
The example is a 32-bit `$reduce_and`.

Rerun the test with:
```
yosys reducealu.ys
```

## $eq (generalization to matching against a constant)

A generalization would be to implement matching against a constant.
```
parameter logic [4-1:0] PATTERN;
logic [4-1:0] vector;

assign Y = (vector == PATTERN);

$eq(.A (vector), .B (PATTERN), .Y (Y));
```

Mapping would only be performed if `PATTERN` is a constant,
which can be chacked during `techmap` using
`_TECHMAP_CONSTMSK_<port-name>_` and `_TECHMAP_CONSTVAL_<port-name>_`.

Based on the logic table this generalization only works when `I[3:0] !== 4'b00xx`,
since `LUT2` must be set to all zeros for the carry propagation to work as desired.

`LUT4` inputs can be reordered with little timing impact,
so it should be possible to match against patterns with at least one bit set to `1`.
Further generalization would be possible by reordering inputs between ALUs in the chain,
but this would have a larger impact on timing, making low level RTL optimizations a bit unpredictable.

## `$reduce_or`

Unfortunately it seems a 4-bit `$reduce_or` can not be mapped to an ALU cell.
In my experiments with synthesis primitives `$reduce_or` and `$reduce_xor`
were used for encoders (one-hot, priority), error detection/correction.

It would still be possible to create a 3-bit mapping, if the `LUT4` input `I[3]` is set to `1`.
While not great, it might still outperform a multi layer tree structure in the FPGA.

## $reduce_xor

As expected, there seems to be no way to implement an XOR chain using ALU cells.

parameter int ALU_MODE = 2,
parameter int RAW_ALU_LUT = (ALU_MODE == 0) ? 16'b0110000001101010  // add
                          : (ALU_MODE == 1) ? 16'b1001000010011010  // sub
                          : (ALU_MODE == 2) ? 16'b0110000010011010  // addsub
                          : (ALU_MODE == 3) ? 16'b1001000010011111  // ne
                          : (ALU_MODE == 4) ? 16'b1001000010011010  // ge
                          : (ALU_MODE == 5) ? 16'b1001000010011010  // le
                          : (ALU_MODE == 6) ? 16'b1010000010100000  // cup
                          : (ALU_MODE == 7) ? 16'b0101000001011111  // cdn
                          : (ALU_MODE == 8) ? 16'b1010000001011010  // cupcdn
                          : (ALU_MODE == 9) ? 16'b0111100010001000; // mul/

| LUTx | MUXx  | LUTs | CSLs | CFUs | MUX2_LUT5 | MUX2_LUT6 | MUX2_LUT7 | MUX2_LUT8 |
|------|-------|------|------|------|-----------|-----------|-----------|-----------|
| LUT4 | MUX2  | 1    |      |      | 0         | 0         | 0         | 0         |
| LUT5 | MUX4  | 2    | 1    |      | 1         | 0         | 0         | 0         |
| LUT6 | MUX8  | 4    | 2    |      | 2         | 1         | 0         | 0         |
| LUT7 | MUX16 | 8    | 4    | 1    | 4         | 2         | 1         | 0         |
| LUT8 | MUX32 | 16   | 8    | 2    | 8         | 4         | 2         | 1         |
