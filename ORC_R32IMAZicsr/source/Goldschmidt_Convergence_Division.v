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
// File name     : Goldschmidt_Convergence_Division.v
// Author        : Jose R Garcia
// Created       : 2020/12/06 15:51:57
// Last modified : 2020/12/27 08:54:48
// Project Name  : ORCs
// Module Name   : Goldschmidt_Convergence_Division
// Description   : The Goldschmidt Convergence Division is an iterative method
//                 to approximate the division result. This implementation
//                 targets integer numbers. It is specifically designed to work
//                 with the ORC_R32IM* processors.
//
// Additional Comments:
//   This code implementation is based on the description of the Goldschmidt
//   Convergence Dividers found on a publication of 2006. This divider computes:
//                 d(i) = d[i-1].(2-d[i-1])
//                          and
//                 D(i) = D[i-1].(2-d[i-1])
//   Reference: Synthesis og Arithmetic Circuits, FPGA, ASIC and Embedded Systems
//              by Jean-Pierre Deschamp; Gery Jean Antoine Bioul; 
//              Gustavo D. Sutter
//
//  The remainder calculation requires an extra which is why the address tag is
//  used to make the decision on whether do the calculation or skip it.
/////////////////////////////////////////////////////////////////////////////////
module Goldschmidt_Convergence_Division #(
  parameter P_GCD_FACTORS_MSB    = 7,
  parameter P_GCD_ACCURACY       = 2,
  parameter P_GCD_MEM_ADDR_MSB   = 0,
  parameter P_GCD_DIV_START_ADDR = 0
)(
  input i_clk,
  input i_reset_sync,
  // WB Interface
  input                                   i_slave_stb,  // valid
  input  [((P_GCD_MEM_ADDR_MSB+1)*2)-1:0] i_slave_data, // {rs2. rs1}
  input                                   i_slave_tga,  // 0=div, 1=rem
  output                                  o_slave_ack,  // ready
  // GDC mem0 WB(pipeline) master Read Interface
  output                        o_master_div0_read_stb,  // WB read enable
  output [P_GCD_MEM_ADDR_MSB:0] o_master_div0_read_addr, // WB address
  input  [P_GCD_FACTORS_MSB:0]  i_master_div0_read_data, // WB data
  // GDC mem0 WB(pipeline) master Write Interface
  output                        o_master_div0_write_stb,  // WB write enable
  output [P_GCD_MEM_ADDR_MSB:0] o_master_div0_write_addr, // WB address
  output [P_GCD_FACTORS_MSB:0]  o_master_div0_write_data, // WB data
  // GDC mem1 WB(pipeline) master Read Interface
  output                        o_master_div1_read_stb,  // WB read enable
  output [P_GCD_MEM_ADDR_MSB:0] o_master_div1_read_addr, // WB address
  input  [P_GCD_FACTORS_MSB:0]  i_master_div1_read_data, // WB data
  // GDC mem1 WB(pipeline) master Write Interface
  output                        o_master_div1_write_stb,  // WB write enable
  output [P_GCD_MEM_ADDR_MSB:0] o_master_div1_write_addr, // WB address
  output [P_GCD_FACTORS_MSB:0]  o_master_div1_write_data, // WB data
	// Multiplier interface
  output [((P_GCD_FACTORS_MSB+1)*2)-1:0] o_multiplicand,
  output [((P_GCD_FACTORS_MSB+1)*2)-1:0] o_multiplier,
  input  [((P_GCD_FACTORS_MSB+1)*4)-1:0] i_product
);

  ///////////////////////////////////////////////////////////////////////////////
  // Internal Parameter Declarations
  ///////////////////////////////////////////////////////////////////////////////
  // Misc.
  localparam [P_GCD_FACTORS_MSB:0] L_GCD_NUMBER_TWO       = 2;
  localparam [P_GCD_FACTORS_MSB:0] L_GCD_ZERO_FILLER      = 0;
  localparam                       L_GCD_ACCURACY_BITS    = P_GCD_ACCURACY*4;
  localparam                       L_GCD_MUL_FACTORS_MSB  = ((P_GCD_FACTORS_MSB+1)*2)-1;
  localparam                       L_GCD_STEP_PRODUCT_MSB = (L_GCD_MUL_FACTORS_MSB+1)+P_GCD_FACTORS_MSB;
  localparam                       L_GCD_FACTORS_NIBBLES  = (P_GCD_FACTORS_MSB+1)/4;
  // Program Counter FSM States
  localparam [1:0] S_IDLE                 = 2'h0; // r_program_counter_state after reset
  localparam [1:0] S_SHIFT_DIVIDEND_POINT = 2'h1; // multiply the dividend by minus powers of ten to shift the decimal point.
  localparam [1:0] S_HALF_STEP_ONE        = 2'h2; // r_program_counter_state, waiting for valid instruction
  localparam [1:0] S_HALF_STEP_TWO        = 2'h3; // r_program_counter_state, wait for Decoder process
  // LookUp Table Initial Address
  localparam [P_GCD_MEM_ADDR_MSB:0] L_GDC_LUT_ADDR = P_GCD_DIV_START_ADDR+1;

  ///////////////////////////////////////////////////////////////////////////////
  // Internal Signals Declarations
  ///////////////////////////////////////////////////////////////////////////////
  // Divider Accumulator signals
  reg [1:0]                  r_divider_state;
  reg [P_GCD_MEM_ADDR_MSB:0] r_dividend_addr; // rs1
  reg [P_GCD_MEM_ADDR_MSB:0] r_divisor_addr;  // rs2
  //
  reg [L_GCD_FACTORS_NIBBLES-1:0] r_first_hot_nibble;
  //
  reg [L_GCD_MUL_FACTORS_MSB:0] r_multiplicand;
  reg [L_GCD_MUL_FACTORS_MSB:0] r_multiplier;
  //
  reg r_ack;
  //
  wire [L_GCD_MUL_FACTORS_MSB:0] w_number_two_extended = {L_GCD_NUMBER_TWO,L_GCD_ZERO_FILLER};
  //
  wire [L_GCD_MUL_FACTORS_MSB:0] w_dividend_extended = {i_dividend, L_GCD_ZERO_FILLER};
  wire [L_GCD_MUL_FACTORS_MSB:0] w_divisor_extended  = {i_divisor,  L_GCD_ZERO_FILLER};
  reg  [L_GCD_MUL_FACTORS_MSB:0] r_dividend_extended;
  reg  [L_GCD_MUL_FACTORS_MSB:0] r_divisor_extended;
  //
  wire [L_GCD_MUL_FACTORS_MSB:0] w_current_dividend = r_divider_state == S_HALF_STEP_ONE ? r_dividend_extended : i_product[L_GCD_STEP_PRODUCT_MSB:P_GCD_FACTORS_MSB+1];
  wire [L_GCD_MUL_FACTORS_MSB:0] w_current_divisor  = r_divider_state == S_HALF_STEP_TWO ? r_divisor_extended  : i_product[L_GCD_STEP_PRODUCT_MSB:P_GCD_FACTORS_MSB+1];
  wire [L_GCD_MUL_FACTORS_MSB:0] two_minus_divisor = w_number_two_extended + ~w_current_divisor;
  //
  wire                       w_dividend_not_zero = |i_dividend;
  wire                       w_divisor_not_zero  = |i_divisor;
  wire [P_GCD_FACTORS_MSB:0] w_quotient          = i_product[L_GCD_MUL_FACTORS_MSB:L_GCD_MUL_FACTORS_MSB-2] == 3'b100 |
                                                   i_product[L_GCD_MUL_FACTORS_MSB:L_GCD_MUL_FACTORS_MSB-2] == 3'b101 | 
                                                   i_product[L_GCD_MUL_FACTORS_MSB:L_GCD_MUL_FACTORS_MSB-2] == 3'b111 ? w_current_dividend[L_GCD_MUL_FACTORS_MSB:P_GCD_FACTORS_MSB+1] + 1 :
                                                     w_current_dividend[L_GCD_MUL_FACTORS_MSB:P_GCD_FACTORS_MSB+1];
  reg  [P_GCD_FACTORS_MSB:0] r_remainder         = i_product[L_GCD_MUL_FACTORS_MSB:L_GCD_MUL_FACTORS_MSB-2] == 3'b100 |
                                                   i_product[L_GCD_MUL_FACTORS_MSB:L_GCD_MUL_FACTORS_MSB-2] == 3'b101 | 
                                                   i_product[L_GCD_MUL_FACTORS_MSB:L_GCD_MUL_FACTORS_MSB-2] == 3'b111 ? w_current_dividend[L_GCD_MUL_FACTORS_MSB:P_GCD_FACTORS_MSB+1] + 1 :
                                                     w_current_dividend[L_GCD_MUL_FACTORS_MSB:P_GCD_FACTORS_MSB+1];

  ///////////////////////////////////////////////////////////////////////////////
  //            ********      Architecture Declaration      ********           //
  ///////////////////////////////////////////////////////////////////////////////

  genvar ii;
  
  generate
    for (ii=L_GCD_FACTORS_NIBBLES-1; ii>=0; ii=ii-1) begin
      ///////////////////////////////////////////////////////////////////////////////
      // Process     : Fixed Point Locator
      // Description : Locates the the first hot nibble to determine by which power
      //               of minus ten to multiply the divisor.
      ///////////////////////////////////////////////////////////////////////////////
	    always @(*) begin
        if (i_reset_sync== 1'b1) begin
          r_first_hot_nibble[ii] = 1'b0;
        end
        else if (i_slave_stb == 1'b1 && |r_first_hot_nibble[L_GCD_FACTORS_NIBBLES-1:ii] == 1'b0) begin
          // Find first hot nibbles and create the number two
          r_first_hot_nibble[ii] = |i_divisor[((ii+1)*4)-1:ii*4];
        end
      end
    end
  endgenerate

  ///////////////////////////////////////////////////////////////////////////////
  // Process     : Divider Accumulator
  // Description : 
  ///////////////////////////////////////////////////////////////////////////////
  always @(posedge i_clk) begin
    if (i_reset_sync == 1'b1) begin
      r_divider_state     <= S_IDLE;
      r_ack               <= 1'b0;
      r_divisor_extended  <= 0;
      r_dividend_extended <= 0;
      r_remainder         <= 0;
      r_multiplicand      <= 0; 
      r_multiplier        <= 0;
    end
    else begin
      casez (r_divider_state)
        S_IDLE : begin
          if (i_slave_stb == 1'b1) begin
            if (w_dividend_not_zero == 1'b0 || w_divisor_not_zero == 1'b0) begin
              // If either is zero return zero
              r_dividend_extended <= {L_GCD_ZERO_FILLER, L_GCD_ZERO_FILLER};
              r_remainder         <= 0;
              r_ack               <= 1'b1;
              r_divider_state     <= S_IDLE;
            end
            else if (i_divisor == 1) begin
              // if denominator is 1 return numerator
              r_dividend_extended <= {L_GCD_ZERO_FILLER, i_dividend};
              r_remainder         <= 0;
              r_ack               <= 1'b1;
              r_divider_state     <= S_IDLE;
            end
            else if ($signed(i_divisor) == -1) begin
              // if denominator is -1 return -1*numerator
              r_dividend_extended <= {L_GCD_ZERO_FILLER, ~i_dividend};
              r_remainder         <= 0;
              r_ack               <= 1'b1;
              r_divider_state     <= S_IDLE;
            end
            else begin
              // Shift the decimal point in the divisor.
              r_dividend_extended <= w_dividend_extended;            //
              r_multiplicand      <= w_divisor_extended;             //
              r_multiplier        <= {L_GCD_ZERO_FILLER, L_GCD_E10}; //
              r_divider_state     <= S_SHIFT_DIVIDEND_POINT;         // 
              r_ack               <= 1'b0;
            end
          end
          else begin
            //
            r_ack <= 1'b0;
          end
        end
        S_SHIFT_DIVIDEND_POINT : begin
          // 
          r_multiplicand     <= r_dividend_extended;
          r_multiplier       <= {L_GCD_ZERO_FILLER, L_GCD_E10};
          r_divider_state    <= S_HALF_STEP_ONE;
        end
        S_HALF_STEP_ONE : begin
          // 
          r_divisor_extended <= i_product[L_GCD_STEP_PRODUCT_MSB:P_GCD_FACTORS_MSB+1];
          r_multiplicand     <= w_current_divisor;
          r_multiplier       <= two_minus_divisor;
          
          if (&i_product[L_MUL_FACTORS_MSB:L_MUL_FACTORS_MSB-L_GCD_ACCURACY_BITS] == 1'b1) begin
            // When all steps are completed assert ack and return to idle.
            r_ack           <= 1'b1;
            r_divider_state <= S_IDLE;
          end
          else begin
            // Increase count and start another division whole step.
            r_divider_state <= S_HALF_STEP_TWO;
          end
        end
        S_HALF_STEP_TWO : begin
          // Second half of the division step
          r_dividend_extended <= i_product[L_GCD_STEP_PRODUCT_MSB:P_GCD_FACTORS_MSB+1];
          r_multiplicand      <= w_current_dividend;
          r_multiplier        <= two_minus_divisor;
          r_divider_state     <= S_HALF_STEP_ONE;
        end
        default : begin
          r_ack           <= 1'b0;
          r_divider_state <= S_IDLE;
        end
      endcase
    end
	end
  // 
  assign o_slave_ack    = r_ack;
  assign o_multiplicand = r_multiplicand;
  assign o_multiplier   = r_multiplier;
  assign o_quotient     = w_quotient;
  assign o_remainder    = r_remainder;

endmodule // Goldschmidt_Convergence_Division
