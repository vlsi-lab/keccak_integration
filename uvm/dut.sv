///////////////////////////////////////////////////////////////
// Author: Petr Bardonek ibardonek@fit.vut.cz
// Language: SystemVerilog
// Description: Module declaration
///////////////////////////////////////////////////////////////
module DUT( input logic CLK );
    import uvm_pkg::*;
    import test_parameters_pkg::*;

    // Design related packages
    import obi_pkg::*;
    import reg_pkg::*;
    import keccak_x_heep_pkg::*;
    import addr_map_rule_pkg::*;

    // Instantiate DUT interface
    fve_itf fve_if( CLK );

    bind top.dut.keccak_x_heep_top_i.x_heep_system_i.core_v_mini_mcu_i.memory_subsystem_i mem_itf mem_if(
        .clk_i(clk_i),
        .rst_ni(rst_ni),
        .clk_gate_en_i(clk_gate_en_i),
        .ram_req_i(ram_req_i),
        .ram_resp_o(ram_resp_o),
        .set_retentive_i(set_retentive_i)
    );

    bind top.dut.keccak_x_heep_top_i.keccak_top_i.i_keccak keccak_itf keccak_if(
        .clk(clk),
        .rst_n(rst_n),
        .start(start),
        .din(din),
        .dout(dout),
        .status_d(status_d),
        .status_de(status_de),
        .keccak_intr(keccak_intr)
    );

    localparam SWITCH_ACK_LATENCY = 15;
    localparam EXT_XBAR_NMASTER_RND = USE_EXTERNAL_DEVICE_EXAMPLE ? keccak_x_heep_pkg::EXT_XBAR_NMASTER : 1;
    localparam HEEP_EXT_XBAR_NMASTER = USE_EXTERNAL_DEVICE_EXAMPLE ? keccak_x_heep_pkg::EXT_XBAR_NMASTER : 0;

    localparam int unsigned LOG_EXT_XBAR_NSLAVE = EXT_XBAR_NSLAVE > 32'd1 ? $clog2( EXT_XBAR_NSLAVE ) : 32'd1;

    localparam EXT_DOMAINS_RND = core_v_mini_mcu_pkg::EXTERNAL_DOMAINS == 0 ? 1 : core_v_mini_mcu_pkg::EXTERNAL_DOMAINS;
    localparam NEXT_INT_RND = core_v_mini_mcu_pkg::NEXT_INT == 0 ? 1 : core_v_mini_mcu_pkg::NEXT_INT;
  
 
    wire uart_rx;
    wire uart_tx;
    logic sim_jtag_enable = (JTAG_DPI == 1);
    wire sim_jtag_tck;
    wire sim_jtag_tms;
    wire sim_jtag_trst;
    wire sim_jtag_tdi;
    wire sim_jtag_tdo;
    wire sim_jtag_trstn;
    wire [31:0] gpio;

    logic [EXT_PERIPHERALS_PORT_SEL_WIDTH-1:0] ext_periph_select;

    // External subsystems
    logic [core_v_mini_mcu_pkg::EXTERNAL_DOMAINS-1:0] external_subsystem_powergate_switch;
    logic [core_v_mini_mcu_pkg::EXTERNAL_DOMAINS-1:0] external_subsystem_powergate_switch_ack;
    logic [core_v_mini_mcu_pkg::EXTERNAL_DOMAINS-1:0] external_subsystem_powergate_iso;  
    logic [EXT_DOMAINS_RND-1:0] external_subsystem_rst_n;
    logic [EXT_DOMAINS_RND-1:0] external_ram_banks_set_retentive;

    // wire for inout connections
    wire boot_sel_w;
    wire execute_from_flash_w;
    wire rst_ni_w;
    wire exit_valid_o_w; 

    assign boot_sel_w = boot_sel;
    assign execute_from_flash_w = execute_from_flash;
    assign rst_ni_w = fve_if.rst_ni;
    assign fve_if.exit_valid_o = exit_valid_o_w;

    // HDL DUT
    keccak_x_heep_top #(
        .COREV_PULP(COREV_PULP),
        .FPU(FPU),
        .ZFINX(ZFINX)
    ) keccak_x_heep_top_i (
        .clk_i(CLK),
        .rst_ni(rst_ni_w),

        .boot_select_i(boot_sel_w),
        .execute_from_flash_i(execute_from_flash_w),

        .jtag_tck_i  (sim_jtag_tck),
        .jtag_tms_i  (sim_jtag_tms),
        .jtag_trst_ni(sim_jtag_trstn),
        .jtag_tdi_i  (sim_jtag_tdi),
        .jtag_tdo_o  (sim_jtag_tdo),

        .gpio_io(gpio),

        .uart_rx_i(uart_rx),
        .uart_tx_o(uart_tx),

        .external_subsystem_powergate_switch_o(external_subsystem_powergate_switch),
        .external_subsystem_powergate_switch_ack_i(external_subsystem_powergate_switch_ack),
        .external_subsystem_powergate_iso_o(external_subsystem_powergate_iso),
        .external_subsystem_rst_no(external_subsystem_rst_n),
        .external_ram_banks_set_retentive_o(external_ram_banks_set_retentive),

        .exit_value_o(fve_if.exit_value_o),
        .exit_valid_o(exit_valid_o_w)
    );

    //pretending to be SWITCH CELLs that delay by SWITCH_ACK_LATENCY cycles the ACK signal
    logic tb_cpu_subsystem_powergate_switch_ack[SWITCH_ACK_LATENCY+1];
    logic tb_peripheral_subsystem_powergate_switch_ack[SWITCH_ACK_LATENCY+1];
    logic [core_v_mini_mcu_pkg::NUM_BANKS-1:0] tb_memory_subsystem_banks_powergate_switch_ack[SWITCH_ACK_LATENCY+1];
    logic [core_v_mini_mcu_pkg::EXTERNAL_DOMAINS-1:0] tb_external_subsystem_powergate_switch_ack[SWITCH_ACK_LATENCY+1];
    logic delayed_tb_cpu_subsystem_powergate_switch_ack;
    logic delayed_tb_peripheral_subsystem_powergate_switch_ack;
    logic [core_v_mini_mcu_pkg::NUM_BANKS-1:0] delayed_tb_memory_subsystem_banks_powergate_switch_ack;
    logic [core_v_mini_mcu_pkg::EXTERNAL_DOMAINS-1:0] delayed_tb_external_subsystem_powergate_switch_ack;

    always_ff @(negedge CLK) begin
        tb_cpu_subsystem_powergate_switch_ack[0] <= keccak_x_heep_top_i.x_heep_system_i.cpu_subsystem_powergate_switch;
        tb_peripheral_subsystem_powergate_switch_ack[0] <= keccak_x_heep_top_i.x_heep_system_i.peripheral_subsystem_powergate_switch;
        tb_memory_subsystem_banks_powergate_switch_ack[0] <= keccak_x_heep_top_i.x_heep_system_i.memory_subsystem_banks_powergate_switch;
        tb_external_subsystem_powergate_switch_ack[0] <= external_subsystem_powergate_switch;
        for (int i = 0; i < SWITCH_ACK_LATENCY; i++) begin
            tb_memory_subsystem_banks_powergate_switch_ack[i+1] <= tb_memory_subsystem_banks_powergate_switch_ack[i];
            tb_cpu_subsystem_powergate_switch_ack[i+1] <= tb_cpu_subsystem_powergate_switch_ack[i];
            tb_peripheral_subsystem_powergate_switch_ack[i+1] <= tb_peripheral_subsystem_powergate_switch_ack[i];
            tb_external_subsystem_powergate_switch_ack[i+1] <= tb_external_subsystem_powergate_switch_ack[i];
        end
    end

    assign delayed_tb_cpu_subsystem_powergate_switch_ack = tb_cpu_subsystem_powergate_switch_ack[SWITCH_ACK_LATENCY];
    assign delayed_tb_peripheral_subsystem_powergate_switch_ack = tb_peripheral_subsystem_powergate_switch_ack[SWITCH_ACK_LATENCY];
    assign delayed_tb_memory_subsystem_banks_powergate_switch_ack = tb_memory_subsystem_banks_powergate_switch_ack[SWITCH_ACK_LATENCY];
    assign delayed_tb_external_subsystem_powergate_switch_ack = tb_external_subsystem_powergate_switch_ack[SWITCH_ACK_LATENCY];

    always_comb begin
        force keccak_x_heep_top_i.x_heep_system_i.core_v_mini_mcu_i.cpu_subsystem_powergate_switch_ack_i = delayed_tb_cpu_subsystem_powergate_switch_ack;
        force keccak_x_heep_top_i.x_heep_system_i.core_v_mini_mcu_i.peripheral_subsystem_powergate_switch_ack_i = delayed_tb_peripheral_subsystem_powergate_switch_ack;
        force keccak_x_heep_top_i.x_heep_system_i.core_v_mini_mcu_i.memory_subsystem_banks_powergate_switch_ack_i = delayed_tb_memory_subsystem_banks_powergate_switch_ack;
        force external_subsystem_powergate_switch_ack = delayed_tb_external_subsystem_powergate_switch_ack;
    end

    uartdpi #(
        .BAUD('d256000),
        .FREQ(CLK_FREQUENCY_KHz * 1000),  //Hz
        .NAME("uart0")
    ) i_uart0 (
        .clk_i(CLK),
        .rst_ni(fve_if.rst_ni),
        .tx_o(uart_rx),
        .rx_i(uart_tx)
    );

    // jtag calls from dpi
    SimJTAG #(
        .TICK_DELAY(1),
        .PORT      (4567)
    ) i_sim_jtag (
        .clock(CLK),
        .reset(~fve_if.rst_ni),
        .enable(sim_jtag_enable),
        .init_done(rst_ni),
        .jtag_TCK(sim_jtag_tck),
        .jtag_TMS(sim_jtag_tms),
        .jtag_TDI(sim_jtag_tdi),
        .jtag_TRSTn(sim_jtag_trstn),
        .jtag_TDO_data(sim_jtag_tdo),
        .jtag_TDO_driven(1'b1),
        .exit()
    );
 
    initial begin
        // set interface to uvm config database
        // Black box interface
        uvm_config_db #(virtual fve_itf)::set( null, "uvm_test_top", "fve_if", fve_if);

        // White box interfaces
        uvm_config_db #(virtual mem_itf)::set( null, "uvm_test_top", "mem_if", top.dut.keccak_x_heep_top_i.x_heep_system_i.core_v_mini_mcu_i.memory_subsystem_i.mem_if);

        uvm_config_db #(virtual keccak_itf)::set( null, "uvm_test_top", "keccak_if", top.dut.keccak_x_heep_top_i.keccak_top_i.i_keccak.keccak_if);
    end
endmodule: DUT