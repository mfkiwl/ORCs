# Results : Resources and Timing Estimates
_These results should be considered experimental, they are a quick example for xc7s25csga324-1IL FPGA_

### Synthesis and Mapping

***Report Model: ORC_R32I***

1. Slice Logic
--------------

+----------------------------+------+-------+-----------+-------+
|          Site Type         | Used | Fixed | Available | Util% |
+----------------------------+------+-------+-----------+-------+
| Slice LUTs*                | 1235 |     0 |     14600 |  8.46 |
|   LUT as Logic             | 1099 |     0 |     14600 |  7.53 |
|   LUT as Memory            |  136 |     0 |      5000 |  2.72 |
|     LUT as Distributed RAM |  136 |     0 |           |       |
|     LUT as Shift Register  |    0 |     0 |           |       |
| Slice Registers            |  180 |     0 |     29200 |  0.62 |
|   Register as Flip Flop    |  180 |     0 |     29200 |  0.62 |
|   Register as Latch        |    0 |     0 |     29200 |  0.00 |
| F7 Muxes                   |    2 |     0 |      7300 |  0.03 |
| F8 Muxes                   |    0 |     0 |      3650 |  0.00 |
+----------------------------+------+-------+-----------+-------+
* Warning! The Final LUT count, after physical optimizations and full implementation, is typically lower. Run opt_design after synthesis, if not already completed, for a more realistic count.

