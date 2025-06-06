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
            onehot = suffix & ~{1'b0, suffix[WIDTH-1:1]};
            // conversion from onehot to binary
            msb_pos = '0;
            for (int unsigned i=0; i<WIDTH; i++) begin
                msb_pos |= onehot[i] ? i[WIDTH_LOG-1:0] : WIDTH_LOG'('0);
            end
        end

    end: naive
    else begin: fpga

        logic [WIDTH-1:0] Sum_mag_rev;
        logic [WIDTH-1:0] Sum_mag_rev_neg_inc;
        logic [WIDTH-1:0] onehot_rev;
        logic [WIDTH-1:0] onehot;

        always_comb
        begin
            // bit reverse
            Sum_mag_rev = {<<{Sum_mag}};
            // parallel suffix
            Sum_mag_rev_neg_inc = (~Sum_mag_rev)+1;
            onehot_rev = Sum_mag_rev & Sum_mag_rev_neg_inc;
            // conversion from thermometer to one-hot
            onehot = {<<{onehot_rev}};
            // conversion from onehot to binary
            msb_pos = '0;
            for (int unsigned i=0; i<WIDTH; i++) begin
                msb_pos |= onehot[i] ? i[WIDTH_LOG-1:0] : WIDTH_LOG'('0);
            end
        end

    end: fpga
    endgenerate

endmodule: leading_1_in_mantisa

