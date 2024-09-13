module SPI_Master_TB ();
  
  parameter SPI_MODE=3; // CPOL = 1, CPHA = 1
  parameter CLKS_PER_HALF_BIT=4;  // 6.25 MHz
  parameter MAIN_CLK_DELAY=2;  // 25 MHz
  
//reg son Inputs y wire son outputs


  reg r_Rst_L=1'b0; 
  reg r_Clk=1'b0; 
  wire w_SPI_Clk;
  wire w_SPI_MOSI;

  // Se�ales espec�ficas del maestro
  reg [7:0] i_TX_Byte = 0; 
  reg i_TX_DV = 1'b0;
  wire o_TX_Ready;
  wire o_RX_DV;
  wire [7:0] o_RX_Byte;

  // Generador de reloj Principal:
  always #(MAIN_CLK_DELAY) r_Clk = ~r_Clk;

  // Instancia del UUT (Unidad Bajo Prueba)
  SPI_Master 
  #(.SPI_MODE(SPI_MODE),
    .CLKS_PER_HALF_BIT(CLKS_PER_HALF_BIT)) SPI_Master_UUT
  (
   // Se�ales de control y datos,
   .i_Rst_L(r_Rst_L),     // Reset de FPGA
   .i_Clk(r_Clk),         // Reloj de FPGA
   
   // Se�ales de transmisi�n (MOSI)
   .i_TX_Byte(i_TX_Byte),     // Byte a transmitir en MOSI
   .i_TX_DV(i_TX_DV),         // Pulso de dato v�lido con i_TX_Byte
   .o_TX_Ready(o_TX_Ready),   // Se�al de que la transmisi�n est� lista para el pr�ximo byte
   
   // Se�ales de recepci�n (MISO)
   .o_RX_DV(o_RX_DV),       // Pulso de dato v�lido (1 ciclo de reloj)
   .o_RX_Byte(o_RX_Byte),   // Byte recibido desde MISO

   // Interfaz SPI
   .o_SPI_Clk(w_SPI_Clk),
   .i_SPI_MISO(w_SPI_MOSI),
   .o_SPI_MOSI(w_SPI_MOSI)
   );

  //Funcion (task) encargada de simular el envio de un solo byte desde el maestro al ser referenciada
  task SendSingleByte(input [7:0] data); //Recibe como parametro el dato a enviar
    begin
      @(posedge r_Clk); //A la siguiente se�al del reloj principal que pase de 0 a 1....
      i_TX_Byte <= data; //Le asigna a la transmision el dato que se quiere enviar
      i_TX_DV   <= 1'b1; //En alto da la se�al para iniciar la transmisi�n. Si "o_TX_Ready" esta en alto. 
      @(posedge r_Clk); //Espera a la siguiente subida del ciclo de reloj para....
      i_TX_DV <= 1'b0; //Desactiva la se�al ya que la transferencia de datos comenzo
      @(posedge o_TX_Ready); //Termina la operacion de la transferencia de datos cuando el indicador de que est� listo para 
      //otra transmision este activo
    end
  endtask // SendSingleByte

  initial
    begin
      $dumpfile("dump.vcd"); // Define el nombre del archivo VCD, para uso de posibles registros visuales (EDA Playground)
      $dumpvars;// Comienza a grabar todas las se�ales
      
      repeat(10) @(posedge r_Clk); //En el siguiente ciclo de reloj...
      r_Rst_L  = 1'b0; //Resetear FPGA (Para este caso se resetea en bajo)
      repeat(10) @(posedge r_Clk);
      r_Rst_L  = 1'b1; //Deja la se�al de reset desactivada en alto
      
      // Prueba con un solo byte
      SendSingleByte(8'hC1);
      $display("Enviado 0xC1, Recibido 0x%X", o_RX_Byte); 
      
      // Prueba con doble byte
      SendSingleByte(8'hBE);
      $display("Enviado 0xBE, Recibido 0x%X", o_RX_Byte); 
      SendSingleByte(8'hEF);
      $display("Enviado 0xEF, Recibido 0x%X", o_RX_Byte); 
      repeat(10) @(posedge r_Clk);
      $finish();      
    end // initial begin

endmodule // SPI_Master_TB
