`timescale 1ns/1ps

module pwm_generador_tb;

    // Inputs
    reg clk;
    reg [3:0] switch;

    // Outputs
    wire led;

    pwm_generador uut (
        .clk(clk),
        .switch(switch),
        .led(led)
    );

    // Clock 
    always #5 clk = ~clk; 
    initial begin
     
        clk = 0;
        switch = 4'b0000;

        // Pruebas
        #20;
        switch = 4'b0001; // 10% duty cycle
        #1000000; 
        
        switch = 4'b0100; // 40% duty cycle
        #1000000; 
        
        switch = 4'b1000; // 80% duty cycle
        #1000000; 
        
        switch = 4'b1111; // 100% duty cycle (capped)
        #1000000; 
        
    
        $finish;
    end


endmodule

