// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vtop.h for the primary calling header

#include "Vtop.h"
#include "Vtop__Syms.h"

#include "verilated_dpi.h"

//==========

void Vtop::eval_step() {
    VL_DEBUG_IF(VL_DBG_MSGF("+++++TOP Evaluate Vtop::eval\n"); );
    Vtop__Syms* __restrict vlSymsp = this->__VlSymsp;  // Setup global symbol table
    Vtop* const __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
#ifdef VL_DEBUG
    // Debug assertions
    _eval_debug_assertions();
#endif  // VL_DEBUG
    // Initialize
    if (VL_UNLIKELY(!vlSymsp->__Vm_didInit)) _eval_initial_loop(vlSymsp);
    // Evaluate till stable
    int __VclockLoop = 0;
    QData __Vchange = 1;
    do {
        VL_DEBUG_IF(VL_DBG_MSGF("+ Clock loop\n"););
        vlSymsp->__Vm_activity = true;
        _eval(vlSymsp);
        if (VL_UNLIKELY(++__VclockLoop > 100)) {
            // About to fail, so enable debug to see what's not settling.
            // Note you must run make with OPT=-DVL_DEBUG for debug prints.
            int __Vsaved_debug = Verilated::debug();
            Verilated::debug(1);
            __Vchange = _change_request(vlSymsp);
            Verilated::debug(__Vsaved_debug);
            VL_FATAL_MT("/home/jota/Documents/HW/HDL_projects/ORCs/ORC_R32I/sim/../source/ORC_R32I.v", 49, "",
                "Verilated model didn't converge\n"
                "- See DIDNOTCONVERGE in the Verilator manual");
        } else {
            __Vchange = _change_request(vlSymsp);
        }
    } while (VL_UNLIKELY(__Vchange));
}

void Vtop::_eval_initial_loop(Vtop__Syms* __restrict vlSymsp) {
    vlSymsp->__Vm_didInit = true;
    _eval_initial(vlSymsp);
    vlSymsp->__Vm_activity = true;
    // Evaluate till stable
    int __VclockLoop = 0;
    QData __Vchange = 1;
    do {
        _eval_settle(vlSymsp);
        _eval(vlSymsp);
        if (VL_UNLIKELY(++__VclockLoop > 100)) {
            // About to fail, so enable debug to see what's not settling.
            // Note you must run make with OPT=-DVL_DEBUG for debug prints.
            int __Vsaved_debug = Verilated::debug();
            Verilated::debug(1);
            __Vchange = _change_request(vlSymsp);
            Verilated::debug(__Vsaved_debug);
            VL_FATAL_MT("/home/jota/Documents/HW/HDL_projects/ORCs/ORC_R32I/sim/../source/ORC_R32I.v", 49, "",
                "Verilated model didn't DC converge\n"
                "- See DIDNOTCONVERGE in the Verilator manual");
        } else {
            __Vchange = _change_request(vlSymsp);
        }
    } while (VL_UNLIKELY(__Vchange));
}

VL_INLINE_OPT void Vtop::_combo__TOP__1(Vtop__Syms* __restrict vlSymsp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtop::_combo__TOP__1\n"); );
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
}

