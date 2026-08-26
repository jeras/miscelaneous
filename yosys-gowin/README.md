# Gowin FPGA mapping primitives to ALU

This would be some preliminary results.

After looking at the ALU schematic for some time I was wandering whether the LU4+LUT2 setup would allow me to do anything useful.
After writing a logic table things became clearer.

## `$reduce_and`

```
CIN = 1'b1;
result = COUT;
```

| idx | `D` `C`   `B` `A`   |   AND   | OR  |
|-----|---------------------|:-------:|:---:|
| `0` | `0` `0` **`0` `0`** | **`0`** |     |
| `1` | `0` `0` **`0` `1`** | **`0`** |     |
| `2` | `0` `0` **`1` `0`** | **`0`** |     |
| `3` | `0` `0` **`1` `1`** | **`0`** |     |
| `4` | `0` `1`   `0` `0`   |   `0`   |     |
| `5` | `0` `1`   `0` `1`   |   `0`   |     |
| `6` | `0` `1`   `1` `0`   |   `0`   |     |
| `7` | `0` `1`   `1` `1`   |   `0`   |     |
| `8` | `1` `0`   `0` `0`   |   `0`   | `1` |
| `9` | `1` `0`   `0` `1`   |   `0`   | `0` |
| `A` | `1` `0`   `1` `0`   |   `0`   | `0` |
| `B` | `1` `0`   `1` `1`   |   `0`   | `0` |
| `C` | `1` `1`   `0` `0`   |   `0`   | `0` |
| `D` | `1` `1`   `0` `1`   |   `0`   | `0` |
| `E` | `1` `1`   `1` `0`   |   `0`   | `0` |
| `F` | `1` `1`   `1` `1`   |   `1`   | `0` |

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