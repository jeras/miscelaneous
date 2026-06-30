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

/*
(* techmap_celltype = "$add" *)
module librelane_rca_add (A, B, Y);
	parameter A_SIGNED = 0;
	parameter B_SIGNED = 0;
	parameter A_WIDTH = 1;
	parameter B_WIDTH = 1;
	parameter Y_WIDTH = 1;

	parameter _TECHMAP_CONSTMSK_A_ = 0;
	parameter _TECHMAP_CONSTMSK_B_ = 0;
	parameter _TECHMAP_CONSTVAL_A_ = 0;
	parameter _TECHMAP_CONSTVAL_B_ = 0;

	wire _TECHMAP_FAIL_ = Y_WIDTH <= 2;

	(* force_downto *)
	input [A_WIDTH-1:0] A;
	(* force_downto *)
	input [B_WIDTH-1:0] B;
	(* force_downto *)
	output [Y_WIDTH-1:0] Y;

	(* force_downto *)
	wire [Y_WIDTH-1:0] CO;

	(* force_downto *)
	wire [Y_WIDTH-1:0] A_buf, B_buf;
	\$pos #(.A_SIGNED(A_SIGNED), .A_WIDTH(A_WIDTH), .Y_WIDTH(Y_WIDTH)) A_conv (.A(A), .Y(A_buf));
	\$pos #(.A_SIGNED(B_SIGNED), .A_WIDTH(B_WIDTH), .Y_WIDTH(Y_WIDTH)) B_conv (.A(B), .Y(B_buf));

	(* force_downto *)
	wire [Y_WIDTH-1:0] AA = A_buf;
	(* force_downto *)
	wire [Y_WIDTH-1:0] BB = B_buf;
	(* force_downto *)
	wire [Y_WIDTH-1:0] C = {CO, 1'b0};

	generate
		genvar i;
		for (i=0; i<Y_WIDTH; i=i+1) begin: stage
			\$__FA__ FA (.A(AA[i]), .B(BB[i]), .C(C[i]), .X(CO[i]), .Y(Y[i]));
		end
	endgenerate

endmodule
*/

