module priority_multiplexer_wrapper #(
    parameter int WIDTH = 8,
    parameter int LENGTH = 16
)(
    // system signals
    input  logic clk,
    // control
    input  logic [LENGTH-1:0] ena,
    // data input/output
    input  logic [WIDTH-1:0] data_i,
    output logic [WIDTH-1:0] data_o
);

    logic [LENGTH-1:0] ena_r;

    logic        [WIDTH-1:0] buffer_i;
    logic [LENGTH*WIDTH-1:0] shifter;
    logic        [WIDTH-1:0] buffer_o;

    // shifting data into a buffer
    always_ff @(posedge clk)
    begin
        buffer_i <= data_i;
        shifter[0+:WIDTH] <= buffer_i;
        for (int i=1; i<LENGTH; i++) begin
            shifter[WIDTH*i+:WIDTH] <= shifter[WIDTH*i-1+:WIDTH];
        end
    end

    // register control signals
    always_ff @(posedge clk)
    begin
        ena_r <= ena;
    end

    // multiplexer
    $pmux #(
        .WIDTH (WIDTH),
        .S_WIDTH (LENGTH)
    ) mux (
        .A (buffer_i),
        .B (shifter),
        .S (ena_r),
        .Y (buffer_o)
    );

    // output register
    always_ff @(posedge clk)
    begin
        data_o <= buffer_o;
    end

endmodule: priority_multiplexer_wrapper
