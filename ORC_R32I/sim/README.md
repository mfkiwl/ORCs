# ORC_R32I Test Bench Specifications

Document        | Metadata
:-------------- | :------------------
_Version_       | v0.0.1
_Prepared by_   | Jose R Garcia
_Created_       | 2020/11/26 23:18:53
_Last modified_ | 2020/12/22 23:18:53
_Project_       | ORCs


## Table Of Contents
TBD

## Overview

TBD

 ## Syntax and Abbreviations

Term        | Definition
:---------- | :---------------------------------
0b0         | Binary number syntax
0x0000_0000 | Hexadecimal number syntax
bit         | Single binary digit (0 or 1)
BYTE        | 8-bits wide data unit
DWORD       | 32-bits wide data unit
LSB         | Least Significant bit
MSB         | Most Significant bit
UVM         | Universal Verification Methodology
WB          | Wishbone


## Prerequisites:

These ar also found in the tools/ directory.
 - Verilator and/or Icarus Verilog. 
 - cocotb
 - cocotb-coverage
 - uvm-python

To install a simulator follow the instructions in the tools/README.md
For setting cocotb and uvm-python:

    sudo apt install python3-pip
    pip install cocotb
    pip install cocotb-coverage
    git clone https://github.com/tpoikela/uvm-python.git
    cd uvm-python
    python -m pip install --user .


It is recommend to run the simulation using verilator as such
   
    make

or 

    SIM=icarus make  # Use iverilog as a simulator

Verilator is more strict on code and sometimes it will catch things that synthesis tools would make assumptions on or optimize.


## Design
TBD

## Tests
TBD