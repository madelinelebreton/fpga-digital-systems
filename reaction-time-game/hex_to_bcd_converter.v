// module hex_to_bcd_converter
// converts a 20-bit number to decimal representation for 7SD
// uses double-dabble algorithm
// ex. 0b10011100010000 = 1, 0, 0, 0, 0

// algorithm overview: (looked this up)
// 1. Initialize all BCD digits to 0
// 2. For each bit of binary input (MSB to LSB):
// a. For each BCD digit: if digit >= 5, add 3 (prevents overflow during shift)
// b. Shift all BCD digits left by 1 bit
// c. Shift in the next binary bit
// 3. After all shifts, BCD digits contain the decimal representation


module hex_to_bcd_converter(
    input wire clk, // clock for registering outputs
    input wire reset_n,        
    input wire [19:0] hex_number, // 20 bit binary input (needed 0 to 999,999)
    output reg [3:0] bcd_digit_0,   
    output reg [3:0] bcd_digit_1,   
    output reg [3:0] bcd_digit_2,   
    output reg [3:0] bcd_digit_3,   
    output reg [3:0] bcd_digit_4,   
    output reg [3:0] bcd_digit_5    
);

integer i, k;  // loop counters 
reg [3:0] bcd_digit [5:0];  // array of 6 BCD digits (each has 4 bits)

// combinational block for conversion algorithm, no clock dependency
always @(*) begin
	 // initialize all digits to 0 to start from a known state
    for (k = 0; k < 6; k = k + 1) begin
        bcd_digit[k] = 4'b0000;
    end
    
	 // during reset, output zeros
    if (!reset_n) begin
			// still at zero state from above
    end
    else begin
			// process binary bits from MSB (19) to LSB (0)
        for (i = 19; i >= 0; i = i - 1) begin
            for (k = 5; k >= 0; k = k - 1) begin
                if (bcd_digit[k] >= 5) begin
                    bcd_digit[k] = bcd_digit[k] + 4'd3;
                end
            end
         
            for (k = 5; k >= 1; k = k - 1) begin
                bcd_digit[k] = bcd_digit[k] << 1; // shift left
                bcd_digit[k][0] = bcd_digit[k-1][3]; // carry from next digit
            end
            
            // rightmost BCD digit gets next bit from binary input
            bcd_digit[0] = bcd_digit[0] << 1; // shift left
            bcd_digit[0][0] = hex_number[i];// shift in binary bit
        end
    end
end

// separate sequential block for registering outputs and synchronizing to clock
always @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin // reset to 0
        bcd_digit_0 <= 4'd0;
        bcd_digit_1 <= 4'd0;
        bcd_digit_2 <= 4'd0;
        bcd_digit_3 <= 4'd0;
        bcd_digit_4 <= 4'd0;
        bcd_digit_5 <= 4'd0;
    end
    else begin // register calculated BCD digits
        bcd_digit_0 <= bcd_digit[0];
        bcd_digit_1 <= bcd_digit[1];
        bcd_digit_2 <= bcd_digit[2];
        bcd_digit_3 <= bcd_digit[3];
        bcd_digit_4 <= bcd_digit[4];
        bcd_digit_5 <= bcd_digit[5];
    end
end

endmodule