///////////////////////////////////////////////////////////////
// Author: Petr Bardonek ibardonek@fit.vut.cz
// Language: SystemVerilog
// Description: Class receives transactions from the driver and performs 
//              transformation of these transactions into the form of expected 
//              responses according to the specification. Afterwards, it 
//              receives transactions from the monitor and automatically 
//              compares these real responses with the expected ones.
///////////////////////////////////////////////////////////////

// analysis implementations to support input from many places
`uvm_analysis_imp_decl( _dut )
`uvm_analysis_imp_decl( _gold )

`uvm_analysis_imp_decl( _dut_keccak )
`uvm_analysis_imp_decl( _gold_keccak )

class fve_scoreboard extends uvm_scoreboard;

    // registration of component tools
    `uvm_component_utils( fve_scoreboard )

    // analysis components
    uvm_analysis_imp_dut #(fve_transaction, fve_scoreboard) dut_analysis_export;
    uvm_analysis_imp_gold #(fve_transaction, fve_scoreboard) gold_analysis_export;
    // local queues to store all transactions
    local fve_transaction m_dut_fifo[$];
    local fve_transaction m_gold_fifo[$];
    // golden reference model handle also assigned by parent component
    fve_gm m_gold_h;

    // Analysis for passive agents
    uvm_analysis_imp_dut_keccak #(keccak_transaction, fve_scoreboard) dut_keccak_analysis_export;
    uvm_analysis_imp_gold_keccak #(keccak_transaction, fve_scoreboard) gold_keccak_analysis_export;
    // local queues to store all transactions
    local keccak_transaction m_dut_keccak_fifo[$];
    local keccak_transaction m_gold_keccak_fifo[$];

    // stores the final report message
    local string m_report_msg;
    // counts miscompares during run_phase and check_phase
    local int unsigned m_miscompares = 0;
    // counts all comparisons during run_phase and check_phase
    local int unsigned m_total = 0;

    // standard UVM interface

    // Constructor - creates new instance of this class
    function new( string name = "m_scoreboard_h", uvm_component parent = null );
        super.new( name, parent );
    endfunction: new

    // Build - instantiates child components
    function void build_phase( uvm_phase phase );
        super.build_phase( phase );
        dut_analysis_export = new( "dut_analysis_export", this );
        gold_analysis_export = new( "gold_analysis_export", this );

        dut_keccak_analysis_export = new( "dut_keccak_analysis_export", this );
        gold_keccak_analysis_export = new( "gold_keccak_analysis_export", this );
    endfunction: build_phase

    // Write - store all transactions from DUT ports
    function void write_dut( fve_transaction t );
        store_item_cnd( m_dut_fifo, t );
        compare_transaction();
    endfunction: write_dut

    function void write_dut_keccak( keccak_transaction t );
        if (t.keccak_intr == 1) begin
            store_item_cnd_keccak( m_dut_keccak_fifo, t );
            compare_transaction();
        end
    endfunction: write_dut_keccak

    // Write - store all transaction from golden reference model ports
    function void write_gold( fve_transaction t );
        store_item_cnd( m_gold_fifo, t );
        compare_transaction();
    endfunction: write_gold

    function void write_gold_keccak( keccak_transaction t );
        if (t.keccak_intr == 1) begin
            store_item_cnd_keccak( m_gold_keccak_fifo, t );
            compare_transaction();
        end
    endfunction: write_gold_keccak

    // comparison in every clock cycle
    function void compare_transaction();
        if (m_gold_keccak_fifo.size() && m_dut_keccak_fifo.size() ) begin
            keccak_transaction dut_keccak;
            keccak_transaction gold_keccak;
            dut_keccak = m_dut_keccak_fifo.pop_front();
            gold_keccak = m_gold_keccak_fifo.pop_front();
            if ( !gold_keccak.compare(dut_keccak) ) begin
               `uvm_error( "Comparison in SCOREBOARD:", $sformatf("Found miscompare for Keccak between GM and DUT:\n%s\n%s\n",   gold_keccak.sprint(), dut_keccak.sprint()) )
                m_miscompares += 1;
            end
            m_total += 1;
        end

        if ( m_gold_fifo.size() && m_dut_fifo.size() ) begin
            fve_transaction dut;
            fve_transaction gold;
            dut = m_dut_fifo.pop_front();
            gold = m_gold_fifo.pop_front();
            /*if ( !gold.compare(dut) ) begin
               `uvm_error( "Comparison in SCOREBOARD:", $sformatf("Found miscompare between GM and DUT:\n%s\n%s\n",   gold.sprint(), dut.sprint()) )
                m_miscompares += 1;
            end  */
            m_total += 1;
        end
    endfunction: compare_transaction

    // Store - store transaction into given queue if given transaction should be
    // compared with its opposite during the check phase.
    local function automatic void store_item_cnd( ref fve_transaction queue[$],
        fve_transaction t );
        queue.push_back( t );
    endfunction: store_item_cnd

    local function automatic void store_item_cnd_keccak( ref keccak_transaction queue[$],
        keccak_transaction t );
        queue.push_back( t );
    endfunction: store_item_cnd_keccak

    // Check - compare DUT and golden reference model
    function void check_phase( uvm_phase phase );
        if ( m_gold_fifo.size() != m_dut_fifo.size() ) begin
            `uvm_fatal( "check:", $sformatf("Different number of output transactions: DUT=%0d, gold=%0d.",
                m_dut_fifo.size(),
                m_gold_fifo.size()) )
        end
    endfunction: check_phase

    // Report - generate final report (success/failure)
    function void report_phase( uvm_phase phase );
        `uvm_info( "FINAL STATUS", $sformatf("The result for fve VERIFICATION is %0s, %0d/%0d miscompares!",
            (m_miscompares == 0 ? "OK" : "FAIL"),
            m_miscompares,
            m_total),
            UVM_LOW )
    endfunction: report_phase

endclass: fve_scoreboard
