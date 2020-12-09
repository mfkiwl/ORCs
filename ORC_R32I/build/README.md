# Results : Resources and Timing Estimates
_This results were generated using Yosys, NextPNR and the Icestorm tool chain targeting the Lattice HX8k breakout board. These result only account for this core being in the FPGA, as it gets integrated into a design with more components the overall max clock of the system will be lower since the more resources used in a FPGA the harder it is to meet timing._

## Synthesis 
 Yosys version: `0.9+3746 (git sha1 ec410c9b, gcc 10.2.1 -O3 -feliminate-unused-debug-types -fexceptions -fstack-protector -m64 -fasynchronous-unwind-tables -ftree-loop-distribute-patterns -fno-semantic-interposition -ffat-lto-objects -fno-trapping-math -mtune=skylake -fvisibility-inlines-hidden -fPIC -Os)`

 Yosys flags: `-synth_ice40 -abc2 -retime -relut -dsp`

### Synthesis Results
| Resource                  | Usage Count | 
| :------------------------ | ----------: |
| Number of  wire           |          651|
| Number of wire bits       |         3233|
| Number of public wires    |          651|
| Number of public wire bits|         3233|
| Number of memories        |            0|
| Number of memory bits     |            0|
| Number of processes       |            0|
| Number of cells<br> --- SB_CARRY <br> --- SB_DFF <br> --- SB_DFFE <br> --- SB_DFFESR <br> --- SB_DFFESS <br> --- SB_DFFSR <br> --- SB_LUT4 <br> --- SB_RAM40_4K |               1804<br>329<br>5<br>5<br>101<br>1<br>6<br>1353<br>4|


## Plance and Route
NextPnR version: `(Version 868902fb)`

nextpnr-ice40 flags : `--pcf-allow-unconstrained --timing-allow-fail --ignore-loops --pre-pack pre_pack.py --opt-timing --seed 607`


### Resources Utilization 

|Device Resources |Device Utilization|Percentage|
| --------------: | :--------------: | :------: |
|ICESTORM_LC      |  1533 / 7680     |    19%   |
|ICESTORM_RAM     |     4 /   32     |    12%   |
|SB_IO            |   204 /  256     |    79%   |
|SB_GB            |     4 /    8     |    50%   |
|ICESTORM_PLL     |     0 /    2     |     0%   |
|SB_WARMBOOT      |     0 /    1     |     0%   |


**Checksum:** 0x3aef616d

### Slack

|**Slack histogram** | Legend:<br> * represents 5 endpoint(s) + represents [1,5) endpoint(s)|
| :--------------: | :-------------------------------------------------------- |
| [ 64808,  65682) |************+|
| [ 65682,  66556) |*******+|
| [ 66556,  67430) |************+|
| [ 67430,  68304) |*************+|
| [ 68304,  69178) |***********************+|
| [ 69178,  70052) |****************************+|
| [ 70052,  70926) |***********+|
| [ 70926,  71800) |*****+|
| [ 71800,  72674) |******************+|
| [ 72674,  73548) |**************************************+|
| [ 73548,  74422) |**************************+|
| [ 74422,  75296) |***********+|
| [ 75296,  76170) |*******+|
| [ 76170,  77044) |*******************+|
| [ 77044,  77918) |***************+|
| [ 77918,  78792) |****************+|
| [ 78792,  79666) |*********+|
| [ 79666,  80540) |************************************************************ |
| [ 80540,  81414) |****************************+|
| [ 81414,  82288) |************+|


### Clock slack

    Max frequency for clock 'i_clk$SB_IO_IN_$glb_clk': 18.62 ns (53.72 MHz) MHz (PASS at 12.00 MHz)
    Max delay <async>                         -> posedge i_clk$SB_IO_IN_$glb_clk: 15.82 ns
    Max delay posedge i_clk$SB_IO_IN_$glb_clk -> <async>                        : 12.37 ns
    
## IceTime timing Analysis

Total number of logic levels: 41

Total path delay: 18.62 ns (53.72 MHz)


# Running

For a single run use
    make all

For running regression with multiple seeds
    make -j`nproc` rpt