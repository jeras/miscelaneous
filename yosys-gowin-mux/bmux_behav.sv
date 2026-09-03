module top #(
    parameter int unsigned WIDTH = 1,
    parameter int unsigned S_WIDTH = 3
)(
    input  logic [S_WIDTH-1:0] S,
    input  logic [2**S_WIDTH*WIDTH-1:0] A,
    output logic [WIDTH-1:0] Y
);

    assign Y = A[S*WIDTH+:WIDTH];
/*
    generate
    case (S_WIDTH)
        2: MUX4 mux (
               .I0 (A[0]),
               .I1 (A[1]),
               .I2 (A[2]),
               .I3 (A[3]),
               .S0 (S[0]),
               .S1 (S[1]),
               .O  (Y)
           );
        3: MUX8 mux (
               .I0 (A[0]),
               .I1 (A[1]),
               .I2 (A[2]),
               .I3 (A[3]),
               .I4 (A[4]),
               .I5 (A[5]),
               .I6 (A[6]),
               .I7 (A[7]),
               .S0 (S[0]),
               .S1 (S[1]),
               .S2 (S[2]),
               .O  (Y)
           );
    endcase
    endgenerate
*/

endmodule
