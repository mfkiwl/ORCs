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
// Last modified : 2020/12/23 12:48:37
// Project Name  : ORCs
// Module Name   : Goldschmidt_Convergence_Division
// Description   : The Goldschmidt Convergence Division is an iterative method
//                 to approximate the division result. This implementation
//                 targets integer numbers.
//
// Additional Comments:
//   This code implementation is based on the description of the Goldschmidt
//   Convergence Dividers found on a publication of 2006. This divider computes:
//                 d(i) = d[i-1].(2-d[i-1])
//                          and
//                 D(i) = D[i-1].(2-d[i-1])
//   Reference: Synthesis og Arithmetic Circuits, FPGA, ASIC and Embedded Systems
//     Authors: Jean-Pierre Deschamp; Gery Jean Antoine Bioul;Gustavo D. Sutter
//
// To Do : generate the remainder, set the look-up table of the powers of tens.
/////////////////////////////////////////////////////////////////////////////////
module Goldschmidt_Convergence_Division #(
  parameter P_GCD_FACTORS_MSB = 8,
  parameter P_GCD_STEPS       = 3
)(
  input i_clk,
  input i_reset_sync,
  // 
  input  i_slave_stb,
  output o_slave_ack,
  //
  input  signed [P_GCD_FACTORS_MSB:0] i_dividend,
  input  signed [P_GCD_FACTORS_MSB:0] i_divisor,
  output signed [P_GCD_FACTORS_MSB:0] o_quotient,
  output        [P_GCD_FACTORS_MSB:0] o_remainder,
	//
  output signed [((P_GCD_FACTORS_MSB+1)*2)-1:0] o_multiplicand,
  output signed [((P_GCD_FACTORS_MSB+1)*2)-1:0] o_multiplier,
  input  signed [((P_GCD_FACTORS_MSB+1)*4)-1:0] i_product
);

  ///////////////////////////////////////////////////////////////////////////////
  // Internal Parameter Declarations
  ///////////////////////////////////////////////////////////////////////////////
  // OpCodes
  localparam L_GCD_STEPS_MSB        = $clog2((P_GCD_STEPS));
  localparam L_GCD_MUL_FACTORS_MSB  = ((P_GCD_FACTORS_MSB+1)*2)-1;
  localparam L_GCD_STEP_PRODUCT_MSB = (L_GCD_MUL_FACTORS_MSB+1)+P_GCD_FACTORS_MSB;
  localparam L_GCD_FACTORS_NIBBLES  = (P_GCD_FACTORS_MSB+1)/4;
  // Program Counter FSM States
  localparam [1:0] S_IDLE                 = 2'h0; // r_program_counter_state after reset
  localparam [1:0] S_SHIFT_DIVIDEND_POINT = 2'h1; // multiply the dividend by minus powers of ten to shift the decimal point.
  localparam [1:0] S_HALF_STEP_ONE        = 2'h2; // r_program_counter_state, waiting for valid instruction
  localparam [1:0] S_HALF_STEP_TWO        = 2'h3; // r_program_counter_state, wait for Decoder process
  //
  localparam [P_GCD_FACTORS_MSB:0] L_GCD_NUMBER_TWO  = 2;
  localparam [P_GCD_FACTORS_MSB:0] L_GCD_ZERO_FILLER = 0;
  //
  localparam [P_GCD_FACTORS_MSB:0] L_GCD_E10 = 32'b00011001100110011001100110011010;
  localparam [P_GCD_FACTORS_MSB:0] L_GCD_E100 = 32'b00011001100110011001100110011010;
  localparam [P_GCD_FACTORS_MSB:0] L_GCD_E1000 = 32'b00011001100110011001100110011010;
  localparam [P_GCD_FACTORS_MSB:0] L_GCD_E10000 = 32'b00011001100110011001100110011010;
  localparam [P_GCD_FACTORS_MSB:0] L_GCD_E100000 = 32'b00011001100110011001100110011010;
  localparam [P_GCD_FACTORS_MSB:0] L_GCD_E1000000 = 32'b00011001100110011001100110011010;
  localparam [P_GCD_FACTORS_MSB:0] L_GCD_E10000000 = 32'b00011001100110011001100110011010;
  localparam [P_GCD_FACTORS_MSB:0] L_GCD_E100000000 = 32'b00011001100110011001100110011010;

  ///////////////////////////////////////////////////////////////////////////////
  // Internal Signals Declarations
  ///////////////////////////////////////////////////////////////////////////////
  reg [1:0] r_divider_state;
  //
  reg [L_GCD_FACTORS_NIBBLES-1:0] r_first_hot_nibble;
  //
	reg [L_GCD_MUL_FACTORS_MSB:0] r_multiplicand;
	reg [L_GCD_MUL_FACTORS_MSB:0] r_multiplier;
  //
  reg r_ack;
  //
  reg  [L_GCD_STEPS_MSB:0]       r_steps_count;
  wire [L_GCD_MUL_FACTORS_MSB:0] w_number_two_extended = {L_GCD_NUMBER_TWO,L_GCD_ZERO_FILLER};
  //
  wire [L_GCD_MUL_FACTORS_MSB:0] w_dividend_extended = {i_dividend, L_GCD_ZERO_FILLER};
  wire [L_GCD_MUL_FACTORS_MSB:0] w_divisor_extended  = {i_divisor,  L_GCD_ZERO_FILLER};
  reg  [L_GCD_MUL_FACTORS_MSB:0] r_dividend_extended;
  reg  [L_GCD_MUL_FACTORS_MSB:0] r_divisor_extended;
  reg  [P_GCD_FACTORS_MSB:0]     r_quotient;
  reg  [P_GCD_FACTORS_MSB:0]     r_remainder;
  //
  wire [L_GCD_MUL_FACTORS_MSB:0] w_current_dividend = r_divider_state == S_HALF_STEP_ONE ? r_dividend_extended : i_product[L_GCD_STEP_PRODUCT_MSB:P_GCD_FACTORS_MSB+1];
  wire [L_GCD_MUL_FACTORS_MSB:0] w_current_divisor  = r_divider_state == S_HALF_STEP_TWO ? r_divisor_extended  : i_product[L_GCD_STEP_PRODUCT_MSB:P_GCD_FACTORS_MSB+1];
  wire [L_GCD_MUL_FACTORS_MSB:0] two_minus_divisor = w_number_two_extended + ~w_current_divisor;
  //
  wire w_dividend_not_zero = |i_dividend;
  wire w_divisor_not_zero  = |i_divisor;
  
  ///////////////////////////////////////////////////////////////////////////////
  //            ********      Architecture Declaration      ********           //
  ///////////////////////////////////////////////////////////////////////////////

  genvar ii;
  
  generate
    for (ii=L_GCD_FACTORS_NIBBLES-1; ii>=0; ii=ii-1) begin
      ///////////////////////////////////////////////////////////////////////////////
      // Process     : Fixed Point Locator
      // Description : 
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
      r_divider_state       <= S_IDLE;
      r_ack                 <= 1'b0;
      r_divisor_extended    <= 0;
      r_dividend_extended   <= 0;
      r_quotient            <= 0;
      r_remainder           <= 0;
      r_steps_count         <= 0;
      r_multiplicand        <= 0; 
      r_multiplier          <= 0;
    end
    else begin
      casez (r_divider_state)
        S_IDLE : begin
          if (i_slave_stb == 1'b1) begin
            if (w_dividend_not_zero == 1'b0 || w_divisor_not_zero == 1'b0) begin
              // If either is zero return zero
              r_quotient      <= 0;
              r_remainder     <= 0;
              r_ack           <= 1'b1;
              r_divider_state <= S_IDLE;
            end
            else if (i_divisor == 1) begin
              // if denominator is 1 return numerator
              r_quotient      <= i_dividend;
              r_remainder     <= 0;
              r_ack           <= 1'b1;
              r_divider_state <= S_IDLE;
            end
            else if ($signed(i_divisor) == -1) begin
              // if denominator is -1 return -1*numerator
              r_quotient      <= ~i_dividend;
              r_remainder     <= 0;
              r_ack           <= 1'b1;
              r_divider_state <= S_IDLE;
            end
            else begin
              // Shift the decimal point in the divisor.
              r_dividend_extended <= w_dividend_extended;    //
              r_multiplicand      <= w_divisor_extended;     //
              r_multiplier        <= {L_GCD_ZERO_FILLER, L_GCD_E10}; //
              r_divider_state     <= S_SHIFT_DIVIDEND_POINT; // 
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
          
          if (r_steps_count == P_GCD_STEPS) begin
            // When all steps are completed assert ack and return to idle.
            r_steps_count   <= 0;
            r_ack           <= 1'b1;
            r_divider_state <= S_IDLE;
          end
          else begin
            // Increase count and start another division whole step.
            r_steps_count   <= r_steps_count + 1;
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
  assign o_quotient     = w_current_dividend[L_GCD_MUL_FACTORS_MSB:P_GCD_FACTORS_MSB+1] + |i_product[L_GCD_MUL_FACTORS_MSB:L_GCD_MUL_FACTORS_MSB-2];  // rounding up
  assign o_remainder    = r_remainder;

endmodule // Goldschmidt_Convergence_Division
