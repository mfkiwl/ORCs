// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vtop.h for the primary calling header

#include "Vtop.h"
#include "Vtop__Syms.h"

#include "verilated_dpi.h"

//==========

VL_CTOR_IMP(Vtop) {
    Vtop__Syms* __restrict vlSymsp = __VlSymsp = new Vtop__Syms(this, name());
    Vtop* const __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    // Reset internal values
    
    // Reset structure values
    _ctor_var_reset();
}

void Vtop::__Vconfigure(Vtop__Syms* vlSymsp, bool first) {
    if (false && first) {}  // Prevent unused
    this->__VlSymsp = vlSymsp;
    if (false && this->__VlSymsp) {}  // Prevent unused
    Verilated::timeunit(-12);
    Verilated::timeprecision(-12);
}

Vtop::~Vtop() {
    VL_DO_CLEAR(delete __VlSymsp, __VlSymsp = nullptr);
}

void Vtop::_settle__TOP__2(Vtop__Syms* __restrict vlSymsp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtop::_settle__TOP__2\n"); );
    Vtop* const __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    // Body
    vlTOPp->ORC_R32I__DOT__i_clk = vlTOPp->i_clk;
    vlTOPp->ORC_R32I__DOT__i_reset_sync = vlTOPp->i_reset_sync;
    vlTOPp->ORC_R32I__DOT__i_inst_read_ack = vlTOPp->i_inst_read_ack;
    vlTOPp->ORC_R32I__DOT__i_inst_read_data = vlTOPp->i_inst_read_data;
    vlTOPp->ORC_R32I__DOT__i_master_read_ack = vlTOPp->i_master_read_ack;
    vlTOPp->ORC_R32I__DOT__i_master_read_data = vlTOPp->i_master_read_data;
    vlTOPp->ORC_R32I__DOT__i_master_write_ack = vlTOPp->i_master_write_ack;
    vlTOPp->ORC_R32I__DOT__w_j_simm = ((((0x80000000U 
                                          & vlTOPp->i_inst_read_data)
                                          ? 0x7ffU : 0U) 
                                        << 0x15U) | 
                                       ((0x100000U 
                                         & (vlTOPp->i_inst_read_data 
                                            >> 0xbU)) 
                                        | ((0xff000U 
                                            & vlTOPp->i_inst_read_data) 
                                           | ((0x800U 
                                               & (vlTOPp->i_inst_read_data 
                                                  >> 9U)) 
                                              | (0x7feU 
                                                 & (vlTOPp->i_inst_read_data 
                                                    >> 0x14U))))));
    vlTOPp->ORC_R32I__DOT__w_source1_pointer = (0x1fU 
                                                & (vlTOPp->i_inst_read_data 
                                                   >> 0xfU));
    vlTOPp->ORC_R32I__DOT__w_source2_pointer = (0x1fU 
                                                & (vlTOPp->i_inst_read_data 
                                                   >> 0x14U));
    vlTOPp->ORC_R32I__DOT__w_rd = (0x1fU & (vlTOPp->i_inst_read_data 
                                            >> 7U));
    vlTOPp->ORC_R32I__DOT__w_opcode = (0x7fU & vlTOPp->i_inst_read_data);
    vlTOPp->ORC_R32I__DOT__w_signed_rs1 = vlTOPp->ORC_R32I__DOT__r_unsigned_rs1;
    vlTOPp->ORC_R32I__DOT__w_signed_rs2 = vlTOPp->ORC_R32I__DOT__r_unsigned_rs2;
    vlTOPp->ORC_R32I__DOT__o_inst_read = vlTOPp->ORC_R32I__DOT__r_program_counter_valid;
    vlTOPp->ORC_R32I__DOT__o_inst_read_addr = vlTOPp->ORC_R32I__DOT__r_next_pc_fetch;
    vlTOPp->ORC_R32I__DOT__w_master_addr = (vlTOPp->ORC_R32I__DOT__r_unsigned_rs1 
                                            + vlTOPp->ORC_R32I__DOT__r_simm);
    vlTOPp->ORC_R32I__DOT__w_unsigned_rs2_extended 
        = ((IData)(vlTOPp->ORC_R32I__DOT__r_rii) ? vlTOPp->ORC_R32I__DOT__r_uimm
            : vlTOPp->ORC_R32I__DOT__r_unsigned_rs2);
    vlTOPp->ORC_R32I__DOT__w_pc_opcode = (0x7fU & vlTOPp->ORC_R32I__DOT__r_inst_data);
    vlTOPp->ORC_R32I__DOT__w_destination_index = (0x1fU 
                                                  & (vlTOPp->ORC_R32I__DOT__r_inst_data 
                                                     >> 7U));
    vlTOPp->ORC_R32I__DOT__o_master_read = vlTOPp->ORC_R32I__DOT__r_lcc;
    vlTOPp->ORC_R32I__DOT__o_master_write = vlTOPp->ORC_R32I__DOT__r_scc;
    vlTOPp->ORC_R32I__DOT__w_fct7 = (0x7fU & (vlTOPp->ORC_R32I__DOT__r_inst_data 
                                              >> 0x19U));
    vlTOPp->ORC_R32I__DOT__w_decoder_valid = ((((((IData)(vlTOPp->ORC_R32I__DOT__r_jalr) 
                                                  | (IData)(vlTOPp->ORC_R32I__DOT__r_bcc)) 
                                                 | (IData)(vlTOPp->ORC_R32I__DOT__r_rii)) 
                                                | (IData)(vlTOPp->ORC_R32I__DOT__r_rro)) 
                                               | (IData)(vlTOPp->ORC_R32I__DOT__r_lcc)) 
                                              | (IData)(vlTOPp->ORC_R32I__DOT__r_scc));
    vlTOPp->ORC_R32I__DOT__w_fct3 = (7U & (vlTOPp->ORC_R32I__DOT__r_inst_data 
                                           >> 0xcU));
    vlTOPp->ORC_R32I__DOT__w_rd_not_zero = (0U != (IData)(vlTOPp->ORC_R32I__DOT__w_rd));
    vlTOPp->ORC_R32I__DOT__w_lui = (((0x37U == (IData)(vlTOPp->ORC_R32I__DOT__w_opcode)) 
                                     & (IData)(vlTOPp->i_inst_read_ack))
                                     ? 1U : 0U);
    vlTOPp->ORC_R32I__DOT__w_auipc = (((0x17U == (IData)(vlTOPp->ORC_R32I__DOT__w_opcode)) 
                                       & (IData)(vlTOPp->i_inst_read_ack))
                                       ? 1U : 0U);
    vlTOPp->ORC_R32I__DOT__w_decoder_opcode = ((0x13U 
                                                == (IData)(vlTOPp->ORC_R32I__DOT__w_opcode))
                                                ? 1U
                                                : (
                                                   (0x33U 
                                                    == (IData)(vlTOPp->ORC_R32I__DOT__w_opcode))
                                                    ? 1U
                                                    : 
                                                   ((3U 
                                                     == (IData)(vlTOPp->ORC_R32I__DOT__w_opcode))
                                                     ? 1U
                                                     : 
                                                    ((0x23U 
                                                      == (IData)(vlTOPp->ORC_R32I__DOT__w_opcode))
                                                      ? 1U
                                                      : 
                                                     ((0x63U 
                                                       == (IData)(vlTOPp->ORC_R32I__DOT__w_opcode))
                                                       ? 1U
                                                       : 
                                                      ((0x67U 
                                                        == (IData)(vlTOPp->ORC_R32I__DOT__w_opcode))
                                                        ? 1U
                                                        : 0U))))));
    vlTOPp->ORC_R32I__DOT__w_jal = (((0x6fU == (IData)(vlTOPp->ORC_R32I__DOT__w_opcode)) 
                                     & (IData)(vlTOPp->i_inst_read_ack))
                                     ? 1U : 0U);
    vlTOPp->ORC_R32I__DOT__w_signed_rs2_extended = 
        ((IData)(vlTOPp->ORC_R32I__DOT__r_rii) ? vlTOPp->ORC_R32I__DOT__r_simm
          : vlTOPp->ORC_R32I__DOT__w_signed_rs2);
    vlTOPp->o_inst_read = vlTOPp->ORC_R32I__DOT__o_inst_read;
    vlTOPp->o_inst_read_addr = vlTOPp->ORC_R32I__DOT__o_inst_read_addr;
    vlTOPp->ORC_R32I__DOT__o_master_read_addr = vlTOPp->ORC_R32I__DOT__w_master_addr;
    vlTOPp->ORC_R32I__DOT__o_master_write_addr = vlTOPp->ORC_R32I__DOT__w_master_addr;
    vlTOPp->ORC_R32I__DOT__w_destination_index_not_zero 
        = (0U != (IData)(vlTOPp->ORC_R32I__DOT__w_destination_index));
    vlTOPp->o_master_read = vlTOPp->ORC_R32I__DOT__o_master_read;
    vlTOPp->o_master_write = vlTOPp->ORC_R32I__DOT__o_master_write;
    vlTOPp->ORC_R32I__DOT__w_decoder_ready = (((~ (IData)(vlTOPp->ORC_R32I__DOT__w_decoder_valid)) 
                                               & (IData)(vlTOPp->ORC_R32I__DOT__r_read_ready)) 
                                              & (IData)(vlTOPp->ORC_R32I__DOT__r_write_ready));
    if (((0U == (IData)(vlTOPp->ORC_R32I__DOT__w_fct3)) 
         | (4U == (IData)(vlTOPp->ORC_R32I__DOT__w_fct3)))) {
        vlTOPp->ORC_R32I__DOT__w_l_data = ((3U == (3U 
                                                   & vlTOPp->ORC_R32I__DOT__r_master_read_addr))
                                            ? (((((0U 
                                                   == (IData)(vlTOPp->ORC_R32I__DOT__w_fct3)) 
                                                  & (vlTOPp->i_master_read_data 
                                                     >> 0x1fU))
                                                  ? 0xffffffU
                                                  : 0U) 
                                                << 8U) 
                                               | (0xffU 
                                                  & (vlTOPp->i_master_read_data 
                                                     >> 0x18U)))
                                            : ((2U 
                                                == 
                                                (3U 
                                                 & vlTOPp->ORC_R32I__DOT__r_master_read_addr))
                                                ? (
                                                   ((((0U 
                                                       == (IData)(vlTOPp->ORC_R32I__DOT__w_fct3)) 
                                                      & (vlTOPp->i_master_read_data 
                                                         >> 0x17U))
                                                      ? 0xffffffU
                                                      : 0U) 
                                                    << 8U) 
                                                   | (0xffU 
                                                      & (vlTOPp->i_master_read_data 
                                                         >> 0x10U)))
                                                : (
                                                   (1U 
                                                    == 
                                                    (3U 
                                                     & vlTOPp->ORC_R32I__DOT__r_master_read_addr))
                                                    ? 
                                                   (((((0U 
                                                        == (IData)(vlTOPp->ORC_R32I__DOT__w_fct3)) 
                                                       & (vlTOPp->i_master_read_data 
                                                          >> 0xfU))
                                                       ? 0xffffffU
                                                       : 0U) 
                                                     << 8U) 
                                                    | (0xffU 
                                                       & (vlTOPp->i_master_read_data 
                                                          >> 8U)))
                                                    : 
                                                   (((((0U 
                                                        == (IData)(vlTOPp->ORC_R32I__DOT__w_fct3)) 
                                                       & (vlTOPp->i_master_read_data 
                                                          >> 7U))
                                                       ? 0xffffffU
                                                       : 0U) 
                                                     << 8U) 
                                                    | (0xffU 
                                                       & vlTOPp->i_master_read_data)))));
        vlTOPp->ORC_R32I__DOT__o_master_write_byte_enable 
            = ((3U == (3U & vlTOPp->ORC_R32I__DOT__w_master_addr))
                ? 8U : ((2U == (3U & vlTOPp->ORC_R32I__DOT__w_master_addr))
                         ? 4U : ((1U == (3U & vlTOPp->ORC_R32I__DOT__w_master_addr))
                                  ? 2U : 1U)));
    } else {
        vlTOPp->ORC_R32I__DOT__w_l_data = (((1U == (IData)(vlTOPp->ORC_R32I__DOT__w_fct3)) 
                                            | (5U == (IData)(vlTOPp->ORC_R32I__DOT__w_fct3)))
                                            ? ((2U 
                                                & vlTOPp->ORC_R32I__DOT__r_master_read_addr)
                                                ? (
                                                   ((((1U 
                                                       == (IData)(vlTOPp->ORC_R32I__DOT__w_fct3)) 
                                                      & (vlTOPp->i_master_read_data 
                                                         >> 0x1fU))
                                                      ? 0xffffU
                                                      : 0U) 
                                                    << 0x10U) 
                                                   | (0xffffU 
                                                      & (vlTOPp->i_master_read_data 
                                                         >> 0x10U)))
                                                : (
                                                   ((((1U 
                                                       == (IData)(vlTOPp->ORC_R32I__DOT__w_fct3)) 
                                                      & (vlTOPp->i_master_read_data 
                                                         >> 0xfU))
                                                      ? 0xffffU
                                                      : 0U) 
                                                    << 0x10U) 
                                                   | (0xffffU 
                                                      & vlTOPp->i_master_read_data)))
                                            : vlTOPp->i_master_read_data);
        vlTOPp->ORC_R32I__DOT__o_master_write_byte_enable 
            = (((1U == (IData)(vlTOPp->ORC_R32I__DOT__w_fct3)) 
                | (5U == (IData)(vlTOPp->ORC_R32I__DOT__w_fct3)))
                ? ((2U & vlTOPp->ORC_R32I__DOT__w_master_addr)
                    ? 0xcU : 3U) : 0xfU);
    }
    vlTOPp->ORC_R32I__DOT__w_s_data = ((0U == (IData)(vlTOPp->ORC_R32I__DOT__w_fct3))
                                        ? ((3U == (3U 
                                                   & vlTOPp->ORC_R32I__DOT__w_master_addr))
                                            ? (0xff000000U 
                                               & (vlTOPp->ORC_R32I__DOT__r_unsigned_rs2 
                                                  << 0x18U))
                                            : ((2U 
                                                == 
                                                (3U 
                                                 & vlTOPp->ORC_R32I__DOT__w_master_addr))
                                                ? (0xff0000U 
                                                   & (vlTOPp->ORC_R32I__DOT__r_unsigned_rs2 
                                                      << 0x10U))
                                                : (
                                                   (1U 
                                                    == 
                                                    (3U 
                                                     & vlTOPp->ORC_R32I__DOT__w_master_addr))
                                                    ? 
                                                   (0xff00U 
                                                    & (vlTOPp->ORC_R32I__DOT__r_unsigned_rs2 
                                                       << 8U))
                                                    : 
                                                   (0xffU 
                                                    & vlTOPp->ORC_R32I__DOT__r_unsigned_rs2))))
                                        : ((1U == (IData)(vlTOPp->ORC_R32I__DOT__w_fct3))
                                            ? ((2U 
                                                & vlTOPp->ORC_R32I__DOT__w_master_addr)
                                                ? (0xffff0000U 
                                                   & (vlTOPp->ORC_R32I__DOT__r_unsigned_rs2 
                                                      << 0x10U))
                                                : (0xffffU 
                                                   & vlTOPp->ORC_R32I__DOT__r_unsigned_rs2))
                                            : vlTOPp->ORC_R32I__DOT__r_unsigned_rs2));
    vlTOPp->ORC_R32I__DOT__w_bmux = ((IData)(vlTOPp->ORC_R32I__DOT__r_bcc) 
                                     & ((4U == (IData)(vlTOPp->ORC_R32I__DOT__w_fct3))
                                         ? VL_LTS_III(32,32,32, vlTOPp->ORC_R32I__DOT__w_signed_rs1, vlTOPp->ORC_R32I__DOT__w_signed_rs2)
                                         : ((5U == (IData)(vlTOPp->ORC_R32I__DOT__w_fct3))
                                             ? VL_GTES_III(32,32,32, vlTOPp->ORC_R32I__DOT__w_signed_rs1, vlTOPp->ORC_R32I__DOT__w_signed_rs2)
                                             : ((6U 
                                                 == (IData)(vlTOPp->ORC_R32I__DOT__w_fct3))
                                                 ? 
                                                (vlTOPp->ORC_R32I__DOT__r_unsigned_rs1 
                                                 < vlTOPp->ORC_R32I__DOT__r_unsigned_rs2)
                                                 : 
                                                ((7U 
                                                  == (IData)(vlTOPp->ORC_R32I__DOT__w_fct3))
                                                  ? 
                                                 (vlTOPp->ORC_R32I__DOT__r_unsigned_rs1 
                                                  >= vlTOPp->ORC_R32I__DOT__r_unsigned_rs2)
                                                  : 
                                                 ((0U 
                                                   == (IData)(vlTOPp->ORC_R32I__DOT__w_fct3))
                                                   ? 
                                                  (vlTOPp->ORC_R32I__DOT__r_unsigned_rs1 
                                                   == vlTOPp->ORC_R32I__DOT__r_unsigned_rs2)
                                                   : 
                                                  ((1U 
                                                    == (IData)(vlTOPp->ORC_R32I__DOT__w_fct3))
                                                    ? 
                                                   (vlTOPp->ORC_R32I__DOT__r_unsigned_rs1 
                                                    != vlTOPp->ORC_R32I__DOT__r_unsigned_rs2)
                                                    : 0U)))))));
    vlTOPp->ORC_R32I__DOT__w_rm_data = ((7U == (IData)(vlTOPp->ORC_R32I__DOT__w_fct3))
                                         ? (vlTOPp->ORC_R32I__DOT__r_unsigned_rs1 
                                            & vlTOPp->ORC_R32I__DOT__w_signed_rs2_extended)
                                         : ((6U == (IData)(vlTOPp->ORC_R32I__DOT__w_fct3))
                                             ? (vlTOPp->ORC_R32I__DOT__r_unsigned_rs1 
                                                | vlTOPp->ORC_R32I__DOT__w_signed_rs2_extended)
                                             : ((4U 
                                                 == (IData)(vlTOPp->ORC_R32I__DOT__w_fct3))
                                                 ? 
                                                (vlTOPp->ORC_R32I__DOT__r_unsigned_rs1 
                                                 ^ vlTOPp->ORC_R32I__DOT__w_signed_rs2_extended)
                                                 : 
                                                ((3U 
                                                  == (IData)(vlTOPp->ORC_R32I__DOT__w_fct3))
                                                  ? 
                                                 ((vlTOPp->ORC_R32I__DOT__r_unsigned_rs1 
                                                   < vlTOPp->ORC_R32I__DOT__w_unsigned_rs2_extended)
                                                   ? 1U
                                                   : 0U)
                                                  : 
                                                 ((2U 
                                                   == (IData)(vlTOPp->ORC_R32I__DOT__w_fct3))
                                                   ? 
                                                  (VL_LTS_III(1,32,32, vlTOPp->ORC_R32I__DOT__w_signed_rs1, vlTOPp->ORC_R32I__DOT__w_signed_rs2_extended)
                                                    ? 1U
                                                    : 0U)
                                                   : 
                                                  ((0U 
                                                    == (IData)(vlTOPp->ORC_R32I__DOT__w_fct3))
                                                    ? 
                                                   (((IData)(vlTOPp->ORC_R32I__DOT__r_rro) 
                                                     & ((IData)(vlTOPp->ORC_R32I__DOT__w_fct7) 
                                                        >> 5U))
                                                     ? 
                                                    (vlTOPp->ORC_R32I__DOT__r_unsigned_rs1 
                                                     - vlTOPp->ORC_R32I__DOT__w_unsigned_rs2_extended)
                                                     : 
                                                    (vlTOPp->ORC_R32I__DOT__r_unsigned_rs1 
                                                     + vlTOPp->ORC_R32I__DOT__w_signed_rs2_extended))
                                                    : 
                                                   ((1U 
                                                     == (IData)(vlTOPp->ORC_R32I__DOT__w_fct3))
                                                     ? 
                                                    (vlTOPp->ORC_R32I__DOT__r_unsigned_rs1 
                                                     << 
                                                     (0x1fU 
                                                      & vlTOPp->ORC_R32I__DOT__w_unsigned_rs2_extended))
                                                     : 
                                                    ((0x20U 
                                                      & (IData)(vlTOPp->ORC_R32I__DOT__w_fct7))
                                                      ? 
                                                     VL_SHIFTRS_III(32,32,5, vlTOPp->ORC_R32I__DOT__w_signed_rs1, 
                                                                    (0x1fU 
                                                                     & vlTOPp->ORC_R32I__DOT__w_unsigned_rs2_extended))
                                                      : 
                                                     (vlTOPp->ORC_R32I__DOT__r_unsigned_rs1 
                                                      >> 
                                                      (0x1fU 
                                                       & vlTOPp->ORC_R32I__DOT__w_unsigned_rs2_extended))))))))));
    vlTOPp->o_master_read_addr = vlTOPp->ORC_R32I__DOT__o_master_read_addr;
    vlTOPp->o_master_write_addr = vlTOPp->ORC_R32I__DOT__o_master_write_addr;
    vlTOPp->ORC_R32I__DOT__w_program_counter_ready 
        = (1U & ((((IData)(vlTOPp->ORC_R32I__DOT__w_decoder_ready) 
                   & (IData)(vlTOPp->ORC_R32I__DOT__r_program_counter_valid)) 
                  & (~ (IData)(vlTOPp->ORC_R32I__DOT__w_decoder_opcode))) 
                 | (~ (IData)(vlTOPp->ORC_R32I__DOT__r_program_counter_valid))));
    vlTOPp->o_master_write_byte_enable = vlTOPp->ORC_R32I__DOT__o_master_write_byte_enable;
    vlTOPp->ORC_R32I__DOT__o_master_write_data = vlTOPp->ORC_R32I__DOT__w_s_data;
    vlTOPp->ORC_R32I__DOT__w_jump_request = (((IData)(vlTOPp->ORC_R32I__DOT__w_jal) 
                                              | (IData)(vlTOPp->ORC_R32I__DOT__r_jalr)) 
                                             | (IData)(vlTOPp->ORC_R32I__DOT__w_bmux));
    vlTOPp->ORC_R32I__DOT__w_jump_value = ((IData)(vlTOPp->ORC_R32I__DOT__w_bmux)
                                            ? (vlTOPp->ORC_R32I__DOT__r_simm 
                                               + vlTOPp->ORC_R32I__DOT__r_next_pc_decode)
                                            : ((IData)(vlTOPp->ORC_R32I__DOT__r_jalr)
                                                ? (vlTOPp->ORC_R32I__DOT__r_simm 
                                                   + vlTOPp->ORC_R32I__DOT__r_unsigned_rs1)
                                                : (vlTOPp->ORC_R32I__DOT__w_j_simm 
                                                   + vlTOPp->ORC_R32I__DOT__r_next_pc_decode)));
    vlTOPp->o_master_write_data = vlTOPp->ORC_R32I__DOT__o_master_write_data;
}

