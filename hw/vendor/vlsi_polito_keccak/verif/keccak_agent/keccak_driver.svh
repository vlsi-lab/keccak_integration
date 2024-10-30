///////////////////////////////////////////////////////////////
// Author: Petr Bardonek ibardonek@fit.vut.cz
// Language: SystemVerilog
// Description: Definition of the driver class 'keccak_driver' used for communication with agents input interface.
///////////////////////////////////////////////////////////////
class keccak_driver extends uvm_driver #(keccak_transaction);

    // registration of component tools
    `uvm_component_utils( keccak_driver )

    // reference to the interface wrapper, initialized during the connect phase by parent agent
    virtual i_keccak_itf vif;

    uvm_analysis_port #(keccak_transaction) analysis_port;

    // Constructor - creates new instance of this class
    function new( string name = "m_driver_h", uvm_component parent = null );
        super.new( name, parent );
    endfunction: new

    // Build - instantiates child components
    function void build_phase( uvm_phase phase );
        super.build_phase( phase );
        analysis_port = new( "analysis_port", this );
    endfunction: build_phase

    // Run - starts the processing in driver (bidirectional)
    task run_phase( uvm_phase phase );
        // synchronize with DUT
        vif.wait_for_clock();
        forever begin
            // get next available sequence item
            seq_item_port.get_next_item( req );
            // drive ports
            vif.drive( req );
            // send transaction to GM
            analysis_port.write( req );
            // synchronize with DUT
            vif.wait_for_clock();
            // set DUT response for the sequence
            vif.monitor( req );
            // received sequence has been consumed
            seq_item_port.item_done();
        end
    endtask: run_phase

endclass: keccak_driver
