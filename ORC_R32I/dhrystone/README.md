clang --target=riscv32 -MD -O3 -march=rv32i -DTIME -DRISCV -ffreestanding start.S -c -o start.o
