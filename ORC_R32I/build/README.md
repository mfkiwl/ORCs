# Build Examples (Core only)

## Lattice_HX8K
This directory dedicated to the Lattice HX8K Breakout board. Contains results of synthesis, technology specific mapping, place and route along with the artifacts used to produce them. 

## Sipeed_PriMER
This directory dedicated to the SiPEED's TANG PRiMER FPGA Dev Board (https://www.seeedstudio.com/Sipeed-TANG-PriMER-FPGA-Development-Board-p-2881.html). Contains results of synthesis, technology specific mapping, place and route along with the artifacts used to produce them. There are two different ways to build for this FPGA since yosys can be used to pre-map the design or use TANG Dynasty (td) workflow. 

Anlogic's EG4S20 td tool will identify inferred ram but does not map inferred ram into the technology specific IP's. Rather it expects the system integrator to use the IP generator in td to create BRAM and DSP code to be integrated into the project. Therefore the original source code will crash the tool. A modified version of the code targeting the technology specific BRAM code is include and named ORC_R32I_ANLOGIC.v. The BRAM code created by the IP generator is included and named ram.v

Yosys support for the Anlogic EG4S20 FPGA present in this board is partially supported. It does not support the dsp and brams but it will convert the inferred ram code to lut rams. Therefore the orginal source code for the ORC_R32I can be pre-mapped with yosys and then fed to td for final mapping.

## Vivado
Includes the project used to obtain synthesis results.
