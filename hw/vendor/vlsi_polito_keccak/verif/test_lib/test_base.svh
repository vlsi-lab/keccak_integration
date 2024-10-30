///////////////////////////////////////////////////////////////
// Author: Petr Bardonek ibardonek@fit.vut.cz
// Language: SystemVerilog
// Description: The base UVM test class
///////////////////////////////////////////////////////////////
class keccak_test_base extends uvm_test;

    // registration of component tools
    `uvm_component_utils( keccak_test_base )

    // member attribute with the verification environment
    keccak_env m_keccak_env_h;
    // same handler as the one above, just different name
    keccak_env m_env_h;

    // Constructor - creates new instance of this class
    function new( string name = "keccak_test_base", uvm_component parent = null );
        super.new( name, parent );
    endfunction: new

    // Build - instantiates child components
    function void build_phase( uvm_phase phase );
        super.build_phase( phase );
        m_keccak_env_h = keccak_env::type_id::create( "m_keccak_env_h", this );
        m_env_h = m_keccak_env_h;
    endfunction: build_phase

endclass: keccak_test_base
