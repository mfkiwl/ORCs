# test_BlackIceR32E.py

import random
import cocotb
from cocotb.clock import Clock
from cocotb.triggers import FallingEdge

@cocotb.test()
async def test_BlackIceR32E(dut):
    """ Test test_BlackIceR32E """

    clock = Clock(dut.i_clk, 20, units="ns")  # Create a 10us period clock on port clk
    cocotb.fork(clock.start())  # Start the clock

    dut.i_reset_sync <= 1
    dut.UART_RXD <= 1

    for i in range(10):
        await FallingEdge(dut.i_clk)

    dut.i_reset_sync <= 0

    for i in range(10):
        val = random.randint(0, 1)
        dut.UART_RXD <= val  # Assign the random value val to the input port d
        await FallingEdge(dut.i_clk)
       # assert dut.o_inst_addr_valid == 1, "output o_inst_addr_valid was incorrect on the {}th cycle".format(i)