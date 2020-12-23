# Results : Resources and Timing Estimates
_This results were generated using Yosys, NextPNR and the Icestorm tool chain targeting the Lattice HX8k breakout board. These result only account for this core being in the FPGA, as it gets integrated into a design with more components the overall max clock of the system will be lower since the more resources used in a FPGA the harder it is to meet timing._

## Synthesis 
 Yosys version: `0.9+3715 (git sha1 d021f4b4, clang 11.0.0-2 -fPIC -Os)`

 Yosys flags: `-synth_ice40 -abc2 -retime -device hx`

### Synthesis Results
| Resource                  | Usage Count | 
| :------------------------ | ----------: |
| Number of  wire           |          631|
| Number of wire bits       |         3169|
| Number of public wires    |          631|
| Number of public wire bits|         3169|
| Number of memories        |            0|
| Number of memory bits     |            0|
| Number of processes       |            0|
| Number of cells<br> --- SB_CARRY <br> --- SB_DFF <br> --- SB_DFFE <br> --- SB_DFFESR <br> --- SB_DFFESS <br> --- SB_DFFSR <br> --- SB_LUT4 <br> --- SB_RAM40_4K |               1828<br>329<br>5<br>5<br>101<br>1<br>6<br>1377<br>4|


## Plance and Route
NextPnR version: `(Version 868902fb)`

nextpnr-ice40 flags : `--pcf-allow-unconstrained --timing-allow-fail --ignore-loops --pre-pack pre_pack.py --opt-timing --seed 307`


### Resources Utilization 

|Device Resources |Device Utilization|Percentage|
| --------------: | :--------------: | :------: |
|ICESTORM_LC      |  1568 / 7680     |    20%   |
|ICESTORM_RAM     |     4 /   32     |    12%   |
|SB_IO            |   204 /  256     |    79%   |
|SB_GB            |     4 /    8     |    50%   |
|ICESTORM_PLL     |     0 /    2     |     0%   |
|SB_WARMBOOT      |     0 /    1     |     0%   |


**Checksum:** 0xb54e1d6e

### Slack

|**Slack histogram** | Legend:<br> * represents 5 endpoint(s) + represents [1,5) endpoint(s)|
| :--------------: | :-------------------------------------------------------- |
| [ 64819,  65672) |*************+|
| [ 65672,  66525) |**********+|
| [ 66525,  67378) |*****+|
| [ 67378,  68231) |****************+|
| [ 68231,  69084) |****+|
| [ 69084,  69937) |****+|
| [ 69937,  70790) |*********+|
| [ 70790,  71643) |*******************+|
| [ 71643,  72496) |***********************+|
| [ 72496,  73349) |****************************** |
| [ 73349,  74202) |******************************+|
| [ 74202,  75055) |*********************************+|
| [ 75055,  75908) |*****************+|
| [ 75908,  76761) |*******************+|
| [ 76761,  77614) |*****+|
| [ 77614,  78467) |****************************+|
| [ 78467,  79320) |******+|
| [ 79320,  80173) |************************************************************ |
| [ 80173,  81026) |***********************+|
| [ 81026,  81879) |***********************+|


### Clock slack

    Max frequency for clock 'i_clk$SB_IO_IN_$glb_clk': 54.01 MHz (PASS at 12.00 MHz)
    Max delay <async>                         -> posedge i_clk$SB_IO_IN_$glb_clk: 15.59 ns
    Max delay posedge i_clk$SB_IO_IN_$glb_clk -> <async>                        : 12.29 ns
    
## IceTime timing Analysis

Total number of logic levels: 38

Total path delay: 18.73 ns (53.38 MHz)
