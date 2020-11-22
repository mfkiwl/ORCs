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
# File name     : hbi_seq.py
# Author        : Jose R Garcia
# Created       : 2020/11/22 10:24:13
# Last modified : 2020/11/22 10:31:58
# Project Name  : UVM Python Verification Library
# Module Name   : hbi_seq, hbi_base_sequence
# Description   : Handshake Bus Sequence Item and Sequences.
#
# Additional Comments:
#   Create a a read or write transaction.
#################################################################################
from uvm import *

class hbi_seq(UVMSequenceItem):
    """         
       Class: Memory Interface Sequence Item
        
       Definition: Contains functions, tasks and methods of this
    """
    READ = 0
    WRITE = 1

    def __init__(self, name="hbi_seq"):
        super().__init__(name)
        self.addr            = 0      # Program Counter
        self.data            = 0      # the instructio
        self.byte_enable     = 0      # logic
        self.type            = "READ" # type_e
         self.transmit_delay = 0      # delay ins


    def do_copy(self, rhs):
        self.addr   = rhs.addr
        self.data   = rhs.data
        self.type   = rhs.type
        self.byte_enable = rhs.byte_enable
        #for val in rhs.data:
        #    self.data.append(val)
        #for val in rhs.byte_enable:
        #    self.byte_enable.append(val)


    def do_clone(self):
        new_obj = hbi_seq()
        new_obj.copy(self)
        return new_obj


    def convert2string(self):
        return sv.sformatf("\n ======================================= \n     Type  : %s \n  Address : 0h%0h \n     Data : 0h%0h \n ======================================= \n ",
                self.type, self.addr, self.data)

    #endclass: hbi_seq
uvm_object_utils(hbi_seq)


class hbi_base_sequence(UVMSequence):

    def __init__(self, name="hbi_base_sequence"):
        super().__init__(name)
        self.set_automatic_phase_objection(1)
        self.req = hbi_seq()
        self.rsp = hbi_seq()


class read_sequence(hbi_base_sequence):

    def __init__(self, name="read_byte_seq"):
        hbi_base_sequence.__init__(self, name)
        self.data = 0
        self.transmit_delay = 0


    async def body(self):
        # Build the sequence item
        self.req.data = self.data

        await uvm_do_with(self, self.req)

        rsp = []
        await self.get_response(rsp)
        self.rsp = rsp[0]
        uvm_info(self.get_type_name(),
            sv.sformatf("%s read : addr = `x{}, data[0] = `x{}",
                self.get_sequence_path(), self.rsp.addr, self.rsp.data[0]),
            UVM_HIGH)


uvm_object_utils(read_sequence)

class write_sequence(hbi_base_sequence):

    def __init__(self, name="read_byte_seq"):
        hbi_base_sequence.__init__(self, name)
        self.data = 0
        self.addr = 0
        self.transmit_delay = 0


    async def body(self):
        # Build the sequence item
        self.req.data = self.data
        self.req.addr = self.addr

        await uvm_do_with(self, self.req)

        rsp = []
        await self.get_response(rsp)
        self.rsp = rsp[0]
        uvm_info(self.get_type_name(),
            sv.sformatf("%s read : addr = `x{}, data[0] = `x{}",
                self.get_sequence_path(), self.rsp.addr, self.rsp.data[0]),
            UVM_HIGH)


uvm_object_utils(write_sequence)
