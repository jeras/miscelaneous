`timescale 1ns/1ps

module axis_tb;

  localparam  WORD_W=8, BUS_W=8,
              N_BEATS=10, WORDS_PER_BEAT=BUS_W/WORD_W,
              PROB_VALID=30, PROB_READY=30,
              CLK_PERIOD=10, NUM_EXP=50;

  logic clk;
  logic rstn;
  // AXI-Stream
  logic                                               valid;
  logic                                               ready;
  logic              [WORDS_PER_BEAT-1:0][WORD_W-1:0] data;
  // local signals
  logic              [WORDS_PER_BEAT-1:0][WORD_W-1:0] in_beat;
  logic [N_BEATS-1:0][WORDS_PER_BEAT-1:0][WORD_W-1:0] tx_data, rx_data;

  // clock generator
  // NOTE: not sure which assignment operator is correct, but I usually use =
  initial                clk = 1'b1;
  always #(CLK_PERIOD/2) clk = ~clk;

  // VIP instances
  AXIS_TX #(.WORD_W(WORD_W), .BUS_W(BUS_W), .PROB_VALID(PROB_VALID), .N_BEATS(N_BEATS)) tx (.*);
  AXIS_RX #(.WORD_W(WORD_W), .BUS_W(BUS_W), .PROB_READY(PROB_READY), .N_BEATS(N_BEATS)) rx (.*);

  initial begin
    $dumpfile ("dump.vcd"); $dumpvars;
    rstn = 0;
    repeat(5) @(posedge clk);
    rstn <= 1;
    repeat(5) @(posedge clk);

    // initialize reference data beat
    foreach (tx_data[n]) begin
      foreach (in_beat[w])
        in_beat[w] = $urandom_range(0,2**WORD_W-1);
      tx_data[n] = in_beat;
    end
    
    // TX
    for (int i=0; i<NUM_EXP; i++) begin: tx_loop
      // drive data stream
      tx.axis_push_packet(tx_data);
    end: tx_loop
    // wait for RX to finish
    forever begin
      @(posedge clk);
    end
  end

  initial begin
    // RX
    for (int i=0; i<NUM_EXP; i++) begin: rx_loop
      // clear RX data array
      rx_data = 'x;
      // sample data stream
      rx.axis_pull_packet(rx_data);
      // check data for correctness
      assert (rx_data == tx_data)
        $display("Packet[%0d]: Outputs match: %h", i, rx_data);
      else $error("Packet[%0d]: Expected: %h != Received: %h", i, tx_data, rx_data);
    end: rx_loop
    repeat(5) @(posedge clk);
    $finish();
  end

//  initial begin
//    repeat(100) @(posedge clk);
//    $display("TIMEOUT");
//    $finish();
//  end
endmodule: axis_tb


module AXIS_TX #(
  parameter  WORD_W=8, BUS_W=8, PROB_VALID=20,
             N_BEATS=10,
  localparam WORDS_PER_BEAT = BUS_W/WORD_W
)(
  // system signals
  input  logic clk,
  // AXI-Stream
  output logic                                  valid,
  input  logic                                  ready,
  output logic [WORDS_PER_BEAT-1:0][WORD_W-1:0] data
);
  // initialize stream
  initial begin
    valid = 1'b0;
    data  = 'x;
  end

  task automatic axis_push_packet(
    // reference data
    input  logic [N_BEATS-1:0][WORDS_PER_BEAT-1:0][WORD_W-1:0] tx_data
  );
    // loop over beats
    for (int i=0; i<N_BEATS; i++) begin
      // randomize valid timing
      while ($urandom_range(0,99) >= PROB_VALID) begin
        @(posedge clk);
      end
      // drive stream
      valid <= 1'b1;
      data  <= tx_data[i];
      // wait for transfer
      do begin
        @(posedge clk);
      end while (~(valid & ready));
      // clear the valid signal
      valid <= 1'b0;
      data  <= 'x;
    end
  endtask: axis_push_packet
endmodule: AXIS_TX


module AXIS_RX #(
  parameter  WORD_W=8, BUS_W=8, PROB_READY=20,
             N_BEATS=10,
             WORDS_PER_BEAT = BUS_W/WORD_W
)(
  // system signals
  input  logic clk,
  // AXI-Stream
  input  logic                                  valid,
  output logic                                  ready,
  input  logic [WORDS_PER_BEAT-1:0][WORD_W-1:0] data
);

  logic [WORDS_PER_BEAT-1:0][WORD_W-1:0] data_t;

  // initialize stream
  initial begin
    ready = 1'b0;
  end

  task automatic axis_pull_packet(
    // sampled data
    output logic [N_BEATS-1:0][WORDS_PER_BEAT-1:0][WORD_W-1:0] data_o
  );
    // loop over beats
    for (int i=0; i<N_BEATS; i++) begin
      while ($urandom_range(0,99) >= PROB_READY) begin
        @(posedge clk);
      end
      ready <= 1'b1;
      // wait for transfer
      do begin
        @(posedge clk);
      end while (~(valid & ready));
      // sample stream
      data_t <= data;
      // clear the ready signal
      ready <= 1'b0;
      // write to array
      data_o[i] = data;
    end
  endtask: axis_pull_packet
endmodule: AXIS_RX
