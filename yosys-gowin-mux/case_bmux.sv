module top #(
    parameter int WIDTH = 1
)(
    input  logic [WIDTH-1:0] a, b, c, d, e, f, g, h,
    input  logic [3-1:0] s,
    output logic [WIDTH-1:0] y
);

    always_comb
    casex (s)
//        3'b000: y = a;
//        3'b001: y = b;
//        3'b010: y = c;
//        3'b011: y = d;
        3'b011: y = d;
        3'b0??: y = a;
        3'b100: y = e;
        3'b101: y = f;
        3'b110: y = g;
        3'b111: y = h;
        default: y = 'x;
    endcase

//    always_comb
//    casex (s)
//        3'b111: y = h;
//        3'b110: y = g;
//        3'b101: y = f;
//        3'b100: y = e;
//        3'b011: y = d;
//        3'b0??: y = a;
//        default: y = 'x;
//    endcase

endmodule
