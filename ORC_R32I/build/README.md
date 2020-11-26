# Results : Resources and Timing Estimates
_This results were generated using Yosys, NextPNR and the Icestorm tool chain targeting the Lattice HX8k breakout board. These result only account for this core being in the FPGA, as it gets integrated into a design with more components the overall max clock of the system will be lower since the more resources used in a FPGA the harder it is to meet timing._

## Synthesis 
 Yosys version: `0.9+3667 (git sha1 e7f36d01, clang 11.0.0-2 -fPIC -Os)`

 Yosys flags: `-abc9`

### Synthesis Results
| Resource                  | Usage Count | 
| :------------------------ | ----------: |
| Number of  wire           |         1109|
| Number of wire bits       |         3382|
| Number of public wires    |         1109|
| Number of public wire bits|         3382|
| Number of memories        |            0|
| Number of memory bits     |            0|
| Number of processes       |             0|
| Number of cells<br> --- SB_CARRY <br> --- SB_DFF <br> --- SB_DFFE <br> --- SB_DFFESR <br> --- SB_DFFSR <br> --- SB_LUT4 <br> --- SB_RAM40_4K |               1825<br>269<br>1<br>5<br>202<br>6<br>1338<br>4|

## Plance and Route
NextPnR version: `(Version d5dde5df)`

nextpnr-ice40 flags : `--pcf-allow-unconstrained --timing-allow-fail --ignore-loops --pre-pack pre_pack.py --opt-timing --seed 0`


### Resources Utilization 

|Device Resources |Device Utilization|Percentage|
| --------------: | :--------------: | :------: |
|ICESTORM_LC      |  1548 / 7680     |    20%   |
|ICESTORM_RAM     |     4 /   32     |    12%   |
|SB_IO            |   204 /  256     |    79%   |
|SB_GB            |     6 /    8     |    75%   |
|ICESTORM_PLL     |     0 /    2     |     0%   |
|SB_WARMBOOT      |     0 /    1     |     0%   |


**Checksum:** 0xe91059d4

### Slack

|**Slack histogram** | Legend:<br> * represents 5 endpoint(s) + represents [1,5) endpoint(s)|
| :--------------: | :-------------- |
|Info: [ 65476,  66313) |********+|
|Info: [ 66313,  67150) |****+|
|Info: [ 67150,  67987) |**************+|
|Info: [ 67987,  68824) |**************+|
|Info: [ 68824,  69661) |****+|
|Info: [ 69661,  70498) |************+|
|Info: [ 70498,  71335) |**********************+|
|Info: [ 71335,  72172) |***********************+|
|Info: [ 72172,  73009) |*********+|
|Info: [ 73009,  73846) |*********************+|
|Info: [ 73846,  74683) |****************+|
|Info: [ 74683,  75520) |********************************+|
|Info: [ 75520,  76357) |********************************+|
|Info: [ 76357,  77194) |****** |
|Info: [ 77194,  78031) |***+|
|Info: [ 78031,  78868) |*** |
|Info: [ 78868,  79705) |***********+|
|Info: [ 79705,  80542) |************************************************************ |
|Info: [ 80542,  81379) |********************+|
|Info: [ 81379,  82216) |*************+|


### Clock slack

    Max frequency for clock 'i_clk$SB_IO_IN_$glb_clk': 56.00 MHz (PASS at 12.00 MHz)
    
    Max delay <async>                         -> <async>                        : 9.14 ns
    Max delay <async>                         -> posedge i_clk$SB_IO_IN_$glb_clk: 15.78 ns
    Max delay posedge i_clk$SB_IO_IN_$glb_clk -> <async>                        : 16.57 ns



## IceTime timing Analysis

Total number of logic levels: 32

Total path delay: 18.09 ns (55.28 MHz)
