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
// Last modified : 2020/11/04 23:59:56
// Project Name  : ORCs
// Module Name   : ORC_R32I
// Description   : The ORC_R32I is a verilog implementation of the riscv32i
//                 architecture.
//
// Additional Comments:
//   This core was initially written using the prior work done on the DarkRISC
//   project as reference. For simulation use the make file in the sim directory.
//   for synthesis and building example use the scripts in the build directory. 
/////////////////////////////////////////////////////////////////////////////////
module ORC_R32I (
  input i_clk,        // clock
  input i_reset_sync, // reset
  // Instruction Data Interface
  output        o_inst_read,      // read enable
  input         i_inst_read_ack,  // acknowledge 
  output [31:0] o_inst_read_addr, // address
  input  [31:0] i_inst_read_data, // data
  // Master Read Interface
  output        o_master_read,      // read enable
  input         i_master_read_ack,  // acknowledge 
  output [31:0] o_master_read_addr, // address
  input  [31:0] i_master_read_data, // data
  // Master Write Interface
  output        o_master_write,            // write enable
  input         i_master_write_ack,        // acknowledge 
  output [31:0] o_master_write_addr,       // address
  output [31:0] o_master_write_data,       // data
  output [3:0]  o_master_write_byte_enable // byte enable
);
  ///////////////////////////////////////////////////////////////////////////////
  // Internal Parameter Declarations
  ///////////////////////////////////////////////////////////////////////////////
  // OpCodes 
  localparam [6:0] L_LUI   = 7'b0110111; // lui   imm[31:12], rd[11:7]
  localparam [6:0] L_AUIPC = 7'b0010111; // auipc imm[31:12], rd[11:7]
  localparam [6:0] L_JAL   = 7'b1101111; // jal   imm[20|10:1|11|19:12],rd[11:7]
  localparam [6:0] L_JALR  = 7'b1100111; // jalr  imm[11:0], rs1[19:15],000,rd[11:7]
  localparam [6:0] L_BCC   = 7'b1100011; // bcc   imm[12|10:5],rs2[24:20],rs1[19:15],funct[14:12],imm[4:1|11]
  localparam [6:0] L_LCC   = 7'b0000011; // lxx   imm[11:0],rs1[19:15],funct[14:12],rd[11:7]
  localparam [6:0] L_SCC   = 7'b0100011; // sxx   imm[11:5],rs2[24:20],rs1[19:15],funct[14:12],imm[4:0],
  localparam [6:0] L_MCC   = 7'b0010011; // xxxi  imm[11:0],[19:15],funct[14:12],rd[11:7]
  localparam [6:0] L_RCC   = 7'b0110011; // xxx   imm[6:0],rs2[24:20],rs1[19:15],funct[14:12],rd[11:7]
  // OpCodes not implemented
  //localparam [7:0] FCC = 7'b00011_11; // FENCE
  //localparam [7:0] CCC = 7'b11100_11; // ECALL, EBREAK, CSR
  // Misc Definitions
  localparam [31:0] L_ALL_ZERO   = 'b0;
  localparam [31:0] L_ALL_ONES   = 'b1;
  localparam        L_REG_LENGTH = 32;
  ///////////////////////////////////////////////////////////////////////////////
  // Internal Signals Declarations
  ///////////////////////////////////////////////////////////////////////////////
  // Decoder Signals
  wire [6:0]  w_opcode = i_inst_read_data[6:0];
  reg  [31:0] r_inst_data;
  reg  [31:0] r_simm;
  reg  [31:0] r_uimm;
  reg         r_lui;
  reg         r_auipc;
  reg         r_jal;
  reg         r_jalr;
  reg         r_bcc;
  reg         r_lcc;
  reg         r_scc;
  reg         r_mcc;
  reg         r_rcc;
  reg         r_decoder_valid;
  //, XFCC, XCCC;
  // Program Counter regs
  reg [31:0] r_next_program_counter2; // 32-bit program counter t+2
  reg [31:0] r_next_program_counter;  // 32-bit program counter t+1
  reg [31:0] r_program_counter;		    // 32-bit program counter t+0
  reg        r_program_counter_valid;
  // Registers regs
  reg [31:0] mem_registers1 [0:L_REG_LENGTH-1];	// general-purpose 32x32-bit registers
  reg [31:0] mem_registers2 [0:L_REG_LENGTH-1];	// general-purpose 32x32-bit registers
  // Instruction Fields wires
  wire [4:0] w_dest_pointer    = r_inst_data[11:7]; // set SP_RESET when i_reset_sync==1
  wire [4:0] w_source1_pointer = r_inst_data[19:15];
  wire [4:0] w_source2_pointer = r_inst_data[24:20];
  wire [2:0] w_fct3            = r_inst_data[14:12];
  wire [6:0] w_fct7            = r_inst_data[31:25];
  //wire    FCC = FLUSH ? 0 : XFCC; // w_opcode==7'b0001111; //w_fct3
  //wire    CCC = FLUSH ? 0 : XCCC; // w_opcode==7'b1110011; //w_fct3
  // source-1 and source-1 register selection
  wire signed [31:0] w_signed_rs1   = mem_registers1[w_source1_pointer];
  wire signed [31:0] w_signed_rs2   = mem_registers2[w_source2_pointer];
  wire        [31:0] w_unsigned_rs1 = mem_registers1[w_source1_pointer];
  wire        [31:0] w_unsigned_rs2 = mem_registers2[w_source2_pointer];
  // L-group of instructions (w_opcode==7'b0000011)
  wire [31:0] w_l_data = w_fct3==0||w_fct3==4 ? 
                           (r_master_read_addr[1:0]==3 ? { w_fct3==0&&i_master_read_data[31] ? L_ALL_ONES[31: 8]:L_ALL_ZERO[31: 8] , i_master_read_data[31:24] } :
                            r_master_read_addr[1:0]==2 ? { w_fct3==0&&i_master_read_data[23] ? L_ALL_ONES[31: 8]:L_ALL_ZERO[31: 8] , i_master_read_data[23:16] } :
                            r_master_read_addr[1:0]==1 ? { w_fct3==0&&i_master_read_data[15] ? L_ALL_ONES[31: 8]:L_ALL_ZERO[31: 8] , i_master_read_data[15: 8] } :
                              {w_fct3==0&&i_master_read_data[ 7] ? L_ALL_ONES[31: 8]:L_ALL_ZERO[31: 8] , i_master_read_data[ 7: 0]}):
                         w_fct3==1||w_fct3==5 ? ( r_master_read_addr[1]==1   ? { w_fct3==1&&i_master_read_data[31] ? L_ALL_ONES[31:16]:L_ALL_ZERO[31:16] , i_master_read_data[31:16] } :
                           {w_fct3==1&&i_master_read_data[15] ? L_ALL_ONES[31:16]:L_ALL_ZERO[31:16] , i_master_read_data[15: 0]}) :
                           i_master_read_data;
  // S-group of instructions (w_opcode==7'b0100011)
  wire [31:0] w_s_data = w_fct3==0 ? ( w_master_addr[1:0]==3 ? { w_unsigned_rs2[ 7: 0], L_ALL_ZERO [23:0] } : 
                                       w_master_addr[1:0]==2 ? { L_ALL_ZERO [31:24], w_unsigned_rs2[ 7:0], L_ALL_ZERO[15:0] } : 
                                       w_master_addr[1:0]==1 ? { L_ALL_ZERO [31:16], w_unsigned_rs2[ 7:0], L_ALL_ZERO[7:0] } :
                                                  { L_ALL_ZERO [31: 8], w_unsigned_rs2[ 7:0] } ) :
                         w_fct3==1 ? ( w_master_addr[1]  ==1 ? { w_unsigned_rs2[15: 0], L_ALL_ZERO [15:0] } :
                                                  { L_ALL_ZERO [31:16], w_unsigned_rs2[15:0] } ) :
                                  w_unsigned_rs2;
  // C-group not implemented yet!
  //wire [31:0] CDATA = 0;	// status register istructions not implemented yet
  // RM-group of instructions (OPCODEs==7'b0010011/7'b0110011), merged! src=immediate(M)/register(R)
  wire signed [31:0] w_signed_rs2_extended   = r_mcc ? r_simm : w_signed_rs2;
  wire        [31:0] w_unsigned_rs2_extended = r_mcc ? r_uimm : w_unsigned_rs2;
  wire        [31:0] w_rm_data = w_fct3==7 ? w_unsigned_rs1&w_signed_rs2_extended :
                                 w_fct3==6 ? w_unsigned_rs1|w_signed_rs2_extended :
                                 w_fct3==4 ? w_unsigned_rs1^w_signed_rs2_extended :
                                 w_fct3==3 ? w_unsigned_rs1<w_unsigned_rs2_extended?1:0 : // unsigned
                                 w_fct3==2 ? w_signed_rs1<w_signed_rs2_extended?1:0 :     // signed
                                 w_fct3==0 ? (r_rcc&&w_fct7[5] ? w_unsigned_rs1-w_unsigned_rs2_extended : w_unsigned_rs1+w_signed_rs2_extended) :
                                 w_fct3==1 ? w_unsigned_rs1<<w_unsigned_rs2_extended[4:0] :                         
                                 w_fct7[5] ? $signed(w_signed_rs1>>>w_unsigned_rs2_extended[4:0]) :                    
                                    w_unsigned_rs1>>w_unsigned_rs2_extended[4:0];
  // J/B-group of instructions (w_opcode==7'b1100011)
  wire w_bmux = r_bcc & (
                w_fct3==4 ? w_signed_rs1< w_signed_rs2 :     // blt
                w_fct3==5 ? w_signed_rs1>=w_signed_rs2 :     // bge
                w_fct3==6 ? w_unsigned_rs1< w_unsigned_rs2 : // bltu
                w_fct3==7 ? w_unsigned_rs1>=w_unsigned_rs2 : // bgeu
                w_fct3==0 ? w_unsigned_rs1==w_unsigned_rs2 : // beq
                w_fct3==1 ? w_unsigned_rs1!=w_unsigned_rs2 : // bne
                0);
  wire        w_jump_request = (r_jal|r_jalr|w_bmux);
  wire [31:0] w_jump_value   = r_simm + (r_jalr==1'b1 ? w_unsigned_rs1 : r_program_counter);
  // Memory Master Interface
  wire [31:0] w_master_addr  = (w_unsigned_rs1 + r_simm);
  reg         r_master_read;
  reg  [31:0] r_master_read_addr;
  reg         r_master_write;
  reg  [31:0] r_master_write_addr;
  reg  [31:0] r_master_write_data;
  reg  [3:0]  r_master_write_byte_enable;
  reg  [4:0]  r_dest_pointer;
  // Ready signals
  wire w_read_ready            = (!r_master_read & !i_master_read_ack) | i_master_read_ack;
  wire w_write_ready           = (!r_master_write & !i_master_write_ack) | i_master_write_ack;
  wire w_inst_addr_ready       = (!r_program_counter_valid & !i_inst_read_ack) | i_inst_read_ack;
  wire w_decoder_ready         = r_lcc ? w_read_ready : 1; // !w_jump_request & w_read_ready;
  wire w_program_counter_ready = (w_decoder_ready & i_inst_read_ack) | !r_program_counter_valid;

  ///////////////////////////////////////////////////////////////////////////////
  //            ********      Architecture Declaration      ********           //
  ///////////////////////////////////////////////////////////////////////////////
  
  ///////////////////////////////////////////////////////////////////////////////
  // Process     : Program Counter Process
  // Description : Updates the next program counter after the data instruction 
  //               is consumed.
  ///////////////////////////////////////////////////////////////////////////////
  always@(posedge i_clk) begin
    if (i_reset_sync == 1'b1) begin
      r_next_program_counter2 <= 'b0;
      r_next_program_counter  <= 'b0;
      r_program_counter       <= 'b0;
      r_program_counter_valid <= 1'b1;
    end
    else if (w_program_counter_ready == 1'b1 && w_inst_addr_ready == 1'b1) begin
      r_program_counter       <= r_next_program_counter; // current program counter
      r_next_program_counter  <= r_next_program_counter2;
	    r_next_program_counter2 <= w_jump_request ? w_jump_value : r_next_program_counter2+4;
      r_program_counter_valid <= 1'b1;
    end
    else if (w_inst_addr_ready == 1'b1) begin
      // When the interface instruction read interface is ready for the next
      // address but the program counter is yet to be updated.
      r_program_counter_valid <= 1'b0;
    end
  end
  assign o_inst_read_addr = r_next_program_counter2;
  assign o_inst_read      = r_program_counter_valid;

  ///////////////////////////////////////////////////////////////////////////////
  // Process     : Decoder Process
  // Description : Decodes and registers the instruction data.
  ///////////////////////////////////////////////////////////////////////////////
  always@(posedge i_clk) begin
    if (i_reset_sync == 1'b1) begin
      r_inst_data     <= 32'b0;
      r_lui           <= 1'b0;
      r_auipc         <= 1'b0;
      r_jal           <= 1'b0;
      r_jalr          <= 1'b0;
      r_bcc           <= 1'b0;
      r_lcc           <= 1'b0;
      r_scc           <= 1'b0;
      r_mcc           <= 1'b0;
      r_rcc           <= 1'b0;
      r_simm          <= 32'b0;
      r_uimm          <= 32'b0;
      r_decoder_valid <= 1'b0;
    end
    else if (w_decoder_ready == 1'b1 && i_inst_read_ack ==1'b1) begin
      // When the instruction read interface recevied with acknowledgement 
      // of the read operation an has valid data.
      r_inst_data <= i_inst_read_data;
      r_lui       <= w_opcode==L_LUI ? 1 : 0;
      r_auipc     <= w_opcode==L_AUIPC ? 1 : 0;
      r_jal       <= w_opcode==L_JAL ? 1 : 0;
      r_jalr      <= w_opcode==L_JALR ? 1 : 0;
      r_bcc       <= w_opcode==L_BCC ? 1 : 0;
      r_lcc       <= w_opcode==L_LCC ? 1 : 0;
      r_scc       <= w_opcode==L_SCC ? 1 : 0;
      r_mcc       <= w_opcode==L_MCC ? 1 : 0;
      r_rcc       <= w_opcode==L_RCC ? 1 : 0;
      case (w_opcode)
        L_AUIPC : begin
          r_simm <= { i_inst_read_data[31:12], L_ALL_ZERO[11:0] };
          r_uimm <= { i_inst_read_data[31:12], L_ALL_ZERO[11:0] };
        end
        L_SCC : begin
          r_simm <= { i_inst_read_data[31] ? L_ALL_ONES[31:12]:L_ALL_ZERO[31:12], i_inst_read_data[31:25], i_inst_read_data[11:7] };
          r_uimm <= { L_ALL_ZERO[31:12], i_inst_read_data[31:25],i_inst_read_data[11:7] };
        end
        L_LUI : begin
          r_simm <= { i_inst_read_data[31:12], L_ALL_ZERO[11:0] };
          r_uimm <= { i_inst_read_data[31:12], L_ALL_ZERO[11:0] };
        end
        L_BCC : begin
          r_simm <= { i_inst_read_data[31] ? L_ALL_ONES[31:13]:L_ALL_ZERO[31:13], i_inst_read_data[31],i_inst_read_data[7],i_inst_read_data[30:25],i_inst_read_data[11:8],L_ALL_ZERO[0] };
          r_uimm <= { L_ALL_ZERO[31:13], i_inst_read_data[31],i_inst_read_data[7],i_inst_read_data[30:25],i_inst_read_data[11:8],L_ALL_ZERO[0] };
        end
        L_JAL : begin
          r_simm <= { i_inst_read_data[31] ? L_ALL_ONES[31:21]:L_ALL_ZERO[31:21], i_inst_read_data[31], i_inst_read_data[19:12], i_inst_read_data[20], i_inst_read_data[30:21], L_ALL_ZERO[0] };
          r_uimm <= { L_ALL_ZERO[31:21], i_inst_read_data[31], i_inst_read_data[19:12], i_inst_read_data[20], i_inst_read_data[30:21], L_ALL_ZERO[0] };
        end
        default : begin
          r_simm <= { i_inst_read_data[31] ? L_ALL_ONES[31:12]:L_ALL_ZERO[31:12], i_inst_read_data[31:20] };
          r_uimm <= { L_ALL_ZERO[31:12], i_inst_read_data[31:20] };
        end
      endcase
      //
      r_decoder_valid <= 1'b1;
    end
    else begin // if (w_decoder_ready == 1'b0) begin
      // If Data not valid or if decoder not ready
      r_jal           <= 1'b0;
      r_jalr          <= 1'b0;
      r_bcc           <= 1'b0;
      r_decoder_valid <= 1'b0;
    end
  end

  ///////////////////////////////////////////////////////////////////////////////
  // Process     : General Purpose Registers Process
  // Description : Updates the contents of the general purpose registers.
  ///////////////////////////////////////////////////////////////////////////////
  always@(posedge i_clk) begin
    if (i_reset_sync == 1'b1) begin
      mem_registers1[w_dest_pointer] <= 'b0;
      mem_registers2[w_dest_pointer] <= 'b0;
    end
    else if (r_decoder_valid == 1'b1 && w_dest_pointer !== 4'b0) begin
      if (r_auipc == 1'b1) begin
        mem_registers1[w_dest_pointer] <= r_program_counter+r_simm;
        mem_registers2[w_dest_pointer] <= r_program_counter+r_simm;
      end
      if (r_jal == 1'b1) begin
        // Jump
        mem_registers1[w_dest_pointer] <= r_next_program_counter;
        mem_registers2[w_dest_pointer] <= r_next_program_counter;
      end
      if (r_jalr == 1'b1) begin
        // Jump
        mem_registers1[w_dest_pointer] <= r_next_program_counter;
        mem_registers2[w_dest_pointer] <= r_next_program_counter;
      end
      if (r_lui == 1'b1) begin
        // Load
        mem_registers1[w_dest_pointer] <= r_simm;
        mem_registers2[w_dest_pointer] <= r_simm;
      end
      if (r_mcc == 1'b1) begin
        mem_registers1[w_dest_pointer] <= w_rm_data;
        mem_registers2[w_dest_pointer] <= w_rm_data;
      end
      if (r_rcc == 1'b1) begin
        mem_registers1[w_dest_pointer] <= w_rm_data;
        mem_registers2[w_dest_pointer] <= w_rm_data;
      end
    end
    else if (r_master_read == 1'b1 && i_master_read_ack == 1'b1 && r_dest_pointer !== 4'b0) begin
      // Data loaded from memory.
      mem_registers1[r_dest_pointer] <= w_l_data;
      mem_registers2[r_dest_pointer] <= w_l_data;
    end
  end

  ///////////////////////////////////////////////////////////////////////////////
  // Process     : Read Process
  // Description : Registers the signals that create the read interface
  //               transaction.
  ///////////////////////////////////////////////////////////////////////////////
  always@(posedge i_clk) begin
    if (i_reset_sync == 1'b0) begin
      r_master_read      <= 1'b0;
      r_master_read_addr <= 32'b0;
      r_dest_pointer     <= 4'd1;
    end
    else if (w_read_ready == 1'b1) begin
      r_master_read      <= r_lcc;
      r_master_read_addr <= w_master_addr;
      r_dest_pointer     <= w_dest_pointer;
    end
  end
  assign o_master_read_addr = r_master_read_addr;
  assign o_master_read      = r_master_read;

  ///////////////////////////////////////////////////////////////////////////////
  // Process     : Write Process
  // Description : Registers the signals used to create a write interface
  //               transaction.
  ///////////////////////////////////////////////////////////////////////////////
  always@(posedge i_clk) begin
    if (i_reset_sync == 1'b0) begin
      r_master_write             <= 1'b0;
      r_master_write_addr        <= 32'b0;
      r_master_write_data        <= 32'b0;
      r_master_write_byte_enable <= 4'b0;
    end
    else if (w_write_ready == 1'b1) begin
      r_master_write             <= r_scc;
      r_master_write_addr        <= w_master_addr;
      r_master_write_data        <= w_s_data;
      r_master_write_byte_enable <= w_fct3==0||w_fct3==4 ? ( w_master_addr[1:0]==3 ? 4'b1000 : 
                                                             w_master_addr[1:0]==2 ? 4'b0100 : 
                                                             w_master_addr[1:0]==1 ? 4'b0010 : 
                                                                                     4'b0001 ) :
                                    w_fct3==1||w_fct3==5 ? ( w_master_addr[1] == 1 ? 4'b1100 :
                                                                                     4'b0011 ) : 
                                                                                     4'b1111;
    end
  end
  assign o_master_write             = r_master_write;
  assign o_master_write_addr        = r_master_write_addr;
  assign o_master_write_data        = r_master_write_data;
  assign o_master_write_byte_enable = r_master_write_byte_enable;  

endmodule 