`timescale 1ns / 1ps

module ctrl_UART #(
    parameter palabra = 32  // Tamaño por defecto de la palabra
    //parameter N = 2         // Tamaño por defecto de addr2
)(
    input  wire CLK100MHZ,
    input  wire rst,
    input wire reg_sel_i,
    // Entradas
    input wire [palabra-1:0] ctrl,    // Entrada de control
    input wire [palabra-1:0] data,    // Entrada de datos

    // Salidas
    output reg [palabra-1:0] IN2_data,    // Salida de datos IN2
    output reg WR2_data,                  // Señal de escritura para datos
    output reg hold_ctrl,
    output reg [palabra-1:0] IN2_ctrl,    // Salida de control IN2
    output reg WR2_ctrl,                  // Señal de escritura para control
    

    // Dirección de salida
    //output reg [N-1:0] addr2,             // Salida de dirección
    output reg addr2=1, //Esta direccion no cambia, corresponde a la direccion donde
    //se guarda lo que se recibe en el registro de datos
    
    input  wire rxd, //Para el constraint
    output wire txd, //Para el constraint
    input wire rx_busy
    
    
);

//GENERACION DE ESTADOS
localparam IDLE=2'b00;
localparam RECEIVE_BYTE = 2'b01;
localparam COMPLETE     = 2'b10;

reg [1:0] state, next_state;
    
// Contador de bytes recibidos
reg [1:0] byte_count;   // 2 bits para contar hasta 4 bytes

wire [7:0] dato_rx;     // Dato recibido desde el módulo UART
wire m_axis_tvalid;     // Señal que indica que un byte ha sido recibido
reg recibir;            // Señal de control para indicar que estamos listos para recibir

wire clk_uart;

UART_Nexys #(.DATA_WIDTH(8), .prescale(1303))(
    .CLK100MHZ(CLK100MHZ),
    .rst(rst),

    .dato_tx(8'b0), //Es de 8 bits por tanto se debe empaquetar el envío de la palabra
    .hay_dato_tx(), //Se activa cuando hay un dato ingresado para enviar
    //Para pruebas usar un led
    .transmitir(1'b0), //En alto transmite el dato, para pruebas un boton

    .dato_rx(dato_rx), 
    .m_axis_tvalid(m_axis_tvalid),
    .recibir(recibir), //NO afecta

    .rxd(rxd),
    .txd(txd),

    .tx_busy(),
    .rx_busy(rx_busy),
    .rx_overrun_error(),
    .rx_frame_error()
);

always @(posedge uart_inst.CLK200MHZ or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            byte_count <= 0;
            IN2_data <= 0;
            WR2_data <= 0;
            hold_ctrl<=0;
            recibir <= 0;
        end else begin
            state <= next_state;
        end
    end

    // Lógica de transición de estados
    always @(*) begin
        // Estado por defecto
        next_state = state;
        WR2_data = 0; // Inicializar WR2_data en 0
        hold_ctrl=0;
        recibir = 0;   // Inicializar recibir en 0

        case (state)
            IDLE: begin
                if (m_axis_tvalid && !rx_busy && reg_sel_i) begin
                    // Solo recibe si hay un dato válido y la UART no está ocupada
                    next_state = RECEIVE_BYTE; // Cambia a recibir byte completo
                    recibir = 1;  // Activa la recepción
                end
            end

            RECEIVE_BYTE: begin
                // Almacena el byte recibido en IN2_data
                IN2_data[(byte_count + 1) * 8 - 1 -: 8] = dato_rx; // Almacena en la posición correcta, de rango de un byte
                byte_count = byte_count + 1;

                // Cambia de estado si se han recibido 4 bytes
                if (byte_count == 2'b11) begin
                    next_state = COMPLETE;
                end else begin
                    next_state = IDLE; // Regresa a IDLE si aún no se han recibido 4 bytes
                end
            end

            COMPLETE: begin
                WR2_data = 1;   // Activa la escritura de datos
                hold_ctrl=1;       //AVERIGUAR FORMA DE DESACTIVAR 
                byte_count = 0; // Resetea el contador para la próxima recepción
                next_state = IDLE;  // Vuelve al estado inicial
            end
        endcase
    end
endmodule
