# Introduction

In the **keccak_integration** repository you can find an example of how a post-quantum cryptographic (PQC) hardware accelerator works. 
The repository is organized as follows. 

![Image](https://github.com/vlsi-lab/keccak_integration/blob/main/repo_org.png)

There are two important branches:
* __keccak_pulpissimo__
* __keccak_xheep__

Keccak accelerator has been integrated and tested in both microcontrollers.

[PULPissimo](https://github.com/pulp-platform/pulpissimo.git) is a microcontroller from the open-source PULP platform project is used and configured to work with the 4-stage pipeline core RI5CY. Then, Keccak and [CRYSTALS-Kyber](https://github.com/PQClean/PQClean/tree/master/crypto_kem) algorithms are compiled using [PULP toolchain](https://github.com/pulp-platform/pulp-riscv-gnu-toolchain), setting the optimization flag '-O3' and increasing the
stack’s memory size.

[X-Heep](https://github.com/esl-epfl/x-heep.git) (eXtendable Heterogeneous Energy-Efficient Platform) is a RISC-V microcontroller described in SystemVerilog that can be configured to target small and tiny platforms as well as extended to support accelerators.


## Getting started
Get the repository:
```
git clone --recursive https://github.com/vlsi-lab/keccak_integration.git
```
And check for the branch desired.
```
git checkout keccak_XXX
```

<!-- LICENSE -->
## License
Distributed under the MIT License.
See `LICENSE.txt` for more information.




<!-- CONTACT -->
## Contact
Alessandra Dolmeta - [linkedin](https://www.linkedin.com/in/alessandra-dolmeta-4884301a3/) - alessandra.dolmeta@polito.it

Mattia Mirigaldi -  [linkedin](https://www.linkedin.com/in/alessandra-dolmeta-4884301a3/)](https://www.linkedin.com/in/mattia-mirigaldi-8109b9201/) - mattia.mirigaldi@polito.it

## Reference
Work has been presented at [TASER2023](https://ches.iacr.org/2023/forum.php), during [CHES](https://ches.iacr.org/2023/) conference.


