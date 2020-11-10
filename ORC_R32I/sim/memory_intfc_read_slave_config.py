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
# File name     : memory_intfc_read_slave_config.py
# Author        : Jose R Garcia
# Created       : 2020/11/05 19:26:21
# Last modified : 2020/11/08 21:20:11
# Project Name  : UVM Python Verification Library
# Module Name   : memory_intfc_read_slave_config
# Description   : Memory Slave Interface Configuration object.
#
# Additional Comments:
#
#################################################################################
from uvm.base.uvm_object import *
from uvm.macros import *
from memory_intfc_read_slave_if import *

class memory_intfc_read_slave_config(UVMObject):
    """         
       Class: Memory Interface Read Slave Agent Config
        
       Definition: COnfiguration of the agent.
    """
    #virtual memory_intfc_read_slave_if vif
    
    def __init__(self, name="memory_intfc_read_slave_config"):
        super().__init__(name)
        """         
           Function: new
          
           Definition: Read slave config constructor.

           Args:
             name: This agents name.
             parent: NONE
        """
        self.vif = None  # memory_intfc_read_slave_if


    def build_phase(self, phase):
        """         
           Function: build_phase
          
           Definition: Create a new read slave agent with all its components.

           Args:
             phase: build_phase
        """
        self.vif = memory_intfc_read_slave_if.type_id.create("vif", self)


uvm_object_utils(memory_intfc_read_slave_config)