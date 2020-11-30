// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Tracing implementation internals
#include "verilated_vcd_c.h"
#include "Vtop__Syms.h"


void Vtop::traceChgTop0(void* userp, VerilatedVcd* tracep) {
    Vtop__Syms* __restrict vlSymsp = static_cast<Vtop__Syms*>(userp);
    Vtop* const __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    // Variables
    if (VL_UNLIKELY(!vlSymsp->__Vm_activity)) return;
    // Body
    {
        vlTOPp->traceChgSub0(userp, tracep);
    }
}

void Vtop::traceChgSub0(void* userp, VerilatedVcd* tracep) {
    Vtop__Syms* __restrict vlSymsp = static_cast<Vtop__Syms*>(userp);
    Vtop* const __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    vluint32_t* const oldp = tracep->oldp(vlSymsp->__Vm_baseCode + 1);
    if (false && oldp) {}  // Prevent unused
    // Body
    {
        tracep->chgBit(oldp+0,(vlTOPp->i_clk));
        tracep->chgBit(oldp+1,(vlTOPp->i_reset_sync));
        tracep->chgBit(oldp+2,(vlTOPp->o_inst_read));
        tracep->chgBit(oldp+3,(vlTOPp->i_inst_read_ack));
        tracep->chgIData(oldp+4,(vlTOPp->o_inst_read_addr),32);
        tracep->chgIData(oldp+5,(vlTOPp->i_inst_read_data),32);
        tracep->chgBit(oldp+6,(vlTOPp->o_master_read));
        tracep->chgBit(oldp+7,(vlTOPp->i_master_read_ack));
        tracep->chgIData(oldp+8,(vlTOPp->o_master_read_addr),32);
        tracep->chgIData(oldp+9,(vlTOPp->i_master_read_data),32);
        tracep->chgBit(oldp+10,(vlTOPp->o_master_write));
        tracep->chgBit(oldp+11,(vlTOPp->i_master_write_ack));
        tracep->chgIData(oldp+12,(vlTOPp->o_master_write_addr),32);
        tracep->chgIData(oldp+13,(vlTOPp->o_master_write_data),32);
        tracep->chgCData(oldp+14,(vlTOPp->o_master_write_byte_enable),4);
        tracep->chgBit(oldp+15,(vlTOPp->ORC_R32I__DOT__i_clk));
        tracep->chgBit(oldp+16,(vlTOPp->ORC_R32I__DOT__i_reset_sync));
        tracep->chgBit(oldp+17,(vlTOPp->ORC_R32I__DOT__o_inst_read));
        tracep->chgBit(oldp+18,(vlTOPp->ORC_R32I__DOT__i_inst_read_ack));
        tracep->chgIData(oldp+19,(vlTOPp->ORC_R32I__DOT__o_inst_read_addr),32);
        tracep->chgIData(oldp+20,(vlTOPp->ORC_R32I__DOT__i_inst_read_data),32);
        tracep->chgBit(oldp+21,(vlTOPp->ORC_R32I__DOT__o_master_read));
        tracep->chgBit(oldp+22,(vlTOPp->ORC_R32I__DOT__i_master_read_ack));
        tracep->chgIData(oldp+23,(vlTOPp->ORC_R32I__DOT__o_master_read_addr),32);
        tracep->chgIData(oldp+24,(vlTOPp->ORC_R32I__DOT__i_master_read_data),32);
        tracep->chgBit(oldp+25,(vlTOPp->ORC_R32I__DOT__o_master_write));
        tracep->chgBit(oldp+26,(vlTOPp->ORC_R32I__DOT__i_master_write_ack));
        tracep->chgIData(oldp+27,(vlTOPp->ORC_R32I__DOT__o_master_write_addr),32);
        tracep->chgIData(oldp+28,(vlTOPp->ORC_R32I__DOT__o_master_write_data),32);
        tracep->chgCData(oldp+29,(vlTOPp->ORC_R32I__DOT__o_master_write_byte_enable),4);
        tracep->chgIData(oldp+30,(vlTOPp->ORC_R32I__DOT__r_next_pc_fetch),32);
        tracep->chgIData(oldp+31,(vlTOPp->ORC_R32I__DOT__r_next_pc_decode),32);
        tracep->chgIData(oldp+32,(vlTOPp->ORC_R32I__DOT__r_pc),32);
        tracep->chgBit(oldp+33,(vlTOPp->ORC_R32I__DOT__r_program_counter_valid));
        tracep->chgBit(oldp+34,(vlTOPp->ORC_R32I__DOT__r_inst_read_ack));
        tracep->chgIData(oldp+35,(vlTOPp->ORC_R32I__DOT__r_inst_data),32);
        tracep->chgCData(oldp+36,(vlTOPp->ORC_R32I__DOT__w_opcode),7);
        tracep->chgCData(oldp+37,(vlTOPp->ORC_R32I__DOT__w_pc_opcode),7);
        tracep->chgIData(oldp+38,(vlTOPp->ORC_R32I__DOT__r_simm),32);
        tracep->chgIData(oldp+39,(vlTOPp->ORC_R32I__DOT__r_uimm),32);
        tracep->chgBit(oldp+40,(vlTOPp->ORC_R32I__DOT__r_jalr));
        tracep->chgBit(oldp+41,(vlTOPp->ORC_R32I__DOT__r_bcc));
        tracep->chgBit(oldp+42,(vlTOPp->ORC_R32I__DOT__r_lcc));
        tracep->chgBit(oldp+43,(vlTOPp->ORC_R32I__DOT__r_scc));
        tracep->chgBit(oldp+44,(vlTOPp->ORC_R32I__DOT__r_rii));
        tracep->chgBit(oldp+45,(vlTOPp->ORC_R32I__DOT__r_rro));
        tracep->chgIData(oldp+46,(vlTOPp->ORC_R32I__DOT__general_registers1[0]),32);
        tracep->chgIData(oldp+47,(vlTOPp->ORC_R32I__DOT__general_registers1[1]),32);
        tracep->chgIData(oldp+48,(vlTOPp->ORC_R32I__DOT__general_registers1[2]),32);
        tracep->chgIData(oldp+49,(vlTOPp->ORC_R32I__DOT__general_registers1[3]),32);
        tracep->chgIData(oldp+50,(vlTOPp->ORC_R32I__DOT__general_registers1[4]),32);
        tracep->chgIData(oldp+51,(vlTOPp->ORC_R32I__DOT__general_registers1[5]),32);
        tracep->chgIData(oldp+52,(vlTOPp->ORC_R32I__DOT__general_registers1[6]),32);
        tracep->chgIData(oldp+53,(vlTOPp->ORC_R32I__DOT__general_registers1[7]),32);
        tracep->chgIData(oldp+54,(vlTOPp->ORC_R32I__DOT__general_registers1[8]),32);
        tracep->chgIData(oldp+55,(vlTOPp->ORC_R32I__DOT__general_registers1[9]),32);
        tracep->chgIData(oldp+56,(vlTOPp->ORC_R32I__DOT__general_registers1[10]),32);
        tracep->chgIData(oldp+57,(vlTOPp->ORC_R32I__DOT__general_registers1[11]),32);
        tracep->chgIData(oldp+58,(vlTOPp->ORC_R32I__DOT__general_registers1[12]),32);
        tracep->chgIData(oldp+59,(vlTOPp->ORC_R32I__DOT__general_registers1[13]),32);
        tracep->chgIData(oldp+60,(vlTOPp->ORC_R32I__DOT__general_registers1[14]),32);
        tracep->chgIData(oldp+61,(vlTOPp->ORC_R32I__DOT__general_registers1[15]),32);
        tracep->chgIData(oldp+62,(vlTOPp->ORC_R32I__DOT__general_registers1[16]),32);
        tracep->chgIData(oldp+63,(vlTOPp->ORC_R32I__DOT__general_registers1[17]),32);
        tracep->chgIData(oldp+64,(vlTOPp->ORC_R32I__DOT__general_registers1[18]),32);
        tracep->chgIData(oldp+65,(vlTOPp->ORC_R32I__DOT__general_registers1[19]),32);
        tracep->chgIData(oldp+66,(vlTOPp->ORC_R32I__DOT__general_registers1[20]),32);
        tracep->chgIData(oldp+67,(vlTOPp->ORC_R32I__DOT__general_registers1[21]),32);
        tracep->chgIData(oldp+68,(vlTOPp->ORC_R32I__DOT__general_registers1[22]),32);
        tracep->chgIData(oldp+69,(vlTOPp->ORC_R32I__DOT__general_registers1[23]),32);
        tracep->chgIData(oldp+70,(vlTOPp->ORC_R32I__DOT__general_registers1[24]),32);
        tracep->chgIData(oldp+71,(vlTOPp->ORC_R32I__DOT__general_registers1[25]),32);
        tracep->chgIData(oldp+72,(vlTOPp->ORC_R32I__DOT__general_registers1[26]),32);
        tracep->chgIData(oldp+73,(vlTOPp->ORC_R32I__DOT__general_registers1[27]),32);
        tracep->chgIData(oldp+74,(vlTOPp->ORC_R32I__DOT__general_registers1[28]),32);
        tracep->chgIData(oldp+75,(vlTOPp->ORC_R32I__DOT__general_registers1[29]),32);
        tracep->chgIData(oldp+76,(vlTOPp->ORC_R32I__DOT__general_registers1[30]),32);
        tracep->chgIData(oldp+77,(vlTOPp->ORC_R32I__DOT__general_registers1[31]),32);
        tracep->chgIData(oldp+78,(vlTOPp->ORC_R32I__DOT__general_registers2[0]),32);
        tracep->chgIData(oldp+79,(vlTOPp->ORC_R32I__DOT__general_registers2[1]),32);
        tracep->chgIData(oldp+80,(vlTOPp->ORC_R32I__DOT__general_registers2[2]),32);
        tracep->chgIData(oldp+81,(vlTOPp->ORC_R32I__DOT__general_registers2[3]),32);
        tracep->chgIData(oldp+82,(vlTOPp->ORC_R32I__DOT__general_registers2[4]),32);
        tracep->chgIData(oldp+83,(vlTOPp->ORC_R32I__DOT__general_registers2[5]),32);
        tracep->chgIData(oldp+84,(vlTOPp->ORC_R32I__DOT__general_registers2[6]),32);
        tracep->chgIData(oldp+85,(vlTOPp->ORC_R32I__DOT__general_registers2[7]),32);
        tracep->chgIData(oldp+86,(vlTOPp->ORC_R32I__DOT__general_registers2[8]),32);
        tracep->chgIData(oldp+87,(vlTOPp->ORC_R32I__DOT__general_registers2[9]),32);
        tracep->chgIData(oldp+88,(vlTOPp->ORC_R32I__DOT__general_registers2[10]),32);
        tracep->chgIData(oldp+89,(vlTOPp->ORC_R32I__DOT__general_registers2[11]),32);
        tracep->chgIData(oldp+90,(vlTOPp->ORC_R32I__DOT__general_registers2[12]),32);
        tracep->chgIData(oldp+91,(vlTOPp->ORC_R32I__DOT__general_registers2[13]),32);
        tracep->chgIData(oldp+92,(vlTOPp->ORC_R32I__DOT__general_registers2[14]),32);
        tracep->chgIData(oldp+93,(vlTOPp->ORC_R32I__DOT__general_registers2[15]),32);
        tracep->chgIData(oldp+94,(vlTOPp->ORC_R32I__DOT__general_registers2[16]),32);
        tracep->chgIData(oldp+95,(vlTOPp->ORC_R32I__DOT__general_registers2[17]),32);
        tracep->chgIData(oldp+96,(vlTOPp->ORC_R32I__DOT__general_registers2[18]),32);
        tracep->chgIData(oldp+97,(vlTOPp->ORC_R32I__DOT__general_registers2[19]),32);
        tracep->chgIData(oldp+98,(vlTOPp->ORC_R32I__DOT__general_registers2[20]),32);
        tracep->chgIData(oldp+99,(vlTOPp->ORC_R32I__DOT__general_registers2[21]),32);
        tracep->chgIData(oldp+100,(vlTOPp->ORC_R32I__DOT__general_registers2[22]),32);
        tracep->chgIData(oldp+101,(vlTOPp->ORC_R32I__DOT__general_registers2[23]),32);
        tracep->chgIData(oldp+102,(vlTOPp->ORC_R32I__DOT__general_registers2[24]),32);
        tracep->chgIData(oldp+103,(vlTOPp->ORC_R32I__DOT__general_registers2[25]),32);
        tracep->chgIData(oldp+104,(vlTOPp->ORC_R32I__DOT__general_registers2[26]),32);
        tracep->chgIData(oldp+105,(vlTOPp->ORC_R32I__DOT__general_registers2[27]),32);
        tracep->chgIData(oldp+106,(vlTOPp->ORC_R32I__DOT__general_registers2[28]),32);
        tracep->chgIData(oldp+107,(vlTOPp->ORC_R32I__DOT__general_registers2[29]),32);
        tracep->chgIData(oldp+108,(vlTOPp->ORC_R32I__DOT__general_registers2[30]),32);
        tracep->chgIData(oldp+109,(vlTOPp->ORC_R32I__DOT__general_registers2[31]),32);
        tracep->chgCData(oldp+110,(vlTOPp->ORC_R32I__DOT__reset_index),5);
        tracep->chgBit(oldp+111,(vlTOPp->ORC_R32I__DOT__r_read_ready));
        tracep->chgBit(oldp+112,(vlTOPp->ORC_R32I__DOT__r_write_ready));
        tracep->chgIData(oldp+113,(vlTOPp->ORC_R32I__DOT__r_master_read_addr),32);
        tracep->chgCData(oldp+114,(vlTOPp->ORC_R32I__DOT__w_rd),5);
        tracep->chgCData(oldp+115,(vlTOPp->ORC_R32I__DOT__w_destination_index),5);
        tracep->chgCData(oldp+116,(vlTOPp->ORC_R32I__DOT__w_source1_pointer),5);
        tracep->chgCData(oldp+117,(vlTOPp->ORC_R32I__DOT__w_source2_pointer),5);
        tracep->chgCData(oldp+118,(vlTOPp->ORC_R32I__DOT__w_fct3),3);
        tracep->chgCData(oldp+119,(vlTOPp->ORC_R32I__DOT__w_fct7),7);
        tracep->chgIData(oldp+120,(vlTOPp->ORC_R32I__DOT__r_unsigned_rs1),32);
        tracep->chgIData(oldp+121,(vlTOPp->ORC_R32I__DOT__r_unsigned_rs2),32);
        tracep->chgIData(oldp+122,(vlTOPp->ORC_R32I__DOT__w_signed_rs1),32);
        tracep->chgIData(oldp+123,(vlTOPp->ORC_R32I__DOT__w_signed_rs2),32);
        tracep->chgIData(oldp+124,(vlTOPp->ORC_R32I__DOT__w_master_addr),32);
        tracep->chgIData(oldp+125,(vlTOPp->ORC_R32I__DOT__w_l_data),32);
        tracep->chgIData(oldp+126,(vlTOPp->ORC_R32I__DOT__w_s_data),32);
        tracep->chgIData(oldp+127,(vlTOPp->ORC_R32I__DOT__w_signed_rs2_extended),32);
        tracep->chgIData(oldp+128,(vlTOPp->ORC_R32I__DOT__w_unsigned_rs2_extended),32);
        tracep->chgIData(oldp+129,(vlTOPp->ORC_R32I__DOT__w_rm_data),32);
        tracep->chgBit(oldp+130,(vlTOPp->ORC_R32I__DOT__w_jal));
        tracep->chgIData(oldp+131,(vlTOPp->ORC_R32I__DOT__w_j_simm),32);
        tracep->chgBit(oldp+132,(vlTOPp->ORC_R32I__DOT__w_bmux));
        tracep->chgBit(oldp+133,(vlTOPp->ORC_R32I__DOT__w_jump_request));
        tracep->chgIData(oldp+134,(vlTOPp->ORC_R32I__DOT__w_jump_value),32);
        tracep->chgBit(oldp+135,(vlTOPp->ORC_R32I__DOT__w_rd_not_zero));
        tracep->chgBit(oldp+136,(vlTOPp->ORC_R32I__DOT__w_destination_index_not_zero));
        tracep->chgBit(oldp+137,(vlTOPp->ORC_R32I__DOT__w_decoder_valid));
        tracep->chgBit(oldp+138,(vlTOPp->ORC_R32I__DOT__w_decoder_ready));
        tracep->chgBit(oldp+139,(vlTOPp->ORC_R32I__DOT__w_decoder_opcode));
        tracep->chgBit(oldp+140,(vlTOPp->ORC_R32I__DOT__w_program_counter_ready));
        tracep->chgBit(oldp+141,(vlTOPp->ORC_R32I__DOT__w_lui));
        tracep->chgBit(oldp+142,(vlTOPp->ORC_R32I__DOT__w_auipc));
    }
}

void Vtop::traceCleanup(void* userp, VerilatedVcd* /*unused*/) {
    Vtop__Syms* __restrict vlSymsp = static_cast<Vtop__Syms*>(userp);
    Vtop* const __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    // Body
    {
        vlSymsp->__Vm_activity = false;
        vlTOPp->__Vm_traceActivity[0U] = 0U;
    }
}
