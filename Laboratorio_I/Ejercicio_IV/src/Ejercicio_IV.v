module top( 
    input clk,
    input [3:0] switch,  //Entrada de los switches 
    output reg led
    );

    
    localparam integer counter_MAX = 100_000 - 1;  // 100,000 clock cycles (maximo) es de este valor para un ancho de pulso de 1ms

    
    reg [16:0] counter = 0;  // regitro de 17 bits para poder realizar un contador que llegue a 100,000

    always @(posedge clk) begin 
        if (counter < counter_MAX) 
            counter <= counter + 1; 
        else 
            counter <= 0; // vuelve el contador a cero 
    end

    // Ajuste del duty cycle del PWM por medio de los switches 
    always @(posedge clk) begin
        led <= (counter < (switch * 6667)) ? 1 : 0; 
    end

endmodule

