#include <stddef.h>
#include <stdint.h>
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#include "../api.h"
#include "../randombytes.h"

int main(void) {
  	uint8_t key_a[PQCLEAN_KYBER768_CLEAN_CRYPTO_BYTES], key_b[PQCLEAN_KYBER768_CLEAN_CRYPTO_BYTES];
    uint8_t pk[PQCLEAN_KYBER768_CLEAN_CRYPTO_PUBLICKEYBYTES];
    uint8_t sendb[PQCLEAN_KYBER768_CLEAN_CRYPTO_CIPHERTEXTBYTES];
    uint8_t sk_a[PQCLEAN_KYBER768_CLEAN_CRYPTO_SECRETKEYBYTES];
    int j;
	size_t i1, i2, i3, i4;

	FILE *pk_file, *sk_file, *sendb_file, *keyb_file;
    
	pk_file=fopen("./txt/pk.txt","w");
	if(pk_file == NULL)
   	{
      printf("Error!");   
      return -1;             
   	}

	sk_file=fopen("./txt/sk.txt","w");
	if(sk_file == NULL)
   	{
      printf("Error!");   
      return -1;             
   	}

	keyb_file=fopen("./txt/keyb.txt","w");
	if(keyb_file == NULL)
   	{
      printf("Error!");   
      return -1;             
   	}

	sendb_file=fopen("./txt/sendb.txt","w");
	if(sendb_file == NULL)
   	{
      printf("Error!");   
      return -1;             
   	}

    // Key-pair generation
	printf("Keypair starts!\n");
    PQCLEAN_KYBER768_CLEAN_crypto_kem_keypair(pk, sk_a);
	printf("Keypair done!\n");


	for (i1 = 0; i1 < PQCLEAN_KYBER768_CLEAN_CRYPTO_PUBLICKEYBYTES; i1++) {
        fprintf(pk_file, "pk[%d] = 0x%02x;", i1, pk[i1]);
        fprintf(pk_file, "\n");
    }

	printf("pk.txt file completed!\n");
   	
		for (i2 = 0; i2 < PQCLEAN_KYBER768_CLEAN_CRYPTO_SECRETKEYBYTES; i2++) {
        fprintf(sk_file, "sk_a[%d] = 0x%02x;", i2, sk_a[i2]);
        fprintf(sk_file, "\n");
    }

	printf("sk_a.txt file completed!\n");

    // Encapsulation
    PQCLEAN_KYBER768_CLEAN_crypto_kem_enc(sendb, key_b, pk);
	printf("Encapsulation done!\n");

	for (i3 = 0; i3 < PQCLEAN_KYBER768_CLEAN_CRYPTO_CIPHERTEXTBYTES; i3++) {
        fprintf(sendb_file, "sendb[%d] = 0x%02x;", i3, sendb[i3]);
        fprintf(sendb_file, "\n");
    }

	printf("sendb.txt file completed!\n");

	for (i4 = 0; i4 < PQCLEAN_KYBER768_CLEAN_CRYPTO_BYTES; i4++) {
        fprintf(keyb_file, "key_b[%d] = 0x%02x;", i4, key_b[i4]);
        fprintf(keyb_file, "\n");
    }

	printf("keyb.txt file completed!\n");


    // Decapsulation
    PQCLEAN_KYBER768_CLEAN_crypto_kem_dec(key_a, sendb, sk_a);
    printf("Decapsulation done!\n");
    
    
    for (j = 0; j < PQCLEAN_KYBER768_CLEAN_CRYPTO_BYTES; j++) {
        if (key_a[j] != key_b[j]) {
            printf("ERROR\n");
            return -1;
        }
	}

	fclose(sk_file);
	fclose(pk_file);
	fclose(sendb_file);
	fclose(keyb_file);
	
    return 0;
}
