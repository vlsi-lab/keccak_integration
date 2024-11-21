///////////////////////////////////////////////////////////////
// Author: Petr Bardonek ibardonek@fit.vut.cz
// Language: SystemVerilog
// Description: This class is used to monitor input signals to Keccak
//              component. It sends inputs to the GM.
//              It replaces driver, which is not present
//              within passive monitoring agent.
///////////////////////////////////////////////////////////////
class keccak_input_monitor extends uvm_monitor;

    // registration of component tools
    `uvm_component_utils( keccak_input_monitor )

    // reference to the interface wrapper, initialized during the connect phase by parent agent
    virtual keccak_itf vif;
    // used to send transactions to all connected components
    uvm_analysis_port #(keccak_transaction) analysis_port;
    // base name prefix for created transactions
    string m_name = "dut_keccak";

    // Constructor - creates new instance of this class
    function new( string name = "m_input_monitor_h", uvm_component parent = null );
        super.new( name, parent );
    endfunction: new

    // Build - instantiates child components
    function void build_phase( uvm_phase phase );
        super.build_phase( phase );
        analysis_port = new( "analysis_port", this );
    endfunction: build_phase

    // Run - starts the processing in driver (bidirectional)
    task run_phase( uvm_phase phase );
        keccak_transaction req;
        // synchronize with DUT
        vif.wait_for_clock();
        forever begin
            req = keccak_transaction::type_id::create(
                $sformatf("%0s: %0t", m_name, $time) );
            // drive ports
            vif.input_monitor( req );
            // send transaction to GM
            analysis_port.write( req );
            // synchronize with DUT
            vif.wait_for_clock();
            // set DUT response for the sequence
            vif.monitor( req );
        end
    endtask: run_phase

endclass: keccak_input_monitor
