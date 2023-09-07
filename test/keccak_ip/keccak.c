#include <stdio.h>
#include <inttypes.h>
#include "pulp.h"

int main(){

	printf("Hello Keccak\n");

	uint32_t Din[50];
	uint32_t Dout[50];

	memset(Din, 0, sizeof(Din));
	memset(Dout, 0, sizeof(Dout));

	Din[0] = 0x7369C667;
	Din[1] = 0xEC4AFF51;
	Din[2] = 0xABBACD29;
	Din[3] = 0x00000010;
	Din[31] = 0x80000000;
    
	KeccakF1600_StatePermute(Din, Dout);
	
  printf("Keccak Ends!\n");
	return 0;

}

