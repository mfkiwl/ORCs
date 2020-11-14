# Results : Resources and Timing Estimates
_This results were generated using Yosys, NextPNR and the Icestorm tool chain targeting the Lattice HX8k breakout board. These result only account for this core being in the FPGA, as it gets integrated into a design with more components the overall max clock of the system will be lower since the more resources used in a FPGA the harder it is to meet timing._

## Synthesis 
 Yosys version: `0.9+3667 (git sha1 e7f36d01, clang 11.0.0-2 -fPIC -Os)`

 Yosys flags: `-abc9`

### Synthesis Results
| Resource | Usage Count | 
| :-------------- | ---------: |
| Number of  wire           | 1286|
| Number of wire bits       | 3556|
| Number of public wires    | 1286|
| Number of public wire bits| 3556|
| Number of memories|               0|
| Number of memory bits|            0|
| Number of processes|              0|
| Number of cells<br> --- SB_CARRY <br> --- SB_DFF <br> --- SB_DFFE <br> --- SB_DFFESR <br> --- SB_DFFSR <br> --- SB_LUT4 <br> --- SB_RAM40_4K |               2005<br>251<br>32<br>5<br>244<br>75<br>1393<br>4|

## Plance and Route
NextPnR version: `(Version d5dde5df)`

nextpnr-ice40 flags : `--pcf-allow-unconstrained --timing-allow-fail --ignore-loops --pre-pack pre_pack.py --opt-timing --seed 0`

### Slack

|**Slack histogram** | Legend:<br> * represents 5 endpoint(s) + represents [1,5) endpoint(s)|
| :--------------: | :-------------- |
|[ 66873,  67640) |*+|
|[ 67640,  68407) |****+|
|[ 68407,  69174) |****+|
|[ 69174,  69941) |****+|
|[ 69941,  70708) |+|
|[ 70708,  71475) |********+|
|[ 71475,  72242) |**+|
|[ 72242,  73009) |****+|
|[ 73009,  73776) |******+|
|[ 73776,  74543) |******************+|
|[ 74543,  75310) |********************+|
|[ 75310,  76077) |***************+|
|[ 76077,  76844) |*****************+|
|[ 76844,  77611) |***+|
|[ 77611,  78378) |****************+|
|[ 78378,  79145) |**+|
|[ 79145,  79912) |*********+|
|[ 79912,  80679) |************************************************************ |
|[ 80679,  81446) |**********************+|
|[ 81446,  82213) |*****************+|


### Clock slack

    Max frequency for clock 'i_clk$SB_IO_IN_$glb_clk': 60.75 MHz (PASS at 12.00 MHz)
    Max delay <async>                         -> posedge i_clk$SB_IO_IN_$glb_clk: 14.91 ns
    Max delay posedge i_clk$SB_IO_IN_$glb_clk -> <async>                        : 4.41 ns



## IceTime timing Analysis

Total number of logic levels: 12
Total path delay: 16.63 ns (60.13 MHz)