module INV (input I, output O);
	LUT1 #(.INIT(2'b01)) lut1 (.F(O), .I0(I));
endmodule

module LUT1 #(parameter [1:0] INIT = 2'b00) (output F, input I0);
	localparam [15:0] INIT4 = { {8{INIT[1]}}, {8{INIT[0]}} };
	LUT4 #(.INIT(INIT4)) lut1 (.F(F), .I0(1'b0), .I1(1'b0), .I2(1'b0), .I3(I0));
endmodule

module LUT2 #(parameter [3:0] INIT = 4'b0000) (output F, input I0, I1);
	localparam [15:0] INIT4 = { {4{INIT[3]}}, {4{INIT[2]}}, {4{INIT[1]}}, {4{INIT[0]}} };
	LUT4 #(.INIT(INIT4)) lut2 (.F(F), .I0(1'b0), .I1(1'b0), .I2(I0), .I3(I1));
endmodule

module LUT3 #(parameter [7:0] INIT = 8'b0000_0000) (output F, input I0, I1, I2);
	localparam [15:0] INIT4 = { {2{INIT[7]}}, {2{INIT[6]}}, {2{INIT[5]}}, {2{INIT[4]}}, {2{INIT[3]}}, {2{INIT[2]}}, {2{INIT[1]}}, {2{INIT[0]}} };
	LUT4 #(.INIT(INIT4)) lut3 (.F(F), .I0(1'b0), .I1(I0), .I2(I1), .I3(I2));
endmodule

// LUT4 is a P&R primitive defined elsewhere

module LUT5 #(parameter INIT = 32'h0000_0000) (output F, input I0, I1, I2, I3, I4);
	wire f0, f1;
	LUT4 #(.INIT(INIT[15: 0])) lut0 (.F(f0), .I0(I0), .I1(I1), .I2(I2), .I3(I3));
	LUT4 #(.INIT(INIT[31:16])) lut1 (.F(f1), .I0(I0), .I1(I1), .I2(I2), .I3(I3));
	MUX2_LUT5 mux5(.I0(f0), .I1(f1), .S0(I4), .O(Y));
endmodule

module LUT6 #(parameter INIT = 64'h0000_0000_0000_0000) (output F, input I0, I1, I2, I3, I4, I5);
	wire f0, f1;
	LUT5 #(.INIT(INIT[31: 0])) lut0 (.F(f0), .I0(I0), .I1(I1), .I2(I2), .I3(I3), .I4(I4));
	LUT5 #(.INIT(INIT[63:32])) lut1 (.F(f1), .I0(I0), .I1(I1), .I2(I2), .I3(I3), .I4(I4));
	MUX2_LUT6 mux6(.I0(f0), .I1(f1), .S0(I5), .O(Y));
endmodule

module LUT7 #(parameter INIT = 128'h0000_0000_0000_0000_0000_0000_0000_0000) (output F, input I0, I1, I2, I3, I4, I5, I6);
	wire f0, f1;
	LUT6 #(.INIT(INIT[63:  0])) lut0 (.F(f0), .I0(I0), .I1(I1), .I2(I2), .I3(I3), .I4(I4), .I5(I5));
	LUT6 #(.INIT(INIT[127:64])) lut1 (.F(f1), .I0(I0), .I1(I1), .I2(I2), .I3(I3), .I4(I4), .I5(I5));
	MUX2_LUT7 mux7(.I0(f0), .I1(f1), .S0(I6), .O(Y));
endmodule

module LUT8 #(parameter INIT = 256'h0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000) (output F, input I0, I1, I2, I3, I4, I5, I6, I7);
	wire f0, f1;
	LUT7 #(.INIT(INIT[63:  0])) lut0 (.F(f0), .I0(I0), .I1(I1), .I2(I2), .I3(I3), .I4(I4), .I5(I5), .I6(I6));
	LUT7 #(.INIT(INIT[127:64])) lut1 (.F(f1), .I0(I0), .I1(I1), .I2(I2), .I3(I3), .I4(I4), .I5(I5), .I6(I6));
	MUX2_LUT8 mux8(.I0(f0), .I1(f1), .S0(I7), .O(Y));
endmodule

// MUX2_LUT* are P&R primitives defined elsewhere

module MUX2_MUX4 (input I0, I1, input S0, output O);
	MUX2_LUT5 mux2_lut5 (.O(O), .I0(I0), .I1(I1), .S0(S0));
endmodule

module MUX2_MUX8 (output O, input I0, I1, input S0);
	MUX2_LUT6 mux2_lut6 (.O(O), .I0(I0), .I1(I1), .S0(S0));
endmodule

module MUX2_MUX16 (output O, input I0, I1, input S0);
	MUX2_LUT7 mux2_lut7 (.O(O), .I0(I0), .I1(I1), .S0(S0));
endmodule

