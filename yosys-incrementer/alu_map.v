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


(* techmap_celltype = "$alu" *)
module librelane_rca_alu (A, B, CI, BI, X, Y, CO);
	parameter A_SIGNED = 0;
	parameter B_SIGNED = 0;
	parameter A_WIDTH = 1;
	parameter B_WIDTH = 1;
	parameter Y_WIDTH = 1;

	parameter _TECHMAP_CONSTMSK_A_ = 'x;
	parameter _TECHMAP_CONSTVAL_A_ = 'x;
	parameter _TECHMAP_CONSTMSK_B_ = 'x;
	parameter _TECHMAP_CONSTVAL_B_ = 'x;
	parameter _TECHMAP_CONSTMSK_CI_ = 1'bx;
	parameter _TECHMAP_CONSTVAL_CI_ = 1'bx;
	parameter _TECHMAP_CONSTMSK_BI_ = 1'bx;
	parameter _TECHMAP_CONSTVAL_BI_ = 1'bx;

	wire [1023:0] _TECHMAP_DO_ = "opt_expr";

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
	wire [Y_WIDTH-1:0] CC = {CO, BI ^ CI};

	assign X = AA ^ BB;

	localparam _TECHMAP_CONSTMSK_AA_ = _TECHMAP_CONSTMSK_A_;
	localparam _TECHMAP_CONSTVAL_AA_ = _TECHMAP_CONSTVAL_A_;
	localparam _TECHMAP_CONSTMSK_BB_ = _TECHMAP_CONSTMSK_BI_ ? _TECHMAP_CONSTMSK_B_ : 'x;
	localparam _TECHMAP_CONSTVAL_BB_ = _TECHMAP_CONSTVAL_BI_ ? ~_TECHMAP_CONSTVAL_B_ : _TECHMAP_CONSTVAL_B_;
	localparam _TECHMAP_CONSTMSK_CC_ = {{Y_WIDTH-1{1'b0}}, _TECHMAP_CONSTMSK_BI_ & _TECHMAP_CONSTMSK_CI_};
	localparam _TECHMAP_CONSTVAL_CC_ = {{Y_WIDTH-1{1'bx}}, _TECHMAP_CONSTVAL_BI_ ^ _TECHMAP_CONSTVAL_CI_};

    \$fa #(
		.WIDTH                (Y_WIDTH)
//		._TECHMAP_CONSTMSK_A_ (_TECHMAP_CONSTMSK_AA_),
//		._TECHMAP_CONSTVAL_A_ (_TECHMAP_CONSTVAL_AA_),
//		._TECHMAP_CONSTMSK_B_ (_TECHMAP_CONSTMSK_BB_),
//		._TECHMAP_CONSTVAL_B_ (_TECHMAP_CONSTVAL_BB_),
//		._TECHMAP_CONSTMSK_C_ (_TECHMAP_CONSTMSK_CC_),
//		._TECHMAP_CONSTVAL_C_ (_TECHMAP_CONSTVAL_CC_)
	) FA (.A(AA), .B(BB), .C(CC), .X(CO), .Y(Y));

endmodule
