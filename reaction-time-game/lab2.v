// Module: lab2 (top level module)

// instantiates all submodules and implements main FSM for game control

// BLINK, WAIT_RANDOM, TIMING, RESULT, (back to BLINK)

// KEY[0] = Player 1 button
// KEY[1] = Reset button
// KEY[2] = Resume/Continue button
// KEY[3] = Player 2 button

module lab2 (
    input CLOCK_50,// 50 MHz clock from board
    input [3:0] KEY,// 4 active low buttons
                                            
    output [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5,  // six 7SDs
    output [9:0] LEDR // 10 LEDs for win tracking
);


// connects to a 1 ms clock
wire ms_clk;  // 1 kHz clock (1 ms period)

clock_divider #(50000) cd (
    .clock(CLOCK_50),
    .reset_n(KEY[1]),
    .clk_ms(ms_clk)
);

// localparam define FSM states

reg [2:0] state; // current state register
reg [15:0] state_count; // counter for timing within each state

localparam 
    BLINK       = 3'd0, // HEX displays blink 000000
    WAIT_RANDOM = 3'd1, // HEX displays off for random duration
    TIMING      = 3'd2, // timer running, displays show elapsed time
    RESULT      = 3'd3; // display frozen, showing reaction time

// implement cheating detection with two flags

reg key0_cheated;  // 1 = KEY[0] pressed early
reg key3_cheated;  // 1 = KEY[3] pressed early

// combinational logic to check for cheating
// continuously monitor buttons during non timing states (immediate)
wire both_cheated = key0_cheated & key3_cheated;
wire any_cheated = key0_cheated | key3_cheated;


// track who wins using 3-bit counters (0 to 5 times), 3 bits could describe 0 to 7 in decimal
reg [2:0] key0_wins;  // KEY[0] win count (0 to 5)
reg [2:0] key3_wins;  // KEY[3] win count (0 to 5)

// LED display pattern progress bars
// KEY[0]: LEDs light up from right to left (LEDR[0] to LEDR[4])
// KEY[3]: LEDs light up from left to right (LEDR[9] to LEDR[5])

