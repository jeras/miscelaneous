module prefixor #(
    parameter int unsigned WIDTH = 8
)(
    input  logic [WIDTH-1:0] vec_i,
    output logic [WIDTH-1:0] por_o
);

//    always_comb
//    begin
//        or_o = 1'b0;
//        for (int unsigned i=0; i<WIDTH; i++)  or_o |= vec_i[i];
//    end

    assign por_o = vec_i | {por_o[WIDTH-2:0], 1'b0};

endmodule