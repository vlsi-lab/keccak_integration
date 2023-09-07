#!/bin/bash

source /eda/scripts/init_questa
export PULP_RISCV_GCC_TOOLCHAIN=/software/riscv/riscv32-pulp
export PATH=$PULP_RISCV_GCC_TOOLCHAIN/bin:$PATH

source pulp-runtime/configs/pulpissimo.sh

cd pulpissimo
make checkout
source setup/vsim.sh
env | grep VSIM
make clean build 

cd ../test/keccak_ip
make clean all
make dis > keccak.s
make -f Makefile run



