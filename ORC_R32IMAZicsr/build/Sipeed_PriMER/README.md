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
| #lut                | 1819 |   out of  19600  |  9.28%|
| #reg                |  218 |   out of  19600  |  1.11%|
| #le                 | 1839 |          -       |     - |
|   #lut only         | 1621 |   out of   1839  | 88.15%|
|   #reg only         |   20 |   out of   1839  |  1.09%|
|   #lut&reg          |  198 |   out of   1839  | 10.77%|
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

               

|Report Hierarchy Area: |  | | | |
:-------- | :-------- | :---- |:------| :---- |
| Instance | Module   | le    | lut   | seq   |
| top      | ORC_R32I | 1839  | 1819  | 218   |


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
| #lut                | 1575 |   out of  19600  | 8.04% |
| #reg                |  167 |   out of  19600  | 0.85% |
| #le                 | 1575 |        -         |  -    |
|   #lut only         | 1408 |   out of   1575  | 89.40% |
|   #reg only         |    0 |   out of   1575  |  0.00% |
|   #lut&reg          |  167 |   out of   1575  | 10.60% |
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
| top       |ORC_R32I | 1575  | 1575 | 167  |


### Running

An example project is included in the ORC_R32I_PriMER folder.