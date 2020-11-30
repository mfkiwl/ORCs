// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Tracing implementation internals
#include "verilated_vcd_c.h"
#include "Vtop__Syms.h"


//======================

void Vtop::trace(VerilatedVcdC* tfp, int, int) {
    tfp->spTrace()->addInitCb(&traceInit, __VlSymsp);
    traceRegister(tfp->spTrace());
}

void Vtop::traceInit(void* userp, VerilatedVcd* tracep, uint32_t code) {
    // Callback from tracep->open()
    Vtop__Syms* __restrict vlSymsp = static_cast<Vtop__Syms*>(userp);
    if (!Verilated::calcUnusedSigs()) {
        VL_FATAL_MT(__FILE__, __LINE__, __FILE__,
                        "Turning on wave traces requires Verilated::traceEverOn(true) call before time 0.");
    }
    vlSymsp->__Vm_baseCode = code;
    tracep->module(vlSymsp->name());
    tracep->scopeEscape(' ');
    Vtop::traceInitTop(vlSymsp, tracep);
    tracep->scopeEscape('.');
}

//======================


void Vtop::traceInitTop(void* userp, VerilatedVcd* tracep) {
    Vtop__Syms* __restrict vlSymsp = static_cast<Vtop__Syms*>(userp);
    Vtop* const __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    // Body
    {
        vlTOPp->traceInitSub0(userp, tracep);
    }
}

