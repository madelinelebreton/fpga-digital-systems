// module clock_divider
// converts 50 MHz clock to 1kHz (1ms period)

module clock_divider (
    input clock,           // 50 MHz input clock from board
    input reset_n,         
    output reg clk_ms      // output clock at 1 kHz 
);

parameter factor = 50000;  // divide 50 MHz by 50,000 to get 1 kHz, use a parameter to make it reusable

reg [31:0] countQ;  // 32 bit counter 

always @(posedge clock or negedge reset_n) begin // asynchronous reset for immediate response
    // start with resetting to known state. deterministic startup behaviour
	 if (!reset_n) begin
        countQ <= 32'd0; // count = 0
        clk_ms <= 1'b0;  // clock low
    end
    else begin
		// model toggle behaviour using if-else branches 
        if (countQ < factor/2) begin // first half of duty cycle
            countQ <= countQ + 1; // keep track of where we are in the period
            clk_ms <= 1'b0; // toggle clock to low
        end
        else if (countQ < factor - 1) begin // first half of duty cycle
            countQ <= countQ + 1; // keep track of where we are in the period
            clk_ms <= 1'b1; // toggle clock to high
        end
        else begin
            // period complete, reset counter to 0 to start new cycle
            countQ <= 32'd0;
            clk_ms <= 1'b0;
        end
    end
end

endmodule