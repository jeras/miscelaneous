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
    output logic [2*SIZE-1:0] p,
    input  wire               start,
    output logic              done
);
    wire                       pw;
    logic [       SIZE   -1:0] Y;
    logic [$clog2(SIZE)+3-1:0] cnt, ncnt;
    logic                      state, pstate;

    localparam IDLE=0, RUNNING=1;

    always @(posedge clk, posedge rst)
    if (rst) begin
        state <= IDLE;
        pstate <= IDLE;
        done <= 1'b0;
    end 
    else begin
        case (state)
            IDLE    :   if(start)         state <= RUNNING; else state <= IDLE   ;
            RUNNING :   if(cnt == 2*SIZE) state <= IDLE   ; else state <= RUNNING; 
            default :                     state <= IDLE   ;
        endcase
        pstate <= state;
        done <= pstate & ~state;
    end
    
    always @(posedge clk)
    cnt <= ncnt;

    always @*
    case(state)
        IDLE    :   ncnt = 0;
        RUNNING :   ncnt = cnt + 1;
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

endmodule