VL_INLINE_OPT void Vtop::_sequent__TOP__3(Vtop__Syms* __restrict vlSymsp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtop::_sequent__TOP__3\n"); );
    Vtop* const __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    // Variables
    CData/*0:0*/ __Vdly__ORC_R32I__DOT__r_program_counter_valid;
    CData/*0:0*/ __Vdly__ORC_R32I__DOT__r_read_ready;
    CData/*0:0*/ __Vdly__ORC_R32I__DOT__r_write_ready;
    IData/*31:0*/ __Vdly__ORC_R32I__DOT__r_next_pc_fetch;
    IData/*31:0*/ __Vdly__ORC_R32I__DOT__r_next_pc_decode;
    // Body
    __Vdly__ORC_R32I__DOT__r_next_pc_decode = vlTOPp->ORC_R32I__DOT__r_next_pc_decode;
    __Vdly__ORC_R32I__DOT__r_next_pc_fetch = vlTOPp->ORC_R32I__DOT__r_next_pc_fetch;
    __Vdly__ORC_R32I__DOT__r_program_counter_valid 
        = vlTOPp->ORC_R32I__DOT__r_program_counter_valid;
    __Vdly__ORC_R32I__DOT__r_write_ready = vlTOPp->ORC_R32I__DOT__r_write_ready;
    __Vdly__ORC_R32I__DOT__r_read_ready = vlTOPp->ORC_R32I__DOT__r_read_ready;
    if (vlTOPp->i_inst_read_ack) {
        vlTOPp->ORC_R32I__DOT__r_unsigned_rs2 = vlTOPp->ORC_R32I__DOT__general_registers2
            [vlTOPp->ORC_R32I__DOT__w_source2_pointer];
    }
    if (vlTOPp->i_inst_read_ack) {
        vlTOPp->ORC_R32I__DOT__r_unsigned_rs1 = vlTOPp->ORC_R32I__DOT__general_registers1
            [vlTOPp->ORC_R32I__DOT__w_source1_pointer];
    }
    if (vlTOPp->i_reset_sync) {
        vlTOPp->ORC_R32I__DOT__reset_index = (0x1fU 
                                              & ((IData)(1U) 
                                                 + (IData)(vlTOPp->ORC_R32I__DOT__reset_index)));
        vlTOPp->ORC_R32I__DOT__general_registers1[vlTOPp->ORC_R32I__DOT__reset_index] = 0U;
        vlTOPp->ORC_R32I__DOT__general_registers2[vlTOPp->ORC_R32I__DOT__reset_index] = 0U;
    } else {
        if (vlTOPp->ORC_R32I__DOT__w_decoder_valid) {
            if (vlTOPp->ORC_R32I__DOT__r_jalr) {
                vlTOPp->ORC_R32I__DOT__general_registers1[vlTOPp->ORC_R32I__DOT__w_destination_index] 
                    = ((IData)(4U) + vlTOPp->ORC_R32I__DOT__r_next_pc_decode);
                vlTOPp->ORC_R32I__DOT__general_registers2[vlTOPp->ORC_R32I__DOT__w_destination_index] 
                    = ((IData)(4U) + vlTOPp->ORC_R32I__DOT__r_next_pc_decode);
            }
            if (vlTOPp->ORC_R32I__DOT__r_rii) {
                vlTOPp->ORC_R32I__DOT__general_registers1[vlTOPp->ORC_R32I__DOT__w_destination_index] 
                    = vlTOPp->ORC_R32I__DOT__w_rm_data;
                vlTOPp->ORC_R32I__DOT__general_registers2[vlTOPp->ORC_R32I__DOT__w_destination_index] 
                    = vlTOPp->ORC_R32I__DOT__w_rm_data;
            }
            if (vlTOPp->ORC_R32I__DOT__r_rro) {
                vlTOPp->ORC_R32I__DOT__general_registers1[vlTOPp->ORC_R32I__DOT__w_destination_index] 
                    = vlTOPp->ORC_R32I__DOT__w_rm_data;
                vlTOPp->ORC_R32I__DOT__general_registers2[vlTOPp->ORC_R32I__DOT__w_destination_index] 
                    = vlTOPp->ORC_R32I__DOT__w_rm_data;
            }
        } else {
            if (((IData)(vlTOPp->ORC_R32I__DOT__w_rd_not_zero) 
                 & (IData)(vlTOPp->i_inst_read_ack))) {
                if ((0x37U == (IData)(vlTOPp->ORC_R32I__DOT__w_opcode))) {
                    vlTOPp->ORC_R32I__DOT__general_registers1[vlTOPp->ORC_R32I__DOT__w_rd] 
                        = (0xfffff000U & vlTOPp->i_inst_read_data);
                    vlTOPp->ORC_R32I__DOT__general_registers2[vlTOPp->ORC_R32I__DOT__w_rd] 
                        = (0xfffff000U & vlTOPp->i_inst_read_data);
                }
                if ((0x17U == (IData)(vlTOPp->ORC_R32I__DOT__w_opcode))) {
                    vlTOPp->ORC_R32I__DOT__general_registers1[vlTOPp->ORC_R32I__DOT__w_rd] 
                        = (vlTOPp->ORC_R32I__DOT__r_next_pc_fetch 
                           + (0xfffff000U & vlTOPp->i_inst_read_data));
                    vlTOPp->ORC_R32I__DOT__general_registers2[vlTOPp->ORC_R32I__DOT__w_rd] 
                        = (vlTOPp->ORC_R32I__DOT__r_next_pc_fetch 
                           + (0xfffff000U & vlTOPp->i_inst_read_data));
                }
                if ((0x6fU == (IData)(vlTOPp->ORC_R32I__DOT__w_opcode))) {
                    vlTOPp->ORC_R32I__DOT__general_registers1[vlTOPp->ORC_R32I__DOT__w_rd] 
                        = ((IData)(4U) + vlTOPp->ORC_R32I__DOT__r_next_pc_fetch);
                    vlTOPp->ORC_R32I__DOT__general_registers2[vlTOPp->ORC_R32I__DOT__w_rd] 
                        = ((IData)(4U) + vlTOPp->ORC_R32I__DOT__r_next_pc_fetch);
                }
            } else {
                if (((IData)(vlTOPp->i_master_read_ack) 
                     & (~ (IData)(vlTOPp->ORC_R32I__DOT__r_inst_read_ack)))) {
                    vlTOPp->ORC_R32I__DOT__general_registers1[vlTOPp->ORC_R32I__DOT__w_destination_index] 
                        = vlTOPp->ORC_R32I__DOT__w_l_data;
                    vlTOPp->ORC_R32I__DOT__general_registers2[vlTOPp->ORC_R32I__DOT__w_destination_index] 
                        = vlTOPp->ORC_R32I__DOT__w_l_data;
                }
            }
        }
    }
    if (vlTOPp->i_reset_sync) {
        __Vdly__ORC_R32I__DOT__r_next_pc_fetch = 0U;
        __Vdly__ORC_R32I__DOT__r_next_pc_decode = 0U;
        vlTOPp->ORC_R32I__DOT__r_pc = 0U;
        __Vdly__ORC_R32I__DOT__r_program_counter_valid = 0U;
    } else {
        if (vlTOPp->ORC_R32I__DOT__w_program_counter_ready) {
            if (vlTOPp->i_inst_read_ack) {
                if (vlTOPp->ORC_R32I__DOT__w_jump_request) {
                    __Vdly__ORC_R32I__DOT__r_next_pc_fetch 
                        = vlTOPp->ORC_R32I__DOT__w_jump_value;
                    __Vdly__ORC_R32I__DOT__r_program_counter_valid 
                        = vlTOPp->ORC_R32I__DOT__w_jal;
                } else {
                    if (vlTOPp->ORC_R32I__DOT__w_decoder_ready) {
                        __Vdly__ORC_R32I__DOT__r_next_pc_fetch 
                            = ((IData)(4U) + vlTOPp->ORC_R32I__DOT__r_next_pc_fetch);
                        __Vdly__ORC_R32I__DOT__r_program_counter_valid = 1U;
                    }
                }
                vlTOPp->ORC_R32I__DOT__r_pc = vlTOPp->ORC_R32I__DOT__r_next_pc_decode;
                __Vdly__ORC_R32I__DOT__r_next_pc_decode 
                    = vlTOPp->ORC_R32I__DOT__r_next_pc_fetch;
            } else {
                if (vlTOPp->ORC_R32I__DOT__r_program_counter_valid) {
                    __Vdly__ORC_R32I__DOT__r_program_counter_valid = 0U;
                } else {
                    if (vlTOPp->ORC_R32I__DOT__r_inst_read_ack) {
                        if (vlTOPp->ORC_R32I__DOT__w_jump_request) {
                            __Vdly__ORC_R32I__DOT__r_program_counter_valid 
                                = ((IData)(vlTOPp->ORC_R32I__DOT__r_program_counter_valid) 
                                   <= (IData)(vlTOPp->ORC_R32I__DOT__w_jal));
                            __Vdly__ORC_R32I__DOT__r_next_pc_fetch 
                                = vlTOPp->ORC_R32I__DOT__w_jump_value;
                        } else {
                            if (vlTOPp->ORC_R32I__DOT__w_decoder_ready) {
                                __Vdly__ORC_R32I__DOT__r_next_pc_fetch 
                                    = ((IData)(4U) 
                                       + vlTOPp->ORC_R32I__DOT__r_next_pc_fetch);
                                __Vdly__ORC_R32I__DOT__r_program_counter_valid = 1U;
                            }
                        }
                        vlTOPp->ORC_R32I__DOT__r_pc 
                            = vlTOPp->ORC_R32I__DOT__r_next_pc_decode;
                        __Vdly__ORC_R32I__DOT__r_next_pc_decode 
                            = vlTOPp->ORC_R32I__DOT__r_next_pc_fetch;
                    } else {
                        __Vdly__ORC_R32I__DOT__r_program_counter_valid = 1U;
                    }
                }
            }
        } else {
            __Vdly__ORC_R32I__DOT__r_program_counter_valid = 0U;
        }
    }
    vlTOPp->ORC_R32I__DOT__r_bcc = ((~ (IData)(vlTOPp->i_reset_sync)) 
                                    & ((((IData)(vlTOPp->ORC_R32I__DOT__w_decoder_ready) 
                                         & (IData)(vlTOPp->ORC_R32I__DOT__r_inst_read_ack)) 
                                        & (IData)(vlTOPp->ORC_R32I__DOT__w_destination_index_not_zero)) 
                                       & (0x63U == (IData)(vlTOPp->ORC_R32I__DOT__w_pc_opcode))));
    if (vlTOPp->i_reset_sync) {
        __Vdly__ORC_R32I__DOT__r_write_ready = 1U;
    } else {
        if (((IData)(vlTOPp->ORC_R32I__DOT__r_write_ready) 
             & (IData)(vlTOPp->ORC_R32I__DOT__r_scc))) {
            __Vdly__ORC_R32I__DOT__r_write_ready = 0U;
        } else {
            if (((~ (IData)(vlTOPp->ORC_R32I__DOT__r_write_ready)) 
                 & (IData)(vlTOPp->i_master_write_ack))) {
                __Vdly__ORC_R32I__DOT__r_write_ready = 1U;
            }
        }
    }
    if (vlTOPp->i_reset_sync) {
        __Vdly__ORC_R32I__DOT__r_read_ready = 1U;
        vlTOPp->ORC_R32I__DOT__r_master_read_addr = 0U;
    } else {
        if (((IData)(vlTOPp->ORC_R32I__DOT__r_read_ready) 
             & (IData)(vlTOPp->ORC_R32I__DOT__r_lcc))) {
            __Vdly__ORC_R32I__DOT__r_read_ready = 0U;
            vlTOPp->ORC_R32I__DOT__r_master_read_addr 
                = vlTOPp->ORC_R32I__DOT__w_master_addr;
        } else {
            if (((~ (IData)(vlTOPp->ORC_R32I__DOT__r_read_ready)) 
                 & (IData)(vlTOPp->i_master_read_ack))) {
                __Vdly__ORC_R32I__DOT__r_read_ready = 1U;
            }
        }
    }
    if (vlTOPp->i_reset_sync) {
        vlTOPp->ORC_R32I__DOT__r_uimm = 0U;
    } else {
        if ((((IData)(vlTOPp->ORC_R32I__DOT__w_decoder_ready) 
              & (IData)(vlTOPp->ORC_R32I__DOT__r_inst_read_ack)) 
             & (IData)(vlTOPp->ORC_R32I__DOT__w_destination_index_not_zero))) {
            if ((0x13U == (IData)(vlTOPp->ORC_R32I__DOT__w_pc_opcode))) {
                vlTOPp->ORC_R32I__DOT__r_uimm = (0xfffU 
                                                 & (vlTOPp->ORC_R32I__DOT__r_inst_data 
                                                    >> 0x14U));
            }
        }
    }
    if (vlTOPp->i_reset_sync) {
        vlTOPp->ORC_R32I__DOT__r_simm = 0U;
    } else {
        if ((((IData)(vlTOPp->ORC_R32I__DOT__w_decoder_ready) 
              & (IData)(vlTOPp->ORC_R32I__DOT__r_inst_read_ack)) 
             & (IData)(vlTOPp->ORC_R32I__DOT__w_destination_index_not_zero))) {
            if ((0x13U == (IData)(vlTOPp->ORC_R32I__DOT__w_pc_opcode))) {
                vlTOPp->ORC_R32I__DOT__r_simm = (((
                                                   (0x80000000U 
                                                    & vlTOPp->ORC_R32I__DOT__r_inst_data)
                                                    ? 0xfffffU
                                                    : 0U) 
                                                  << 0xcU) 
                                                 | (0xfffU 
                                                    & (vlTOPp->ORC_R32I__DOT__r_inst_data 
                                                       >> 0x14U)));
            }
            if ((0x67U == (IData)(vlTOPp->ORC_R32I__DOT__w_pc_opcode))) {
                vlTOPp->ORC_R32I__DOT__r_simm = (((
                                                   (0x80000000U 
                                                    & vlTOPp->ORC_R32I__DOT__r_inst_data)
                                                    ? 0xfffffU
                                                    : 0U) 
                                                  << 0xcU) 
                                                 | (0xfffU 
                                                    & (vlTOPp->ORC_R32I__DOT__r_inst_data 
                                                       >> 0x14U)));
            }
            if ((0x63U == (IData)(vlTOPp->ORC_R32I__DOT__w_pc_opcode))) {
                vlTOPp->ORC_R32I__DOT__r_simm = (((
                                                   (0x80000000U 
                                                    & vlTOPp->ORC_R32I__DOT__r_inst_data)
                                                    ? 0x7ffffU
                                                    : 0U) 
                                                  << 0xdU) 
                                                 | ((0x1000U 
                                                     & (vlTOPp->ORC_R32I__DOT__r_inst_data 
                                                        >> 0x13U)) 
                                                    | ((0x800U 
                                                        & (vlTOPp->ORC_R32I__DOT__r_inst_data 
                                                           << 4U)) 
                                                       | ((0x7e0U 
                                                           & (vlTOPp->ORC_R32I__DOT__r_inst_data 
                                                              >> 0x14U)) 
                                                          | (0x1eU 
                                                             & (vlTOPp->ORC_R32I__DOT__r_inst_data 
                                                                >> 7U))))));
            }
            if ((3U == (IData)(vlTOPp->ORC_R32I__DOT__w_pc_opcode))) {
                vlTOPp->ORC_R32I__DOT__r_simm = (((
                                                   (0x80000000U 
                                                    & vlTOPp->ORC_R32I__DOT__r_inst_data)
                                                    ? 0xfffffU
                                                    : 0U) 
                                                  << 0xcU) 
                                                 | (0xfffU 
                                                    & (vlTOPp->ORC_R32I__DOT__r_inst_data 
                                                       >> 0x14U)));
            }
            if ((0x23U == (IData)(vlTOPp->ORC_R32I__DOT__w_pc_opcode))) {
                vlTOPp->ORC_R32I__DOT__r_simm = (((
                                                   (0x80000000U 
                                                    & vlTOPp->ORC_R32I__DOT__r_inst_data)
                                                    ? 0xfffffU
                                                    : 0U) 
                                                  << 0xcU) 
                                                 | ((0xfe0U 
                                                     & (vlTOPp->ORC_R32I__DOT__r_inst_data 
                                                        >> 0x14U)) 
                                                    | (0x1fU 
                                                       & (vlTOPp->ORC_R32I__DOT__r_inst_data 
                                                          >> 7U))));
            }
        }
    }
    vlTOPp->ORC_R32I__DOT__w_signed_rs2 = vlTOPp->ORC_R32I__DOT__r_unsigned_rs2;
    vlTOPp->ORC_R32I__DOT__w_signed_rs1 = vlTOPp->ORC_R32I__DOT__r_unsigned_rs1;
    vlTOPp->ORC_R32I__DOT__r_next_pc_decode = __Vdly__ORC_R32I__DOT__r_next_pc_decode;
    vlTOPp->ORC_R32I__DOT__r_next_pc_fetch = __Vdly__ORC_R32I__DOT__r_next_pc_fetch;
    vlTOPp->ORC_R32I__DOT__r_program_counter_valid 
        = __Vdly__ORC_R32I__DOT__r_program_counter_valid;
    vlTOPp->ORC_R32I__DOT__r_write_ready = __Vdly__ORC_R32I__DOT__r_write_ready;
    vlTOPp->ORC_R32I__DOT__r_read_ready = __Vdly__ORC_R32I__DOT__r_read_ready;
    vlTOPp->ORC_R32I__DOT__r_rro = ((~ (IData)(vlTOPp->i_reset_sync)) 
                                    & ((((IData)(vlTOPp->ORC_R32I__DOT__w_decoder_ready) 
                                         & (IData)(vlTOPp->ORC_R32I__DOT__r_inst_read_ack)) 
                                        & (IData)(vlTOPp->ORC_R32I__DOT__w_destination_index_not_zero)) 
                                       & (0x33U == (IData)(vlTOPp->ORC_R32I__DOT__w_pc_opcode))));
    vlTOPp->ORC_R32I__DOT__r_jalr = ((~ (IData)(vlTOPp->i_reset_sync)) 
                                     & ((((IData)(vlTOPp->ORC_R32I__DOT__w_decoder_ready) 
                                          & (IData)(vlTOPp->ORC_R32I__DOT__r_inst_read_ack)) 
                                         & (IData)(vlTOPp->ORC_R32I__DOT__w_destination_index_not_zero)) 
                                        & (0x67U == (IData)(vlTOPp->ORC_R32I__DOT__w_pc_opcode))));
    vlTOPp->ORC_R32I__DOT__r_rii = ((~ (IData)(vlTOPp->i_reset_sync)) 
                                    & ((((IData)(vlTOPp->ORC_R32I__DOT__w_decoder_ready) 
                                         & (IData)(vlTOPp->ORC_R32I__DOT__r_inst_read_ack)) 
                                        & (IData)(vlTOPp->ORC_R32I__DOT__w_destination_index_not_zero)) 
                                       & (0x13U == (IData)(vlTOPp->ORC_R32I__DOT__w_pc_opcode))));
    vlTOPp->ORC_R32I__DOT__o_inst_read_addr = vlTOPp->ORC_R32I__DOT__r_next_pc_fetch;
    vlTOPp->ORC_R32I__DOT__o_inst_read = vlTOPp->ORC_R32I__DOT__r_program_counter_valid;
    vlTOPp->ORC_R32I__DOT__r_scc = ((~ (IData)(vlTOPp->i_reset_sync)) 
                                    & ((((IData)(vlTOPp->ORC_R32I__DOT__w_decoder_ready) 
                                         & (IData)(vlTOPp->ORC_R32I__DOT__r_inst_read_ack)) 
                                        & (IData)(vlTOPp->ORC_R32I__DOT__w_destination_index_not_zero)) 
                                       & (0x23U == (IData)(vlTOPp->ORC_R32I__DOT__w_pc_opcode))));
    vlTOPp->ORC_R32I__DOT__r_lcc = ((~ (IData)(vlTOPp->i_reset_sync)) 
                                    & ((((IData)(vlTOPp->ORC_R32I__DOT__w_decoder_ready) 
                                         & (IData)(vlTOPp->ORC_R32I__DOT__r_inst_read_ack)) 
                                        & (IData)(vlTOPp->ORC_R32I__DOT__w_destination_index_not_zero)) 
                                       & (3U == (IData)(vlTOPp->ORC_R32I__DOT__w_pc_opcode))));
    vlTOPp->ORC_R32I__DOT__w_master_addr = (vlTOPp->ORC_R32I__DOT__r_unsigned_rs1 
                                            + vlTOPp->ORC_R32I__DOT__r_simm);
    if ((1U & (~ (IData)(vlTOPp->i_reset_sync)))) {
        if (vlTOPp->i_inst_read_ack) {
            vlTOPp->ORC_R32I__DOT__r_inst_data = vlTOPp->i_inst_read_data;
        }
    }
    vlTOPp->o_inst_read_addr = vlTOPp->ORC_R32I__DOT__o_inst_read_addr;
    vlTOPp->o_inst_read = vlTOPp->ORC_R32I__DOT__o_inst_read;
    vlTOPp->ORC_R32I__DOT__o_master_read_addr = vlTOPp->ORC_R32I__DOT__w_master_addr;
    vlTOPp->ORC_R32I__DOT__o_master_write_addr = vlTOPp->ORC_R32I__DOT__w_master_addr;
    if (vlTOPp->ORC_R32I__DOT__r_rii) {
        vlTOPp->ORC_R32I__DOT__w_signed_rs2_extended 
            = vlTOPp->ORC_R32I__DOT__r_simm;
        vlTOPp->ORC_R32I__DOT__w_unsigned_rs2_extended 
            = vlTOPp->ORC_R32I__DOT__r_uimm;
    } else {
        vlTOPp->ORC_R32I__DOT__w_signed_rs2_extended 
            = vlTOPp->ORC_R32I__DOT__w_signed_rs2;
        vlTOPp->ORC_R32I__DOT__w_unsigned_rs2_extended 
            = vlTOPp->ORC_R32I__DOT__r_unsigned_rs2;
    }
    vlTOPp->ORC_R32I__DOT__o_master_write = vlTOPp->ORC_R32I__DOT__r_scc;
    if ((1U & (~ (IData)(vlTOPp->i_reset_sync)))) {
        vlTOPp->ORC_R32I__DOT__r_inst_read_ack = vlTOPp->i_inst_read_ack;
    }
    vlTOPp->ORC_R32I__DOT__o_master_read = vlTOPp->ORC_R32I__DOT__r_lcc;
    vlTOPp->ORC_R32I__DOT__w_decoder_valid = ((((((IData)(vlTOPp->ORC_R32I__DOT__r_jalr) 
                                                  | (IData)(vlTOPp->ORC_R32I__DOT__r_bcc)) 
                                                 | (IData)(vlTOPp->ORC_R32I__DOT__r_rii)) 
                                                | (IData)(vlTOPp->ORC_R32I__DOT__r_rro)) 
                                               | (IData)(vlTOPp->ORC_R32I__DOT__r_lcc)) 
                                              | (IData)(vlTOPp->ORC_R32I__DOT__r_scc));
    vlTOPp->o_master_read_addr = vlTOPp->ORC_R32I__DOT__o_master_read_addr;
    vlTOPp->o_master_write_addr = vlTOPp->ORC_R32I__DOT__o_master_write_addr;
    vlTOPp->ORC_R32I__DOT__w_pc_opcode = (0x7fU & vlTOPp->ORC_R32I__DOT__r_inst_data);
    vlTOPp->ORC_R32I__DOT__w_destination_index = (0x1fU 
                                                  & (vlTOPp->ORC_R32I__DOT__r_inst_data 
                                                     >> 7U));
    vlTOPp->ORC_R32I__DOT__w_fct7 = (0x7fU & (vlTOPp->ORC_R32I__DOT__r_inst_data 
                                              >> 0x19U));
    vlTOPp->ORC_R32I__DOT__w_fct3 = (7U & (vlTOPp->ORC_R32I__DOT__r_inst_data 
                                           >> 0xcU));
    vlTOPp->o_master_write = vlTOPp->ORC_R32I__DOT__o_master_write;
    vlTOPp->o_master_read = vlTOPp->ORC_R32I__DOT__o_master_read;
    vlTOPp->ORC_R32I__DOT__w_decoder_ready = (((~ (IData)(vlTOPp->ORC_R32I__DOT__w_decoder_valid)) 
                                               & (IData)(vlTOPp->ORC_R32I__DOT__r_read_ready)) 
                                              & (IData)(vlTOPp->ORC_R32I__DOT__r_write_ready));
    vlTOPp->ORC_R32I__DOT__w_destination_index_not_zero 
        = (0U != (IData)(vlTOPp->ORC_R32I__DOT__w_destination_index));
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
    vlTOPp->ORC_R32I__DOT__o_master_write_byte_enable 
        = (((0U == (IData)(vlTOPp->ORC_R32I__DOT__w_fct3)) 
            | (4U == (IData)(vlTOPp->ORC_R32I__DOT__w_fct3)))
            ? ((3U == (3U & vlTOPp->ORC_R32I__DOT__w_master_addr))
                ? 8U : ((2U == (3U & vlTOPp->ORC_R32I__DOT__w_master_addr))
                         ? 4U : ((1U == (3U & vlTOPp->ORC_R32I__DOT__w_master_addr))
                                  ? 2U : 1U))) : ((
                                                   (1U 
                                                    == (IData)(vlTOPp->ORC_R32I__DOT__w_fct3)) 
                                                   | (5U 
                                                      == (IData)(vlTOPp->ORC_R32I__DOT__w_fct3)))
                                                   ? 
                                                  ((2U 
                                                    & vlTOPp->ORC_R32I__DOT__w_master_addr)
                                                    ? 0xcU
                                                    : 3U)
                                                   : 0xfU));
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
    vlTOPp->o_master_write_byte_enable = vlTOPp->ORC_R32I__DOT__o_master_write_byte_enable;
    vlTOPp->ORC_R32I__DOT__o_master_write_data = vlTOPp->ORC_R32I__DOT__w_s_data;
    vlTOPp->o_master_write_data = vlTOPp->ORC_R32I__DOT__o_master_write_data;
}

