`timescale 1ns/1ps

module pm32_tb #(
    parameter int SIZE = 32
)();

    logic clk = 1'b1;
    logic rst = 1'b1;

    logic [  SIZE-1:0] mc;
    logic [  SIZE-1:0] mp;
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
        $dumpfile("pm32_tb.vcd");
        $dumpvars(0, pm32_tb);
    end

endmodule
                      