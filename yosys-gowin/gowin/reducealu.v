(* techmap_celltype = "$reduce_and $reduce_or" *)
module \$reduce_or (A, Y);

    parameter A_SIGNED = 0;
    parameter A_WIDTH = 0;
    parameter Y_WIDTH = 0;

    input [A_WIDTH-1:0] A;
    output [Y_WIDTH-1:0] Y;

    parameter _TECHMAP_CELLTYPE_ = "";

    // width round up to multiple of LUT inputs
    localparam CC_WIDTH = (A_WIDTH + 3) / 4;
    localparam AA_WIDTH = CC_WIDTH * 4;

    localparam [16-1:0] LUT = (_TECHMAP_CELLTYPE_ == "$reduce_or")  ? 16'b1111_1111_1111_1110
                            : (_TECHMAP_CELLTYPE_ == "$reduce_and") ? 16'b1000_0000_0000_0000
                            :                                         16'bxxxx_xxxx_xxxx_xxxx;

    wire [AA_WIDTH-1:0] AA;
    wire [CC_WIDTH  :0] CC;

    \$pos #(.A_SIGNED(A_SIGNED), .A_WIDTH(A_WIDTH), .Y_WIDTH(AA_WIDTH)) A_conv (.A(A), .Y(AA));

    assign CC[0] = 1'b1;

    genvar i;
    generate for (i = 0; i < CC_WIDTH; i = i + 1) begin: slice
        CLS #(.LUT (LUT))
        cls (
            .I0   (AA[4*i+0]),
	        .I1   (AA[4*i+1]),
	        .I2   (AA[4*i+2]),
            .I3   (AA[4*i+3]),
	        .CIN  (CC[i]),
	        .COUT (CC[i+1]),
	        .SUM  ()
	    );
    end endgenerate

    generate case (_TECHMAP_CELLTYPE_)
        "$reduce_or":
            assign Y = CC[CC_WIDTH];
        "$reduce_and":
            assign Y = CC[CC_WIDTH];
    endcase endgenerate

endmodule
