// A signed 32x32 Multiplier utilizing SPM
// 
// Copyright 2016, mshalan@aucegypt.edu

`timescale		    1ns/1ps
`default_nettype    none

module pm32 #(
    parameter int SIZE = 32
)(
    input  wire               clk,
    input  wire               rst,
    input  wire  [  SIZE-1:0] mc,
    input  wire  [  SIZE-1:0] mp,
    output reg   [2*SIZE-1:0] p,
    input  wire               start,
    output wire               done
);
    wire                      pw;
    reg  [       SIZE   -1:0] Y;
    reg  [$clog2(SIZE)+3-1:0] cnt, ncnt;
    reg                 [1:0] state, nstate;

    localparam IDLE=0, RUNNING=1, DONE=2;

    always @(posedge clk, posedge rst)
    if (rst)  state <= IDLE;
    else      state <= nstate;
    
    always @*
    case (state)
        IDLE    :   if(start)         nstate = RUNNING; else nstate = IDLE   ;
        RUNNING :   if(cnt == 2*SIZE) nstate = DONE   ; else nstate = RUNNING; 
        DONE    :   if(start)         nstate = RUNNING; else nstate = DONE   ;
        default :                     nstate = IDLE   ;
    endcase
    
    always @(posedge clk)
    cnt <= ncnt;

    always @*
    case(state)
        IDLE    :   ncnt = 0;
        RUNNING :   ncnt = cnt + 1;
        DONE    :   ncnt = 0;
        default :   ncnt = 0;
    endcase

    always @(posedge clk, posedge rst)
    if (rst)
        Y <= '0;
    else if((start == 1'b1))
        Y <= mp;
    else if(state==RUNNING) 
        Y <= (Y >> 1);

    always @(posedge clk, posedge rst)
    if(rst)
        p <= '0;
    else if(start)
        p <= '0;
    else if(state==RUNNING)
        p <= {pw, p[2*SIZE-1:1]};

    wire y = (state==RUNNING) ? Y[0] : 1'b0;

    spm #(
        .SIZE(SIZE)
    ) spm32 (
        .clk (clk),
        .rst (rst),
        .x   (mc),
        .y   (y),
        .p   (pw)
    );

    assign done = (state == DONE);

endmodule
