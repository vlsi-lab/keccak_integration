///////////////////////////////////////////////////////////////
// Author: Petr Bardonek ibardonek@fit.vut.cz
// Language: SystemVerilog
// Description: Package encompassing all files defining
//              golden model (GM, reference model).
///////////////////////////////////////////////////////////////
package sv_keccak_gm_pkg;
    import uvm_pkg::*;
    import sv_param_pkg::*;
    import sv_keccak_agent_pkg::*;

    `include "uvm_macros.svh"
    `include "golden_model.svh"
endpackage: sv_keccak_gm_pkg
