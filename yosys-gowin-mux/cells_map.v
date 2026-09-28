`default_nettype none
//All DFF* have INIT, but the hardware is always initialised to the reset
//value regardless. The parameter is ignored.

// DFFN			 D Flip-Flop with Negative-Edge Clock
module	\$_DFF_N_ (input D, C, output Q);
	DFFN _TECHMAP_REPLACE_ (.D(D), .Q(Q), .CLK(C));
	wire _TECHMAP_REMOVEINIT_Q_ = 1;
endmodule

// DFF			 D Flip-Flop
module	\$_DFF_P_ (input D, C, output Q);
	DFF _TECHMAP_REPLACE_ (.D(D), .Q(Q), .CLK(C));
	wire _TECHMAP_REMOVEINIT_Q_ = 1;
endmodule

// DFFE			 D Flip-Flop with Clock Enable
module	\$_DFFE_PP_ (input D, C, E, output Q);
	DFFE _TECHMAP_REPLACE_ (.D(D), .Q(Q), .CLK(C), .CE(E));
	wire _TECHMAP_REMOVEINIT_Q_ = 1;
endmodule

// DFFNE		 D Flip-Flop with Negative-Edge Clock and Clock Enable
module	\$_DFFE_NP_ (input D, C, E, output Q);
	DFFNE _TECHMAP_REPLACE_ (.D(D), .Q(Q), .CLK(C), .CE(E));
	wire _TECHMAP_REMOVEINIT_Q_ = 1;
endmodule

// DFFR			 D Flip-Flop with Synchronous Reset
module	\$_SDFF_PP0_ (input D, C, R, output Q);
	DFFR _TECHMAP_REPLACE_ (.D(D), .Q(Q), .CLK(C), .RESET(R));
	wire _TECHMAP_REMOVEINIT_Q_ = 1;
endmodule

// DFFNR		 D Flip-Flop with Negative-Edge Clock and Synchronous Reset
module	\$_SDFF_NP0_ (input D, C, R, output Q);
	DFFNR _TECHMAP_REPLACE_ (.D(D), .Q(Q), .CLK(C), .RESET(R));
	wire _TECHMAP_REMOVEINIT_Q_ = 1;
endmodule

// DFFRE		 D Flip-Flop with Clock Enable and Synchronous Reset
module	\$_SDFFE_PP0P_ (input D, C, R, E, output Q);
	DFFRE _TECHMAP_REPLACE_ (.D(D), .Q(Q), .CLK(C), .RESET(R), .CE(E));
	wire _TECHMAP_REMOVEINIT_Q_ = 1;
endmodule

// DFFNRE		 D Flip-Flop with Negative-Edge Clock,Clock Enable, and Synchronous Reset
module	\$_SDFFE_NP0P_ (input D, C, R, E, output Q);
	DFFNRE _TECHMAP_REPLACE_ (.D(D), .Q(Q), .CLK(C), .RESET(R), .CE(E));
	wire _TECHMAP_REMOVEINIT_Q_ = 1;
endmodule

// DFFS			 D Flip-Flop with Synchronous Set
module	\$_SDFF_PP1_ (input D, C, R, output Q);
	DFFS _TECHMAP_REPLACE_ (.D(D), .Q(Q), .CLK(C), .SET(R));
	wire _TECHMAP_REMOVEINIT_Q_ = 1;
endmodule

// DFFNS		 D Flip-Flop with Negative-Edge Clock and Synchronous Set
module	\$_SDFF_NP1_ (input D, C, R, output Q);
	DFFNS _TECHMAP_REPLACE_ (.D(D), .Q(Q), .CLK(C), .SET(R));
	wire _TECHMAP_REMOVEINIT_Q_ = 1;
endmodule

// DFFSE		 D Flip-Flop with Clock Enable and Synchronous Set
module	\$_SDFFE_PP1P_ (input D, C, R, E, output Q);
	DFFSE _TECHMAP_REPLACE_ (.D(D), .Q(Q), .CLK(C), .SET(R), .CE(E));
	wire _TECHMAP_REMOVEINIT_Q_ = 1;
endmodule

// DFFNSE		 D Flip-Flop with Negative-Edge Clock,Clock Enable,and Synchronous Set
module	\$_SDFFE_NP1P_ (input D, C, R, E, output Q);
	DFFNSE _TECHMAP_REPLACE_ (.D(D), .Q(Q), .CLK(C), .SET(R), .CE(E));
	wire _TECHMAP_REMOVEINIT_Q_ = 1;
endmodule

// DFFP			 D Flip-Flop with Asynchronous Preset
module	\$_DFF_PP1_ (input D, C, R, output Q);
	DFFP _TECHMAP_REPLACE_ (.D(D), .Q(Q), .CLK(C), .PRESET(R));
	wire _TECHMAP_REMOVEINIT_Q_ = 1;
endmodule

// DFFNP		 D Flip-Flop with Negative-Edge Clock and Asynchronous Preset
module	\$_DFF_NP1_ (input D, C, R, output Q);
	DFFNP _TECHMAP_REPLACE_ (.D(D), .Q(Q), .CLK(C), .PRESET(R));
	wire _TECHMAP_REMOVEINIT_Q_ = 1;
endmodule

// DFFC			 D Flip-Flop with Asynchronous Clear
module	\$_DFF_PP0_ (input D, C, R, output Q);
	DFFC _TECHMAP_REPLACE_ (.D(D), .Q(Q), .CLK(C), .CLEAR(R));
	wire _TECHMAP_REMOVEINIT_Q_ = 1;
endmodule

// DFFNC		 D Flip-Flop with Negative-Edge Clock and Asynchronous Clear
module	\$_DFF_NP0_ (input D, C, R, output Q);
	DFFNC _TECHMAP_REPLACE_ (.D(D), .Q(Q), .CLK(C), .CLEAR(R));
	wire _TECHMAP_REMOVEINIT_Q_ = 1;
endmodule

// DFFPE		 D Flip-Flop with Clock Enable and Asynchronous Preset
module	\$_DFFE_PP1P_ (input D, C, R, E, output Q);
	DFFPE _TECHMAP_REPLACE_ (.D(D), .Q(Q), .CLK(C), .PRESET(R), .CE(E));
	wire _TECHMAP_REMOVEINIT_Q_ = 1;
endmodule

// DFFNPE		 D Flip-Flop with Negative-Edge Clock,Clock Enable, and Asynchronous Preset
module	\$_DFFE_NP1P_ (input D, C, R, E, output Q);
	DFFNPE _TECHMAP_REPLACE_ (.D(D), .Q(Q), .CLK(C), .PRESET(R), .CE(E));
	wire _TECHMAP_REMOVEINIT_Q_ = 1;
endmodule

// DFFCE		 D Flip-Flop with Clock Enable and Asynchronous Clear
module	\$_DFFE_PP0P_ (input D, C, R, E, output Q);
	DFFCE _TECHMAP_REPLACE_ (.D(D), .Q(Q), .CLK(C), .CLEAR(R), .CE(E));
	wire _TECHMAP_REMOVEINIT_Q_ = 1;
endmodule

// DFFNCE		 D Flip-Flop with Negative-Edge Clock,Clock Enable and Asynchronous Clear
module	\$_DFFE_NP0P_ (input D, C, R, E, output Q);
	DFFNCE _TECHMAP_REPLACE_ (.D(D), .Q(Q), .CLK(C), .CLEAR(R), .CE(E));
	wire _TECHMAP_REMOVEINIT_Q_ = 1;
endmodule

module \$lut (A, Y);
	parameter WIDTH = 0;
	parameter LUT = 0;

	(* force_downto *)
	input [WIDTH-1:0] A;
	output Y;

	generate case (WIDTH)
		1: LUT1 #(.INIT(LUT)) _TECHMAP_REPLACE_ (.F(Y), .I0(A[0]));
		2: LUT2 #(.INIT(LUT)) _TECHMAP_REPLACE_ (.F(Y), .I0(A[0]), .I1(A[1]));
		3: LUT3 #(.INIT(LUT)) _TECHMAP_REPLACE_ (.F(Y), .I0(A[0]), .I1(A[1]), .I2(A[2]));
		4: LUT4 #(.INIT(LUT)) _TECHMAP_REPLACE_ (.F(Y), .I0(A[0]), .I1(A[1]), .I2(A[2]), .I3(A[3]));
		5: LUT5 #(.INIT(LUT)) _TECHMAP_REPLACE_ (.F(Y), .I0(A[0]), .I1(A[1]), .I2(A[2]), .I3(A[3]), .I4(A[4]));
		6: LUT6 #(.INIT(LUT)) _TECHMAP_REPLACE_ (.F(Y), .I0(A[0]), .I1(A[1]), .I2(A[2]), .I3(A[3]), .I4(A[4]), .I5(A[5]));
		7: LUT7 #(.INIT(LUT)) _TECHMAP_REPLACE_ (.F(Y), .I0(A[0]), .I1(A[1]), .I2(A[2]), .I3(A[3]), .I4(A[4]), .I5(A[5]), .I6(A[6]));
		8: LUT8 #(.INIT(LUT)) _TECHMAP_REPLACE_ (.F(Y), .I0(A[0]), .I1(A[1]), .I2(A[2]), .I3(A[3]), .I4(A[4]), .I5(A[5]), .I6(A[6]), .I7(A[7]));
	endcase endgenerate
endmodule

module \$_MUX_ (input A, B, input S, output Y);
	MUX2 _TECHMAP_REPLACE_ (.O(Y), .I0(A), .I1(B), .S0(S));
endmodule

module \$_MUX4_ (input A, B, C, D, input S, T, output Y);
	MUX4 _TECHMAP_REPLACE_ (.O(Y), .I0(A), .I1(B), .I2(C), .I3(D), .S0(S), .S1(T));
endmodule

module \$_MUX8_ (input A, B, C, D, E, F, G, H, input S, T, U, output Y);
	MUX8  _TECHMAP_REPLACE_ (.O(Y), .I0(A), .I1(B), .I2(C), .I3(D), .I4(E), .I5(F), .I6(G), .I7(H), .S0(S), .S1(T), .S2(U));
endmodule

module \$_MUX16_ (input A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, input S, T, U, V, output Y);
	MUX16 _TECHMAP_REPLACE_ (.O(Y), .I0(A), .I1(B), .I2(C), .I3(D), .I4(E), .I5(F), .I6(G), .I7(H), .I8(I), .I9(J), .I10(K), .I11(L), .I12(M), .I13(N), .I14(O), .I15(P), .S0(S), .S1(T), .S2(U), .S3(V));
endmodule

module \$_MUX32_ (input A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, QA, QB, QC, QD, QE, QF, QG, QH, QI, QJ, QK, QL, QM, QN, QO, QP, input S, T, U, V, W, output Y);
	MUX32 _TECHMAP_REPLACE_ (.O(Y), .I0( A), .I1( B), .I2( C), .I3( D), .I4( E), .I5( F), .I6( G), .I7( H), .I8( I), .I9( J), .I10( K), .I11( L), .I12( M), .I13( N), .I14( O), .I15( P),
	                                .I0(QA), .I1(QB), .I2(QC), .I3(QD), .I4(QE), .I5(QF), .I6(QG), .I7(QH), .I8(QI), .I9(QJ), .I10(QK), .I11(QL), .I12(QM), .I13(QN), .I14(QO), .I15(QP), .S0(S), .S1(T), .S2(U), .S3(U), .S3(V), .S4(W));
endmodule

module \$bmux (A, S, Y);
	parameter WIDTH = 0;
	parameter S_WIDTH = 0;

	input [WIDTH*2**S_WIDTH-1:0] A;
	input [S_WIDTH-1:0] S;
	output [WIDTH-1:0] Y;

	genvar i, j, k;
	generate
		for (i=0; i<WIDTH; i++) begin: index
			wire [2**S_WIDTH-1:0] AA;

			for (j=0; j<2**S_WIDTH; j++) begin: bitmap
				assign AA[j] = A[i+j*WIDTH];
			end

			case (S_WIDTH)
				1: MUX2  _TECHMAP_REPLACE_ (.O(Y[i]), .I0 (AA[ 0]), .I1 (AA[ 1]),                                                                                     .S0(S[0]));
				2: MUX4  _TECHMAP_REPLACE_ (.O(Y[i]), .I0 (AA[ 0]), .I1 (AA[ 1]), .I2 (AA[ 2]), .I3 (AA[ 3]),                                                         .S0(S[0]), .S1(S[1]));
				3: MUX8  _TECHMAP_REPLACE_ (.O(Y[i]), .I0 (AA[ 0]), .I1 (AA[ 1]), .I2 (AA[ 2]), .I3 (AA[ 3]), .I4 (AA[ 4]), .I5 (AA[ 5]), .I6 (AA[ 6]), .I7 (AA[ 7]), .S0(S[0]), .S1(S[1]), .S2(S[2]));
				4: MUX16 _TECHMAP_REPLACE_ (.O(Y[i]), .I0 (AA[ 0]), .I1 (AA[ 1]), .I2 (AA[ 2]), .I3 (AA[ 3]), .I4 (AA[ 4]), .I5 (AA[ 5]), .I6 (AA[ 6]), .I7 (AA[ 7]),
				                                      .I8 (AA[ 8]), .I9 (AA[ 9]), .I10(AA[10]), .I11(AA[11]), .I12(AA[12]), .I13(AA[13]), .I14(AA[14]), .I15(AA[15]), .S0(S[0]), .S1(S[1]), .S2(S[2]), .S3(S[3]));
				5: MUX32 _TECHMAP_REPLACE_ (.O(Y[i]), .I0 (AA[ 0]), .I1 (AA[ 1]), .I2 (AA[ 2]), .I3 (AA[ 3]), .I4 (AA[ 4]), .I5 (AA[ 5]), .I6 (AA[ 6]), .I7 (AA[ 7]),
				                                      .I8 (AA[ 8]), .I9 (AA[ 9]), .I10(AA[10]), .I11(AA[11]), .I12(AA[12]), .I13(AA[13]), .I14(AA[14]), .I15(AA[15]),
												      .I16(AA[16]), .I17(AA[17]), .I18(AA[18]), .I19(AA[19]), .I20(AA[20]), .I21(AA[21]), .I22(AA[22]), .I23(AA[23]),
				                                      .I24(AA[24]), .I25(AA[25]), .I26(AA[26]), .I27(AA[27]), .I28(AA[28]), .I29(AA[29]), .I30(AA[30]), .I31(AA[31]), .S0(S[0]), .S1(S[1]), .S2(S[2]), .S3(S[3]), .S4(S[4]));
				default: begin
					// TODO: causes segmentation fault
					wire [2**(S_WIDTH-5):0] YY;

					for (k=0; k<2**(S_WIDTH-5); k++) begin: segment
						\$bmux #(.WIDTH(1), .S_WIDTH(5)) mux (.A(AA[k*2**5+:2**5]), .S(S[4:0]), .Y(YY[k]));
					end

					\$bmux #(.WIDTH(1), .S_WIDTH(S_WIDTH-5)) mux (.A(YY), .S(S[S_WIDTH-1:5]), .Y(Y[i]));
				end
			endcase
		end
	endgenerate
endmodule
