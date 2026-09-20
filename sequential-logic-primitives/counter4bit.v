// 4-bit counter with reset and enable control
module counter4bit(
	input clk,
	input enable,
	input reset,
	output reg [3:0] count
);

always @ (posedge clk) begin
	if(!reset) begin// active low
		count <= 4'b0000;
	end
	else if (!enable) begin // active low
		count <= count + 1'b1;
	end
end

endmodule