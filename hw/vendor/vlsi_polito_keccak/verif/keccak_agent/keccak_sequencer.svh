///////////////////////////////////////////////////////////////
// Author: Petr Bardonek ibardonek@fit.vut.cz
// Language: SystemVerilog
// Description: This class manages random inputs for DUT and sends them to driver.
///////////////////////////////////////////////////////////////
class keccak_sequencer extends uvm_sequencer #(keccak_transaction);

    // registration of component tools
    `uvm_component_utils( keccak_sequencer )

    // Constructor - creates new instance of this class
    function new( string name = "m_sequencer_h", uvm_component parent = null );
        super.new( name, parent );
    endfunction: new

endclass: keccak_sequencer
