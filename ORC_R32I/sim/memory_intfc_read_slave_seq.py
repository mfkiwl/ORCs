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
# Last modified : 2020/11/09 22:35:41
# Project Name  : UVM Python Verification Library
# Module Name   : memory_intfc_read_slave_seq
# Description   : Memory Slave Interface Sequence Item.
#
# Additional Comments:
#   Create a a read or write transaction.
#################################################################################
from uvm import *

class memory_intfc_read_slave_seq(UVMSequenceItem):

    READ = 0

    def __init__(self, name="memory_intfc_read_slave_seq"):
        super().__init__(name)
        self.addr = 0  # bit
        self.data = 0  # logic
        self.byte_enable = 0  # logic
        self.kind = memory_intfc_read_slave_seq.READ  # kind_e


    def do_copy(self, rhs):
        self.addr = rhs.addr
        self.kind = rhs.kind
        self.byte_enable = rhs.byte_enable
        for val in rhs.data:
            self.data.append(val)
        for val in rhs.byte_enable:
            self.byte_enable.append(val)


    def do_clone(self):
        new_obj = ubus_transfer()
        new_obj.copy(self)
        return new_obj


    def convert2string(self):
        res = "ID: " + str(self.m_transaction_id)
        res += ", addr: " + str(self.addr) + ", kind: READ"
        res += ", byte_enable: " + str(self.byte_enable) + ", wait_state: " + str(self.wait_state)
        res += "\ndata: " + str(self.data)
        return res


    def convert2string(self):
        kind = "READ"
        return sv.sformatf("kind=%s addr=%0h data=%0h byte_enable=%0h",
                kind, self.addr, self.data, self.byte_enable)

    #endclass: memory_intfc_read_slave_seq
uvm_object_utils(memory_intfc_read_slave_seq)



class memory_intfc_read_slave_base_sequence(UVMSequence):

    def __init__(self, name="memory_intfc_read_slave_base_sequence"):
        super().__init__(name)
        self.set_automatic_phase_objection(1)
        self.req = memory_intfc_read_slave_seq()
        self.rsp = memory_intfc_read_slave_seq()


class read_sequence(memory_intfc_read_slave_base_sequence):

    def __init__(self, name="read_byte_seq"):
        memory_intfc_read_slave_base_sequence.__init__(self, name)
        self.data = 0
        self.rand('data', range((1 << 32) - 1))
        self.transmit_delay = 0

    #  constraint transmit_del_ct { (transmit_del <= 10); }


    async def body(self):
        self.req.data = self.data
        await uvm_do_with(self, self.req, lambda data: data == self.data)
        #      { req.addr == start_addr
        #        req.read_write == READ
        #        req.size == 1
        #        req.error_pos == 1000
        #        req.transmit_delay == transmit_del; } )
        rsp = []
        await self.get_response(rsp)
        self.rsp = rsp[0]
        uvm_info(self.get_type_name(),
            sv.sformatf("%s read : addr = `x{}, data[0] = `x{}",
                self.get_sequence_path(), self.rsp.addr, self.rsp.data[0]),
            UVM_HIGH)
        #  endtask


uvm_object_utils(read_sequence)
