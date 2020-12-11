# ORCs
**O**pen-source **R**ISC-V **C**ores
This project aims to create a collection of _harts_ complaint to the RISC-V ISA. Unlike other projects this one does not seek to create the smallest risc-v implementation but it is rather an experiment on implementing the risc-v ISA on accessible or popular FPGA dev boards.

## ORC R32I
RV32I un-privileged hart implementation directory. Contains the source code, simulation files and examples for synthesis and place-and-route.

This project is currently under progress it uses previous work from the DarkRISCV project (https://github.com/darklife/darkriscv) as a starting reference. The instruction interface was swap from a streaming interface to a memory interface(Wishbone pipeline). The pipeline is also different, the DarRISCV uses a flush and halt mechanism, the ORC R32I (and probably all other future ORCs) use a handshake design. There is a valid and ready signal for each process to control the pipeline.

The ORC_R32I/source folder contains more on th specifications and the verilog code. For Lattice iCE40 HX8k resource cost see the results in ORC_R32I/build/Lattice_HX8k 

## Current State
The code synthesizes, which provides a reference on possible FPGA resource usage and timing. The test bench is under progress. It is being written using uvm-python and cocotb.

The design build results for the Lattice HX8K can be found in the build directory, it consumes about 20% of the cells and about ~1377 LUTs and can close timing with a clock of ~50MHz depending on PnR.

For a Xilinx S7 like the one in the Arty board it will consume ~1100 LUTs and runs up to 140MHz of clock speed.

The current code will not work for Anlogic FPGAs. The attempt to synthesize the code targeting the Sipeed TANG PriMER FPGA board  resulted on crashing Tang Dynasty, (V4.6.18154). Looks like the BRAMs need to be created using their IP generator and then instantiate that module withing the code unlike other synthesis software that would do that automagicly.

## Performance

### Clocks Per Instructions
 _________\ Pipeline Stage <br> Instruction \ ___________ | Fetch | Decode | Register | Response | Total Clocks
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
Finish test bench, benchmark and build an integrated example... and work on fixes for bugs yet to be discovered.
