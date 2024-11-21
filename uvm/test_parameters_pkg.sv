///////////////////////////////////////////////////////////////
// Author: Petr Bardonek ibardonek@fit.vut.cz
// Language: SystemVerilog
// Description: Package encompassing parameters used throughtout
//              the UVM verification testbench.
///////////////////////////////////////////////////////////////
package test_parameters_pkg;
    import uvm_pkg::*;
    
    `include "uvm_macros.svh"

    // Clocks and resets
    parameter CLK_PHASE_HI = 5ns;
    parameter CLK_PHASE_LO = 5ns;
    parameter CLK_PERIOD = CLK_PHASE_HI + CLK_PHASE_LO;

    parameter STIM_APPLICATION_DEL = CLK_PERIOD * 0.1;
    parameter RESP_ACQUISITION_DEL = CLK_PERIOD * 0.9;
    parameter RESET_DEL = STIM_APPLICATION_DEL;
    parameter RESET_WAIT_CYCLES = 50;

    parameter logic RST_ACT_LEVEL = 1'b0;

    // Variables settable by args
    int unsigned transaction_count = 'h40000;
    int unsigned seed = 0;
    string firmware;
    // Boot selection (0:jtag or 1:flash)
    logic boot_sel = 0;
    // SPI selection (0:ot-qspi or 1:memory mapped flash, only valid if boot_sel is 1)
    logic execute_from_flash = 1;

    // Generic parameters
    parameter COREV_PULP = 0;
    parameter FPU = 0;
    parameter ZFINX = 0;
    parameter JTAG_DPI = 0;
    parameter USE_EXTERNAL_DEVICE_EXAMPLE = 1;
    parameter CLK_FREQUENCY_KHz = 'd100_000;
    parameter X_EXT = 0; // eXtension interface in cv32e40x

    parameter MEM_SIZE = core_v_mini_mcu_pkg::MEM_SIZE; // Bytes
    parameter N_MEM_BANKS = core_v_mini_mcu_pkg::NUM_BANKS; // Banks
    parameter MEM_BANK_SIZE = MEM_SIZE / N_MEM_BANKS; // Size of memory bank in B
    parameter MEM_BANK_SIZE_W = MEM_BANK_SIZE / 4; // Size of memory bank in Words (4B)

    // Keccak specific parameters
    parameter EXT_DOMAINS_RND = core_v_mini_mcu_pkg::EXTERNAL_DOMAINS == 0 ? 1 : core_v_mini_mcu_pkg::EXTERNAL_DOMAINS;
    parameter NROUNDS = 24;

    parameter logic [1599:0] ZERO = 0;
    parameter logic [1599:0] ONE = 1;
    parameter logic [1599:0] MAX = {1600{1'b1}};
    parameter logic [1599:0] LOW = 2;
    parameter logic [1599:0] HIGH = MAX-1;

    parameter logic START = 1'b1;

endpackage: test_parameters_pkg