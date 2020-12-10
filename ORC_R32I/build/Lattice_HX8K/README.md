# Results : Resources and Timing Estimates
_This results were generated using Yosys, NextPNR and the Icestorm tool chain targeting the Lattice HX8k breakout board. These result only account for this core being in the FPGA, as it gets integrated into a design with more components the overall max clock of the system will be lower since the more resources used in a FPGA the harder it is to meet timing._

## Synthesis 
 Yosys version: `0.9+3746 (git sha1 ec410c9b, gcc 10.2.1 -O3 -feliminate-unused-debug-types -fexceptions -fstack-protector -m64 -fasynchronous-unwind-tables -ftree-loop-distribute-patterns -fno-semantic-interposition -ffat-lto-objects -fno-trapping-math -mtune=skylake -fvisibility-inlines-hidden -fPIC -Os)`

 Yosys script: `syn_ice40.ys`

### Synthesis Results
| Resource                  | Usage Count | 
| :------------------------ | ----------: |
| Number of  wire           |          608|
| Number of wire bits       |         3134|
| Number of public wires    |          608|
| Number of public wire bits|         3134|
| Number of memories        |            0|
| Number of memory bits     |            0|
| Number of processes       |            0|
| Number of cells<br> --- SB_CARRY <br> --- SB_DFF <br> --- SB_DFFE <br> --- SB_DFFESR <br> --- SB_DFFESS <br> --- SB_DFFSR <br> --- SB_LUT4 <br> --- SB_RAM40_4K |               1787<br>329<br>5<br>5<br>101<br>1<br>6<br>1336<br>4|


## Plance and Route
NextPnR version: `(Version 868902fb)`

nextpnr-ice40 flags : `--pcf-allow-unconstrained --timing-allow-fail --ignore-loops --pre-pack pre_pack.py --opt-timing --seed 907`


### Resources Utilization 

|Device Resources |Device Utilization|Percentage|
| --------------: | :--------------: | :------: |
|ICESTORM_LC      |  1517 / 7680     |    19%   |
|ICESTORM_RAM     |     4 /   32     |    12%   |
|SB_IO            |   204 /  256     |    79%   |
|SB_GB            |     4 /    8     |    50%   |
|ICESTORM_PLL     |     0 /    2     |     0%   |
|SB_WARMBOOT      |     0 /    1     |     0%   |


**Checksum:** 0xd2dfb7eb

### Slack

|**Slack histogram** | Legend:<br> * represents 5 endpoint(s) + represents [1,5) endpoint(s)|
| :--------------: | :-------------------------------------------------------- |
| [ 64344,  65225) |***********+|
| [ 65225,  66106) |*****+|
| [ 66106,  66987) |************+|
| [ 66987,  67868) |*****+|
| [ 67868,  68749) |******+|
| [ 68749,  69630) |******+|
| [ 69630,  70511) |*****+|
| [ 70511,  71392) |************+|
| [ 71392,  72273) |****************+|
| [ 72273,  73154) |**********************************+|
| [ 73154,  74035) |*****************************+|
| [ 74035,  74916) |********************************+|
| [ 74916,  75797) |*********+|
| [ 75797,  76678) |*****************+|
| [ 76678,  77559) |*************** |
| [ 77559,  78440) |**************+|
| [ 78440,  79321) |***+|
| [ 79321,  80202) |******************+|
| [ 80202,  81083) |************************************************************ |
| [ 81083,  81964) |****************+|


### Clock slack

    Max frequency for clock 'i_clk$SB_IO_IN_$glb_clk': 52.66 MHz (PASS at 12.00 MHz)
    
    Max delay <async>                         -> posedge i_clk$SB_IO_IN_$glb_clk: 15.12 ns
    Max delay posedge i_clk$SB_IO_IN_$glb_clk -> <async>                        : 12.43 ns
    
## IceTime timing Analysis

Total number of logic levels: 42

Total path delay: 18.97 ns (52.71 MHz)

# Running

For a single run use
    make all

For running regression with multiple seeds
    make -j`nproc` rpt