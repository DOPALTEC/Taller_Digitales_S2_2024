module SPI_Master
  #(parameter SPI_MODE = 0, //Configura el modo de funcionamiento del spi
    parameter CLKS_PER_HALF_BIT = 2)
  (
   // Señales de control de datos
   input        i_Rst_L,     // Reset activo bajo
   input        i_Clk,       // Reloj de la FPGA
   
   // Señales de transmisión (MOSI)
   input [7:0]  i_TX_Byte,        // Byte para transmitir en MOSI
   input        i_TX_DV,          // Pulso de validación de dato con i_TX_Byte
   output reg   o_TX_Ready,       // Señala que TX está listo para el siguiente byte de datos
   
   // Señales de recepción (MISO)
   output reg       o_RX_DV,     // Pulso de validación de dato (1 ciclo de reloj)
   output reg [7:0] o_RX_Byte,   // Byte recibido en MISO
   // Interfaz SPI
   output reg o_SPI_Clk,
   input      i_SPI_MISO,
   output reg o_SPI_MOSI
   );

  // Interfaz SPI (Corren con el dominio de reloj SPI)
  wire w_CPOL;     // Protocolo de polaridad de reloj
  wire w_CPHA;     // Protocolo de fase de reloj

  reg [$clog2(CLKS_PER_HALF_BIT*2)-1:0] r_SPI_Clk_Count;
  reg r_SPI_Clk;
  reg [4:0] r_SPI_Clk_Edges;
  reg r_Leading_Edge;
  reg r_Trailing_Edge;
  reg       r_TX_DV;
  reg [7:0] r_TX_Byte;

  reg [2:0] r_RX_Bit_Count;
  reg [2:0] r_TX_Bit_Count;

  // CPOL: Polaridad del reloj
  // CPOL=0 significa que el reloj está inactivo en 0, el flanco de subida es el flanco principal.
  // CPOL=1 significa que el reloj está inactivo en 1, el flanco de bajada es el flanco principal.
  assign w_CPOL  = (SPI_MODE == 2) | (SPI_MODE == 3);

  // CPHA: Fase del reloj
  // CPHA=0 significa que el lado "out" cambia los datos en el flanco de bajada del reloj
  //              el lado "in" captura datos en el flanco de subida del reloj
  // CPHA=1 significa que el lado "out" cambia los datos en el flanco de subida del reloj
  //              el lado "in" captura datos en el flanco de bajada del reloj
  assign w_CPHA  = (SPI_MODE == 1) | (SPI_MODE == 3);

  // Propósito: Generar el reloj SPI el número correcto de veces cuando el pulso de DV llega
  always @(posedge i_Clk or negedge i_Rst_L)
  begin
    if (~i_Rst_L)
    begin
      o_TX_Ready      <= 1'b0;
      r_SPI_Clk_Edges <= 0;
      r_Leading_Edge  <= 1'b0;
      r_Trailing_Edge <= 1'b0;
      r_SPI_Clk       <= w_CPOL; // asignar estado predeterminado al estado inactivo
      r_SPI_Clk_Count <= 0;
    end
    else
    begin
      // Asignaciones por defecto
      r_Leading_Edge  <= 1'b0;
      r_Trailing_Edge <= 1'b0;
      
      if (i_TX_DV)
      begin
        o_TX_Ready      <= 1'b0;
        r_SPI_Clk_Edges <= 16;  // Total de flancos en un byte SIEMPRE es 16
      end
      else if (r_SPI_Clk_Edges > 0)
      begin
        o_TX_Ready <= 1'b0;
        
        if (r_SPI_Clk_Count == CLKS_PER_HALF_BIT*2-1)
        begin
          r_SPI_Clk_Edges <= r_SPI_Clk_Edges - 1'b1;
          r_Trailing_Edge <= 1'b1;
          r_SPI_Clk_Count <= 0;
          r_SPI_Clk       <= ~r_SPI_Clk;
        end
        else if (r_SPI_Clk_Count == CLKS_PER_HALF_BIT-1)
        begin
          r_SPI_Clk_Edges <= r_SPI_Clk_Edges - 1'b1;
          r_Leading_Edge  <= 1'b1;
          r_SPI_Clk_Count <= r_SPI_Clk_Count + 1'b1;
          r_SPI_Clk       <= ~r_SPI_Clk;
        end
        else
        begin
          r_SPI_Clk_Count <= r_SPI_Clk_Count + 1'b1;
        end
      end  
      else
      begin
        o_TX_Ready <= 1'b1;
      end
    end // else: !if(~i_Rst_L)
  end // always @ (posedge i_Clk or negedge i_Rst_L)

  // Propósito: Registrar i_TX_Byte cuando el pulso de validación de datos es activado.
  // Mantiene el almacenamiento local del byte en caso de que un módulo de nivel superior cambie los datos
  always @(posedge i_Clk or negedge i_Rst_L)
  begin
    if (~i_Rst_L)
    begin
      r_TX_Byte <= 8'h00;
      r_TX_DV   <= 1'b0;
    end
    else
      begin
        r_TX_DV <= i_TX_DV; // Retraso de 1 ciclo de reloj
        if (i_TX_DV)
        begin
          r_TX_Byte <= i_TX_Byte;
        end
      end // else: !if(~i_Rst_L)
  end // always @ (posedge i_Clk or negedge i_Rst_L)

  // Propósito: Generar datos MOSI
  // Funciona con CPHA=0 y CPHA=1
  always @(posedge i_Clk or negedge i_Rst_L)
  begin
    if (~i_Rst_L)
    begin
      o_SPI_MOSI     <= 1'b0;
      r_TX_Bit_Count <= 3'b111; // enviar MSb primero
    end
    else
    begin
      // Si ready está alto, restablece la cuenta de bits a su valor predeterminado
      if (o_TX_Ready)
      begin
        r_TX_Bit_Count <= 3'b111;
      end
      // Captura el caso en el que comenzamos la transacción y CPHA = 0
      else if (r_TX_DV & ~w_CPHA)
      begin
        o_SPI_MOSI     <= r_TX_Byte[3'b111];
        r_TX_Bit_Count <= 3'b110;
      end
      else if ((r_Leading_Edge & w_CPHA) | (r_Trailing_Edge & ~w_CPHA))
      begin
        r_TX_Bit_Count <= r_TX_Bit_Count - 1'b1;
        o_SPI_MOSI     <= r_TX_Byte[r_TX_Bit_Count];
      end
    end
  end

  // Propósito: Leer los datos de MISO.
  always @(posedge i_Clk or negedge i_Rst_L)
  begin
    if (~i_Rst_L)
    begin
      o_RX_Byte      <= 8'h00;
      o_RX_DV        <= 1'b0;
      r_RX_Bit_Count <= 3'b111;
    end
    else
    begin
      // Asignaciones por defecto
      o_RX_DV   <= 1'b0;

      if (o_TX_Ready) // Verifica si ready está alto, si es así, restablece la cuenta de bits a su valor predeterminado
      begin
        r_RX_Bit_Count <= 3'b111;
      end
      else if ((r_Leading_Edge & ~w_CPHA) | (r_Trailing_Edge & w_CPHA))
      begin
        o_RX_Byte[r_RX_Bit_Count] <= i_SPI_MISO;  // Muestra los datos
        r_RX_Bit_Count            <= r_RX_Bit_Count - 1'b1;
        if (r_RX_Bit_Count == 3'b000)
        begin
          o_RX_DV   <= 1'b1;   // Byte completo, pulso de validación de datos
        end
      end
    end
  end
  
  // Propósito: Añadir retardo de reloj a las señales para alineación.
  always @(posedge i_Clk or negedge i_Rst_L)
  begin
    if (~i_Rst_L)
    begin
      o_SPI_Clk  <= w_CPOL;
    end
    else
      begin
        o_SPI_Clk <= r_SPI_Clk;
      end // else: !if(~i_Rst_L)
  end // always @ (posedge i_Clk or negedge i_Rst_L)
  
endmodule // SPI_Master
