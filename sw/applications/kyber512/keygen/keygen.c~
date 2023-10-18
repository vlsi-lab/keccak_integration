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
  
    uint8_t pk[PQCLEAN_KYBER512_CLEAN_CRYPTO_PUBLICKEYBYTES];
    uint8_t sk_a[PQCLEAN_KYBER512_CLEAN_CRYPTO_SECRETKEYBYTES];

    // Key-pair generation
    printf("Keypair starts!\n");
    PQCLEAN_KYBER512_CLEAN_crypto_kem_keypair(pk, sk_a);
    printf("Keypair done!\n");

    printf("pk:\n");
    printbytes(pk, PQCLEAN_KYBER512_CLEAN_CRYPTO_PUBLICKEYBYTES);
    printf("sk_a:\n");
    printbytes(sk_a, PQCLEAN_KYBER512_CLEAN_CRYPTO_SECRETKEYBYTES);

  
    return 0;
}
