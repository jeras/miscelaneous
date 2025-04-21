module verilator_localparam_in_struct_init #(
    localparam int unsigned XLEN = 32
)();

    typedef struct packed {
        int unsigned ADDR_WIDTH;
        int unsigned DATA_WIDTH;
        int unsigned CODE_WIDTH;
    } phy_t;

    localparam phy_t PHY1 = '{
        ADDR_WIDTH: 12,
        DATA_WIDTH: 32,
        CODE_WIDTH: 1024
    };

    localparam phy_t PHY2 = '{
        ADDR_WIDTH: 20,
        DATA_WIDTH: 32,
        CODE_WIDTH: XLEN
    };

    localparam phy_t PHY3 = '{
        ADDR_WIDTH: XLEN,
        DATA_WIDTH: 64,
        CODE_WIDTH: 512
    };

//    /* verilator lint_off WIDTHCONCAT */
    localparam phy_t PHY4 = '{
        ADDR_WIDTH: XLEN,
        DATA_WIDTH: int'(XLEN),
        CODE_WIDTH: 256
    };
//    /* verilator lint_on WIDTHCONCAT */

    initial
    begin
        $display("%s PHY1.ADDR_WIDTH = %d", $typename(PHY1.ADDR_WIDTH), PHY1.ADDR_WIDTH);
        $display("%s PHY1.DATA_WIDTH = %d", $typename(PHY1.DATA_WIDTH), PHY1.DATA_WIDTH);
        $display("%s PHY1.CODE_WIDTH = %d", $typename(PHY1.CODE_WIDTH), PHY1.CODE_WIDTH);
        $display("%s PHY2.ADDR_WIDTH = %d", $typename(PHY2.ADDR_WIDTH), PHY2.ADDR_WIDTH);
        $display("%s PHY2.DATA_WIDTH = %d", $typename(PHY2.DATA_WIDTH), PHY2.DATA_WIDTH);
        $display("%s PHY2.CODE_WIDTH = %d", $typename(PHY2.CODE_WIDTH), PHY2.CODE_WIDTH);
        $display("%s PHY3.ADDR_WIDTH = %d", $typename(PHY3.ADDR_WIDTH), PHY3.ADDR_WIDTH);
        $display("%s PHY3.DATA_WIDTH = %d", $typename(PHY3.DATA_WIDTH), PHY3.DATA_WIDTH);
        $display("%s PHY3.CODE_WIDTH = %d", $typename(PHY3.CODE_WIDTH), PHY3.CODE_WIDTH);
        $display("%s PHY4.ADDR_WIDTH = %d", $typename(PHY4.ADDR_WIDTH), PHY4.ADDR_WIDTH);
        $display("%s PHY4.DATA_WIDTH = %d", $typename(PHY4.DATA_WIDTH), PHY4.DATA_WIDTH);
        $display("%s PHY4.CODE_WIDTH = %d", $typename(PHY4.CODE_WIDTH), PHY4.CODE_WIDTH);
    end

endmodule: verilator_localparam_in_struct_init