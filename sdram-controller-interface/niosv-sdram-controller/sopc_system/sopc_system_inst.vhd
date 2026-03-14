	component sopc_system is
		port (
			clk_clk           : in    std_logic                     := 'X';             -- clk
			reset_reset_n     : in    std_logic                     := 'X';             -- reset_n
			dram_addr_output  : out   std_logic_vector(12 downto 0);                    -- output
			dram_ba_output    : out   std_logic_vector(1 downto 0);                     -- output
			dram_cas_n_output : out   std_logic;                                        -- output
			dram_cke_output   : out   std_logic;                                        -- output
			dram_cs_n_output  : out   std_logic;                                        -- output
			dram_dq_output    : inout std_logic_vector(15 downto 0) := (others => 'X'); -- output
			dram_ldqm_output  : out   std_logic;                                        -- output
			dram_udqm_output  : out   std_logic;                                        -- output
			dram_we_n_output  : out   std_logic;                                        -- output
			dram_ras_n_output : out   std_logic;                                        -- output
			sdram_clk_clk     : out   std_logic                                         -- clk
		);
	end component sopc_system;

	u0 : component sopc_system
		port map (
			clk_clk           => CONNECTED_TO_clk_clk,           --        clk.clk
			reset_reset_n     => CONNECTED_TO_reset_reset_n,     --      reset.reset_n
			dram_addr_output  => CONNECTED_TO_dram_addr_output,  --  dram_addr.output
			dram_ba_output    => CONNECTED_TO_dram_ba_output,    --    dram_ba.output
			dram_cas_n_output => CONNECTED_TO_dram_cas_n_output, -- dram_cas_n.output
			dram_cke_output   => CONNECTED_TO_dram_cke_output,   --   dram_cke.output
			dram_cs_n_output  => CONNECTED_TO_dram_cs_n_output,  --  dram_cs_n.output
			dram_dq_output    => CONNECTED_TO_dram_dq_output,    --    dram_dq.output
			dram_ldqm_output  => CONNECTED_TO_dram_ldqm_output,  --  dram_ldqm.output
			dram_udqm_output  => CONNECTED_TO_dram_udqm_output,  --  dram_udqm.output
			dram_we_n_output  => CONNECTED_TO_dram_we_n_output,  --  dram_we_n.output
			dram_ras_n_output => CONNECTED_TO_dram_ras_n_output, -- dram_ras_n.output
			sdram_clk_clk     => CONNECTED_TO_sdram_clk_clk      --  sdram_clk.clk
		);

