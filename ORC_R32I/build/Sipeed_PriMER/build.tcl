import_device eagle_s20.db -package BG256
read_verilog full.v -top ORC_R32I
read_adc PriMER.adc
optimize_rtl
map_macro
map
pack
report_area -io_info -file mapping.rpt
place
route
bitgen -bit demo.bit -version 0X0000 -svf demo.svf -svf_comment_on -g ucode:00000000000000000000000000000000