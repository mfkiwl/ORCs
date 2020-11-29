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
# File name     : orc_r32i_test_lib.py
# Author        : Jose R Garcia
# Created       : 2020/11/05 19:26:21
# Last modified : 2020/11/29 09:43:44
# Project Name  : ORCs
# Module Name   : orc_r32i_test_lib
# Description   : ORC_R32I Test Library
#
# Additional Comments:
#   Contains the test base and tests.
#################################################################################
import cocotb
from cocotb.triggers import Timer

from uvm import *
from memory_intfc_read_slave_seq import *
from memory_intfc_read_slave_agent import *
from memory_intfc_read_slave_config import *
from tb_env_config import *
from orc_r32i_tb_env import *
from mem_model import *

class orc_r32i_test_base(UVMTest):
    """         
       Class: Memory Interface Read Slave Monitor
        
       Definition: Contains functions, tasks and methods of this agent's monitor.
    """

    def __init__(self, name="orc_r32i_test_base", parent=None):
        super().__init__(name, parent)
        self.test_pass = True
        self.tb_env = None
        self.tb_env_config = None
        self.inst_agent_cfg = None
        self.reg_block = None
        self.printer = None

    def build_phase(self, phase):
        super().build_phase(phase)
        # Enable transaction recording for everything
        UVMConfigDb.set(self, "*", "recording_detail", UVM_FULL)
        # Create the reg block
        self.reg_block = reg_block.type_id.create("reg_block", self)
        self.reg_block.build()
        # create this test test bench environment config
        self.tb_env_config = tb_env_config.type_id.create("tb_env_config", self)
        self.tb_env_config.reg_block = self.reg_block
        # Create the instruction agent
        self.inst_agent_cfg = memory_intfc_read_slave_config.type_id.create("inst_agent_cfg", self)
        arr = []
        # Get the instruction interface created at top
        if UVMConfigDb.get(None, "*", "vif", arr) is True:
            UVMConfigDb.set(self, "*", "vif", arr[0])
            # Make this agent's interface the interface connected at top
            self.inst_agent_cfg.vif = arr[0]
            UVMConfigDb.set(self, "*", "cfg", self.inst_agent_cfg)
        else:
            uvm_fatal("NOVIF", "Could not get vif from config DB")

        # Make this instruction agent the test bench config agent
        self.tb_env_config.inst_agent_cfg = self.inst_agent_cfg
        UVMConfigDb.set(self, "*", "tb_env_config", self.tb_env_config)
        # Create the test bench environment 
        self.tb_env = orc_r32i_tb_env.type_id.create("tb_env", self)
        # Create a specific depth printer for printing the created topology
        self.printer = UVMTablePrinter()
        self.printer.knobs.depth = 3


    def end_of_elaboration_phase(self, phase):
        # Print topology
        uvm_info(self.get_type_name(),
            sv.sformatf("Printing the test topology :\n%s", self.sprint(self.printer)), UVM_LOW)


    def report_phase(self, phase):
        if self.test_pass:
            uvm_info(self.get_type_name(), "** UVM TEST PASSED **", UVM_NONE)
        else:
            uvm_fatal(self.get_type_name(), "** UVM TEST FAIL **\n" +
                self.err_msg)


uvm_component_utils(orc_r32i_test_base)


class orc_r32i_reg_test(orc_r32i_test_base):


    def __init__(self, name="orc_r32i_reg_test", parent=None):
        super().__init__(name, parent)


    async def run_phase(self, phase):

        slave_sqr = self.tb_env.inst_agent.sqr
        
        slave_seq0 = read_sequence("slave_seq0")
        slave_seq0.data = 74135
        slave_seq0.opcaode = "AUIPC" 

        slave_seq1 = read_sequence("slave_seq1")
        slave_seq1.data = 646021523
        slave_seq1.opcaode = "RII"

        slave_seq2 = read_sequence("slave_seq2")
        slave_seq2.data = 2193720595
        slave_seq2.opcaode = "RII" 

        slave_seq3 = read_sequence("slave_seq3")
        slave_seq3.data = 83479
        slave_seq3.opcaode = "AUIPC"

        slave_seq4 = read_sequence("slave_seq4")
        slave_seq4.data = 1166118409
        slave_seq4.opcaode = "JAL"

        slave_seq5 = read_sequence("slave_seq5")
        slave_seq5.data = 714080495
        slave_seq5.opcaode = "JAL"

        slave_seq6 = read_sequence("slave_seq6")
        slave_seq6.data = 2181145347
        slave_seq6.opcaode = "LCC"

        # Call the sequencer
        #await slave_seq0.start(slave_sqr)
        await slave_seq0.start(slave_sqr)

        #await slave_seq1.start(slave_sqr)
        await slave_seq1.start(slave_sqr)

        #await slave_seq2.start(slave_sqr)
        await slave_seq2.start(slave_sqr)
        
        #await slave_seq3.start(slave_sqr)
        await slave_seq3.start(slave_sqr)

        #await slave_seq4.start(slave_sqr)
        #await slave_seq4.start(slave_sqr)

        #await slave_seq5.start(slave_sqr)
        await slave_seq5.start(slave_sqr)

        #await slave_seq6.start(slave_sqr)
        await slave_seq6.start(slave_sqr)

uvm_component_utils(orc_r32i_reg_test)