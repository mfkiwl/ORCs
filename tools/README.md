# Tools Directory
 Collection of repositories containing essential tools for generating, building and testing the project's artifacts. Installation guide is focused on __Ubuntu__ Linux distribution. __A recursive GIT clone takes about 7GB of disk space.__

## Installing the IceStorm Tools, Arachne-PNR, NextPNR and Yosys:

_For more details visit http://www.clifford.at/icestorm/_

### Prerequisites :
`sudo apt-get install build-essential clang bison flex libreadline-dev gawk tcl-dev libffi-dev git mercurial graphviz xdot pkg-config python python3 libftdi-dev qt5-default python3-dev libboost-all-dev cmake libeigen3-dev`

### IceStorm :
- `cd icestorm`
- `make -j$(nproc)`
- `sudo make install`

### Arachne-PNR :
- `cd ../arachne-pnr`
- `make -j$(nproc)`
- `sudo make install`

### NextPNR :

- `cd ../nextpnr`
- `cmake -DARCH=ice40 -DCMAKE_INSTALL_PREFIX=/usr/local .`
- `make -j$(nproc)`
- `sudo make install`

### Yosys :

- `cd ../yosys`
- `make -j$(nproc)`
- `sudo make install`

## Verilator
### Prerequisites:
sudo apt-get install git make autoconf g++ flex bison
sudo apt-get install libfl2     # Ubuntu only (ignore if gives error)
sudo apt-get install libfl-dev  # Ubuntu only (ignore if gives error)

### Every time you need to build:
`unset VERILATOR_ROOT  # For bash
cd verilator
autoconf        # Create ./configure script
./configure
make
sudo make install`

## RISC-V GNU TOOLCHAIN
### Prerequisites:
`sudo apt-get install autoconf automake autotools-dev cmake curl python3 libmpc-dev libmpfr-dev libgmp-dev gawk build-essential bison flex gzip zip unzip texinfo gperf libtool patchutils bc zlib1g-dev libexpat-dev gcc-multilib libglib2.0-dev libfdt-dev libpixman-1-dev`

### Install
`./configure --prefix=/opt/riscv --with-arch=rv32gc --with-abi=ilp32d --enable-multilib`

```make -j`nproc` ```

__Make sure to add /opt/riscv/bin to your $PATH__