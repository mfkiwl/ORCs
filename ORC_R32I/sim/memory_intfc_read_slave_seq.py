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
# File name     : memory_intfc_read_slave_seq.py
# Author        : Jose R Garcia
# Created       : 2020/11/05 19:26:21
# Last modified : 2020/11/22 23:04:47
# Project Name  : UVM Python Verification Library
# Module Name   : memory_intfc_read_slave_seq
# Description   : Memory Slave Interface Sequence Item.
#
# Additional Comments:
#   Create a a read or write transaction.
#################################################################################
from uvm import *

class memory_intfc_read_slave_seq(UVMSequenceItem):
    """         
       Class: Memory Interface Sequence Item
        
       Definition: Contains functions, tasks and methods of this
    """
    READ = 0

    def __init__(self, name="memory_intfc_read_slave_seq"):
        super().__init__(name)
        self.addr   = 0  # Program Counter
        self.data   = 0  # the instruction
        self.opcode = "LUI"
        self.rs1    = 0
        self.rs2    = 0
        self.simm   = 0
        self.uimm   = 0
        self.rd     = 0
        self.fct3   = 0
        self.fct7   = 0
        self.byte_enable = 0  # logic
        self.kind = memory_intfc_read_slave_seq.READ  # kind_e


    def do_copy(self, rhs):
        self.addr   = rhs.addr
        self.data   = rhs.data
        self.opcode = rhs.opcode
        self.rs1    = rhs.rs1
        self.rs2    = rhs.rs2
        self.simm   = rhs.simm
        self.uimm   = rhs.uimm
        self.rd     = rhs.rd
        self.fct3   = rhs.fct3
        self.fct7   = rhs.fct7
        self.kind   = rhs.kind
        self.byte_enable = rhs.byte_enable
        #for val in rhs.data:
        #    self.data.append(val)
        #for val in rhs.byte_enable:
        #    self.byte_enable.append(val)


    def do_clone(self):
        new_obj = memory_intfc_read_slave_seq()
        new_obj.copy(self)
        return new_obj


    def convert2string(self):
        kind = "FETCH"
        return sv.sformatf("\n ======================================= \n            Type  : %s \n  Program Counter : 0h%0h \n      Instruction : 0h%0h \n           OPCODE : %s\n              rs1 : 0d%0d \n              rs2 : 0d%0d \n               rd : 0d%0d \n ======================================= \n ",
                kind, self.addr, self.data, self.opcode, self.rs1, self.rs2, self.rd)

    #endclass: memory_intfc_read_slave_seq
uvm_object_utils(memory_intfc_read_slave_seq)


class memory_intfc_read_slave_base_sequence(UVMSequence):

    def __init__(self, name="memory_intfc_read_slave_base_sequence"):
        super().__init__(name)
        #self.set_automatic_phase_objection(1)
        self.req = memory_intfc_read_slave_seq()
        self.rsp = memory_intfc_read_slave_seq()


class read_sequence(memory_intfc_read_slave_base_sequence):

    def __init__(self, name="read_sequence"):
        memory_intfc_read_slave_base_sequence.__init__(self, name)
        self.data = 0
        self.opcode = " "
        self.transmit_delay = 0


    async def body(self):
        # Build the sequence item
        self.req.data = self.data
        self.req.opcode = self.opcode

        await uvm_do_with(self, self.req) # start_item 


uvm_object_utils(read_sequence)
