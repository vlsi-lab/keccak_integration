///////////////////////////////////////////////////////////////
// Author: Petr Bardonek ibardonek@fit.vut.cz
// Language: SystemVerilog
// Description: Package encompassing all files defining
//              passive UVM agent for the Keccak component.
///////////////////////////////////////////////////////////////
package keccak_agent_pkg;
    import uvm_pkg::*;
    import test_parameters_pkg::*;
    import obi_pkg::*;
    import mem_agent_pkg::*;

    `include "uvm_macros.svh"
    `include "keccak_transaction.svh"
    `include "keccak_input_monitor.svh"
    `include "keccak_monitor.svh"
    `include "keccak_coverage.svh"
    `include "keccak_gm.svh"
    `include "keccak_agent.svh"
endpackage: keccak_agent_pkg
