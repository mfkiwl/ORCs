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
# File name     : memory_intfc_read_slave_monitor.py
# Author        : Jose R Garcia
# Created       : 2020/11/05 20:08:35
# Last modified : 2020/11/09 22:18:23
# Project Name  : UVM Python Verification Library
# Module Name   : memory_intfc_read_slave_monitor
# Description   : Memory Slave Interface  monitor.
#
# Additional Comments:
#
#################################################################################
import cocotb
from cocotb.triggers import *
from uvm.base.uvm_callback import *
from uvm.comps.uvm_monitor import UVMMonitor
from uvm.tlm1 import *
from uvm.macros import *
from memory_intfc_read_slave_seq import *
from memory_intfc_read_slave_if import *

class memory_intfc_read_slave_monitor(UVMMonitor):
    """         
       Class: Memory Interface Read Slave Monitor
        
       Definition: Contains functions, tasks and methods of this agent's monitor.
    """

    def __init__(self, name, parent=None):
        super().__init__(name, parent)
        """         
           Function: new
          
           Definition: Read slave agent constructor.

           Args:
             name: This agents name.
             parent: NONE
        """
        self.ap = None
        self.vif = None  # connected at the agent
        self.cfg = None  # config loaded by the agent
        self.errors = 0
        self.num_items = 0
        self.tag = "MEM_INFC_READ_SLAVE_MONITOR"


    def build_phase(self, phase):
        super().build_phase(phase)
        """         
           Function: build_phase
          
           Definition: Brings this agent's virtual interface.

           Args:
             phase: build_phase
        """
        self.ap = UVMAnalysisPort("ap", self)

    
    async def run_phase(self, phase):
        """         
           Function: run_phase
          
           Definition: Task executed during run phase. Drives the signals in
                       response to a DUT read request. 

           Args:
             phase: run_phase
        """
        while True:
            tr = None  # Clean transaction for every loop.
            # Wait for a read request cycle
            while True:
                await self.sample_delay() # Wait for the clock's rising edge
                if (self.vif.i_reset_sync == 0 and self.vif.o_inst_read == 1):
                    break # If out of reset and received a read request
            
            # Create sequence item for this transaction.
            tr = memory_intfc_read_slave_seq.type_id.create("tr", self)
            # Load signals values into sequence item to describe the transaction
            tr.kind        = memory_intfc_read_slave_seq.READ
            tr.addr        = self.vif.o_inst_read_addr.value.integer
            tr.data        = self.vif.i_inst_read_data.value.integer
            #tr.byte_enable = self.vif.o_inst_write_byte_enable.value.integer

            # Wait for acknowledgement of read request cycle. TODO: Add a timeout
            while True:
                await self.sample_delay() # Wait for the clock's rising edge
                if (self.vif.i_inst_read_ack == 1):
                    if (int(self.vif.o_inst_read) != 1):
                        uvm_error("memory_intfc_read_slave", "memory_intfc_read_slave protocol violation")
                        self.errors += 1
                    break # If out of reset and received a read request

            self.trans_observed(tr)
            self.num_items += 1
            self.ap.write(tr)
            uvm_info(self.tag, "Sampled memory_intfc_read_slave item: " + tr.convert2string(),
                UVM_HIGH)


    def trans_observed(self, tr):
        pass

    
    async def sample_delay(self):
        await RisingEdge(self.vif.i_clk)
        await Timer(1, "NS")


uvm_component_utils(memory_intfc_read_slave_monitor)
