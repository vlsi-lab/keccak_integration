///////////////////////////////////////////////////////////////
// Author: Petr Bardonek ibardonek@fit.vut.cz
// Language: SystemVerilog
// Description: The UVM test class
///////////////////////////////////////////////////////////////
class fve_test extends test_base;

    // registration of component tools
    `uvm_component_utils( fve_test )

    // creation of uvm_sequence_base
    uvm_sequence_base seq;

    // Constructor - creates new instance of this class
    function new( string name = "fve_test", uvm_component parent = null );
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
        $cast( seq, create_object("fve_sequence_reset", "reset") );
        seq.start( m_env_h.m_fve_agent_h.m_sequencer_h);

        // $cast( seq, create_object("keccak_program_sequence", "keccak_gen") );
        // seq.start( null );

        // starting random sequence
        $cast( seq, create_object("fve_sequence_rand", "rand") );
        seq.start( m_env_h.m_fve_agent_h.m_sequencer_h);

        // test is done, move to next phase
        phase.drop_objection( this );
    endtask: run_phase

endclass: fve_test
