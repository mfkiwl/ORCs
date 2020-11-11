# Results : Resources and Timing Estimates
_This results were generated using Yosys, NextPNR and the Icestorm tool chain targeting the Lattice HX8k breakout board_

## Synthesis 
 Yosys version: `0.9+3667 (git sha1 e7f36d01, clang 11.0.0-2 -fPIC -Os)`

 Yosys flags: `-abc9`

### Synthesis Results
| Resource | Usage Count | 
| :-------------- | ---------: |
| Number of  wire           | 1257|
| Number of wire bits       | 3652|
| Number of public wires    | 1257|
| Number of public wire bits| 3652|
| Number of memories|               0|
| Number of memory bits|            0|
| Number of processes|              0|
| Number of cells<br> --- SB_CARRY<br> --- SB_DFF <br> --- SB_DFFESR <br> --- SB_DFFESS <br> --- SB_DFFSR <br> --- SB_LUT4 <br> --- SB_RAM40_4K |               1940<br>247<br>32<br>280<br>1<br>6<br>1370<br>4|

## Plance and Route
NextPnR version: `(Version d5dde5df)`

nextpnr-ice40 flags : `--pcf-allow-unconstrained --timing-allow-fail --ignore-loops --pre-pack pre_pack.py --opt-timing`

### Slack

|**Slack histogram** | Legend:<br> * represents 5 endpoint(s) + represents [1,5) endpoint(s)|
| :--------------: | :-------------- |
|[ 64717,  65592) |**********+|
|[ 65592,  66467) |***********+|
|[ 66467,  67342) |******+|
|[ 67342,  68217) |*******+|
|[ 68217,  69092) |*+|
|[ 69092,  69967) |***********************+
|[ 69967,  70842) |*************+|
|[ 70842,  71717) |**************+|
|[ 71717,  72592) |*********************************************+|
|[ 72592,  73467) |***********************+|
|[ 73467,  74342) |*********+|
|[ 74342,  75217) |***********************************+|
|[ 75217,  76092) |************************************************************ |
|[ 76092,  76967) |***********+|
|[ 76967,  77842) |*******************************+|
|[ 77842,  78717) |***************************************************+|
|[ 78717,  79592) |*****************************************************+|
|[ 79592,  80467) |********************************************+|
|[ 80467,  81342) |*********************************+|
|[ 81342,  82217) |*******************************************+|

### Clock slack

    Max frequency for clock 'i_clk$SB_IO_IN_$glb_clk': 53.72 MHz (PASS at 12.00 MHz)
    Max delay <async>                         -> posedge i_clk$SB_IO_IN_$glb_clk: 16.23 ns
    Max delay posedge i_clk$SB_IO_IN_$glb_clk -> <async>                        : 4.48 ns

## IceTime timing Analysis

Timing estimate: **19.13 ns (52.28 MHz)**