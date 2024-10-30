///////////////////////////////////////////////////////////////
// Author: Petr Bardonek ibardonek@fit.vut.cz
// Language: SystemVerilog
// Description: Package encompassing all files defining
//              UVM agent for the DUT main interface.
///////////////////////////////////////////////////////////////
package sv_keccak_agent_pkg;
    import uvm_pkg::*;
    import sv_param_pkg::*;

    `include "uvm_macros.svh"
    `include "keccak_transaction.svh"
    `include "keccak_monitor.svh"
    `include "keccak_coverage.svh"
    `include "keccak_driver.svh"
    `include "keccak_sequencer.svh"
    `include "keccak_sequence.svh"
    `include "keccak_agent.svh"
endpackage: sv_keccak_agent_pkg
