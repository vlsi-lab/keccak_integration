///////////////////////////////////////////////////////////////
// Author: Petr Bardonek ibardonek@fit.vut.cz
// Language: SystemVerilog
// Description: Package encompassing all files defining
//              UVM agent for the DUT main interface.
///////////////////////////////////////////////////////////////
package fve_agent_pkg;
    import uvm_pkg::*;
    import test_parameters_pkg::*;
    import mem_agent_pkg::*;

    `include "uvm_macros.svh"
    `include "fve_transaction.svh"
    `include "fve_monitor.svh"
    `include "fve_coverage.svh"
    `include "fve_driver.svh"
    `include "fve_sequencer.svh"
    `include "fve_sequence.svh"
    `include "fve_agent.svh"
endpackage: fve_agent_pkg
