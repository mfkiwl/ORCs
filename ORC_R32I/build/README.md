# Results : Resources and Timing Estimates
_This results were generated using Yosys, NextPNR and the Icestorm tool chain targeting the Lattice HX8k breakout board. These result only account for this core being in the FPGA, as it gets integrated into a design with more components the overall max clock of the system will be lower since the more resources used in a FPGA the harder it is to meet timing._

## Synthesis 
 Yosys version: `0.9+3667 (git sha1 e7f36d01, clang 11.0.0-2 -fPIC -Os)`

 Yosys flags: `-abc9`

### Synthesis Results
| Resource                  | Usage Count | 
| :------------------------ | ----------: |
| Number of  wire           |         1124|
| Number of wire bits       |         3493|
| Number of public wires    |         1124|
| Number of public wire bits|         3493|
| Number of memories        |            0|
| Number of memory bits     |            0|
| Number of processes       |             0|
| Number of cells<br> --- SB_CARRY <br> --- SB_DFF <br> --- SB_DFFE <br> --- SB_DFFESR <br> --- SB_DFFESS <br> --- SB_DFFSR <br> --- SB_LUT4 <br> --- SB_RAM40_4K |               1809<br>269<br>5<br>5<br>133<br>1<br>6<br>1386<br>4|


## Plance and Route
NextPnR version: `(Version d5dde5df)`

nextpnr-ice40 flags : `--pcf-allow-unconstrained --timing-allow-fail --ignore-loops --pre-pack pre_pack.py --opt-timing --seed 0`


### Resources Utilization 

|Device Resources |Device Utilization|Percentage|
| --------------: | :--------------: | :------: |
|ICESTORM_LC      |  1566 / 7680     |    20%   |
|ICESTORM_RAM     |     4 /   32     |    12%   |
|SB_IO            |   204 /  256     |    79%   |
|SB_GB            |     4 /    8     |    50%   |
|ICESTORM_PLL     |     0 /    2     |     0%   |
|SB_WARMBOOT      |     0 /    1     |     0%   |


**Checksum:** 0xeb8ad1b6

### Slack

|**Slack histogram** | Legend:<br> * represents 5 endpoint(s) + represents [1,5) endpoint(s)|
| :--------------: | :-------------- |
|[ 65019,  65862) |**********+|
|[ 65862,  66705) |*****+|
|[ 66705,  67548) |******+|
|[ 67548,  68391) |*****+|
|[ 68391,  69234) |************+|
|[ 69234,  70077) |*****+|
|[ 70077,  70920) |*******+|
|[ 70920,  71763) |********+|
|[ 71763,  72606) |***************+|
|[ 72606,  73449) |***************************+|
|[ 73449,  74292) |**********************+|
|[ 74292,  75135) |*************************+|
|[ 75135,  75978) |**********************+|
|[ 75978,  76821) |***************************+|
|[ 76821,  77664) |***********************+|
|[ 77664,  78507) |***+|
|[ 78507,  79350) |***+|
|[ 79350,  80193) |*****************+|
|[ 80193,  81036) |************************************************************ |
|[ 81036,  81879) |************************+|


### Clock slack

    Max frequency for clock 'i_clk$SB_IO_IN_$glb_clk': 53.25 MHz (PASS at 12.00 MHz)
    
    Max delay <async>                         -> <async>                        : 8.92 ns
    Max delay <async>                         -> posedge i_clk$SB_IO_IN_$glb_clk: 16.04 ns
    Max delay posedge i_clk$SB_IO_IN_$glb_clk -> <async>                        : 17.11 ns



## IceTime timing Analysis

Total number of logic levels: 11

Total path delay: 18.16 ns (55.07 MHz)
