///////////////////////////////////////////////////////////////
// Author: Petr Bardonek ibardonek@fit.vut.cz
// Language: SystemVerilog
// Description: This class represents transaction which contains values of DUT's interface signals.
///////////////////////////////////////////////////////////////
class fve_transaction extends uvm_sequence_item;

    // registration of object tools
    `uvm_object_utils( fve_transaction )

    // Member attributes, equivalent with interface pins
    // Input signals
    rand logic rst_ni;
    rand logic boot_select_i;
    rand logic execute_from_flash_i;
    rand logic jtag_tck_i;
    rand logic jtag_tms_i;
    rand logic jtag_trst_ni;
    rand logic jtag_tdi_i;
    rand logic jtag_tdo_o;
    rand logic uart_rx_i;
    rand logic uart_tx_o;
    rand logic [31:0] gpio_io;
    rand logic [3:0] spi_flash_sd_io;
    rand logic [1:0] spi_flash_csb;
    rand logic spi_flash_sck;
    rand logic [3:0] spi_sd_io;
    rand logic [1:0] spi_csb;
    rand logic spi_sck;
    rand logic [EXT_DOMAINS_RND-1:0] external_subsystem_powergate_switch_ack_i;
    rand logic exit_valid_o;
    // Output signals
    logic [EXT_DOMAINS_RND-1:0] external_subsystem_powergate_switch_o;
    logic [EXT_DOMAINS_RND-1:0] external_subsystem_powergate_iso_o;
    logic [EXT_DOMAINS_RND-1:0] external_subsystem_rst_no;
    logic [EXT_DOMAINS_RND-1:0] external_ram_banks_set_retentive_o;
    logic [31:0] exit_value_o;


    // Constructor - creates new instance of this class
    function new( string name = "fve_transaction" );
        super.new( name );
    endfunction: new

    // common UVM functions

    // Properly copy all transaction attributes.
    function void do_copy( uvm_object rhs );
        fve_transaction rhs_;

        if( !$cast(rhs_, rhs) ) begin
            `uvm_fatal( "do_copy:", "Failed to cast transaction object." )
            return;
        end
        // now copy all attributes
        super.do_copy( rhs );
        rst_ni = rhs_.rst_ni;
        boot_select_i = rhs_.boot_select_i;
        execute_from_flash_i = rhs_.execute_from_flash_i;
        jtag_tck_i = rhs_.jtag_tck_i;
        jtag_tms_i = rhs_.jtag_tms_i;
        jtag_trst_ni = rhs_.jtag_trst_ni;
        jtag_tdi_i = rhs_.jtag_tdi_i;
        jtag_tdo_o = rhs_.jtag_tdo_o;
        uart_rx_i = rhs_.uart_rx_i;
        uart_tx_o = rhs_.uart_tx_o;
        gpio_io = rhs_.gpio_io;
        spi_flash_sd_io = rhs_.spi_flash_sd_io;
        spi_flash_csb = rhs_.spi_flash_csb;
        spi_flash_sck = rhs_.spi_flash_sck;
        spi_sd_io = rhs_.spi_sd_io;
        spi_csb = rhs_.spi_csb;
        spi_sck = rhs_.spi_sck;
        external_subsystem_powergate_switch_o = rhs_.external_subsystem_powergate_switch_o;
        external_subsystem_powergate_switch_ack_i = rhs_.external_subsystem_powergate_switch_ack_i;
        external_subsystem_powergate_iso_o = rhs_.external_subsystem_powergate_iso_o;
        external_subsystem_rst_no = rhs_.external_subsystem_rst_no;
        external_ram_banks_set_retentive_o = rhs_.external_ram_banks_set_retentive_o;
        exit_value_o = rhs_.exit_value_o;
        exit_valid_o = rhs_.exit_valid_o;
    endfunction: do_copy

    // Properly compare all transaction attributes representing output pins.
    function bit do_compare( uvm_object rhs, uvm_comparer comparer );
        fve_transaction rhs_;

        if( !$cast(rhs_, rhs) ) begin
            `uvm_error( "do_compare:", "Failed to cast transaction object." )
            return 0;
        end

        // using simple equivalence operator (faster)
        return ( super.do_compare(rhs, comparer) &&
            (rst_ni == rhs_.rst_ni) &&
            (boot_select_i == rhs_.boot_select_i) &&
            (execute_from_flash_i == rhs_.execute_from_flash_i) &&
            (jtag_tck_i == rhs_.jtag_tck_i) &&
            (jtag_tms_i == rhs_.jtag_tms_i) &&
            (jtag_trst_ni == rhs_.jtag_trst_ni) &&
            (jtag_tdi_i == rhs_.jtag_tdi_i) &&
            (jtag_tdo_o == rhs_.jtag_tdo_o) &&
            (uart_rx_i == rhs_.uart_rx_i) &&
            (uart_tx_o == rhs_.uart_tx_o) &&
            (gpio_io == rhs_.gpio_io) &&
            (spi_flash_sd_io == rhs_.spi_flash_sd_io) &&
            (spi_flash_csb == rhs_.spi_flash_csb) &&
            (spi_flash_sck == rhs_.spi_flash_sck) &&
            (spi_sd_io == rhs_.spi_sd_io) &&
            (spi_csb == rhs_.spi_csb) &&
            (spi_sck == rhs_.spi_sck) &&
            (external_subsystem_powergate_switch_o == rhs_.external_subsystem_powergate_switch_o) &&
            (external_subsystem_powergate_iso_o == rhs_.external_subsystem_powergate_iso_o) &&
            (external_subsystem_rst_no == rhs_.external_subsystem_rst_no) &&
            (external_ram_banks_set_retentive_o == rhs_.external_ram_banks_set_retentive_o) &&
            (exit_value_o == rhs_.exit_value_o) &&
            (exit_valid_o == rhs_.exit_valid_o) );
    endfunction: do_compare

    // Convert transaction into human readable form.
    function string convert2string();
        string s;
        s = $sformatf( "%s \
            \n\trst_ni: 'h%0h \
            \n\tboot_select_i: 'h%0h \
            \n\texecute_from_flash_i: 'h%0h \
            \n\tjtag_tck_i: 'h%0h \
            \n\tjtag_tms_i: 'h%0h \
            \n\tjtag_trst_ni: 'h%0h \
            \n\tjtag_tdi_i: 'h%0h \
            \n\tjtag_tdo_o: 'h%0h \
            \n\tuart_rx_i: 'h%0h \
            \n\tuart_tx_o: 'h%0h \
            \n\tgpio_io: 'h%0h \
            \n\tspi_flash_sd_io: 'h%0h \
            \n\tspi_flash_csb: 'h%0h \
            \n\tspi_flash_sck: 'h%0h \
            \n\tspi_sd_io: 'h%0h \
            \n\tspi_csb: 'h%0h \
            \n\tspi_sck: 'h%0h \
            \n\texternal_subsystem_powergate_switch_o: 'h%0h \
            \n\texternal_subsystem_powergate_switch_ack_i: 'h%0h \
            \n\texternal_subsystem_powergate_iso_o: 'h%0h \
            \n\texternal_subsystem_rst_no: 'h%0h \
            \n\texternal_ram_banks_set_retentive_o: 'h%0h \
            \n\texit_value_o: 'h%0h \
            \n\texit_valid_o: 'h%0h",
            super.convert2string(),
            rst_ni,
            boot_select_i,
            execute_from_flash_i,
            jtag_tck_i,
            jtag_tms_i,
            jtag_trst_ni,
            jtag_tdi_i,
            jtag_tdo_o,
            uart_rx_i,
            uart_tx_o,
            gpio_io,
            spi_flash_sd_io,
            spi_flash_csb,
            spi_flash_sck,
            spi_sd_io,
            spi_csb,
            spi_sck,
            external_subsystem_powergate_switch_o,
            external_subsystem_powergate_switch_ack_i,
            external_subsystem_powergate_iso_o,
            external_subsystem_rst_no,
            external_ram_banks_set_retentive_o,
            exit_value_o,
            exit_valid_o
            );
        return s;
    endfunction: convert2string

    // Customize what gets printed or sprinted, use the uvm_printer policy classes.
    function void do_print( uvm_printer printer );
        super.do_print( printer );
        if ( printer != null ) begin
            printer.print_int( "rst_ni", rst_ni, $bits(rst_ni) );
            printer.print_int( "boot_select_i", boot_select_i, $bits(boot_select_i) );
            printer.print_int( "execute_from_flash_i", execute_from_flash_i, $bits(execute_from_flash_i) );
            printer.print_int( "jtag_tck_i", jtag_tck_i, $bits(jtag_tck_i) );
            printer.print_int( "jtag_tms_i", jtag_tms_i, $bits(jtag_tms_i) );
            printer.print_int( "jtag_trst_ni", jtag_trst_ni, $bits(jtag_trst_ni) );
            printer.print_int( "jtag_tdi_i", jtag_tdi_i, $bits(jtag_tdi_i) );
            printer.print_int( "jtag_tdo_o", jtag_tdo_o, $bits(jtag_tdo_o) );
            printer.print_int( "uart_rx_i", uart_rx_i, $bits(uart_rx_i) );
            printer.print_int( "uart_tx_o", uart_tx_o, $bits(uart_tx_o) );
            printer.print_int( "gpio_io", gpio_io, $bits(gpio_io) );
            printer.print_int( "spi_flash_sd_io", spi_flash_sd_io, $bits(spi_flash_sd_io) );
            printer.print_int( "spi_flash_csb", spi_flash_csb, $bits(spi_flash_csb) );
            printer.print_int( "spi_flash_sck", spi_flash_sck, $bits(spi_flash_sck) );
            printer.print_int( "spi_sd_io", spi_sd_io, $bits(spi_sd_io) );
            printer.print_int( "spi_csb", spi_csb, $bits(spi_csb) );
            printer.print_int( "spi_sck", spi_sck, $bits(spi_sck) );
            printer.print_int( "external_subsystem_powergate_switch_o", external_subsystem_powergate_switch_o, $bits(external_subsystem_powergate_switch_o) );
            printer.print_int( "external_subsystem_powergate_switch_ack_i", external_subsystem_powergate_switch_ack_i, $bits(external_subsystem_powergate_switch_ack_i) );
            printer.print_int( "external_subsystem_powergate_iso_o", external_subsystem_powergate_iso_o, $bits(external_subsystem_powergate_iso_o) );
            printer.print_int( "external_subsystem_rst_no", external_subsystem_rst_no, $bits(external_subsystem_rst_no) );
            printer.print_int( "external_ram_banks_set_retentive_o", external_ram_banks_set_retentive_o, $bits(external_ram_banks_set_retentive_o) );
            printer.print_int( "exit_value_o", exit_value_o, $bits(exit_value_o) );
            printer.print_int( "exit_valid_o", exit_valid_o, $bits(exit_valid_o) );
        end
    endfunction: do_print

    // Support the viewing of data objects as transactions in a waveform GUI.
    function void do_record( uvm_recorder recorder );
        super.do_record( recorder );
        `uvm_record_field( "rst_ni", rst_ni )
        `uvm_record_field( "boot_select_i", boot_select_i )
        `uvm_record_field( "execute_from_flash_i", execute_from_flash_i )
        `uvm_record_field( "jtag_tck_i", jtag_tck_i )
        `uvm_record_field( "jtag_tms_i", jtag_tms_i )
        `uvm_record_field( "jtag_trst_ni", jtag_trst_ni )
        `uvm_record_field( "jtag_tdi_i", jtag_tdi_i )
        `uvm_record_field( "jtag_tdo_o", jtag_tdo_o )
        `uvm_record_field( "uart_rx_i", uart_rx_i )
        `uvm_record_field( "uart_tx_o", uart_tx_o )
        `uvm_record_field( "gpio_io", gpio_io )
        `uvm_record_field( "spi_flash_sd_io", spi_flash_sd_io )
        `uvm_record_field( "spi_flash_csb", spi_flash_csb )
        `uvm_record_field( "spi_flash_sck", spi_flash_sck )
        `uvm_record_field( "spi_sd_io", spi_sd_io )
        `uvm_record_field( "spi_csb", spi_csb )
        `uvm_record_field( "spi_sck", spi_sck )
        `uvm_record_field( "external_subsystem_powergate_switch_o", external_subsystem_powergate_switch_o )
        `uvm_record_field( "external_subsystem_powergate_switch_ack_i", external_subsystem_powergate_switch_ack_i )
        `uvm_record_field( "external_subsystem_powergate_iso_o", external_subsystem_powergate_iso_o )
        `uvm_record_field( "external_subsystem_rst_no", external_subsystem_rst_no )
        `uvm_record_field( "external_ram_banks_set_retentive_o", external_ram_banks_set_retentive_o )
        `uvm_record_field( "exit_value_o", exit_value_o )
        `uvm_record_field( "exit_valid_o", exit_valid_o )
    endfunction: do_record

endclass: fve_transaction
