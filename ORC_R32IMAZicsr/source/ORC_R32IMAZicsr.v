/////////////////////////////////////////////////////////////////////////////////
// BSD 3-Clause License
// 
// Copyright (c) 2020, Jose R. Garcia
// All rights reserved.
// 
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are met:
// 
// 1. Redistributions of source code must retain the above copyright notice, this
//    list of conditions and the following disclaimer.
// 
// 2. Redistributions in binary form must reproduce the above copyright notice,
//    this list of conditions and the following disclaimer in the documentation
//    and/or other materials provided with the distribution.
// 
// 3. Neither the name of the copyright holder nor the names of its
//    contributors may be used to endorse or promote products derived from
//    this software without specific prior written permission.
// 
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
// AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
// IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
// DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
// FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
// DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
// SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
// CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
// OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
// OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//
/////////////////////////////////////////////////////////////////////////////////
// File name     : ORC_R32IMAZicsr.v
// Author        : Jose R Garcia
// Created       : 2020/11/04 23:20:43
// Last modified : 2020/12/23 13:06:40
// Project Name  : ORCs
// Module Name   : ORC_R32IMAZicsr
// Description   : The ORC_R32IMAZicsr is a machine mode capable hart implementation of 
//                 the riscv32im instruction set architecture.
//
// Additional Comments:
//   
/////////////////////////////////////////////////////////////////////////////////
module ORC_R32IMAZicsr #(
  // Compile time configurable generic parameters
  parameter P_FETCH_COUNTER_RESET = 32'h0000_0000, // First instruction address
  parameter P_DIVISION_STEPS      = 4              // Num of divider iterations
)(
  // Component's clocks and resets
  input i_clk,        // clock
  input i_reset_sync, // reset
  // Instruction Wishbone(pipeline) Master Read Interface
  output        o_inst_read_stb,  // WB read enable
  input         i_inst_read_ack,  // WB acknowledge 
  output [31:0] o_inst_read_addr, // WB address
  input  [31:0] i_inst_read_data, // WB data
  // Wishbone(pipeline) Master Read Interface
  output        o_master_read_stb,  // WB read enable
  input         i_master_read_ack,  // WB acknowledge 
  output [31:0] o_master_read_addr, // WB address
  input  [31:0] i_master_read_data, // WB data
  // Wishbone(pipeline) Master Write Interface
  output        o_master_write_stb,  // WB write enable
  input         i_master_write_ack,  // WB acknowledge 
  output [31:0] o_master_write_addr, // WB address
  output [31:0] o_master_write_data, // WB data
  output [3:0]  o_master_write_sel   // WB byte enable
);
  ///////////////////////////////////////////////////////////////////////////////
  // Internal Parameter Declarations
  ///////////////////////////////////////////////////////////////////////////////

  ///////////////////////////////////////////////////////////////////////////////
  // Internal Signals Declarations
  ///////////////////////////////////////////////////////////////////////////////
  // Hart_Core to HCC Processor connecting wires.
  wire        w_hcc_processor_stb;
  wire        w_hcc_processor_ack;
  wire        w_hcc_processor_addr;
  wire [63:0] w_hcc_processor_factors;
  wire [63:0] w_hcc_processor_result;

  ///////////////////////////////////////////////////////////////////////////////
  //            ********      Architecture Declaration      ********           //
  ///////////////////////////////////////////////////////////////////////////////
  
  ///////////////////////////////////////////////////////////////////////////////
  // Instance    : hart
  // Description : Hardware thread that decodes the riscv32im ISA.
  ///////////////////////////////////////////////////////////////////////////////
  Hart_Core #(P_FETCH_COUNTER_RESET) core (
    // Component's clocks and resets
    .i_clk(i_clk),               // clock
    .i_reset_sync(i_reset_sync), // reset
    // Instruction Wishbone(pipeline) Master Read Interface
    .o_inst_read_stb(o_inst_read_stb),   // WB read enable
    .i_inst_read_ack(i_inst_read_ack),   // WB acknowledge 
    .o_inst_read_addr(o_inst_read_addr), // WB address
    .i_inst_read_data(i_inst_read_data), // WB data
    // Wishbone(pipeline) Master Read Interface
    .o_master_read_stb(o_master_read_stb),   // WB read enable
    .i_master_read_ack(i_master_read_ack),   // WB acknowledge 
    .o_master_read_addr(o_master_read_addr), // WB address
    .i_master_read_data(i_master_read_data), // WB data
    // Wishbone(pipeline) Master Write Interface
    .o_master_write_stb(o_master_write_stb),   // WB write enable
    .i_master_write_ack(i_master_write_ack),   // WB acknowledge
    .o_master_write_addr(o_master_write_addr), // WB address
    .o_master_write_data(o_master_write_data), // WB data
    .o_master_write_sel(o_master_write_sel),   // WB byte enable
    // Integer Multiplier and Divider Component
    .o_master_hcc_processor_stb(w_hcc_processor_stb),      // WB valid stb
    .i_master_hcc_processor_ack(w_hcc_processor_ack),      // WB acknowledge
    .o_master_hcc_processor_addr(w_hcc_processor_addr),    // WB address
    .o_master_hcc_processor_data(w_hcc_processor_factors), // WB output data
    .i_master_hcc_processor_data(w_hcc_processor_result)   // WB input data
  );

  ///////////////////////////////////////////////////////////////////////////////
  // Instance    : HCC Arithmetic Processor
  // Description : A High Computational Cost Arithmetic Processor that handles
  //               multiplication and division operations.
  ///////////////////////////////////////////////////////////////////////////////
  HCC_Arithmetic_Processor #(63, 63, P_DIVISION_STEPS) mul_div_processor (
    .i_slave_hcc_processor_clk(i_clk),                    // clock
    .i_slave_hcc_processor_reset_sync(i_reset_sync),      //
    .i_slave_hcc_processor_stb(w_hcc_processor_stb),      // WB valid stb
    .o_slave_hcc_processor_ack(w_hcc_processor_ack),      // WB acknowledge
    .i_slave_hcc_processor_addr(w_hcc_processor_addr),    //
    .i_slave_hcc_processor_data(w_hcc_processor_factors), // 
    .o_slave_hcc_processor_data(w_hcc_processor_result)   //
  );

endmodule
