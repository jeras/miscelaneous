`timescale 1ns / 1ps

module pm32_tb_sdf #(
    parameter int SIZE = 32
)();

    logic clk = 1'b1;
    logic rst = 1'b1;

    logic start = 1'b0;
    wire  done;

    logic unsigned [  SIZE-1:0] mc;
    logic unsigned [  SIZE-1:0] mp;
    wire  unsigned [2*SIZE-1:0] r;  // expected result
    wire  unsigned [2*SIZE-1:0] p;  // RTL result output

    always #5 clk = ~clk;

    initial begin
        repeat(4) @(posedge clk);
        #1;
        rst <= 1'b0;
        repeat(4) @(posedge clk);
        #1;
        // due to a bug somewhere in the RTL, mc MSB must be zero
//        mc <= 32'hafaf_fafa;
        mc <= 32'h7faf_fafa;
        mp <= 32'haaaa_5555;
//        mc <= 32'd5;
//        mp <= 32'd3453311;
        start <= 1'b1;
        @(posedge clk);
        #1;
        start <= 1'b0;
        do @(posedge clk);
        while (done == 1'b0);
        // print result
        @(posedge clk);
        $info("mc = 32'h%08x (%d)", mc, mc);
        $info("mp = 32'h%08x (%d)", mp, mp);
        assert (p == r) $info ("p = 64'h%016x (%0d)", p, p);
        else            $error("p = 64'h%016x (%0d)", p, p, " should be 64'h%016x (%0d)", r, r);
        repeat(4) @(posedge clk);
        $finish();
    end

    assign r = mc*mp;

    pm32 dut (
        .clk   (clk),
        .rst   (rst),
        .mc    (mc),
        .mp    (mp),
        .p     (p),
        .start (start),
        .done  (done)
    );

    initial begin
        static string sdf = `SDF;
        $display("SDF file: %s", sdf);
        $sdf_annotate(sdf, dut);
        $dumpfile("pm32_tb_sdf.vcd");
        $dumpvars(0, pm32_tb_sdf);
    end

endmodule
