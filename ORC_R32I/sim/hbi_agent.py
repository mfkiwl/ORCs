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
# File name     : hbi_agent.py
# Author        : Jose R Garcia
# Created       : 2020/11/09 21:43:54
# Last modified : 2020/11/22 10:17:25
# Project Name  : UVM-Python Verification Library
# Module Name   : hbi_agent
# Description   : Handshake Bus Interface Agent.
#
# Additional Comments:
#
#################################################################################
from uvm import *
from hbi_agent_if import *
from hbi_agent import *
from hbi_agent_sequencer import *
from hbi_agent_monitor import *
from mem_model import *

class hbi_agent(UVMAgent):
    """         
       Class: Handshake Bus Insterface  Agent
        
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
        self.hbi_cfg         = None  # hbi_agent_config
        self.hbi_sqr         = None  # hbi_agent_sequencer
        self.hbi_drv         = None  # hbi_agent (driver)
        self.hbi_mon         = None  # hbi_agent_monitor
        self.hbi_vif         = None  # memory_intfc_vif There is no library import in this file because it is done in __init__.py
        self.hbi_reg_adapter = None  # memory model
        self.hbi_ap          = UVMAnalysisPort("ap", self) # analysis port for the monitor


    def build_phase(self, phase):
        super().build_phase(phase)
        """         
           Function: build_phase
          
           Definition: Create a new read slave agent with all its components.

           Args:
             phase: build_phase
        """
        arr = []
        if (not UVMConfigDb.get(self, "*", "hbi_cfg", arr)):
            uvm_fatal("MEM_INFC_READ_SLAVE/AGENT/CONFIG", "No hbi_agent_config")
        self.hbi_cfg = arr[0]
        
        # self.sqr = hbi_agent_sequencer.type_id.create("sqr", self)
        self.hbi_sqr = UVMSequencer.type_id.create("hbi_sqr", self)
        
        if (self.hbi_cfg.has_driver)
            self.hbi_drv = hbi_agent.type_id.create("hbi_drv", self)
       
        if (self.hbi_cfg.has_monitor)
            self.hbi_mon = hbi_agent_monitor.type_id.create("hbi_mon", self)

        if (self.hbi_cfg.has_memory_model)
            self.hbi_reg_adapter = reg_adapter.type_id.create("hbi_reg_adapter", self)


    def connect_phase(self, phase):
        """         
           Function: connect_phase
          
           Definition: Connects the analysis port and sequence item export. 

           Args:
             phase: connect_phase
        """
        if (self.hbi_cfg.has_monitor)
            self.hbi_mon.vif = self.hbi_cfg.vif
            self.hbi_mon.ap.connect(self.hbi_ap)
       
        if (self.hbi_cfg.has_driver)
            self.hbi_drv.seq_item_port.connect(self.hbi_sqr.seq_item_export) # Driver Connection
            self.hbi_drv.vif = self.hbi_cfg.vif


uvm_component_utils(hbi_agent)
