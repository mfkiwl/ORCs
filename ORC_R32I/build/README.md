# Results : Resources and Timing Estimates
_This results were generated using Yosys, NextPNR and the Icestorm tool chain targeting the Lattice HX8k breakout board_

## 1. Results with Yosys flags: `-abc2 -retime -relut`

### Synthesis Results
| Resource | Usage Count | 
| :-------------- | ---------: |
| Number of public wire bits|    3351|
| Number of public wires|         654|
| Number of wire bits|           3351|
| Number of wires|                654|
| Number of memories|               0|
| Number of memory bits|            0|
| Number of processes|              0|
| Number of cells<br> --- SB_CARRY<br> --- SB_DFF <br> --- SB_DFFESR <br> --- SB_DFFESS <br> --- SB_DFFSR <br> --- SB_LUT4 <br> --- SB_RAM40_4K |               1878<br>280<br>32<br>259<br>2<br>6<br>1295<br>4|

### Plance and Route

|**Slack histogram** | Legend:<br> * represents 5 endpoint(s) + represents [1,5) endpoint(s)|
| :--------------: | :-------------- |
[ 62568,  63550) |*+|
[ 63550,  64532) |*+|
[ 64532,  65514) |****+|
[ 65514,  66496) |******+|
[ 66496,  67478) |********+|
[ 67478,  68460) |+|
[ 68460,  69442) |+|
[ 69442,  70424) |+|
[ 70424,  71406) |******+|
[ 71406,  72388) |**********+|
[ 72388,  73370) |**************************+|
[ 73370,  74352) |****************************************+|
[ 74352,  75334) |**************+|
[ 75334,  76316) |**********************+|
[ 76316,  77298) |*********+|
[ 77298,  78280) |************************************************************ |
[ 78280,  79262) |********+|
[ 79262,  80244) |****************************+|
[ 80244,  81226) |*****************************************+|
[ 81226,  82208) |**************************+|

### Timing estimate: 20.28 ns (49.32 MHz)


## 2. Results with Yosys flags: `-abc9`

### Synthesis Results

| Resource | Usage Count | 
| :-------------- | ---------: |
|Number of wires:               1213
|Number of wire bits:           3576
|Number of public wires:        1213
|Number of public wire bits:    3576
|Number of memories:               0
|Number of memory bits:            0
|Number of processes:              0
|Number of cells <br> --- SB_CARRY <br> --- SB_DFF <br> --- SB_DFFESR <br> --- SB_DFFESS <br> --- SB_DFFSR <br> --- SB_LUT4 <br> --- SB_RAM40_4K | 1843<br>247<br>32<br>259<br>2<br>6<br>1293<br>4|

### Plance and Route

|**Slack histogram** | Legend:<br> * represents 5 endpoint(s) + represents [1,5) endpoint(s)|
| :--------------: | :-------------- |
|[ 64674,  65551) |*+|
|[ 65551,  66428) |******+|
|[ 66428,  67305) |*****+|
|[ 67305,  68182) |*********+|
|[ 68182,  69059) |*+|
|[ 69059,  69936) |+|
|[ 69936,  70813) |***+|
|[ 70813,  71690) |*******+|
|[ 71690,  72567) |***********+|
|[ 72567,  73444) |***********+|
|[ 73444,  74321) |********+|
|[ 74321,  75198) |*************************************************+|
|[ 75198,  76075) |**********+|
|[ 76075,  76952) |*********************************************+|
|[ 76952,  77829) |*******************+|
|[ 77829,  78706) |************************************************************ |
|[ 78706,  79583) |********************************+|
|[ 79583,  80460) |****************************+|
|[ 80460,  81337) |***********************+|
|[ 81337,  82214) |******************************+|

### Timing estimate: 18.72 ns (53.42 MHz)