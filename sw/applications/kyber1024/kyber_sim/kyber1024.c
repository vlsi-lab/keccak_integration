#include <stddef.h>
#include <stdint.h>
#include <stdio.h>
#include <string.h>

#include "../api.h"
#include "../randombytes.h"

static void printbytes(const uint8_t *x, size_t xlen) {
    size_t i;
    for (i = 0; i < xlen; i++) {
        printf("%02x", x[i]);
    }
    printf("\n");
    }


int main(void) {
  uint8_t key_a[PQCLEAN_KYBER1024_CLEAN_CRYPTO_BYTES], key_b[PQCLEAN_KYBER1024_CLEAN_CRYPTO_BYTES];
    uint8_t pk[PQCLEAN_KYBER1024_CLEAN_CRYPTO_PUBLICKEYBYTES];
    uint8_t sendb[PQCLEAN_KYBER1024_CLEAN_CRYPTO_CIPHERTEXTBYTES];
    uint8_t sk_a[PQCLEAN_KYBER1024_CLEAN_CRYPTO_SECRETKEYBYTES];
    int j;

    // Key-pair generation
	printf("Keypair starts!\n");
    PQCLEAN_KYBER1024_CLEAN_crypto_kem_keypair(pk, sk_a);
	//printf("Keypair done!\n");

	printf("pk:\n");
	printbytes(pk, PQCLEAN_KYBER1024_CLEAN_CRYPTO_PUBLICKEYBYTES);
       printf("sk_a:\n");
	printbytes(sk_a, PQCLEAN_KYBER1024_CLEAN_CRYPTO_SECRETKEYBYTES);

    // Encapsulation
    PQCLEAN_KYBER1024_CLEAN_crypto_kem_enc(sendb, key_b, pk);
	printf("Encapsulation done!\n");

	printf("sendb:\n");
	printbytes(sendb, PQCLEAN_KYBER1024_CLEAN_CRYPTO_CIPHERTEXTBYTES);
	printf("key_b:\n");
    printbytes(key_b, PQCLEAN_KYBER1024_CLEAN_CRYPTO_BYTES);
	
    // Decapsulation
    PQCLEAN_KYBER1024_CLEAN_crypto_kem_dec(key_a, sendb, sk_a);
    printf("Decapsulation done!\n");
    
    printf("key_a:\n");
    printbytes(key_a, PQCLEAN_KYBER1024_CLEAN_CRYPTO_BYTES);
    
    for (j = 0; j < PQCLEAN_KYBER1024_CLEAN_CRYPTO_BYTES; j++) {
        if (key_a[j] != key_b[j]) {
            printf("ERROR\n");
            return -1;
        }
	}
    return 0;
}
