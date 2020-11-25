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
# File name     : orc_r32i_predictor.py
# Author        : Jose R Garcia
# Created       : 2020/11/05 20:08:35
# Last modified : 2020/11/21 23:45:59
# Project Name  : UVM Python Verification Library
# Module Name   : orc_r32i_predictor
# Description   : Memory Slave Interface  monitor.
#
# Additional Comments:
#
#################################################################################
import cocotb
from cocotb.triggers import *
from uvm.base import *
from uvm.comps import *
from uvm.tlm1 import *
from uvm.macros import *
from memory_intfc_read_slave_seq import *
from memory_intfc_read_slave_if import *
from mem_model import *

class orc_r32i_predictor(UVMSubscriber):
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
        self.num_items = 0
        self.tag = "ORC_R32I_PREDICTOR"


    def build_phase(self, phase):
        super().build_phase(phase)
        """         
           Function: build_phase
          
           Definition: Brings this agent's virtual interface.

           Args:
             phase: build_phase
        """
        self.ap = UVMAnalysisPort("ap", self)

   
    def write(self, t):
        if (t.opcode == "LUI"):
            # uvm_reg.address(t.rd) = t.uimm
            #   
        if (t.opcode == "AUIPC"):
            # uvm_reg.address(t.rd) = t.uimm + pc
        if (t.opcode == "RII") :



uvm_component_utils(orc_r32i_predictor)
