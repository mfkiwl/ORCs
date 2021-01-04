# Results : Resources and Timing Estimates
_These results were generated using Yosys, NextPNR and the Icestorm tool chain targeting the Lattice HX8k breakout board. These result only account for this core being in the FPGA, as it gets integrated into a design with more components the overall max clock of the system will be lower since the more resources used in a FPGA the harder it is to meet timing._

## Synthesis 
 Yosys version: `Yosys 0.9+3814 (git sha1 da1d06d7, gcc 10.2.0-13ubuntu1 -fPIC -Os)`

 Yosys script: `syn_ice40.ys`

### Synthesis Results
| Resource                  | Usage Count | 
| :------------------------ | ----------: |
| Number of  wire           |          627|
| Number of wire bits       |         3086|
| Number of public wires    |          627|
| Number of public wire bits|         3086|
| Number of memories        |            0|
| Number of memory bits     |            0|
| Number of processes       |            0|
| Number of cells<br> --- SB_CARRY <br> --- SB_DFF <br> --- SB_DFFESR <br> --- SB_DFFESS <br> --- SB_DFFSR <br> --- SB_LUT4 <br> --- SB_RAM40_4K |               1610<br>234<br>2<br>99<br>1<br>11<br>1259<br>4|


## Plance and Route
NextPnR version: `nextpnr-ice40 -- Next Generation Place and Route (Version bdaa9f0e)`

nextpnr-ice40 flags : `--pcf-allow-unconstrained --timing-allow-fail --ignore-loops --pre-pack pre_pack.py --opt-timing --seed 2070319`


### Resources Utilization 

|Device Resources |Device Utilization|Percentage|
| --------------: | :--------------: | :------: |
|ICESTORM_LC      |  1369 / 7680     |    17%   |
|ICESTORM_RAM     |     4 /   32     |    12%   |
|SB_IO            |   204 /  256     |    79%   |
|SB_GB            |     4 /    8     |    50%   |
|ICESTORM_PLL     |     0 /    2     |     0%   |
|SB_WARMBOOT      |     0 /    1     |     0%   |


**Checksum:** 0xb6091c12

### Slack

|**Slack histogram** | Legend:<br> * represents 2 endpoint(s) + represents [1,2) endpoint(s)|
| :--------------: | :-------------------------------------------------------- |
| [ 66625,  67388) |*****+|
| [ 67388,  68151) |*******+|
| [ 68151,  68914) |************+|
| [ 68914,  69677) |*************+|
| [ 69677,  70440) |**********+|
| [ 70440,  71203) |**********************+|
| [ 71203,  71966) |********+|
| [ 71966,  72729) |*********************************+|
| [ 72729,  73492) |*********+|
| [ 73492,  74255) |*************************+|
| [ 74255,  75018) |********************+|
| [ 75018,  75781) |**********************************+|
| [ 75781,  76544) |********************+|
| [ 76544,  77307) |*********************************+|
| [ 77307,  78070) |****************************************+|
| [ 78070,  78833) |*********************+|
| [ 78833,  79596) |******************+|
| [ 79596,  80359) |************************************************************ |
| [ 80359,  81122) |*******************************+|
| [ 81122,  81885) |******************+|


### Clock slack

Info: Max frequency for clock 'i_clk$SB_IO_IN_$glb_clk': 59.85 MHz (PASS at 12.00 MHz)

Info: Max delay <async>                         -> posedge i_clk$SB_IO_IN_$glb_clk: 15.45 ns
Info: Max delay posedge i_clk$SB_IO_IN_$glb_clk -> <async>                        : 12.92 ns


## IceTime timing Analysis

Total number of logic levels: 37

Total path delay: 17.09 ns (59.28 MHz)

# Running

For a single run use
    make all

For running regression with multiple seeds
    make -j`nproc` rpt