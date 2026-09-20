// this module creates a a 3-to-1 multiplexer that selects between three 16-bit inputs

module mux3( 
	input [15:0] a, b, c, 
	input s0, s1,
	output reg [15:0] y); // data a, b, c, select bits s0, s1
		
	always @(*) begin
		case({s1, s0})
			2'b00: y = a;
			2'b01: y = b;
			2'b10: y = c;
			default: y = 16'b0;
		endcase
	end
endmodule

