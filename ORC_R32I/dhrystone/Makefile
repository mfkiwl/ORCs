USE_MYSTDLIB = 0
OBJS = dhry_1.o dhry_2.o stdlib.o
CFLAGS = -MD -O3 -march=rv32g -DTIME -DRISCV
TOOLCHAIN_PREFIX = riscv32-unknown-elf-

ifeq ($(USE_MYSTDLIB),1)
CFLAGS += -DUSE_MYSTDLIB -ffreestanding -nostdlib
OBJS += start.o
else
OBJS += syscalls.o
endif

test_trace: testbench.vvp dhry.hex
	vvp -N $< +trace
	python3 ../showtrace.py testbench.trace dhry.elf > testbench.ins

test_nola: testbench_nola.iver dhry.hex
	vvp -N testbench_nola.iver
	gtkwave testbench_nola.vcd wave.gtkw

timing: timing.txt
	grep '^##' timing.txt | gawk 'x != "" {print x,$$3-y;} {x=$$2;y=$$3;}' | sort | uniq -c | \
		gawk '{printf("%03d-%-7s %2d %-8s (%d)\n",$$3,$$2,$$3,$$2,$$1);}' | sort | cut -c13-

timing.txt: timing.iver dhry.hex
	vvp -N timing.iver > timing.txt

testbench_nola.iver: testbench_nola.v ../source/ORC_R32I.v
	iverilog -g2012 -gxtypes -o testbench_nola.iver testbench_nola.v ../source/ORC_R32I.v
	chmod -x testbench_nola.iver

timing.iver: testbench_nola.v ../source/ORC_R32I.v
	iverilog -o timing.iver -DTIMING testbench_nola.v ../source/ORC_R32I.v
	chmod -x timing.iver

dhry.hex: dhry.elf
	$(TOOLCHAIN_PREFIX)objcopy -O verilog $< $@

ifeq ($(USE_MYSTDLIB),1)
dhry.elf: $(OBJS) sections.lds
	$(TOOLCHAIN_PREFIX)gcc $(CFLAGS) -Wl,-Bstatic,-T,sections.lds,-Map,dhry.map,--strip-debug -o $@ $(OBJS) -lgcc
	chmod -x $@
else
dhry.elf: $(OBJS)
	$(TOOLCHAIN_PREFIX)gcc $(CFLAGS) -Wl,-Bstatic,-T,../firmware/riscv.ld,-Map,dhry.map,--strip-debug -o $@ $(OBJS) -lgcc -lc
	chmod -x $@
endif

%.o: %.c
	$(TOOLCHAIN_PREFIX)gcc -c $(CFLAGS) $<

%.o: %.S
	$(TOOLCHAIN_PREFIX)gcc -c $(CFLAGS) $<

dhry_1.o dhry_2.o: CFLAGS += -Wno-implicit-int -Wno-implicit-function-declaration

clean:
	rm -rf *.o *.d dhry.elf dhry.map dhry.bin dhry.hex testbench_nola.iver testbench_nola.vcd timing.vvp timing.txt

.PHONY: test clean

-include *.d

