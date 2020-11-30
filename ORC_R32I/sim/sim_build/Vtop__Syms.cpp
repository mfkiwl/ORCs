// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Symbol table implementation internals

#include "Vtop__Syms.h"
#include "Vtop.h"



// FUNCTIONS
Vtop__Syms::Vtop__Syms(Vtop* topp, const char* namep)
    // Setup locals
    : __Vm_namep(namep)
    , __Vm_activity(false)
    , __Vm_baseCode(0)
    , __Vm_didInit(false)
    // Setup submodule names
{
    // Pointer to top level
    TOPp = topp;
    // Setup each module's pointers to their submodules
    // Setup each module's pointer back to symbol table (for public functions)
    TOPp->__Vconfigure(this, true);
    // Setup scopes
    __Vscope_ORC_R32I.configure(this, name(), "ORC_R32I", "ORC_R32I", -12, VerilatedScope::SCOPE_MODULE);
    __Vscope_TOP.configure(this, name(), "TOP", "TOP", 0, VerilatedScope::SCOPE_OTHER);
    
    // Setup scope hierarchy
    __Vhier.add(0, &__Vscope_ORC_R32I);
    
    // Setup export functions
    for (int __Vfinal=0; __Vfinal<2; __Vfinal++) {
        __Vscope_ORC_R32I.varInsert(__Vfinal,"general_registers1", &(TOPp->ORC_R32I__DOT__general_registers1), false, VLVT_UINT32,VLVD_NODIR|VLVF_PUB_RW,2 ,31,0 ,31,0);
        __Vscope_ORC_R32I.varInsert(__Vfinal,"general_registers2", &(TOPp->ORC_R32I__DOT__general_registers2), false, VLVT_UINT32,VLVD_NODIR|VLVF_PUB_RW,2 ,31,0 ,31,0);
        __Vscope_ORC_R32I.varInsert(__Vfinal,"i_clk", &(TOPp->ORC_R32I__DOT__i_clk), false, VLVT_UINT8,VLVD_NODIR|VLVF_PUB_RW,0);
        __Vscope_ORC_R32I.varInsert(__Vfinal,"i_inst_read_ack", &(TOPp->ORC_R32I__DOT__i_inst_read_ack), false, VLVT_UINT8,VLVD_NODIR|VLVF_PUB_RW,0);
        __Vscope_ORC_R32I.varInsert(__Vfinal,"i_inst_read_data", &(TOPp->ORC_R32I__DOT__i_inst_read_data), false, VLVT_UINT32,VLVD_NODIR|VLVF_PUB_RW,1 ,31,0);
        __Vscope_ORC_R32I.varInsert(__Vfinal,"i_master_read_ack", &(TOPp->ORC_R32I__DOT__i_master_read_ack), false, VLVT_UINT8,VLVD_NODIR|VLVF_PUB_RW,0);
        __Vscope_ORC_R32I.varInsert(__Vfinal,"i_master_read_data", &(TOPp->ORC_R32I__DOT__i_master_read_data), false, VLVT_UINT32,VLVD_NODIR|VLVF_PUB_RW,1 ,31,0);
        __Vscope_ORC_R32I.varInsert(__Vfinal,"i_master_write_ack", &(TOPp->ORC_R32I__DOT__i_master_write_ack), false, VLVT_UINT8,VLVD_NODIR|VLVF_PUB_RW,0);
        __Vscope_ORC_R32I.varInsert(__Vfinal,"i_reset_sync", &(TOPp->ORC_R32I__DOT__i_reset_sync), false, VLVT_UINT8,VLVD_NODIR|VLVF_PUB_RW,0);
        __Vscope_ORC_R32I.varInsert(__Vfinal,"o_inst_read", &(TOPp->ORC_R32I__DOT__o_inst_read), false, VLVT_UINT8,VLVD_NODIR|VLVF_PUB_RW,0);
        __Vscope_ORC_R32I.varInsert(__Vfinal,"o_inst_read_addr", &(TOPp->ORC_R32I__DOT__o_inst_read_addr), false, VLVT_UINT32,VLVD_NODIR|VLVF_PUB_RW,1 ,31,0);
        __Vscope_ORC_R32I.varInsert(__Vfinal,"o_master_read", &(TOPp->ORC_R32I__DOT__o_master_read), false, VLVT_UINT8,VLVD_NODIR|VLVF_PUB_RW,0);
        __Vscope_ORC_R32I.varInsert(__Vfinal,"o_master_read_addr", &(TOPp->ORC_R32I__DOT__o_master_read_addr), false, VLVT_UINT32,VLVD_NODIR|VLVF_PUB_RW,1 ,31,0);
        __Vscope_ORC_R32I.varInsert(__Vfinal,"o_master_write", &(TOPp->ORC_R32I__DOT__o_master_write), false, VLVT_UINT8,VLVD_NODIR|VLVF_PUB_RW,0);
        __Vscope_ORC_R32I.varInsert(__Vfinal,"o_master_write_addr", &(TOPp->ORC_R32I__DOT__o_master_write_addr), false, VLVT_UINT32,VLVD_NODIR|VLVF_PUB_RW,1 ,31,0);
        __Vscope_ORC_R32I.varInsert(__Vfinal,"o_master_write_byte_enable", &(TOPp->ORC_R32I__DOT__o_master_write_byte_enable), false, VLVT_UINT8,VLVD_NODIR|VLVF_PUB_RW,1 ,3,0);
        __Vscope_ORC_R32I.varInsert(__Vfinal,"o_master_write_data", &(TOPp->ORC_R32I__DOT__o_master_write_data), false, VLVT_UINT32,VLVD_NODIR|VLVF_PUB_RW,1 ,31,0);
        __Vscope_ORC_R32I.varInsert(__Vfinal,"r_bcc", &(TOPp->ORC_R32I__DOT__r_bcc), false, VLVT_UINT8,VLVD_NODIR|VLVF_PUB_RW,0);
        __Vscope_ORC_R32I.varInsert(__Vfinal,"r_inst_data", &(TOPp->ORC_R32I__DOT__r_inst_data), false, VLVT_UINT32,VLVD_NODIR|VLVF_PUB_RW,1 ,31,0);
        __Vscope_ORC_R32I.varInsert(__Vfinal,"r_inst_read_ack", &(TOPp->ORC_R32I__DOT__r_inst_read_ack), false, VLVT_UINT8,VLVD_NODIR|VLVF_PUB_RW,0);
        __Vscope_ORC_R32I.varInsert(__Vfinal,"r_jalr", &(TOPp->ORC_R32I__DOT__r_jalr), false, VLVT_UINT8,VLVD_NODIR|VLVF_PUB_RW,0);
        __Vscope_ORC_R32I.varInsert(__Vfinal,"r_lcc", &(TOPp->ORC_R32I__DOT__r_lcc), false, VLVT_UINT8,VLVD_NODIR|VLVF_PUB_RW,0);
        __Vscope_ORC_R32I.varInsert(__Vfinal,"r_master_read_addr", &(TOPp->ORC_R32I__DOT__r_master_read_addr), false, VLVT_UINT32,VLVD_NODIR|VLVF_PUB_RW,1 ,31,0);
        __Vscope_ORC_R32I.varInsert(__Vfinal,"r_next_pc_decode", &(TOPp->ORC_R32I__DOT__r_next_pc_decode), false, VLVT_UINT32,VLVD_NODIR|VLVF_PUB_RW,1 ,31,0);
        __Vscope_ORC_R32I.varInsert(__Vfinal,"r_next_pc_fetch", &(TOPp->ORC_R32I__DOT__r_next_pc_fetch), false, VLVT_UINT32,VLVD_NODIR|VLVF_PUB_RW,1 ,31,0);
        __Vscope_ORC_R32I.varInsert(__Vfinal,"r_pc", &(TOPp->ORC_R32I__DOT__r_pc), false, VLVT_UINT32,VLVD_NODIR|VLVF_PUB_RW,1 ,31,0);
        __Vscope_ORC_R32I.varInsert(__Vfinal,"r_program_counter_valid", &(TOPp->ORC_R32I__DOT__r_program_counter_valid), false, VLVT_UINT8,VLVD_NODIR|VLVF_PUB_RW,0);
        __Vscope_ORC_R32I.varInsert(__Vfinal,"r_read_ready", &(TOPp->ORC_R32I__DOT__r_read_ready), false, VLVT_UINT8,VLVD_NODIR|VLVF_PUB_RW,0);
        __Vscope_ORC_R32I.varInsert(__Vfinal,"r_rii", &(TOPp->ORC_R32I__DOT__r_rii), false, VLVT_UINT8,VLVD_NODIR|VLVF_PUB_RW,0);
        __Vscope_ORC_R32I.varInsert(__Vfinal,"r_rro", &(TOPp->ORC_R32I__DOT__r_rro), false, VLVT_UINT8,VLVD_NODIR|VLVF_PUB_RW,0);
        __Vscope_ORC_R32I.varInsert(__Vfinal,"r_scc", &(TOPp->ORC_R32I__DOT__r_scc), false, VLVT_UINT8,VLVD_NODIR|VLVF_PUB_RW,0);
        __Vscope_ORC_R32I.varInsert(__Vfinal,"r_simm", &(TOPp->ORC_R32I__DOT__r_simm), false, VLVT_UINT32,VLVD_NODIR|VLVF_PUB_RW,1 ,31,0);
        __Vscope_ORC_R32I.varInsert(__Vfinal,"r_uimm", &(TOPp->ORC_R32I__DOT__r_uimm), false, VLVT_UINT32,VLVD_NODIR|VLVF_PUB_RW,1 ,31,0);
        __Vscope_ORC_R32I.varInsert(__Vfinal,"r_unsigned_rs1", &(TOPp->ORC_R32I__DOT__r_unsigned_rs1), false, VLVT_UINT32,VLVD_NODIR|VLVF_PUB_RW,1 ,31,0);
        __Vscope_ORC_R32I.varInsert(__Vfinal,"r_unsigned_rs2", &(TOPp->ORC_R32I__DOT__r_unsigned_rs2), false, VLVT_UINT32,VLVD_NODIR|VLVF_PUB_RW,1 ,31,0);
        __Vscope_ORC_R32I.varInsert(__Vfinal,"r_write_ready", &(TOPp->ORC_R32I__DOT__r_write_ready), false, VLVT_UINT8,VLVD_NODIR|VLVF_PUB_RW,0);
        __Vscope_ORC_R32I.varInsert(__Vfinal,"reset_index", &(TOPp->ORC_R32I__DOT__reset_index), false, VLVT_UINT8,VLVD_NODIR|VLVF_PUB_RW,1 ,4,0);
        __Vscope_ORC_R32I.varInsert(__Vfinal,"w_auipc", &(TOPp->ORC_R32I__DOT__w_auipc), false, VLVT_UINT8,VLVD_NODIR|VLVF_PUB_RW,0);
        __Vscope_ORC_R32I.varInsert(__Vfinal,"w_bmux", &(TOPp->ORC_R32I__DOT__w_bmux), false, VLVT_UINT8,VLVD_NODIR|VLVF_PUB_RW,0);
        __Vscope_ORC_R32I.varInsert(__Vfinal,"w_decoder_opcode", &(TOPp->ORC_R32I__DOT__w_decoder_opcode), false, VLVT_UINT8,VLVD_NODIR|VLVF_PUB_RW,0);
        __Vscope_ORC_R32I.varInsert(__Vfinal,"w_decoder_ready", &(TOPp->ORC_R32I__DOT__w_decoder_ready), false, VLVT_UINT8,VLVD_NODIR|VLVF_PUB_RW,0);
        __Vscope_ORC_R32I.varInsert(__Vfinal,"w_decoder_valid", &(TOPp->ORC_R32I__DOT__w_decoder_valid), false, VLVT_UINT8,VLVD_NODIR|VLVF_PUB_RW,0);
        __Vscope_ORC_R32I.varInsert(__Vfinal,"w_destination_index", &(TOPp->ORC_R32I__DOT__w_destination_index), false, VLVT_UINT8,VLVD_NODIR|VLVF_PUB_RW,1 ,4,0);
        __Vscope_ORC_R32I.varInsert(__Vfinal,"w_destination_index_not_zero", &(TOPp->ORC_R32I__DOT__w_destination_index_not_zero), false, VLVT_UINT8,VLVD_NODIR|VLVF_PUB_RW,0);
        __Vscope_ORC_R32I.varInsert(__Vfinal,"w_fct3", &(TOPp->ORC_R32I__DOT__w_fct3), false, VLVT_UINT8,VLVD_NODIR|VLVF_PUB_RW,1 ,2,0);
        __Vscope_ORC_R32I.varInsert(__Vfinal,"w_fct7", &(TOPp->ORC_R32I__DOT__w_fct7), false, VLVT_UINT8,VLVD_NODIR|VLVF_PUB_RW,1 ,6,0);
        __Vscope_ORC_R32I.varInsert(__Vfinal,"w_j_simm", &(TOPp->ORC_R32I__DOT__w_j_simm), false, VLVT_UINT32,VLVD_NODIR|VLVF_PUB_RW,1 ,31,0);
        __Vscope_ORC_R32I.varInsert(__Vfinal,"w_jal", &(TOPp->ORC_R32I__DOT__w_jal), false, VLVT_UINT8,VLVD_NODIR|VLVF_PUB_RW,0);
        __Vscope_ORC_R32I.varInsert(__Vfinal,"w_jump_request", &(TOPp->ORC_R32I__DOT__w_jump_request), false, VLVT_UINT8,VLVD_NODIR|VLVF_PUB_RW,0);
        __Vscope_ORC_R32I.varInsert(__Vfinal,"w_jump_value", &(TOPp->ORC_R32I__DOT__w_jump_value), false, VLVT_UINT32,VLVD_NODIR|VLVF_PUB_RW,1 ,31,0);
        __Vscope_ORC_R32I.varInsert(__Vfinal,"w_l_data", &(TOPp->ORC_R32I__DOT__w_l_data), false, VLVT_UINT32,VLVD_NODIR|VLVF_PUB_RW,1 ,31,0);
        __Vscope_ORC_R32I.varInsert(__Vfinal,"w_lui", &(TOPp->ORC_R32I__DOT__w_lui), false, VLVT_UINT8,VLVD_NODIR|VLVF_PUB_RW,0);
        __Vscope_ORC_R32I.varInsert(__Vfinal,"w_master_addr", &(TOPp->ORC_R32I__DOT__w_master_addr), false, VLVT_UINT32,VLVD_NODIR|VLVF_PUB_RW,1 ,31,0);
        __Vscope_ORC_R32I.varInsert(__Vfinal,"w_opcode", &(TOPp->ORC_R32I__DOT__w_opcode), false, VLVT_UINT8,VLVD_NODIR|VLVF_PUB_RW,1 ,6,0);
        __Vscope_ORC_R32I.varInsert(__Vfinal,"w_pc_opcode", &(TOPp->ORC_R32I__DOT__w_pc_opcode), false, VLVT_UINT8,VLVD_NODIR|VLVF_PUB_RW,1 ,6,0);
        __Vscope_ORC_R32I.varInsert(__Vfinal,"w_program_counter_ready", &(TOPp->ORC_R32I__DOT__w_program_counter_ready), false, VLVT_UINT8,VLVD_NODIR|VLVF_PUB_RW,0);
        __Vscope_ORC_R32I.varInsert(__Vfinal,"w_rd", &(TOPp->ORC_R32I__DOT__w_rd), false, VLVT_UINT8,VLVD_NODIR|VLVF_PUB_RW,1 ,4,0);
        __Vscope_ORC_R32I.varInsert(__Vfinal,"w_rd_not_zero", &(TOPp->ORC_R32I__DOT__w_rd_not_zero), false, VLVT_UINT8,VLVD_NODIR|VLVF_PUB_RW,0);
        __Vscope_ORC_R32I.varInsert(__Vfinal,"w_rm_data", &(TOPp->ORC_R32I__DOT__w_rm_data), false, VLVT_UINT32,VLVD_NODIR|VLVF_PUB_RW,1 ,31,0);
        __Vscope_ORC_R32I.varInsert(__Vfinal,"w_s_data", &(TOPp->ORC_R32I__DOT__w_s_data), false, VLVT_UINT32,VLVD_NODIR|VLVF_PUB_RW,1 ,31,0);
        __Vscope_ORC_R32I.varInsert(__Vfinal,"w_signed_rs1", &(TOPp->ORC_R32I__DOT__w_signed_rs1), false, VLVT_UINT32,VLVD_NODIR|VLVF_PUB_RW,1 ,31,0);
        __Vscope_ORC_R32I.varInsert(__Vfinal,"w_signed_rs2", &(TOPp->ORC_R32I__DOT__w_signed_rs2), false, VLVT_UINT32,VLVD_NODIR|VLVF_PUB_RW,1 ,31,0);
        __Vscope_ORC_R32I.varInsert(__Vfinal,"w_signed_rs2_extended", &(TOPp->ORC_R32I__DOT__w_signed_rs2_extended), false, VLVT_UINT32,VLVD_NODIR|VLVF_PUB_RW,1 ,31,0);
        __Vscope_ORC_R32I.varInsert(__Vfinal,"w_source1_pointer", &(TOPp->ORC_R32I__DOT__w_source1_pointer), false, VLVT_UINT8,VLVD_NODIR|VLVF_PUB_RW,1 ,4,0);
        __Vscope_ORC_R32I.varInsert(__Vfinal,"w_source2_pointer", &(TOPp->ORC_R32I__DOT__w_source2_pointer), false, VLVT_UINT8,VLVD_NODIR|VLVF_PUB_RW,1 ,4,0);
        __Vscope_ORC_R32I.varInsert(__Vfinal,"w_unsigned_rs2_extended", &(TOPp->ORC_R32I__DOT__w_unsigned_rs2_extended), false, VLVT_UINT32,VLVD_NODIR|VLVF_PUB_RW,1 ,31,0);
        __Vscope_TOP.varInsert(__Vfinal,"i_clk", &(TOPp->i_clk), false, VLVT_UINT8,VLVD_IN|VLVF_PUB_RW,0);
        __Vscope_TOP.varInsert(__Vfinal,"i_inst_read_ack", &(TOPp->i_inst_read_ack), false, VLVT_UINT8,VLVD_IN|VLVF_PUB_RW,0);
        __Vscope_TOP.varInsert(__Vfinal,"i_inst_read_data", &(TOPp->i_inst_read_data), false, VLVT_UINT32,VLVD_IN|VLVF_PUB_RW,1 ,31,0);
        __Vscope_TOP.varInsert(__Vfinal,"i_master_read_ack", &(TOPp->i_master_read_ack), false, VLVT_UINT8,VLVD_IN|VLVF_PUB_RW,0);
        __Vscope_TOP.varInsert(__Vfinal,"i_master_read_data", &(TOPp->i_master_read_data), false, VLVT_UINT32,VLVD_IN|VLVF_PUB_RW,1 ,31,0);
        __Vscope_TOP.varInsert(__Vfinal,"i_master_write_ack", &(TOPp->i_master_write_ack), false, VLVT_UINT8,VLVD_IN|VLVF_PUB_RW,0);
        __Vscope_TOP.varInsert(__Vfinal,"i_reset_sync", &(TOPp->i_reset_sync), false, VLVT_UINT8,VLVD_IN|VLVF_PUB_RW,0);
        __Vscope_TOP.varInsert(__Vfinal,"o_inst_read", &(TOPp->o_inst_read), false, VLVT_UINT8,VLVD_OUT|VLVF_PUB_RW,0);
        __Vscope_TOP.varInsert(__Vfinal,"o_inst_read_addr", &(TOPp->o_inst_read_addr), false, VLVT_UINT32,VLVD_OUT|VLVF_PUB_RW,1 ,31,0);
        __Vscope_TOP.varInsert(__Vfinal,"o_master_read", &(TOPp->o_master_read), false, VLVT_UINT8,VLVD_OUT|VLVF_PUB_RW,0);
        __Vscope_TOP.varInsert(__Vfinal,"o_master_read_addr", &(TOPp->o_master_read_addr), false, VLVT_UINT32,VLVD_OUT|VLVF_PUB_RW,1 ,31,0);
        __Vscope_TOP.varInsert(__Vfinal,"o_master_write", &(TOPp->o_master_write), false, VLVT_UINT8,VLVD_OUT|VLVF_PUB_RW,0);
        __Vscope_TOP.varInsert(__Vfinal,"o_master_write_addr", &(TOPp->o_master_write_addr), false, VLVT_UINT32,VLVD_OUT|VLVF_PUB_RW,1 ,31,0);
        __Vscope_TOP.varInsert(__Vfinal,"o_master_write_byte_enable", &(TOPp->o_master_write_byte_enable), false, VLVT_UINT8,VLVD_OUT|VLVF_PUB_RW,1 ,3,0);
        __Vscope_TOP.varInsert(__Vfinal,"o_master_write_data", &(TOPp->o_master_write_data), false, VLVT_UINT32,VLVD_OUT|VLVF_PUB_RW,1 ,31,0);
    }
}
