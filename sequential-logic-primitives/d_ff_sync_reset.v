// one bit flip flip with active low synchronous reset
module d_ff_sync_reset(
	input clk,
	input d,
	input reset,
	output reg q
);

// capture input d on rising edge of clock, update q on falling edge
always @ (posedge clk) begin
	if(!reset) begin // active low reset
		q <= 1'b0;
	end
	else begin
		q <= d;
	end
end
	
endmodule
