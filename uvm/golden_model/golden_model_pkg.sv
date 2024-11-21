///////////////////////////////////////////////////////////////
// Author: Petr Bardonek ibardonek@fit.vut.cz
// Language: SystemVerilog
// Description: Package encompassing all files defining
//              golden model (GM, reference model).
///////////////////////////////////////////////////////////////
package golden_model_pkg;
    import uvm_pkg::*;
    import test_parameters_pkg::*;
    import fve_agent_pkg::*;
    import mem_agent_pkg::*;
    import keccak_agent_pkg::*;

    `include "uvm_macros.svh"
    `include "golden_model.svh"
endpackage: golden_model_pkg
