///////////////////////////////////////////////////////////////
// Author: Petr Bardonek ibardonek@fit.vut.cz
// Language: SystemVerilog
// Description: Class representing and creating the main parts
//              of the verification environment.
///////////////////////////////////////////////////////////////
class keccak_env extends uvm_env;

    // registration of component tools
    `uvm_component_utils( keccak_env )

    // main top component
    keccak_agent m_keccak_agent_h;
    keccak_scoreboard m_scoreboard_h;
    keccak_gm m_gold_h;

    // Constructor - creates new instance of this class
    function new( string name = "m_env_h", uvm_component parent = null );
        super.new( name, parent );
    endfunction: new

    // Build - instantiates child components
    function void build_phase( uvm_phase phase );
        super.build_phase( phase );
        m_keccak_agent_h = keccak_agent::type_id::create( "m_keccak_agent_h", this );
        m_scoreboard_h = keccak_scoreboard::type_id::create( "m_scoreboard_h", this );
        m_gold_h = keccak_gm::type_id::create( "m_gold_h", this );
    endfunction: build_phase

    // Connect - create interconnection between child components
    function void connect_phase( uvm_phase phase );
        super.connect_phase( phase );
        // agent monitor => scoreboard (DUT outputs)
        m_keccak_agent_h.analysis_port_monitor.connect( m_scoreboard_h.dut_analysis_export );
        // agent driver => golden reference model (DUT inputs)
        m_keccak_agent_h.analysis_port_driver.connect( m_gold_h.analysis_export );
        // golden reference model => scoreboard (GM outputs)
        m_gold_h.keccak_analysis_port.connect( m_scoreboard_h.gold_analysis_export );
        // now initialize scoreboard attributes
        m_scoreboard_h.m_gold_h = m_gold_h;
    endfunction: connect_phase

endclass: keccak_env
