///////////////////////////////////////////////////////////////
// Author: Petr Bardonek ibardonek@fit.vut.cz
// Language: SystemVerilog
// Description: Definition of interface for connection between
//              UVM verification environment and DUT interface pins.
///////////////////////////////////////////////////////////////
interface fve_itf
    // import agent package for transaction and wrapper base classes
    import uvm_pkg::*;
    import test_parameters_pkg::*;
    import fve_agent_pkg::*;
    (
        input logic CLK
    );

    logic rst_ni;
    logic boot_select_i;
    logic execute_from_flash_i;
    logic jtag_tck_i;
    logic jtag_tms_i;
    logic jtag_trst_ni;
    logic jtag_tdi_i;
    logic jtag_tdo_o;
    logic uart_rx_i;
    logic uart_tx_o;
    logic [31:0] gpio_io;
    logic [3:0] spi_flash_sd_io;
    logic [1:0] spi_flash_csb;
    logic spi_flash_sck;
    logic [3:0] spi_sd_io;
    logic [1:0] spi_csb;
    logic spi_sck;
    logic [EXT_DOMAINS_RND-1:0] external_subsystem_powergate_switch_o;
    logic [EXT_DOMAINS_RND-1:0] external_subsystem_powergate_switch_ack_i;
    logic [EXT_DOMAINS_RND-1:0] external_subsystem_powergate_iso_o;
    logic [EXT_DOMAINS_RND-1:0] external_subsystem_rst_no;
    logic [EXT_DOMAINS_RND-1:0] external_ram_banks_set_retentive_o;
    logic [31:0] exit_value_o;
    logic exit_valid_o;

    // Clocking blocks
    // testbench point of view
    clocking cb_out @( posedge CLK );
        output rst_ni, boot_select_i, execute_from_flash_i, jtag_tck_i, 
        jtag_tms_i, jtag_trst_ni, jtag_tdi_i, jtag_tdo_o, uart_rx_i, 
        uart_tx_o, gpio_io, spi_flash_sd_io, spi_flash_csb, spi_flash_sck, 
        spi_sd_io, spi_csb, spi_sck, external_subsystem_powergate_switch_ack_i, 
        exit_valid_o;
    endclocking: cb_out

    clocking cb_in @( posedge CLK );
        input rst_ni, boot_select_i, execute_from_flash_i, jtag_tck_i, 
        jtag_tms_i, jtag_trst_ni, jtag_tdi_i, jtag_tdo_o, uart_rx_i, 
        uart_tx_o, gpio_io, spi_flash_sd_io, spi_flash_csb, spi_flash_sck, 
        spi_sd_io, spi_csb, spi_sck, external_subsystem_powergate_switch_o, 
        external_subsystem_powergate_iso_o, external_subsystem_rst_no, 
        external_ram_banks_set_retentive_o, exit_value_o, exit_valid_o;
    endclocking: cb_in

    // Monitor point of view
    clocking cbm @( posedge CLK );
        input rst_ni, boot_select_i, execute_from_flash_i, jtag_tck_i, 
        jtag_tms_i, jtag_trst_ni, jtag_tdi_i, jtag_tdo_o, uart_rx_i, 
        uart_tx_o, gpio_io, spi_flash_sd_io, spi_flash_csb, spi_flash_sck, 
        spi_sd_io, spi_csb, spi_sck, external_subsystem_powergate_switch_o, 
        external_subsystem_powergate_switch_ack_i, 
        external_subsystem_powergate_iso_o, external_subsystem_rst_no, 
        external_ram_banks_set_retentive_o, exit_value_o, exit_valid_o;
    endclocking: cbm

    // drive - drive input and inout pins
    task automatic drive( fve_transaction t );
        cb_out.rst_ni <= t.rst_ni;
        cb_out.boot_select_i <= t.boot_select_i;
        cb_out.execute_from_flash_i <= t.execute_from_flash_i;
        cb_out.jtag_tck_i <= t.jtag_tck_i;
        cb_out.jtag_tms_i <= t.jtag_tms_i;
        cb_out.jtag_trst_ni <= t.jtag_trst_ni;
        cb_out.jtag_tdi_i <= t.jtag_tdi_i;
        cb_out.jtag_tdo_o <= t.jtag_tdo_o;
        cb_out.uart_rx_i <= t.uart_rx_i;
        cb_out.uart_tx_o <= t.uart_tx_o;
        cb_out.gpio_io <= t.gpio_io;
        cb_out.spi_flash_sd_io <= t.spi_flash_sd_io;
        cb_out.spi_flash_csb <= t.spi_flash_csb;
        cb_out.spi_flash_sck <= t.spi_flash_sck;
        cb_out.spi_sd_io <= t.spi_sd_io;
        cb_out.spi_csb <= t.spi_csb;
        cb_out.spi_sck <= t.spi_sck;
        cb_out.external_subsystem_powergate_switch_ack_i <= t.external_subsystem_powergate_switch_ack_i;
        cb_out.exit_valid_o <= t.exit_valid_o;
    endtask: drive

    // monitor - read values on all interface pins using monitor clocking blocks
    task automatic monitor( fve_transaction t );
        t.rst_ni = cbm.rst_ni;
        t.boot_select_i = cbm.boot_select_i;
        t.execute_from_flash_i = cbm.execute_from_flash_i;
        t.jtag_tck_i = cbm.jtag_tck_i;
        t.jtag_tms_i = cbm.jtag_tms_i;
        t.jtag_trst_ni = cbm.jtag_trst_ni;
        t.jtag_tdi_i = cbm.jtag_tdi_i;
        t.jtag_tdo_o = cbm.jtag_tdo_o;
        t.uart_rx_i = cbm.uart_rx_i;
        t.uart_tx_o = cbm.uart_tx_o;
        t.gpio_io = cbm.gpio_io;
        t.spi_flash_sd_io = cbm.spi_flash_sd_io;
        t.spi_flash_csb = cbm.spi_flash_csb;
        t.spi_flash_sck = cbm.spi_flash_sck;
        t.spi_sd_io = cbm.spi_sd_io;
        t.spi_csb = cbm.spi_csb;
        t.spi_sck = cbm.spi_sck;
        t.external_subsystem_powergate_switch_o = cbm.external_subsystem_powergate_switch_o;
        t.external_subsystem_powergate_switch_ack_i = cbm.external_subsystem_powergate_switch_ack_i;
        t.external_subsystem_powergate_iso_o = cbm.external_subsystem_powergate_iso_o;
        t.external_subsystem_rst_no = cbm.external_subsystem_rst_no;
        t.external_ram_banks_set_retentive_o = cbm.external_ram_banks_set_retentive_o;
        t.exit_value_o = cbm.exit_value_o;
        t.exit_valid_o = cbm.exit_valid_o;
    endtask: monitor

    // monitor - read values on all interface pins asynchronously (no clocking blocks)
    task automatic input_monitor( fve_transaction t );
        t.rst_ni = rst_ni;
        t.boot_select_i = boot_select_i;
        t.execute_from_flash_i = execute_from_flash_i;
        t.jtag_tck_i = jtag_tck_i;
        t.jtag_tms_i = jtag_tms_i;
        t.jtag_trst_ni = jtag_trst_ni;
        t.jtag_tdi_i = jtag_tdi_i;
        t.jtag_tdo_o = jtag_tdo_o;
        t.uart_rx_i = uart_rx_i;
        t.uart_tx_o = uart_tx_o;
        t.gpio_io = gpio_io;
        t.spi_flash_sd_io = spi_flash_sd_io;
        t.spi_flash_csb = spi_flash_csb;
        t.spi_flash_sck = spi_flash_sck;
        t.spi_sd_io = spi_sd_io;
        t.spi_csb = spi_csb;
        t.spi_sck = spi_sck;
        t.external_subsystem_powergate_switch_o = external_subsystem_powergate_switch_o;
        t.external_subsystem_powergate_switch_ack_i = external_subsystem_powergate_switch_ack_i;
        t.external_subsystem_powergate_iso_o = external_subsystem_powergate_iso_o;
        t.external_subsystem_rst_no = external_subsystem_rst_no;
        t.external_ram_banks_set_retentive_o = external_ram_banks_set_retentive_o;
        t.exit_value_o = exit_value_o;
        t.exit_valid_o = exit_valid_o;
    endtask: input_monitor

    // wait for n clock cycles
    task automatic wait_for_clock( int n = 1 );
        repeat ( n ) begin
            @( cbm );
        end
    endtask: wait_for_clock

    // wait for reset to finish
    task automatic wait_for_reset_inactive();
        @( posedge rst_ni );
    endtask: wait_for_reset_inactive

endinterface: fve_itf