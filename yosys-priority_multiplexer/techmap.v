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
wire [WIDTH-1:0] MUX;

// parallel prefix OR transforms the priority select into a thermometer encoded signal
prefix_or #(.WIDTH (WIDTH)) thermometer (S, TER);
// bitwise OR between priority select and shifted thermometer select results in one-hot select
assign OHT = S & (TER << 1);
// an encoder (OR type) converts a one-hot vector into the index of the hot input
\$encode_or #(.A_WIDTH (WIDTH), .S_WIDTH (S_WIDTH)) encoder (.A (OHT), .S (BIN));

// binary controlled multiplexer
// if none of the select signals is active, the thermometer MSB bit is zero
\$bmux #(.WIDTH (WIDTH), .S_WIDTH ($clog2(S_WIDTH))) multiplexer (.A (B), .S (BIN), .Y (MUX));
assign Y = TER[WIDTH-1] ? MUX : A;

endmodule

module prefix_or (A, Y);

parameter WIDTH = 0;

input [WIDTH-1:0] A;
output [WIDTH-1:0] Y;

assign Y = A | (Y << 1);

endmodule

module onehot_prefix_or (A, Y);

parameter WIDTH = 0;

input [WIDTH-1:0] A;
output [WIDTH-1:0] Y;

wire [WIDTH-1:0] S;

// parallel prefix
\$sum #(.A_WIDTH (WIDTH), .B_WIDTH (WIDTH), .Y_WIDTH (WIDTH)) adder (.A (~A), .B (1), .Y (S));
assign Y = A & S;

endmodule

module encode_or (A, S);

parameter A_WIDTH = 0;
parameter S_WIDTH = $clog2(A_WIDTH);

input [A_WIDTH-1:0] A;
output [S_WIDTH-1:0] S;

always_comb begin
    Y = '0;
    for (int i = 0; i < A_WIDTH; i++) begin
        if (A[i]) begin
            Y |= i[S_WIDTH-1:0];
        end
    end
end

endmodule
