SIM = verilator
TOPLEVEL_LANG = verilog
EXTRA_ARGS += --trace --trace-structs
VERILOG_SOURCES = $(shell pwd)/../source/ORC_R32I.v ./ORC_R32I_TOP.v
TOPLEVEL = ORC_R32I_TOP
MODULE = top

include $(shell cocotb-config --makefiles)/Makefile.sim
