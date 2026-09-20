// Module blinkHEX

// all 6 HEX displays show 000000 for a period then turn off

module blinkHEX(
    input ms_clk, // 1 kHz clock (1 ms period)
    input reset_n,  
    output reg [3:0] d0, // digit 0
    output reg [3:0] d1,      
    output reg [3:0] d2,      
    output reg [3:0] d3,     
    output reg [3:0] d4,       
    output reg [3:0] d5 // digit 5 
);

// blink period = 200 ms, 5 times per second
parameter BLINK_PERIOD = 200;

// 12-bit counter 
reg [11:0] countQ;

always @(posedge ms_clk or negedge reset_n) begin
    if (!reset_n) begin
        // reset to known state at 0
        countQ <= 12'd0;
        d0 <= 4'b0000;
        d1 <= 4'b0000;
        d2 <= 4'b0000;
        d3 <= 4'b0000;
        d4 <= 4'b0000;
        d5 <= 4'b0000;
    end
    else begin
        // three-phase counter for blinking
        // 1: show 000000 (first half of period)
        // 2: show blank (second half of period)
        // 3: reset counter and repeat
        
        if (countQ < BLINK_PERIOD/2) begin
            // first half: display 0s
            countQ <= countQ + 12'd1;
            d0 <= 4'b0000; 
            d1 <= 4'b0000;
            d2 <= 4'b0000;
            d3 <= 4'b0000;
            d4 <= 4'b0000;
            d5 <= 4'b0000;
        end
        else if (countQ < BLINK_PERIOD) begin
            // second half: blank display
            countQ <= countQ + 12'd1;
            d0 <= 4'b1111;  // blank
            d1 <= 4'b1111;
            d2 <= 4'b1111;
            d3 <= 4'b1111;
            d4 <= 4'b1111;
            d5 <= 4'b1111;
        end
        else begin
            // period complete: reset counter and start over
            // show 0 immediately after reset to ensure we always start with displays visible
            countQ <= 12'd0;
            d0 <= 4'b0000;
            d1 <= 4'b0000;
            d2 <= 4'b0000;
            d3 <= 4'b0000;
            d4 <= 4'b0000;
            d5 <= 4'b0000;
        end
    end
end

endmodule