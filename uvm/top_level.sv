///////////////////////////////////////////////////////////////
// Author: Petr Bardonek ibardonek@fit.vut.cz
// Language: SystemVerilog
// Description: The topmost encapsulation level of the verification
///////////////////////////////////////////////////////////////
module top; // <-- tb_top
    import uvm_pkg::*;
    import test_parameters_pkg::*;
    import fve_agent_pkg::*;
    import mem_agent_pkg::*;
    import keccak_agent_pkg::*;
    import fve_env_pkg::*;
    import test_lib_pkg::*;

    `include "uvm_macros.svh"

    // Global clock signal
    logic clk;
    // DUT instance
    DUT dut( clk ); // <-- testharness

    // handler for backdoor access
    backdoor_access bd_access;

    // clock generation
    initial begin : clock_gen
        forever begin
            #CLK_PHASE_HI clk = 1'b0;
            #CLK_PHASE_LO clk = 1'b1;
        end
    end : clock_gen

    // customize the default printer
    initial begin
        automatic uvm_table_printer printer = new;
        printer.knobs.begin_elements = -1;
        printer.knobs.value_width = -1;
        uvm_default_printer = printer;
        $timeformat(-9, 0, " ns", 8);
    end

    // Get arguments
    initial begin
        if ($value$plusargs("firmware=%s", firmware)) begin
            `uvm_info("TESTBENCH", $sformatf("loading firmware %0s",firmware), UVM_MEDIUM)
        end else begin
            `uvm_info("TESTBENCH", $sformatf("no firmware specified"), UVM_MEDIUM)
            if (JTAG_DPI == 0) begin
                $finish;
            end
        end

        if ($test$plusargs("boot_sel")) begin
            $value$plusargs("boot_sel=%d", boot_sel);
            if (boot_sel == 1) begin
                `uvm_info("TESTBENCH", $sformatf("Booting from flash"), UVM_MEDIUM)
            end else if (boot_sel == 0) begin
                `uvm_info("TESTBENCH", $sformatf("Booting from jtag"), UVM_MEDIUM)
            end else begin
                `uvm_info("TESTBENCH", $sformatf("Wrong Boot Option specified (jtag, flash) - using jtag (boot_sel=0)"), UVM_MEDIUM)
            end
        end else begin
            `uvm_info("TESTBENCH", $sformatf("No Boot Option specified, using jtag (boot_sel=0)"), UVM_MEDIUM)
        end

        if (boot_sel == 1) begin
            if ($test$plusargs("execute_from_flash")) begin
                $value$plusargs("execute_from_flash=%d", execute_from_flash);
                if (execute_from_flash == 1) begin
                    `uvm_info("TESTBENCH", $sformatf("Using YosysHQ memory mapped SPI"), UVM_MEDIUM)
                end else if (execute_from_flash == 0) begin
                    `uvm_info("TESTBENCH", $sformatf("Using OpenTitan SPI"), UVM_MEDIUM)
                end else begin
                    `uvm_info("TESTBENCH", $sformatf("Wrong SPI Option specified (execute from flash, load flash in-memory) - using execute from flash (execute_from_flash=1)"), UVM_MEDIUM)
                end
            end else begin
                `uvm_info("TESTBENCH", $sformatf("No SPI Option specified, using execute from flash (execute_from_flash=1)"), UVM_MEDIUM)
            end
        end

        // if (!$value$plusargs("SEED=%d", SEED ))
        //     `uvm_warning("MISSING_PARAM", "Seed for randomization is not specified, using default")
        // if (!$value$plusargs("TRANSACTION_COUNT=%d", TRANSACTION_COUNT ))
        //     `uvm_warning("MISSING_PARAM", "Transaction count was not specified, using default")
    end

    // interfaces should register them self in configuration space, run default test
    initial begin
        bd_access = new();
        uvm_config_db#(backdoor_access)::set(null, "uvm_test_top", "bd_access", bd_access);
        // start of the simulation
        run_test( "fve_test" );
    end
endmodule: top
