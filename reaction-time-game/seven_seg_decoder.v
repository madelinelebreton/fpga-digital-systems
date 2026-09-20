// module seven_seg_decoder
// combinational logic because no states or memory, so no clock needed

module seven_seg_decoder(
    input [3:0] x,              // 4-bit input (0-15)
    output reg [6:0] hex_LEDs   // 7-segment output {g,f,e,d,c,b,a}
);


always @(*) begin // combinational always block
    case (x)
        // one case for each digit to double check against datasheet
        4'b0000: hex_LEDs = 7'b1000000;  // 0
        4'b0001: hex_LEDs = 7'b1111001;  // 1
        4'b0010: hex_LEDs = 7'b0100100;  // 2
        4'b0011: hex_LEDs = 7'b0110000;  // 3
        4'b0100: hex_LEDs = 7'b0011001;  // 4
        4'b0101: hex_LEDs = 7'b0010010;  // 5
        4'b0110: hex_LEDs = 7'b0000010;  // 6
        4'b0111: hex_LEDs = 7'b1111000;  // 7
        4'b1000: hex_LEDs = 7'b0000000;  // 8
        4'b1001: hex_LEDs = 7'b0010000;  // 9
        
        // hexadecimal A-E
        4'b1010: hex_LEDs = 7'b0001000;  // A
        4'b1011: hex_LEDs = 7'b0000011;  // b
        4'b1100: hex_LEDs = 7'b1000110;  // C
        4'b1101: hex_LEDs = 7'b0100001;  // d
        4'b1110: hex_LEDs = 7'b0000110;  // E
        
		  // blank
        4'b1111: hex_LEDs = 7'b1111111;  // use F to turn all segments off
        
		  // no default case because all 2^4 = 16 possible 4 bit combos have been covered
    endcase
end // end always

endmodule