///////////////////////////////////////////////////////////////
// Author: Petr Bardonek ibardonek@fit.vut.cz
// Language: SystemVerilog
// Description: Definition of interface for connection between
//              UVM verification environment and DUT interface pins.
///////////////////////////////////////////////////////////////
`include "uvm_macros.svh"

interface i_keccak_itf
    // import agent package for transaction and wrapper base classes
    import uvm_pkg::*;
    import sv_param_pkg::*;
    import sv_keccak_agent_pkg::*;
    (
        input logic CLK
    );

    // Inputs
    logic rst_n;
    logic start;
    logic [1599:0] din;
    // Outputs
    logic [1599:0] dout;
    logic status_d;
    logic status_de;
    logic keccak_intr;

    // clocking blocks
    // testbench point of view
    clocking cb @( posedge CLK );
        output rst_n, start, din;
        input dout, status_d, status_de, keccak_intr;
    endclocking: cb

    // monitor point of view
    clocking cbm @( posedge CLK );
        input rst_n, start, din, dout, status_d, status_de, keccak_intr;
    endclocking: cbm

    // drive - drive input and inout pins
    task automatic drive( keccak_transaction t );
        cb.rst_n <= t.rst_n;
        cb.start <= t.start;
        cb.din <= t.din;
    endtask: drive

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
    task automatic async_monitor( keccak_transaction t );
        t.rst_n = rst_n;
        t.start = start;
        t.din = din;
        t.dout = dout;
        t.status_d = status_d;
        t.status_de = status_de;
        t.keccak_intr = keccak_intr;
    endtask: async_monitor

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

endinterface: i_keccak_itf