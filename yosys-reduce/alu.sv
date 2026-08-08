module alu #(
    parameter int unsigned WIDTH = 8
)(
    input  logic [WIDTH-1:0] opa,
    input  logic [WIDTH-1:0] opb,
    output logic [WIDTH-1:0] sum,
    output logic             gr,
    output logic             eq
);
    logic [WIDTH-0:0] tmp;
    assign tmp = (WIDTH+1)'(opa) + (WIDTH+1)'(opb);
    assign sum = WIDTH'(tmp);
    assign gr  = tmp[WIDTH];
    assign eq  = sum == '0;
endmodule