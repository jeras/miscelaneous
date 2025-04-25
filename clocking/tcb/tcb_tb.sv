module tcb_tb #(
  parameter int unsigned ADR = 32,
  parameter int unsigned DAT = 32
)();

  // system signals
  logic clk = 1'b1;
  logic rst = 1'b1;

  // interface
  tcb_if #(ADR, DAT) tcb (clk, rst);

  // clock (100MHz)
  always #(10ns/2) clk = ~clk;

  // test sequence
  initial
  begin
    // reset sequence
    rst = 1'b1;
    repeat (2) @(posedge clk);
    rst <= 1'b0;
    repeat (20) @(posedge clk);
    $finish();
  end

  // manager
  tcb_man_prg man_prg (tcb);

  // subordinate
  tcb_sub_prg sub_prg (tcb);

endmodule: tcb_tb


program tcb_man_prg (
  tcb_if.man_cb tcb
);

  task write (
    input [tcb.ADR-1:0] adr,
    input [tcb.DAT-1:0] dat
  );
    tcb.cb_man.vld <= 1'b1;
    tcb.cb_man.wen <= 1'b1;
    tcb.cb_man.adr <= adr;
    tcb.cb_man.wdt <= dat;
    do begin
      @tcb.cb_man;
    end while (~tcb.cb_man.trn);
    tcb.cb_man.wen <= 1'bx;
    tcb.cb_man.adr <= 'x;
    tcb.cb_man.wdt <= 'x;
    tcb.cb_man.vld <= 1'b0;
  endtask: write

  task read (
    input [tcb.ADR-1:0] adr,
    input [tcb.DAT-1:0] dat
  );
    tcb.cb_man.adr <= adr;
    tcb.cb_man.wen <= 1'b0;
    do begin
      @tcb.cb_man;
    end while (~tcb.cb_man.trn);
    tcb.cb_man.wen <= 1'bx;
    tcb.cb_man.adr <= 'x;
    tcb.cb_man.wdt <= 'x;
    tcb.cb_man.vld <= 1'b0;
    dat <= tcb.cb_man.rdt;
  endtask: read

  initial
  begin
    tcb.cb_man.vld <= 1'b0;
    repeat (4) @tcb.cb_man;
    write('h0000_0000, 'h01234567);
    write('h0000_0004, 'h89abcdef);
    repeat (4) @tcb.cb_man;
  end

endprogram: tcb_man_prg

program tcb_sub_prg (
  tcb_if.sub_cb tcb
);

  logic [tcb.DAT-1:0] mem [256];

  task access (
    input [tcb.DAT-1:0] dat
  );
    tcb.cb_sub.rdy <= 1'b1;
    do begin
      @tcb.cb_sub;
    end while (~tcb.cb_sub.trn);
    tcb.cb_sub.rdy <= 1'b0;
    if (tcb.cb_sub.wen) begin
      mem[tcb.cb_sub.adr] <= tcb.cb_sub.wdt;
    end else begin
      tcb.cb_sub.rdt <= dat;
    end
  endtask: access

  initial
  begin
    tcb.cb_sub.rdy <= 1'b0;
    repeat (8) @tcb.cb_sub;
    access('h76543210);
    access('hfedcba98);
    repeat (4) @tcb.cb_sub;
  end

endprogram: tcb_sub_prg