void Vtop::_initial__TOP__4(Vtop__Syms* __restrict vlSymsp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtop::_initial__TOP__4\n"); );
    Vtop* const __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    // Body
    vlTOPp->ORC_R32I__DOT__reset_index = 0U;
}

void Vtop::_eval_initial(Vtop__Syms* __restrict vlSymsp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtop::_eval_initial\n"); );
    Vtop* const __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    // Body
    vlTOPp->__Vclklast__TOP__i_clk = vlTOPp->i_clk;
    vlTOPp->_initial__TOP__4(vlSymsp);
}

void Vtop::final() {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtop::final\n"); );
    // Variables
    Vtop__Syms* __restrict vlSymsp = this->__VlSymsp;
    Vtop* const __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
}

void Vtop::_eval_settle(Vtop__Syms* __restrict vlSymsp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtop::_eval_settle\n"); );
    Vtop* const __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    // Body
    vlTOPp->_settle__TOP__2(vlSymsp);
}

void Vtop::_ctor_var_reset() {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtop::_ctor_var_reset\n"); );
    // Body
    i_clk = VL_RAND_RESET_I(1);
    i_reset_sync = VL_RAND_RESET_I(1);
    o_inst_read = VL_RAND_RESET_I(1);
    i_inst_read_ack = VL_RAND_RESET_I(1);
    o_inst_read_addr = VL_RAND_RESET_I(32);
    i_inst_read_data = VL_RAND_RESET_I(32);
    o_master_read = VL_RAND_RESET_I(1);
    i_master_read_ack = VL_RAND_RESET_I(1);
    o_master_read_addr = VL_RAND_RESET_I(32);
    i_master_read_data = VL_RAND_RESET_I(32);
    o_master_write = VL_RAND_RESET_I(1);
    i_master_write_ack = VL_RAND_RESET_I(1);
    o_master_write_addr = VL_RAND_RESET_I(32);
    o_master_write_data = VL_RAND_RESET_I(32);
    o_master_write_byte_enable = VL_RAND_RESET_I(4);
    ORC_R32I__DOT__i_clk = VL_RAND_RESET_I(1);
    ORC_R32I__DOT__i_reset_sync = VL_RAND_RESET_I(1);
    ORC_R32I__DOT__o_inst_read = VL_RAND_RESET_I(1);
    ORC_R32I__DOT__i_inst_read_ack = VL_RAND_RESET_I(1);
    ORC_R32I__DOT__o_inst_read_addr = VL_RAND_RESET_I(32);
    ORC_R32I__DOT__i_inst_read_data = VL_RAND_RESET_I(32);
    ORC_R32I__DOT__o_master_read = VL_RAND_RESET_I(1);
    ORC_R32I__DOT__i_master_read_ack = VL_RAND_RESET_I(1);
    ORC_R32I__DOT__o_master_read_addr = VL_RAND_RESET_I(32);
    ORC_R32I__DOT__i_master_read_data = VL_RAND_RESET_I(32);
    ORC_R32I__DOT__o_master_write = VL_RAND_RESET_I(1);
    ORC_R32I__DOT__i_master_write_ack = VL_RAND_RESET_I(1);
    ORC_R32I__DOT__o_master_write_addr = VL_RAND_RESET_I(32);
    ORC_R32I__DOT__o_master_write_data = VL_RAND_RESET_I(32);
    ORC_R32I__DOT__o_master_write_byte_enable = VL_RAND_RESET_I(4);
    ORC_R32I__DOT__r_next_pc_fetch = VL_RAND_RESET_I(32);
    ORC_R32I__DOT__r_next_pc_decode = VL_RAND_RESET_I(32);
    ORC_R32I__DOT__r_pc = VL_RAND_RESET_I(32);
    ORC_R32I__DOT__r_program_counter_valid = VL_RAND_RESET_I(1);
    ORC_R32I__DOT__r_inst_read_ack = VL_RAND_RESET_I(1);
    ORC_R32I__DOT__r_inst_data = VL_RAND_RESET_I(32);
    ORC_R32I__DOT__w_opcode = VL_RAND_RESET_I(7);
    ORC_R32I__DOT__w_pc_opcode = VL_RAND_RESET_I(7);
    ORC_R32I__DOT__r_simm = VL_RAND_RESET_I(32);
    ORC_R32I__DOT__r_uimm = VL_RAND_RESET_I(32);
    ORC_R32I__DOT__r_jalr = VL_RAND_RESET_I(1);
    ORC_R32I__DOT__r_bcc = VL_RAND_RESET_I(1);
    ORC_R32I__DOT__r_lcc = VL_RAND_RESET_I(1);
    ORC_R32I__DOT__r_scc = VL_RAND_RESET_I(1);
    ORC_R32I__DOT__r_rii = VL_RAND_RESET_I(1);
    ORC_R32I__DOT__r_rro = VL_RAND_RESET_I(1);
    for (int __Vi0=0; __Vi0<32; ++__Vi0) {
        ORC_R32I__DOT__general_registers1[__Vi0] = VL_RAND_RESET_I(32);
    }
    for (int __Vi0=0; __Vi0<32; ++__Vi0) {
        ORC_R32I__DOT__general_registers2[__Vi0] = VL_RAND_RESET_I(32);
    }
    ORC_R32I__DOT__reset_index = VL_RAND_RESET_I(5);
    ORC_R32I__DOT__r_read_ready = VL_RAND_RESET_I(1);
    ORC_R32I__DOT__r_write_ready = VL_RAND_RESET_I(1);
    ORC_R32I__DOT__r_master_read_addr = VL_RAND_RESET_I(32);
    ORC_R32I__DOT__w_rd = VL_RAND_RESET_I(5);
    ORC_R32I__DOT__w_destination_index = VL_RAND_RESET_I(5);
    ORC_R32I__DOT__w_source1_pointer = VL_RAND_RESET_I(5);
    ORC_R32I__DOT__w_source2_pointer = VL_RAND_RESET_I(5);
    ORC_R32I__DOT__w_fct3 = VL_RAND_RESET_I(3);
    ORC_R32I__DOT__w_fct7 = VL_RAND_RESET_I(7);
    ORC_R32I__DOT__r_unsigned_rs1 = VL_RAND_RESET_I(32);
    ORC_R32I__DOT__r_unsigned_rs2 = VL_RAND_RESET_I(32);
    ORC_R32I__DOT__w_signed_rs1 = VL_RAND_RESET_I(32);
    ORC_R32I__DOT__w_signed_rs2 = VL_RAND_RESET_I(32);
    ORC_R32I__DOT__w_master_addr = VL_RAND_RESET_I(32);
    ORC_R32I__DOT__w_l_data = VL_RAND_RESET_I(32);
    ORC_R32I__DOT__w_s_data = VL_RAND_RESET_I(32);
    ORC_R32I__DOT__w_signed_rs2_extended = VL_RAND_RESET_I(32);
    ORC_R32I__DOT__w_unsigned_rs2_extended = VL_RAND_RESET_I(32);
    ORC_R32I__DOT__w_rm_data = VL_RAND_RESET_I(32);
    ORC_R32I__DOT__w_jal = VL_RAND_RESET_I(1);
    ORC_R32I__DOT__w_j_simm = VL_RAND_RESET_I(32);
    ORC_R32I__DOT__w_bmux = VL_RAND_RESET_I(1);
    ORC_R32I__DOT__w_jump_request = VL_RAND_RESET_I(1);
    ORC_R32I__DOT__w_jump_value = VL_RAND_RESET_I(32);
    ORC_R32I__DOT__w_rd_not_zero = VL_RAND_RESET_I(1);
    ORC_R32I__DOT__w_destination_index_not_zero = VL_RAND_RESET_I(1);
    ORC_R32I__DOT__w_decoder_valid = VL_RAND_RESET_I(1);
    ORC_R32I__DOT__w_decoder_ready = VL_RAND_RESET_I(1);
    ORC_R32I__DOT__w_decoder_opcode = VL_RAND_RESET_I(1);
    ORC_R32I__DOT__w_program_counter_ready = VL_RAND_RESET_I(1);
    ORC_R32I__DOT__w_lui = VL_RAND_RESET_I(1);
    ORC_R32I__DOT__w_auipc = VL_RAND_RESET_I(1);
    for (int __Vi0=0; __Vi0<1; ++__Vi0) {
        __Vm_traceActivity[__Vi0] = VL_RAND_RESET_I(1);
    }
}