VL_INLINE_OPT void Vtop::_combo__TOP__5(Vtop__Syms* __restrict vlSymsp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtop::_combo__TOP__5\n"); );
    Vtop* const __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    // Body
    vlTOPp->ORC_R32I__DOT__w_source2_pointer = (0x1fU 
                                                & (vlTOPp->i_inst_read_data 
                                                   >> 0x14U));
    vlTOPp->ORC_R32I__DOT__w_source1_pointer = (0x1fU 
                                                & (vlTOPp->i_inst_read_data 
                                                   >> 0xfU));
    vlTOPp->ORC_R32I__DOT__w_rd = (0x1fU & (vlTOPp->i_inst_read_data 
                                            >> 7U));
    vlTOPp->ORC_R32I__DOT__w_opcode = (0x7fU & vlTOPp->i_inst_read_data);
    vlTOPp->ORC_R32I__DOT__w_l_data = (((0U == (IData)(vlTOPp->ORC_R32I__DOT__w_fct3)) 
                                        | (4U == (IData)(vlTOPp->ORC_R32I__DOT__w_fct3)))
                                        ? ((3U == (3U 
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
                                                       & vlTOPp->i_master_read_data)))))
                                        : (((1U == (IData)(vlTOPp->ORC_R32I__DOT__w_fct3)) 
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
                                            : vlTOPp->i_master_read_data));
    vlTOPp->ORC_R32I__DOT__w_jump_value = ((IData)(vlTOPp->ORC_R32I__DOT__w_bmux)
                                            ? (vlTOPp->ORC_R32I__DOT__r_simm 
                                               + vlTOPp->ORC_R32I__DOT__r_next_pc_decode)
                                            : ((IData)(vlTOPp->ORC_R32I__DOT__r_jalr)
                                                ? (vlTOPp->ORC_R32I__DOT__r_simm 
                                                   + vlTOPp->ORC_R32I__DOT__r_unsigned_rs1)
                                                : (vlTOPp->ORC_R32I__DOT__w_j_simm 
                                                   + vlTOPp->ORC_R32I__DOT__r_next_pc_decode)));
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
    vlTOPp->ORC_R32I__DOT__w_program_counter_ready 
        = (1U & ((((IData)(vlTOPp->ORC_R32I__DOT__w_decoder_ready) 
                   & (IData)(vlTOPp->ORC_R32I__DOT__r_program_counter_valid)) 
                  & (~ (IData)(vlTOPp->ORC_R32I__DOT__w_decoder_opcode))) 
                 | (~ (IData)(vlTOPp->ORC_R32I__DOT__r_program_counter_valid))));
    vlTOPp->ORC_R32I__DOT__w_jump_request = (((IData)(vlTOPp->ORC_R32I__DOT__w_jal) 
                                              | (IData)(vlTOPp->ORC_R32I__DOT__r_jalr)) 
                                             | (IData)(vlTOPp->ORC_R32I__DOT__w_bmux));
}

