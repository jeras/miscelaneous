module loop #(
    parameter int unsigned WIDTH = 4,
    parameter int unsigned BYTE = 2,
    parameter string       IMPLEMENTATION = "ALWAYS"  // supported "ALWAYS"/"GENERATE"
)(
    input  logic                  clk,
    input  logic      [WIDTH-1:0] enable,
    input  logic [BYTE*WIDTH-1:0] data_i,
    output logic [BYTE*WIDTH-1:0] data_o
);

    generate
    case (IMPLEMENTATION)
        "ALWAYS": begin
            always_ff @(posedge clk)
            begin
                for (int unsigned i=0; i<WIDTH; i++) begin
                    if (enable[i])  data_o[i*BYTE+:BYTE] <= data_i[i*BYTE+:BYTE];
                end
            end
        end
	    "GENERATE": begin
            for (genvar i=0; i<WIDTH; i++) begin
                always_ff @(posedge clk)
                begin
                    if (enable[i])  data_o[i*BYTE+:BYTE] <= data_i[i*BYTE+:BYTE];
                end
            end
        end
    endcase
    endgenerate

endmodule: loop
