///////////////////////////////////////////////////////////////
// Author: Petr Bardonek ibardonek@fit.vut.cz
// Language: SystemVerilog
// Description: The topmost encapsulation level of the verification
///////////////////////////////////////////////////////////////
module top;
    import uvm_pkg::*;
    import sv_param_pkg::*;
    import sv_keccak_agent_pkg::*;
    import sv_env_pkg::*;
    import sv_test_pkg::*;

    `include "uvm_macros.svh"

    // Global clock signal
    logic CLK;
    // DUT instance
    DUT dut( CLK );

    // clock generation
    initial begin
        CLK <= 'b0;
        #(CLK_PERIOD/2) forever #(CLK_PERIOD/2) CLK = ~CLK;
    end

    // customize the default printer
    initial begin
        automatic uvm_table_printer printer = new;
        printer.knobs.begin_elements = -1;
        printer.knobs.value_width = -1;
        uvm_default_printer = printer;
        $timeformat(-9, 0, " ns", 8);
    end

    // Add arguments from tcl
    initial begin
        if (!$value$plusargs("SEED=%d", SEED ))
            `uvm_warning("MISSING_PARAM", "Seed for randomization is not specified, using default")
        if (!$value$plusargs("TRANSACTION_COUNT=%d", TRANSACTION_COUNT ))
            `uvm_warning("MISSING_PARAM", "Transaction count was not specified, using default")
    end

    // interfaces should register them self in configuration space, run default test
    initial begin
        // start of the simulation
        run_test( "keccak_test" );
    end
endmodule: top