void Vtop::traceInitSub0(void* userp, VerilatedVcd* tracep) {
    Vtop__Syms* __restrict vlSymsp = static_cast<Vtop__Syms*>(userp);
    Vtop* const __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    const int c = vlSymsp->__Vm_baseCode;
    if (false && tracep && c) {}  // Prevent unused
    // Body
    {
        tracep->declBit(c+1,"i_clk", false,-1);
        tracep->declBit(c+2,"i_reset_sync", false,-1);
        tracep->declBit(c+3,"o_inst_read", false,-1);
        tracep->declBit(c+4,"i_inst_read_ack", false,-1);
        tracep->declBus(c+5,"o_inst_read_addr", false,-1, 31,0);
        tracep->declBus(c+6,"i_inst_read_data", false,-1, 31,0);
        tracep->declBit(c+7,"o_master_read", false,-1);
        tracep->declBit(c+8,"i_master_read_ack", false,-1);
        tracep->declBus(c+9,"o_master_read_addr", false,-1, 31,0);
        tracep->declBus(c+10,"i_master_read_data", false,-1, 31,0);
        tracep->declBit(c+11,"o_master_write", false,-1);
        tracep->declBit(c+12,"i_master_write_ack", false,-1);
        tracep->declBus(c+13,"o_master_write_addr", false,-1, 31,0);
        tracep->declBus(c+14,"o_master_write_data", false,-1, 31,0);
        tracep->declBus(c+15,"o_master_write_byte_enable", false,-1, 3,0);
        tracep->declBus(c+144,"ORC_R32I P_FETCH_COUNTER_RESET", false,-1, 31,0);
        tracep->declBit(c+16,"ORC_R32I i_clk", false,-1);
        tracep->declBit(c+17,"ORC_R32I i_reset_sync", false,-1);
        tracep->declBit(c+18,"ORC_R32I o_inst_read", false,-1);
        tracep->declBit(c+19,"ORC_R32I i_inst_read_ack", false,-1);
        tracep->declBus(c+20,"ORC_R32I o_inst_read_addr", false,-1, 31,0);
        tracep->declBus(c+21,"ORC_R32I i_inst_read_data", false,-1, 31,0);
        tracep->declBit(c+22,"ORC_R32I o_master_read", false,-1);
        tracep->declBit(c+23,"ORC_R32I i_master_read_ack", false,-1);
        tracep->declBus(c+24,"ORC_R32I o_master_read_addr", false,-1, 31,0);
        tracep->declBus(c+25,"ORC_R32I i_master_read_data", false,-1, 31,0);
        tracep->declBit(c+26,"ORC_R32I o_master_write", false,-1);
        tracep->declBit(c+27,"ORC_R32I i_master_write_ack", false,-1);
        tracep->declBus(c+28,"ORC_R32I o_master_write_addr", false,-1, 31,0);
        tracep->declBus(c+29,"ORC_R32I o_master_write_data", false,-1, 31,0);
        tracep->declBus(c+30,"ORC_R32I o_master_write_byte_enable", false,-1, 3,0);
        tracep->declBus(c+145,"ORC_R32I L_RII", false,-1, 6,0);
        tracep->declBus(c+146,"ORC_R32I L_RRO", false,-1, 6,0);
        tracep->declBus(c+147,"ORC_R32I L_LUI", false,-1, 6,0);
        tracep->declBus(c+148,"ORC_R32I L_AUIPC", false,-1, 6,0);
        tracep->declBus(c+149,"ORC_R32I L_JAL", false,-1, 6,0);
        tracep->declBus(c+150,"ORC_R32I L_JALR", false,-1, 6,0);
        tracep->declBus(c+151,"ORC_R32I L_BCC", false,-1, 6,0);
        tracep->declBus(c+152,"ORC_R32I L_LCC", false,-1, 6,0);
        tracep->declBus(c+153,"ORC_R32I L_SCC", false,-1, 6,0);
        tracep->declBus(c+144,"ORC_R32I L_ALL_ZERO", false,-1, 31,0);
        tracep->declBus(c+154,"ORC_R32I L_ALL_ONES", false,-1, 31,0);
        tracep->declBus(c+31,"ORC_R32I r_next_pc_fetch", false,-1, 31,0);
        tracep->declBus(c+32,"ORC_R32I r_next_pc_decode", false,-1, 31,0);
        tracep->declBus(c+33,"ORC_R32I r_pc", false,-1, 31,0);
        tracep->declBit(c+34,"ORC_R32I r_program_counter_valid", false,-1);
        tracep->declBit(c+35,"ORC_R32I r_inst_read_ack", false,-1);
        tracep->declBus(c+36,"ORC_R32I r_inst_data", false,-1, 31,0);
        tracep->declBus(c+37,"ORC_R32I w_opcode", false,-1, 6,0);
        tracep->declBus(c+38,"ORC_R32I w_pc_opcode", false,-1, 6,0);
        tracep->declBus(c+39,"ORC_R32I r_simm", false,-1, 31,0);
        tracep->declBus(c+40,"ORC_R32I r_uimm", false,-1, 31,0);
        tracep->declBit(c+41,"ORC_R32I r_jalr", false,-1);
        tracep->declBit(c+42,"ORC_R32I r_bcc", false,-1);
        tracep->declBit(c+43,"ORC_R32I r_lcc", false,-1);
        tracep->declBit(c+44,"ORC_R32I r_scc", false,-1);
        tracep->declBit(c+45,"ORC_R32I r_rii", false,-1);
        tracep->declBit(c+46,"ORC_R32I r_rro", false,-1);
        {int i; for (i=0; i<32; i++) {
                tracep->declBus(c+47+i*1,"ORC_R32I general_registers1", true,(i+0), 31,0);}}
        {int i; for (i=0; i<32; i++) {
                tracep->declBus(c+79+i*1,"ORC_R32I general_registers2", true,(i+0), 31,0);}}
        tracep->declBus(c+111,"ORC_R32I reset_index", false,-1, 4,0);
        tracep->declBit(c+112,"ORC_R32I r_read_ready", false,-1);
        tracep->declBit(c+113,"ORC_R32I r_write_ready", false,-1);
        tracep->declBus(c+114,"ORC_R32I r_master_read_addr", false,-1, 31,0);
        tracep->declBus(c+115,"ORC_R32I w_rd", false,-1, 4,0);
        tracep->declBus(c+116,"ORC_R32I w_destination_index", false,-1, 4,0);
        tracep->declBus(c+117,"ORC_R32I w_source1_pointer", false,-1, 4,0);
        tracep->declBus(c+118,"ORC_R32I w_source2_pointer", false,-1, 4,0);
        tracep->declBus(c+119,"ORC_R32I w_fct3", false,-1, 2,0);
        tracep->declBus(c+120,"ORC_R32I w_fct7", false,-1, 6,0);
        tracep->declBus(c+121,"ORC_R32I r_unsigned_rs1", false,-1, 31,0);
        tracep->declBus(c+122,"ORC_R32I r_unsigned_rs2", false,-1, 31,0);
        tracep->declBus(c+123,"ORC_R32I w_signed_rs1", false,-1, 31,0);
        tracep->declBus(c+124,"ORC_R32I w_signed_rs2", false,-1, 31,0);
        tracep->declBus(c+125,"ORC_R32I w_master_addr", false,-1, 31,0);
        tracep->declBus(c+126,"ORC_R32I w_l_data", false,-1, 31,0);
        tracep->declBus(c+127,"ORC_R32I w_s_data", false,-1, 31,0);
        tracep->declBus(c+128,"ORC_R32I w_signed_rs2_extended", false,-1, 31,0);
        tracep->declBus(c+129,"ORC_R32I w_unsigned_rs2_extended", false,-1, 31,0);
        tracep->declBus(c+130,"ORC_R32I w_rm_data", false,-1, 31,0);
        tracep->declBit(c+131,"ORC_R32I w_jal", false,-1);
        tracep->declBus(c+132,"ORC_R32I w_j_simm", false,-1, 31,0);
        tracep->declBit(c+133,"ORC_R32I w_bmux", false,-1);
        tracep->declBit(c+134,"ORC_R32I w_jump_request", false,-1);
        tracep->declBus(c+135,"ORC_R32I w_jump_value", false,-1, 31,0);
        tracep->declBit(c+136,"ORC_R32I w_rd_not_zero", false,-1);
        tracep->declBit(c+137,"ORC_R32I w_destination_index_not_zero", false,-1);
        tracep->declBit(c+138,"ORC_R32I w_decoder_valid", false,-1);
        tracep->declBit(c+139,"ORC_R32I w_decoder_ready", false,-1);
        tracep->declBit(c+140,"ORC_R32I w_decoder_opcode", false,-1);
        tracep->declBit(c+141,"ORC_R32I w_program_counter_ready", false,-1);
        tracep->declBit(c+142,"ORC_R32I w_lui", false,-1);
        tracep->declBit(c+143,"ORC_R32I w_auipc", false,-1);
    }
}

