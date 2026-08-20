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

wire [WIDTH-1:0] T;

prefix_or #(WIDTH) thermometer (A, T);
assign Y = T & ~(T << 1);

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
