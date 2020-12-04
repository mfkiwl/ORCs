# Results : Resources and Timing Estimates
_This results were generated using Yosys, NextPNR and the Icestorm tool chain targeting the Lattice HX8k breakout board. These result only account for this core being in the FPGA, as it gets integrated into a design with more components the overall max clock of the system will be lower since the more resources used in a FPGA the harder it is to meet timing._

## Synthesis 
 Yosys version: `0.9+3715 (git sha1 d021f4b4, clang 11.0.0-2 -fPIC -Os)`

 Yosys flags: `-synth_ice40 -abc2 -retime -device hx`

### Synthesis Results
| Resource                  | Usage Count | 
| :------------------------ | ----------: |
| Number of  wire           |          653|
| Number of wire bits       |         3223|
| Number of public wires    |          653|
| Number of public wire bits|         3223|
| Number of memories        |            0|
| Number of memory bits     |            0|
| Number of processes       |            0|
| Number of cells<br> --- SB_CARRY <br> --- SB_DFF <br> --- SB_DFFE <br> --- SB_DFFESR <br> --- SB_DFFESS <br> --- SB_DFFSR <br> --- SB_LUT4 <br> --- SB_RAM40_4K |               1797<br>301<br>5<br>5<br>133<br>1<br>6<br>1342<br>4|


## Plance and Route
NextPnR version: `(Version 868902fb)`

nextpnr-ice40 flags : `--pcf-allow-unconstrained --timing-allow-fail --ignore-loops --pre-pack pre_pack.py --opt-timing --seed 307`


### Resources Utilization 

|Device Resources |Device Utilization|Percentage|
| --------------: | :--------------: | :------: |
|ICESTORM_LC      |  1549 / 7680     |    20%   |
|ICESTORM_RAM     |     4 /   32     |    12%   |
|SB_IO            |   204 /  256     |    79%   |
|SB_GB            |     4 /    8     |    50%   |
|ICESTORM_PLL     |     0 /    2     |     0%   |
|SB_WARMBOOT      |     0 /    1     |     0%   |


**Checksum:** 0x13146e29

### Slack

|**Slack histogram** | Legend:<br> * represents 5 endpoint(s) + represents [1,5) endpoint(s)|
| :--------------: | :-------------------------------------------------------- |
| [ 63886,  64786) |*********+|
| [ 64786,  65686) |*****+|
| [ 65686,  66586) |**********+|
| [ 66586,  67486) |****+|
| [ 67486,  68386) |*******+|
| [ 68386,  69286) |****+|
| [ 69286,  70186) |******+|
| [ 70186,  71086) |********+|
| [ 71086,  71986) |******************************+|
| [ 71986,  72886) |*******************************+|
| [ 72886,  73786) |**********+|
| [ 73786,  74686) |*********************+|
| [ 74686,  75586) |*********+|
| [ 75586,  76486) |**********+|
| [ 76486,  77386) |***************************+|
| [ 77386,  78286) |*********************+|
| [ 78286,  79186) |****+|
| [ 79186,  80086) |*************+|
| [ 80086,  80986) |************************************************************ |
| [ 80986,  81886) |**************************+|


### Clock slack

    Max frequency for clock 'i_clk$SB_IO_IN_$glb_clk': 51.42 MHz (PASS at 12.00 MHz)    
    Max delay <async>                         -> posedge i_clk$SB_IO_IN_$glb_clk: 15.64 ns
    Max delay posedge i_clk$SB_IO_IN_$glb_clk -> <async>                        : 11.93 ns


## IceTime timing Analysis

Total number of logic levels: 42

Total path delay: 19.33 ns (51.73 MHz)
