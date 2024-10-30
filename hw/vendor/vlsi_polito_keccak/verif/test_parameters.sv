///////////////////////////////////////////////////////////////
// Author: Petr Bardonek ibardonek@fit.vut.cz
// Language: SystemVerilog
// Description: Package encompassing parameters used throughtout
//              the UVM verification testbench.
///////////////////////////////////////////////////////////////
package sv_param_pkg;
    import uvm_pkg::*;

    `include "uvm_macros.svh"

    // clocks and resets
    parameter CLK_PERIOD = 10ns;

    // generic parameters
    parameter logic RST_ACT_LEVEL = 1'b0;

    int unsigned TRANSACTION_COUNT = 512;
    int unsigned SEED = 0;
    parameter NROUNDS = 24;

    logic [1599:0] ZERO = 0;
    logic [1599:0] ONE = 1;
    logic [1599:0] MAX = {1600{1'b1}};
    logic [1599:0] LOW = 2;
    logic [1599:0] HIGH = MAX-1;

    parameter logic START = 1'b1;

endpackage: sv_param_pkg