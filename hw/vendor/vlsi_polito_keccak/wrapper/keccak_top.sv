//
// keccak_top: keccak accelerator top-level. 
// Designed by Alessandra Dolmeta, Mattia Mirigaldi
// alessandra.dolmeta@polito.it, mattiamirigaldi.98017@gmail.com
//

module keccak_top 
  import keccak_data_reg_pkg::*;
  import keccak_ctrl_reg_pkg::*;
  import reg_pkg::*;
  import obi_pkg::*;  
(
	input logic clk_i,
	input logic rst_ni,
	// AHB Slave interface (data memory)
	input 	    obi_req_t slave_req_i,
	output 	    obi_resp_t slave_resp_o,
        // APB interface (ctrl mem)
	input 	    reg_req_t reg_req_i,
        output 	    reg_rsp_t reg_rsp_o,
  
	output 	    keccak_intr_o
);

   reg_req_t periph_req_i;   
   reg_rsp_t periph_rsp_o;
   
   keccak_data_reg2hw_t reg_file_to_ip_data;
   keccak_data_hw2reg_t ip_to_reg_file_data;   
   keccak_ctrl_reg2hw_t reg_file_to_ip_ctrl;
   keccak_ctrl_hw2reg_t ip_to_reg_file_ctrl;

	
   periph_to_reg #(
      .req_t(reg_pkg::reg_req_t),
      .rsp_t(reg_pkg::reg_rsp_t),
      .IW(1)
   ) periph_to_reg_i (
      .clk_i,
      .rst_ni,
      .req_i(slave_req_i.req),
      .add_i(slave_req_i.addr),
      .wen_i(~slave_req_i.we),
      .wdata_i(slave_req_i.wdata),
      .be_i(slave_req_i.be),
      .id_i('0),
      .gnt_o(slave_resp_o.gnt),
      .r_rdata_o(slave_resp_o.rdata),
      .r_opc_o(),
      .r_id_o(),
      .r_valid_o(slave_resp_o.rvalid),
      .reg_req_o(periph_req_i),
      .reg_rsp_i(periph_rsp_o)
   );


   keccak_data_reg_top #(
	.reg_req_t(reg_req_t),
	.reg_rsp_t(reg_rsp_t)
	) i_data_regfile (
		.clk_i,
		.rst_ni,
		.devmode_i(1'b1),
		// From the bus to regfile
		.reg_req_i(periph_req_i),
		.reg_rsp_o(periph_rsp_o),
		
		// Signals from regfile to keccak IP
		.reg2hw(reg_file_to_ip_data),
		.hw2reg(ip_to_reg_file_data) 
	);

   keccak_ctrl_reg_top #(
	.reg_req_t(reg_req_t),
	.reg_rsp_t(reg_rsp_t)
	) i_ctrl_regfile (
		.clk_i,
		.rst_ni,
		.devmode_i(1'b1),
		// From the bus to regfile
		.reg_req_i(reg_req_i),
		.reg_rsp_o(reg_rsp_o),
		
		// Signals from regfile to keccak IP
		.reg2hw(reg_file_to_ip_ctrl),
		.hw2reg(ip_to_reg_file_ctrl) 
	);


     
   // wiring signals between control unit and ip
   wire logic [1599:0] din_keccak, dout_keccak;
   assign din_keccak = reg_file_to_ip_data;
			       			        	
	keccak i_keccak (
		.clk(clk_i),
		.rst_n(rst_ni),
		.start(reg_file_to_ip_ctrl),
		.din(din_keccak),
		.dout(dout_keccak),
		.status_d(ip_to_reg_file_ctrl.status.d),
		.status_de(ip_to_reg_file_ctrl.status.de),
		.keccak_intr(keccak_intr_o)
	);

  assign ip_to_reg_file_data = dout_keccak;
   
  
endmodule : keccak_top
