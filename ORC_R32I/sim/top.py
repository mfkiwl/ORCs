# test_ORC_R32I.py
import random
import cocotb
import sys
# insert at 1, 0 is the script path (or '' in REPL)
sys.path.append('uvm_externals/Wishbone_Pipeline_Master/')
from cocotb.triggers import Timer
from cocotb.clock import Clock
from uvm.base import run_test, UVMDebug
from uvm.base.uvm_phase import UVMPhase
from uvm.seq import UVMSequence
from uvm_externals.Wishbone_Pipeline_Master.wb_master_if import *
from tb_env_config import *
from orc_r32i_tb_env import *
from orc_r32i_test_lib import *

async def initial_run_test(dut, vif):
    from uvm.base import UVMCoreService
    cs_ = UVMCoreService.get()
    UVMConfigDb.set(None, "*", "vif", vif)
    await run_test("orc_r32i_reg_test")


async def initial_reset(vif):
    await Timer(0, "NS")
    vif.i_reset_sync <= 1
    await Timer(330, "NS") # clock*32 + 1 to clear all general register which are BRAM
    vif.i_reset_sync <= 0


@cocotb.test()
async def top(dut):
    """ ORC R32I Test Bench Top """


    # Map the signals in the DUT to the interface
    bus_map = {"clk_i"   : "i_clk", 
               "rst_i"   : "i_reset_sync",
               "adr_o"   : "o_inst_read_addr", 
               "dat_i"   : "i_inst_read_data",
               "dat_o"   : "", 
               "we_o"    : "",
               "sel_o"   : "",
               "stb_o"   : "o_inst_read_stb",
               "ack_i"   : "i_inst_read_ack",
               "cyc_o"   : "",
               "stall_i" : "",
               "tga_o"   : "",
               "tgd_i"   : "",
               "tgd_o"   : "",
               "tgc_o"   : ""}
 
    vif = wb_master_if(dut, bus_map)
    clock = Clock(dut.i_clk, 10, units="ns")  # Create a 100Mhz clock
    cocotb.fork(clock.start())  # Start the clock
    cocotb.fork(initial_reset(dut))
    #proc_run_test = cocotb.fork(initial_run_test(dut, vif))
    cocotb.fork(initial_run_test(dut, vif))
    #proc_clk = cocotb.fork(always_clk(dut, 100))

    await Timer(999, "NS")
    #await [proc_run_test, proc_reset.join()]
    #await sv.fork_join([proc_run_test, proc_reset])