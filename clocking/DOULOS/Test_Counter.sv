module Test_Counter;
    timeunit 1ns;
  
    reg Clock = 0, Reset, Enable, Load, UpDn;
  
    reg [7:0] Data;
    wire [7:0] Q;
    reg OK;
  
    // Clock generator
    always
    begin
      #5 Clock = 1;
      #5 Clock = 0;
    end
  
    // Test stimulus
    initial
    begin
      Enable = 0;
      Load = 0;
      UpDn = 1;
      Reset = 1;
      #10; // Should be reset
      Reset = 0;
      #10; // Should do nothing - not enabled
      Enable = 1;    #20; // Should count up to 2
      UpDn = 0;
      #40; // Should count downto 254
      UpDn = 1;
  
      // etc. ...
    end
  
    // Instance the device-under-test
    COUNTER G1 (Clock, Reset, Enable, Load, UpDn, Data, Q);
  
    // Check the results
    initial
    begin
      OK = 1;
      #9;
      if (Q !== 8'b00000000)
        OK = 0;
      #10;
      if (Q !== 8'b00000000)
        OK = 0;
      #20;
      if (Q !== 8'b00000010)
        OK = 0;
      #40;
      if (Q !== 8'b11111110)
        OK = 0;
      // etc. ...
    end
  endmodule
  