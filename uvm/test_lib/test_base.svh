///////////////////////////////////////////////////////////////
// Author: Petr Bardonek ibardonek@fit.vut.cz
// Language: SystemVerilog
// Description: The base UVM test class
///////////////////////////////////////////////////////////////
class test_base extends uvm_test;

    // registration of component tools
    `uvm_component_utils( test_base )

    // member attribute with the verification environment
    fve_env m_fve_env_h;
    // same handler as the one above, just different name
    fve_env m_env_h;

    // Constructor - creates new instance of this class
    function new( string name = "test_base", uvm_component parent = null );
        super.new( name, parent );
    endfunction: new

    // Build - instantiates child components
    function void build_phase( uvm_phase phase );
        super.build_phase( phase );
        m_fve_env_h = fve_env::type_id::create( "m_fve_env_h", this );
        m_env_h = m_fve_env_h;
    endfunction: build_phase

endclass: test_base
