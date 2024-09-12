`timescale 1ns / 1ps
module debounce(
    input clk,
    input rst_n,      
    input button_in,  // entrada del botón 
    output debounced_out
);
    parameter  DEBOUNCE_THRESHOLD = 1000000;  //  debounce delay

    reg [19:0] counter;  
    reg button_state;    
// contador 
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            counter <= 0;
            button_state <= 0;
        end else begin
            if (button_in != button_state) begin
                counter <= counter + 1;
                if (counter == DEBOUNCE_THRESHOLD) begin
                    button_state <= button_in;
                    counter <= 0;
                end
            end else begin
                counter <= 0;
            end
        end
    end

    assign debounced_out = button_state;
endmodule
