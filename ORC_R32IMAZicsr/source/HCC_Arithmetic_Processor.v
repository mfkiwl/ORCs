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
// File name     : HCC_Arithmetic_Processor.v
// Author        : Jose R Garcia
// Created       : 2020/12/06 15:51:57
// Last modified : 2020/12/28 15:31:11
// Project Name  : ORCs
// Module Name   : HCC_Arithmetic_Processor
// Description   : The High Computational Cost Arithmetic Processor encapsules 
//                 an integer multiplier and an integer division module.
//
// Additional Comments:
//   .
/////////////////////////////////////////////////////////////////////////////////
module HCC_Arithmetic_Processor #(
  parameter P_HCC_FACTORS_MSB    = 7,
  parameter P_HCC_MEM_ADDR_MSB   = 0,
  parameter P_HCC_MUL_START_ADDR = 0,
  parameter P_HCC_DIV_START_ADDR = 0,
  parameter P_HCC_DIV_ACCURACY   = 2
)(
  // WB Interface
  input                                   i_slave_hcc_processor_clk,
  input                                   i_slave_hcc_processor_reset_sync,
  input                                   i_slave_hcc_processor_stb,
  output                                  o_slave_hcc_processor_ack,
  input                                   i_slave_hcc_processor_addr,
  input                                   i_slave_hcc_processor_tga,
  input  [((P_HCC_MEM_ADDR_MSB+1)*2)-1:0] i_slave_hcc_processor_data, // {rs2, rs1}
  // HCC Processor mem0 WB(pipeline) master Read Interface
  output                        o_master_hcc0_read_stb,  // WB read enable
  output [P_HCC_MEM_ADDR_MSB:0] o_master_hcc0_read_addr, // WB address
  input  [31:0]                 i_master_hcc0_read_data, // WB data
  // HCC Processor mem0 WB(pipeline) master Write Interface
  output                        o_master_hcc0_write_stb,  // WB write enable
  output [P_HCC_MEM_ADDR_MSB:0] o_master_hcc0_write_addr, // WB address
  output [31:0]                 o_master_hcc0_write_data, // WB data
  // HCC Processor mem1 WB(pipeline) master Read Interface
  output                        o_master_hcc1_read_stb,  // WB read enable
  output [P_HCC_MEM_ADDR_MSB:0] o_master_hcc1_read_addr, // WB address
  input  [31:0]                 i_master_hcc1_read_data, // WB data
  // HCC Processor mem1 WB(pipeline) master Write Interface
  output                        o_master_hcc1_write_stb,  // WB write enable
  output [P_HCC_MEM_ADDR_MSB:0] o_master_hcc1_write_addr, // WB address
  output [31:0]                 o_master_hcc1_write_data  // WB data
);

  ///////////////////////////////////////////////////////////////////////////////
  // Internal Parameter Declarations
  ///////////////////////////////////////////////////////////////////////////////
  localparam L_HCC_FACTORS_MSB = ((P_HCC_FACTORS_MSB+1)/2)-1;
  localparam L_HCC_PRODUCT_MSB = ((P_HCC_FACTORS_MSB+1)*2)-1;
  ///////////////////////////////////////////////////////////////////////////////
  // Internal Signals Declarations
  ///////////////////////////////////////////////////////////////////////////////
  // HCC Controls
  reg r_wait_ack;
  reg r_select;
  // HCC Processor to Memory_Backplane connecting wires.
  wire                        w_hcc0_read_stb;   // WB read enable
  wire [P_HCC_MEM_ADDR_MSB:0] w_hcc0_read_addr;  // WB address
  wire [31:0]                 w_hcc0_read_data;  // WB data
  wire                        w_hcc0_write_stb;  // WB write enable
  wire [P_HCC_MEM_ADDR_MSB:0] w_hcc0_write_addr; // WB address
  wire [31:0]                 w_hcc0_write_data; // WB data
  wire                        w_hcc1_read_stb;   // WB read enable
  wire [P_HCC_MEM_ADDR_MSB:0] w_hcc1_read_addr;  // WB address
  wire [31:0]                 w_hcc1_read_data;  // WB data
  wire                        w_hcc1_write_stb;  // WB write enable
  wire [P_HCC_MEM_ADDR_MSB:0] w_hcc1_write_addr; // WB address
  wire [31:0]                 w_hcc1_write_data; // WB data
  // Divider
  wire                       w_div_stb = i_slave_hcc_processor_stb & i_slave_hcc_processor_addr;
  wire                       w_div_ack;
  wire [P_HCC_FACTORS_MSB:0] w_div_multiplicand;
  wire [P_HCC_FACTORS_MSB:0] w_div_multiplier;
  wire [L_HCC_FACTORS_MSB:0] w_quotient;
  wire [L_HCC_FACTORS_MSB:0] w_remainder;
  // Multiplier
  wire signed [P_HCC_FACTORS_MSB:0] w_multiplicand = r_select == 1'b1 ? $signed(i_master_hcc0_read_data) : $signed(i_master_hcc0_read_data);
  wire signed [P_HCC_FACTORS_MSB:0] w_multiplier   = r_select == 1'b1 ? $signed(i_master_hcc1_read_data) : $signed(i_master_hcc0_read_data);
  wire        [L_HCC_PRODUCT_MSB:0] w_product;

  ///////////////////////////////////////////////////////////////////////////////
  //            ********      Architecture Declaration      ********           //
  ///////////////////////////////////////////////////////////////////////////////

  ///////////////////////////////////////////////////////////////////////////////
  // Process     : Control Process
  // Description : Controls the access to the multiplier
  ///////////////////////////////////////////////////////////////////////////////
	always @(posedge i_slave_hcc_processor_clk)	begin
    if (i_slave_hcc_processor_reset_sync == 1'b1) begin
      r_select   <= 1'b1;
      r_wait_ack <= 1'b0;
    end
    else begin
      if (i_slave_hcc_processor_stb == 1'b1) begin
        r_select   <= i_slave_hcc_processor_addr;
        r_wait_ack <= 1'b1;
      end
      if (r_select == 1'b0 && r_wait_ack == 1'b1) begin
        r_wait_ack <= 1'b0;
        r_select   <= 1'b1;
      end
      if (r_select == 1'b1 && r_wait_ack == 1'b1) begin
        r_wait_ack <= !w_div_ack;
      end
    end
	end

  assign o_slave_hcc_processor_ack  = (r_select==1'b0 && r_wait_ack==1'b1) ? 1'b1 :
                                      (r_select==1'b1 && r_wait_ack==1'b1) ? w_div_ack : 1'b0;
  // assign o_slave_hcc_processor_data = r_select ? {w_remainder, w_quotient} : w_product[P_HCC_RESULT_MSB:0];

  ///////////////////////////////////////////////////////////////////////////////
  // Instance    : Integer Multiplier
  // Description : A High Computational Cost Arithmetic Processor that handles
  //               multiplication and division operations.
  ///////////////////////////////////////////////////////////////////////////////
  Integer_Multiplier #(
    P_HCC_FACTORS_MSB, 
    P_HCC_FACTORS_MSB, 
    L_HCC_PRODUCT_MSB
  ) mul (
    .i_clk(i_slave_hcc_processor_clk), //
    .i_multiplicand(w_multiplicand),   // 
    .i_multiplier(w_multiplier),       // 
  	.o_product(w_product)              //
  );

  ///////////////////////////////////////////////////////////////////////////////
  // Instance    : Integer Divider
  // Description : Instance of a Goldschmidt Division implementation.
  ///////////////////////////////////////////////////////////////////////////////
  Goldschmidt_Convergence_Division #(
    L_HCC_FACTORS_MSB,   // 
    P_HCC_DIV_ACCURACY,  //
    P_HCC_MEM_ADDR_MSB,  // 
    P_HCC_DIV_START_ADDR // P_HCC_DIV_START_ADDR
  ) div (
    // Clock and Reset
    .i_clk(i_slave_hcc_processor_clk),
    .i_reset_sync(i_slave_hcc_processor_reset_sync),
    // WB Interface
    .i_slave_stb(w_div_stb),                   // valid
    .i_slave_data(i_slave_hcc_processor_data), // {rs2, rs1}
    .i_slave_tga(i_slave_hcc_processor_tga),   // quotient=0, remainder=1
    .o_slave_ack(w_div_ack),                   // ready
    // mem0 WB(pipeline) master Read Interface
    .o_master_div0_read_stb(w_hcc0_read_stb),   // WB read enable
    .o_master_div0_read_addr(w_hcc0_read_addr), // WB address
    .i_master_div0_read_data(w_hcc0_read_data), // WB data
    // mem0 WB(pipeline) master Write Interface
    .o_master_div0_write_stb(w_hcc0_write_stb),   // WB write enable
    .o_master_div0_write_addr(w_hcc0_write_addr), // WB address
    .o_master_div0_write_data(w_hcc0_write_data), // WB data
    // mem1 WB(pipeline) master Read Interface
    .o_master_div1_read_stb(w_hcc1_read_stb),   // WB read enable
    .o_master_div1_read_addr(w_hcc1_read_addr), // WB address
    .i_master_div1_read_data(w_hcc1_read_data), // WB data
    // mem1 WB(pipeline) master Write Interface
    .o_master_div1_write_stb(w_hcc1_write_stb),   // WB write enable
    .o_master_div1_write_addr(w_hcc1_write_addr), // WB address
    .o_master_div1_write_data(w_hcc1_write_data),  // WB data
    // Connection to multiplier
    .o_multiplicand(w_div_multiplicand),
    .o_multiplier(w_div_multiplier),
  	.i_product(w_product)
  );

endmodule // HCC_Arithmetic_Processor