# Results : Resources and Timing Estimates
_These results were generated using Yosys, NextPNR and the Icestorm tool chain targeting the Lattice HX8k breakout board. These result only account for this core being in the FPGA, as it gets integrated into a design with more components the overall max clock of the system will be lower since the more resources used in a FPGA the harder it is to meet timing._

## Synthesis 
 Yosys version: `0.9+3746 (git sha1 ec410c9b, gcc 10.2.1 -O3 -feliminate-unused-debug-types -fexceptions -fstack-protector -m64 -fasynchronous-unwind-tables -ftree-loop-distribute-patterns -fno-semantic-interposition -ffat-lto-objects -fno-trapping-math -mtune=skylake -fvisibility-inlines-hidden -fPIC -Os)`

 Yosys script: `syn_ice40.ys`

### Synthesis Results
| Resource                  | Usage Count | 
| :------------------------ | ----------: |
| Number of  wire           |          653|
| Number of wire bits       |         3273|
| Number of public wires    |          653|
| Number of public wire bits|         3273|
| Number of memories        |            0|
| Number of memory bits     |            0|
| Number of processes       |            0|
| Number of cells<br> --- SB_CARRY <br> --- SB_DFF <br> --- SB_DFFE <br> --- SB_DFFESR <br> --- SB_DFFESS <br> --- SB_DFFSR <br> --- SB_LUT4 <br> --- SB_RAM40_4K |               1787<br>329<br>5<br>5<br>101<br>1<br>11<br>1366<br>4|


## Plance and Route
NextPnR version: `(Version 868902fb)`

nextpnr-ice40 flags : `--pcf-allow-unconstrained --timing-allow-fail --ignore-loops --pre-pack pre_pack.py --opt-timing --seed 507`


### Resources Utilization 

|Device Resources |Device Utilization|Percentage|
| --------------: | :--------------: | :------: |
|ICESTORM_LC      |  1546 / 7680     |    20%   |
|ICESTORM_RAM     |     4 /   32     |    12%   |
|SB_IO            |   204 /  256     |    79%   |
|SB_GB            |     4 /    8     |    50%   |
|ICESTORM_PLL     |     0 /    2     |     0%   |
|SB_WARMBOOT      |     0 /    1     |     0%   |


**Checksum:** 0x7b60bbdd

### Slack

|**Slack histogram** | Legend:<br> * represents 5 endpoint(s) + represents [1,5) endpoint(s)|
| :--------------: | :-------------------------------------------------------- |
| [ 63774,  64679) |***************+|
| [ 64679,  65584) |********+|
| [ 65584,  66489) |****+|
| [ 66489,  67394) |********+|
| [ 67394,  68299) |***************+|
| [ 68299,  69204) |**************************+|
| [ 69204,  70109) |****************+|
| [ 70109,  71014) |****+|
| [ 71014,  71919) |********+|
| [ 71919,  72824) |***********************+|
| [ 72824,  73729) |***********************+|
| [ 73729,  74634) |***************+|
| [ 74634,  75539) |************************+|
| [ 75539,  76444) |*****************+|
| [ 76444,  77349) |*******+|
| [ 77349,  78254) |**************+|
| [ 78254,  79159) |****+|
| [ 79159,  80064) |********+|
| [ 80064,  80969) |************************************************************ |
| [ 80969,  81874) |********************+|


### Clock slack

    Max frequency for clock 'i_clk$SB_IO_IN_$glb_clk': 51.13 MHz (PASS at 12.00 MHz)
   
    Max delay <async>                         -> posedge i_clk$SB_IO_IN_$glb_clk: 16.74 ns
    Max delay posedge i_clk$SB_IO_IN_$glb_clk -> <async>                        : 12.57 ns

## IceTime timing Analysis

Total number of logic levels: 41

Total path delay: 19.38 ns (51.60 MHz)

# Running

For a single run use
    make all

For running regression with multiple seeds
    make -j`nproc` rpt