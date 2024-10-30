# **KRONOS**

## (K)eccak (R)ISC-V (O)ptimized e(N)gine f(O)r Ha(S)hing

## Keccak component UVM verification

Verification for the Keccak component is implemented with SystemVerilog utilizing Universal Verification Methodology (UVM) following its principles.
The verification is done in simulation using Questasim from Mentor (2020.4).

### Run

The verification can be run with makefile from the main directory with these options:

- UVM_TESTNAME
  - Specify which UVM test to execute (optional)
  - Ignored if RUN_MULTIPLE_TESTS is set
- UVM_TESTS_FILE
  - Specify location of the file with list of test names (optional).
  - Mandatory if RUN_MULTIPLE_TESTS is set
- RUN_MULTIPLE_TESTS
  - Run all tests specified in file with list of test names (optional)
  - Forces run of simulation in cmdline
- TRANS_CNT
  - Number of transactions to be generated with random sequences (optional)
  - If number specified is 0, default value will be used
- SEED - Number to be used as a seed for randomization (optional)

Makefile targets for verification:
- `comp-verif-run` - runs simulation within cmdline with arguments specified
- `comp-verif-run-gui` - runs simulation within GUI with arguments specified
- `comp-verif-cov-rep-html` - generates html coverage report of executed tests
- `comp-verif-cov-rep-txt` - generates txt coverage report of executed tests
- `comp-verif-cov-merge` - merges all coverage databases of executed tests to a single one
- `comp-verif-cov-merge-rep-html` - generates html coverage report of merged coverage databases
- `comp-verif-cov-merge-rep-txt` - generates txt coverage report of merged coverage databases
- `comp-verif-clean` - deletes all generated folders and files related to verification

NOTE: Coverage reports are stored in `veris_res` directory.


The UVM verification is placed in `verif` directory at the `hw/vendor/vlsi_polito_keccak` directory. The verif folder also contains shell script for running the verification. Files `transcript` and `vsim.wlf` usable for debugging after quiting simulation are also in this directory.

For further information refer to [README](./hw/vendor/vlsi_polito_keccak/README.md).