module MUX2_LUT32 (output O, input I0, I1, input S0);
	MUX2_LUT8 mux2_lut8 (.O(O), .I0(I0), .I1(I1), .S0(S0));
endmodule

// | idx | `3210` | MUX10 | MUX21 | MUX32 |
// |-----|--------|:-----:|:-----:|:-----:|
// | `0` | `0000` |  `0`  |  `0`  |  `0`  |
// | `1` | `0001` |  `1`  |  `0`  |  `0`  |
// | `2` | `0010` |  `0`  |  `1`  |  `1`  |
// | `3` | `0011` |  `1`  |  `1`  |  `1`  |
// | `4` | `0100` |  `0`  |  `0`  |  `1`  |
// | `5` | `0101` |  `1`  |  `0`  |  `1`  |
// | `6` | `0110` |  `0`  |  `1`  |  `0`  |
// | `7` | `0111` |  `1`  |  `1`  |  `0`  |
// | `8` | `1000` |  `0`  |  `0`  |  `0`  |
// | `9` | `1001` |  `0`  |  `0`  |  `0`  |
// | `A` | `1010` |  `1`  |  `0`  |  `1`  |
// | `B` | `1011` |  `1`  |  `0`  |  `1`  |
// | `C` | `1100` |  `0`  |  `1`  |  `1`  |
// | `D` | `1101` |  `0`  |  `1`  |  `1`  |
// | `E` | `1110` |  `1`  |  `1`  |  `1`  |
// | `F` | `1111` |  `1`  |  `1`  |  `1`  |

module MUX2 (output O, input I0, I1, input S0);
	LUT4 #(.INIT(16'b1100_1100_1010_1010)) lut (.F(O), .I0(I0  ), .I1(I1  ), .I2(1'b0), .I3(S0  ));
//	LUT4 #(.INIT(16'b1111_0000_1100_1100)) lut (.F(O), .I0(1'b0), .I1(I0  ), .I2(I1  ), .I3(S0  ));
//	LUT4 #(.INIT(16'b1111_1100_0011_1100)) lut (.F(O), .I0(1'b0), .I1(S0  ), .I2(I0  ), .I3(I1  ));
endmodule

module MUX4 (output O, input I0, I1, I2, I3, input S0, S1);
    wire o0, o1;
	//           O , I0, I1, S0
    MUX2 mux2_0 (o0, I0, I1, S0);
    MUX2 mux2_1 (o1, I2, I3, S0);
    MUX2_MUX4 mux2_o (.O(O), .I0(o0), .I1(o1), .S0(S0));
endmodule

module MUX8 (output O, input I0, I1, I2, I3, I4, I5, I6, I7, input S0, S1, S2);
    wire o0, o1;
	//           O , I0, I1, I2, I3, S0, S1
    MUX4 mux4_0 (o0, I0, I1, I2, I3, S0, S1);
    MUX4 mux4_1 (o1, I4, I5, I6, I7, S0, S1);
    MUX2_MUX8 mux2_o (.O(O), .I0(o0), .I1(o1), .S0(S2));
endmodule

module MUX16 (output O, input I0, I1, I2, I3, I4, I5, I6, I7, I8, I9, I10, I11, I12, I13, I14, I15, input S0, S1, S2, S3);
    wire o0, o1;
	//           O , I0, I1, I2 , I3 , I4 , I5 , I6 , I7 , S0, S1, S2
    MUX8 mux8_0 (o0, I0, I1, I2 , I3 , I4 , I5 , I6 , I7 , S0, S1, S2);
    MUX8 mux8_1 (o1, I8, I9, I10, I11, I12, I13, I14, I15, S0, S1, S2);
    MUX2_MUX16 mux2_o (.O(O), .I0(o0), .I1(o1), .S0(S3));
endmodule

module MUX32 (output O, input I0, I1, I2, I3, I4, I5, I6, I7, I8, I9, I10, I11, I12, I13, I14, I15, I16, I17, I18, I19, I20, I21, I22, I23, I24, I25, I26, I27, I28, I29, I30, I31, input S0, S1, S2, S3, S4);
    wire o0, o1;
	//             O , I0 , I1 , I2 , I3 , I4 , I5 , I6 , I7 , I8 , I9 , I10, I11, I12, I13, I14, I15, S0, S1, S2, S3
    MUX16 mux16_0 (o0, I0 , I1 , I2 , I3 , I4 , I5 , I6 , I7 , I8 , I9 , I10, I11, I12, I13, I14, I15, S0, S1, S2, S3);
    MUX16 mux16_1 (o1, I16, I17, I18, I19, I20, I21, I22, I23, I24, I25, I26, I27, I28, I29, I30, I31, S0, S1, S2, S3);
    MUX2_MUX32 mux2_o (.O(O), .I0(o0), .I1(o1), .S0(S4));
endmodule
