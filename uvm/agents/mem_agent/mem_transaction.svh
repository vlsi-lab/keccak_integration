///////////////////////////////////////////////////////////////
// Author: Petr Bardonek ibardonek@fit.vut.cz
// Language: SystemVerilog
// Description: This class represents transaction which contains values of memory subsystem's interface signals.
///////////////////////////////////////////////////////////////
class mem_transaction extends uvm_sequence_item;

    // registration of object tools
    `uvm_object_utils( mem_transaction )

    // Member attributes, equivalent with interface pins
    // Input signals
    rand logic rst_ni;
    rand logic [N_MEM_BANKS-1:0] clk_gate_en_i; // Clock-gating signal
    rand obi_req_t [N_MEM_BANKS-1:0] ram_req_i;
    rand logic [N_MEM_BANKS-1:0] set_retentive_i;
    // Output signals
    obi_resp_t [N_MEM_BANKS-1:0] ram_resp_o;

    // Constructor - creates new instance of this class
    function new( string name = "mem_transaction" );
        super.new( name );
    endfunction: new

    // common UVM functions

    // Properly copy all transaction attributes.
    function void do_copy( uvm_object rhs );
        mem_transaction rhs_;

        if( !$cast(rhs_, rhs) ) begin
            `uvm_fatal( "do_copy:", "Failed to cast transaction object." )
            return;
        end
        // now copy all attributes
        super.do_copy( rhs );
        rst_ni = rhs_.rst_ni;
        clk_gate_en_i = rhs_.clk_gate_en_i;
        ram_req_i = rhs_.ram_req_i;
        set_retentive_i = rhs_.set_retentive_i;
        ram_resp_o = rhs_.ram_resp_o;
    endfunction: do_copy

    // Properly compare all transaction attributes representing output pins.
    function bit do_compare( uvm_object rhs, uvm_comparer comparer );
        mem_transaction rhs_;

        if( !$cast(rhs_, rhs) ) begin
            `uvm_error( "do_compare:", "Failed to cast transaction object." )
            return 0;
        end

        // using simple equivalence operator (faster)
        return ( super.do_compare(rhs, comparer) &&
            ( ram_resp_o == rhs_.ram_resp_o) );
    endfunction: do_compare

    // Convert transaction into human readable form.
    function string convert2string();
        string s;
        s = $sformatf( "%s \
            \n\trst_ni: 'h%0h \
            \n\tclk_gate_en_i: 'h%0h \
            \n\tram_req_i: 'h%0h \
            \n\tset_retentive_i: 'h%0h \
            \n\tram_resp_o: 'h%0h",
            super.convert2string(),
            rst_ni,
            clk_gate_en_i,
            ram_req_i,
            set_retentive_i,
            ram_resp_o
            );
        return s;
    endfunction: convert2string

    // Customize what gets printed or sprinted, use the uvm_printer policy classes.
    function void do_print( uvm_printer printer );
        super.do_print( printer );
        if ( printer != null ) begin
            printer.print_int( "rst_ni", rst_ni, $bits(rst_ni) );
            printer.print_int( "clk_gate_en_i", clk_gate_en_i, $bits(clk_gate_en_i) );
            printer.print_int( "ram_req_i", ram_req_i, $bits(ram_req_i) );
            printer.print_int( "set_retentive_i", set_retentive_i, $bits(set_retentive_i) );
            printer.print_int( "ram_resp_o", ram_resp_o, $bits(ram_resp_o) );
        end
    endfunction: do_print

    // Support the viewing of data objects as transactions in a waveform GUI.
    function void do_record( uvm_recorder recorder );
        super.do_record( recorder );
        `uvm_record_field( "rst_ni", rst_ni )
        `uvm_record_field( "clk_gate_en_i", clk_gate_en_i )
        `uvm_record_field( "ram_req_i", ram_req_i )
        `uvm_record_field( "set_retentive_i", set_retentive_i )
        `uvm_record_field( "ram_resp_o", ram_resp_o )
    endfunction: do_record

endclass: mem_transaction
