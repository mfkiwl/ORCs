# Results : Resources and Timing Estimates
_These results should be considered experimental as Yosys does not fully support Anlogic's_FPGA and the ORC_R32I_ANLOGIC.v is rather a quick example_

## Yosys+TD Workfow (uses LUTRAMs)
### Synthesis and Mapping

***Report Model: ORC_R32I***

| IO Statistics |           |
| :------------ | --------: |
| #IO           |       204 |
|   #input      |        69 |
|   #output     |       135 |
|   #inout      |         0 |


|Utilization Statistics|     |                  |       |
| :------------------ | ---: | :--------------: | ----: |
| #lut                | 1479 |   out of  19600  |  7.55%|
| #reg                |  177 |   out of  19600  |  0.90%|
| #le                 | 1500 |          -       |     - |
|   #lut only         | 1323 |   out of   1839  | 88.20%|
|   #reg only         |   21 |   out of   1839  |  1.40%|
|   #lut&reg          |  156 |   out of   1839  | 10.40%|
| #dsp                |    0 |   out of     29  |  0.00%|
| #bram               |    0 |   out of     64  |  0.00%|
|   #bram9k           |    0 |        -         |  -    |
|   #fifo9k           |    0 |        -         |   -   |
| #bram32k            |    0 |   out of     16  |  0.00%|
| #pad                |  204 |   out of    188  |108.51%|
|   #ireg             |    0 |        -         |   -   |
|   #oreg             |    0 |        -         |   -   |
|   #treg             |    0 |        -         |   -   |
| #pll                |    0 |   out of      4  |  0.00%|


### Running

Create the pre-mapped code.
    make all
This will create full.v
Then either open td with -gui and create a project with the gui OR open td in command line and use the following command sequence:
    import_device eagle_s20.db -package BG256
    read_verilog full.v -top ORC_R32I
    read_adc PriMER.adc
    optimize_rtl
    map_macro
    map
    pack
    report_area -io_info -file mapping.rpt 

mapping.rpt will contain the results.

## TD Workflow (uses BRAMs)

### Synthesis and Mapping

***Report Model: ORC_R32I***

| IO Statistics |           |
| :------------ | --------: |
| #IO           |       204 |
|   #input      |        69 |
|   #output     |       135 |
|   #inout      |         0 |


|Utilization Statistics|     |                  |       |
| :------------------ | ---: | :--------------: | ----: |
| #lut                | 1561 |   out of  19600  | 7.96% |
| #reg                |  167 |   out of  19600  | 0.85% |
| #le                 | 1561 |        -         |  -    |
|   #lut only         | 1394 |   out of   1561  | 89.30% |
|   #reg only         |    0 |   out of   1561  |  0.00% |
|   #lut&reg          |  167 |   out of   1561  | 10.70% |
| #dsp                |    0 |   out of     29  |  0.00% |
| #bram               |    4 |   out of     64  |  6.25% |
|   #bram9k           |    4 |        -         |  -    |
|   #fifo9k           |    0 |        -         |  -    |
| #bram32k            |    0 |   out of     16 |   0.00% |
| #pad                |  204 |   out of    188 | 108.51% |
|   #ireg             |   13 |        -         |  -    |
|   #oreg             |    0 |        -         |  -    |
|   #treg             |    0 |        -         |  -    |
| #pll                |    0 |   out of      4  |  0.00% |


| Report Hierarchy Area: |  | |      |      |
| :-------- | :------ | :---- |:-----| :--- |
| Instance  |Module   | le    | lut  | seq  |
| top       |ORC_R32I | 1561  | 1561 | 167  |


### Running

An example project is included in the ORC_R32I_PriMER folder.