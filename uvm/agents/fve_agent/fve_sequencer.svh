///////////////////////////////////////////////////////////////
// Author: Petr Bardonek ibardonek@fit.vut.cz
// Language: SystemVerilog
// Description: This class manages random inputs for DUT and sends them to driver.
///////////////////////////////////////////////////////////////
class fve_sequencer extends uvm_sequencer #(fve_transaction);

    // registration of component tools
    `uvm_component_utils( fve_sequencer )

    // Constructor - creates new instance of this class
    function new( string name = "m_sequencer_h", uvm_component parent = null );
        super.new( name, parent );
    endfunction: new

endclass: fve_sequencer
