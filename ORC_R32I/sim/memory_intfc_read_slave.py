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
# Last modified : 2020/11/20 01:17:02
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
        self.vif = memory_intfc_read_slave_if
        #self.vif = memory_intfc_read_slave_if.type_id.create("vif", self)
        self.trig = Event("trans_exec")  # event
        self.tag = "memory_intfc_read_slave_" + name
        self.data = 0


    def build_phase(self, phase):
        super().build_phase(phase)
        """         
           Function: build_phase
          
           Definition: Gets this agent's interface.

           Args:
             phase: build_phase
        """
        #self.vif = memory_intfc_read_slave_if.type_id.create("vif", self)
    
    async def run_phase(self, phase):
        """         
           Function: run_phase
          
           Definition: Task executed during run phase. Drives the signals in
                       response to a DUT read request. 

           Args:
             phase: run_phase
        """
        uvm_info("memory_intfc_read_slave", "memory_intfc_read_slave run_phase started", UVM_MEDIUM)
        # Initiate Read signals at their reset values.
        self.vif.i_inst_read_ack <= 0
        self.vif.i_inst_read_data <= 0
        #self.vif.i_inst_read_byte_enable <= 0

        while True:
            
            await self.drive_delay() # Wait for the clock's rising edge
            if (self.vif.i_reset_sync == 0 and self.vif.o_inst_read == 1):
              tr = []
              await self.seq_item_port.get_next_item(tr)
              tr = tr[0]
              #uvm_info("memory_intfc_read_slave", "Driving trans into DUT: " + tr.convert2string(), UVM_DEBUG)
              await self.trans_received(tr)
              #uvm_do_callbacks(memory_intfc_read_slave,memory_intfc_read_slave_cbs,trans_received(self,tr))
              #data = []
              #byte_enable =[]
              self.data = 74135 # 32'h0001_2197 (AUIPC)
              await self.read(self.vif.o_inst_read_addr, self.data)
              #await self.read(tr.addr, data, byte_enable)
              tr.addr = self.vif.o_inst_read_addr
              tr.addr = self.vif.o_inst_read_addr
              #tr.byte_enable = byte_enable[0]
              tr.convert2string
              await self.trans_executed(tr)
              #uvm_do_callbacks(memory_intfc_read_slave,memory_intfc_read_slave_cbs,trans_executed(self,tr))
              self.seq_item_port.item_done()
              self.trig.set()

    
    #async def read(self, addr, data, byte_enable):
    #    uvm_info(self.tag, "======================================= ", UVM_MEDIUM)
    #    uvm_info(self.tag, "Reading to address : " + str(addr),        UVM_MEDIUM)
    #    uvm_info(self.tag, "              data : " + str(data),        UVM_MEDIUM)
    #    uvm_info(self.tag, "       byte_enable : " + str(byte_enable), UVM_MEDIUM)
    #    uvm_info(self.tag, "======================================= ", UVM_MEDIUM)

    async def read(self, addr, data):
        self.vif.i_inst_read_data <= data
        #self.vif.i_inst_read_byte_enable <= byte_enable
        self.vif.i_inst_read_ack  <= 1

   
    async def drive_delay(self):
        await RisingEdge(self.vif.i_clk)
        await Timer(1, "NS")

    
    async def trans_received(self, tr):
        await Timer(0, "NS")

    
    async def trans_executed(self, tr):
        uvm_info(self.tag, "Finished Memory Interface read to address : " + str(tr.addr.value), UVM_MEDIUM)
        await Timer(0, "NS")


uvm_component_utils(memory_intfc_read_slave)
