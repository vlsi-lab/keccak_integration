#!/bin/bash

/usr/bin/gcc -o test ../cbd.c fips202.c ../indcpa.c ../kem.c ../ntt.c ../poly.c ../polyvec.c ../randombytes.c ../reduce.c ../symmetric-shake.c ../verify.c ../api.h ../cbd.h fips202.h ../indcpa.h ../kem.h ../ntt.h ../params.h ../poly.h ../polyvec.h ../randombytes.h ../reduce.h ../symmetric.h ../verify.h testvectors.c -std=c99

