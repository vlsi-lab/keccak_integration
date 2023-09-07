# Introduction

In the **keccak_integration** repository you can find an example of how a post-quantum crytpographic (PQC) hardware accelerator works. 



# Getting started
The repository is organized as followed. 

![Image](https://github.com/vlsi-lab/keccak_integration/blob/main/repo_org.png)

There are two important branches:
* keccak_pulpissimo
* keccak_xheep

[PULPissimo](https://github.com/pulp-platform/pulpissimo.git) is a microcontroller from the open-source PULP platform project is used and configured to work with the 4-stage pipeline core RI5CY. Then, Keccak and [CRYSTALS-Kyber](https://github.com/PQClean/PQClean/tree/master/crypto_kem) algorithms are compiled using [PULP toolchain](https://github.com/pulp-platform/pulp-riscv-gnu-toolchain), setting the optimization flag '-O3' and increasing the
stack’s memory size.

[X-Heep](https://github.com/esl-epfl/x-heep.git) (eXtendable Heterogeneous Energy-Efficient Platform) is a RISC-V microcontroller described in SystemVerilog that can be configured to target small and tiny platforms as well as extended to support accelerators.

<!-- LICENSE -->
## License
Distributed under the MIT License.
See `LICENSE.txt` for more information.




<!-- CONTACT -->
## Contact
Alessandra Dolmeta - [@linkedin ]([https://twitter.com/your_username](https://www.linkedin.com/in/alessandra-dolmeta-4884301a3/)) - alessandra.dolmeta@polito.it

Mattia Mirigaldi -  [@linkedin ]([[https://twitter.com/your_username](https://www.linkedin.com/in/alessandra-dolmeta-4884301a3/)](https://www.linkedin.com/in/mattia-mirigaldi-8109b9201/)) - mattia.mirigaldi@polito.it


