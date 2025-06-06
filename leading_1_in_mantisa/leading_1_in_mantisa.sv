module leading_1_in_mantisa #(
    parameter  int unsigned WIDTH = 24,
    localparam int unsigned WIDTH_LOG = $clog2(WIDTH),
    parameter string IMPLEMENTATION = "NAIVE" // the other option is "FPGA"
)(
    input  logic [WIDTH    -1:0] Sum_mag,
    output logic [WIDTH_LOG-1:0] msb_pos
);

    generate
    if (IMPLEMENTATION == "NAIVE") begin: naive

        logic [WIDTH-1:0] suffix;
        logic [WIDTH-1:0] onehot;

        always_comb
        begin
            // parallel suffix
            suffix[WIDTH-1] = Sum_mag[WIDTH-1];
            for (int i=WIDTH-1; i>0; i--) begin
                suffix[i-1] = Sum_mag[i-1] | suffix[i];
            end
            // conversion from thermometer to one-hot
            assign onehot = suffix & ~{1'b0, suffix[WIDTH-1:1]};
            // conversion from onehot to binary
            msb_pos = '0;
            for (int unsigned i=0; i<WIDTH; i++) begin
                msb_pos |= onehot[i] ? i[WIDTH_LOG-1:0] : WIDTH_LOG'('0);
            end
        end

    end: naive
    else begin: fpga

    end: fpga
    endgenerate

endmodule: leading_1_in_mantisa

