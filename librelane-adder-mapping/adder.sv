module adder #(
    parameter int unsigned WIDTH = 8
)(
    input  logic [WIDTH-1:0] opa,
    input  logic [WIDTH-1:0] opb,
    output logic [WIDTH-1:0] sum
);
    assign sum = opa + (* map="RCA" *) opb;
endmodule: adder
