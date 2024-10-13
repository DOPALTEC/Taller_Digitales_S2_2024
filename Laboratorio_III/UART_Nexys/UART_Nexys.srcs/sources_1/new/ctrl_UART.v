`timescale 1ns / 1ps

module ctrl_UART #(
    parameter palabra = 32  // Tamaño por defecto de la palabra
    //parameter N = 2         // Tamaño por defecto de addr2
   
)(
    input  wire CLK100MHZ,
    input  wire rst,
    input wire reg_sel_i,
    input wire wr_i,
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
localparam COMPLETE = 2'b10;
localparam TRANSMIT = 2'b11;

reg [1:0] state, next_state;
    
// Contador de bytes recibidos
reg [1:0] byte_count;   // 2 bits para contar hasta 4 bytes
reg [7:0] dato_tx;
wire [7:0] dato_rx;     // Dato recibido desde el módulo UART
wire m_axis_tvalid;     // Señal que indica que un byte ha sido recibido
reg recibir;            // Señal de control para indicar que estamos listos para recibir
reg transmitir;
wire tx_busy;
wire hay_dato_tx;

UART_Nexys #(.DATA_WIDTH(8), .prescale(1303)) UART_Nexys_inst(
    .CLK100MHZ(CLK100MHZ),
    .rst(rst),

    .dato_tx(dato_tx), //Es de 8 bits por tanto se debe empaquetar el envío de la palabra
    .hay_dato_tx(hay_dato_tx), //Se activa cuando hay un dato ingresado para enviar
    //Para pruebas usar un led
    .transmitir(transmitir), //En alto transmite el dato, para pruebas un boton

    .dato_rx(dato_rx), 
    .m_axis_tvalid(m_axis_tvalid),
    .recibir(recibir), //NO afecta

    .rxd(rxd),
    .txd(txd),

    .tx_busy(tx_busy),
    .rx_busy(rx_busy),
    .rx_overrun_error(),
    .rx_frame_error()
);

reg [15:0] timeout_counter;  // Un contador para el tiempo de espera

localparam TIMEOUT_LIMIT = 1000;  // Define un límite para el timeout (ajústalo según el reloj) 
/*

DAR ALMENOS 3 BITS EN RX QUE NO SE RECIBE NADA, IR PROBRANDO AL TENER LA RECPCION EN PC REAL

*/

reg byte_rx_valido;


/*
Si rx se mantiene en alto, osea que no se recibe nada, que esté pendiente de si se quiere realizar una transmision
despues de una recepcion se transmite, la prioridad será la recepcion. El cual se escribira en control o datos 
dependiendo de reg_sel_i y si rx baja se mantiene el hold_ctrl en 1 hasta que byte_rx_valido

*/
reg send;
reg new_rx;

always @(posedge UART_Nexys_inst.CLK200MHZ or posedge rst) begin
    if (rst) begin
        state <= IDLE;
        byte_count <= 0;
        hold_ctrl <= 0;
        //////Reinicia Bits para Recepcion////
        //dato_rx<=0;
        WR2_data <= 0;
        IN2_data <= 0;
        recibir <= 0;
        //////Reinicia Bits para Transmisuin////
        WR2_ctrl=0;
        IN2_ctrl<=0;
        transmitir<=0;
        timeout_counter <= 0;  // Inicializa el contador de timeout
        byte_rx_valido<=0;
        send=0;
        new_rx=0;
    end else begin
        byte_rx_valido<=m_axis_tvalid;
        state <= next_state;
        
        // Actualiza el contador de timeout
        if (state == RECEIVE_BYTE && !m_axis_tvalid) begin
            timeout_counter <= timeout_counter + 1;
        end else begin
            timeout_counter <= 0;  // Resetea el contador si está recibiendo un byte
        end
        
        // Almacena el byte recibido solo si byte_rx_valido (m_axis_tvalid del ciclo anterior) es alto
        if (state == RECEIVE_BYTE && byte_rx_valido) begin
            //dato_rx<=dato_rx;
            IN2_data[(byte_count + 1) * 8 - 1 -: 8] <= dato_rx;  // Almacena el byte en la posición correcta
            byte_count <= byte_count + 1;  // Incrementa el contador después de almacenar el byte
        end
        
    end
end

// Modificar la lógica de los estados
always @(*) begin
    ///limpia el valor new_rx si hay un dato y si se solicita
    send=ctrl[0];
    if(new_rx && reg_sel_i && hold_ctrl && !wr_i)begin
        WR2_ctrl=1;
        new_rx=0;
        IN2_ctrl[1]=new_rx;
        
    end
    // Estado por defecto
    next_state = state;
    
    //////////////////VALORES SE REINICIAN CADA CICLO EVITAN LA ESCRITURA COMPLETA EN REGDATA////////////////////
    WR2_data = 0;  // Inicializar WR2_data en 0
    hold_ctrl = 0;
    recibir = 0;  // Inicializar recibir en 0
    //Transmision
    //WR2_ctrl=0;
    transmitir=0;


    case (state)
        IDLE: begin
            if (m_axis_tvalid && !rx_busy && !tx_busy) begin //Si no se esta transmitiendo ni recibiendo y hay un byte ya recibido
                ///////Registra que se recibio un dato en new_rx
                recibir = 1;  // Activa la recepción

                next_state = RECEIVE_BYTE;
            end
            else if (!m_axis_tvalid && !rx_busy && !tx_busy && hay_dato_tx && send==1) begin
                dato_tx<=data[7:0];
                next_state = TRANSMIT;
            end
        end

        RECEIVE_BYTE: begin
            if (byte_count == 2'b11 || timeout_counter >= TIMEOUT_LIMIT) begin
                WR2_ctrl=1;
                new_rx=1;
                IN2_ctrl[1]=new_rx;
                
                next_state = COMPLETE;
            end
        end

        COMPLETE: begin
            WR2_data = 1;  // Activa la escritura de datos
            hold_ctrl = 1;  // Averiguar la forma de desactivar si es necesario
            byte_count = 0;  // Resetea el contador de bytes
            next_state = IDLE;
        end
        
        TRANSMIT: begin
            transmitir=1;
            //Limpia el bit send al transmitir dato
            WR2_ctrl=1;
            send=0;
            IN2_ctrl[0]=send;
            //////////////

            if (!tx_busy) begin  // Espera hasta que la transmisión termine (tx_busy = 0)
                next_state = IDLE;  // Vuelve al estado IDLE cuando la transmisión se completa
            end
        end
            
    endcase
end
endmodule