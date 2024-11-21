///////////////////////////////////////////////////////////////
// Author: Petr Bardonek ibardonek@fit.vut.cz
// Language: SystemVerilog
// Description: Class representing and creating the main parts
//              of the verification environment.
///////////////////////////////////////////////////////////////
class fve_env extends uvm_env;

    // registration of component tools
    `uvm_component_utils( fve_env )

    // main sub-components
    // main agent in the environment
    fve_agent m_fve_agent_h;
    fve_scoreboard m_scoreboard_h;
    fve_gm m_gold_h;

    // Passive monitoring agents
    mem_agent m_mem_agent_h;
    keccak_agent m_keccak_agent_h;

    // Constructor - creates new instance of this class
    function new( string name = "m_env_h", uvm_component parent = null );
        super.new( name, parent );
    endfunction: new

    // Build - instantiates child components
    function void build_phase( uvm_phase phase );
        super.build_phase( phase );
        m_fve_agent_h = fve_agent::type_id::create( "m_fve_agent_h", this );
        m_scoreboard_h = fve_scoreboard::type_id::create( "m_scoreboard_h", this );
        m_gold_h = fve_gm::type_id::create( "m_gold_h", this );

        m_mem_agent_h = mem_agent::type_id::create( "m_mem_agent_h", this );
        m_keccak_agent_h = keccak_agent::type_id::create( "m_keccak_agent_h", this );
    endfunction: build_phase

    // Connect - create interconnection between child components
    function void connect_phase( uvm_phase phase );
        super.connect_phase( phase );
        // agent monitor => scoreboard (DUT outputs)
        m_fve_agent_h.analysis_port_monitor.connect( m_scoreboard_h.dut_analysis_export );
        // agent driver => golden reference model (DUT inputs)
        m_fve_agent_h.analysis_port_driver.connect( m_gold_h.analysis_export );
        // golden reference model => scoreboard (GM outputs)
        m_gold_h.fve_analysis_port.connect( m_scoreboard_h.gold_analysis_export );
        // now initialize scoreboard attributes
        m_scoreboard_h.m_gold_h = m_gold_h;

        // keccak monitor => scoreboard (Keccak outputs)
        m_keccak_agent_h.analysis_port_monitor.connect( m_scoreboard_h.dut_keccak_analysis_export );
        // keccak reference model => scoreboard (Keccak GM outputs)
        m_keccak_agent_h.m_gold_h.keccak_analysis_port.connect( m_scoreboard_h.gold_keccak_analysis_export );
    endfunction: connect_phase

endclass: fve_env
