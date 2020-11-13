# Results : Resources and Timing Estimates
_This results were generated using Yosys, NextPNR and the Icestorm tool chain targeting the Lattice HX8k breakout board. These result only account for this core being in the FPGA, as it gets integrated into a design with more components the overall max clock of the system will be lower since the more resources used in a FPGA the harder it is to meet timing._

## Synthesis 
 Yosys version: `0.9+3667 (git sha1 e7f36d01, clang 11.0.0-2 -fPIC -Os)`

 Yosys flags: `-abc9`

### Synthesis Results
| Resource | Usage Count | 
| :-------------- | ---------: |
| Number of  wire           | 1308|
| Number of wire bits       | 3690|
| Number of public wires    | 1308|
| Number of public wire bits| 3690|
| Number of memories|               0|
| Number of memory bits|            0|
| Number of processes|              0|
| Number of cells<br> --- SB_CARRY<br> --- SB_DFF <br> --- SB_DFFESR <br> --- SB_DFFSR <br> --- SB_LUT4 <br> --- SB_RAM40_4K |               2005<br>247<br>32<br>276<br>75<br>1371<br>4|

## Plance and Route
NextPnR version: `(Version d5dde5df)`

nextpnr-ice40 flags : `--pcf-allow-unconstrained --timing-allow-fail --ignore-loops --pre-pack pre_pack.py --opt-timing --seed 1`

### Slack

|**Slack histogram** | Legend:<br> * represents 5 endpoint(s) + represents [1,5) endpoint(s)|
| :--------------: | :-------------- |
|[ 67419,  68166) |*+|
|[ 68166,  68913) |****+|
|[ 68913,  69660) |****+|
|[ 69660,  70407) |************+|
|[ 70407,  71154) |****+|
|[ 71154,  71901) |****+|
|[ 71901,  72648) |**+|
|[ 72648,  73395) |***+|
|[ 73395,  74142) |**************+|
|[ 74142,  74889) |*********************+|
|[ 74889,  75636) |*******+|
|[ 75636,  76383) |************************+|
|[ 76383,  77130) |*******+|
|[ 77130,  77877) |*************+|
|[ 77877,  78624) |*+|
|[ 78624,  79371) |***+|
|[ 79371,  80118) |*********+|
|[ 80118,  80865) |************************************************************ |
|[ 80865,  81612) |***************+|
|[ 81612,  82359) |*****************+|


### Clock slack

    Max frequency for clock 'i_clk$SB_IO_IN_$glb_clk': 62.84 MHz (PASS at 12.00 MHz)
    Max delay <async>                         -> posedge i_clk$SB_IO_IN_$glb_clk: 15.87 ns
    Max delay posedge i_clk$SB_IO_IN_$glb_clk -> <async>                        : 4.10 ns


## IceTime timing Analysis

Total number of logic levels: 12
Total path delay: 16.28 ns (61.42 MHz)