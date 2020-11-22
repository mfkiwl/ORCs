#################################################################################
# BSD 3-Clause License
# 
# Copyright (c) 2020, Jose R. Garcia
# All rights reserved.
# 
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
# 
# 1. Redistributions of source code must retain the above copyright notice, this
#    list of conditions and the following disclaimer.
# 
# 2. Redistributions in binary form must reproduce the above copyright notice,
#    this list of conditions and the following disclaimer in the documentation
#    and/or other materials provided with the distribution.
# 
# 3. Neither the name of the copyright holder nor the names of its
#    contributors may be used to endorse or promote products derived from
#    this software without specific prior written permission.
# 
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
# FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
# DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
# SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
# CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
# OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#
#################################################################################
# File name     : hbi_driver.py
# Author        : Jose R Garcia
# Created       : 2020/11/22 12:45:43
# Last modified : 2020/11/22 12:49:21
# Project Name  : UVM-Python Verification Library
# Module Name   : hbi_driver
# Description   : Handshake Bus Interface Driver.
#
# Additional Comments:
#
#################################################################################
import cocotb
from cocotb.triggers import *
from uvm import *
from hbi_seq import *
from hbi_if import *


class hbi_driver(UVMDriver):
    """         
       Class: Memory Interface Read Slave Driver
        
       Definition: Contains functions, tasks and methods to drive the read interface
                   signals in response to the DUT. This is the stimulus generator.
    """

    def __init__(self, name, parent=None):
        super().__init__(name,parent)
        """         
           Function: new
          
           Definition: Read slave agent constructor.

           Args:
             name: This agents name.
             parent: NONE
        """
        self.seq_item_port
        self.vif = hbi_if
        self.trig = Event("trans_exec")  # event
        self.tag = "hbi_" + name
        self.data = 0


    def build_phase(self, phase):
        super().build_phase(phase)
        """         
           Function: build_phase
          
           Definition: Gets this agent's interface.

           Args:
             phase: build_phase
        """

    
    async def run_phase(self, phase):
        """         
           Function: run_phase
          
           Definition: Task executed during run phase. Drives the signals in
                       response to a DUT read request. 

           Args:
             phase: run_phase
        """
        uvm_info("hbi_driver", "hbi_driver run_phase started", UVM_MEDIUM)
        # Initiate Read signals at their reset values.
        self.vif.i_inst_read_ack  <= 0
        self.vif.i_inst_read_data <= 0

        while True:
            
            await self.clock_delay() # Wait for the clock's rising edge

            if (self.vif.i_reset_sync == 0 and self.vif.o_read == 1):
              # If out of reset and read request seen get next sequence item.
              tr = []
              await self.seq_item_port.get_next_item(tr)
              tr = tr[0]
              
              await self.trans_received(tr)

              await self.read(tr.data)

              tr.addr = self.vif.o_inst_read_addr
              tr.addr = self.vif.o_inst_read_addr

              await self.trans_executed(tr)
              
              self.seq_item_port.item_done()
              self.trig.set()


    async def read(self, data):
        self.vif.i_inst_read_data <= data
        #self.vif.i_inst_read_byte_enable <= byte_enable
        self.vif.i_inst_read_ack  <= 1

   
    async def clock_delay(self):
        await RisingEdge(self.vif.i_clk)
        await Timer(1, "NS")

    
    async def trans_received(self, tr):
        await RisingEdge(self.vif.i_clk)
        await Timer(0, "NS")

    
    async def trans_executed(self, tr):
        # uvm_info(self.tag, "Finished Memory Interface read to address : " + str(tr.addr.value), UVM_MEDIUM)
        tr.convert2string
        await Timer(0, "NS")


uvm_component_utils(hbi_driver)
