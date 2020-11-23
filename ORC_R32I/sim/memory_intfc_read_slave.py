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
# File name     : memory_intfc_read_slave.py
# Author        : Jose R Garcia
# Created       : 2020/11/05 19:26:21
# Last modified : 2020/11/23 00:30:10
# Project Name  : UVM Python Verification Library
# Module Name   : memory_intfc_read_slave
# Description   : Memory Slave Interface driver.
#
# Additional Comments:
#
#################################################################################
import cocotb
from cocotb.triggers import *
from uvm import *
from memory_intfc_read_slave_seq import *
from memory_intfc_read_slave_if import *


class memory_intfc_read_slave(UVMDriver):
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
        self.vif  = memory_intfc_read_slave_if
        self.trig = Event("trans_exec")  # event
        self.tag  = "memory_intfc_read_slave_" + name
        self.data = 0


    def build_phase(self, phase):
        super().build_phase(phase)
        """         
           Function: build_phase
          
           Definition: Gets this agent's interface.

           Args:
             phase: build_phase
        """
    
    async def main_phase(self, phase):
        """         
           Function: run_phase
          
           Definition: Task executed during run phase. Drives the signals in
                       response to a DUT read request. 

           Args:
             phase: run_phase
        """
        uvm_info("memory_intfc_read_slave", "memory_intfc_read_slave run_phase started", UVM_MEDIUM)
        # Initiate Read signals at their reset values.
        self.vif.i_inst_read_ack  <= 0
        self.vif.i_inst_read_data <= 0

        while True:
            if (self.vif.i_reset_sync == 1):
                self.vif.i_inst_read_ack  <= 0
                self.vif.i_inst_read_data <= 0
                await self.drive_delay() # Wait for the clock's rising edge

            if (self.vif.i_reset_sync == 0 and self.vif.o_inst_read == 1 and self.vif.i_inst_read_ack == 0):
                tr = []
                await self.seq_item_port.get_next_item(tr)
                phase.raise_objection(self, "test_read objection")
                tr_copy = tr[0]
                
                await self.drive_delay()
  
                await self.read(tr_copy.data)
  
                tr_copy.addr = self.vif.o_inst_read_addr
  
                #await self.trans_executed(tr_copy)
                
                self.seq_item_port.item_done()
                phase.drop_objection(self, "test_read drop objection")
                #self.trig.set()


            if (self.vif.i_reset_sync == 0 and self.vif.o_inst_read == 1 and self.vif.i_inst_read_ack == 1):
                tr = []
                await self.seq_item_port.get_next_item(tr)
                phase.raise_objection(self, "test_read objection")
                tr_copy = tr[0]
                
                await self.drive_delay()
  
                await self.read(tr_copy.data)
  
                tr_copy.addr = self.vif.o_inst_read_addr
  
                #await self.trans_executed(tr_copy)
                
                self.seq_item_port.item_done()
                phase.drop_objection(self, "test_read drop objection")
                #self.trig.set()

            
            if (self.vif.i_reset_sync == 0 and self.vif.o_inst_read == 0):
                await self.drive_delay() # Wait for the clock's rising edge
                self.vif.i_inst_read_ack <= 0



    async def read(self, data):
        self.vif.i_inst_read_data <= data
        #self.vif.i_inst_read_byte_enable <= byte_enable
        self.vif.i_inst_read_ack  <= 1
        await Timer(0, "NS")

   
    async def drive_delay(self):
        await RisingEdge(self.vif.i_clk)
        await Timer(0, "NS")

    
    async def trans_received(self, tr):
        await RisingEdge(self.vif.i_clk)
        await Timer(0, "NS")

    
    async def trans_executed(self, tr):
        # uvm_info(self.tag, "Finished Memory Interface read to address : " + str(tr.addr.value), UVM_MEDIUM)
        # tr.convert2string
        await Timer(0, "NS")


uvm_component_utils(memory_intfc_read_slave)
