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
// File name     : Integer_Multiplier.v
// Author        : Jose R Garcia
// Created       : 2020/12/06 15:51:57
// Last modified : 2020/12/27 00:18:45
// Project Name  : ORCs
// Module Name   : Integer_Multiplier
// Description   : The Integer_Multiplier is a .
//
// Additional Comments:
//   .
/////////////////////////////////////////////////////////////////////////////////
module Integer_Multiplier #(
  parameter P_MUL_MULTIPLICAND_MSB = 7,
  parameter P_MUL_MULTIPLIER_MSB   = 7,
  parameter P_MUL_PRODUCT_MSB      = 15
)(
  input                             i_clk,
  input  [P_MUL_MULTIPLICAND_MSB:0] i_multiplicand,
  input  [P_MUL_MULTIPLIER_MSB:0]   i_multiplier,
  output [P_MUL_PRODUCT_MSB:0]      o_product
  );

  /////////////////////////////////////////////////////////////////////////////
  // Internal Signal Declarations
  /////////////////////////////////////////////////////////////////////////////
  reg [P_MUL_PRODUCT_MSB:0] r_product; // Holds the multiplication product
  
  /////////////////////////////////////////////////////////////////////////////
  //            ********      Architecture Declaration      ********
  /////////////////////////////////////////////////////////////////////////////

  /////////////////////////////////////////////////////////////////////////////
  // Process     : Multiplication Process
  // Description : Generates the product by performing the multiplication.
  /////////////////////////////////////////////////////////////////////////////
	always @(posedge i_clk)	begin
    //	Multiply any time the inputs changes.
		r_product <= $signed(i_multiplicand) * $signed(i_multiplier);
	end

  assign o_product = r_product;

endmodule // Integer_Multiplier