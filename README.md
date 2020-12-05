# ORCs
**O**pen-source **R**ISC-V **C**ores
This project aims to create a collection of _harts_ complaint to the RISC-V ISA.

## ORC R32I
RV32I un-priviledge hart implementation directory. Contains the source code, simulation files and examples for synthesis and place-and-route.

This project is currently under progress it uses previous work from the DarkRISCV project (https://github.com/darklife/darkriscv) as a starting reference. Hopefully this Verilog-2005 code is easier to understand for people more used too VHDL. The instruction interface was swap from a streaming interface to a memory interface. The pipeline is also different, the DarRISCV uses a flush and halt mechanism, the ORC R32I (and probably all other future ORCs) use a handshake design. There is a valid and ready signal for each process to control the pipeline.

## Current State
The code synthesizes, which provides a reference on possible FPGA resource usage and timing. The test bench is under progress. It is being written using uvm-python and cocotb. The Dhrystone benchmark code from picorv32 is being ported. Note that this benchmark calls multiplication and division opcodes which are not part of the RV32I instruction set, so it is yet to be fully determined whether it is worth the effort at this point.

The design build results for the Lattice HX8K can e found in the build directory, it consumes about 20% of the cells (~1377 LUTs) and can close timing with a clock of ~50MHz depending on PnR. 
For a Xilinx S7 like the one in the Arty board it will consume about 8% of resources (~1100 LUTs) and run up to 140MHz of clock speed.
The current code will not work for Anlogic FPGAs. The attempt to synthesize the code targeting the Sipeed TANG PriMER FPGA board  resulted on crashing Tang Dynasty, (V4.6.18154). Looks like the BRAMs need to be created using their IP generator and then instantiate that module withing the code unlike other synthesis software that would do that automagicly.

## Performance

### Clocks Per Instructions
 _________\ Waits For <br> Instruction \ ________ | Fetch | Decode | Register | Response | Total Clocks
:---------- | :---: | :----: | :------: | :------: | :----------:
LUI         |   ✔️   |    ✔️   |          |          |      2
AUIPC       |   ✔️   |    ✔️   |          |          |      2
JAL         |   ✔️   |    ✔️   |          |          |      2
JALR        |   ✔️   |    ✔️   |     ✔️    |          |      3
BRANCH      |   ✔️   |    ✔️   |     ✔️    |          |      3
R-R         |   ✔️   |    ✔️   |     ✔️    |          |      3
R-I         |   ✔️   |    ✔️   |     ✔️    |          |      3
Load        |   ✔️   |    ✔️   |     ✔️    |    ✔️     |      4*
Store       |   ✔️   |    ✔️   |     ✔️    |    ✔️     |      4*

_*minimum_

## Tools Directory
Collection of tools for compiling, synthesizing, building, simulating and verifying the implementations. **A recursive GIT clone takes about 7GB of disk space.**

## To Do 
Verify, validate and benchmark... and work on fixes for bugs yet to be discovered.
