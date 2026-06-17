module synthesis_primitives (
    // system signals
    input  logic clk,
    input  logic rst,
    // MUX2
    input  logic [       2 -1:0] mux2_i,
    input  logic [$clog2(2)-1:0] mux2_s,
    output logic                 mux2_o,
    // MUX2I
    input  logic [       2 -1:0] mux2i_i,
    input  logic [$clog2(2)-1:0] mux2i_s,
    output logic                 mux2i_o,
    // MUX4
    input  logic [       4 -1:0] mux4_i,
    input  logic [$clog2(4)-1:0] mux4_s,
    output logic                 mux4_o,
    // MUX8
    input  logic [       8 -1:0] mux8_i,
    input  logic [$clog2(8)-1:0] mux8_s,
    output logic                 mux8_o,
    // MUX4
    input  logic [       16 -1:0] mux16_i,
    input  logic [$clog2(16)-1:0] mux16_s,
    output logic                  mux16_o,
    // DELAY FLOP
    input  logic flop_d,  // data input
    output logic flop_q,  // data output
    // DELAY LATCH
    input  logic dlatch_p_d,   // data input
    input  logic dlatch_p_g,   // gate
    output logic dlatch_p_q,   // data output
    // DELAY LATCH
    input  logic dlatch_n_d,   // data input
    input  logic dlatch_n_gn,  // gate
    output logic dlatch_n_q,   // data output
    // DELAY LATCH
    input  logic dlatch_pn0_d,   // data input
    input  logic dlatch_pn0_rn,  // reset
    input  logic dlatch_pn0_g,   // gate
    output logic dlatch_pn0_q,   // data output
    // DELAY LATCH
    input  logic dlatch_nn0_d,   // data input
    input  logic dlatch_nn0_rn,  // reset
    input  logic dlatch_nn0_gn,  // gate
    output logic dlatch_nn0_q    // data output
);

    // multiplexers
    assign mux2_o  =  mux2_i [mux2_s ];
    assign mux2i_o = ~mux2i_i[mux2i_s];
    assign mux4_o  =  mux4_i [mux4_s ];
    assign mux8_o  =  mux8_i [mux8_s ];
    assign mux16_o =  mux16_i[mux16_s];

    // delay flop
    always_ff @(posedge clk)
    flop_q <= flop_d;

    // delay latch
    always_latch
    if (dlatch_p_g) dlatch_p_q <= dlatch_p_d;

    // delay latch
    always_latch
    if (~dlatch_n_gn) dlatch_n_q <= dlatch_n_d;

    // delay latch
    always_latch
    if      (~dlatch_pn0_rn) dlatch_pn0_q <= 1'b0;
    else if ( dlatch_pn0_g ) dlatch_pn0_q <= dlatch_pn0_d;

    // delay latch
    always_latch
    if      (~dlatch_nn0_rn) dlatch_nn0_q <= 1'b0;
    else if (~dlatch_nn0_gn) dlatch_nn0_q <= dlatch_nn0_d;

endmodule: synthesis_primitives