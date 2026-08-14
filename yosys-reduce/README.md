While the essence is in the title I would like to discuss a broader set of word-level cells.

To avoid a lengthy introduction this are the main questions I would like to discuss:
1. If I created a PR adding `$prefix_or`/`$prefix_and`/`$prefix_xor` word-level cells to RTLIL, simulation/equivalence models, technology mapping and tests (but without Verilog inference code), would the PR be considered for merging? So the question is whether it would be worth for me to start making code edits beyond research.
2. Are there any plans to add `$reduce_*` inference for Verilog code with `for` loops (inside `always_comb`, ..., but not generate blocks) when the assignment operators are `|=`/`&=`/`^=`? Currently such a loop is mapped into an OR/AND/XOR chain.

## Proposed new word-level cells

For now I have some understanding how to handle the technology mapping and unit tests (with equivalence checking). For most of the changes I would try to use `reduce_*` as reference. I do not know yet, what effort it would take to support various optimization passes.

### Rather useful cells

* `$prefix_or`/`$prefix_and`, would be useful for implementing priority circuits, leading-zeroes/ones detector increment-decrement, magnitude comparators, ... ASIC technology mapping could be used to choose a chain or various parallel prefix implementations. FPGA technology mapping could map them to fast carry chains.
* `$suffix_xor`, can be used to implement Gray to binary conversion, ASIC technology mapping could be used to choose a chain or various parallel prefix implementations. Based on my research, FPGA fast carry chains do not support XOR.

In total I would add `$prefix_or`/`$prefix_and`/`$prefix_xor` and `$suffix_or`/`$suffix_and`/`$suffix_xor`.

### Less useful cells (one-hot to binary encoding)

* `encode_or`/`encode_and` is a classic encoder, it produces the index of the one hot bit. I am still studying what timing/area/congestion compromises are available.
* `encode_xor` is similar to the above, but for Hamming code (SECDEC, ECC, ...).

This would be less useful, since they are less common in RTL, and more likely to be written with optimized code instead of generic RTL.

I also considered `$min`/`$max`/`$sum`/`$sort` based on SystemVerilog array operators. While they are less useful, inference might be straightforward, and I did spend some time researching min/max/sort RTL/VLSI implementations.

## Inference

A ping to @povik, if he would be willing to comment.

I gave a quick look at the AST/RTLIL code (in Yosys and `sv-elab`) and it is obvious that inference of `$reduce_*` and `$prefix_*` from loops would not be as simple as looking for the Verilog unary OR/AND/XOR operator.

Similar to reduction, prefix operations can be written with just an assignment:
```SystemVerilog
assign X = A | {X[WIDTH-2:0], 1'b0};
// alternative syntax
assign X = A | (X << 1);
```

It is not uncommon to see RTL using `for` loops and assignment operators `|=`/`&=`/`^=` to write reduction and parallel prefix code.

Loop code for `$reduce_or` inference:
```SystemVerilog
module #(parameter int WIDTH = 8) (
    input  logic [WIDTH-1:0] A,
    output logic             X
);
always_comb begin
    X = 1'b0;
    for (int i=0; i<WIDTH; i++) begin
        X |= A[i];
    end
end
endmodule: reduce_or
```

Loop code for `$prefix_or` inference:
```SystemVerilog
module #(parameter int WIDTH = 8) (
    input  logic [WIDTH-1:0] A,
    output logic [WIDTH-1:0] X
);
always_comb begin
    X = A;
    for (int i=1; i<WIDTH; i++) begin
        X[i] |= X[i-1];
    end
end
endmodule: reduce_or
```
Unfortunately, there is no common practice for writing parallel prefix code, and I have seen loop contents so complex (chaotic), it was difficult to discern the intended functionality.

At first glance it seems Yosys AST code first unwraps the loop and then translates each step into RTLIL. 
This means reduction and prefix operation written as a loop are mapped to a chain implementation, instead of a reduce tree or a parallel prefix structure.

If there is a Yosys step that can extract reduce/prefix operations please tell.

PULP Platform worked on a parameterizable extract: "[We extend the extract pass to support variable width operators to match arbitrary arithmetic operations."](https://arxiv.org/pdf/2405.04257) (section III.C), but I did not check the implementation yet.
I also did not check what ABC can do about it yet.

An OR/AND/XOR encoder can be written in Verilog as:
```SystemVerilog
module encode_or #(parameter int WIDTH = 8) (
    input  logic [       WIDTH -1:0] A,
    output logic [$clog2(WIDTH)-1:0] Y
);
    always_comb begin
        Y = '0;
        for (int i = 0; i < WIDTH; i++ ) begin
            if (A[i]) begin
                Y |= i[$clog2(WIDTH)-1:0];
            end
        end
    end
endmodule
```

## Usefulness of internal cells without inference (with examples)

There is some precedent in Yosys having internal RTLIL cells without the parser being able to infer them, this is still true for some `$dlatch_*` cells. I am not sure if `$demux` can be inferred.

Such cells could be used in Verilog RTL directly and processed using `read_verilog -icells`. Simulators could use the definitions from `techlibs/common/simlib.v`.

Technology mapping `techmap` could use this cells to internally.

### Example converting `$pmux` into `$bmux`

A custom `techmap` file can be used to implement a parallel prefix structure for `$reduce_or`.

```SystemVerilog
module \$pmux (A, B, S, Y);

    parameter WIDTH = 0;
    parameter S_WIDTH = 0;

    input [WIDTH-1:0] A;
    input [WIDTH*S_WIDTH-1:0] B;
    input [S_WIDTH-1:0] S;
    output [WIDTH-1:0] Y;

    wire [S_WIDTH-1:0] TER;  // thermometer encoded select
    wire [S_WIDTH-1:0] OHT;  // one-hot encoded select
    wire [$clog2(S_WIDTH)-1:0] BIN;  // binary encoded select
    
    // parallel prefix OR transforms the priority select into a thermometer encoded signal
    assign TER = \$prefix_or(S);
    // bitwise OR between priority select and shifted thermometer select results in one-hot select
    assign OHT = S & (TER << 1);
    // an encoder (OR type) converts a one-hot vector into the index of the hot input
    assign BIN = \$encode_or(OHT);
    
    // binary controlled multiplexer
    // if none of the select signals is active, the thermometer MSB bit is zero
    assign Y = TER[WIDTH-1] ? \$bmux(B, OHT, Y);

endmodule
```

### Mapping priority to thermometer and one-hot conversion



### Magnitude comparator

