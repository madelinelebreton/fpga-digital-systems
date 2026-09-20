// 4-to-1 multiplexer
module mux_4(
	input [1:0] sel, // select from 2 bits (4 inputs)
	input [3:0] i, // 4 bit input
	output reg q
);

always @ (*) begin
	case(sel) 
		2'b00: q = i[0];
		2'b01: q = i[1];
		2'b10: q = i[2];
		2'b11: q = i[3];
		default: q = 1'b0;
	endcase 
end

endmodule