(* techmap_celltype = "$add" *)
module librelane_rca_add (A, B, Y);
	parameter A_SIGNED = 0;
	parameter B_SIGNED = 0;
	parameter A_WIDTH = 1;
	parameter B_WIDTH = 1;
	parameter Y_WIDTH = 1;

	parameter _TECHMAP_CONSTMSK_A_ = 'x;
	parameter _TECHMAP_CONSTMSK_B_ = 'x;
	parameter _TECHMAP_CONSTVAL_A_ = 'x;
	parameter _TECHMAP_CONSTVAL_B_ = 'x;

	wire _TECHMAP_FAIL_ = Y_WIDTH <= 2;

	(* force_downto *)
	input [A_WIDTH-1:0] A;
	(* force_downto *)
	input [B_WIDTH-1:0] B;
	(* force_downto *)
	output [Y_WIDTH-1:0] Y;

	(* force_downto *)
	wire [Y_WIDTH-1:0] CO;

	(* force_downto *)
	wire [Y_WIDTH-1:0] A_buf, B_buf;
	\$pos #(.A_SIGNED(A_SIGNED), .A_WIDTH(A_WIDTH), .Y_WIDTH(Y_WIDTH)) A_conv (.A(A), .Y(A_buf));
	\$pos #(.A_SIGNED(B_SIGNED), .A_WIDTH(B_WIDTH), .Y_WIDTH(Y_WIDTH)) B_conv (.A(B), .Y(B_buf));

	(* force_downto *)
	wire [Y_WIDTH-1:0] AA = A_buf;
	(* force_downto *)
	wire [Y_WIDTH-1:0] BB = B_buf;
	(* force_downto *)
	wire [Y_WIDTH-1:0] C = {CO, 1'b0};

	generate
		genvar i;
		for (i=0; i<Y_WIDTH; i=i+1) begin: stage
			if (_TECHMAP_CONSTMSK_A_[i] | _TECHMAP_CONSTMSK_B_[i]) begin
				if (_TECHMAP_CONSTMSK_A_[i] & _TECHMAP_CONSTMSK_B_[i]) begin
					// both inputs are constant
					assign Y [i] =   _TECHMAP_CONSTVAL_A_[i] ^ _TECHMAP_CONSTVAL_B_[i] ^ C[i];
					assign CO[i] =  (_TECHMAP_CONSTVAL_A_[i] & _TECHMAP_CONSTVAL_B_[i])
								 | ((_TECHMAP_CONSTVAL_A_[i] ^ _TECHMAP_CONSTVAL_B_[i]) & C[i]);
				end else if (_TECHMAP_CONSTMSK_A_[i]) begin
					// input A is constant
					if (_TECHMAP_CONSTVAL_A_[i]) begin
						// A[i] == 1'b1
						assign Y [i] = BB[i] ~^ C[i];
						assign CO[i] = BB[i]  | C[i];
					end else begin
						// A[i] == 1'b0
						\$__HA__ HA (.A(AA[i]), .B(C[i]), .X(CO[i]), .Y(Y[i]));
					end
				end else if (_TECHMAP_CONSTMSK_B_[i]) begin
					// input B is constant
					if (_TECHMAP_CONSTVAL_B_[i]) begin
						// B[i] == 1'b1
						assign Y [i] = AA[i] ~^ C[i];
						assign CO[i] = AA[i]  | C[i];
					end else begin
						// B[i] == 1'b0
						\$__HA__ HA (.A(AA[i]), .B(C[i]), .X(CO[i]), .Y(Y[i]));
					end
				end
			end else begin
				\$__FA__ FA (.A(AA[i]), .B(BB[i]), .C(C[i]), .X(CO[i]), .Y(Y[i]));
			end
		end
	endgenerate

endmodule

(* techmap_celltype = "$sub" *)
module librelane_rca_sub (A, B, Y);
	parameter A_SIGNED = 0;
	parameter B_SIGNED = 0;
	parameter A_WIDTH = 1;
	parameter B_WIDTH = 1;
	parameter Y_WIDTH = 1;

	parameter _TECHMAP_CONSTMSK_A_ = 'x;
	parameter _TECHMAP_CONSTMSK_B_ = 'x;
	parameter _TECHMAP_CONSTVAL_A_ = 'x;
	parameter _TECHMAP_CONSTVAL_B_ = 'x;

	wire _TECHMAP_FAIL_ = Y_WIDTH <= 2;

	(* force_downto *)
	input [A_WIDTH-1:0] A;
	(* force_downto *)
	input [B_WIDTH-1:0] B;
	(* force_downto *)
	output [Y_WIDTH-1:0] Y;

	//input CI, BI;
	(* force_downto *)
	wire [Y_WIDTH-1:0] CO;

	(* force_downto *)
	wire [Y_WIDTH-1:0] A_buf, B_buf;
	\$pos #(.A_SIGNED(A_SIGNED), .A_WIDTH(A_WIDTH), .Y_WIDTH(Y_WIDTH)) A_conv (.A(A), .Y(A_buf));
	\$pos #(.A_SIGNED(B_SIGNED), .A_WIDTH(B_WIDTH), .Y_WIDTH(Y_WIDTH)) B_conv (.A(B), .Y(B_buf));

	(* force_downto *)
	wire [Y_WIDTH-1:0] AA = A_buf;
	(* force_downto *)
	wire [Y_WIDTH-1:0] BB = ~B_buf;
	(* force_downto *)
	wire [Y_WIDTH-1:0] C = {CO, 1'b1};

	generate
		genvar i;
		for (i=0; i<Y_WIDTH; i=i+1) begin: stage
			if (_TECHMAP_CONSTMSK_A_[i] | _TECHMAP_CONSTMSK_B_[i]) begin
				if (_TECHMAP_CONSTMSK_A_[i] & _TECHMAP_CONSTMSK_B_[i]) begin
					// both inputs are constant
					assign Y [i] =   _TECHMAP_CONSTVAL_A_[i] ^ _TECHMAP_CONSTVAL_B_[i] ^ C[i];
					assign CO[i] =  (_TECHMAP_CONSTVAL_A_[i] & _TECHMAP_CONSTVAL_B_[i])
								 | ((_TECHMAP_CONSTVAL_A_[i] ^ _TECHMAP_CONSTVAL_B_[i]) & C[i]);
				end else if (_TECHMAP_CONSTMSK_A_[i]) begin
					// input A is constant
					if (_TECHMAP_CONSTVAL_A_[i]) begin
						// A[i] == 1'b1
						assign Y [i] = BB[i] ~^ C[i];
						assign CO[i] = BB[i]  | C[i];
					end else begin
						// A[i] == 1'b0
						\$__HA__ HA (.A(AA[i]), .B(C[i]), .X(CO[i]), .Y(Y[i]));
					end
				end else if (_TECHMAP_CONSTMSK_B_[i]) begin
					// input B is constant
					if (_TECHMAP_CONSTVAL_B_[i]) begin
						// B[i] == 1'b1
						assign Y [i] = AA[i] ~^ C[i];
						assign CO[i] = AA[i]  | C[i];
					end else begin
						// B[i] == 1'b0
						\$__HA__ HA (.A(AA[i]), .B(C[i]), .X(CO[i]), .Y(Y[i]));
					end
				end
			end else begin
				\$__FA__ FA (.A(AA[i]), .B(BB[i]), .C(C[i]), .X(CO[i]), .Y(Y[i]));
			end
		end
	endgenerate

endmodule

(* techmap_celltype = "$alu" *)
module librelane_rca_alu (A, B, CI, BI, X, Y, CO);
	parameter A_SIGNED = 0;
	parameter B_SIGNED = 0;
	parameter A_WIDTH = 1;
	parameter B_WIDTH = 1;
	parameter Y_WIDTH = 1;

	parameter _TECHMAP_CONSTMSK_A_ = 'x;
	parameter _TECHMAP_CONSTMSK_B_ = 'x;
	parameter _TECHMAP_CONSTVAL_A_ = 'x;
	parameter _TECHMAP_CONSTVAL_B_ = 'x;

	wire _TECHMAP_FAIL_ = Y_WIDTH <= 2;

	(* force_downto *)
	input [A_WIDTH-1:0] A;
	(* force_downto *)
	input [B_WIDTH-1:0] B;
	(* force_downto *)
	output [Y_WIDTH-1:0] X, Y;

	input CI, BI;
	(* force_downto *)
	output [Y_WIDTH-1:0] CO;

	(* force_downto *)
	wire [Y_WIDTH-1:0] A_buf, B_buf;
	\$pos #(.A_SIGNED(A_SIGNED), .A_WIDTH(A_WIDTH), .Y_WIDTH(Y_WIDTH)) A_conv (.A(A), .Y(A_buf));
	\$pos #(.A_SIGNED(B_SIGNED), .A_WIDTH(B_WIDTH), .Y_WIDTH(Y_WIDTH)) B_conv (.A(B), .Y(B_buf));

	(* force_downto *)
	wire [Y_WIDTH-1:0] AA = A_buf;
	(* force_downto *)
	wire [Y_WIDTH-1:0] BB = BI ? ~B_buf : B_buf;
	(* force_downto *)
	wire [Y_WIDTH-1:0] C = {CO, BI ^ CI};

	assign X = AA ^ BB;

	generate
		genvar i;
		for (i=0; i<Y_WIDTH; i=i+1) begin: stage
			if (_TECHMAP_CONSTMSK_A_[i] | _TECHMAP_CONSTMSK_B_[i]) begin
				if (_TECHMAP_CONSTMSK_A_[i] & _TECHMAP_CONSTMSK_B_[i]) begin
					// both inputs are constant
					assign Y [i] =   _TECHMAP_CONSTVAL_A_[i] ^ _TECHMAP_CONSTVAL_B_[i] ^ C[i];
					assign CO[i] =  (_TECHMAP_CONSTVAL_A_[i] & _TECHMAP_CONSTVAL_B_[i])
								 | ((_TECHMAP_CONSTVAL_A_[i] ^ _TECHMAP_CONSTVAL_B_[i]) & C[i]);
				end else if (_TECHMAP_CONSTMSK_A_[i]) begin
					// input A is constant
					if (_TECHMAP_CONSTVAL_A_[i]) begin
						// A[i] == 1'b1
						assign Y [i] = BB[i] ~^ C[i];
						assign CO[i] = BB[i]  | C[i];
					end else begin
						// A[i] == 1'b0
						\$__HA__ HA (.A(AA[i]), .B(C[i]), .X(CO[i]), .Y(Y[i]));
					end
				end else if (_TECHMAP_CONSTMSK_B_[i]) begin
					// input B is constant
					if (_TECHMAP_CONSTVAL_B_[i]) begin
						// B[i] == 1'b1
						assign Y [i] = AA[i] ~^ C[i];
						assign CO[i] = AA[i]  | C[i];
					end else begin
						// B[i] == 1'b0
						\$__HA__ HA (.A(AA[i]), .B(C[i]), .X(CO[i]), .Y(Y[i]));
					end
				end
			end else begin
				\$__FA__ FA (.A(AA[i]), .B(BB[i]), .C(C[i]), .X(CO[i]), .Y(Y[i]));
			end
		end
	endgenerate

endmodule
