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
// File name     : Memory_Backplane.v
// Author        : Jose R Garcia
// Created       : 2020/12/23 14:17:03
// Last modified : 2020/12/28 20:30:26
// Project Name  : ORCs
// Module Name   : Memory_Backplane
// Description   : The Memory_Backplane controls access to the BRAMs.
//
// Additional Comments:
//   
/////////////////////////////////////////////////////////////////////////////////
module Memory_Backplane #(
  parameter P_MEM_ADDR_MSB     = 0,
  parameter P_MEM_DEPTH        = 0,
  parameter P_MEM_WIDTH        = 0,
  parameter P_NUM_GENERAL_REGS = 16 // Should be 16 or 32 per ISA
)(
  // Component's clocks and resets
  input i_clk,        // clock
  input i_reset_sync, // reset
  // Core mem0 WB(pipeline) Slave Read Interface
  input                     i_slave_core0_read_stb,  // WB read enable
  input  [P_MEM_ADDR_MSB:0] i_slave_core0_read_addr, // WB address
  output [P_MEM_WIDTH-1:0]  o_slave_core0_read_data, // WB data
  // Core mem0 WB(pipeline) Slave Write Interface
  input                    i_slave_core0_write_stb,  // WB write enable
  input [P_MEM_ADDR_MSB:0] i_slave_core0_write_addr, // WB address
  input [P_MEM_WIDTH-1:0]  i_slave_core0_write_data, // WB data
  // Core mem1 WB(pipeline) Slave Read Interface
  input                     i_slave_core1_read_stb,  // WB read enable
  input  [P_MEM_ADDR_MSB:0] i_slave_core1_read_addr, // WB address
  output [P_MEM_WIDTH-1:0]  o_slave_core1_read_data, // WB data
  // Core mem1 WB(pipeline) Slave Write Interface
  input                    i_slave_core1_write_stb,  // WB write enable
  input [P_MEM_ADDR_MSB:0] i_slave_core1_write_addr, // WB address
  input [P_MEM_WIDTH-1:0]  i_slave_core1_write_data, // WB data
  // HCC Processor mem0 WB(pipeline) Slave Read Interface
  input                     i_slave_hcc0_read_stb,  // WB read enable
  input  [P_MEM_ADDR_MSB:0] i_slave_hcc0_read_addr, // WB address
  output [P_MEM_WIDTH-1:0]  o_slave_hcc0_read_data, // WB data
  // HCC Processor mem0 WB(pipeline) Slave Write Interface
  input                    i_slave_hcc0_write_stb,  // WB write enable
  input [P_MEM_ADDR_MSB:0] i_slave_hcc0_write_addr, // WB address
  input [P_MEM_WIDTH-1:0]  i_slave_hcc0_write_data, // WB data
  // HCC Processor mem1 WB(pipeline) Slave Read Interface
  input                     i_slave_hcc1_read_stb,  // WB read enable
  input  [P_MEM_ADDR_MSB:0] i_slave_hcc1_read_addr, // WB address
  output [P_MEM_WIDTH-1:0]  o_slave_hcc1_read_data, // WB data
  // HCC Processor mem1 WB(pipeline) Slave Write Interface
  input                    i_slave_hcc1_write_stb,  // WB write enable
  input [P_MEM_ADDR_MSB:0] i_slave_hcc1_write_addr, // WB address
  input [P_MEM_WIDTH-1:0]  i_slave_hcc1_write_data  // WB data
);
  ///////////////////////////////////////////////////////////////////////////////
  // Internal Parameter Declarations
  ///////////////////////////////////////////////////////////////////////////////
  localparam L_REG_RESET_INDEX_MSB = $clog2(P_NUM_GENERAL_REGS)-1;

  ///////////////////////////////////////////////////////////////////////////////
  // Internal Signals Declarations
  ///////////////////////////////////////////////////////////////////////////////
  // BRAM array duplicated to index source 0 & 1 at same time or individually. 
  // A fake a dual-port BRAM of sorts.
  reg [P_MEM_WIDTH-1:0] mem_space0 [0:P_MEM_DEPTH-1]; // 37x32-bit registers,
  reg [P_MEM_WIDTH-1:0] mem_space1 [0:P_MEM_DEPTH-1]; // 37x32-bit registers, 
  // General Registers Reset
  reg [L_REG_RESET_INDEX_MSB:0] reset_index; //
  // Memory Slave Read Process
  reg [P_MEM_WIDTH-1:0] r_slave_read0_data;
  reg [P_MEM_WIDTH-1:0] r_slave_read1_data;
  // Read Case
  wire [1:0] w_read0_cases = {i_slave_core0_read_stb, i_slave_hcc0_read_stb};
  wire [1:0] w_read1_cases = {i_slave_core1_read_stb, i_slave_hcc1_read_stb};
  // Write Case
  wire [1:0] w_write0_cases = {i_slave_core0_write_stb, i_slave_hcc0_write_stb};
  wire [1:0] w_write1_cases = {i_slave_core1_write_stb, i_slave_hcc1_write_stb};

  ///////////////////////////////////////////////////////////////////////////////
  //            ********      Architecture Declaration      ********           //
  ///////////////////////////////////////////////////////////////////////////////
  
  initial begin
    // Load initial states in the brams.
    $readmemb("bram0_initial_state.mem", mem_space0);
    $readmemb("bram1_initial_state.mem", mem_space1);
  end

  ///////////////////////////////////////////////////////////////////////////////
  // Process     : General Purpose Registers Reset Index
  // Description : 
  ///////////////////////////////////////////////////////////////////////////////
  always@(posedge i_clk) begin
    if (i_reset_sync == 1'b1) begin
      reset_index <= reset_index+1;
    end
    else begin
      reset_index <= 0;
    end
  end

  ///////////////////////////////////////////////////////////////////////////////
  // Process     : mem_space0 Read Process
  // Description : 
  ///////////////////////////////////////////////////////////////////////////////
  always@(posedge i_clk) begin
    casez (w_read0_cases)
      2'b01 : begin
        // HCC Processor read access
        r_slave_read0_data <= mem_space0[i_slave_hcc0_read_addr];
      end
      2'b10 : begin
        // Core read access
        r_slave_read0_data <= mem_space0[i_slave_core0_read_addr];
      end
      default : begin
        r_slave_read0_data <= r_slave_read0_data;
      end
    endcase
  end
  // 
  assign o_slave_core0_read_data = r_slave_read0_data;
  assign o_slave_hcc0_read_data  = r_slave_read0_data;

  ///////////////////////////////////////////////////////////////////////////////
  // Process     : mem_space0 Write Process
  // Description : 
  ///////////////////////////////////////////////////////////////////////////////
  always@(posedge i_clk) begin
    if (i_reset_sync == 1'b1) begin
      mem_space0[reset_index] <= 32'h0000_0000;
    end
    else begin
      casez (w_write0_cases)
        2'b01 : begin
          // HCC Processor write access
          mem_space1[i_slave_hcc0_write_addr] <= i_slave_hcc0_write_data;
        end
        2'b10 : begin
          // Core write access
          mem_space1[i_slave_core0_write_addr] <= i_slave_core0_write_data;
        end
        default : begin
          // null
        end
      endcase
    end
  end

  ///////////////////////////////////////////////////////////////////////////////
  // Process     : mem_space1 Read Process
  // Description : 
  ///////////////////////////////////////////////////////////////////////////////
  always@(posedge i_clk) begin
    casez (w_read1_cases)
      2'b01 : begin
        // HCC Processor read access
        r_slave_read1_data <= mem_space1[i_slave_hcc1_read_addr];
      end
      2'b10 : begin
        // Core read access
        r_slave_read1_data <= mem_space1[i_slave_core1_read_addr];
      end
      default : begin
        // idle
        r_slave_read1_data <= r_slave_read1_data;
      end
    endcase
  end
  // 
  assign o_slave_core1_read_data = r_slave_read1_data;
  assign o_slave_hcc1_read_data  = r_slave_read1_data;

  ///////////////////////////////////////////////////////////////////////////////
  // Process     : mem_space1 Write Process
  // Description : 
  ///////////////////////////////////////////////////////////////////////////////
  always@(posedge i_clk) begin
    if (i_reset_sync == 1'b1) begin
      mem_space1[reset_index] <= 32'h0000_0000;
    end
    else begin
      casez (w_write1_cases)
        2'b01 : begin
          // HCC Processor write access
          mem_space1[i_slave_hcc1_write_addr] <= i_slave_hcc1_write_data;
        end
        2'b10 : begin
          // Core write access
          mem_space1[i_slave_core1_write_addr] <= i_slave_core1_write_data;
        end
        default : begin
          // null
        end
      endcase
    end
  end

endmodule

