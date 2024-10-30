///////////////////////////////////////////////////////////////
// Author: Petr Bardonek ibardonek@fit.vut.cz
// Language: SystemVerilog
// Description: Module declaration
///////////////////////////////////////////////////////////////
module DUT( input logic CLK );
    import uvm_pkg::*;
    import sv_param_pkg::*;

    // Instantiate DUT interface
    i_keccak_itf keccak_itf( CLK );

    // Black box signals mapping (from top module ENTITY)
    keccak HDL_DUT_U(
        .clk( CLK               ),
        .rst_n(keccak_itf.rst_n),
        .start(keccak_itf.start),
        .din(keccak_itf.din),
        .dout(keccak_itf.dout),
        .status_d(keccak_itf.status_d),
        .status_de(keccak_itf.status_de),
        .keccak_intr(keccak_itf.keccak_intr)
    );

    initial begin
        // set interface to uvm config database
        // Black box interface
        uvm_config_db #(virtual i_keccak_itf)::set( null, "uvm_test_top", "keccak_itf", keccak_itf);
    end
endmodule: DUT
