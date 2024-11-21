///////////////////////////////////////////////////////////////
// Author: Petr Bardonek ibardonek@fit.vut.cz
// Language: SystemVerilog
// Description: This class measures exercised combinations of signals of memory subsystem.
///////////////////////////////////////////////////////////////
class mem_coverage extends uvm_subscriber #(mem_transaction);

    // registration of component tools
    `uvm_component_utils( mem_coverage )

    // member attributes
    // holds current values of interface pins
    local T m_transaction_h;

    // Covergroup definition
    covergroup FunctionalCoverage( string inst );
    endgroup

    // Constructor - creates new instance of this class
    function new( string name = "m_coverage_h", uvm_component parent = null );
        super.new( name, parent );
        FunctionalCoverage = new( "mem" );
    endfunction: new

    // Build - instantiates child components
    function void build_phase( uvm_phase phase );
        super.build_phase( phase );
    endfunction: build_phase

    // Write - obligatory function, samples value on the interface.
    function void write( T t );
        // skip invalid transactions
        m_transaction_h = t;
        FunctionalCoverage.sample();
    endfunction: write

endclass: mem_coverage
