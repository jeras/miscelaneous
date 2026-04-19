`timescale 1ns/1ps

module spm_sdf_tb #(
    parameter int SIZE = 32
)();

    logic clk = 1'b1;
    logic rst = 1'b1;

    wire  [  SIZE-1:0] mc;
    wire  [  SIZE-1:0] mp;
    wire  [2*SIZE-1:0] p;
    logic              start;
    wire               done;

    always #5 clk = ~clk;

    initial begin
        repeat(4) @(posedge clk);
        #1;
        rst <= 1'b0;
        repeat(4) @(posedge clk);
        #1;
        mc <= 'd5;
        mp <= 'd11;
        start <= 1'b1;
        do @(posedge clk);
        while (done == 1'b0);
        repeat(4) @(posedge clk);
        $finish();
    end

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
        $sdf_annotate("../runs/RUN_2026-04-17_02-34-38/final/sdf/nom_ss_100C_1v60/spm__nom_ss_100C_1v60.sdf", dut);
        $dumpfile("spm_sdf_tb.vcd");
        $dumpvars(0, spm_sdf_tb);
//        $dumpvars(0, dut);
    end

endmodule
                      