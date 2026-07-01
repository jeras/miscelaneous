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

module riscv_alu #(
    parameter int unsigned XLEN = 8
)(
    // incrementer signals
    input  logic signed [XLEN-1:0] opa,
    input  logic signed   [4-1:0] opb,
    output logic signed [XLEN-1:0] sum
);

    assign sum = opa + opb;

endmodule: riscv_alu
