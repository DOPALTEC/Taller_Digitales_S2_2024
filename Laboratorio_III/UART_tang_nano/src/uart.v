`default_nettype none
`timescale 1ms / 100us
module uart
#(
    parameter DELAY_FRAMES = 234 // 27,000,000 (27Mhz) / 115200 Baud rate
)
(
    input wire clk,
    input wire rst_n,
    output wire uart_tx,
    // Usamos los valores guardados en los registros
    input wire count_bit1_reg,
    input wire count_bit0_reg,
    input wire enable_bit1_reg,
    input wire enable_bit0_reg,
    input wire any_key_pressed
);

// Registros para TX
reg [3:0] txState = 0;
reg [24:0] txCounter = 0;
reg [7:0] dataOut = 0;
reg txPinRegister = 1;
reg [2:0] txBitNumber = 0;
reg [3:0] txByteCounter = 0;

assign uart_tx = txPinRegister;

// Función para convertir los 4 bits a ASCII según el mapeo del teclado
function [7:0] get_key_ascii;
    input bit1_e, bit0_e, bit1_c, bit0_c;
    reg [3:0] key_value;
    begin
        key_value = {bit1_e, bit0_e, bit1_c, bit0_c};
        case (key_value)
            4'b1100: get_key_ascii = "1";  // 0000 = 1
            4'b1101: get_key_ascii = "2";  // 0001 = 2
            4'b1110: get_key_ascii = "3";  // 0010 = 3
            4'b1111: get_key_ascii = "A";  // 0011 = A
            4'b1000: get_key_ascii = "4";  // 0100 = 4
            4'b1001: get_key_ascii = "5";  // 0101 = 5
            4'b1010: get_key_ascii = "6";  // 0110 = 6
            4'b1011: get_key_ascii = "B";  // 0111 = B
            4'b0100: get_key_ascii = "7";  // 1000 = 7
            4'b0101: get_key_ascii = "8";  // 1001 = 8
            4'b0110: get_key_ascii = "9";  // 1010 = 9
            4'b0111: get_key_ascii = "C";  // 1011 = C
            4'b0000: get_key_ascii = "*";  // 1100 = *
            4'b0001: get_key_ascii = "0";  // 1101 = 0
            4'b0010: get_key_ascii = "#";  // 1110 = #
            4'b0011: get_key_ascii = "D";  // 1111 = D
            default: get_key_ascii = "?";  // Por si acaso
        endcase
    end
endfunction

// Estados del TX
localparam TX_STATE_IDLE = 0;
localparam TX_STATE_START_BIT = 1;
localparam TX_STATE_WRITE = 2;
localparam TX_STATE_STOP_BIT = 3;
localparam TX_STATE_WAIT = 4;

// Memoria para el mensaje a enviar
reg [7:0] txMemory [3:0];  // "X\r\n" donde X es el carácter de la tecla

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        txState <= TX_STATE_IDLE;
        txCounter <= 0;
        txByteCounter <= 0;
        txPinRegister <= 1;
    end else begin
        case (txState)
            TX_STATE_IDLE: begin
                if (any_key_pressed) begin
                    // Cuando se presiona una tecla, preparamos el mensaje
                    txMemory[0] <= get_key_ascii(enable_bit1_reg, enable_bit0_reg, 
                                               count_bit1_reg, count_bit0_reg);
                    txMemory[1] <= 8'h0D;  // CR
                    txMemory[2] <= 8'h0A;  // LF
                    txState <= TX_STATE_START_BIT;
                    txCounter <= 0;
                    txByteCounter <= 0;
                end
                else begin
                    txPinRegister <= 1;
                end
            end 
            
            TX_STATE_START_BIT: begin
                txPinRegister <= 0;
                if ((txCounter + 1) == DELAY_FRAMES) begin
                    txState <= TX_STATE_WRITE;
                    dataOut <= txMemory[txByteCounter];
                    txBitNumber <= 0;
                    txCounter <= 0;
                end else 
                    txCounter <= txCounter + 1;
            end

            TX_STATE_WRITE: begin
                txPinRegister <= dataOut[txBitNumber];
                if ((txCounter + 1) == DELAY_FRAMES) begin
                    if (txBitNumber == 3'b111) begin
                        txState <= TX_STATE_STOP_BIT;
                    end else begin
                        txBitNumber <= txBitNumber + 1;
                    end
                    txCounter <= 0;
                end else 
                    txCounter <= txCounter + 1;
            end

            TX_STATE_STOP_BIT: begin
                txPinRegister <= 1;
                if ((txCounter + 1) == DELAY_FRAMES) begin
                    if (txByteCounter == 2) begin  // Enviamos 3 bytes: valor, CR, LF
                        txState <= TX_STATE_WAIT;
                    end else begin
                        txByteCounter <= txByteCounter + 1;
                        txState <= TX_STATE_START_BIT;
                    end
                    txCounter <= 0;
                end else 
                    txCounter <= txCounter + 1;
            end

            TX_STATE_WAIT: begin
                // Esperamos a que se suelte la tecla antes de volver a IDLE
                if (!any_key_pressed) begin
                    txState <= TX_STATE_IDLE;
                end
            end
        endcase      
    end
end

endmodule
