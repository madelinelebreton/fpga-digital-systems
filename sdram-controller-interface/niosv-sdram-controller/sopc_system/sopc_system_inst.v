	sopc_system u0 (
		.clk_clk           (<connected-to-clk_clk>),           //        clk.clk
		.reset_reset_n     (<connected-to-reset_reset_n>),     //      reset.reset_n
		.dram_addr_output  (<connected-to-dram_addr_output>),  //  dram_addr.output
		.dram_ba_output    (<connected-to-dram_ba_output>),    //    dram_ba.output
		.dram_cas_n_output (<connected-to-dram_cas_n_output>), // dram_cas_n.output
		.dram_cke_output   (<connected-to-dram_cke_output>),   //   dram_cke.output
		.dram_cs_n_output  (<connected-to-dram_cs_n_output>),  //  dram_cs_n.output
		.dram_dq_output    (<connected-to-dram_dq_output>),    //    dram_dq.output
		.dram_ldqm_output  (<connected-to-dram_ldqm_output>),  //  dram_ldqm.output
		.dram_udqm_output  (<connected-to-dram_udqm_output>),  //  dram_udqm.output
		.dram_we_n_output  (<connected-to-dram_we_n_output>),  //  dram_we_n.output
		.dram_ras_n_output (<connected-to-dram_ras_n_output>), // dram_ras_n.output
		.sdram_clk_clk     (<connected-to-sdram_clk_clk>)      //  sdram_clk.clk
	);

