///////////////////////////////////////////////////////////////
// Author: Petr Bardonek ibardonek@fit.vut.cz
// Language: SystemVerilog
// Description: Package encompassing all files defining
//              UVM environment.
///////////////////////////////////////////////////////////////
package sv_env_pkg;
    import uvm_pkg::*;
    import sv_param_pkg::*;
    import sv_keccak_agent_pkg::*;
    import sv_keccak_gm_pkg::*;

    `include "uvm_macros.svh"
    `include "scoreboard.svh"
    `include "env.svh"
endpackage: sv_env_pkg
