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
    // DELAY LATCH
    input  logic latch_d,  // data input
    input  logic latch_g,  // gate
    output logic latch_q   // data output
);

    // multiplexers
    assign mux2_o  =  mux2_i [mux2_s ];
    assign mux2i_o = ~mux2i_i[mux2i_s];
    assign mux4_o  =  mux4_i [mux4_s ];
    assign mux8_o  =  mux8_i [mux8_s ];
    assign mux16_o =  mux16_i[mux16_s];

    // delay latch
    always_latch
    if (latch_g) latch_q <= latch_d;

endmodule: synthesis_primitives