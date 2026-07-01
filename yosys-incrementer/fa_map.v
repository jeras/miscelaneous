/*
(* techmap_celltype = "$__HA__" *)
module librelane_ha (
	input A, B,
	output X, Y
);
	assign X = A&B;  // COUT
	assign Y = A^B;  // SUM
endmodule

(* techmap_celltype = "$__FA__" *)
module librelane_fa (
	input A, B, C,
	output X, Y
);
	assign X = (A&B)|(C&(A^B));  // COUT
	assign Y = A^B^C;            // SUM
endmodule
*/

(* techmap_celltype = "$__HA__" *)
module librelane_ha (
	input A, B,
	output X, Y
);
	sky130_fd_sc_hd__ha_1 HA (
		.COUT (X),
		.SUM  (Y),
		.A    (A),
		.B    (B)
	);
endmodule

(* techmap_celltype = "$__FA__" *)
module librelane_fa (
	input A, B, C,
	output X, Y
);
	sky130_fd_sc_hd__fa_1 FA (
		.COUT (X),
		.SUM  (Y),
		.CIN  (C),
		.A    (A),
		.B    (B)
	);
endmodule

//module \$fa (A, B, C, X, Y);
//
//    parameter WIDTH = 1;
//
//    input [WIDTH-1:0] A, B, C;
//    output [WIDTH-1:0] X, Y;
//
//    wire [WIDTH-1:0] t1, t2, t3;
//
//    assign t1 = A ^ B, t2 = A & B, t3 = C & t1;
//    assign Y = t1 ^ C, X = (t2 | t3) ^ (Y ^ Y);
//
//endmodule

(* techmap_celltype = "$fa" *)
module \$fa (A, B, C, X, Y);
	parameter WIDTH = 1;

	input [WIDTH-1:0] A, B, C;
	output [WIDTH-1:0] X, Y;  // COUT, SUM

	parameter _TECHMAP_CONSTMSK_A_ = 'x;
	parameter _TECHMAP_CONSTMSK_B_ = 'x;
	parameter _TECHMAP_CONSTMSK_C_ = 'x;
	parameter _TECHMAP_CONSTVAL_A_ = 'x;
	parameter _TECHMAP_CONSTVAL_B_ = 'x;
	parameter _TECHMAP_CONSTVAL_C_ = 'x;

	generate
		genvar i;
		for (i=0; i<WIDTH; i=i+1) begin: width
			case ({_TECHMAP_CONSTMSK_A_[i], _TECHMAP_CONSTMSK_B_[i], _TECHMAP_CONSTMSK_C_[i]})
				3'b111, 3'b110, 3'b101, 3'b011: begin // all three or two inputs are constant
					assign X[i] = (A[i] & B[i]) | (C[i] & (A[i] ^ B[i]));  // COUT
					assign Y[i] = A[i] ^ B[i] ^ C[i];  // SUM
				end
				3'b001: begin  // C is constant
					if (_TECHMAP_CONSTVAL_C_[i]) begin
						wire XT, YT;
						\$__HA__ HA (.A(A[i]), .B(B[i]), .X(XT), .Y(YT));  // TODO
						assign X[i] = XT | YT;
						assign Y[i] = ~YT;
					end else begin
						\$__HA__ HA (.A(A[i]), .B(B[i]), .X(X[i]), .Y(Y[i]));
					end
				end
				3'b010: begin  // B is constant
					if (_TECHMAP_CONSTVAL_B_[i]) begin
						\$__HA__ HA (.A(A[i]), .B(C[i]), .X(X[i]), .Y(Y[i]));  // TODO
					end else begin
						\$__HA__ HA (.A(A[i]), .B(C[i]), .X(X[i]), .Y(Y[i]));
					end
				end
				3'b100: begin  // A is constant
					if (_TECHMAP_CONSTVAL_A_[i]) begin
						\$__HA__ HA (.A(B[i]), .B(C[i]), .X(X[i]), .Y(Y[i]));  // TODO
					end else begin
						\$__HA__ HA (.A(B[i]), .B(C[i]), .X(X[i]), .Y(Y[i]));
					end
				end
				default: begin
					\$__FA__ FA (.A(A[i]), .B(B[i]), .C(C[i]), .X(X[i]), .Y(Y[i]));
				end
			endcase
		end
	endgenerate

endmodule
