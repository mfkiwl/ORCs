# Results : Resources and Timing Estimates
_These results were generated using Yosys, NextPNR and the Icestorm tool chain targeting the Lattice HX8k breakout board. These result only account for this core being in the FPGA, as it gets integrated into a design with more components the overall max clock of the system will be lower since the more resources used in a FPGA the harder it is to meet timing._

## Synthesis 
 Yosys version: `Yosys 0.9+3814 (git sha1 da1d06d7, gcc 10.2.0-13ubuntu1 -fPIC -Os)`

 Yosys script: `syn_ice40.ys`

### Synthesis Results
| Resource                  | Usage Count | 
| :------------------------ | ----------: |
| Number of  wire           |          642|
| Number of wire bits       |         3284|
| Number of public wires    |          642|
| Number of public wire bits|         3284|
| Number of memories        |            0|
| Number of memory bits     |            0|
| Number of processes       |            0|
| Number of cells<br> --- SB_CARRY <br> --- SB_DFF <br> --- SB_DFFESR <br> --- SB_DFFESS <br> --- SB_DFFSR <br> --- SB_LUT4 <br> --- SB_RAM40_4K |               1781<br>329<br>4<br>101<br>1<br>11<br>1331<br>4|


## Plance and Route
NextPnR version: `nextpnr-ice40 -- Next Generation Place and Route (Version bdaa9f0e)`

nextpnr-ice40 flags : `--pcf-allow-unconstrained --timing-allow-fail --ignore-loops --pre-pack pre_pack.py --opt-timing --seed 2`


### Resources Utilization 

|Device Resources |Device Utilization|Percentage|
| --------------: | :--------------: | :------: |
|ICESTORM_LC      |  1526 / 7680     |    19%   |
|ICESTORM_RAM     |     4 /   32     |    12%   |
|SB_IO            |   204 /  256     |    79%   |
|SB_GB            |     4 /    8     |    50%   |
|ICESTORM_PLL     |     0 /    2     |     0%   |
|SB_WARMBOOT      |     0 /    1     |     0%   |


**Checksum:** 0x096d08dc

### Slack

|**Slack histogram** | Legend:<br> * represents 2 endpoint(s) + represents [1,2) endpoint(s)|
| :--------------: | :-------------------------------------------------------- |
| [ 64971,  65816) |************+|
| [ 65816,  66661) |***+|
| [ 66661,  67506) |*********+|
| [ 67506,  68351) |*************+|
| [ 68351,  69196) |********+|
| [ 69196,  70041) |**********+|
| [ 70041,  70886) |******+|
| [ 70886,  71731) |***************************+|
| [ 71731,  72576) |*************************+|
| [ 72576,  73421) |***************+|
| [ 73421,  74266) |**********+|
| [ 74266,  75111) |**********+|
| [ 75111,  75956) |********+|
| [ 75956,  76801) |******************+|
| [ 76801,  77646) |************************+|
| [ 77646,  78491) |*****************+|
| [ 78491,  79336) |****************+|
| [ 79336,  80181) |*********************+|
| [ 80181,  81026) |************************************************************ |
| [ 81026,  81871) |**********************+|


### Clock slack

     Max frequency for clock 'i_clk$SB_IO_IN_$glb_clk': 54.46 MHz (PASS at 12.00 MHz)
    
     Max delay <async>                         -> posedge i_clk$SB_IO_IN_$glb_clk: 16.93 ns
     Max delay posedge i_clk$SB_IO_IN_$glb_clk -> <async>                        : 12.13 ns


## IceTime timing Analysis

Total number of logic levels: 38

Total path delay: 18.57 ns (53.86 MHz)

# Running

For a single run use
    make all

For running regression with multiple seeds
    make -j`nproc` rpt