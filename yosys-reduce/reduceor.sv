module reduceor #(
    parameter int unsigned WIDTH = 8
)(
    input  logic [WIDTH-1:0] vec_i,
    output logic             or_o
);

    always_comb
    begin
        or_o = 1'b0;
        for (int unsigned i=0; i<WIDTH; i++)  or_o |= vec_i[i];
    end

//    assign or_o = |vec_i;

endmodule