void Vtop::_eval(Vtop__Syms* __restrict vlSymsp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtop::_eval\n"); );
    Vtop* const __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    // Body
    vlTOPp->_combo__TOP__1(vlSymsp);
    if (((IData)(vlTOPp->i_clk) & (~ (IData)(vlTOPp->__Vclklast__TOP__i_clk)))) {
        vlTOPp->_sequent__TOP__3(vlSymsp);
    }
    vlTOPp->_combo__TOP__5(vlSymsp);
    // Final
    vlTOPp->__Vclklast__TOP__i_clk = vlTOPp->i_clk;
}

VL_INLINE_OPT QData Vtop::_change_request(Vtop__Syms* __restrict vlSymsp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtop::_change_request\n"); );
    Vtop* const __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    // Body
    return (vlTOPp->_change_request_1(vlSymsp));
}

VL_INLINE_OPT QData Vtop::_change_request_1(Vtop__Syms* __restrict vlSymsp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtop::_change_request_1\n"); );
    Vtop* const __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    // Body
    // Change detection
    QData __req = false;  // Logically a bool
    return __req;
}

#ifdef VL_DEBUG
void Vtop::_eval_debug_assertions() {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtop::_eval_debug_assertions\n"); );
    // Body
    if (VL_UNLIKELY((i_clk & 0xfeU))) {
        Verilated::overWidthError("i_clk");}
    if (VL_UNLIKELY((i_reset_sync & 0xfeU))) {
        Verilated::overWidthError("i_reset_sync");}
    if (VL_UNLIKELY((i_inst_read_ack & 0xfeU))) {
        Verilated::overWidthError("i_inst_read_ack");}
    if (VL_UNLIKELY((i_master_read_ack & 0xfeU))) {
        Verilated::overWidthError("i_master_read_ack");}
    if (VL_UNLIKELY((i_master_write_ack & 0xfeU))) {
        Verilated::overWidthError("i_master_write_ack");}
}
#endif  // VL_DEBUG
