///////////////////////////////////////////////////////////////
// Author: Petr Bardonek ibardonek@fit.vut.cz
// Language: SystemVerilog
// Description: The base UVM test class
///////////////////////////////////////////////////////////////
class keccak_test extends keccak_test_base;

    // registration of component tools
    `uvm_component_utils( keccak_test )

    // creation of uvm_sequence_base
    uvm_sequence_base seq;
    // Constructor - creates new instance of this class
    function new( string name = "keccak_test", uvm_component parent = null );
        super.new( name, parent );
    endfunction: new

    // Build - instantiates child components
    function void build_phase( uvm_phase phase );
        super.build_phase( phase );
    endfunction: build_phase

    // Run - start processing sequences
    task run_phase( uvm_phase phase );
        // prevent the phase from immediate termination
        phase.raise_objection( this );
        // test is done when all sequence items have been consumed

        // starting reset sequence
        $cast( seq, create_object("keccak_sequence_reset", "reset") );
        seq.start( m_env_h.m_keccak_agent_h.m_sequencer_h);

        // starting basic sequence
        $cast( seq, create_object("keccak_sequence_basic", "basic") );
        seq.start( m_env_h.m_keccak_agent_h.m_sequencer_h);

        // starting random sequence
        $cast( seq, create_object("keccak_seq_rand", "rand") );
        seq.start( m_env_h.m_keccak_agent_h.m_sequencer_h);

        // test is done, move to next phase
        phase.drop_objection( this );
    endtask: run_phase

endclass: keccak_test
