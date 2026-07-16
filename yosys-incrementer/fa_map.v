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
//	sky130_fd_sc_hd__fah_1 FA (
//		.COUT (X),
//		.SUM  (Y),
//		.CI  (C),
//		.A    (A),
//		.B    (B)
//	);
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

