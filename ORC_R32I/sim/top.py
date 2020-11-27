# test_ORC_R32I.py
import random
import cocotb
from cocotb.triggers import Timer
from cocotb.clock import Clock
from uvm.base import run_test, UVMDebug
from uvm.base.uvm_phase import UVMPhase
from uvm.seq import UVMSequence
from memory_intfc_read_slave_seq import *
from memory_intfc_read_slave_agent import *
from memory_intfc_read_slave_config import *
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

    vif = memory_intfc_read_slave_if(dut)
    clock = Clock(dut.i_clk, 10, units="ns")  # Create a 100Mhz clock
    cocotb.fork(clock.start())  # Start the clock
    cocotb.fork(initial_reset(dut))
    #proc_run_test = cocotb.fork(initial_run_test(dut, vif))
    cocotb.fork(initial_run_test(dut, vif))
    #proc_clk = cocotb.fork(always_clk(dut, 100))

    await Timer(999, "NS")
    #await [proc_run_test, proc_reset.join()]
    #await sv.fork_join([proc_run_test, proc_reset])