assign LEDR[4:0] = (key0_wins == 3'd0) ? 5'b00000 : // ? : used like if/else statement shorthand
                   (key0_wins == 3'd1) ? 5'b00001 :
                   (key0_wins == 3'd2) ? 5'b00011 :
                   (key0_wins == 3'd3) ? 5'b00111 :
                   (key0_wins == 3'd4) ? 5'b01111 :
                                         5'b11111;  // 5 wins

assign LEDR[9:5] = (key3_wins == 3'd0) ? 5'b00000 :
                   (key3_wins == 3'd1) ? 5'b10000 :
                   (key3_wins == 3'd2) ? 5'b11000 :
                   (key3_wins == 3'd3) ? 5'b11100 :
                   (key3_wins == 3'd4) ? 5'b11110 :
                                         5'b11111;  // 5 wins
													  

wire [19:0] ms_count; // ms count from timer
wire start_timer_n; // start signal
wire stop_timer_n; // stop signal

// generate start/stop signals from FSM state
// timer starts automatically in TIMING, stops in RESULT
assign start_timer_n = (state == TIMING) ? 1'b0 : 1'b1; // this will implement start when display turns on
assign stop_timer_n  = (state == RESULT) ? 1'b0 : 1'b1; // will implement stop when a button is pressed, hold the value for display

counter ctr (
    .clk(ms_clk),
    .reset_n(KEY[1]),
    .start_n(start_timer_n),
    .stop_n(stop_timer_n),
    .ms_count(ms_count)
);

// convert timer output to BCD for seven-segment display
wire [3:0] bcd0, bcd1, bcd2, bcd3, bcd4, bcd5;  // 6 BCD digits

hex_to_bcd_converter bcd (
    .clk(ms_clk),
    .reset_n(KEY[1]),
    .hex_number(ms_count),
    .bcd_digit_0(bcd0),
    .bcd_digit_1(bcd1),
    .bcd_digit_2(bcd2),
    .bcd_digit_3(bcd3),
    .bcd_digit_4(bcd4),
    .bcd_digit_5(bcd5)
);

// blink display module
// during BLINK state, displays alternate between 000000 and blank.
wire [3:0] blink_d0, blink_d1, blink_d2, blink_d3, blink_d4, blink_d5;

blinkHEX blink (
    .ms_clk(ms_clk),
    .reset_n(KEY[1]),
    .d0(blink_d0),
    .d1(blink_d1),
    .d2(blink_d2),
    .d3(blink_d3),
    .d4(blink_d4),
    .d5(blink_d5)
);

// random number generator for wait duration
wire [13:0] rnd_value; // random number (will be in range 1000 to 5000)
wire rnd_ready;// flag = 1 means valid random number available
reg [15:0] random_delay; // stores random delay for current round

// automatically trigger random generation in BLINK state
// we want a new random number for each round
// trigger during BLINK to generate before WAIT_RANDOM
wire resume_rnd = (state == BLINK) ? 1'b0 : 1'b1;  // active low

random rnd_gen (
    .clk(ms_clk),
    .reset_n(KEY[1]),
    .resume_n(resume_rnd),
    .random(rnd_value),
    .rnd_ready(rnd_ready)
);

// display multiplexer
// selects what to show based on state and conditions

reg [3:0] d0, d1, d2, d3, d4, d5;  // digit values sent to decoders

always @(*) begin
    // check for cheating first (highest priority)
    // if cheating occurred, override normal display behavior
    if (both_cheated) begin
        // both players cheated: display all 8s
        d0 = 4'd8;
        d1 = 4'd8;
        d2 = 4'd8;
        d3 = 4'd8;
        d4 = 4'd8;
        d5 = 4'd8;
    end
    else if (key0_cheated) begin
        // KEY[0] cheated: display all 1s
        d0 = 4'd1;
        d1 = 4'd1;
        d2 = 4'd1;
        d3 = 4'd1;
        d4 = 4'd1;
        d5 = 4'd1;
    end
    else if (key3_cheated) begin
        // KEY[3] cheated: display all 2s
        d0 = 4'd2;
        d1 = 4'd2;
        d2 = 4'd2;
        d3 = 4'd2;
        d4 = 4'd2;
        d5 = 4'd2;
    end
    else begin
        // no cheating: display based on current state
        case(state)
            BLINK: begin
                // display blinking pattern
                d0 = blink_d0;
                d1 = blink_d1;
                d2 = blink_d2;
                d3 = blink_d3;
                d4 = blink_d4;
                d5 = blink_d5;
            end
            
            WAIT_RANDOM: begin
                // all displays off (blank)
                d0 = 4'hF;
                d1 = 4'hF;
                d2 = 4'hF;
                d3 = 4'hF;
                d4 = 4'hF;
                d5 = 4'hF;
            end
            
            TIMING,
            RESULT: begin
                // display timer value in BCD
                d0 = bcd0;
                d1 = bcd1;
                d2 = bcd2;
                d3 = bcd3;
                d4 = bcd4;
                d5 = bcd5;
            end
            
            default: begin
                // blank display if undefined states are encountered
                d0 = 4'hF;
                d1 = 4'hF;
                d2 = 4'hF;
                d3 = 4'hF;
                d4 = 4'hF;
                d5 = 4'hF;
            end
        endcase
    end
end

// one 7SD decoder per display
seven_seg_decoder h0 (.x(d0), .hex_LEDs(HEX0));
seven_seg_decoder h1 (.x(d1), .hex_LEDs(HEX1));
seven_seg_decoder h2 (.x(d2), .hex_LEDs(HEX2));
seven_seg_decoder h3 (.x(d3), .hex_LEDs(HEX3));
seven_seg_decoder h4 (.x(d4), .hex_LEDs(HEX4));
seven_seg_decoder h5 (.x(d5), .hex_LEDs(HEX5));

// main FSM
// sequential logic for state transitions and counters
// change states based on timing and button presses

always @(posedge ms_clk or negedge KEY[1]) begin
    if (!KEY[1]) begin
        // asynchronous reset to initial state
        state <= BLINK;
        state_count <= 16'd0;
        random_delay <= 16'd0;
        key0_cheated <= 1'b0;
        key3_cheated <= 1'b0;
        key0_wins <= 3'd0;
        key3_wins <= 3'd0;
    end
    else begin
        // increment state counter every clock cycle
        // provides timing for state transitions
        state_count <= state_count + 1'b1;
        
        // latch random value when ready
        // once LFSR generates a valid random number, store it for this round
        if (rnd_ready && (state == BLINK || state == WAIT_RANDOM)) begin
            random_delay <= rnd_value;
        end
        
        // state transition logic
        case (state)
           
            BLINK: begin // display blink for 2 seconds
                // clear cheating flags at start of new round
                // each round is independent, past cheating doesn't carry over
                key0_cheated <= 1'b0;
                key3_cheated <= 1'b0;
                
                // 2000 ms = 2 seconds of blinking gives players time to get ready
                if (state_count == 16'd2000) begin
                    state <= WAIT_RANDOM;
                    state_count <= 16'd0;
                end
            end
            
            // displays are off for a random duration (1-5 seconds)
            // this prevents players from anticipating when to press
				
				WAIT_RANDOM: begin
                // check for cheating (early button press)
                // if button pressed during wait, flag as cheating
                if (!KEY[0]) begin
                    key0_cheated <= 1'b1;
                end
                if (!KEY[3]) begin
                    key3_cheated <= 1'b1;
                end
					 
                // wait for random delay to expire
                // random_delay was set by LFSR (1000-5000 ms range)
                if (state_count >= random_delay) begin
                    state <= TIMING;
                    state_count <= 16'd0;
                end
            end
            
           
            // timer is running, displays show elapsed time
            // first player to press their button wins
            TIMING: begin
                // check which button was pressed first
                // KEY[0] is checked first in the if-else chain, giving it
                // priority if both buttons pressed simultaneously
                
                if (!KEY[0] && !any_cheated) begin
                    // Player 1 pressed button (and didn't cheat)
                    if (key0_wins < 3'd5) begin
                        key0_wins <= key0_wins + 1'b1;
                    end
                    state <= RESULT;
                    state_count <= 16'd0;
                end
                else if (!KEY[3] && !any_cheated) begin
                    // Player 2 pressed button (and didn't cheat)
                    if (key3_wins < 3'd5) begin
                        key3_wins <= key3_wins + 1'b1;
                    end
                    state <= RESULT;
                    state_count <= 16'd0;
                end
                else if (!KEY[0] || !KEY[3]) begin
                    // someone pressed but cheating occurred
                    // no winner if anyone cheated
                    // go to RESULT but don't increment win counters
                    state <= RESULT;
                    state_count <= 16'd0;
                end
                // if no button pressed, stay in TIMING
                // timer continues running until someone presses
            end
            
            // display frozen showing reaction time (or error code if cheated)
            // Wait for resume button KEY[2] to start new round
            RESULT: begin
                // KEY[2] resumes the game
                // this gives players time to see the result before continuing
                if (!KEY[2]) begin
                    state <= BLINK;
                    state_count <= 16'd0;
                end
            end
				
            // default state: if somehow we enter an undefined state, return to BLINK
            default: begin
                state <= BLINK;
                state_count <= 16'd0;
            end
        endcase
    end
end

endmodule