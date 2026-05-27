module yosys_latch (
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
    always @*
    if      (dlatch_nn0_rn == 1'b0) dlatch_nn0_q <= 1'b0;
    else if (dlatch_nn0_gn == 1'b0) dlatch_nn0_q <= dlatch_nn0_d;

endmodule: yosys_latch