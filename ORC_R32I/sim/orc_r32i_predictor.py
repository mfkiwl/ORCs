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
# Last modified : 2020/12/08 17:28:24
# Project Name  : ORCs
# Module Name   : orc_r32i_predictor
# Description   : Non Time Consuming R32I model.
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
from uvm_externals.Wishbone_Pipeline_Master.wb_master_seq import *

# Local defines
LUI = 55
AUIPC = 23
JAL = 111
JALR = 103
BCC = 99
RRO = 51
RII = 19
LCC = 3
SCC = 35

class orc_r32i_predictor(UVMSubscriber):
    """         
       Class: Predictor
        
       Definition: Contains functions, tasks and methods of this agent's monitor.
    """

    def __init__(self, name, parent=None):
        super().__init__(name, parent)
        """         
           Function: new
          
           Definition: R32I Predictor constructor.

           Args:
             name: This component's name.
             parent: NONE
        """
        self.ap = None
        self.num_items = 0
        self.instruction = None
        self.opcode = 0
        self.fct3 = 0
        self.fct7 = 0
        self.rd = 0
        self.rs1 = 0
        self.rs2 = 0
        self.signed_imm = 0
        self.unsigned_imm = 0
        self.pc = 0
        self.regs = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
        self.tag = "orc_r32i_predictor" + name


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
        """         
           Function: write
          
           Definition: This function immediately receives the transaction sent to
             the UUT by the agent. Decodes the instruction and generates a response
             sent to the scoreboard. 

           Args:
             t: wb_master_seq (Sequence Item)
        """
        #  Convert data_in from integer into a string array of binary characters.
        #  Index 0 in the array is the MSB index 32 is the LSB.
        self.instruction = f'{t.data_in:032b}'

        #  Select the bit fields associate with the instruction's opcode
        #  and convert to interger
        self.opcode = int(self.instruction[26:32], 2)

        if (self.opcode == LUI):
            #  Get rd and imm
            self.rd = int(self.instruction[21:25], 2)
            self.unsigned_imm = int(self.instruction[0:19] + '000000000000' , 2)
            self.regs[self.rd] = self.unsigned_imm
            uvm_info(self.tag, sv.sformatf("\n    OPCODE: LUI\n      Regs: %d", self.regs[self.rd]), UVM_LOW)

            
        if (self.opcode == AUIPC):
            #  Get rd and imm
            self.rd = int(self.instruction[21:25], 2)
            self.unsigned_imm = int(self.instruction[0:19] + '000000000000' , 2)
            self.regs[self.rd] = self.unsigned_imm + self.pc 
            uvm_info(self.tag, sv.sformatf("\n    OPCODE: AUIPC\n      Regs: %d", self.regs[self.rd]), UVM_LOW)
            
        if (self.opcode == JAL):
            #  Get rd and imm
            self.rd = int(self.instruction[21:25], 2)
            self.signed_imm = int(self.instruction[0] + self.instruction[13:20] + self.instruction[12] + self.instruction[1:11] + '0' , 2)
            self.regs[self.rd] = self.pc + 4
            uvm_info(self.tag, '\n    Got JAL', UVM_LOW)

        if (self.opcode == JALR):
            #  Get rd and imm
            self.rd = int(self.instruction[21:25], 2)
            self.signed_imm = int(self.instruction[0] + self.instruction[13:20] + self.instruction[12] + self.instruction[1:11] + '0' , 2)
            self.regs[self.rd] = self.pc + 4
            uvm_info(self.tag, '\n    Got JALR', UVM_LOW)

        #if (self.opcode == BCC):

        #    # uvm_reg.address(t.rd) = t.uimm + pc
        if (self.opcode == RRO):
            uvm_info(self.tag, '\n    Got RRO', UVM_LOW)

        if (self.opcode == RII):
            uvm_info(self.tag, '\n    Got RII', UVM_LOW)

        #if (self.opcode == LCC):

        #if (self.opcode == SCC):

        self.create_response(t)

   
    def create_response(self, t):
        """         
           Function: create_response
          
           Definition: Creates a response transaction and updates the pc counter. 

           Args:
             t: wb_master_seq (Sequence Item)
        """
 

uvm_component_utils(orc_r32i_predictor)
