module binary2thermometer #(
    parameter int unsigned WIDTH = 4,
    parameter string       IMPLEMENTATION = "POWER"  // supported "POWER"/"SHIFT"
)(
    input  logic                       clk,
    input  logic [$clog2(WIDTH+1)-1:0] binary,
    input  logic [       WIDTH   -1:0] data_i,
    output logic [       WIDTH   -1:0] data_o
//    output logic [       WIDTH   -1:0] thermometer
);

    generate
    for (genvar i=0; i<WIDTH; i++) begin
        case (IMPLEMENTATION)
            "POWER": begin
                always @(posedge clk)
                if (i < (2**binary))  data_o[i] <= data_i[i];
            end
	    "SHIFT": begin
                always @(posedge clk)
                if (i < (1<<binary))  data_o[i] <= data_i[i];
            end
        endcase
    end
    endgenerate

endmodule: binary2thermometer

