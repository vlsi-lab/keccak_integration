///////////////////////////////////////////////////////////////
// Author: Petr Bardonek ibardonek@fit.vut.cz
// Language: SystemVerilog
// Description: This class represents transaction which contains values of output signals for 'keccak'.
///////////////////////////////////////////////////////////////
class keccak_transaction extends uvm_sequence_item;

    // registration of object tools
    `uvm_object_utils( keccak_transaction )

    // Member attributes, equivalent with interface pins
    // make input attributes random, except for clocks
    rand logic rst_n;
    rand logic start;
    rand logic [1599:0] din;
    logic [1599:0] dout;
    logic status_d;
    logic status_de;
    logic keccak_intr;

    // Constructor - creates new instance of this class
    function new( string name = "keccak_transaction" );
        super.new( name );
    endfunction: new

    // Properly copy all transaction attributes.
    function void do_copy( uvm_object rhs );
        keccak_transaction rhs_;

        if( !$cast(rhs_, rhs) ) begin
            `uvm_fatal( "do_copy:", "Failed to cast transaction object." )
            return;
        end
        // now copy all attributes
        super.do_copy( rhs );
        rst_n = rhs_.rst_n;
        start = rhs_.start;
        din = rhs_.din;
        dout = rhs_.dout;
        status_d = rhs_.status_d;
        status_de = rhs_.status_de;
        keccak_intr = rhs_.keccak_intr;
    endfunction: do_copy

    // Properly compare all transaction attributes representing output pins.
    function bit do_compare( uvm_object rhs, uvm_comparer comparer );
        keccak_transaction rhs_;

        if( !$cast(rhs_, rhs) ) begin
            `uvm_error( "do_compare:", "Failed to cast transaction object." )
            return 0;
        end

        // using simple equivalence operator (faster)
        return ( super.do_compare(rhs, comparer) &&
            (dout == rhs_.dout) &&
            (status_d == rhs_.status_d) &&
            (status_de == rhs_.status_de) &&
            (keccak_intr == rhs_.keccak_intr) );
    endfunction: do_compare

    // Convert transaction into human readable form.
    function string convert2string();
        string s;
        s = $sformatf("%s \
            \n\trst_n: 'h%0h \
            \n\tstart: 'h%0h \
            \n\tdin: 'h%0h \
            \n\tdout: 'h%0h \
            \n\tstatus_d: 'h%0h \
            \n\tstatus_de: 'h%0h \
            \n\tkeccak_intr: 'h%0h",
            super.convert2string(),
            rst_n,
            start,
            din,
            dout,
            status_d,
            status_de,
            keccak_intr
        );
        return s;
    endfunction: convert2string

    // Customize what gets printed or sprinted, use the uvm_printer policy classes.
    function void do_print( uvm_printer printer );
        super.do_print( printer );
        if ( printer != null ) begin
            printer.print_int( "rst_n", rst_n, $bits(rst_n) );
            printer.print_int( "start", start, $bits(start) );
            printer.print_int( "din", din, $bits(din) );
            printer.print_int( "dout", dout, $bits(dout) );
            printer.print_int( "status_d", status_d, $bits(status_d) );
            printer.print_int( "status_de", status_de, $bits(status_de) );
            printer.print_int( "keccak_intr", keccak_intr, $bits(keccak_intr) );
        end else begin
            `uvm_info(get_type_name(), convert2string(), UVM_MEDIUM)
        end
    endfunction: do_print

    // Support the viewing of data objects as transactions in a waveform GUI.
    function void do_record( uvm_recorder recorder );
        super.do_record( recorder );
        `uvm_record_field( "rst_n", rst_n )
        `uvm_record_field( "start", start )
        `uvm_record_field( "din", din )
        `uvm_record_field( "dout", dout )
        `uvm_record_field( "status_d", status_d )
        `uvm_record_field( "status_de", status_de )
        `uvm_record_field( "keccak_intr", keccak_intr )
    endfunction: do_record

endclass: keccak_transaction
