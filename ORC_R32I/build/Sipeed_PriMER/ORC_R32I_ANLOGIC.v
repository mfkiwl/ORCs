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
// File name     : ORC_R32I.v
// Author        : Jose R Garcia
// Created       : 2020/11/04 23:20:43
// Last modified : 2021/01/04 12:04:32
// Project Name  : ORCs
// Module Name   : ORC_R32I
// Description   : The ORC_R32I is a machine mode capable hart implementation of 
//                 the riscv32i instruction set architecture.
//
// Additional Comments:
//   This core was initially written using the prior work done on the DarkRISC
//   project as reference. For simulation use the make file in the sim directory.
//   for synthesis and building example use the scripts in the build directory. 
//   The interfaces signals adhere to Wishbone B4 spec. A reduced set of signals
//   is used, CYC_O is not implemented.
/////////////////////////////////////////////////////////////////////////////////
module ORC_R32I #(
  // Compile time configurable generic parameters
  parameter P_FETCH_COUNTER_RESET = 32'h0000_0000 // First instruction address
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
  // OpCodes 
  localparam [6:0] L_RII   = 7'b0010011; // imm[11:0],[19:15],funct[14:12],rd[11:7]
  localparam [6:0] L_RRO   = 7'b0110011; // funct[6:0],rs2[24:20],rs1[19:15],funct[14:12],rd[11:7]
  localparam [6:0] L_LUI   = 7'b0110111; // imm[31:12], rd[11:7]
  localparam [6:0] L_AUIPC = 7'b0010111; // imm[31:12], rd[11:7]
  localparam [6:0] L_JAL   = 7'b1101111; // imm[20|10:1|11|19:12],rd[11:7]
  localparam [6:0] L_JALR  = 7'b1100111; // imm[11:0], rs1[19:15],000,rd[11:7]
  localparam [6:0] L_BCC   = 7'b1100011; // imm[12|10:5],rs2[24:20],rs1[19:15],funct[14:12],imm[4:1|11]
  localparam [6:0] L_LCC   = 7'b0000011; // imm[11:0],rs1[19:15],funct[14:12],rd[11:7]
  localparam [6:0] L_SCC   = 7'b0100011; // imm[11:5],rs2[24:20],rs1[19:15],funct[14:12],imm[4:0]
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
  // Decoder Process Signals
  wire [6:0]  w_opcode = i_inst_read_data[6:0]; // OPCODE field
  reg  [31:0] r_simm;                           // Signed Immediate
  reg  [31:0] r_uimm;                           // Unsigned Immediate
  reg         r_jalr;                           // valid JALR flag
  reg         r_bcc;                            // valid branch flag
  reg         r_lcc;                            // valid load flag
  reg         r_scc;                            // valid store flag
  reg         r_rii;                            // valid register-immediate flag
  reg         r_rro;                            // valid register-register flag
  // General Purpose Registers. BRAM array duplicated to index source 1 & 2 at same time.
  wire [31:0] w_unsigned_rs1;
  wire [31:0] w_unsigned_rs2;
  reg [4:0]  reset_index = 0;           // This means the reset needs to be held for at least 32 clocks
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
  wire signed [31:0] w_signed_rs1  = $signed(r_unsigned_rs1); // signed rs1
  wire signed [31:0] w_signed_rs2  = $signed(r_unsigned_rs2); // signed rs2
  wire        [31:0] w_master_addr = r_unsigned_rs1 + r_simm; // address created by lcc and scc instructions
  // L-group of instructions (w_opcode==7'b0000011)
  wire [31:0] w_l_data = w_fct3==0||w_fct3==4 ? 
                           (r_master_read_addr[1:0]==3 ? { w_fct3==0&&i_master_read_data[31] ? L_ALL_ONES[31:8]:L_ALL_ZERO[31:8], i_master_read_data[31:24] } :
                            r_master_read_addr[1:0]==2 ? { w_fct3==0&&i_master_read_data[23] ? L_ALL_ONES[31:8]:L_ALL_ZERO[31:8], i_master_read_data[23:16] } :
                            r_master_read_addr[1:0]==1 ? { w_fct3==0&&i_master_read_data[15] ? L_ALL_ONES[31:8]:L_ALL_ZERO[31:8], i_master_read_data[15:8] } :
                              {w_fct3==0&&i_master_read_data[7] ? L_ALL_ONES[31:8]:L_ALL_ZERO[31:8], i_master_read_data[7:0]}):
                         w_fct3==1||w_fct3==5 ? ( r_master_read_addr[1]==1 ? { w_fct3==1&&i_master_read_data[31] ? L_ALL_ONES[31:16]:L_ALL_ZERO[31:16], i_master_read_data[31:16] } :
                           {w_fct3==1&&i_master_read_data[15] ? L_ALL_ONES[31:16]:L_ALL_ZERO[31:16], i_master_read_data[15:0]}) : i_master_read_data;
  // S-group of instructions (w_opcode==7'b0100011)
  wire [31:0] w_s_data = w_fct3==0 ? ( w_master_addr[1:0]==3 ? { r_unsigned_rs2[ 7: 0], L_ALL_ZERO [23:0] } : 
                                       w_master_addr[1:0]==2 ? { L_ALL_ZERO [31:24], r_unsigned_rs2[7:0], L_ALL_ZERO[15:0] } : 
                                       w_master_addr[1:0]==1 ? { L_ALL_ZERO [31:16], r_unsigned_rs2[7:0], L_ALL_ZERO[7:0] } :
                                                  { L_ALL_ZERO [31: 8], r_unsigned_rs2[7:0] } ) :
                         w_fct3==1 ? ( w_master_addr[1]  ==1 ? { r_unsigned_rs2[15: 0], L_ALL_ZERO [15:0] } :
                                                  { L_ALL_ZERO [31:16], r_unsigned_rs2[15:0] } ) : r_unsigned_rs2;
  // RM-group of instructions (OPCODEs==7'b0010011/7'b0110011), merged! src=immediate(M)/register(R)
  wire signed [31:0] w_signed_rs2_extended   = r_rii ? r_simm : w_signed_rs2;
  wire        [31:0] w_unsigned_rs2_extended = r_rii ? r_uimm : r_unsigned_rs2;
  wire        [31:0] w_rm_data               = w_fct3==7 ? (r_unsigned_rs1 & w_signed_rs2_extended) :
                                               w_fct3==6 ? (r_unsigned_rs1 | w_signed_rs2_extended) :
                                               w_fct3==4 ? (r_unsigned_rs1 ^ w_signed_rs2_extended) :
                                               w_fct3==3 ? (r_unsigned_rs1 < w_unsigned_rs2_extended ? 1:0) :
                                               w_fct3==2 ? (w_signed_rs1 < w_signed_rs2_extended ? 1:0) : 
                                               w_fct3==0 ? (r_rro && w_fct7[5] ? r_unsigned_rs1 - w_unsigned_rs2_extended : 
                                                                                 r_unsigned_rs1 + w_signed_rs2_extended) :
                                               w_fct3==1 ? (r_unsigned_rs1 << w_unsigned_rs2_extended[4:0]) :                         
                                               w_fct7[5] ? $signed(w_signed_rs1 >>> w_unsigned_rs2_extended[4:0]) :                    
                                                            r_unsigned_rs1 >> w_unsigned_rs2_extended[4:0];
  // Jump/Branch-group of instructions (w_opcode==7'b1100011)
  wire        w_jal    = w_opcode == L_JAL ? 1:0;
  wire [31:0] w_j_simm = { i_inst_read_data[31] ? L_ALL_ONES[31:21]:L_ALL_ZERO[31:21],
                           i_inst_read_data[31], i_inst_read_data[19:12],
                           i_inst_read_data[20], i_inst_read_data[30:21], L_ALL_ZERO[0] };
  wire w_bmux = r_bcc & (
                w_fct3==4 ? w_signed_rs1   <  w_signed_rs2 :   // blt
                w_fct3==5 ? w_signed_rs1   >= w_signed_rs2 :   // bge
                w_fct3==6 ? r_unsigned_rs1 <  r_unsigned_rs2 : // bltu
                w_fct3==7 ? r_unsigned_rs1 >= r_unsigned_rs2 : // bgeu
                w_fct3==0 ? r_unsigned_rs1 == r_unsigned_rs2 : // beq
                w_fct3==1 ? r_unsigned_rs1 != r_unsigned_rs2 : // bne
                0);
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
              // Instructions that require accessing registers and/or external 
              // devices.
              // Increment the address and pre-load the program counter. Register
              // the instruction.
              r_next_pc_fetch <= (r_next_pc_fetch+32'h4);
              // Transition
              r_program_counter_valid <= 1'b0;
              r_program_counter_state <= S_WAIT_FOR_DECODER;
            end
            if (w_jal == 1'b1) begin
              // Is an immediate jump request. Update the program counter with the 
              // jump value.
              r_next_pc_fetch <= (w_j_simm+r_next_pc_fetch);
              r_program_counter_valid <= 1'b1;
              r_program_counter_state <= S_WAIT_FOR_ACK;
            end
            else begin
              // Instructions that are executed in one clock: LUI, AUIPC, FENCE, 
              // ECALL and BREAK
              // Increment the program counter. Ignore this instruction
              r_next_pc_fetch <= (r_next_pc_fetch+32'h4);
              r_program_counter_valid <= 1'b1;
              r_program_counter_state <= S_WAIT_FOR_ACK;
            end
            r_inst_data <= i_inst_read_data;
          end
          else begin
            r_inst_data             <= r_inst_data;
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
            if (w_jump_request == 1'b1) begin
              // Jump request by comparison (Branch or JALR).
              r_next_pc_fetch <= w_jump_value;
            end
            // Done with regular instruction.
            r_program_counter_valid <= 1'b1;
            r_program_counter_state <= S_WAIT_FOR_ACK;
          end
        end
        S_WAIT_FOR_READ : begin
          if (i_master_read_ack == 1'b1) begin
            // Data received. Transition to fetch new instruction.
            r_program_counter_valid <= 1'b1;
            r_program_counter_state <= S_WAIT_FOR_ACK;
          end // else implement a timeout counter?
        end
        S_WAIT_FOR_WRITE : begin
          if (i_master_write_ack ==1'b1) begin
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
  // Process     : Decoder Process
  // Description : Decodes and registers the instruction data.
  ///////////////////////////////////////////////////////////////////////////////
  always@(posedge i_clk) begin
    if (i_reset_sync == 1'b1) begin
      r_jalr <= 1'b0;
      r_bcc  <= 1'b0;
      r_lcc  <= 1'b0;
      r_scc  <= 1'b0;
      r_rii  <= 1'b0;
      r_rro  <= 1'b0;
      r_simm <= L_ALL_ZERO;
      r_uimm <= L_ALL_ZERO;
    end
    else begin
      if (i_inst_read_ack == 1'b1 && w_rd_not_zero == 1'b1) begin
        // If rs1 and rs2 are valid
        if (w_opcode == L_RII) begin
          // Register-Immediate Instructions.
          // Performs ADDI, SLTI, ANDI, ORI, XORI, SLLI, SRLI, SRAI (I=immediate).
          r_rii  <= 1'b1;
          r_simm <= { i_inst_read_data[31] ? L_ALL_ONES[31:12]:L_ALL_ZERO[31:12], i_inst_read_data[31:20] };
          r_uimm <= { L_ALL_ZERO[31:12], i_inst_read_data[31:20] };
        end
        else begin
          r_rii <= 1'b0;
        end
  
        if ( w_opcode == L_RRO) begin
          // Register-Register Operations
          // Performs ADD, SLT, SLTU, AND, OR, XOR, SLL, SRL, SUB, SRA
          r_rro <= 1'b1;
        end
        else begin
          r_rro <= 1'b0;
        end
  
        if (w_opcode == L_JALR) begin
          //  Jump And Link Register(indirect jump instruction).
          // The target address is obtained by adding the sign-extended 12-bit
          // I-immediate to the register rs1, then setting the least-significant bit of
          // the result to zero. The address of the instruction following the jump
          // (r_next_pc_fetch) is written to register rd. Register x0 can be
          // used as the destination if the result is not required.
          r_jalr <= 1'b1;
          r_simm <= { i_inst_read_data[31] ? L_ALL_ONES[31:12]:L_ALL_ZERO[31:12],
                      i_inst_read_data[31:20] };
        end
        else begin
          r_jalr <= 1'b0;
        end
          
        if (w_opcode == L_BCC) begin
          // Branches Conditional to Comparisons.
          // The 12-bit B-immediate encodes signed offsets in multiples of 2 bytes.
          // The offset is sign-extended and added to the address of the branch 
          // instruction to give the target address. Branch instructions compare 
          // two registers.
          r_bcc  <= 1'b1;
          r_simm <= { i_inst_read_data[31] ? L_ALL_ONES[31:13]:L_ALL_ZERO[31:13], 
                     i_inst_read_data[31],i_inst_read_data[7],i_inst_read_data[30:25],
                     i_inst_read_data[11:8],L_ALL_ZERO[0] };
        end
        else begin
          r_bcc <= 1'b0;
        end
  
        if ( w_opcode == L_LCC) begin
          // Load, Conditional to Comparisons.
          // The effective address is obtained by adding register rs1 to the 
          // sign-extended 12-bit offset. Loads copy a value from memory to 
          // register rd.
          r_lcc  <= 1'b1;
          r_simm <= { i_inst_read_data[31] ? L_ALL_ONES[31:12]:L_ALL_ZERO[31:12], 
                     i_inst_read_data[31:20] };
        end
        else begin
          r_lcc <= 1'b0;
        end
  
        if (w_opcode == L_SCC) begin
          // Store, Conditional to Comparisons.
          // The effective address is obtained by adding register rs1 to the 
          // sign-extended 12-bit offset. Stores copy the value in register rs2 to
          // memory.
          r_scc   <= 1'b1;
          r_simm  <= { i_inst_read_data[31] ? L_ALL_ONES[31:12]:L_ALL_ZERO[31:12], 
                       i_inst_read_data[31:25], i_inst_read_data[11:7] };
        end
        else begin
          r_scc <= 1'b0;
        end
      end
      else begin
        // If Data not valid or if decoder not ready
        r_rii  <= 1'b0;
        r_rro  <= 1'b0;
        r_jalr <= 1'b0;
        r_bcc  <= 1'b0;
        r_lcc  <= 1'b0;
        r_scc  <= 1'b0;
      end
    end
  end

  ///////////////////////////////////////////////////////////////////////////////
  // Process     : General Purpose Registers Read Process
  // Description : Updates the contents of the general purpose registers.
  ///////////////////////////////////////////////////////////////////////////////
  always@(posedge i_clk) begin
      // Get rs1 and rs2
      r_unsigned_rs1 <= w_unsigned_rs1;
      r_unsigned_rs2 <= w_unsigned_rs2;
  end

  ///////////////////////////////////////////////////////////////////////////////
  // Process     : General Purpose Registers Write Process
  // Description : Updates the contents of the general purpose registers.
  ///////////////////////////////////////////////////////////////////////////////
  always@(posedge i_clk) begin
    if (i_reset_sync == 1'b1) begin
      reset_index <= reset_index+1;
    end
  end

  wire [31:0] w_bram_data_input = i_reset_sync ? L_ALL_ZERO :
                           w_decoder_valid ? (r_jalr ? r_next_pc_decode + 4 :
                                             r_rii || r_rro ? w_rm_data : w_rm_data) :
                           w_rd_not_zero & i_inst_read_ack ? (
                             w_opcode == L_LUI   ? { i_inst_read_data[31:12], L_ALL_ZERO[11:0] } :
                             w_opcode == L_AUIPC ? r_next_pc_fetch + { i_inst_read_data[31:12], L_ALL_ZERO[11:0] } :
                             w_opcode == L_JAL   ? r_next_pc_fetch + 4 : w_rm_data) :
                           i_master_read_ack & !r_master_read_ready ? w_l_data : w_rm_data;
  
  wire [4:0] w_bram_addr_input = i_reset_sync ? reset_index : 
                           w_decoder_valid ? w_destination_index :
                           w_rd_not_zero & i_inst_read_ack ? w_rd :
                           i_master_read_ack & !r_master_read_ready ? w_destination_index : w_rd;

  wire w_bram_enable_input = i_reset_sync    ? 1'b1 :
                             w_decoder_valid & (r_jalr | r_rii | r_rro) ? 1'b1 : 
                             w_rd_not_zero & i_inst_read_ack ? (
                               w_opcode == L_LUI || w_opcode == L_AUIPC || w_opcode == L_JAL ? 1'b1 : 1'b0) :
                             i_master_read_ack & !r_master_read_ready ? 1'b1 : 1'b0;

  BRAM general_registers1(
    // Write Side
  	.dia(w_bram_data_input), 
    .addra(w_bram_addr_input), 
    .cea(w_bram_enable_input), 
    .clka(i_clk),
    // Read Side
  	.dob(w_unsigned_rs1), 
    .addrb(w_source1_pointer), 
    .ceb(i_inst_read_ack), 
    .clkb(i_clk)
  );
  
  BRAM general_registers2(
    // Write Side
  	.dia(w_bram_data_input), 
    .addra(w_bram_addr_input), 
    .cea(w_bram_enable_input), 
    .clka(i_clk),
    //Read side
  	.dob(w_unsigned_rs2), 
    .addrb(w_source2_pointer), 
    .ceb(i_inst_read_ack), 
    .clkb(i_clk)
  );

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
    else if (r_master_read_ready == 1'b0 &&  i_master_read_ack == 1'b1) begin
      // Received valid data. Ready for new transaction on the next clock.
      r_master_read_ready <= 1'b1;
    end
  end
  assign o_master_read_addr = w_master_addr;
  assign o_master_read_stb  = r_lcc;

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
    else if (r_master_write_ready == 1'b0 && i_master_write_ack == 1'b1) begin
      r_master_write_ready <= 1'b1;
    end
  end
  assign o_master_write_stb  = r_scc;
  assign o_master_write_addr = w_master_addr;
  assign o_master_write_data = w_s_data;
  assign o_master_write_sel  = w_fct3==0||w_fct3==4 ? ( 
                                 w_master_addr[1:0]==3 ? 4'b1000 : 
                                 w_master_addr[1:0]==2 ? 4'b0100 : 
                                 w_master_addr[1:0]==1 ? 4'b0010 : 
                                                         4'b0001 ) :
                               w_fct3==1||w_fct3==5 ? ( 
                                 w_master_addr[1] == 1 ? 4'b1100 :
                                                         4'b0011 ) :
                                                         4'b1111;

endmodule
