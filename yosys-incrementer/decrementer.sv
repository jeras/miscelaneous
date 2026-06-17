// Copyright 2026 Iztok Jeras
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

module decrementer #(
    parameter int unsigned W = 8
)(
    // system signals
    input  logic clk,
    input  logic rst,
    // decrementer signals
    input  logic         load,
    input  logic         dec,
    input  logic [W-1:0] val,
    output logic [W-1:0] cnt
);

    logic ena;

    assign ena = dec | load;

    always_ff @(posedge clk, posedge rst)
    if (rst)  cnt <= '0;
    else if (ena) begin
        if (load)  cnt <= val;
        else       cnt <= cnt - dec;
    end

//    always_ff @(posedge clk, posedge rst)
//    if (rst)  cnt <= '0;
//    else if (ena) begin
//        if (load)      cnt <= val;
//        else if (dec)  cnt <= cnt + 'd1;
//    end

//    always_ff @(posedge clk, posedge rst)
//    if (rst)  cnt <= '0;
//    else if (load) cnt <= val;
//    else if (dec)  cnt <= cnt + 'd1;

//    always_ff @(posedge clk, posedge rst)
//    if (rst)  cnt <= '0;
//    else if (load) cnt <= val;
//    else           cnt <= cnt + dec;

endmodule: decrementer
