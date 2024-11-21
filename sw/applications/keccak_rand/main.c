#include <stdio.h>
#include <inttypes.h>
#include <string.h>

#include "core_v_mini_mcu.h"
#include "keccak_x_heep.h"
#include "keccak_driver.h"

#define SIZE 50


int main(){

	printf("Program for testing Keccak with random values\n");

	static uint32_t Din[SIZE] __attribute__ ((aligned (4)));
	static uint32_t Dout[SIZE] __attribute__ ((aligned (4)));

	static uint32_t D_expected[SIZE];
	int i = 0;

	memset(Din, 0, sizeof(Din));
	memset(Dout, 0, sizeof(Dout));
	memset(D_expected, 0, sizeof(D_expected));
	
	printf("Hello Keccak\n");
	KeccakF1600_StatePermute(Din,Dout);	
	
	printf("Keccak terminated!\n");
	return 0;

}
