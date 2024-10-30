///////////////////////////////////////////////////////////////
// Author: Petr Bardonek ibardonek@fit.vut.cz
// Language: SystemVerilog
// Description: This class is used to monitor interface pins of the DUT/DUV.
///////////////////////////////////////////////////////////////
class keccak_monitor extends uvm_monitor;

    // registration of component tools
    `uvm_component_utils( keccak_monitor )

    // reference to DUT interface wrapper, initialized during the connect phase by parent agent
    virtual i_keccak_itf vif;
    // used to send transactions to all connected components
    uvm_analysis_port #(keccak_transaction) analysis_port;
    // base name prefix for created transactions
    string m_name = "dut";

    // Constructor - creates new instance of this class
    function new( string name = "m_monitor_h", uvm_component parent = null );
        super.new( name, parent );
    endfunction: new

    // Build - instantiates child components
    function void build_phase( uvm_phase phase );
        super.build_phase( phase );
        analysis_port = new( "analysis_port", this );
    endfunction: build_phase

    // Run - starts the processing in monitor
    task run_phase( uvm_phase phase );
        keccak_transaction dut;
        // start processing after clock becomes active
        vif.wait_for_clock();
        // monitor interface every clock cycle
        forever begin
            dut = keccak_transaction::type_id::create(
                $sformatf("%0s: %0t", m_name, $time) );
            // synchronize with the DUT
            vif.wait_for_clock();
            // receive interface pin values
            vif.monitor( dut );
            // display the content of the transaction
            // dut.print(); // for debugging
            // send it to the scoreboard, subscribers, ...
            analysis_port.write( dut );
        end
    endtask: run_phase

endclass: keccak_monitor
