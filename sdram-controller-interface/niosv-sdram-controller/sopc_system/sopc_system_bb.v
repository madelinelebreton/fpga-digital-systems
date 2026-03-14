
module sopc_system (
	clk_clk,
	reset_reset_n,
	dram_addr_output,
	dram_ba_output,
	dram_cas_n_output,
	dram_cke_output,
	dram_cs_n_output,
	dram_dq_output,
	dram_ldqm_output,
	dram_udqm_output,
	dram_we_n_output,
	dram_ras_n_output,
	sdram_clk_clk);	

	input		clk_clk;
	input		reset_reset_n;
	output	[12:0]	dram_addr_output;
	output	[1:0]	dram_ba_output;
	output		dram_cas_n_output;
	output		dram_cke_output;
	output		dram_cs_n_output;
	inout	[15:0]	dram_dq_output;
	output		dram_ldqm_output;
	output		dram_udqm_output;
	output		dram_we_n_output;
	output		dram_ras_n_output;
	output		sdram_clk_clk;
endmodule
