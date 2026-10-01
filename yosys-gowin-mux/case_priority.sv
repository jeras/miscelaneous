module top #(
    parameter int WIDTH = 1,
    parameter int WIDTH_S = 8
)(
    input  logic [WIDTH-1:0] a, b, c, d, e, f, g, h,
    input  logic [WIDTH_S-1:0] s,
    output logic [WIDTH-1:0] y
);

    always_comb
    priority casex (s)
        8'b???????1: y = a;
        8'b??????10: y = b;
        8'b?????100: y = c;
        8'b????1000: y = d;
        8'b???10000: y = e;
        8'b??100000: y = f;
        8'b?1000000: y = g;
        8'b10000000: y = h;
        default:     y = 'x;
    endcase

endmodule
