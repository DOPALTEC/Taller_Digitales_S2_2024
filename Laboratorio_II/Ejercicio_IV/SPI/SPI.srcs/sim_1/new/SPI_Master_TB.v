`timescale 1ns / 1ps

module SPI_Master_TB ();
  
  parameter SPI_MODE=3; // CPOL = 1, CPHA = 1
  parameter CLKS_PER_HALF_BIT=4;  // 6.25 MHz
  parameter MAIN_CLK_DELAY=2;  // 25 MHz
  
//reg son Inputs y wire son outputs

//SEÑALES PARA RELOJ FPGA
  reg r_Rst_L=1'b0; 
  reg r_Clk=1'b0; 
  
//BYTE A TRANSMITIR POR DISPOSITIVO #1
  reg [7:0] i_TX_Byte = 0; 
//PULSO QUE INDICA QUE SE PUEDE TRANSMITIR UN DATO
  wire o_TX_Ready;
//PULSO QUE CONTROLA QUE SE REALIZA LA TRANSMISION
  reg i_TX_DV = 1'b0;
//PULSO DE RELOJ QUE SE GENERA PARA LA TRANSMISION DEL DISPOSITIVO #1
  wire w_SPI_Clk;
//SEÑAL DE PULSOS QUE REPRESENTAN LOS BITS TRANSMITIDOS POR EL DISPOSITIVO #1
  wire w_SPI_MOSI;
//PULSO QUE INDICA QUE YA SE RECIBIO UN DATO PROVENIENTE DEL DISPOSITIVO #2
  wire o_RX_DV;
//BYTE RECUPERADO DE LA TRANSMISION PROVENIENTE DEL DISPOSITIVO #2 Y QUE RECIBE EL #1
  wire [7:0] o_RX_Byte;

//Inicializacion de señales para el segundo dispositivo
  reg [7:0] i_TX_Byte_2 = 0; 
  wire o_TX_Ready_2;
  reg i_TX_DV_2 = 1'b0;
  wire w_SPI_Clk_2;
  wire w_SPI_MOSI_2;
  wire o_RX_DV_2;
  wire [7:0] o_RX_Byte_2;


integer seed; //Semilla para generar valores aleatorios
reg [7:0] dato_disp1; // Primer valor aleatorio de 8 bits
reg [7:0] dato_disp2;

  // Generador de reloj Principal:
  always #(MAIN_CLK_DELAY) r_Clk = ~r_Clk;

  // Instancia del UUT (Unidad Bajo Prueba)
  SPI_Master 
  #(.SPI_MODE(SPI_MODE),
    .CLKS_PER_HALF_BIT(CLKS_PER_HALF_BIT)) SPI_Master_UUT
  (
   // Señales de control y datos,
   .i_Rst_L(r_Rst_L),     // Reset de FPGA
   .i_Clk(r_Clk),         // Reloj de FPGA
   
   // Señales de transmisión (MOSI)
   .i_TX_Byte(i_TX_Byte),     // Byte a transmitir en MOSI
   .i_TX_DV(i_TX_DV),         // Pulso de dato válido con i_TX_Byte
   .o_TX_Ready(o_TX_Ready),   // Señal de que la transmisión está lista para el próximo byte
   
   // Señales de recepción (MISO)
   .o_RX_DV(o_RX_DV),       // Pulso que indica que el dato a recibir es válido (1 ciclo de reloj)
   .o_RX_Byte(o_RX_Byte),   // Byte recibido desde MISO

   // Interfaz SPI
   .o_SPI_Clk(w_SPI_Clk),
   .i_SPI_MISO(w_SPI_MOSI_2),
   .o_SPI_MOSI(w_SPI_MOSI)
   );
   
/////////////////////////Generacion del Segundo Dispositivo///////////////////////////////////////

  SPI_Master 
  #(.SPI_MODE(SPI_MODE),
    .CLKS_PER_HALF_BIT(CLKS_PER_HALF_BIT)) SPI_Master_UUT2
  (
   // Señales de control y datos,
   .i_Rst_L(r_Rst_L),     // Reset de FPGA
   .i_Clk(r_Clk),         // Reloj de FPGA
   
   // Señales de transmisión (MOSI)
   .i_TX_Byte(i_TX_Byte_2),     // Byte a transmitir en MOSI
   .i_TX_DV(i_TX_DV_2),         // Pulso de dato válido con i_TX_Byte
   .o_TX_Ready(o_TX_Ready_2),   // Señal de que la transmisión está lista para el próximo byte
   
   // Señales de recepción (MISO)
   .o_RX_DV(o_RX_DV_2),       // Pulso que indica que el dato a recibir es válido (1 ciclo de reloj)
   .o_RX_Byte(o_RX_Byte_2),   // Byte recibido desde MISO

//AL SER DOS DISPOSITIVOS EL MISO DE UNO ES EL MOSI DEL OTRO
   // Interfaz SPI
   .o_SPI_Clk(w_SPI_Clk_2),
   .i_SPI_MISO(w_SPI_MOSI), //Entra lo transmitido por el dispositivo 1
   .o_SPI_MOSI(w_SPI_MOSI_2) //Sale la transmision para el dispositivo 1
   );
   
/////////////////////////////////////////////////////////////////////////////////////////////////
  //Funcion (task) encargada de simular el envio de un solo byte desde el maestro al ser referenciada PARA DISPOSITIVO 1
  task SendSingleByte(input [7:0] data, input [7:0] data_2); //Recibe como parametro el dato a enviar
    begin
      @(posedge r_Clk); //A la siguiente señal del reloj principal que pase de 0 a 1....
      i_TX_Byte <= data; //Le asigna a la transmision el dato que se quiere enviar
      i_TX_Byte_2 <= data_2;
      
      i_TX_DV   <= 1'b1; //En alto da la señal para iniciar la transmisión. Si "o_TX_Ready" esta en alto. 
      i_TX_DV_2   <= 1'b1; 
      @(posedge r_Clk); //Espera a la siguiente subida del ciclo de reloj para....
      i_TX_DV <= 1'b0; //Desactiva la señal ya que la transferencia de datos comenzo
      i_TX_DV_2 <= 1'b0; 
      @(posedge (o_TX_Ready && o_TX_Ready_2)); //Termina la operacion de la transferencia de datos cuando el indicador de que está listo para 
      //otra transmision este activo
    end
  endtask // SendSingleByte
  


  initial
    begin
      $dumpfile("dump.vcd"); // Define el nombre del archivo VCD, para uso de posibles registros visuales (EDA Playground)
      $dumpvars;// Comienza a grabar todas las señales
      
      seed = 32'h8AC639CF;
      
      dato_disp1=$random(seed);
      dato_disp2=$random(seed);
      
      repeat(10) @(posedge r_Clk); //En el siguiente ciclo de reloj...
      r_Rst_L  = 1'b0; //Resetear FPGA (Para este caso se resetea en bajo)
      repeat(10) @(posedge r_Clk);
      r_Rst_L  = 1'b1; //Deja la señal de reset desactivada en alto
      
      // Prueba con un solo byte
      SendSingleByte(dato_disp1, dato_disp2);
      #10000; //Espera a que se realicen las transmisiones y recepciones
      if((i_TX_Byte == o_RX_Byte_2)&&(i_TX_Byte_2 == o_RX_Byte))begin //Si el byte transmitido del dispositivo #1 es igual al recibido del #2 y viceversa...
        $display("Transmisiones y Recepciones Exitosas:\n|Dispositivo|---TX---|---RX---|\n|-----1-----|---%h---|---%h---|\n|-----2-----|---%h---|---%h---|", i_TX_Byte,o_RX_Byte,i_TX_Byte_2,o_RX_Byte_2); 
      end
      else begin
        $display("Error: Transmisiones y Recepciones Fallidas");
      end

      repeat(10) @(posedge r_Clk);
      $finish();      
    end // initial begin

endmodule // SPI_Master_TB
