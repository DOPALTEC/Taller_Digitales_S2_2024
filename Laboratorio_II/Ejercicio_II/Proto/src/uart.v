`default_nettype none
`timescale 1ms / 100us
module uart
#(
    parameter DELAY_FRAMES = 234 // 27,000,000 (27Mhz) / 115200 Baud rate
)
(
    input wire clk,
    input wire rst_n,
    // Removemos uart_rx ya que no lo usaremos
    output wire uart_tx,
    // Agregamos las entradas de los registros
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

// Convertimos los 2 bits del contador a un valor ASCII hex (0-3)
wire [7:0] count_ascii = (count_bit1_reg ? 8'h32 : 8'h30) + {6'b0, count_bit0_reg};

// Estados del TX
localparam TX_STATE_IDLE = 0;
localparam TX_STATE_START_BIT = 1;
localparam TX_STATE_WRITE = 2;
localparam TX_STATE_STOP_BIT = 3;
localparam TX_STATE_WAIT = 4;

// Memoria para el mensaje a enviar
reg [7:0] txMemory [3:0];  // "X\r\n" donde X es el valor hex

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
                    txMemory[0] <= count_ascii;  // Valor hex
                    txMemory[1] <= 8'h0D;        // CR
                    txMemory[2] <= 8'h0A;        // LF
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