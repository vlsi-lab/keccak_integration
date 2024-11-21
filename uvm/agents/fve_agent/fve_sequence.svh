///////////////////////////////////////////////////////////////
// Author: Petr Bardonek ibardonek@fit.vut.cz
// Language: SystemVerilog
// Description: This class represents UVM sequence base for DUT/DUV.
///////////////////////////////////////////////////////////////
class fve_sequence extends uvm_sequence #(fve_transaction);

    // registration of object tools
    `uvm_object_utils( fve_sequence )

    // local shortcut to transaction type
    typedef REQ seq_item_t;
    // member attributes, equivalent with interface ports, only inputs
    // Input signals
    rand logic default_rst_ni;
    rand logic default_boot_select_i;
    rand logic default_execute_from_flash_i;
    rand logic default_jtag_tck_i;
    rand logic default_jtag_tms_i;
    rand logic default_jtag_trst_ni;
    rand logic default_jtag_tdi_i;
    rand logic default_jtag_tdo_o;
    rand logic default_uart_rx_i;
    rand logic default_uart_tx_o;
    rand logic [31:0] default_gpio_io;
    rand logic [3:0] default_spi_flash_sd_io;
    rand logic [1:0] default_spi_flash_csb;
    rand logic default_spi_flash_sck;
    rand logic [3:0] default_spi_sd_io;
    rand logic [1:0] default_spi_csb;
    rand logic default_spi_sck;
    rand logic [EXT_DOMAINS_RND-1:0]  default_external_subsystem_powergate_switch_ack_i;
    rand logic default_exit_valid_o;

    // handler for backdoor access
    backdoor_access bd_access;

    // the only item handle that is reused for all transactions
    seq_item_t item;

    // Constructor - creates new instance of this class
    function new( string name = "fve_sequence" );
        super.new( name );
        // create item using the factory
        item = seq_item_t::type_id::create( "item" );

        if ( !uvm_config_db #(backdoor_access)::get(null,
            "uvm_test_top",
            "bd_access",
            bd_access) ) begin
            `uvm_fatal( "configuration:", "Cannot find 'bd_access' inside uvm_config_db, probably not set!" )
        end
    endfunction: new

    // create_and_finish_item - create single item, set default values and finish it
    protected task automatic create_and_finish_item();
        // blocks until the sequencer grants the sequence access to the driver
        start_item( item );
        // prepare item to be used (assign default data)
        item.rst_ni = default_rst_ni;
        item.boot_select_i = default_boot_select_i;
        item.execute_from_flash_i = default_execute_from_flash_i;
        item.jtag_tck_i = default_jtag_tck_i;
        item.jtag_tms_i = default_jtag_tms_i;
        item.jtag_trst_ni = default_jtag_trst_ni;
        item.jtag_tdi_i = default_jtag_tdi_i;
        item.jtag_tdo_o = default_jtag_tdo_o;
        item.uart_rx_i = default_uart_rx_i;
        item.uart_tx_o = default_uart_tx_o;
        item.gpio_io = default_gpio_io;
        item.spi_flash_sd_io = default_spi_flash_sd_io;
        item.spi_flash_csb = default_spi_flash_csb;
        item.spi_flash_sck = default_spi_flash_sck;
        item.spi_sd_io = default_spi_sd_io;
        item.spi_csb = default_spi_csb;
        item.spi_sck = default_spi_sck;
        item.external_subsystem_powergate_switch_ack_i = default_external_subsystem_powergate_switch_ack_i;
        item.exit_valid_o = default_exit_valid_o;
        // block until the driver has completed its side of the transfer protocol
        finish_item( item );
    endtask: create_and_finish_item

endclass: fve_sequence

// This class represents UVM sequence reseting the DUT/DUV.
class fve_sequence_reset extends fve_sequence;

    // registration of object tools
    `uvm_object_utils( fve_sequence_reset )

    // Constructor - creates new instance of this class
    function new( string name = "fve_sequence_reset" );
        super.new( name );
    endfunction: new

    // body - implements behavior of the reset sequence (unidirectional)
    task body();
        // set reset values, randomize() cannot be used here
        default_rst_ni = RST_ACT_LEVEL;
        // wait a few cycles
        repeat (RESET_WAIT_CYCLES+1) begin
            create_and_finish_item();
        end

        `uvm_info("SEQ", $sformatf("reset deasserted at %t",$time), UVM_HIGH)

        default_rst_ni = ~RST_ACT_LEVEL;
        repeat (RESET_WAIT_CYCLES) begin
            create_and_finish_item();
        end

        bd_access.init_mem_from_hex(firmware);
        bd_access.end_preload();
        create_and_finish_item();
    endtask: body

endclass: fve_sequence_reset


class fve_sequence_rand extends fve_sequence;

    // registration of object tools
    `uvm_object_utils( fve_sequence_rand )

    // constraint const_RST
    // {
    //     default_rst_n dist{
    //         RST_ACT_LEVEL := 5,
    //         ~RST_ACT_LEVEL := 95
    //     };
    // }

    // Constructor - creates new instance of this class
    function new( string name = "fve_sequence_rand" );
        super.new( name );
    endfunction: new

    // body - implements behavior of the reset sequence (unidirectional)
    task body();
        // set reset values, randomize() cannot be used here
        default_rst_ni = ~RST_ACT_LEVEL;

        repeat ( transaction_count ) begin
            create_and_finish_item();
        end

    endtask: body

endclass: fve_sequence_rand
