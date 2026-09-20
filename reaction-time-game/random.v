// random module
// generates random numbers using linear feedback shift register instead of $random 

// tap positions 1, 3, 5 from mathematical tables (Galois field theory)

module random (
    input clk, // 1 kHz clock 
    input reset_n,              
    input resume_n, // start generating. FSM controls when we need a new number 
    output reg [13:0] random, // 14 bits to rep. 1000-5000 ms
    output reg rnd_ready // Flag = 1 means valid random number available
);

reg [13:0] reg_values;  // LFSR shift register
reg enable;             // internal enable: 1 = generating, 0 = paused

always @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
        // seed with all 1s (avoid all-zero lock-up)
        reg_values <= 14'b11111111111111;
        enable <= 1'b1; // start generating immediately after reset
        rnd_ready <= 1'b0; // no valid number yet
        random <= 14'd0; // clear output
    end
    else if (!resume_n) begin
        // resume signal starts a new generation cycle
        // doesn't reset reg_values to keep the LFSR state for true randomness
        enable <= 1'b1;
        rnd_ready <= 1'b0;  // clear ready flag (old value no longer valid)
    end
    else begin
        if (enable) begin
            
            // shift bit 0 into position 13
            reg_values[13] <= reg_values[0];
            
            // positions without taps: simple shift
            reg_values[12:6] <= reg_values[13:7];
            
            // rap at position 5: XOR with bit 0
            reg_values[5] <= reg_values[0] ^ reg_values[6];
            
            // positions without taps: simple shift
            reg_values[4] <= reg_values[5];
            
            // tap at position 3: XOR with bit 0
            reg_values[3] <= reg_values[0] ^ reg_values[4];
            
            // simple shift
            reg_values[2] <= reg_values[3];
            
            // tap at position 1: XOR with bit 0
            reg_values[1] <= reg_values[0] ^ reg_values[2];
            
            // position 0: gets previous position 1
            reg_values[0] <= reg_values[1];
            
            // check if generated value is in valid range [1000, 5000]
            if (reg_values >= 14'd1000 && reg_values <= 14'd5000) begin
                // found a valid random number!
                random <= reg_values;
                rnd_ready <= 1'b1;
                enable <= 1'b0;  //stop generating until resume_n
                
            end
            // if not in range, keep shifting
     
        end
    end
end // end always

endmodule