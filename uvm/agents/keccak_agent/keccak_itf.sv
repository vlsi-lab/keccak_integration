///////////////////////////////////////////////////////////////
// Author: Petr Bardonek ibardonek@fit.vut.cz
// Language: SystemVerilog
// Description: Definition of interface for connection between
//              UVM verification environment and Keccak component interface pins.
///////////////////////////////////////////////////////////////
interface keccak_itf
    // import agent package for transaction and wrapper base classes
    import uvm_pkg::*;
    import test_parameters_pkg::*;
    import keccak_agent_pkg::*;
    import obi_pkg::*;
    (
        input logic clk,
        // Inputs
        input logic rst_n,
        input logic start,
        input logic [1599:0] din,
        // Outputs
        input logic [1599:0] dout,
        input logic status_d,
        input logic status_de,
        input logic keccak_intr
    );

    // Monitor point of view
    clocking cbm @( posedge clk );
        input rst_n, start, din, dout, status_d, status_de, keccak_intr;
    endclocking: cbm

    // monitor - read values on all interface pins using monitor clocking blocks
    task automatic monitor( keccak_transaction t );
        t.rst_n = cbm.rst_n;
        t.start = cbm.start;
        t.din = cbm.din;
        t.dout = cbm.dout;
        t.status_d = cbm.status_d;
        t.status_de = cbm.status_de;
        t.keccak_intr = cbm.keccak_intr;
    endtask: monitor

    // monitor - read values on all interface pins asynchronously (no clocking blocks)
    task automatic input_monitor( keccak_transaction t );
        t.rst_n = rst_n;
        t.start = start;
        t.din = din;
        t.dout = dout;
        t.status_d = status_d;
        t.status_de = status_de;
        t.keccak_intr = keccak_intr;
    endtask: input_monitor

    // wait for n clock cycles
    task automatic wait_for_clock( int n = 1 );
        repeat ( n ) begin
            @( cbm );
        end
    endtask: wait_for_clock

    // wait for reset to finish
    task automatic wait_for_reset_inactive();
        @( posedge rst_n );
    endtask: wait_for_reset_inactive

endinterface: keccak_itf