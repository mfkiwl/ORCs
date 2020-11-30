// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Primary design header
//
// This header should be included by all source files instantiating the design.
// The class here is then constructed to instantiate the design.
// See the Verilator manual for examples.

#ifndef _VTOP_H_
#define _VTOP_H_  // guard

#include "verilated.h"
#include "Vtop__Dpi.h"

//==========

class Vtop__Syms;
class Vtop_VerilatedVcd;


//----------

VL_MODULE(Vtop) {
  public:
    
    // PORTS
    // The application code writes and reads these signals to
    // propagate new values into/out from the Verilated model.
    VL_IN8(i_clk,0,0);
    VL_IN8(i_reset_sync,0,0);
    VL_OUT8(o_inst_read,0,0);
    VL_IN8(i_inst_read_ack,0,0);
    VL_OUT8(o_master_read,0,0);
    VL_IN8(i_master_read_ack,0,0);
    VL_OUT8(o_master_write,0,0);
    VL_IN8(i_master_write_ack,0,0);
    VL_OUT8(o_master_write_byte_enable,3,0);
    VL_OUT(o_inst_read_addr,31,0);
    VL_IN(i_inst_read_data,31,0);
    VL_OUT(o_master_read_addr,31,0);
    VL_IN(i_master_read_data,31,0);
    VL_OUT(o_master_write_addr,31,0);
    VL_OUT(o_master_write_data,31,0);
    
    // LOCAL SIGNALS
    // Internals; generally not touched by application code
    // Anonymous structures to workaround compiler member-count bugs
    struct {
        CData/*0:0*/ ORC_R32I__DOT__i_clk;
        CData/*0:0*/ ORC_R32I__DOT__i_reset_sync;
        CData/*0:0*/ ORC_R32I__DOT__o_inst_read;
        CData/*0:0*/ ORC_R32I__DOT__i_inst_read_ack;
        CData/*0:0*/ ORC_R32I__DOT__o_master_read;
        CData/*0:0*/ ORC_R32I__DOT__i_master_read_ack;
        CData/*0:0*/ ORC_R32I__DOT__o_master_write;
        CData/*0:0*/ ORC_R32I__DOT__i_master_write_ack;
        CData/*3:0*/ ORC_R32I__DOT__o_master_write_byte_enable;
        CData/*0:0*/ ORC_R32I__DOT__r_program_counter_valid;
        CData/*0:0*/ ORC_R32I__DOT__r_inst_read_ack;
        CData/*6:0*/ ORC_R32I__DOT__w_opcode;
        CData/*6:0*/ ORC_R32I__DOT__w_pc_opcode;
        CData/*0:0*/ ORC_R32I__DOT__r_jalr;
        CData/*0:0*/ ORC_R32I__DOT__r_bcc;
        CData/*0:0*/ ORC_R32I__DOT__r_lcc;
        CData/*0:0*/ ORC_R32I__DOT__r_scc;
        CData/*0:0*/ ORC_R32I__DOT__r_rii;
        CData/*0:0*/ ORC_R32I__DOT__r_rro;
        CData/*4:0*/ ORC_R32I__DOT__reset_index;
        CData/*0:0*/ ORC_R32I__DOT__r_read_ready;
        CData/*0:0*/ ORC_R32I__DOT__r_write_ready;
        CData/*4:0*/ ORC_R32I__DOT__w_rd;
        CData/*4:0*/ ORC_R32I__DOT__w_destination_index;
        CData/*4:0*/ ORC_R32I__DOT__w_source1_pointer;
        CData/*4:0*/ ORC_R32I__DOT__w_source2_pointer;
        CData/*2:0*/ ORC_R32I__DOT__w_fct3;
        CData/*6:0*/ ORC_R32I__DOT__w_fct7;
        CData/*0:0*/ ORC_R32I__DOT__w_jal;
        CData/*0:0*/ ORC_R32I__DOT__w_bmux;
        CData/*0:0*/ ORC_R32I__DOT__w_jump_request;
        CData/*0:0*/ ORC_R32I__DOT__w_rd_not_zero;
        CData/*0:0*/ ORC_R32I__DOT__w_destination_index_not_zero;
        CData/*0:0*/ ORC_R32I__DOT__w_decoder_valid;
        CData/*0:0*/ ORC_R32I__DOT__w_decoder_ready;
        CData/*0:0*/ ORC_R32I__DOT__w_decoder_opcode;
        CData/*0:0*/ ORC_R32I__DOT__w_program_counter_ready;
        CData/*0:0*/ ORC_R32I__DOT__w_lui;
        CData/*0:0*/ ORC_R32I__DOT__w_auipc;
        IData/*31:0*/ ORC_R32I__DOT__o_inst_read_addr;
        IData/*31:0*/ ORC_R32I__DOT__i_inst_read_data;
        IData/*31:0*/ ORC_R32I__DOT__o_master_read_addr;
        IData/*31:0*/ ORC_R32I__DOT__i_master_read_data;
        IData/*31:0*/ ORC_R32I__DOT__o_master_write_addr;
        IData/*31:0*/ ORC_R32I__DOT__o_master_write_data;
        IData/*31:0*/ ORC_R32I__DOT__r_next_pc_fetch;
        IData/*31:0*/ ORC_R32I__DOT__r_next_pc_decode;
        IData/*31:0*/ ORC_R32I__DOT__r_pc;
        IData/*31:0*/ ORC_R32I__DOT__r_inst_data;
        IData/*31:0*/ ORC_R32I__DOT__r_simm;
        IData/*31:0*/ ORC_R32I__DOT__r_uimm;
        IData/*31:0*/ ORC_R32I__DOT__r_master_read_addr;
        IData/*31:0*/ ORC_R32I__DOT__r_unsigned_rs1;
        IData/*31:0*/ ORC_R32I__DOT__r_unsigned_rs2;
        IData/*31:0*/ ORC_R32I__DOT__w_signed_rs1;
        IData/*31:0*/ ORC_R32I__DOT__w_signed_rs2;
        IData/*31:0*/ ORC_R32I__DOT__w_master_addr;
        IData/*31:0*/ ORC_R32I__DOT__w_l_data;
        IData/*31:0*/ ORC_R32I__DOT__w_s_data;
        IData/*31:0*/ ORC_R32I__DOT__w_signed_rs2_extended;
        IData/*31:0*/ ORC_R32I__DOT__w_unsigned_rs2_extended;
        IData/*31:0*/ ORC_R32I__DOT__w_rm_data;
        IData/*31:0*/ ORC_R32I__DOT__w_j_simm;
        IData/*31:0*/ ORC_R32I__DOT__w_jump_value;
    };
    struct {
        IData/*31:0*/ ORC_R32I__DOT__general_registers1[32];
        IData/*31:0*/ ORC_R32I__DOT__general_registers2[32];
    };
    
    // LOCAL VARIABLES
    // Internals; generally not touched by application code
    CData/*0:0*/ __Vclklast__TOP__i_clk;
    CData/*0:0*/ __Vm_traceActivity[1];
    
    // INTERNAL VARIABLES
    // Internals; generally not touched by application code
    Vtop__Syms* __VlSymsp;  // Symbol table
    
    // CONSTRUCTORS
  private:
    VL_UNCOPYABLE(Vtop);  ///< Copying not allowed
  public:
    /// Construct the model; called by application code
    /// The special name  may be used to make a wrapper with a
    /// single model invisible with respect to DPI scope names.
    Vtop(const char* name = "TOP");
    /// Destroy the model; called (often implicitly) by application code
    ~Vtop();
    /// Trace signals in the model; called by application code
    void trace(VerilatedVcdC* tfp, int levels, int options = 0);
    
    // API METHODS
    /// Evaluate the model.  Application must call when inputs change.
    void eval() { eval_step(); }
    /// Evaluate when calling multiple units/models per time step.
    void eval_step();
    /// Evaluate at end of a timestep for tracing, when using eval_step().
    /// Application must call after all eval() and before time changes.
    void eval_end_step() {}
    /// Simulation complete, run final blocks.  Application must call on completion.
    void final();
    
    // INTERNAL METHODS
  private:
    static void _eval_initial_loop(Vtop__Syms* __restrict vlSymsp);
  public:
    void __Vconfigure(Vtop__Syms* symsp, bool first);
  private:
    static QData _change_request(Vtop__Syms* __restrict vlSymsp);
    static QData _change_request_1(Vtop__Syms* __restrict vlSymsp);
  public:
    static void _combo__TOP__1(Vtop__Syms* __restrict vlSymsp);
    static void _combo__TOP__5(Vtop__Syms* __restrict vlSymsp);
  private:
    void _ctor_var_reset() VL_ATTR_COLD;
  public:
    static void _eval(Vtop__Syms* __restrict vlSymsp);
  private:
#ifdef VL_DEBUG
    void _eval_debug_assertions();
#endif  // VL_DEBUG
  public:
    static void _eval_initial(Vtop__Syms* __restrict vlSymsp) VL_ATTR_COLD;
    static void _eval_settle(Vtop__Syms* __restrict vlSymsp) VL_ATTR_COLD;
    static void _initial__TOP__4(Vtop__Syms* __restrict vlSymsp) VL_ATTR_COLD;
    static void _sequent__TOP__3(Vtop__Syms* __restrict vlSymsp);
    static void _settle__TOP__2(Vtop__Syms* __restrict vlSymsp) VL_ATTR_COLD;
  private:
    static void traceChgSub0(void* userp, VerilatedVcd* tracep);
    static void traceChgTop0(void* userp, VerilatedVcd* tracep);
    static void traceCleanup(void* userp, VerilatedVcd* /*unused*/);
    static void traceFullSub0(void* userp, VerilatedVcd* tracep) VL_ATTR_COLD;
    static void traceFullTop0(void* userp, VerilatedVcd* tracep) VL_ATTR_COLD;
    static void traceInitSub0(void* userp, VerilatedVcd* tracep) VL_ATTR_COLD;
    static void traceInitTop(void* userp, VerilatedVcd* tracep) VL_ATTR_COLD;
    void traceRegister(VerilatedVcd* tracep) VL_ATTR_COLD;
    static void traceInit(void* userp, VerilatedVcd* tracep, uint32_t code) VL_ATTR_COLD;
} VL_ATTR_ALIGNED(VL_CACHE_LINE_BYTES);

//----------


#endif  // guard