void Vtop::traceRegister(VerilatedVcd* tracep) {
    // Body
    {
        tracep->addFullCb(&traceFullTop0, __VlSymsp);
        tracep->addChgCb(&traceChgTop0, __VlSymsp);
        tracep->addCleanupCb(&traceCleanup, __VlSymsp);
    }
}

void Vtop::traceFullTop0(void* userp, VerilatedVcd* tracep) {
    Vtop__Syms* __restrict vlSymsp = static_cast<Vtop__Syms*>(userp);
    Vtop* const __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    // Body
    {
        vlTOPp->traceFullSub0(userp, tracep);
    }
}

void Vtop::traceFullSub0(void* userp, VerilatedVcd* tracep) {
    Vtop__Syms* __restrict vlSymsp = static_cast<Vtop__Syms*>(userp);
    Vtop* const __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    vluint32_t* const oldp = tracep->oldp(vlSymsp->__Vm_baseCode);
    if (false && oldp) {}  // Prevent unused
    // Body
    {
        tracep->fullBit(oldp+1,(vlTOPp->i_clk));
        tracep->fullBit(oldp+2,(vlTOPp->i_reset_sync));
        tracep->fullBit(oldp+3,(vlTOPp->o_inst_read));
        tracep->fullBit(oldp+4,(vlTOPp->i_inst_read_ack));
        tracep->fullIData(oldp+5,(vlTOPp->o_inst_read_addr),32);
        tracep->fullIData(oldp+6,(vlTOPp->i_inst_read_data),32);
        tracep->fullBit(oldp+7,(vlTOPp->o_master_read));
        tracep->fullBit(oldp+8,(vlTOPp->i_master_read_ack));
        tracep->fullIData(oldp+9,(vlTOPp->o_master_read_addr),32);
        tracep->fullIData(oldp+10,(vlTOPp->i_master_read_data),32);
        tracep->fullBit(oldp+11,(vlTOPp->o_master_write));
        tracep->fullBit(oldp+12,(vlTOPp->i_master_write_ack));
        tracep->fullIData(oldp+13,(vlTOPp->o_master_write_addr),32);
        tracep->fullIData(oldp+14,(vlTOPp->o_master_write_data),32);
        tracep->fullCData(oldp+15,(vlTOPp->o_master_write_byte_enable),4);
        tracep->fullBit(oldp+16,(vlTOPp->ORC_R32I__DOT__i_clk));
        tracep->fullBit(oldp+17,(vlTOPp->ORC_R32I__DOT__i_reset_sync));
        tracep->fullBit(oldp+18,(vlTOPp->ORC_R32I__DOT__o_inst_read));
        tracep->fullBit(oldp+19,(vlTOPp->ORC_R32I__DOT__i_inst_read_ack));
        tracep->fullIData(oldp+20,(vlTOPp->ORC_R32I__DOT__o_inst_read_addr),32);
        tracep->fullIData(oldp+21,(vlTOPp->ORC_R32I__DOT__i_inst_read_data),32);
        tracep->fullBit(oldp+22,(vlTOPp->ORC_R32I__DOT__o_master_read));
        tracep->fullBit(oldp+23,(vlTOPp->ORC_R32I__DOT__i_master_read_ack));
        tracep->fullIData(oldp+24,(vlTOPp->ORC_R32I__DOT__o_master_read_addr),32);
        tracep->fullIData(oldp+25,(vlTOPp->ORC_R32I__DOT__i_master_read_data),32);
        tracep->fullBit(oldp+26,(vlTOPp->ORC_R32I__DOT__o_master_write));
        tracep->fullBit(oldp+27,(vlTOPp->ORC_R32I__DOT__i_master_write_ack));
        tracep->fullIData(oldp+28,(vlTOPp->ORC_R32I__DOT__o_master_write_addr),32);
        tracep->fullIData(oldp+29,(vlTOPp->ORC_R32I__DOT__o_master_write_data),32);
        tracep->fullCData(oldp+30,(vlTOPp->ORC_R32I__DOT__o_master_write_byte_enable),4);
        tracep->fullIData(oldp+31,(vlTOPp->ORC_R32I__DOT__r_next_pc_fetch),32);
        tracep->fullIData(oldp+32,(vlTOPp->ORC_R32I__DOT__r_next_pc_decode),32);
        tracep->fullIData(oldp+33,(vlTOPp->ORC_R32I__DOT__r_pc),32);
        tracep->fullBit(oldp+34,(vlTOPp->ORC_R32I__DOT__r_program_counter_valid));
        tracep->fullBit(oldp+35,(vlTOPp->ORC_R32I__DOT__r_inst_read_ack));
        tracep->fullIData(oldp+36,(vlTOPp->ORC_R32I__DOT__r_inst_data),32);
        tracep->fullCData(oldp+37,(vlTOPp->ORC_R32I__DOT__w_opcode),7);
        tracep->fullCData(oldp+38,(vlTOPp->ORC_R32I__DOT__w_pc_opcode),7);
        tracep->fullIData(oldp+39,(vlTOPp->ORC_R32I__DOT__r_simm),32);
        tracep->fullIData(oldp+40,(vlTOPp->ORC_R32I__DOT__r_uimm),32);
        tracep->fullBit(oldp+41,(vlTOPp->ORC_R32I__DOT__r_jalr));
        tracep->fullBit(oldp+42,(vlTOPp->ORC_R32I__DOT__r_bcc));
        tracep->fullBit(oldp+43,(vlTOPp->ORC_R32I__DOT__r_lcc));
        tracep->fullBit(oldp+44,(vlTOPp->ORC_R32I__DOT__r_scc));
        tracep->fullBit(oldp+45,(vlTOPp->ORC_R32I__DOT__r_rii));
        tracep->fullBit(oldp+46,(vlTOPp->ORC_R32I__DOT__r_rro));
        tracep->fullIData(oldp+47,(vlTOPp->ORC_R32I__DOT__general_registers1[0]),32);
        tracep->fullIData(oldp+48,(vlTOPp->ORC_R32I__DOT__general_registers1[1]),32);
        tracep->fullIData(oldp+49,(vlTOPp->ORC_R32I__DOT__general_registers1[2]),32);
        tracep->fullIData(oldp+50,(vlTOPp->ORC_R32I__DOT__general_registers1[3]),32);
        tracep->fullIData(oldp+51,(vlTOPp->ORC_R32I__DOT__general_registers1[4]),32);
        tracep->fullIData(oldp+52,(vlTOPp->ORC_R32I__DOT__general_registers1[5]),32);
        tracep->fullIData(oldp+53,(vlTOPp->ORC_R32I__DOT__general_registers1[6]),32);
        tracep->fullIData(oldp+54,(vlTOPp->ORC_R32I__DOT__general_registers1[7]),32);
        tracep->fullIData(oldp+55,(vlTOPp->ORC_R32I__DOT__general_registers1[8]),32);
        tracep->fullIData(oldp+56,(vlTOPp->ORC_R32I__DOT__general_registers1[9]),32);
        tracep->fullIData(oldp+57,(vlTOPp->ORC_R32I__DOT__general_registers1[10]),32);
        tracep->fullIData(oldp+58,(vlTOPp->ORC_R32I__DOT__general_registers1[11]),32);
        tracep->fullIData(oldp+59,(vlTOPp->ORC_R32I__DOT__general_registers1[12]),32);
        tracep->fullIData(oldp+60,(vlTOPp->ORC_R32I__DOT__general_registers1[13]),32);
        tracep->fullIData(oldp+61,(vlTOPp->ORC_R32I__DOT__general_registers1[14]),32);
        tracep->fullIData(oldp+62,(vlTOPp->ORC_R32I__DOT__general_registers1[15]),32);
        tracep->fullIData(oldp+63,(vlTOPp->ORC_R32I__DOT__general_registers1[16]),32);
        tracep->fullIData(oldp+64,(vlTOPp->ORC_R32I__DOT__general_registers1[17]),32);
        tracep->fullIData(oldp+65,(vlTOPp->ORC_R32I__DOT__general_registers1[18]),32);
        tracep->fullIData(oldp+66,(vlTOPp->ORC_R32I__DOT__general_registers1[19]),32);
        tracep->fullIData(oldp+67,(vlTOPp->ORC_R32I__DOT__general_registers1[20]),32);
        tracep->fullIData(oldp+68,(vlTOPp->ORC_R32I__DOT__general_registers1[21]),32);
        tracep->fullIData(oldp+69,(vlTOPp->ORC_R32I__DOT__general_registers1[22]),32);
        tracep->fullIData(oldp+70,(vlTOPp->ORC_R32I__DOT__general_registers1[23]),32);
        tracep->fullIData(oldp+71,(vlTOPp->ORC_R32I__DOT__general_registers1[24]),32);
        tracep->fullIData(oldp+72,(vlTOPp->ORC_R32I__DOT__general_registers1[25]),32);
        tracep->fullIData(oldp+73,(vlTOPp->ORC_R32I__DOT__general_registers1[26]),32);
        tracep->fullIData(oldp+74,(vlTOPp->ORC_R32I__DOT__general_registers1[27]),32);
        tracep->fullIData(oldp+75,(vlTOPp->ORC_R32I__DOT__general_registers1[28]),32);
        tracep->fullIData(oldp+76,(vlTOPp->ORC_R32I__DOT__general_registers1[29]),32);
        tracep->fullIData(oldp+77,(vlTOPp->ORC_R32I__DOT__general_registers1[30]),32);
        tracep->fullIData(oldp+78,(vlTOPp->ORC_R32I__DOT__general_registers1[31]),32);
        tracep->fullIData(oldp+79,(vlTOPp->ORC_R32I__DOT__general_registers2[0]),32);
        tracep->fullIData(oldp+80,(vlTOPp->ORC_R32I__DOT__general_registers2[1]),32);
        tracep->fullIData(oldp+81,(vlTOPp->ORC_R32I__DOT__general_registers2[2]),32);
        tracep->fullIData(oldp+82,(vlTOPp->ORC_R32I__DOT__general_registers2[3]),32);
        tracep->fullIData(oldp+83,(vlTOPp->ORC_R32I__DOT__general_registers2[4]),32);
        tracep->fullIData(oldp+84,(vlTOPp->ORC_R32I__DOT__general_registers2[5]),32);
        tracep->fullIData(oldp+85,(vlTOPp->ORC_R32I__DOT__general_registers2[6]),32);
        tracep->fullIData(oldp+86,(vlTOPp->ORC_R32I__DOT__general_registers2[7]),32);
        tracep->fullIData(oldp+87,(vlTOPp->ORC_R32I__DOT__general_registers2[8]),32);
        tracep->fullIData(oldp+88,(vlTOPp->ORC_R32I__DOT__general_registers2[9]),32);
        tracep->fullIData(oldp+89,(vlTOPp->ORC_R32I__DOT__general_registers2[10]),32);
        tracep->fullIData(oldp+90,(vlTOPp->ORC_R32I__DOT__general_registers2[11]),32);
        tracep->fullIData(oldp+91,(vlTOPp->ORC_R32I__DOT__general_registers2[12]),32);
        tracep->fullIData(oldp+92,(vlTOPp->ORC_R32I__DOT__general_registers2[13]),32);
        tracep->fullIData(oldp+93,(vlTOPp->ORC_R32I__DOT__general_registers2[14]),32);
        tracep->fullIData(oldp+94,(vlTOPp->ORC_R32I__DOT__general_registers2[15]),32);
        tracep->fullIData(oldp+95,(vlTOPp->ORC_R32I__DOT__general_registers2[16]),32);
        tracep->fullIData(oldp+96,(vlTOPp->ORC_R32I__DOT__general_registers2[17]),32);
        tracep->fullIData(oldp+97,(vlTOPp->ORC_R32I__DOT__general_registers2[18]),32);
        tracep->fullIData(oldp+98,(vlTOPp->ORC_R32I__DOT__general_registers2[19]),32);
        tracep->fullIData(oldp+99,(vlTOPp->ORC_R32I__DOT__general_registers2[20]),32);
        tracep->fullIData(oldp+100,(vlTOPp->ORC_R32I__DOT__general_registers2[21]),32);
        tracep->fullIData(oldp+101,(vlTOPp->ORC_R32I__DOT__general_registers2[22]),32);
        tracep->fullIData(oldp+102,(vlTOPp->ORC_R32I__DOT__general_registers2[23]),32);
        tracep->fullIData(oldp+103,(vlTOPp->ORC_R32I__DOT__general_registers2[24]),32);
        tracep->fullIData(oldp+104,(vlTOPp->ORC_R32I__DOT__general_registers2[25]),32);
        tracep->fullIData(oldp+105,(vlTOPp->ORC_R32I__DOT__general_registers2[26]),32);
        tracep->fullIData(oldp+106,(vlTOPp->ORC_R32I__DOT__general_registers2[27]),32);
        tracep->fullIData(oldp+107,(vlTOPp->ORC_R32I__DOT__general_registers2[28]),32);
        tracep->fullIData(oldp+108,(vlTOPp->ORC_R32I__DOT__general_registers2[29]),32);
        tracep->fullIData(oldp+109,(vlTOPp->ORC_R32I__DOT__general_registers2[30]),32);
        tracep->fullIData(oldp+110,(vlTOPp->ORC_R32I__DOT__general_registers2[31]),32);
        tracep->fullCData(oldp+111,(vlTOPp->ORC_R32I__DOT__reset_index),5);
        tracep->fullBit(oldp+112,(vlTOPp->ORC_R32I__DOT__r_read_ready));
        tracep->fullBit(oldp+113,(vlTOPp->ORC_R32I__DOT__r_write_ready));
        tracep->fullIData(oldp+114,(vlTOPp->ORC_R32I__DOT__r_master_read_addr),32);
        tracep->fullCData(oldp+115,(vlTOPp->ORC_R32I__DOT__w_rd),5);
        tracep->fullCData(oldp+116,(vlTOPp->ORC_R32I__DOT__w_destination_index),5);
        tracep->fullCData(oldp+117,(vlTOPp->ORC_R32I__DOT__w_source1_pointer),5);
        tracep->fullCData(oldp+118,(vlTOPp->ORC_R32I__DOT__w_source2_pointer),5);
        tracep->fullCData(oldp+119,(vlTOPp->ORC_R32I__DOT__w_fct3),3);
        tracep->fullCData(oldp+120,(vlTOPp->ORC_R32I__DOT__w_fct7),7);
        tracep->fullIData(oldp+121,(vlTOPp->ORC_R32I__DOT__r_unsigned_rs1),32);
        tracep->fullIData(oldp+122,(vlTOPp->ORC_R32I__DOT__r_unsigned_rs2),32);
        tracep->fullIData(oldp+123,(vlTOPp->ORC_R32I__DOT__w_signed_rs1),32);
        tracep->fullIData(oldp+124,(vlTOPp->ORC_R32I__DOT__w_signed_rs2),32);
        tracep->fullIData(oldp+125,(vlTOPp->ORC_R32I__DOT__w_master_addr),32);
        tracep->fullIData(oldp+126,(vlTOPp->ORC_R32I__DOT__w_l_data),32);
        tracep->fullIData(oldp+127,(vlTOPp->ORC_R32I__DOT__w_s_data),32);
        tracep->fullIData(oldp+128,(vlTOPp->ORC_R32I__DOT__w_signed_rs2_extended),32);
        tracep->fullIData(oldp+129,(vlTOPp->ORC_R32I__DOT__w_unsigned_rs2_extended),32);
        tracep->fullIData(oldp+130,(vlTOPp->ORC_R32I__DOT__w_rm_data),32);
        tracep->fullBit(oldp+131,(vlTOPp->ORC_R32I__DOT__w_jal));
        tracep->fullIData(oldp+132,(vlTOPp->ORC_R32I__DOT__w_j_simm),32);
        tracep->fullBit(oldp+133,(vlTOPp->ORC_R32I__DOT__w_bmux));
        tracep->fullBit(oldp+134,(vlTOPp->ORC_R32I__DOT__w_jump_request));
        tracep->fullIData(oldp+135,(vlTOPp->ORC_R32I__DOT__w_jump_value),32);
        tracep->fullBit(oldp+136,(vlTOPp->ORC_R32I__DOT__w_rd_not_zero));
        tracep->fullBit(oldp+137,(vlTOPp->ORC_R32I__DOT__w_destination_index_not_zero));
        tracep->fullBit(oldp+138,(vlTOPp->ORC_R32I__DOT__w_decoder_valid));
        tracep->fullBit(oldp+139,(vlTOPp->ORC_R32I__DOT__w_decoder_ready));
        tracep->fullBit(oldp+140,(vlTOPp->ORC_R32I__DOT__w_decoder_opcode));
        tracep->fullBit(oldp+141,(vlTOPp->ORC_R32I__DOT__w_program_counter_ready));
        tracep->fullBit(oldp+142,(vlTOPp->ORC_R32I__DOT__w_lui));
        tracep->fullBit(oldp+143,(vlTOPp->ORC_R32I__DOT__w_auipc));
        tracep->fullIData(oldp+144,(0U),32);
        tracep->fullCData(oldp+145,(0x13U),7);
        tracep->fullCData(oldp+146,(0x33U),7);
        tracep->fullCData(oldp+147,(0x37U),7);
        tracep->fullCData(oldp+148,(0x17U),7);
        tracep->fullCData(oldp+149,(0x6fU),7);
        tracep->fullCData(oldp+150,(0x67U),7);
        tracep->fullCData(oldp+151,(0x63U),7);
        tracep->fullCData(oldp+152,(3U),7);
        tracep->fullCData(oldp+153,(0x23U),7);
        tracep->fullIData(oldp+154,(0xffffffffU),32);
    }
}
