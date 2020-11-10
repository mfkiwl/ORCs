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
# File name     : memory_intfc_read_slave_agent.py
# Author        : Jose R Garcia
# Created       : 2020/11/05 19:26:21
# Last modified : 2020/11/09 21:43:54
# Project Name  : UVM Python Verification Library
# Module Name   : memory_intfc_read_slave_agent
# Description   : Memory Slave Interface Agent.
#
# Additional Comments:
#
#################################################################################
from uvm import *
from memory_intfc_read_slave_if import *
from memory_intfc_read_slave import *
from memory_intfc_read_slave_sequencer import *
from memory_intfc_read_slave_monitor import *
from mem_model import *

class memory_intfc_read_slave_agent(UVMAgent):
    """         
       Class: Memory Interface Read Slave Agent
        
       Definition: Contains the instantiations of this agents components.
    """
    
    def __init__(self, name, parent=None):
        """         
           Function: new
          
           Definition: Read slave agent constructor.

           Args:
             name: This agents name.
             parent: NONE
        """
        super().__init__(name, parent)
        # UVM-SV new() equivalent
        self.cfg         = None  # memory_intfc_read_slave_config
        self.sqr         = None  # memory_intfc_read_slave_sequencer
        self.drv         = None  # memory_intfc_read_slave (driver)
        self.mon         = None  # memory_intfc_read_slave_monitor
        self.vif         = None  # memory_intfc_vif There is no library import in this file because it is done in __init__.py
        self.reg_adapter = None  # memory model
        self.ap          = UVMAnalysisPort("ap", self) # analysis port for the monitor


    def build_phase(self, phase):
        super().build_phase(phase)
        """         
           Function: build_phase
          
           Definition: Create a new read slave agent with all its components.

           Args:
             phase: build_phase
        """
        arr = []
        if (not UVMConfigDb.get(self, "*", "cfg", arr)):
            uvm_fatal("MEM_INFC_READ_SLAVE/AGENT/CONFIG", "No memory_intfc_read_slave_config")
        self.cfg = arr[0]
        # self.sqr = memory_intfc_read_slave_sequencer.type_id.create("sqr", self)
        self.sqr = UVMSequencer.type_id.create("sqr", self)
        self.drv = memory_intfc_read_slave.type_id.create("drv", self)
        self.mon = memory_intfc_read_slave_monitor.type_id.create("mon", self)
        self.reg_adapter = reg_adapter.type_id.create("reg_adapter", self)


    def connect_phase(self, phase):
        """         
           Function: connect_phase
          
           Definition: Connects the analysis port and sequence item export. 

           Args:
             phase: connect_phase
        """
        self.mon.vif = self.cfg.vif
        self.drv.seq_item_port.connect(self.sqr.seq_item_export) # Driver Connection
        self.drv.vif = self.cfg.vif
        self.mon.ap.connect(self.ap)


uvm_component_utils(memory_intfc_read_slave_agent)
