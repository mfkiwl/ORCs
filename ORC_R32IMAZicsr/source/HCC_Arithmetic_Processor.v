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
// Last modified : 2021/01/20 00:45:09
// Project Name  : ORCs
// Module Name   : HCC_Arithmetic_Processor
// Description   : The High Computational Cost Arithmetic Processor encapsules 
//                 an integer multiplier and an integer division module.
//
// Additional Comments:
//   .
/////////////////////////////////////////////////////////////////////////////////
module HCC_Arithmetic_Processor #(
  parameter integer P_HCC_FACTORS_MSB  = 7,
  parameter integer P_HCC_MEM_ADDR_MSB = 0,
  parameter integer P_HCC_DIV_ACCURACY = 2,
  parameter integer P_HCC_ANLOGIC_MUL  = 0
)(
  // WB Interface
  input                         i_slave_hcc_processor_clk,
  input                         i_slave_hcc_processor_reset_sync,
  input                         i_slave_hcc_processor_stb,
  output                        o_slave_hcc_processor_ack,
  input                         i_slave_hcc_processor_addr,
  input  [1:0]                  i_slave_hcc_processor_tga,
  input  [P_HCC_MEM_ADDR_MSB:0] i_slave_hcc_processor_data, // rd
  // HCC Processor mem0 WB(pipeline) master Read Interface
  input  [P_HCC_FACTORS_MSB:0]  i_master_hcc0_read_data, // WB data
  // HCC Processor mem1 WB(pipeline) master Read Interface
  input  [P_HCC_FACTORS_MSB:0]  i_master_hcc1_read_data, // WB data
  // HCC Processor mem WB(pipeline) master Write Interface
  output                        o_master_hcc_write_stb,  // WB write enable
  output [P_HCC_MEM_ADDR_MSB:0] o_master_hcc_write_addr, // WB address
  output [P_HCC_FACTORS_MSB:0]  o_master_hcc_write_data  // WB data
);

  ///////////////////////////////////////////////////////////////////////////////
  // Internal Parameter Declarations
  ///////////////////////////////////////////////////////////////////////////////
  localparam L_HCC_FACTORS_NUM_BITS     = P_HCC_FACTORS_MSB+1;
  localparam L_HCC_FACTORS_EXTENDED_MSB = ((P_HCC_FACTORS_MSB+1)*2)-1;
  localparam L_HCC_PRODUCT_EXTENDED_MSB = ((L_HCC_FACTORS_EXTENDED_MSB+1)*2)-1;
  ///////////////////////////////////////////////////////////////////////////////
  // Internal Signals Declarations
  ///////////////////////////////////////////////////////////////////////////////
  // HCC Controls
  reg                        r_wait_ack;
  reg                        r_select;
  reg [P_HCC_MEM_ADDR_MSB:0] r_addr;
  reg                        r_tgd;
  // HCC Processor to Memory_Backplane connecting wires.
  wire                        w_div0_read_stb;  // WB read enable
  wire [P_HCC_MEM_ADDR_MSB:0] w_div0_read_addr; // WB address
  wire                        w_div1_read_stb;  // WB read enable
  wire [P_HCC_MEM_ADDR_MSB:0] w_div1_read_addr; // WB address
  wire                        w_div_write_stb;  // WB write enable
  wire [P_HCC_FACTORS_MSB:0]  w_div_write_data; // WB data
  // Divider
  wire                                w_div_stb = (i_slave_hcc_processor_stb==1'b1 && i_slave_hcc_processor_addr==1'b1) ? 1'b1 : 1'b0;
  wire                                w_div_ack;
  wire [L_HCC_FACTORS_EXTENDED_MSB:0] w_div_multiplicand;
  wire [L_HCC_FACTORS_EXTENDED_MSB:0] w_div_multiplier;
  wire [L_HCC_PRODUCT_EXTENDED_MSB:0] w_product;
  reg  [L_HCC_PRODUCT_EXTENDED_MSB:0] r_product;
  wire [P_HCC_FACTORS_MSB:0]          w_product_bits_select = r_tgd==1'b1 ? w_product[L_HCC_FACTORS_EXTENDED_MSB:P_HCC_FACTORS_MSB+1] : w_product[P_HCC_FACTORS_MSB:0];
  wire [P_HCC_FACTORS_MSB:0]          w_write_data          = r_select==1'b0 ? w_product_bits_select : w_div_write_data;
  wire                                w_write_stb           = ((r_select==1'b0 && r_wait_ack==1'b1) || (r_select==1'b1 && w_div_ack==1'b1)) ? 1'b1 : 1'b0;
  // Multiplier
  wire [L_HCC_FACTORS_EXTENDED_MSB:0] w_multiplicand = (i_slave_hcc_processor_stb==1'b1 && i_slave_hcc_processor_addr==1'b0) ? (
                                                         ^i_slave_hcc_processor_tga ? {{L_HCC_FACTORS_NUM_BITS{i_master_hcc0_read_data[P_HCC_FACTORS_MSB]}}, i_master_hcc0_read_data} :
                                                           {{L_HCC_FACTORS_NUM_BITS{1'b0}}, i_master_hcc0_read_data}) : w_div_multiplicand;
  wire [L_HCC_FACTORS_EXTENDED_MSB:0] w_multiplier   = (i_slave_hcc_processor_stb==1'b1 && i_slave_hcc_processor_addr==1'b0) ? (
                                                        i_slave_hcc_processor_tga==2'b01 ? {{L_HCC_FACTORS_NUM_BITS{i_master_hcc1_read_data[P_HCC_FACTORS_MSB]}}, i_master_hcc1_read_data} :
                                                          {{L_HCC_FACTORS_NUM_BITS{1'b0}}, i_master_hcc1_read_data}) : w_div_multiplier;

  ///////////////////////////////////////////////////////////////////////////////
  //            ********      Architecture Declaration      ********           //
  ///////////////////////////////////////////////////////////////////////////////

  ///////////////////////////////////////////////////////////////////////////////
  // Process     : Control Process
  // Description : Controls the access to the multiplier
  ///////////////////////////////////////////////////////////////////////////////
  always @(posedge i_slave_hcc_processor_clk) begin
    if (i_slave_hcc_processor_reset_sync == 1'b1) begin
      r_select   <= 1'b0;
      r_addr     <= 0;
      r_tgd      <= 0;
      r_wait_ack <= 1'b0;
    end
    else begin
      if (i_slave_hcc_processor_stb == 1'b1) begin
        // Received valid factors index.
        r_select   <= i_slave_hcc_processor_addr;
        r_addr     <= i_slave_hcc_processor_data; // rd
        r_tgd      <= |i_slave_hcc_processor_tga;
        r_wait_ack <= 1'b1;
      end
      if (r_select == 1'b0 && r_wait_ack == 1'b1) begin
        // Multiplication done after one clock.
        r_wait_ack <= 1'b0;
      end
      if (r_select == 1'b1 && r_wait_ack == 1'b1) begin
        // Wait for Division to finish.
        r_wait_ack <= !w_div_ack;
      end
    end
  end
  assign o_slave_hcc_processor_ack = w_write_stb;
  // HCC Processor mem WB(pipeline) master Write access control
  assign o_master_hcc_write_stb  = w_write_stb;  // WB write enable
  assign o_master_hcc_write_addr = r_addr;       // WB address
  assign o_master_hcc_write_data = w_write_data; // WB data

  generate
    if (P_HCC_ANLOGIC_MUL == 0) begin
      /////////////////////////////////////////////////////////////////////////////
      // Process     : Multiplication Process
      // Description : Generates the product by performing the multiplication.
      /////////////////////////////////////////////////////////////////////////////
      always @(posedge i_slave_hcc_processor_clk) begin
        //	Multiply any time the inputs changes.
        r_product <= w_multiplicand * w_multiplier;
      end
      assign w_product = r_product;
    end
  endgenerate

  generate
    if (P_HCC_ANLOGIC_MUL == 1) begin
      ///////////////////////////////////////////////////////////////////////////////
      // Instance    : Integer_Multiplier
      // Description : Anlogic IP EG_LOGIC_MULT, TD version 4.6.18154
      ///////////////////////////////////////////////////////////////////////////////
	    EG_LOGIC_MULT #(
        .INPUT_WIDTH_A(L_HCC_FACTORS_EXTENDED_MSB+1),
	      .INPUT_WIDTH_B(L_HCC_FACTORS_EXTENDED_MSB+1),
	      .OUTPUT_WIDTH(L_HCC_PRODUCT_EXTENDED_MSB+1),
	      .INPUTFORMAT("SIGNED"),
	      .INPUTREGA("DISABLE"),
	      .INPUTREGB("DISABLE"),
	      .OUTPUTREG("ENABLE"),
	      .IMPLEMENT("DSP"),
	      .SRMODE("ASYNC")
	    ) Integer_Multiplier (
	      .a(w_multiplicand),
	      .b(w_multiplier),
	      .p(w_product),
	      .cea(1'b0),
	      .ceb(1'b0),
	      .cepd(1'b1),
	      .clk(i_slave_hcc_processor_clk),
	      .rstan(1'b0),
	      .rstbn(1'b0),
	      .rstpdn(i_slave_hcc_processor_reset_sync)
	    );
    end
  endgenerate

  ///////////////////////////////////////////////////////////////////////////////
  // Instance    : Integer Divider
  // Description : Instance of a Goldschmidt Division implementation.
  ///////////////////////////////////////////////////////////////////////////////
  Goldschmidt_Convergence_Division #(
    P_HCC_FACTORS_MSB,  // 
    P_HCC_DIV_ACCURACY, //
    P_HCC_MEM_ADDR_MSB  //
  ) div (
    // Clock and Reset
    .i_clk(i_slave_hcc_processor_clk),
    .i_reset_sync(i_slave_hcc_processor_reset_sync),
    // WB Interface
    .i_slave_stb(w_div_stb),                 // valid
    .i_slave_tga(i_slave_hcc_processor_tga), // quotient=0, remainder=1
    .o_slave_ack(w_div_ack),                 // ready
    // mem0 WB(pipeline) master Read Interface
    .i_master_div0_read_data(i_master_hcc0_read_data), // WB data
    // mem1 WB(pipeline) master Read Interface
    .i_master_div1_read_data(i_master_hcc1_read_data), // WB data
    // mem WB(pipeline) master Write Interface
    .o_master_div_write_stb(w_div_write_stb),   // WB write enable
    .o_master_div_write_data(w_div_write_data), // WB data
    // Connection to multiplier
    .o_multiplicand(w_div_multiplicand),
    .o_multiplier(w_div_multiplier),
    .i_product(w_product)
  );

endmodule // HCC_Arithmetic_Processor
