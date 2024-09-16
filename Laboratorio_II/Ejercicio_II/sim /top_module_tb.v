module hex_keyboard_interface_tb;

reg clk_in;
reg reset;
reg [3:0] key_cols;
wire [3:0] key_rows;
wire [3:0] hex_out;
wire key_pressed;

hex_keyboard_interface uut (
    .clk_in(clk_in),
    .reset(reset),
    .key_cols(key_cols),
    .key_rows(key_rows),
    .hex_out(hex_out),
    .key_pressed(key_pressed)
);

initial begin
    clk_in = 0;
    reset = 1;
    key_cols = 4'b1111;  // No key pressed (default state)
    
    // Hold reset for a longer time
    #100 reset = 0;

    // Simulate key bounce for key '5' (row[1], col[1])
    #500000 key_cols = 4'b1101; // Start key press '5'
    
    // Key bounce simulation (rapid toggling)
    #100000 key_cols = 4'b1111; // Key released briefly
    #100000 key_cols = 4'b1101; // Key pressed again
    #100000 key_cols = 4'b1111; // Key released briefly
    #100000 key_cols = 4'b1101; // Key pressed again

    // After bouncing, stabilize the key press
    #1000000 key_cols = 4'b1111; // Release key '5'
    
    // Simulate pressing key 'A' (row[0], col[3]) without bounce
    #500000 key_cols = 4'b0111; // Key press 'A'
    #1000000 key_cols = 4'b1111; // Release key 'A'

    #500000 $finish;
end

// Clock generation (100 MHz example: adjust period if needed)
always #5 clk_in = ~clk_in;  // 10ns period = 100MHz

// Monitor outputs during the simulation
initial begin
    $monitor("Time=%0t reset=%b key_rows=%b key_cols=%b hex_out=%h key_pressed=%b",
             $time, reset, key_rows, key_cols, hex_out, key_pressed);
end

endmodule
