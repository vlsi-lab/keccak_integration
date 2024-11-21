///////////////////////////////////////////////////////////////
// Author: Petr Bardonek ibardonek@fit.vut.cz
// Language: SystemVerilog
// Description: Represents the golden model of the processor used to predict results of the DUT.
///////////////////////////////////////////////////////////////
class fve_gm extends uvm_subscriber #(fve_transaction);

    // registration of component tools
    `uvm_component_utils( fve_gm )

    // analysis port for outside components to access transactions from the monitor
    uvm_analysis_port #(fve_transaction) fve_analysis_port;

    // static local variables accesible by waveform
    static logic rst_ni;
    static logic boot_select_i;
    static logic execute_from_flash_i;
    static logic jtag_tck_i;
    static logic jtag_tms_i;
    static logic jtag_trst_ni;
    static logic jtag_tdi_i;
    static logic jtag_tdo_o;
    static logic uart_rx_i;
    static logic uart_tx_o;
    static logic [31:0] gpio_io;
    static logic [3:0] spi_flash_sd_io;
    static logic [1:0] spi_flash_csb;
    static logic spi_flash_sck;
    static logic [3:0] spi_sd_io;
    static logic [1:0] spi_csb;
    static logic spi_sck;
    static logic [EXT_DOMAINS_RND-1:0] external_subsystem_powergate_switch_o;
    static logic [EXT_DOMAINS_RND-1:0] external_subsystem_powergate_iso_o;
    static logic [EXT_DOMAINS_RND-1:0] external_subsystem_rst_no;
    static logic [EXT_DOMAINS_RND-1:0] external_ram_banks_set_retentive_o;
    static logic [31:0] exit_value_o;
    static logic exit_valid_o;

    // auxiliar variables
    static fve_transaction gmOut;

    // base name prefix for created transactions
    string m_name = "gold";

    // Constructor - creates new instance of this class
    function new( string name = "m_fve_gm_h", uvm_component parent = null );
        super.new( name, parent );
    endfunction: new

    // Build - instantiates child components
    function void build_phase( uvm_phase phase );
        super.build_phase( phase );
        fve_analysis_port = new( "fve_analysis_port", this );
        gmOut = fve_transaction::type_id::create( $sformatf("%0s: %0t", "gmOut", $time) );

        gmOut.rst_ni = '0;
        gmOut.boot_select_i = '0;
        gmOut.execute_from_flash_i = '0;
        gmOut.jtag_tck_i = '0;
        gmOut.jtag_tms_i = '0;
        gmOut.jtag_trst_ni = '0;
        gmOut.jtag_tdi_i = '0;
        gmOut.jtag_tdo_o = '0;
        gmOut.uart_rx_i = '0;
        gmOut.uart_tx_o = '0;
        gmOut.gpio_io = '0;
        gmOut.spi_flash_sd_io = '0;
        gmOut.spi_flash_csb = '0;
        gmOut.spi_flash_sck = '0;
        gmOut.spi_sd_io = '0;
        gmOut.spi_csb = '0;
        gmOut.spi_sck = '0;
        gmOut.external_subsystem_powergate_switch_o = '0;
        gmOut.external_subsystem_powergate_iso_o = '0;
        gmOut.external_subsystem_rst_no = '0;
        gmOut.external_ram_banks_set_retentive_o = '0;
        gmOut.exit_value_o = '0;
        gmOut.exit_valid_o = '0;
    endfunction: build_phase

    // Connect - create interconnection between child components
    function void connect_phase( uvm_phase phase );
        super.connect_phase( phase );
    endfunction: connect_phase

    // Write - get all transactions from driver for computing predictions
    function void write( T t );
        fve_transaction out_t;

        out_t = fve_transaction::type_id::create(
        $sformatf("%0s: %0t", m_name, $time) );

        out_t.copy(t);

        // predict outputs
        predict( out_t );

        // support function for displaying data in wave
        wave_display_support_func(out_t);

        // send predicted outputs to scoreboard
        fve_analysis_port.write(out_t);
    endfunction: write

    // implements behavior of the golden model
    local function automatic void predict( fve_transaction t );
        t.rst_ni = gmOut.rst_ni;
        t.boot_select_i = gmOut.boot_select_i;
        t.execute_from_flash_i = gmOut.execute_from_flash_i;
        t.jtag_tck_i = gmOut.jtag_tck_i;
        t.jtag_tms_i = gmOut.jtag_tms_i;
        t.jtag_trst_ni = gmOut.jtag_trst_ni;
        t.jtag_tdi_i = gmOut.jtag_tdi_i;
        t.jtag_tdo_o = gmOut.jtag_tdo_o;
        t.uart_rx_i = gmOut.uart_rx_i;
        t.uart_tx_o = gmOut.uart_tx_o;
        t.gpio_io = gmOut.gpio_io;
        t.spi_flash_sd_io = gmOut.spi_flash_sd_io;
        t.spi_flash_csb = gmOut.spi_flash_csb;
        t.spi_flash_sck = gmOut.spi_flash_sck;
        t.spi_sd_io = gmOut.spi_sd_io;
        t.spi_csb = gmOut.spi_csb;
        t.spi_sck = gmOut.spi_sck;
        t.external_subsystem_powergate_switch_o = gmOut.external_subsystem_powergate_switch_o;
        t.external_subsystem_powergate_iso_o = gmOut.external_subsystem_powergate_iso_o;
        t.external_subsystem_rst_no = gmOut.external_subsystem_rst_no;
        t.external_ram_banks_set_retentive_o = gmOut.external_ram_banks_set_retentive_o;
        t.exit_value_o = gmOut.exit_value_o;
        t.exit_valid_o = gmOut.exit_valid_o;
    endfunction: predict

    local function void set_default_outputs( fve_transaction t );
        t.rst_ni = '0;
        t.boot_select_i = '0;
        t.execute_from_flash_i = '0;
        t.jtag_tck_i = '0;
        t.jtag_tms_i = '0;
        t.jtag_trst_ni = '0;
        t.jtag_tdi_i = '0;
        t.jtag_tdo_o = '0;
        t.uart_rx_i = '0;
        t.uart_tx_o = '0;
        t.gpio_io = '0;
        t.spi_flash_sd_io = '0;
        t.spi_flash_csb = '0;
        t.spi_flash_sck = '0;
        t.spi_sd_io = '0;
        t.spi_csb = '0;
        t.spi_sck = '0;
        t.external_subsystem_powergate_switch_o = '0;
        t.external_subsystem_powergate_iso_o = '0;
        t.external_subsystem_rst_no = '0;
        t.external_ram_banks_set_retentive_o = '0;
        t.exit_value_o = '0;
        t.exit_valid_o = '0;
    endfunction: set_default_outputs

    local function automatic void wave_display_support_func( fve_transaction t );
        rst_ni = t.rst_ni;
        boot_select_i = t.boot_select_i;
        execute_from_flash_i = t.execute_from_flash_i;
        jtag_tck_i = t.jtag_tck_i;
        jtag_tms_i = t.jtag_tms_i;
        jtag_trst_ni = t.jtag_trst_ni;
        jtag_tdi_i = t.jtag_tdi_i;
        jtag_tdo_o = t.jtag_tdo_o;
        uart_rx_i = t.uart_rx_i;
        uart_tx_o = t.uart_tx_o;
        gpio_io = t.gpio_io;
        spi_flash_sd_io = t.spi_flash_sd_io;
        spi_flash_csb = t.spi_flash_csb;
        spi_flash_sck = t.spi_flash_sck;
        spi_sd_io = t.spi_sd_io;
        spi_csb = t.spi_csb;
        spi_sck = t.spi_sck;
        external_subsystem_powergate_switch_o = t.external_subsystem_powergate_switch_o;
        external_subsystem_powergate_iso_o = t.external_subsystem_powergate_iso_o;
        external_subsystem_rst_no = t.external_subsystem_rst_no;
        external_ram_banks_set_retentive_o = t.external_ram_banks_set_retentive_o;
        exit_value_o = t.exit_value_o;
        exit_valid_o = t.exit_valid_o;
    endfunction: wave_display_support_func

endclass: fve_gm
