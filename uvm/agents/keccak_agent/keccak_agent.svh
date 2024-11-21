///////////////////////////////////////////////////////////////
// Author: Petr Bardonek ibardonek@fit.vut.cz
// Language: SystemVerilog
// Description: Represents agent class, passive agent for monitoring of the Keccak component.
///////////////////////////////////////////////////////////////
class keccak_agent extends uvm_agent;

    // registration of component tools
    `uvm_component_utils( keccak_agent )

    // analysis port for outside components to access transactions from the monitor
    uvm_analysis_port #(keccak_transaction) analysis_port_monitor;

    // component keccakbers for passive mode
    keccak_monitor m_monitor_h;
    keccak_input_monitor m_input_monitor_h;
    keccak_coverage m_coverage_h;
    keccak_gm m_gold_h;

    // Constructor - creates new instance of this class
    function new( string name = "m_agent_h", uvm_component parent = null );
        super.new( name, parent );
    endfunction: new

    // Build - instantiates child components
    function void build_phase( uvm_phase phase );
        super.build_phase( phase );
        m_monitor_h = keccak_monitor::type_id::create( "m_monitor_h", this );
        m_input_monitor_h = keccak_input_monitor::type_id::create( "m_input_monitor_h", this );
        m_coverage_h = keccak_coverage::type_id::create( "m_coverage_h", this );
        m_gold_h = keccak_gm::type_id::create( "m_gold_h", this );
    endfunction: build_phase

    // Connect - create interconnection between child components
    function void connect_phase( uvm_phase phase );
        virtual keccak_itf vif;
        super.connect_phase( phase );

        if ( !uvm_config_db #(virtual keccak_itf)::get(null,
            "uvm_test_top",
            "keccak_if",
            vif) ) begin
            `uvm_fatal( "configuration:", "Cannot find 'keccak_if' inside uvm_config_db, probably not set!" )
        end

        // connect monitor and assign interface
        analysis_port_monitor = m_monitor_h.analysis_port;
        m_monitor_h.vif = vif;
        m_input_monitor_h.vif = vif;

        // connect monitor with coverage subscriber
        m_monitor_h.analysis_port.connect( m_coverage_h.analysis_export );
        // connect monitor with keccak reference model
        m_input_monitor_h.analysis_port.connect( m_gold_h.analysis_export);
    endfunction: connect_phase

endclass: keccak_agent
