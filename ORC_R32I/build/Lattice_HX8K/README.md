# Results : Resources and Timing Estimates
_These results were generated using Yosys, NextPNR and the Icestorm tool chain targeting the Lattice HX8k breakout board. These result only account for this core being in the FPGA, as it gets integrated into a design with more components the overall max clock of the system will be lower since the more resources used in a FPGA the harder it is to meet timing._

## Synthesis 
 Yosys version: `0.9+3746 (git sha1 ec410c9b, gcc 10.2.1 -O3 -feliminate-unused-debug-types -fexceptions -fstack-protector -m64 -fasynchronous-unwind-tables -ftree-loop-distribute-patterns -fno-semantic-interposition -ffat-lto-objects -fno-trapping-math -mtune=skylake -fvisibility-inlines-hidden -fPIC -Os)`

 Yosys script: `syn_ice40.ys`

### Synthesis Results
| Resource                  | Usage Count | 
| :------------------------ | ----------: |
| Number of  wire           |          677|
| Number of wire bits       |         3414|
| Number of public wires    |          677|
| Number of public wire bits|         3414|
| Number of memories        |            0|
| Number of memory bits     |            0|
| Number of processes       |            0|
| Number of cells<br> --- SB_CARRY <br> --- SB_DFF <br> --- SB_DFFE <br> --- SB_DFFESR <br> --- SB_DFFESS <br> --- SB_DFFSR <br> --- SB_LUT4 <br> --- SB_RAM40_4K |               1826<br>329<br>5<br>5<br>101<br>1<br>11<br>1375<br>4|


## Plance and Route
NextPnR version: `(Version 868902fb)`

nextpnr-ice40 flags : `--pcf-allow-unconstrained --timing-allow-fail --ignore-loops --pre-pack pre_pack.py --opt-timing --seed 1107`


### Resources Utilization 

|Device Resources |Device Utilization|Percentage|
| --------------: | :--------------: | :------: |
|ICESTORM_LC      |  1556 / 7680     |    20%   |
|ICESTORM_RAM     |     4 /   32     |    12%   |
|SB_IO            |   204 /  256     |    79%   |
|SB_GB            |     4 /    8     |    50%   |
|ICESTORM_PLL     |     0 /    2     |     0%   |
|SB_WARMBOOT      |     0 /    1     |     0%   |


**Checksum:** 0x2369e16d

### Slack

|**Slack histogram** | Legend:<br> * represents 5 endpoint(s) + represents [1,5) endpoint(s)|
| :--------------: | :-------------------------------------------------------- |
| [ 64817,  65687) |************+|
| [ 65687,  66557) |****+|
| [ 66557,  67427) |*******************+|
| [ 67427,  68297) |****************+|
| [ 68297,  69167) |****************+|
| [ 69167,  70037) |**************+|
| [ 70037,  70907) |**************+|
| [ 70907,  71777) |****+|
| [ 71777,  72647) |**+|
| [ 72647,  73517) |************************+|
| [ 73517,  74387) |*******************************+|
| [ 74387,  75257) |*****************+|
| [ 75257,  76127) |******************+|
| [ 76127,  76997) |*****************+|
| [ 76997,  77867) |***************************+|
| [ 77867,  78737) |*****+|
| [ 78737,  79607) |******+|
| [ 79607,  80477) |*************************+|
| [ 80477,  81347) |************************************************************ |
| [ 81347,  82217) |*******+|


### Clock slack

    Max frequency for clock 'i_clk$SB_IO_IN_$glb_clk': 54.01 MHz (PASS at 12.00 MHz)
    
    Max delay <async>                         -> posedge i_clk$SB_IO_IN_$glb_clk: 16.30 ns
    Max delay posedge i_clk$SB_IO_IN_$glb_clk -> <async>                        : 11.19 ns

## IceTime timing Analysis

Total number of logic levels: 34

Total path delay: 18.93 ns (52.82 MHz)

# Running

For a single run use
    make all

For running regression with multiple seeds
    make -j`nproc` rpt