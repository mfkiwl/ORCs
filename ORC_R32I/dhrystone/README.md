# Dhrystone Benchmark

## Prerequisite

setup the riscv gcc toolchain and add it to your environment variables ($PATH). Go to the tools/ directory for install these.
Also requires **gtkview**.

This is an example for linux users on how to add it to your .profile

    # set PATH so it includes riscv toolchain bin if it exists
    if [ -d "/home/_username_/riscv/_install/bin" ] ; then
        PATH="/home/_username_/riscv/_install/bin:$PATH"


## Running the testbench
    
    make testbench_nola


Alternatively one can create the hex file (the compilers output, binary code read by the core from memory) with LLVM using:

    clang --target=riscv32 -MD -O3 -march=rv32i -DTIME -DRISCV -ffreestanding start.S -c -o start.o