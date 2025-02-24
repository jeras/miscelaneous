`timescale 1ns/1ps

module axis_tb;
 
  localparam  WORD_W=8, BUS_W=8, 
              N_BEATS=10, WORDS_PER_BEAT=BUS_W/WORD_W,
              PROB_VALID=10, PROB_READY=10,
              CLK_PERIOD=10, NUM_EXP=500;

  logic clk=0, rstn=1;
  logic s_ready, s_valid, m_ready, m_valid;
  logic              [WORDS_PER_BEAT-1:0][WORD_W-1:0] s_data, m_data, in_beat;
  logic [N_BEATS-1:0][WORDS_PER_BEAT-1:0][WORD_W-1:0] in_data, out_data, exp_data;

  logic [N_BEATS*WORD_W*WORDS_PER_BEAT-1:0] queue [$];

  initial forever #(CLK_PERIOD/2) clk <= ~clk;

  AXIS_Source #(.WORD_W(WORD_W), .BUS_W(BUS_W), .PROB_VALID(PROB_VALID), .N_BEATS(N_BEATS)) source (.*);
  AXIS_Sink   #(.WORD_W(WORD_W), .BUS_W(BUS_W), .PROB_READY(PROB_READY), .N_BEATS(N_BEATS)) sink   (.*);

  assign s_ready = m_ready;
  assign m_data = s_data;
  assign m_valid = s_valid;

  initial begin
    $dumpfile ("dump.vcd"); $dumpvars;
    rstn = 0;
    repeat(5) @(posedge clk);
    rstn = 1;
    repeat(5) @(posedge clk);

    repeat(NUM_EXP) begin
      foreach (in_data[n]) begin
        foreach (in_beat[w])
          in_beat[w] = $urandom_range(0,2**WORD_W-1);
        in_data[n] = in_beat;
      end
      queue.push_front(in_data); 
// append to end of queue
      #1
      source.axis_push_packet;
    end
  end

  initial begin
    repeat(NUM_EXP) begin
      sink.axis_pull_packet;
      exp_data = queue.pop_back();
      assert (exp_data == out_data) 
// remove last element
        $display("Outputs match: %d", exp_data);
      else $fatal(0, "Expected: %h != Output: %h", exp_data, out_data);
    end
    $finish();
  end
endmodule



module AXIS_Sink #(
  parameter  WORD_W=8, BUS_W=8, PROB_READY=20,
             N_BEATS=10,
             WORDS_PER_BEAT = BUS_W/WORD_W
)(
    input  logic clk, m_valid,
    output logic m_ready=0,
    input  logic [WORDS_PER_BEAT-1:0][WORD_W-1:0] m_data,
    output logic [N_BEATS-1:0][WORDS_PER_BEAT-1:0][WORD_W-1:0] out_data
);
  int i_beats = 0;
  bit done = 0;
  
  task axis_pull_packet;
    while (!done) begin
      
      @(posedge clk)
      if (m_ready && m_valid) begin  
// read at posedge
        out_data[i_beats] = m_data;
        i_beats += 1;
        done = (i_beats == N_BEATS);
      end

      #10ps m_ready = ($urandom_range(0,99) < PROB_READY);
    end
    {m_ready, i_beats, done} ='0;
  endtask
endmodule



module AXIS_Source #(
  parameter  WORD_W=8, BUS_W=8, PROB_VALID=20, 
             N_BEATS=10,
  localparam WORDS_PER_BEAT = BUS_W/WORD_W
)(
    input  logic [N_BEATS-1:0][WORDS_PER_BEAT-1:0][WORD_W-1:0] in_data,
    input  logic clk, s_ready, 
    output logic s_valid=0,
    output logic [WORDS_PER_BEAT-1:0][WORD_W-1:0] s_data='0
);
  int i_beats = 0;
  bit prev_handshake = 1; 
// data is released first
  bit done = 0;
  logic [WORDS_PER_BEAT-1:0][WORD_W-1:0] s_data_val;

  task axis_push_packet;
    
// iverilog doesnt support break. so the loop is rolled to have break at top
    while (!done) begin
      if (prev_handshake) begin  
// change data
        s_data_val = in_data[i_beats];
        i_beats    += 1;
      end
      s_valid = $urandom_range(0,99) < PROB_VALID;      
// randomize s_valid
      
// scramble data signals on every cycle if !valid to catch slave reading it at wrong time
      s_data = s_valid ? s_data_val : 'x;

      
// -------------- LOOP BEGINS HERE -----------
      @(posedge clk);
      prev_handshake = s_valid && s_ready; 
// read at posedge
      done           = s_valid && s_ready && (i_beats==N_BEATS);
      
      #10ps; 
// Delay before writing s_valid, s_data, s_keep
    end
    {s_valid, s_data, i_beats, done} = '0;
    prev_handshake = 1;
  endtask
endmodule
