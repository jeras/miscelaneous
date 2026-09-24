module \$_MUX_ (input A, B, input S, output Y);
	\$lut #(.WIDTH(3), .INIT(8'b1100_1010)) lut (.A({S, B, A}), .Y(Y));
endmodule
