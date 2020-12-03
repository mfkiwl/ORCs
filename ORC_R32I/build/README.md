# Results : Resources and Timing Estimates
_This results were generated using Yosys, NextPNR and the Icestorm tool chain targeting the Lattice HX8k breakout board. These result only account for this core being in the FPGA, as it gets integrated into a design with more components the overall max clock of the system will be lower since the more resources used in a FPGA the harder it is to meet timing._

## Synthesis 
 Yosys version: `0.9+3715 (git sha1 d021f4b4, clang 11.0.0-2 -fPIC -Os)`

 Yosys flags: `-synth_ice40 -abc2 -retime -device hx`

### Synthesis Results
| Resource                  | Usage Count | 
| :------------------------ | ----------: |
| Number of  wire           |          631|
| Number of wire bits       |         3164|
| Number of public wires    |          631|
| Number of public wire bits|         3164|
| Number of memories        |            0|
| Number of memory bits     |            0|
| Number of processes       |            0|
| Number of cells<br> --- SB_CARRY <br> --- SB_DFF <br> --- SB_DFFE <br> --- SB_DFFESR <br> --- SB_DFFESS <br> --- SB_DFFSR <br> --- SB_LUT4 <br> --- SB_RAM40_4K |               1783<br>301<br>5<br>5<br>133<br>1<br>6<br>1328<br>4|


## Plance and Route
NextPnR version: `(Version 868902fb)`

nextpnr-ice40 flags : `--pcf-allow-unconstrained --timing-allow-fail --ignore-loops --pre-pack pre_pack.py --opt-timing --seed 99`


### Resources Utilization 

|Device Resources |Device Utilization|Percentage|
| --------------: | :--------------: | :------: |
|ICESTORM_LC      |  1535 / 7680     |    19%   |
|ICESTORM_RAM     |     4 /   32     |    12%   |
|SB_IO            |   204 /  256     |    79%   |
|SB_GB            |     4 /    8     |    50%   |
|ICESTORM_PLL     |     0 /    2     |     0%   |
|SB_WARMBOOT      |     0 /    1     |     0%   |


**Checksum:** 0xf7159216

### Slack

|**Slack histogram** | Legend:<br> * represents 5 endpoint(s) + represents [1,5) endpoint(s)|
| :--------------: | :-------------------------------------------------------- |
| [ 63480,  64400) |********+|
| [ 64400,  65320) |+|
| [ 65320,  66240) |******+|
| [ 66240,  67160) |******+|
| [ 67160,  68080) |*******+|
| [ 68080,  69000) |*********+|
| [ 69000,  69920) |***+|
| [ 69920,  70840) |***************+|
| [ 70840,  71760) |*****************************+|
| [ 71760,  72680) |***********+|
| [ 72680,  73600) |*********************************+|
| [ 73600,  74520) |************************+|
| [ 74520,  75440) |********+|
| [ 75440,  76360) |****************************+|
| [ 76360,  77280) |*****+|
| [ 77280,  78200) |**********************+|
| [ 78200,  79120) |****+|
| [ 79120,  80040) |************+|
| [ 80040,  80960) |************************************************************ |
| [ 80960,  81880) |***************************+|


### Clock slack

    Max frequency for clock 'i_clk$SB_IO_IN_$glb_clk': 50.37 MHz (PASS at 12.00 MHz)
    
    Max delay <async>                         -> posedge i_clk$SB_IO_IN_$glb_clk: 15.05 ns
    Max delay posedge i_clk$SB_IO_IN_$glb_clk -> <async>                        : 12.32 ns


## IceTime timing Analysis

Total number of logic levels: 41

Total path delay: 19.39 ns (51.56 MHz)
