`timescale 1ns / 1ps
//byte_count
module ctrl_UART #(parameter palabra = 8, parameter prescale = 2604)
(
    input  wire clk,
    input  wire rst,
    
    input wire locked,
    //input wire reg_sel_i,
    //input wire wr_i,
    //input wire addr_i,
    // Entradas
    input wire [palabra-1:0] ctrl,    // Entrada de control
    input wire [palabra-1:0] data,    // Entrada de datos

    // Salidas
    ///////Al Registro de Datos///////////////
    output wire [palabra-1:0] IN2_data,    // Salida de datos IN2
    output reg WR2_data,      
    output reg addr2,
    
    ///////Al Registro de Control///////////////
    output reg [palabra-1:0] IN2_ctrl,    // Salida de control IN2
    output reg WR2_ctrl,  
    
    output reg hold_ctrl,

    input  wire rxd, // Para el constraint
    output wire txd  // Para el constraint
);


    // Señales UART
    wire hay_dato_tx;
    reg transmitir; // Cambiado a reg
    wire m_axis_tvalid; 
    reg recibir;  // Cambiado a reg
    wire tx_busy;
    wire rx_busy;

    
    UART_Nexys #(
        .DATA_WIDTH(8), 
        .prescale(prescale)
    ) UART_Nexys_inst (
        .clk(clk),
        .rst(rst),
        .locked(locked),
        .dato_tx(data), // Es de 8 bits por tanto se debe empaquetar el envío de la palabra
        .hay_dato_tx(hay_dato_tx), // Se activa cuando hay un dato ingresado para enviar
        .transmitir(transmitir), // En alto transmite el dato, para pruebas un botón

        .dato_rx(IN2_data), 
        .m_axis_tvalid(m_axis_tvalid),
        .recibir(recibir), // NO afecta

        .rxd(rxd),
        .txd(txd),

        .tx_busy(tx_busy),
        .rx_busy(rx_busy),
        .rx_overrun_error(),
        .rx_frame_error()
    );
    
    localparam IDLE=2'b00;
    localparam RECEIVE_BYTE = 2'b01;
    localparam TRANSMIT = 2'b11;
    
    reg send;
    
    reg new_rx;
    
    ////Detecta Cambio de Flanco en m_axis_tvalid
    reg m_axis_tvalid_d;
    wire m_axis_tvalid_edge;
    assign m_axis_tvalid_edge = ~m_axis_tvalid_d & m_axis_tvalid;
    ////Detecta Cambio de Flanco en Transmitir
    reg send_d;
    wire send_edge;
    assign send_edge = send & ~send_d;
    
    reg hay_dato_tx_d;
    wire hay_dato_tx_edge;
    assign hay_dato_tx_edge = !hay_dato_tx_d & hay_dato_tx;
    // Logica secuencial para transmisión y control de UART
    always @(posedge clk or posedge rst) begin
        if (rst || !locked) begin
            send_d<=0;
            transmitir <= 0;
            recibir <= 0;
            WR2_data <= 0;
            addr2 <= 0;
            IN2_ctrl <= 0;     // Inicializa IN2_ctrl en 0
            WR2_ctrl <= 0;     // Inicializa WR2_ctrl en 0
            new_rx<=0;
            send<=0;
            m_axis_tvalid_d<=0;
            hay_dato_tx_d <= 0; 
        end else begin
            m_axis_tvalid_d <= m_axis_tvalid; //Almacena el estado anterior de m_axis_tvalid
            send_d<=send; //Almacena el Estado anterior de send
            hay_dato_tx_d<=hay_dato_tx;
            
            if (send_edge) begin
                
                transmitir <= 1;  // Pulso de un ciclo
            end else begin
                transmitir <= 0;  // Volver a 0 después del pulso
            end
            
            WR2_data <= 0;      
            addr2 <= 0;
            WR2_ctrl <= 0; // Inicializa WR2_ctrl

            if (hay_dato_tx_edge && ctrl[0]) begin
                send <= 0; // Desactiva send cuando hay_dato_tx pase de 0 a 1
            end
            else begin 
                send<=ctrl[0];
            end
            

                
            if (m_axis_tvalid) begin
                new_rx<=1; 
                IN2_ctrl[1] <= new_rx; 
                WR2_ctrl <= 1; //Genera solo un pulso de un ciclo para escribir       
            end 
        end
    end
endmodule   