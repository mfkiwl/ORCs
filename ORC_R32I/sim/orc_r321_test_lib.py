import cocotb
from cocotb.triggers import Timer

from uvm import *
from memory_intfc_read_slave_seq import *
from memory_intfc_read_slave_agent import *
from memory_intfc_read_slave_config import *
from tb_env_config import *
from orc_r321_tb_env import *
from mem_model import *

class orc_r321_test_base(UVMTest):


    def __init__(self, name="orc_r321_test_base", parent=None):
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
        self.tb_env = orc_r321_tb_env.type_id.create("tb_env", self)
        # Create a specific depth printer for printing the created topology
        self.printer = UVMTablePrinter()
        self.printer.knobs.depth = 3



    def end_of_elaboration_phase(self, phase):
        # Set verbosity for the bus monitor for this demo
        # if self.ubus_example_tb0.ubus0.bus_monitor is not None:
        #     self.ubus_example_tb0.ubus0.bus_monitor.set_report_verbosity_level(UVM_FULL)
        uvm_info(self.get_type_name(),
            sv.sformatf("Printing the test topology :\n%s", self.sprint(self.printer)), UVM_LOW)


    #  task run_phase(uvm_phase phase)
    #    //set a drain-time for the environment if desired
    #    phase.phase_done.set_drain_time(this, 50)
    #  endtask : run_phase

    # def extract_phase(self, phase):
    #     self.err_msg = ""
    #     if self.ubus_example_tb0.scoreboard0.sbd_error:
    #         self.test_pass = False
    #         self.err_msg += '\nScoreboard error flag set'
    #     if self.ubus_example_tb0.scoreboard0.num_writes == 0:
    #         self.test_pass = False
    #         self.err_msg += '\nnum_writes == 0 in scb'
    #     if self.ubus_example_tb0.scoreboard0.num_init_reads == 0:
    #         self.test_pass = False
    #         self.err_msg += '\nnum_init_reads == 0 in scb'


    def report_phase(self, phase):
        if self.test_pass:
            uvm_info(self.get_type_name(), "** UVM TEST PASSED **", UVM_NONE)
        else:
            uvm_fatal(self.get_type_name(), "** UVM TEST FAIL **\n" +
                self.err_msg)


    #endclass : ubus_example_base_test
uvm_component_utils(orc_r321_test_base)


class orc_r321_reg_test(orc_r321_test_base):


    def __init__(self, name="orc_r321_reg_test", parent=None):
        super().__init__(name, parent)


    async def run_phase(self, phase):
        phase.raise_objection(self, "test_read OBJECTED")
        slave_sqr = self.tb_env.inst_agent.sqr
        slave_seq = read_sequence("read_seq")
        #slave_seq.data = 5
        slave_proc = cocotb.fork(slave_seq.start(slave_sqr))
        await slave_proc
        #await sv.fork_join_any(slave_proc)
        phase.drop_objection(self, "test_read drop objection")


uvm_component_utils(orc_r321_reg_test)