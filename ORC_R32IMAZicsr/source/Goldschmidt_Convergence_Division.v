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
// Last modified : 2020/12/28 15:28:27
// Project Name  : ORCs
// Module Name   : Goldschmidt_Convergence_Division
// Description   : The Goldschmidt Convergence Division is an iterative method
//                 to approximate the division result. This implementation
//                 targets integer numbers. It is specifically designed to work
//                 with the ORC_R32IM* processors.
//
// Additional Comments:
//   This code implementation is based on the description of the Goldschmidt
//   Convergence Dividers found on a publication of 2006; Synthesis of Arithmetic
//   Circuits, FPGA, ASIC and Embedded Systems by Jean-Pierre Deschamp,
//   Gery Jean Antoine Bioul and Gustavo D. Sutter. This divider computes:
//                 d(i) = d[i-1].(2-d[i-1])
//                          and
//                 D(i) = D[i-1].(2-d[i-1])
//   were 'd' is the divisor; 'D' is the dividend; 'i' is the step.
//
//  The remainder calculation requires an extra which is why the address tag is
//  used to make the decision on whether do the calculation or skip it.
/////////////////////////////////////////////////////////////////////////////////
module Goldschmidt_Convergence_Division #(
  parameter P_GCD_FACTORS_MSB    = 7,
  parameter P_GCD_ACCURACY       = 1,
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
  localparam [2:0] S_IDLE                 = 3'h0; // Waits for valid factors.
  localparam [2:0] S_SHIFT_DIVIDEND_POINT = 3'h1; // multiply the dividend by minus powers of ten to shift the decimal point.
  localparam [2:0] S_SHIFT_DIVISOR_POINT  = 3'h2; // multiply the divisor by minus powers of ten to shift the decimal point.
  localparam [2:0] S_HALF_STEP_ONE        = 3'h3; // D[i] * (2-d[i]); were i is the iteration.
  localparam [2:0] S_HALF_STEP_TWO        = 3'h4; // d[i] * (2-d[i]); were i is the iteration.
  localparam [2:0] S_REMAINDER_TO_NATURAL = 3'h5; // Convert remainder from decimal fraction to a natural number.
  // LookUp Table Initial Address
  localparam [P_GCD_MEM_ADDR_MSB:0] L_GDC_LUT_ADDR = P_GCD_DIV_START_ADDR+1;

  ///////////////////////////////////////////////////////////////////////////////
  // Internal Signals Declarations
  ///////////////////////////////////////////////////////////////////////////////
  // Fixed Point Locator Process signals
  reg [L_GCD_FACTORS_NIBBLES-1:0] r_first_hot_nibble;
  // Offset Counter
  reg [P_GCD_MEM_ADDR_MSB:0] r_lut0_offset;
  reg [P_GCD_MEM_ADDR_MSB:0] r_lut1_offset;
  reg                        r_found0_hot_bit;
  reg                        r_found1_hot_bit;
  // Divider Accumulator signals
  reg  [1:0]                     r_divider_state;
  reg                            r_calculate_remainder;
  reg                            r_ack;
  reg                            r_lut_half_select;
  wire [L_GCD_MUL_FACTORS_MSB:0] w_number_two_extended = {L_GCD_NUMBER_TWO,L_GCD_ZERO_FILLER};
  wire                           w_dividend_not_zero   = |i_master_div0_read_data;
  wire                           w_divisor_not_zero    = |i_master_div1_read_data;
  reg  [P_GCD_FACTORS_MSB:0]     r_dividend;
  reg  [P_GCD_FACTORS_MSB:0]     r_divisor;
  reg  [L_GCD_MUL_FACTORS_MSB:0] r_multiplicand;
  reg  [L_GCD_MUL_FACTORS_MSB:0] r_multiplier;
  wire [L_GCD_MUL_FACTORS_MSB:0] w_current_divisor     = r_divider_state==S_HALF_STEP_TWO ? r_multiplicand : i_product[L_GCD_STEP_PRODUCT_MSB:P_GCD_FACTORS_MSB+1];
  wire [L_GCD_MUL_FACTORS_MSB:0] w_two_minus_divisor   = w_number_two_extended + ~w_current_divisor;
  wire [P_GCD_FACTORS_MSB:0]     w_quotient            = r_divider_state==S_IDLE ? r_div1_write_data : 
                                                           i_product[L_GCD_MUL_FACTORS_MSB:L_GCD_MUL_FACTORS_MSB-2] == 3'b100 |
                                                           i_product[L_GCD_MUL_FACTORS_MSB:L_GCD_MUL_FACTORS_MSB-2]==3'b101 | 
                                                           i_product[L_GCD_MUL_FACTORS_MSB:L_GCD_MUL_FACTORS_MSB-2]==3'b111 ? i_product[L_GCD_MUL_FACTORS_MSB:P_GCD_FACTORS_MSB+1] + 1 :
                                                             i_product[L_GCD_MUL_FACTORS_MSB:P_GCD_FACTORS_MSB+1];
  wire [P_GCD_FACTORS_MSB:0]     w_remainder           = r_divider_state==S_IDLE ? L_GCD_ZERO_FILLER :
                                                           i_product[L_GCD_MUL_FACTORS_MSB:L_GCD_MUL_FACTORS_MSB-2] == 3'b100 |
                                                           i_product[L_GCD_MUL_FACTORS_MSB:L_GCD_MUL_FACTORS_MSB-2]==3'b101 | 
                                                           i_product[L_GCD_MUL_FACTORS_MSB:L_GCD_MUL_FACTORS_MSB-2]==3'b111 ? i_product[L_GCD_MUL_FACTORS_MSB:P_GCD_FACTORS_MSB+1] + 1 :
                                                             i_product[L_GCD_MUL_FACTORS_MSB:P_GCD_FACTORS_MSB+1];
  // MEMx Factors and LookUp Table Read Signals
  wire                        w_div0_read_stb  = |r_first_hot_nibble[(L_GCD_FACTORS_NIBBLES/2)-1:0];
  wire [P_GCD_MEM_ADDR_MSB:0] w_div0_read_addr = (L_GDC_LUT_ADDR+r_lut0_offset);
  wire                        w_div1_read_stb  = |r_first_hot_nibble[L_GCD_FACTORS_NIBBLES-1:(L_GCD_FACTORS_NIBBLES/2)];
  wire [P_GCD_MEM_ADDR_MSB:0] w_div1_read_addr = (L_GDC_LUT_ADDR+r_lut1_offset);
  // MEMx Result Registers Write Signals
  reg                         r_div0_write_stb;
  reg  [P_GCD_MEM_ADDR_MSB:0] r_div0_write_addr;
  reg                         r_div1_write_stb;
  reg  [P_GCD_MEM_ADDR_MSB:0] r_div1_write_addr;
  reg  [P_GCD_FACTORS_MSB:0]  r_div1_write_data;

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
          // Find first hot nibble in the divisor. The hart's core should have 
          // already loaded the rs2 and rs1 when the instruction got decoded.
          r_first_hot_nibble[ii] = |i_master_div1_read_data[((ii+1)*4)-1:ii*4];
        end
      end
    end
  endgenerate

  integer jj=0; 
  ///////////////////////////////////////////////////////////////////////////////
  // Process     : Offset Counter
  // Description : Count until the hot bit is detected to determine which value
  //               from the lookup table to get.
  ///////////////////////////////////////////////////////////////////////////////
	always @(*) begin
    if (i_slave_stb == 1'b0) begin
      // Reset to zero.
      r_lut0_offset    = 0;
      r_lut1_offset    = 0;
      r_found0_hot_bit = 1'b0;
      r_found1_hot_bit = 1'b0;
    end
    else begin
      //
      for (jj=0; jj<(L_GCD_FACTORS_NIBBLES/2); jj=jj+1) begin
        if (r_first_hot_nibble[jj] == 1'b0 && r_found0_hot_bit == 1'b0) begin
          // Count until the hot bit is found.
          r_lut0_offset = r_lut0_offset+1;
        end
        else begin
          // Found the hot bit, stop counting
          r_found0_hot_bit = 1'b1;
        end
        if (r_first_hot_nibble[jj+(L_GCD_FACTORS_NIBBLES/2)] == 1'b0 && r_found1_hot_bit == 1'b0) begin
          // Count until the hot bit is found.
          r_lut1_offset = r_lut1_offset+1;
        end
        else begin
          // Found the hot bit, stop counting
          r_found1_hot_bit = 1'b1;
        end
      end
    end
  end

  ///////////////////////////////////////////////////////////////////////////////
  // Process     : Divider Accumulator
  // Description : 
  ///////////////////////////////////////////////////////////////////////////////
  always @(posedge i_clk) begin
    if (i_reset_sync == 1'b1) begin
      r_divider_state       <= S_IDLE;
      r_ack                 <= 1'b0;
      r_multiplicand        <= 0; 
      r_multiplier          <= 0;
      r_lut_half_select     <= 1'b0;
      r_calculate_remainder <= 1'b0;
    end
    else begin
      casez (r_divider_state)
        S_IDLE : begin
          if (i_slave_stb == 1'b1) begin
            if (w_dividend_not_zero == 1'b0 || w_divisor_not_zero == 1'b0) begin
              // If either is zero return zero
              r_div0_write_stb  <= 1'b1;
              r_div1_write_stb  <= 1'b1;
              r_div1_write_data <= L_GCD_ZERO_FILLER; // quotient
              r_ack             <= 1'b1;
              r_divider_state   <= S_IDLE;
            end
            else if ($signed(i_master_div1_read_data) == 1) begin
              // if denominator is 1 return numerator
              r_div0_write_stb  <= 1'b1;
              r_div1_write_stb  <= 1'b1;
              r_div1_write_data <= i_master_div0_read_data; // quotient
              r_ack             <= 1'b1;
              r_divider_state   <= S_IDLE;
            end
            else if ($signed(i_master_div1_read_data) == -1) begin
              // if denominator is -1 return -1*numerator
              r_div0_write_stb  <= 1'b1;
              r_div1_write_stb  <= 1'b1;
              r_div1_write_data <= ~i_master_div0_read_data; // quotient
              r_ack             <= 1'b1;
              r_divider_state   <= S_IDLE;
            end
            else begin
              // Shift the decimal point in the divisor.
              r_div0_write_stb <= 1'b0; //
              r_div1_write_stb <= 1'b0; // 
              r_dividend       <= i_master_div0_read_data; //
              r_divisor        <= i_master_div1_read_data; //
              r_ack            <= 1'b0;
              //
              r_lut_half_select <= |r_first_hot_nibble[L_GCD_FACTORS_NIBBLES-1:(L_GCD_FACTORS_NIBBLES/2)];
              // Transition shifting the decimal point.
              r_divider_state <= S_SHIFT_DIVIDEND_POINT;
            end
            r_calculate_remainder <= i_slave_tga;
          end
          else begin
            //
            r_ack <= 1'b0;
          end
        end
        S_SHIFT_DIVISOR_POINT : begin
          // 
          r_multiplicand  <= {r_divisor, L_GCD_ZERO_FILLER};
          casez (r_lut_half_select)
            1'b0 : begin
              r_multiplier <= {L_GCD_ZERO_FILLER, i_master_div0_read_data};
            end
            1'b1 : begin
              r_multiplier <= {L_GCD_ZERO_FILLER, i_master_div1_read_data};
            end
          endcase
          r_divider_state <= S_HALF_STEP_ONE;
        end
        S_SHIFT_DIVIDEND_POINT : begin
          // 
          r_multiplicand  <= {r_dividend, L_GCD_ZERO_FILLER};
          r_multiplier    <= r_multiplier;
          r_divider_state <= S_SHIFT_DIVISOR_POINT;
        end
        S_HALF_STEP_ONE : begin
          //          
          if (&i_product[L_GCD_MUL_FACTORS_MSB:L_GCD_MUL_FACTORS_MSB-L_GCD_ACCURACY_BITS] == 1'b1) begin
            // When the divisor converges to 1.0 (actually 0.999...).
            if (r_calculate_remainder == 1'b1) begin
              r_multiplicand  <= {L_GCD_ZERO_FILLER, i_product[P_GCD_FACTORS_MSB:0]};
              r_multiplier    <= {r_divisor, L_GCD_ZERO_FILLER};
              r_divider_state <= S_REMAINDER_TO_NATURAL;
            end
            else begin
              r_div0_write_stb <= 1'b1;
              r_div1_write_stb <= 1'b1;
              r_ack            <= 1'b1;
              r_divider_state  <= S_IDLE;
            end
          end
          else begin
            // Increase count and start another division whole step.
            r_multiplicand  <= i_product[L_GCD_STEP_PRODUCT_MSB:P_GCD_FACTORS_MSB+1];
            r_multiplier    <= w_two_minus_divisor;
            r_divider_state <= S_HALF_STEP_TWO;
          end
        end
        S_HALF_STEP_TWO : begin
          // Second half of the division step
          r_multiplicand  <= i_product[L_GCD_STEP_PRODUCT_MSB:P_GCD_FACTORS_MSB+1];
          r_multiplier    <= w_two_minus_divisor;
          r_divider_state <= S_HALF_STEP_ONE;
        end
        S_REMAINDER_TO_NATURAL : begin
          r_div0_write_stb <= 1'b1;
          r_div1_write_stb <= 1'b1;
          r_ack            <= 1'b1;
          r_divider_state  <= S_IDLE;
        end
        default : begin
          r_div0_write_stb <= 1'b0;
          r_div1_write_stb <= 1'b0;
          r_ack            <= 1'b0;
          r_divider_state  <= S_IDLE;
        end
      endcase
    end
	end
  // MEMx Factors and LookUp Table Read Access
  assign o_master_div0_read_stb  = w_div0_read_stb;
  assign o_master_div0_read_addr = w_div0_read_addr;
  assign o_master_div1_read_stb  = w_div1_read_stb;
  assign o_master_div1_read_addr = w_div1_read_addr;
  // MEMx Result Registers Write Access
  assign o_master_div0_write_stb  = r_div0_write_stb;
  assign o_master_div0_write_addr = P_GCD_DIV_START_ADDR;
  assign o_master_div0_write_data = w_remainder;
  assign o_master_div1_write_stb  = r_div1_write_stb;
  assign o_master_div1_write_addr = P_GCD_DIV_START_ADDR;
  assign o_master_div1_write_data = w_quotient;
  // Multiplication Processor Access
  assign o_multiplicand = r_multiplicand;
  assign o_multiplier   = r_multiplier;
  // WB Valid/Ready 
  assign o_slave_ack = r_ack;

endmodule // Goldschmidt_Convergence_Division
