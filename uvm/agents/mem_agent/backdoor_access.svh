///////////////////////////////////////////////////////////////
// Author: Petr Bardonek ibardonek@fit.vut.cz
// Language: SystemVerilog
// Description: This class implement memory backdoor access to 
//              directly load/store from/to memory
///////////////////////////////////////////////////////////////
class backdoor_access extends uvm_object;

    // registration of component tools
    `uvm_object_utils( backdoor_access )

    string path_subsystem_mem = "top.dut.keccak_x_heep_top_i.x_heep_system_i.core_v_mini_mcu_i.memory_subsystem_i";
    string path_to_sram = ".ram_i.tc_ram_i.sram";

    // testbench_set_exit_loop signal in soc_ctrl
    // forced by simulation for preloading, do not touch
    // It seems it has something to do with preload of the program 
    string path_to_soc_ctrl = "top.dut.keccak_x_heep_top_i.x_heep_system_i.core_v_mini_mcu_i.ao_peripheral_subsystem_i.soc_ctrl_i.testbench_set_exit_loop[0]";

    function new( string name = "backdoor_access" );
        super.new( name );
    endfunction: new

    function void end_preload();
        if ( uvm_hdl_deposit(path_to_soc_ctrl, 1'b1) == 0 ) begin
            `uvm_error("MEM",$sformatf("Failed to end preload of the memory by setting %s",path_to_soc_ctrl))
        end
        `uvm_info("TESTBENCH", $sformatf("memory loaded"), UVM_HIGH)
    endfunction

    function void write_mem(int addr, logic [31:0] value);
        int bank = addr / MEM_BANK_SIZE_W;
        int addr_in_bank = addr % MEM_BANK_SIZE_W;
        // /tb_top/testharness_i/keccak_x_heep_top_i/x_heep_system_i/core_v_mini_mcu_i/memory_subsystem_i/gen_sram[0]/ram_i/tc_ram_i/sram
        // /top/dut/keccak_x_heep_top_i/x_heep_system_i/core_v_mini_mcu_i/memory_subsystem_i/gen_sram[0]/ram_i/tc_ram_i/sram
        // /top/dut/keccak_x_heep_top_i/x_heep_system_i/core_v_mini_mcu_i/memory_subsystem_i/gen_sram[0]/ram_i/tc_ram_i/sram
        // keccak_x_heep_top_i.x_heep_system_i.core_v_mini_mcu_i.memory_subsystem_i.gen_sram[0].ram_i.tc_ram_i.sram[addr]
        string full_path;

        full_path = $sformatf("%s.gen_sram[%0d]%s[%0d]", path_subsystem_mem, bank, path_to_sram, addr_in_bank);
        if ( uvm_hdl_deposit(full_path, value) == 0 ) begin
            `uvm_error("MEM",$sformatf("Failed to store value to memory at address 'h%0h", addr))
        end
    endfunction

    function logic [31:0] read_mem(int addr);
        int bank = addr / MEM_BANK_SIZE_W;
        int addr_in_bank = addr % MEM_BANK_SIZE_W;
        string full_path;
        logic [31:0] value;

        full_path = $sformatf("%s.gen_sram[%0d]%s[%0d]", path_subsystem_mem, bank, path_to_sram, addr_in_bank);
        if (uvm_hdl_read(full_path, value) == 0) begin
            `uvm_error("MEM",$sformatf("Failed to read memory at address 'h%0h", addr))
        end
        return value;
    endfunction

    function void init_mem_from_hex(string hex_file);
        //whether to use debug to write to memories
        logic [7:0] stimuli[MEM_SIZE];
        logic [31:0] addr;
        int stimuli_counter;

        $readmemh(hex_file, stimuli); // load the program4

        stimuli_counter = 0;

        for ( int addr = 0; addr < MEM_SIZE; addr = addr+4 ) begin
            write_mem(addr / 4, {stimuli[addr+3], stimuli[addr+2], stimuli[addr+1], stimuli[addr]});
        end
    endfunction

    function void wait_c();
    endfunction

    function void wait_sv();
    endfunction
endclass: backdoor_access