// one bit flip flop with active low synchronous reset and active low enable
module d_ff_sync_reset_enable(
	input clk,
	input d,
	input reset,
	input enable,
	output reg q
);

always @ (posedge clk) begin
	if (!reset) begin// active low reset
		q <= 1'b0;
	end
	
	else if (!enable) begin// active low enable
		q <= d;
	end
		
end

endmodule
