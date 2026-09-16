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

	wire [1023:0] _TECHMAP_DO_01_ = "RECURSION; flatten;";

	generate case (WIDTH)
		1: LUT1 #(.INIT(LUT)) _TECHMAP_REPLACE_ (Y, A[0]);
		2: LUT2 #(.INIT(LUT)) _TECHMAP_REPLACE_ (Y, A[0], A[1]);
		3: LUT3 #(.INIT(LUT)) _TECHMAP_REPLACE_ (Y, A[0], A[1], A[2]);
		4: LUT4 #(.INIT(LUT)) _TECHMAP_REPLACE_ (Y, A[0], A[1], A[2], A[3]);
		5: LUT5 #(.INIT(LUT)) _TECHMAP_REPLACE_ (Y, A[0], A[1], A[2], A[3], A[4]);
		6: LUT6 #(.INIT(LUT)) _TECHMAP_REPLACE_ (Y, A[0], A[1], A[2], A[3], A[4], A[5]);
		7: LUT7 #(.INIT(LUT)) _TECHMAP_REPLACE_ (Y, A[0], A[1], A[2], A[3], A[4], A[5], A[6]);
		8: LUT8 #(.INIT(LUT)) _TECHMAP_REPLACE_ (Y, A[0], A[1], A[2], A[3], A[4], A[5], A[6], A[7]);
	endcase endgenerate
endmodule

module \$bmux (A, S, Y);
	parameter WIDTH = 0;
	parameter S_WIDTH = 0;

	input [WIDTH*2**S_WIDTH-1:0] A;
	input [S_WIDTH-1:0] S;
	output [WIDTH-1:0] Y;

	wire [1023:0] _TECHMAP_DO_ = "RECURSION; opt;";

	genvar i, j, k;
	generate
		for (i=0; i<WIDTH; i++) begin: index
			wire [2**S_WIDTH-1:0] AA;

			for (j=0; j<2**S_WIDTH; j++) begin: bitmap
				assign AA[j] = A[i+j*WIDTH];
			end

			case (S_WIDTH)
				1: MUX2  _TECHMAP_REPLACE_ (Y[i], AA[ 0], AA[ 1],                                                 S[0]);
				2: MUX4  _TECHMAP_REPLACE_ (Y[i], AA[ 0], AA[ 1], AA[ 2], AA[ 3],                                 S[0], S[1]);
				3: MUX8  _TECHMAP_REPLACE_ (Y[i], AA[ 0], AA[ 1], AA[ 2], AA[ 3], AA[ 4], AA[ 5], AA[ 6], AA[ 7], S[0], S[1], S[2]);
				4: MUX16 _TECHMAP_REPLACE_ (Y[i], AA[ 0], AA[ 1], AA[ 2], AA[ 3], AA[ 4], AA[ 5], AA[ 6], AA[ 7],
				                                  AA[ 8], AA[ 9], AA[10], AA[11], AA[12], AA[13], AA[14], AA[15], S[0], S[1], S[2], S[3]);
				5: MUX32 _TECHMAP_REPLACE_ (Y[i], AA[ 0], AA[ 1], AA[ 2], AA[ 3], AA[ 4], AA[ 5], AA[ 6], AA[ 7],
				                                  AA[ 8], AA[ 9], AA[10], AA[11], AA[12], AA[13], AA[14], AA[15],
												  AA[16], AA[17], AA[18], AA[19], AA[20], AA[21], AA[22], AA[23],
				                                  AA[24], AA[25], AA[26], AA[27], AA[28], AA[29], AA[30], AA[31], S[0], S[1], S[2], S[3], S[4]);
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
