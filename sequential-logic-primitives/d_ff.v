// one data width flip flop
module d_ff(
	input clk,
	input d,
	output reg q
);

// capture output q on rising edge of clock
always @ (posedge clk) begin
	q <= d;
end

endmodule