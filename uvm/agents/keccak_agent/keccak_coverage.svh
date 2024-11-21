///////////////////////////////////////////////////////////////
// Author: Petr Bardonek ibardonek@fit.vut.cz
// Language: SystemVerilog
// Description: This class measures exercised combinations of signals of Keccak component.
///////////////////////////////////////////////////////////////
class keccak_coverage extends uvm_subscriber #(keccak_transaction);

    // registration of component tools
    `uvm_component_utils( keccak_coverage )

    // keccakber attributes
    // holds current values of interface pins
    local T m_transaction_h;

    // Covergroup definition
    covergroup FunctionalCoverage( string inst );

        cp_din: coverpoint m_transaction_h.din
        {
            bins zero = {ZERO};
            bins one = {ONE};
            bins max = {MAX};
            bins others = {[LOW:HIGH]};
        }

        cp_rst: coverpoint m_transaction_h.rst_n
        {
            bins rst = {RST_ACT_LEVEL};
            bins no_rst = {~RST_ACT_LEVEL};
            option.weight = 0;
        }

        cp_trans_rst: coverpoint m_transaction_h.rst_n
        {
            bins activate = (~RST_ACT_LEVEL => RST_ACT_LEVEL);
            bins deactivate = (RST_ACT_LEVEL => ~RST_ACT_LEVEL);
            bins stable_no_rst = (~RST_ACT_LEVEL => ~RST_ACT_LEVEL);
        }
        
        cp_start: coverpoint m_transaction_h.start
        {
            bins start = {START};
            bins no_start = {~START};
            option.weight = 0;
        }

        cp_trans_start_for_data: coverpoint m_transaction_h.start
        {
            bins stable = (~START => START => START);
            bins fall_edg = (~START => START => ~START);
        }

        cp_keccak_intr: coverpoint m_transaction_h.keccak_intr
        {
            bins zero = {0};
            bins one = {1};
            option.weight = 0;
        }

        cp_status_d: coverpoint m_transaction_h.status_d
        {
            bins zero = {0};
            bins one = {1};
            option.weight = 0;
        }

        cp_status_de: coverpoint m_transaction_h.status_de
        {
            bins zero = {0};
            bins one = {1};
            option.weight = 0;
        }

        cp_trans_keccak_intr: coverpoint m_transaction_h.keccak_intr
        {
            bins rise_edg = (0 => 1);
        }

        cp_dout: coverpoint m_transaction_h.dout
        {
            option.auto_bin_max = 16;
        }

        cr_start_rst_n: cross cp_rst, cp_start;

        cr_start_rst_n_keccak_intr: cross cp_rst, cp_start, cp_keccak_intr;

        cr_start_with_all: cross cp_trans_rst, cp_trans_start_for_data, cp_din
        {
            ignore_bins rst_with_start_or_data = !binsof(cp_trans_rst.stable_no_rst);
        }

        cr_permutation_done: cross cp_keccak_intr, cp_status_d, cp_status_de, cp_dout
        {
            ignore_bins not_finished = !binsof(cp_keccak_intr.zero) || !binsof(cp_status_d.zero) || !binsof(cp_status_de.zero);
        }

        // per instance statistics and options
        option.per_instance = 1;
        option.name = inst;
    endgroup

    // Constructor - creates new instance of this class
    function new( string name = "m_coverage_h", uvm_component parent = null );
        super.new( name, parent );
        FunctionalCoverage = new( "keccak" );
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

endclass: keccak_coverage
