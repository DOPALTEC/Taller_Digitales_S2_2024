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
    key_cols = 4'b1111;
    #10 reset = 0;
    
    // Simulate pressing key '5'
    #100000 key_cols = 4'b1101;
    #1000000 key_cols = 4'b1111;
    
    // Simulate pressing key 'A'
    #100000 key_cols = 4'b0111;
    #1000000 key_cols = 4'b1111;
    
    #100000 $finish;
end

always #5 clk_in = ~clk_in;

initial begin
    $monitor("Time=%0t reset=%b key_rows=%b key_cols=%b hex_out=%h key_pressed=%b",
             $time, reset, key_rows, key_cols, hex_out, key_pressed);
end

endmodule