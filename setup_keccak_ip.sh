#!/bin/bash

source $QUESTA_PATH 
export PULP_RISCV_GCC_TOOLCHAIN=$RISC_V_PATH
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



