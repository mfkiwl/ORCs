# test_Dhrystone.py
import random
import cocotb
from cocotb.clock import Clock
from cocotb.triggers import Timer, RisingEdge, ReadOnly
from cocotb.drivers import BusDriver
from cocotb.monitors import BusMonitor
#
from cocotb_coverage.coverage import *
from cocotb_coverage.crv import *

@cocotb.test()
async def test_Dhrystone(dut):
    """ Test test_Dhrystone """

# ORC_R32I ports
# i_clk        // clock
# i_reset_sync // reset
# o_inst_read     
# i_inst_read_ack 
# o_inst_read_addr
# i_inst_read_data
# o_master_read   
# i_master_read_ack
# o_master_read_addr
# i_master_read_data
# o_master_write          
# i_master_write_ack
# o_master_write_addr
# o_master_write_data
# o_master_write_byte_enable

    clock = Clock(dut.i_clk, 21, units="ns")  # Create a 48Mhz clock
    cocotb.fork(clock.start())  # Start the clock
    # Reset assingment
    dut.i_reset_sync <= 1
    # Instruction Data reset state
    dut.i_inst_read_ack <= 0
    # Mem Read and Write Interface reset state
    dut.i_master_read_ack <= 0
    dut.i_master_write_ack <= 0

    for i in range(10):
        await RisingEdge(dut.i_clk)

    dut.i_reset_sync <= 0

    for i in range(10):
        val = random.randint(0, 1)
        dut.UART_RXD <= val  # Assign the random value val to the input port d
        await RisingEdge(dut.i_clk)
       # assert dut.o_inst_addr_valid == 1, "output o_inst_addr_valid was incorrect on the {}th cycle".format(i)