// module: counter

// starts counting when LEDs turn on (timing state begins)
// stops counting when a button is pressed (save reaction time)
// hold the final value (don't reset to 0 until new round)

module counter(
    input clk, // 1 kHz clock (1 ms period)
    input reset_n,
    input start_n, // buttons are active low
    input stop_n,// active-low stop signal
    output reg [19:0] ms_count  // 20 bits rep. millisecond count (0 to 999,999)
);

// enable flag: once started, counter continues until explicitly stopped
reg enable;  // 1 = counting, 0 = stopped

// initialize registers to known values
// ensure deterministic behavior on power-up
initial begin
    ms_count = 20'd0;
    enable = 1'b0;
end

always @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
        // resets counter to 0
        ms_count <= 20'd0;
        enable <= 1'b0;
    end
    else begin
        // start_n has highest priority, then stop_n, then counting
        // to ensure clean transitions between states
        
        if (!start_n) begin
            // start signal: enable counting and reset count
            enable <= 1'b1;
            ms_count <= 20'd0;
        end
        else if (!stop_n) begin
            // stop signal: disable counting but save count
            enable <= 1'b0;
        end
        else if (enable) begin
            // only increment when enabled AND no start or stop signals
            // limit to 999,999 to prevent overflow
            if (ms_count < 20'd999999) begin
                ms_count <= ms_count + 1'b1;
            end
        end
    end
end

endmodule