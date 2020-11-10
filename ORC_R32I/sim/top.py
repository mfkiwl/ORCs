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
from orc_r321_tb_env import *
from orc_r321_test_lib import *

async def initial_run_test(dut, vif):
    from uvm.base import UVMCoreService
    cs_ = UVMCoreService.get()
    UVMConfigDb.set(None, "*", "vif", vif)
    await run_test("orc_r321_reg_test")


async def initial_reset(vif):
    await Timer(5, "NS")
    vif.i_reset_sync <= 1
    await Timer(51, "NS")
    vif.i_reset_sync <= 0


##async def always_clk(dut, ncycles):
##    #dut.i_clk <= 0
##    n = 0
##    print("EEE starting always_clk")
##    clock = Clock(dut.i_clk, 21, units="ns")  # Create a 48Mhz clock
##    while n < 2*ncycles:
##        n += 1
##        await RisingEdge(dut.i_clk)
# async def run_phase(self, phase):
#     if (vif.i_reset_sync == 0):
#         phase.raise_objection(self, " objects", 1)
#         slave_proc = cocotb.fork(memory_intfc_read_slave_seq.start(sqr))
#         await Timer(1000, "NS")
#         phase.drop_objection(self)

@cocotb.test()
async def top(dut):
    """ ORC R32I Test Bench """

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