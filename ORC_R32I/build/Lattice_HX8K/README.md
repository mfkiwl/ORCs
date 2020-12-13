# Results : Resources and Timing Estimates
_These results were generated using Yosys, NextPNR and the Icestorm tool chain targeting the Lattice HX8k breakout board. These result only account for this core being in the FPGA, as it gets integrated into a design with more components the overall max clock of the system will be lower since the more resources used in a FPGA the harder it is to meet timing._

## Synthesis 
 Yosys version: `Yosys 0.9+3755 (git sha1 442d19f6, gcc 10.2.0-13ubuntu1 -fPIC -Os)`

 Yosys script: `syn_ice40.ys`

### Synthesis Results
| Resource                  | Usage Count | 
| :------------------------ | ----------: |
| Number of  wire           |          644|
| Number of wire bits       |         3274|
| Number of public wires    |          644|
| Number of public wire bits|         3274|
| Number of memories        |            0|
| Number of memory bits     |            0|
| Number of processes       |            0|
| Number of cells<br> --- SB_CARRY <br> --- SB_DFF <br> --- SB_DFFESR <br> --- SB_DFFESS <br> --- SB_DFFSR <br> --- SB_LUT4 <br> --- SB_RAM40_4K |               1830<br>329<br>5<br>101<br>1<br>11<br>1379<br>4|


## Plance and Route
NextPnR version: `(Version 868902fb)`

nextpnr-ice40 flags : `--pcf-allow-unconstrained --timing-allow-fail --ignore-loops --pre-pack pre_pack.py --opt-timing --seed 107`


### Resources Utilization 

|Device Resources |Device Utilization|Percentage|
| --------------: | :--------------: | :------: |
|ICESTORM_LC      |  1565 / 7680     |    20%   |
|ICESTORM_RAM     |     4 /   32     |    12%   |
|SB_IO            |   204 /  256     |    79%   |
|SB_GB            |     4 /    8     |    50%   |
|ICESTORM_PLL     |     0 /    2     |     0%   |
|SB_WARMBOOT      |     0 /    1     |     0%   |


**Checksum:** 0x5d7aafa0

### Slack

|**Slack histogram** | Legend:<br> * represents 2 endpoint(s) + represents [1,2) endpoint(s)|
| :--------------: | :-------------------------------------------------------- |
| [ 66442,  67226) |*****************+|
| [ 67226,  68010) |*********+|
| [ 68010,  68794) |*********+|
| [ 68794,  69578) |***********+|
| [ 69578,  70362) |*************+|
| [ 70362,  71146) |***+|
| [ 71146,  71930) |************+|
| [ 71930,  72714) |*****************************************+|
| [ 72714,  73498) |*****************+|
| [ 73498,  74282) |*************************+|
| [ 74282,  75066) |******************************************+|
| [ 75066,  75850) |**********+|
| [ 75850,  76634) |*******+|
| [ 76634,  77418) |****************+|
| [ 77418,  78202) |****************+|
| [ 78202,  78986) |****************+|
| [ 78986,  79770) |*********+|
| [ 79770,  80554) |************************************************************ |
| [ 80554,  81338) |************************************+|
| [ 81338,  82122) |**************+|


### Clock slack

Info: Max frequency for clock 'i_clk$SB_IO_IN_$glb_clk': 59.20 MHz (PASS at 12.00 MHz)

Info: Max delay <async>                         -> posedge i_clk$SB_IO_IN_$glb_clk: 15.36 ns
Info: Max delay posedge i_clk$SB_IO_IN_$glb_clk -> <async>                        : 12.04 ns


## IceTime timing Analysis

Total number of logic levels: 39

Total path delay: 17.09 ns (58.53 MHz)

# Running

For a single run use
    make all

For running regression with multiple seeds
    make -j`nproc` rpt