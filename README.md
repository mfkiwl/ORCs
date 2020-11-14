# ORCs
Open-source RISC-V Cores

## ORC R32I
Open-source RISC-V Core un-priviledge riscv32i implementation directory. Contains the source code, simulation files and examples for synthesis and place-and-route.

This project is currently under progress it uses previous work from the DarkRISCV project (https://github.com/darklife/darkriscv) as a starting reference. Hopefully this Verilog-2005 code is easier to understand for people more used too VHDL. The instruction interface was swap from a streaming interface to a memory interface. The pipeline is also different, the DarRISCV uses a flush and halt mechanism, the ORC R32I (and probably all other future ORCs) use a handshake design. There is a valid and ready signal for each process to control the pipeline.

## Current State
The code synthesizes, which provides a reference on possible FPGA resource usage and timing. The test bench is under progress. It is being written using uvm-python and cocotb. The Dhrystone benchmark code from picorv32 is being ported.

## Tools Directory
Collection of tools for compiling, synthesizing, building, simulating and verifying the implementations. **A recursive GIT clone takes about 7GB of disk space.**

## To Do 
Verify, validate and benchmark... and work on fixes for bugs yet to be discovered.
