`timescale 1ns / 1ps
//byte_count
module ctrl_UART #(parameter palabra = 32, parameter prescale = 1302)
(
    input  wire clk,
    input  wire rst,
    
    input wire locked,
    input wire reg_sel_i,
    input wire wr_i,
    input wire addr_i,
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


    // Se�ales UART
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
        .dato_tx(data[7:0]), // Es de 8 bits por tanto se debe empaquetar el env�o de la palabra
        .hay_dato_tx(hay_dato_tx), // Se activa cuando hay un dato ingresado para enviar
        .transmitir(transmitir), // En alto transmite el dato, para pruebas un bot�n

        .dato_rx(IN2_data[7:0]),
        .m_axis_tvalid(m_axis_tvalid),
        .recibir(recibir), // NO afecta

        .rxd(rxd),
        .txd(txd),

        .tx_busy(tx_busy),
        .rx_busy(rx_busy),
        .rx_overrun_error(),
        .rx_frame_error()
    );
    
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
    
    reg tx_busy_d;           // Almacena el estado anterior de tx_busy
    wire tx_busy_edge;       // Detecta cambio en tx_busy
    reg pulse_wr2_ctrl;      // Pulso de un ciclo para WR2_ctrl
    assign tx_busy_edge = tx_busy ^ tx_busy_d;
    // Logica secuencial para transmisi�n y control de UART
    always @(posedge clk or posedge rst) begin
        if (rst) begin
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
            hold_ctrl<=0;
            //IN2_data<=0;
            tx_busy_d <= 0;
            pulse_wr2_ctrl <= 0;
            IN2_ctrl[2] <= 0;
        end else begin
            m_axis_tvalid_d <= m_axis_tvalid; //Almacena el estado anterior de m_axis_tvalid
            send_d<=send; //Almacena el Estado anterior de send
            hay_dato_tx_d<=hay_dato_tx;
            tx_busy_d <= tx_busy;
            
            if (send_edge) begin
                
                transmitir <= 1;  // Pulso de un ciclo
            end else begin
                transmitir <= 0;  // Volver a 0 despu�s del pulso
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
            

            if (tx_busy) begin
                //if (IN2_ctrl[2])begin
                //    WR2_ctrl <= 0;
                //end
                //else begin
                    WR2_ctrl <= 1;
                //end  
                IN2_ctrl[2] <=1;
            end else begin
                if (IN2_ctrl[2])begin
                    WR2_ctrl <= 1;
                end
                else begin
                    WR2_ctrl <= 0;
                end  
                IN2_ctrl[2] <=0;
            end

                
            if (m_axis_tvalid) begin
                hold_ctrl<=1; 
                if(reg_sel_i && addr_i)begin //Se solicita el dato rx
                    new_rx<=0;
                    IN2_ctrl[1] <= new_rx;
                    WR2_ctrl <= 1;
                    WR2_data<=1;
                    addr2<=1;
                    recibir<=1;      
                    
                end
                else begin 
                    new_rx<=1; 
                    IN2_ctrl[1] <= new_rx; 
                    WR2_ctrl <= 1;
                    WR2_data<=1;
                    addr2<=1; 
                end 
            end
            else begin
                WR2_data<=0;
                addr2<=0;
                recibir<=0;  
                if(reg_sel_i && !addr_i && wr_i)begin
                    hold_ctrl<=0;
                end
            end
        end
    end
endmodule   