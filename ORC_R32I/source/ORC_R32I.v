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
// Last modified : 2020/11/28 08:41:48
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
  // Component clocks and resets
  input i_clk,        // clock
  input i_reset_sync, // reset
  // Instruction Wishbone(pipeline) Interface
  output        o_inst_read,      // HBI read enable
  input         i_inst_read_ack,  // HBI acknowledge 
  output [31:0] o_inst_read_addr, // HBI address
  input  [31:0] i_inst_read_data, // HBI data
  // Wishbone(pipeline) Master Read Interface
  output        o_master_read,      // HBI read enable
  input         i_master_read_ack,  // HBI acknowledge 
  output [31:0] o_master_read_addr, // HBI address
  input  [31:0] i_master_read_data, // HBI data
  // Wishbone(pipeline) Master Write Interface
  output        o_master_write,            // HBI write enable
  input         i_master_write_ack,        // HBI acknowledge 
  output [31:0] o_master_write_addr,       // HBI address
  output [31:0] o_master_write_data,       // HBI data
  output [3:0]  o_master_write_byte_enable // HBI byte enable
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
  // Misc Definitions
  localparam [31:0] L_ALL_ZERO = 32'h0000_0000;
  localparam [31:0] L_ALL_ONES = 32'hFFFF_FFFF;
  ///////////////////////////////////////////////////////////////////////////////
  // Internal Signals Declarations
  ///////////////////////////////////////////////////////////////////////////////
  // Program Counter Process
  reg [31:0] r_next_pc_fetch;         // 32-bit program counter t+2
  reg [31:0] r_next_pc_decode;        // 32-bit program counter t+1
  reg [31:0] r_pc;                    // 32-bit program counter t+0
  reg        r_program_counter_valid; // Program Counter Valid
  reg        r_inst_read_ack;
  reg [31:0] r_inst_data;
  // Decoder Process Signals
  wire [6:0]  w_opcode    = i_inst_read_data[6:0];
  wire [6:0]  w_pc_opcode = r_inst_data[6:0];
  reg  [31:0] r_simm;
  reg  [31:0] r_uimm;
  reg         r_jalr;
  reg         r_bcc;
  reg         r_lcc;
  reg         r_scc;
  reg         r_rii;
  reg         r_rro;
  // General Purpose Registers. BRAM array duplicated to index source 1 & 2 at same time.
  reg [31:0] general_registers1 [0:31];	// 32x32-bit registers
  reg [31:0] general_registers2 [0:31];	// 32x32-bit registers
  reg [4:0]  reset_index = 0;           // This means the reset needs to be held for at least 32 clocks
  // Memory Master Read and Write Process
  reg        r_master_read;
  reg [31:0] r_master_read_addr;
  reg        r_master_write;
  reg [31:0] r_master_write_addr;
  reg [31:0] r_master_write_data;
  reg [3:0]  r_master_write_byte_enable;
  // Instruction Fields wires
  wire [4:0] w_rd                = i_inst_read_data[11:7];
  wire [4:0] w_destination_index = r_inst_data[11:7];
  wire [4:0] w_source1_pointer   = i_inst_read_data[19:15];
  wire [4:0] w_source2_pointer   = i_inst_read_data[24:20];
  wire [2:0] w_fct3              = r_inst_data[14:12];
  wire [6:0] w_fct7              = r_inst_data[31:25];
  // source-1 and source-2 register selection
  reg         [31:0] r_unsigned_rs1;
  reg         [31:0] r_unsigned_rs2;
  wire signed [31:0] w_signed_rs1  = $signed(r_unsigned_rs1);
  wire signed [31:0] w_signed_rs2  = $signed(r_unsigned_rs2);
  wire        [31:0] w_master_addr = r_unsigned_rs1 + r_simm;
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
  wire        [31:0] w_rm_data               = w_fct3==7 ? r_unsigned_rs1&w_signed_rs2_extended :
                                               w_fct3==6 ? r_unsigned_rs1|w_signed_rs2_extended :
                                               w_fct3==4 ? r_unsigned_rs1^w_signed_rs2_extended :
                                               w_fct3==3 ? r_unsigned_rs1<w_unsigned_rs2_extended?1:0 :
                                               w_fct3==2 ? w_signed_rs1<w_signed_rs2_extended?1:0 : 
                                               w_fct3==0 ? (r_rro&&w_fct7[5] ? r_unsigned_rs1-w_unsigned_rs2_extended : 
                                                                               r_unsigned_rs1+w_signed_rs2_extended) :
                                               w_fct3==1 ? r_unsigned_rs1<<w_unsigned_rs2_extended[4:0] :                         
                                               w_fct7[5] ? $signed(w_signed_rs1>>>w_unsigned_rs2_extended[4:0]) :                    
                                                  r_unsigned_rs1>>w_unsigned_rs2_extended[4:0];
  // Jump/Branch-group of instructions (w_opcode==7'b1100011)
  wire        w_jal    = (w_opcode == L_JAL   && r_inst_read_ack == 1'b1) ? 1:0;
  wire [31:0] w_j_simm = { r_inst_data[31] ? L_ALL_ONES[31:21]:L_ALL_ZERO[31:21],
                           r_inst_data[31], r_inst_data[19:12],
                           r_inst_data[20], r_inst_data[30:21], L_ALL_ZERO[0] };
  wire w_bmux = r_bcc & (
                w_fct3==4 ? w_signed_rs1   <  w_signed_rs2 :   // blt
                w_fct3==5 ? w_signed_rs1   >= w_signed_rs2 :   // bge
                w_fct3==6 ? r_unsigned_rs1 <  r_unsigned_rs2 : // bltu
                w_fct3==7 ? r_unsigned_rs1 >= r_unsigned_rs2 : // bgeu
                w_fct3==0 ? r_unsigned_rs1 == r_unsigned_rs2 : // beq
                w_fct3==1 ? r_unsigned_rs1 != r_unsigned_rs2 : // bne
                0);
  wire        w_jump_request = w_jal | r_jalr | w_bmux;
  wire [31:0] w_jump_value   = w_bmux == 1'b1 ? r_simm + r_next_pc_decode : 
                               r_jalr == 1'b1 ? r_simm + r_unsigned_rs1 : 
                               w_j_simm + r_next_pc_decode; // w_jal == 1'b1 ?
  // Mem Process wires
  wire w_rd_not_zero                = |w_rd;
  wire w_destination_index_not_zero = |w_destination_index;
  // Ready signals
  // External devices R/W
  wire w_read_ready  = !r_master_read  | i_master_read_ack;
  wire w_write_ready = !r_master_write | i_master_write_ack;
  // Decoder Process
  wire w_decoder_valid = r_jalr | r_bcc | r_rii | r_rro | r_lcc | r_scc;
  wire w_decoder_ready = (!w_decoder_valid & w_read_ready & w_write_ready);// | w_decoder_valid;
  // Program Counter Process
  wire w_decoder_opcode = w_opcode == L_RII  ? 1:
                          w_opcode == L_RRO  ? 1:
                          w_opcode == L_LCC  ? 1:
                          w_opcode == L_SCC  ? 1:
                          w_opcode == L_BCC  ? 1:
                          w_opcode == L_JALR ? 1:0;
  wire w_program_counter_ready = (w_decoder_ready & r_program_counter_valid) & (!w_decoder_opcode) | 
                                 (!r_program_counter_valid );
  //wire w_program_counter_ready = w_decoder_ready & !w_decoder_opcode;

  ///////////////////////////////////////////////////////////////////////////////
  //            ********      Architecture Declaration      ********           //
  ///////////////////////////////////////////////////////////////////////////////
  
  // Wishbone Strobe and address output assignments
  assign o_inst_read      = r_program_counter_valid & !w_jump_request;
  assign o_inst_read_addr = r_next_pc_fetch;
  
  ///////////////////////////////////////////////////////////////////////////////
  // Process     : Program Counter Process
  // Description : Updates the next program counter after the data instruction 
  //               is consumed.
  ///////////////////////////////////////////////////////////////////////////////
  always@(posedge i_clk) begin
    if (i_reset_sync == 1'b1) begin
      r_next_pc_fetch         <= P_FETCH_COUNTER_RESET;
      r_next_pc_decode        <= L_ALL_ZERO;
      r_pc                    <= L_ALL_ZERO;
      r_program_counter_valid <= 1'b0;
    end
    else begin
      if (w_program_counter_ready == 1'b1) begin
        // If the no valid inst is currently available or if the following process
        // is ready to consume the valid instruction.
        if ( i_inst_read_ack == 1'b1) begin
          // If a valid instruction was just received.
          if (w_jump_request == 1'b1) begin
            // When there is a jump request update the program counter with the 
            // jump value.
            r_next_pc_fetch         <= w_jump_value;
            r_program_counter_valid <= 1'b0;
          end
          else if (w_decoder_ready == 1'b1) begin
            // Increment the address and update the program counter.
            r_next_pc_fetch         <= r_next_pc_fetch+4;
            r_program_counter_valid <= 1'b1;
          end
          // Update the program counter.
          r_next_pc_decode <= r_next_pc_fetch;
          r_pc             <= r_next_pc_decode;
        end
        else if (r_program_counter_valid == 1'b1) begin
          // When the program counter is valid but no instruction has been received
          r_program_counter_valid <= 1'b0;
        end
        else if (r_inst_read_ack == 1'b1) begin
          // If backpreasssure was applied to finish an instruction and now a new
          // instruction needs to be requested.
          if (w_jump_request == 1'b1) begin
            // When there is a jump request update the program counter with the 
            // jump value.
            r_next_pc_fetch         <= w_jump_value;
            r_program_counter_valid <= 1'b0;
          end
          else if (w_decoder_ready == 1'b1) begin
            // Increment the address and update the program counter.
            r_next_pc_fetch         <= r_next_pc_fetch+4;
            r_program_counter_valid <= 1'b1;
          end
          // Update the program counter.
          r_next_pc_decode <= r_next_pc_fetch;
          r_pc             <= r_next_pc_decode;
        end
        else begin
          // When the interface instruction read interface is ready for the next
          // address but the program counter is yet to be updated.
          r_program_counter_valid <= 1'b1;
        end
      end
      else begin
        // When the decoder is applying back preassure.
        r_program_counter_valid <= 1'b0;
      end
      if ( i_inst_read_ack == 1'b1) begin
        // If a valid instruction was just received.
        r_inst_data     <= i_inst_read_data;
        r_inst_read_ack <= 1'b1;
      end
      else begin
        r_inst_read_ack <= 1'b0;
      end
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
      if (w_decoder_ready == 1'b1 && r_inst_read_ack == 1'b1 && w_destination_index_not_zero == 1'b1) begin
        // 
        if (w_pc_opcode == L_RII) begin
          // Register-Immediate Instructions.
          // Performs ADDI, SLTI, ANDI, ORI, XORI, SLLI, SRLI, SRAI (I=immediate).
          r_rii  <= 1'b1;
          r_simm <= { r_inst_data[31] ? L_ALL_ONES[31:12]:L_ALL_ZERO[31:12], r_inst_data[31:20] };
          r_uimm <= { L_ALL_ZERO[31:12], r_inst_data[31:20] };
        end
        else begin
          r_rii <= 1'b0;
        end
  
        if ( w_pc_opcode == L_RRO) begin
          // Register-Register Operations
          // Performs ADD, SLT, SLTU, AND, OR, XOR, SLL, SRL, SUB, SRA
          r_rro <= 1'b1;
        end
        else begin
          r_rro <= 1'b0;
        end
  
        if (w_pc_opcode == L_JALR) begin
          //  Jump And Link Register(indirect jump instruction).
          // The target address is obtained by adding the sign-extended 12-bit
          // I-immediate to the register rs1, then setting the least-significant bit of
          // the result to zero. The address of the instruction following the jump
          // (r_next_pc_decode) is written to register rd. Register x0 can be
          // used as the destination if the result is not required.
          r_jalr <= 1'b1;
          r_simm <= { r_inst_data[31] ? L_ALL_ONES[31:12]:L_ALL_ZERO[31:12],
                      r_inst_data[31:20] };
        end
        else begin
          r_jalr <= 1'b0;
        end
          
        if (w_pc_opcode == L_BCC) begin
          // Branches Conditional to Comparisons.
          // The 12-bit B-immediate encodes signed offsets in multiples of 2 bytes.
          // The offset is sign-extended and added to the address of the branch 
          // instruction to give the target address. Branch instructions compare 
          // two registers.
          r_bcc  <= 1'b1;
          r_simm <= { r_inst_data[31] ? L_ALL_ONES[31:13]:L_ALL_ZERO[31:13], 
                     r_inst_data[31],r_inst_data[7],r_inst_data[30:25],
                     r_inst_data[11:8],L_ALL_ZERO[0] };
        end
        else begin
          r_bcc <= 1'b0;
        end
  
        if ( w_pc_opcode == L_LCC) begin
          // Load, Conditional to Comparisons.
          // The effective address is obtained by adding register rs1 to the 
          // sign-extended 12-bit offset. Loads copy a value from memory to 
          // register rd.
          r_lcc  <= 1'b1;
          r_simm <= { r_inst_data[31] ? L_ALL_ONES[31:12]:L_ALL_ZERO[31:12], 
                     r_inst_data[31:20] };
        end
        else begin
          r_lcc <= 1'b0;
        end
  
        if (w_pc_opcode == L_SCC) begin
          // Store, Conditional to Comparisons.
          // The effective address is obtained by adding register rs1 to the 
          // sign-extended 12-bit offset. Stores copy the value in register rs2 to
          // memory.
          r_scc   <= 1'b1;
          r_simm  <= { r_inst_data[31] ? L_ALL_ONES[31:12]:L_ALL_ZERO[31:12], 
                       r_inst_data[31:25], r_inst_data[11:7] };
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
    if (i_inst_read_ack == 1'b1) begin
      r_unsigned_rs1 = general_registers1[w_source1_pointer];
      r_unsigned_rs2 = general_registers2[w_source2_pointer];
    end
  end

  // Used for test bench debugging
  wire w_lui   = (w_opcode == L_LUI   && i_inst_read_ack == 1'b1) ? 1:0;
  wire w_auipc = (w_opcode == L_AUIPC && i_inst_read_ack == 1'b1) ? 1:0;
  
  ///////////////////////////////////////////////////////////////////////////////
  // Process     : General Purpose Registers Write Process
  // Description : Updates the contents of the general purpose registers.
  ///////////////////////////////////////////////////////////////////////////////
  always@(posedge i_clk) begin
    if (i_reset_sync == 1'b1) begin
      reset_index                     = reset_index+1;
      general_registers1[reset_index] = L_ALL_ZERO;
      general_registers2[reset_index] = L_ALL_ZERO;
    end
    else if (w_decoder_valid == 1'b1) begin
      // If w_decoder_valid = 1 store into general registers data that required date
      // from rs1 or rs2.
      if (r_jalr == 1'b1) begin
        //  Jump And Link Register(indirect jump instruction).
        general_registers1[w_destination_index] = r_next_pc_decode;
        general_registers2[w_destination_index] = r_next_pc_decode;
      end
      if (r_rii == 1'b1) begin
        // Stores the Register-Immediate instruction result in the general register
        general_registers1[w_destination_index] = w_rm_data;
        general_registers2[w_destination_index] = w_rm_data;
      end
      if (r_rro == 1'b1) begin
        // Store the Register-Register operation result in the general registers
        general_registers1[w_destination_index] = w_rm_data;
        general_registers2[w_destination_index] = w_rm_data;
      end
    end
    else if (w_rd_not_zero == 1'b1 && i_inst_read_ack == 1'b1) begin
      if (w_opcode == L_LUI) begin
        // Load Upper Immediate.
        // Used to build 32-bit constants and uses the U-type format. Places the
        // 32-bit U-immediate value into the destination register rd, filling in
        // the lowest 12 bits with zeros.
        general_registers1[w_rd] = { i_inst_read_data[31:12], L_ALL_ZERO[11:0] };
        general_registers2[w_destination_index] = { i_inst_read_data[31:12], L_ALL_ZERO[11:0] };
      end
      if (w_opcode == L_AUIPC) begin
        // Add Upper Immediate to Program Counter.
        // Is used to build pc-relative addresses and uses the U-type format. 
        // AUIPC forms a 32-bit offset from the U-immediate, filling in the 
        // lowest 12 bits with zeros, adds this offset to the address of the 
        // AUIPC instruction, then places the result in register rd.
        general_registers1[w_rd] = r_next_pc_decode + { i_inst_read_data[31:12], L_ALL_ZERO[11:0] };
        general_registers2[w_rd] = r_next_pc_decode + { i_inst_read_data[31:12], L_ALL_ZERO[11:0] };
      end
      if (w_opcode == L_JAL) begin
        // Jump And Link Operation.
        // The offset is sign-extended and added to the address of the jump 
        // instruction to form the jump target address. JAL stores the address of
        // the instruction following the jump (r_next_pc_decode) into 
        // register rd.
        general_registers1[w_rd] = r_next_pc_fetch;
        general_registers2[w_rd] = r_next_pc_fetch;
      end
    end
    else if (i_master_read_ack == 1'b1 && r_inst_read_ack == 1'b0) begin
      // Data loaded from memory.
      general_registers1[w_destination_index] = w_l_data;
      general_registers2[w_destination_index] = w_l_data;
    end
  end

  ///////////////////////////////////////////////////////////////////////////////
  // Process     : Read Process
  // Description : Registers the signals that create the read interface
  //               transaction.
  ///////////////////////////////////////////////////////////////////////////////
  always@(posedge i_clk) begin
    if (i_reset_sync == 1'b1) begin
      r_master_read      <= 1'b0;
      r_master_read_addr <= L_ALL_ZERO;
    end
    else if (w_read_ready == 1'b1 &&  r_lcc == 1'b1) begin
      // Load the decode data to an external mem or I/O device.
      r_master_read      <= 1'b1;
      r_master_read_addr <= w_master_addr;
    end
    else begin
      r_master_read <= 1'b0;
    end
  end
  assign o_master_read_addr = w_master_addr;
  assign o_master_read      = r_master_read;

  ///////////////////////////////////////////////////////////////////////////////
  // Process     : Write Process
  // Description : Registers the signals used to create a write interface
  //               transaction.
  ///////////////////////////////////////////////////////////////////////////////
  always@(posedge i_clk) begin
    if (i_reset_sync == 1'b1) begin
      r_master_write             <= 1'b0;
      r_master_write_addr        <= L_ALL_ZERO;
      r_master_write_data        <= L_ALL_ZERO;
      r_master_write_byte_enable <= 4'h0;
    end
    else if (w_write_ready == 1'b1 && r_scc == 1'b1) begin
      // Store (write) data in external memory or device.
      r_master_write             <= 1'b1;
      r_master_write_addr        <= w_master_addr;
      r_master_write_data        <= w_s_data;
      r_master_write_byte_enable <= w_fct3==0||w_fct3==4 ? ( 
                                      w_master_addr[1:0]==3 ? 4'b1000 : 
                                      w_master_addr[1:0]==2 ? 4'b0100 : 
                                      w_master_addr[1:0]==1 ? 4'b0010 : 
                                                              4'b0001 ) :
                                    w_fct3==1||w_fct3==5 ? ( 
                                      w_master_addr[1] == 1 ? 4'b1100 :
                                                              4'b0011 ) :
                                                              4'b1111;
    end
    else begin
      r_master_write <= 1'b0;
    end
  end
  assign o_master_write             = r_master_write;
  assign o_master_write_addr        = r_master_write_addr;
  assign o_master_write_data        = r_master_write_data;
  assign o_master_write_byte_enable = r_master_write_byte_enable;  

endmodule
