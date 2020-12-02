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
# File name     : orc_r32i_tb_env.py
# Author        : Jose R Garcia
# Created       : 2020/11/05 20:08:35
# Last modified : 2020/12/01 16:45:28
# Project Name  : UVM Python Verification Library
# Module Name   : orc_r32i_tb_env
# Description   : Memory Slave Interface  monitor.
#
# Additional Comments:
#
#################################################################################
import cocotb
from uvm.base import *
from uvm.comps import UVMEnv
from uvm.macros import uvm_component_utils
from Wishbone_Pipeline_Master.wb_master_agent import *
from mem_model import *

class orc_r32i_tb_env(UVMEnv):
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
        self.inst_agent = None
        self.predictor = None  # passive
        self.cfg = None   # tb_env_config
        self.scoreboard = None   # scoreboard
        self.f_cov = None   # functional coverage
        self.tag = "orc_r32i_tb_env"


    def build_phase(self, phase):
        super().build_phase(phase)
        """         
           Function: build_phase
          
           Definition: Gets configurations from the UVMDb and creates components.

           Args:
             phase: build_phase
        """
        arr = []
        if (not UVMConfigDb.get(self, "", "tb_env_config", arr)):
            uvm_fatal("ORC_R32I_TB_ENV/NoTbEnvConfig", "Test Bench config not found")
        
        self.cfg = arr[0]

        self.inst_agent = wb_master_agent.type_id.create("inst_agent", self)
        self.inst_agent.cfg = self.cfg.inst_agent_cfg
        
        #self.predictor = orc_r32i_predictor.type_id.create("predictor", self)
        self.predictor = UVMRegPredictor.type_id.create("predictor", self)
        
        if (self.cfg.has_scoreboard):
            self.scoreboard = simple_scoreboard.type_id.create("scoreboard", self)

    
    def connect_phase(self, phase):
        super().connect_phase(phase)
        """         
           Function: connect_phase
          
           Definition: Connects the analysis port and sequence item export. 

           Args:
             phase: connect_phase
        """
        #self.inst_agent.ap.connect(self.ap)
        if (self.cfg.has_scoreboard):
            self.inst_agent.ap.connect(self.scoreboard.analysis_export)
        self.cfg.reg_block.reg_map.set_sequencer( self.inst_agent.sqr, self.inst_agent.reg_adapter);
        self.cfg.reg_block.reg_map.set_auto_predict(on=0)
        self.predictor.map     = self.cfg.reg_block.reg_map  # passive
        self.predictor.adapter = self.inst_agent.reg_adapter # passive
        self.inst_agent.ap.connect(self.predictor.bus_in)

uvm_component_utils(orc_r32i_tb_env)
