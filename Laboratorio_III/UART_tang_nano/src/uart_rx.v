module uart_rx (
    input wire clk,
    input wire rst_n,
    input wire uart_rx, // Pin de recepción UART
    output reg [2:0] received_color, // Color recibido
    output reg data_ready // Señal que indica que hay datos listos para procesar
);
    // Estados del RX
    localparam RX_STATE_IDLE = 0;
    localparam RX_STATE_START_BIT = 1;
    localparam RX_STATE_READ = 2;
    localparam RX_STATE_STOP_BIT = 3;

    reg [1:0] rxState = RX_STATE_IDLE;
    reg [24:0] rxCounter = 0;
    reg [2:0] bitCounter = 0;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            rxState <= RX_STATE_IDLE;
            rxCounter <= 0;
            bitCounter <= 0;
            received_color <= 0;
            data_ready <= 0;
        end else begin
            case (rxState)
                RX_STATE_IDLE: begin
                    if (!uart_rx) begin // Detectar el inicio del bit
                        rxState <= RX_STATE_START_BIT;
                        rxCounter <= 0;
                    end
                end

                RX_STATE_START_BIT: begin
                    if (rxCounter < DELAY_FRAMES) begin
                        rxCounter <= rxCounter + 1;
                    end else begin
                        rxState <= RX_STATE_READ;
                        bitCounter <= 0;
                        rxCounter <= 0;
                    end
                end

                RX_STATE_READ: begin
                    if (rxCounter < DELAY_FRAMES) begin
                        rxCounter <= rxCounter + 1;
                    end else begin
                        received_color[bitCounter] <= uart_rx; // Leer el bit
                        if (bitCounter == 2'b011) begin // Si se han leído 3 bits
                            data_ready <= 1; // Señal de que los datos están listos
                            rxState <= RX_STATE_STOP_BIT;
                        end else begin
                            bitCounter <= bitCounter + 1; // Siguiente bit
                        end
                        rxCounter <= 0;
                    end
                end

                RX_STATE_STOP_BIT: begin
                    // Esperar el stop bit y volver al estado idle
                    if (rxCounter < DELAY_FRAMES) begin
                        rxCounter <= rxCounter + 1;
                    end else begin
                        rxState <= RX_STATE_IDLE;
                        data_ready <= 0; // Resetear la señal
                    end
                end
            endcase
        end
    end
endmodule
