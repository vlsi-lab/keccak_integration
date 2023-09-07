# Introduction

In the **pqc_riscv** repository you can find an example of a post-quantum crytpographic (PQC) hardware accelerator for pulpissimo. 
If you are using this accelerator, please refers to:

> Alessandra Dolmeta, Mattia Mirigaldi, Maurizio Martina, and Guido Masera. 2023. Implementation and integration of Keccak accelerator on RISC-V for CRYSTALS-Kyber. In Proceedings of the 20th ACM International Conference on Computing Frontiers (CF '23). Association for Computing Machinery, New York, NY, USA, 381–382. https://doi.org/10.1145/3587135.3591432


# Getting started
The RISC-V PULPissimo microcontroller (Figure - I) from the open-source [PULP platform])(https://github.com/pulp-platform) project is used and configured to work with the 4-stage pipeline core RI5CY. Then, Keccak algorithm is compiled using [PULP toolchain](https://github.com/pulp-platform/pulp-riscv-gnu-toolchain), setting the optimization flag '-O3' and increasing the
stack’s memory size (not for Keccak itself, but in the case of bigger applications, like PQC algorithms).

The `randombytes` file is modified, generating a pseudo-random sequence of bytes, while `fips202`’s standard library functions are substituted
by the one provided by PULP-team. The accelerator is driven in a memory-mapped fashion style and attached to the SoC through an AXI plug, as shown in Figure - II . Its dependency to PULPissimo is managed by [Bender](https://github.com/pulp-platform/bender), while the Keccak register interface is
generated using [reggen tool](https://docs.opentitan.org/util/reggen/doc/).
The high-speed Keccak core developed by Keccak teams is optimized according to our application (Figure - III ). It implements transformation
rounds discussed in section 2. The size of the round constant generator is reduced from 64-bit to one-byte size, simplifying the computation in ι. The accelerator is simulated and tested using ModelSim, exploiting a dedicated driver

![Image](https://github.com/vlsiale/pulpissimo_keccak/blob/main/keccak_ip.svg)

## Folder organization
- **pulpissimo**: forked repository of the original pulpissimo folder. Please refer to [pulpissimo GitHub Pages](https://github.com/pulp-platform/pulpissimo) for further information. 
- **pulp_soc**: forked repository of the pulp_soc sub-ip repository. This is the main repository that contains most of the SoCs RTL logic. This allow us adding new IPs to pulpissimo. The new source code has been registered in the Bender.yml manifest file, in order to add this new repository as a dependency to pulp_soc's Bender.yml. As explained in `pulpissimo` repository, this is the most used strategy throughout the pulpissimo project, which is a collection of many different IP repositories.
- **pulp-runtime**: forked repository of the original pulp-runtime folder. Please refer to [pulp-runtime GitHub Pages](https://github.com/pulp-platform/pulp-runtime.git) for further information.  
- **test**: contains the files required for Keccak test, and for Keccak-IP simulation.

# Simple runtime
## Prerequisities
Prerequisites are explained in detail in the [main repository](https://github.com/pulp-platform/pulpissimo). We report for the reader's convenience the main steps.

First, install the system dependencies indicated [here](https://github.com/pulp-platform/pulp-runtime/blob/master/README.md).

Then, make sure you have  [riscv-gnu-toolchain](https://github.com/pulp-platform/pulp-riscv-gnu-toolchain) installed, and get the repository:
```
git clone --recursive https://github.com/vlsi-lab/keccak_integration.git
git branch keccak_pulpissimo
```
Different bash files are present, to properly set the overall enviroment. In order to run #.sh files, point:
```
source YOUR_QUESTA_SIM_PATH
export PULP_RISCV_GCC_TOOLCHAIN=YOUR_PULP_TOOLCHAIN_PATH
export PATH=$PULP_RISCV_GCC_TOOLCHAIN/bin:$PATH
```
The simple runtime that is cloned supports many different hardware configurations. We want PULPissimo, therefore:
```
source pulp-runtime/configs/pulpissimo.sh
```
Now we are ready to set up the simulation environment. All these commands are added in each .sh file.

## RTL-simulation
Now you need Questasim to do an RTL simulation of PULPissimo. To understand how the rtl-simulation-platform is build and the meaning of all the commands present in .sh files, link [here](https://github.com/pulp-platform/pulpissimo/blob/master/README.md#building-the-rtl-simulation-platform).

## Downloading and running tests
Finally, you can download and run tests. Now you can change the directory to your desired test e.g.: for testing, simply a Keccak transformation, run
```
cd ../test/keccak_ip
make clean all
make dis > keccak.s
make -f Makefile run gui=1
```
`make dis` will provide you with the disassembly of your application, while `make run gui=1` will start Modelsim GUI. In case you are not interested in the GUI, simply run  `make run`.
