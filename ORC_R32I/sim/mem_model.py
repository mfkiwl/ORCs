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
# Created       : 2020/11/05 20:11:12
# Last modified : 2020/11/11 23:39:24
# Project Name  : UVM Python Verification Library
# Module Name   : memory_intfc_read_slave_config
# Description   : Memory Interface Configuraion object.
#
# Additional Comments:
#
#################################################################################
from uvm import *
from memory_intfc_read_slave_seq import *

class reg_model(UVMReg):


    def __init__(self, name="reg_model", n_bits=32):
        super().__init__(name, n_bits)
        self.inst_rom = None


    def build(self):
        self.inst_rom = UVMRegField.type_id.create("inst_rom", self)
        # def configure(self, parent, size, lsb_pos, access, volatile, reset, has_reset, is_rand,
        #        individually_accessible):
        self.inst_rom.configure(self, 32, 0, "RO", False, 0, 0, 0, False)
        # for back-door access


    #self.configure(hdl_path="inst_rom")


uvm_object_utils(reg_model)


class reg_block(UVMRegBlock):


    def __init__(self, name="reg_model", n_bits=32):
        super().__init__(name, n_bits)
        self.reg_map = None
        self.inst_rom_reg = None


    def build(self):
        self.inst_rom_reg = reg_model.type_id.create("inst_rom_reg", self)
        self.inst_rom_reg.configure(blk_parent=self)
        self.inst_rom_reg.build()

        self.reg_map = UVMRegBlock.create_map(self, "reg_map",0, 4, 0, True)
        #self.reg_map.configure(base_addr=0, n_bytes=4, endian=UVM_LITTLE_ENDIAN)

        self.reg_map.add_reg(rg=self.inst_rom_reg, offset=0, rights="RO")
        # def add_reg(self, rg, offset, rights="RW", unmapped=0, frontdoor=None):


    #def configure(hdl_path="top.dut")
    #self.configure(self, None, "top.dut")
    
    
uvm_object_utils(reg_block)


class reg_adapter(UVMRegAdapter):


    def __init__(self, name="reg2memory_intfc_read_slave_adapter"):
        super().__init__(name)

    def reg2bus(self, rw):
        memory_intfc = memory_intfc_read_slave_seq.type_id.create("memory_intfc_read_slave_seq")
        memory_intfc.kind = memory_intfc_read_slave_seq.READ
        memory_intfc.addr = rw.addr
        memory_intfc.data = rw.data
        memory_intfc.byte_enable = rw.byte_enable
        return memory_intfc


    def bus2reg(self, bus_item, rw):  # rw must be ref
        memory_intfc = None
        arr = []
        if (not sv.cast(arr,bus_item, memory_intfc_read_slave_seq)):
            uvm_fatal("NOT_memory_intfc_read_slave_TYPE", "Provided bus_item is not of the correct type")
            return

        memory_intfc = arr[0]
        rw.addr = memory_intfc.addr
        rw.data = memory_intfc.data
        rw.byte_enable = memory_intfc.byte_enable
        rw.status = UVM_IS_OK
        return rw


uvm_object_utils(reg_adapter)


class orc_r32i_predictor(UVMRegPredictor):

    def __init__(self, name="orc_r32i_predictor"):
        super().__init__(name)


uvm_object_utils(orc_r32i_predictor)