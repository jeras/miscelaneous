interface tcb_if #(
  parameter int unsigned ADR = 32,
  parameter int unsigned DAT = 32
)(  
  // system signals
  input  logic clk,  // clock
  input  logic rst   // reset
);

////////////////////////////////////////////////////////////////////////////////
// I/O ports
////////////////////////////////////////////////////////////////////////////////

  // handshake
  logic vld;  // valid
  logic rdy;  // ready

  // local signal
  logic trn;

  // request/response
  logic           wen;  // write enable
  logic [ADR-1:0] adr;  // address
  logic [DAT-1:0] wdt;  // write data
  logic [DAT-1:0] rdt;  // read data

////////////////////////////////////////////////////////////////////////////////
// local logic
////////////////////////////////////////////////////////////////////////////////

  assign trn = vld & rdy;

  ////////////////////////////////////////////////////////////////////////////////
// modports
////////////////////////////////////////////////////////////////////////////////

  // manager
  modport  man (
    // handshake
    output vld,
    input  rdy,
    // request/response
    output wen,
    output adr,
    output wdt,
    input  rdt,
    // local
    input  trn
  );

  // monitor
  modport  mon (
    // handshake
    input  vld,
    input  rdy,
    // request/response
    input  wen,
    input  adr,
    input  wdt,
    input  rdt,
    // local
    input  trn
  );

  // subordinate
  modport  sub (
    // handshake
    input  vld,
    output rdy,
    // request/response
    input  wen,
    input  adr,
    input  wdt,
    output rdt,
    // local
    input  trn
  );

////////////////////////////////////////////////////////////////////////////////
// clocking
////////////////////////////////////////////////////////////////////////////////

  // manager
  clocking cb_man @(posedge clk);
    // handshake
    output vld;
    input  rdy;
    // request/response
    output wen;
    output adr;
    output wdt;
    input  rdt;
    // local
    input  trn;
  endclocking

  // monitor
  clocking cb_mon @(posedge clk);
    // handshake
    input  vld;
    input  rdy;
    // request/response
    input  wen;
    input  adr;
    input  wdt;
    input  rdt;
    // local
    input  trn;
  endclocking

  // subordinate
  clocking cb_sub @(posedge clk);
    // handshake
    input  vld;
    output rdy;
    // request/response
    input  wen;
    input  adr;
    input  wdt;
    output rdt;
    // local
    input  trn;
  endclocking

  modport man_cb (clocking cb_man);
  modport mon_cb (clocking cb_mon);
  modport sub_cb (clocking cb_sub);

endinterface: tcb_if
