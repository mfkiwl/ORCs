# Results : Resources and Timing Estimates
_This results were generated using Yosys, NextPNR and the Icestorm tool chain targeting the Lattice HX8k breakout board. These result only account for this core being in the FPGA, as it gets integrated into a design with more components the overall max clock of the system will be lower since the more resources used in a FPGA the harder it is to meet timing._

## Synthesis 
 Yosys version: `0.9+3667 (git sha1 e7f36d01, clang 11.0.0-2 -fPIC -Os)`

 Yosys flags: `-abc9`

### Synthesis Results
| Resource                  | Usage Count | 
| :------------------------ | ----------: |
| Number of  wire           |         1107|
| Number of wire bits       |         3376|
| Number of public wires    |         1107|
| Number of public wire bits|         3376|
| Number of memories        |            0|
| Number of memory bits     |            0|
| Number of processes       |             0|
| Number of cells<br> --- SB_CARRY <br> --- SB_DFFE <br> --- SB_DFFESR <br> --- SB_DFFSR <br> --- SB_LUT4 <br> --- SB_RAM40_4K |               1828<br>268<br>38<br>160<br>8<br>1350<br>4|

## Plance and Route
NextPnR version: `(Version d5dde5df)`

nextpnr-ice40 flags : `--pcf-allow-unconstrained --timing-allow-fail --ignore-loops --pre-pack pre_pack.py --opt-timing --seed 0`


### Resources Utilization 

|Device Resources |Device Utilization|Percentage|
| --------------: | :--------------: | :------: |
|ICESTORM_LC      |  1551 / 7680     |    20%   |
|ICESTORM_RAM     |     4 /   32     |    12%   |
|SB_IO            |   204 /  256     |    79%   |
|SB_GB            |     6 /    8     |    75%   |
|ICESTORM_PLL     |     0 /    2     |     0%   |
|SB_WARMBOOT      |     0 /    1     |     0%   |


**Checksum:** 0x04633f8d

### Slack

|**Slack histogram** | Legend:<br> * represents 5 endpoint(s) + represents [1,5) endpoint(s)|
| :--------------: | :-------------- |
|Info: [ 64552,  65439) |********+|
|Info: [ 65439,  66326) |****+|
|Info: [ 66326,  67213) |************+|
|Info: [ 67213,  68100) |**********************+|
|Info: [ 68100,  68987) |****+|
|Info: [ 68987,  69874) |*********+|
|Info: [ 69874,  70761) |*********+|
|Info: [ 70761,  71648) |***************+|
|Info: [ 71648,  72535) |************+|
|Info: [ 72535,  73422) |************************************************+|
|Info: [ 73422,  74309) |***********+|
|Info: [ 74309,  75196) |****************************+|
|Info: [ 75196,  76083) |************************+|
|Info: [ 76083,  76970) |*************************+|
|Info: [ 76970,  77857) |*******+|
|Info: [ 77857,  78744) |*****+|
|Info: [ 78744,  79631) |**********************+|
|Info: [ 79631,  80518) |************************************************************ |
|Info: [ 80518,  81405) |*****************************+|
|Info: [ 81405,  82292) |***************+|


### Clock slack

    Max frequency for clock 'i_clk$SB_IO_IN_$glb_clk': 53.25 MHz (PASS at 12.00 MHz)
    
    Max delay <async>                         -> <async>                        : 8.92 ns
    Max delay <async>                         -> posedge i_clk$SB_IO_IN_$glb_clk: 16.04 ns
    Max delay posedge i_clk$SB_IO_IN_$glb_clk -> <async>                        : 17.11 ns



## IceTime timing Analysis

Total number of logic levels: 13

Total path delay: 19.53 ns (51.21 MHz)
