///////////////////////////////////////////////////////////////
// Author: Petr Bardonek ibardonek@fit.vut.cz
// Language: SystemVerilog
// Description: Package encompassing all files defining
//              UVM environment.
///////////////////////////////////////////////////////////////
package fve_env_pkg;
    import uvm_pkg::*;
    import test_parameters_pkg::*;
    import fve_agent_pkg::*;
    import mem_agent_pkg::*;
    import keccak_agent_pkg::*;
    import golden_model_pkg::*;

    `include "uvm_macros.svh"
    `include "fve_scoreboard.svh"
    `include "fve_env.svh"
endpackage: fve_env_pkg
