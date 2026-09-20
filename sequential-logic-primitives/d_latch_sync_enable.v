// d latch with active low sync enable control
module d_latch_sync_enable(
	input d,
	input enable,
	output reg q
);

always @ (enable or d) begin 
	if(!enable) begin // active low
		q <= d; 
	end
end

endmodule
