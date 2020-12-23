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
// Last modified : 2020/12/23 14:17:28
// Project Name  : ORCs
// Module Name   : Memory_Backplane
// Description   : The Memory_Backplane
//
// Additional Comments:
//   
/////////////////////////////////////////////////////////////////////////////////
module ORC_R32I #(
  // Compile time configurable generic parameters
  parameter P_FETCH_COUNTER_RESET = 32'h0000_0000 // First instruction address
)(
  // Component's clocks and resets
  input i_clk,        // clock
  input i_reset_sync, // reset
  // Wishbone(pipeline) Master Read Interface
  input         i_slave_read_stb,  // WB read enable
  input  [31:0] i_slave_read_addr, // WB address
  output [31:0] o_slave_read_data, // WB data
  // Wishbone(pipeline) Master Write Interface
  input        i_slave_write_stb,  // WB write enable
  input [31:0] i_slave_write_addr, // WB address
  input [31:0] i_slave_write_data, // WB data
  input [3:0]  i_slave_write_sel   // WB byte enable
);
  ///////////////////////////////////////////////////////////////////////////////
  // Internal Parameter Declarations
  ///////////////////////////////////////////////////////////////////////////////
  // OpCodes 
  localparam [6:0] L_RII = 7'b0010011; // imm[11:0],[19:15],funct[14:12],rd[11:7]
  localparam [6:0] L_RRO = 7'b0110011; // funct[6:0],rs2[24:20],rs1[19:15],funct[14:12],rd[11:7]
  // Program Counter
  localparam [2:0] S_WAKEUP           = 3'h0; // r_program_counter_state after reset
  localparam [2:0] S_WAIT_FOR_ACK     = 3'h1; // r_program_counter_state, waiting for valid instruction
  localparam [2:0] S_WAIT_FOR_DECODER = 3'h2; // r_program_counter_state, wait for Decoder process
  localparam [2:0] S_WAIT_FOR_READ    = 3'h3; // r_program_counter_state, wait for load to complete
  localparam [2:0] S_WAIT_FOR_WRITE   = 3'h4; // r_program_counter_state, wait for store to complete
  // Misc Definitions
  localparam [31:0] L_ALL_ZERO = 32'h0000_0000;
  localparam [31:0] L_ALL_ONES = 32'hFFFF_FFFF;
  ///////////////////////////////////////////////////////////////////////////////
  // Internal Signals Declarations
  ///////////////////////////////////////////////////////////////////////////////
  // Program Counter Process
  reg [31:0] r_next_pc_fetch;         // 32-bit program counter t
  reg [31:0] r_next_pc_decode;        // 32-bit program counter t-1
  reg        r_program_counter_valid; // Program Counter Valid
  reg [31:0] r_inst_data;             // registers the valid instructions
  reg [2:0]  r_program_counter_state; // Current State Holder.
  // BRAM array duplicated to index source 0 & 1 at same time. Fake a dual-port BRAM
  reg [31:0] mem_space0 [0:31];	// 32x32-bit registers
  reg [31:0] mem_space1 [0:31];	// 32x32-bit registers
  reg [4:0]  reset_index;               // This means the reset needs to be held for at least 32 clocks
  // Memory Master Read and Write Process
  reg        r_master_read_ready;
  reg [31:0] r_master_read_addr;
  reg        r_master_write_ready;
  // Instruction Fields wires
  wire [4:0] w_rd                = i_inst_read_data[11:7];  // rd field
  wire [4:0] w_destination_index = r_inst_data[11:7];       // registered rd_field (one clock delayed of w_rd)
  wire [4:0] w_source1_pointer   = i_inst_read_data[19:15]; // s1 field
  wire [4:0] w_source2_pointer   = i_inst_read_data[24:20]; // s2 field
  wire [2:0] w_fct3              = r_inst_data[14:12];      // fct3 field
  wire [6:0] w_fct7              = r_inst_data[31:25];      // fct7 field
  // source-1 and source-2 register selection
  reg         [31:0] r_unsigned_rs1;                          // rs1 field
  reg         [31:0] r_unsigned_rs2;                          // rs2 field
  wire        w_jump_request = r_jalr | w_bmux;
  wire [31:0] w_jump_value   = r_jalr == 1'b1 ? r_simm + r_unsigned_rs1 : r_simm + r_next_pc_decode;
  // Mem Process wires
  wire w_rd_not_zero = |w_rd; // or reduction of the destination register.
  // Qualifying signals
  // Decoder Process
  wire w_decoder_valid = r_jalr | r_bcc | r_rii | r_rro;
  // Program Counter Process
  wire w_decoder_opcode = w_opcode == L_RII  ? 1:
                          w_opcode == L_RRO  ? 1:
                          w_opcode == L_LCC  ? 1:
                          w_opcode == L_SCC  ? 1:
                          w_opcode == L_BCC  ? 1:
                          w_opcode == L_JALR ? 1:0;

  ///////////////////////////////////////////////////////////////////////////////
  //            ********      Architecture Declaration      ********           //
  ///////////////////////////////////////////////////////////////////////////////
  
  // Wishbone Strobe and address output assignments
  assign o_inst_read_stb  = r_program_counter_valid;
  assign o_inst_read_addr = r_next_pc_fetch;
  
  ///////////////////////////////////////////////////////////////////////////////
  // Process     : Program Counter Process
  // Description : Updates the next program counter after the data instruction 
  //               is consumed.
  ///////////////////////////////////////////////////////////////////////////////
  always@(posedge i_clk) begin
    if (i_reset_sync == 1'b1) begin
      r_program_counter_state <= S_WAKEUP;
      r_next_pc_fetch         <= P_FETCH_COUNTER_RESET;
      r_next_pc_decode        <= L_ALL_ZERO;
      r_inst_data             <= L_ALL_ZERO;
      r_program_counter_valid <= 1'b0;
    end
    else begin
      casez (r_program_counter_state)
        S_WAKEUP : begin
          // Fetch first instruction after reset.
          r_program_counter_valid <= 1'b1;
          r_program_counter_state <= S_WAIT_FOR_ACK;
        end
        S_WAIT_FOR_ACK : begin
          // If the no valid inst is currently available or if the following process
          // is ready to consume the valid instruction.
          if (i_inst_read_ack == 1'b1) begin
            if (w_decoder_opcode == 1'b1) begin
              // Increment the address and pre-load the program counter.
              r_next_pc_fetch <= r_next_pc_fetch+4;
              // If a valid instruction was just received.
              r_inst_data <= i_inst_read_data;
              // Transition
              r_program_counter_valid <= 1'b0;
              r_program_counter_state <= S_WAIT_FOR_DECODER;
            end
            else begin
              if (w_jal == 1'b1) begin
                // Is an immediate jump request. Update the program counter with the 
                // jump value.
                r_next_pc_fetch <= w_j_simm + r_next_pc_fetch;
              end
              else begin
                // Increment the program counter. Ignore this instruction
                r_next_pc_fetch <= r_next_pc_fetch+4;
              end
              // Transition
              r_program_counter_valid <= 1'b1;
              r_program_counter_state <= S_WAIT_FOR_ACK;
            end
          end 
          else begin
            r_program_counter_valid <= 1'b0;
            r_program_counter_state <= S_WAIT_FOR_ACK;
          end
          // Update the program counter.
          r_next_pc_decode <= r_next_pc_fetch;
        end
        S_WAIT_FOR_DECODER : begin
          // Wait one clock cycle to allow data to be stored in the registers.
          if (r_lcc == 1'b1) begin
            // Fetch external data
            r_program_counter_valid <= 1'b0;
            r_program_counter_state <= S_WAIT_FOR_READ;
          end
          else if(r_scc == 1'b1) begin
            // Store data in external.
            r_program_counter_valid <= 1'b0;
            r_program_counter_state <= S_WAIT_FOR_WRITE;
          end
          else begin
            // Done with regular instruction.
            if (w_jump_request == 1'b1) begin
              // Jump request by comparison (Branch or JALR).
              r_next_pc_fetch <= w_jump_value;
            end
            r_program_counter_valid <= 1'b1;
            r_program_counter_state <= S_WAIT_FOR_ACK;
          end
        end
        S_WAIT_FOR_READ : begin
          if (o_slave_read_ack == 1'b1) begin
            // Data received. Transition to fetch new instruction.
            r_program_counter_valid <= 1'b1;
            r_program_counter_state <= S_WAIT_FOR_ACK;
          end // else implement a timeout counter?
        end
        S_WAIT_FOR_WRITE : begin
          if (o_slave_write_ack == 1'b1) begin
            // Data write acknowledge. Trasition to fetch new instruction.
            r_program_counter_valid <= 1'b1;
            r_program_counter_state <= S_WAIT_FOR_ACK;
          end // else implement a timeout counter?
        end
        default : begin
          // Error condition caused by SEU? re-fetch instruction
          r_program_counter_state <= S_WAIT_FOR_ACK;
        end
      endcase
    end
  end

  ///////////////////////////////////////////////////////////////////////////////
  // Process     : General Purpose Registers Read Process
  // Description : Updates the contents of the general purpose registers.
  ///////////////////////////////////////////////////////////////////////////////
  always@(posedge i_clk) begin
    if (i_inst_read_ack == 1'b1) begin
      // Get rs1 and rs2
      r_unsigned_rs1 <= mem_space0[w_source1_pointer];
      r_unsigned_rs2 <= mem_space1[w_source2_pointer];
    end
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
  // Process     : General Purpose Registers Write Process
  // Description : Updates the contents of the general purpose registers.
  ///////////////////////////////////////////////////////////////////////////////
  always@(posedge i_clk) begin
    if (i_reset_sync == 1'b1) begin
      mem_space0[reset_index] <= L_ALL_ZERO;
      mem_space1[reset_index] <= L_ALL_ZERO;
    end
    else if (w_decoder_valid == 1'b1) begin
      // If w_decoder_valid = 1 store into general registers data that required date
      // from rs1 or rs2.
      if (r_jalr == 1'b1) begin
        // Jump And Link Register(indirect jump instruction).
        mem_space0[w_destination_index] <= r_next_pc_decode + 4;
        mem_space1[w_destination_index] <= r_next_pc_decode + 4;
      end
      if (r_rii == 1'b1) begin
        // Stores the Register-Immediate instruction result in the general register
        mem_space0[w_destination_index] <= w_rm_data;
        mem_space1[w_destination_index] <= w_rm_data;
      end
      if (r_rro == 1'b1) begin
        // Store the Register-Register operation result in the general registers
        mem_space0[w_destination_index] <= w_rm_data;
        mem_space1[w_destination_index] <= w_rm_data;
      end
    end
    else if (w_rd_not_zero == 1'b1 && i_inst_read_ack == 1'b1) begin
      if (w_opcode == L_LUI) begin
        // Load Upper Immediate.
        // Used to build 32-bit constants and uses the U-type format. Places the
        // 32-bit U-immediate value into the destination register rd, filling in
        // the lowest 12 bits with zeros.
        mem_space0[w_rd] <= { i_inst_read_data[31:12], L_ALL_ZERO[11:0] };
        mem_space1[w_rd] <= { i_inst_read_data[31:12], L_ALL_ZERO[11:0] };
      end
      if (w_opcode == L_AUIPC) begin
        // Add Upper Immediate to Program Counter.
        // Is used to build pc-relative addresses and uses the U-type format. 
        // AUIPC forms a 32-bit offset from the U-immediate, filling in the 
        // lowest 12 bits with zeros, adds this offset to the address of the 
        // AUIPC instruction, then places the result in register rd.
        mem_space0[w_rd] <= r_next_pc_fetch + { i_inst_read_data[31:12], L_ALL_ZERO[11:0] };
        mem_space1[w_rd] <= r_next_pc_fetch + { i_inst_read_data[31:12], L_ALL_ZERO[11:0] };
      end
      if (w_opcode == L_JAL) begin
        // Jump And Link Operation.
        // The offset is sign-extended and added to the address of the jump 
        // instruction to form the jump target address. JAL stores the address of
        // the instruction following the jump (r_next_pc_decode) into 
        // register rd.
        mem_space0[w_rd] <= r_next_pc_fetch + 4;
        mem_space1[w_rd] <= r_next_pc_fetch + 4;
      end
    end
    else if (o_slave_read_ack == 1'b1 && r_master_read_ready == 1'b0) begin
      // Data loaded from memory or I/O device.
      mem_space0[w_destination_index] <= w_l_data;
      mem_space1[w_destination_index] <= w_l_data;
    end
  end

  ///////////////////////////////////////////////////////////////////////////////
  // Process     : Read Process
  // Description : Registers the signals that create the read interface
  //               transaction.
  ///////////////////////////////////////////////////////////////////////////////
  always@(posedge i_clk) begin
    if (i_reset_sync == 1'b1) begin
      r_master_read_ready <= 1'b1;
      r_master_read_addr  <= L_ALL_ZERO;
    end
    else if (r_master_read_ready == 1'b1 &&  r_lcc == 1'b1) begin
      // Load the decode data to an external mem or I/O device.
      r_master_read_ready <= 1'b0;
      r_master_read_addr  <= w_master_addr;
    end
    else if (r_master_read_ready == 1'b0 &&  o_slave_read_ack == 1'b1) begin
      // Received valid data. Ready for new transaction on the next clock.
      r_master_read_ready <= 1'b1;
    end
  end
  assign i_slave_read_addr = w_master_addr;
  assign i_slave_read_stb  = r_lcc;

  ///////////////////////////////////////////////////////////////////////////////
  // Process     : Write Process
  // Description : Registers the signals used to create a write interface
  //               transaction.
  ///////////////////////////////////////////////////////////////////////////////
  always@(posedge i_clk) begin
    if (i_reset_sync == 1'b1) begin
      r_master_write_ready <= 1'b1;
    end
    else if (r_master_write_ready == 1'b1 && r_scc == 1'b1) begin
      // Store (write) data in external memory or device.
      r_master_write_ready <= 1'b0;                       
    end
    else if (r_master_write_ready == 1'b0 && o_slave_write_ack == 1'b1) begin
      r_master_write_ready <= 1'b1;
    end
  end
  assign i_slave_write_stb  = r_scc;
  assign i_slave_write_addr = w_master_addr;
  assign i_slave_write_data = w_s_data;
  assign i_slave_write_sel  = w_fct3==0||w_fct3==4 ? ( 
                                 w_master_addr[1:0]==3 ? 4'b1000 : 
                                 w_master_addr[1:0]==2 ? 4'b0100 : 
                                 w_master_addr[1:0]==1 ? 4'b0010 : 
                                                         4'b0001 ) :
                               w_fct3==1||w_fct3==5 ? ( 
                                 w_master_addr[1] == 1 ? 4'b1100 :
                                                         4'b0011 ) :
                                                         4'b1111;

endmodule

