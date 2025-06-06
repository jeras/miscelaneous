module leading_1_in_mantisa_tb #(
    parameter  int unsigned WIDTH = 8,
    localparam int unsigned WIDTH_LOG = $clog2(WIDTH),
//    parameter string IMPLEMENTATION = "NAIVE"
    parameter string IMPLEMENTATION = "FPGA"
);

    // timing constant
    localparam time T = 10ns;

    // input
    logic [WIDTH    -1:0] Sum_mag;
    // priority encoder
    logic [WIDTH_LOG-1:0] msb_pos;
    // reference encoder
    logic [WIDTH_LOG-1:0] msb_pos_ref;

///////////////////////////////////////////////////////////////////////////////
// reference calculation and checking of DUT outputs against reference
///////////////////////////////////////////////////////////////////////////////

    function automatic [WIDTH_LOG-1:0] encoder (
        logic [WIDTH-1:0] Sum_mag
    );
        for (int i=WIDTH-1; i>0; i--) begin
            if (Sum_mag[i])  return WIDTH_LOG'(i);
        end
        return '0;
    endfunction: encoder

    // reference encoder
    always_comb
    begin
        msb_pos_ref = encoder(Sum_mag);
    end

    // output checking task
    task check();
        #T;
        assert (msb_pos ==? msb_pos_ref) else $error("(msb_pos = %0d) != (msb_pos_ref = %0d)", msb_pos, msb_pos_ref);
        #T;
    endtask: check

///////////////////////////////////////////////////////////////////////////////
// test
///////////////////////////////////////////////////////////////////////////////

    // test name
    string        test_name;

    // test sequence
    initial
    begin
        // idle test
        test_name = "idle";
        Sum_mag <= '0;
        check;

        // one-hot encoder test
        test_name = "one-hot";
        for (int unsigned i=0; i<WIDTH; i++) begin
            logic [WIDTH-1:0] tmp;
            tmp = '0;
            tmp[i] = 1'b1;
            Sum_mag <= tmp;
            check;
        end

        // priority encoder test (with undefined inputs)
        test_name = "priority";
        for (int unsigned i=0; i<WIDTH; i++) begin
            logic [WIDTH-1:0] tmp;
            tmp = 'x;
            tmp[i] = 1'b1;
            for (int unsigned j=i+1; j<WIDTH; j++) begin
                tmp[j] = 1'b0;
            end
            Sum_mag <= tmp;
            check;
        end
//        $finish;

        // priority encoder test (going through all input combinations)
        test_name = "exhaustive";
        for (int unsigned tmp=0; tmp<2**WIDTH; tmp++) begin
            Sum_mag <= tmp[WIDTH-1:0];
            check;
        end
        $finish;
    end

///////////////////////////////////////////////////////////////////////////////
// DUT instance array (for each implementation)
///////////////////////////////////////////////////////////////////////////////

    // DUT RTL instance
    leading_1_in_mantisa #(
        .WIDTH (WIDTH),
        .IMPLEMENTATION (IMPLEMENTATION)
    ) dut (
        .Sum_mag (Sum_mag),
        .msb_pos (msb_pos)
    );

endmodule: leading_1_in_mantisa_tb
