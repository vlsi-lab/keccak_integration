///////////////////////////////////////////////////////////////
// Author: Petr Bardonek ibardonek@fit.vut.cz
// Language: SystemVerilog
// Description: Definition of interface for connection between
//              UVM verification environment and memory subsystem interface pins.
///////////////////////////////////////////////////////////////
interface mem_itf
    // import agent package for transaction and wrapper base classes
    import uvm_pkg::*;
    import test_parameters_pkg::*;
    import mem_agent_pkg::*;
    import obi_pkg::*;
    (
        input logic clk_i,
        input logic rst_ni,
        // Clock-gating signal;
        input logic [N_MEM_BANKS-1:0] clk_gate_en_i,
        input obi_req_t  [N_MEM_BANKS-1:0] ram_req_i,
        input obi_resp_t [N_MEM_BANKS-1:0] ram_resp_o,
        input logic [N_MEM_BANKS-1:0] set_retentive_i
    );

    // Monitor point of view
    clocking cbm @( posedge clk_i );
        input rst_ni, clk_gate_en_i, ram_req_i, ram_resp_o, set_retentive_i;
    endclocking: cbm

    // monitor - read values on all interface pins using monitor clocking blocks
    task automatic monitor( mem_transaction t );
        t.rst_ni = cbm.rst_ni;
        t.clk_gate_en_i = cbm.clk_gate_en_i;
        t.ram_req_i = cbm.ram_req_i;
        t.set_retentive_i = cbm.set_retentive_i;
        t.ram_resp_o = cbm.ram_resp_o;
    endtask: monitor

    // monitor - read values on all interface pins asynchronously (no clocking blocks)
    task automatic input_monitor( mem_transaction t );
        t.rst_ni = rst_ni;
        t.clk_gate_en_i = clk_gate_en_i;
        t.ram_req_i = ram_req_i;
        t.set_retentive_i = set_retentive_i;
        t.ram_resp_o = ram_resp_o;
    endtask: input_monitor

    // wait for n clock cycles
    task automatic wait_for_clock( int n = 1 );
        repeat ( n ) begin
            @( cbm );
        end
    endtask: wait_for_clock

    // wait for reset to finish
    task automatic wait_for_reset_inactive();
        @( posedge rst_ni );
    endtask: wait_for_reset_inactive

endinterface: mem_itf