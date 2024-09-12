`timescale 1ns / 1ps

module top_module_tb;  // Testbench for the top-level module

    // Testbench signals
    reg clk;
    reg rst_n;          // Active-low reset
    reg button;         // Simulated button input with bounce
    wire [7:0] cont;    // Output from the counter

    // Instantiate the top-level module
    top_module uut (
        .clk(clk),
        .rst_n(rst_n),
        .button(button),
        .cont(cont)
    );

    // Clock generation (50 MHz clock, 20 ns period)
    initial begin
        clk = 0;
        forever #10 clk = ~clk; // Generate clock signal with 20ns period (50 MHz)
    end

    // Simulated button signal generation (with bouncing effect)
    initial begin
        // Initialize signals
        rst_n = 0;      // Assert reset
        button = 0;     // Initial state of button

        // Release reset after 50 ns
        #50 rst_n = 1;  // De-assert reset

        // Simulate button press with bounce
        #100 button = 1;
        #15 button = 0;  // Bouncing effect
        #10 button = 1;  // Bounce
        #20 button = 0;  // Bounce ends

        // Stable button press
        #100 button = 1;
        #100 button = 0;

        // Another press with bouncing
        #150 button = 1;
        #5 button = 0;
        #5 button = 1;
        #10 button = 0;

        // Repeat the noisy press multiple times
        repeat (3) begin
            #200 button = 1;
            #10 button = 0;
            #10 button = 1;
            #30 button = 0;
        end

        // End simulation
        #500;
        $stop;
    end

    // Monitor signals
    initial begin
        $monitor("Time: %0t | rst_n = %b | button = %b | cont = %d", $time, rst_n, button, cont);
    end

endmodule

