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
# Last modified : 2020/12/12 01:21:06
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
from uvm_externals.Wishbone_Pipeline_Master.wb_master_seq import *
from uvm_externals.Wishbone_Pipeline_Master.wb_master_agent import *
from uvm_externals.Wishbone_Pipeline_Master.wb_master_config import *
from tb_env_config import *
from orc_r32i_tb_env import *
from orc_r32i_predictor import *
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
        # self.reg_block = reg_block.type_id.create("reg_block", self)
        # self.reg_block.build()
        # create this test test bench environment config
        self.tb_env_config = tb_env_config.type_id.create("tb_env_config", self)
        # self.tb_env_config.reg_block = self.reg_block
        self.tb_env_config.has_scoreboard = True
        self.tb_env_config.has_predictor = True
        self.tb_env_config.has_functional_coverage = False
        # Create the instruction agent
        self.inst_agent_cfg = wb_master_config.type_id.create("inst_agent_cfg", self)
        arr = []
        # Get the instruction interface created at top
        if UVMConfigDb.get(None, "*", "vif", arr) is True:
            UVMConfigDb.set(self, "*", "vif", arr[0])
            # Make this agent's interface the interface connected at top
            self.inst_agent_cfg.vif         = arr[0]
            self.inst_agent_cfg.has_driver  = 1
            self.inst_agent_cfg.has_monitor = 1
        else:
            uvm_fatal("NOVIF", "Could not get vif from config DB")

        # Create the Mem Read agent
        self.mem_read_agent_cfg = wb_master_config.type_id.create("mem_read_agent_cfg", self)
        arr = []
        # Get the instruction interface created at top
        if UVMConfigDb.get(None, "*", "vif_read", arr) is True:
            UVMConfigDb.set(self, "*", "vif_read", arr[0])
            # Make this agent's interface the interface connected at top
            self.mem_read_agent_cfg.vif         = arr[0]
            self.mem_read_agent_cfg.has_driver  = 1
            self.mem_read_agent_cfg.has_monitor = 1
        else:
            uvm_fatal("NOVIF", "Could not get vif_read from config DB")

        # Create the Mem Write agent
        self.mem_write_agent_cfg = wb_master_config.type_id.create("mem_write_agent_cfg", self)
        arr = []
        # Get the instruction interface created at top
        if UVMConfigDb.get(None, "*", "vif_write", arr) is True:
            UVMConfigDb.set(self, "*", "vif_write", arr[0])
            # Make this agent's interface the interface connected at top
            self.mem_write_agent_cfg.vif         = arr[0]
            self.mem_write_agent_cfg.has_driver  = 1
            self.mem_write_agent_cfg.has_monitor = 1
        else:
            uvm_fatal("NOVIF", "Could not get vif_write from config DB")

        # Make this instruction agent the test bench config agent
        self.tb_env_config.inst_agent_cfg = self.inst_agent_cfg
        self.tb_env_config.mem_read_agent_cfg = self.mem_read_agent_cfg
        self.tb_env_config.mem_write_agent_cfg = self.mem_write_agent_cfg
        UVMConfigDb.set(self, "*", "tb_env_config", self.tb_env_config)
        # Create the test bench environment 
        self.tb_env = orc_r32i_tb_env.type_id.create("tb_env", self)
        # Create a specific depth printer for printing the created topology
        self.printer = UVMTablePrinter()
        self.printer.knobs.depth = 4


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
        self.hex_instructions = []
        self.fetched_instruction = None
        self.count = 112


    async def run_phase(self, phase):
        # Initial setup
        self.read_hex()
        slave_sqr = self.tb_env.inst_agent.sqr
        
        # Fetch instruction
        self.fetch_instruction(self.count)

        #  Create seq0
        slave_seq0 = read_single_sequence("slave_seq0")
        slave_seq0.data = self.fetched_instruction # 74135
        #slave_seq0.opcaode = "AUIPC" 

        # Fetch instruction
        self.count = self.count + 1
        self.fetch_instruction(self.count)

        slave_seq1 = read_single_sequence("slave_seq1")
        slave_seq1.data = self.fetched_instruction # 646021523
        #slave_seq1.opcaode = "RII"

        # Fetch instruction
        self.count = self.count + 1
        self.fetch_instruction(self.count)

        slave_seq2 = read_single_sequence("slave_seq2")
        slave_seq2.data = self.fetched_instruction # 2193720595
        #slave_seq2.opcaode = "RII" 

        # Fetch instruction
        self.count = self.count + 1
        self.fetch_instruction(self.count)

        slave_seq3 = read_single_sequence("slave_seq3")
        slave_seq3.data = self.fetched_instruction # 83479
        #slave_seq3.opcaode = "AUIPC"

        # Fetch instruction
        self.count = self.count + 1
        self.fetch_instruction(self.count)

        slave_seq4 = read_single_sequence("slave_seq4")
        slave_seq4.data = self.fetched_instruction # 1166118409
        #slave_seq4.opcaode = "JAL"

        # Fetch instruction
        self.count = self.count + 1
        self.fetch_instruction(self.count)

        slave_seq5 = read_single_sequence("slave_seq5")
        slave_seq5.data = self.fetched_instruction # 714080495
        #slave_seq5.opcaode = "JAL"

        # Fetch instruction
        self.count = self.count + 1
        self.fetch_instruction(self.count)

        slave_seq6 = read_single_sequence("slave_seq6")
        slave_seq6.data = self.fetched_instruction # 46351203
        #slave_seq6.data = 46363491
        #slave_seq6.opcaode = "BCC" 46351203

        # Fetch instruction
        self.count = self.count + 1
        self.fetch_instruction(self.count)

        slave_seq7 = read_single_sequence("slave_seq6")
        slave_seq7.data = self.fetched_instruction # 2181145347
        #slave_seq6.opcaode = "LCC"

        # Fetch instruction
        self.count = self.count + 1
        self.fetch_instruction(self.count)

        slave_seq5 = read_single_sequence("slave_seq5")
        slave_seq5.data = self.fetched_instruction # 714080495
        #slave_seq5.opcaode = "JAL"

        # Fetch instruction
        self.count = self.count + 1
        self.fetch_instruction(self.count)

        slave_seq2 = read_single_sequence("slave_seq2")
        slave_seq2.data = self.fetched_instruction # 2193720595
        #slave_seq2.opcaode = "RII" 

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

        #await slave_seq7.start(slave_sqr)
        await slave_seq7.start(slave_sqr)


    def read_hex(self):
        f = open('dhry.hex', 'r+')
        hex_inst_list = [line.split(' ') for line in f.readlines()]
        #f'{6:08b}'
        self.hex_instructions = []
        for i,s in enumerate(hex_inst_list):
            self.hex_instructions.append([i.strip() for i in s])

    def fetch_instruction(self, count):
        hex_string = self.hex_instructions[count][3] + self.hex_instructions[count][2] + self.hex_instructions[count][1] + self.hex_instructions[count][0]
        self.fetched_instruction = int(hex_string, 16)

uvm_component_utils(orc_r32i_reg_test)