module sync(
    input clk,
    input wire [1:0] async_in,  // Entrada de 2 bits (key detect)
    output reg sync_out         // Salida de 1 bit
);
    reg sync_ff1_0, sync_ff1_1;  // Flip-flops de 1 bit para cada bit de entrada
    reg sync_ff2_0, sync_ff2_1;  // Flip-flops de 1 bit para cada bit de entrada
    
    initial begin
        sync_ff1_0 = 0;
        sync_ff1_1 = 0;
        sync_ff2_0 = 0;
        sync_ff2_1 = 0;
    end

    always @(posedge clk) begin
        sync_ff1_0 <= async_in[0];  // Sincronizar bit menos significativo
        sync_ff1_1 <= async_in[1];  // Sincronizar bit más significativo
        sync_ff2_0 <= sync_ff1_0;
        sync_ff2_1 <= sync_ff1_1;
        sync_out <= sync_ff2_0 | sync_ff2_1;  // Combinación OR de ambos bits
    end
endmodule
