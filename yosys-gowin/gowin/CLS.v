module CLS #(parameter [16-1:0] LUT = 'x)(
    input  wire I0, I1, I2, I3,
	input  wire CIN,
	output wire COUT,
	output wire SUM
);

	localparam [16-1:0] LUT4 = LUT[16-1:0];
	localparam [ 4-1:0] LUT2 = LUT[ 4-1:0];

	wire lut4, lut2;

	assign lut4 = LUT4[{I3, I2, I1, I0}];
	assign lut2 = LUT2[        {I1, I0}];

	assign SUM = lut4 ^ CIN;
	assign COUT = lut4 ? CIN : lut2;
//	assign COUT = (CIN & lut4) | (~lut4 & lut2);

endmodule
