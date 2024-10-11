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
    output reg WR2_ctrl,  
    //output reg add2,                // Señal de escritura para control
    

    // Dirección de salida
    //output reg [N-1:0] addr2,             // Salida de dirección
    //output reg addr2, //Esta direccion no cambia, corresponde a la direccion donde
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

UART_Nexys #(.DATA_WIDTH(8), .prescale(1303)) UART_Nexys_inst(
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

reg [15:0] timeout_counter;  // Un contador para el tiempo de espera

localparam TIMEOUT_LIMIT = 1000;  // Define un límite para el timeout (ajústalo según el reloj)

reg byte_rx_valido;

// Modificar la lógica del always @(posedge)
always @(posedge UART_Nexys_inst.CLK200MHZ or posedge rst) begin
    if (rst) begin
        state <= IDLE;
        byte_count <= 0;
        IN2_data <= 0;
        WR2_data <= 0;
        hold_ctrl <= 0;
        recibir <= 0;
        timeout_counter <= 0;  // Inicializa el contador de timeout
        byte_rx_valido<=0;
    end else begin
        byte_rx_valido<=m_axis_tvalid;
        state <= next_state;
        
        // Actualiza el contador de timeout
        if (state == RECEIVE_BYTE && !m_axis_tvalid) begin
            timeout_counter <= timeout_counter + 1;
        end else begin
            timeout_counter <= 0;  // Resetea el contador si está recibiendo un byte
        end
    end
end

// Modificar la lógica de los estados
always @(*) begin
    // Estado por defecto
    next_state = state;
    WR2_data = 0;  // Inicializar WR2_data en 0
    hold_ctrl = 0;
    recibir = 0;  // Inicializar recibir en 0

    case (state)
        IDLE: begin
            if (m_axis_tvalid && !rx_busy && reg_sel_i) begin
                next_state = RECEIVE_BYTE;
                recibir = 1;  // Activa la recepción
            end
        end

        RECEIVE_BYTE: begin
            // Almacena el byte recibido en IN2_data
            IN2_data[(byte_count + 1) * 8 - 1 -: 8] = dato_rx;
            if(byte_rx_valido)begin //////////////////////////Debe ser el m_axis_tvalid del ciclo anterior
                byte_count = byte_count + 1;
            end
            // Cambia a COMPLETE si se han recibido 4 bytes o si hay un timeout
            if (byte_count == 2'b11 || timeout_counter >= TIMEOUT_LIMIT) begin
                next_state = COMPLETE;
            end
            //end else if (timeout_counter >= TIMEOUT_LIMIT) begin
            //    next_state = COMPLETE;  // Fuerza el paso a COMPLETE si hay timeout
            //end else begin
            //    next_state = IDLE;
            //end
        end

        COMPLETE: begin
            WR2_data = 1;  // Activa la escritura de datos
            hold_ctrl = 1;  // Averiguar la forma de desactivar si es necesario
            byte_count = 0;  // Resetea el contador de bytes
            next_state = IDLE;
            byte_rx_valido=0;
        end
    endcase
end
endmodule