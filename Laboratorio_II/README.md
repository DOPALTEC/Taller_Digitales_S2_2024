# LABORATORIO 2 

## 1. Abreviaturas y definiciones
- **FPGA**: Field Programmable Gate Arrays

## 2. Referencias
[0] David Harris y Sarah Harris. *Digital Design and Computer Architecture. RISC-V Edition.* Morgan Kaufmann, 2022. ISBN: 978-0-12-820064-3

https://learn.lushaylabs.com/tang-nano-9k-debugging/

Añadir referencia del ST7789V

# Ejercicio 1

#### 1. Encabezado del módulo
```SystemVerilog
module top_module (
    input wire clk,       
    input wire rst_n,     
    input wire key_in,    
    output wire [7:0] count 
);
```
#### 2. Parámetros
- N/A

#### 3. Entradas y salidas:
- `clk`: Reloj del Sistema.
- `rst_n`: Reinicio del Sistema.
- `key_in`: Entrada que indica si se ha presionado una tecla.
- `count`: Registro de 8 bits que se utiliza para contar mientras no se haya presionado ninguna tecla.

#### 4. Criterios de diseño
Se solicita un diseño antirebotes que sincronice las entradas provenientes de pulsadores.

[![Captura-de-pantalla-2024-09-30-235824.png](https://i.postimg.cc/4yWcqqf7/Captura-de-pantalla-2024-09-30-235824.png)](https://postimg.cc/H87j7S7d)

El parámetro DEBOUNCE_TIME del módulo de debounce debe ajustarse en función de la frecuencia del reloj para asegurar que el tiempo de debounce sea adecuado para el botón físico.

El reset debe ser activo en bajo (cuando está en cero), y el enable (key_pressed) activo en alto (1).

Si no hay ninguna tecla presionada, el contador (count) suma un bit en cada ciclo del reloj, y si se presiona, se mantiene su valor actual.

#### 5. Testbench

[![Top1.png](https://i.postimg.cc/CLdSbXqZ/Top1.png)](https://postimg.cc/HVGqgS3H)

Análisis de la Señal count

-La señal de `rst_n` se mantiene en alto (1) durante toda la simulación, lo que significa que el sistema no está siendo reiniciado. 
-La señal `key_in` comienza en 0 (indicando que el botón no está presionado). Alrededor de los **100 ms**, la señal se pone en alto (1). Esto significa que, a partir de ese momento, el botón está presionado.Hay fluctuaciones, lo que simula el rebote típico de un botón físico. Finalmente se mantiene estable.
-El valor del contador comienza en 00000000. Su valor incrementa con el tiempo mientras la señal `key_in` está en bajo (el botón no está presionado).
-Al activarse la señal `key_in` el contador se detiene, manteniendo su valor actual (00011100).

# Ejercicio 2

#### 1. Encabezado del módulo
```SystemVerilog
module top (
    input clk,
    input rst_n,
    input [1:0] enable, 
    output [1:0] count,
    output reg count_bit1_reg,
    output reg count_bit0_reg,
    output reg enable_bit1_reg,
    output reg enable_bit0_reg
);
```
#### 2. Parámetros
N/A

#### 3. Entradas y salidas:
- `clk`: Reloj del Sistema
- `rst_n`: Reinicio del Sistema
- `enable`: Registro de entrada que representa en una codificación de 2 bits la fila presionada del teclado.
- `count`: Registro de salida que representa en una codificación de 2 bits la columna habilitada por el contador.
- `count_bit1_reg`: Registro que guarda el bit más significativo del contador para mostrar la codificación de la tecla presionada.
- `count_bit0_reg`: Registro que guarda el bit menos significativo del contador para mostrar la codificación de la tecla presionada.
- `enable_bit1_reg`: Registro que guarda el bit más significativo del enable para mostrar la codificación de la tecla presionada.
- `count_bit0_reg`: Registro que guarda el bit menos significativo del enable para mostrar la codificación de la tecla presionada.

#### 4. Criterios de diseño
Se solicita un sistema compuesto por un contador de 2 bits, antirebote, divisor de reloj y codificador de tecla, que indique si se ha presionado una tecla y que muestre por medio de leds la tecla presionada en código binario.
Se muestran sus respectivas tablas de verdad, diagramas de estados y diagramas temporales.
##### Contador 2 bits
Tabla de Verdad

[![Captura-de-pantalla-2024-09-30-235330.png](https://i.postimg.cc/Kv5pv8zB/Captura-de-pantalla-2024-09-30-235330.png)](https://postimg.cc/rKKNfc5w)

Tabla de Transición de Estados

[![Captura-de-pantalla-2024-09-30-235409.png](https://i.postimg.cc/W1HnhFPF/Captura-de-pantalla-2024-09-30-235409.png)](https://postimg.cc/75S7RLhw)

Tabla de Salida

[![Captura-de-pantalla-2024-09-30-235330.png](https://i.postimg.cc/Kv5pv8zB/Captura-de-pantalla-2024-09-30-235330.png)](https://postimg.cc/rKKNfc5w)

Diagrama de Estados

[![Captura-de-pantalla-2024-09-30-235944.png](https://i.postimg.cc/HkyJ9Vy7/Captura-de-pantalla-2024-09-30-235944.png)](https://postimg.cc/87TP1kw1)

Diagrama Temporal

[![Captura-de-pantalla-2024-10-01-094022.png](https://i.postimg.cc/Xvx30mH4/Captura-de-pantalla-2024-10-01-094022.png)](https://postimg.cc/VSS2qGPV)

##### Divisor de Reloj

Tabla de Verdad

[![Captura-de-pantalla-2024-10-01-100927.png](https://i.postimg.cc/FHqGK5GN/Captura-de-pantalla-2024-10-01-100927.png)](https://postimg.cc/9Ddyxkvn)

Tabla de Transición de Estados

[![Captura-de-pantalla-2024-10-01-103455.png](https://i.postimg.cc/HLjMVBBm/Captura-de-pantalla-2024-10-01-103455.png)](https://postimg.cc/2qRytds9)

Tabla de Salida

[![Captura-de-pantalla-2024-10-01-103948.png](https://i.postimg.cc/k5HFvB5k/Captura-de-pantalla-2024-10-01-103948.png)](https://postimg.cc/QBpTXN1b)

Diagrama de Transición de Estados

[![Captura-de-pantalla-2024-10-01-105134.png](https://i.postimg.cc/GtHWSBPG/Captura-de-pantalla-2024-10-01-105134.png)](https://postimg.cc/0K1XzyBy)

Diagrama Temporal

[![Captura-de-pantalla-2024-10-01-094835.png](https://i.postimg.cc/yd1vRryQ/Captura-de-pantalla-2024-10-01-094835.png)](https://postimg.cc/cKzRyhjw)

##### Antirebote

Tabla de Verdad

[![Captura-de-pantalla-2024-10-01-110108.png](https://i.postimg.cc/1RgKWch4/Captura-de-pantalla-2024-10-01-110108.png)](https://postimg.cc/V58MvtNc)

Tabla de Transición de Estados

[![Captura-de-pantalla-2024-10-01-110242.png](https://i.postimg.cc/J4Z58rhL/Captura-de-pantalla-2024-10-01-110242.png)](https://postimg.cc/RNCHQzfs)

Tabla de Salida

[![Captura-de-pantalla-2024-10-01-110334.png](https://i.postimg.cc/2SYF8sqB/Captura-de-pantalla-2024-10-01-110334.png)](https://postimg.cc/hfC7231S)

Diagrama de Transición de Estados

[![Captura-de-pantalla-2024-10-01-105902.png](https://i.postimg.cc/J0dch0kr/Captura-de-pantalla-2024-10-01-105902.png)](https://postimg.cc/8fMrK149)

Diagrama Temporal

[![Captura-de-pantalla-2024-10-01-110537.png](https://i.postimg.cc/HLswbb9Y/Captura-de-pantalla-2024-10-01-110537.png)](https://postimg.cc/G4VTC8fV)

##### Codificador de Tecla

[![Captura-de-pantalla-2024-10-01-110820.png](https://i.postimg.cc/gkF3NCHB/Captura-de-pantalla-2024-10-01-110820.png)](https://postimg.cc/0rn6NH3p)

#### 5. Testbench

Decodificador de 2 a 4

[![Captura-de-pantalla-2024-10-01-194949.png](https://i.postimg.cc/CLvK790y/Captura-de-pantalla-2024-10-01-194949.png)](https://postimg.cc/nCDZcRMT)

Contador de 2 bits

[![Captura-de-pantalla-2024-10-01-200113.png](https://i.postimg.cc/CMCK9zGV/Captura-de-pantalla-2024-10-01-200113.png)](https://postimg.cc/V561CsZ7)

Antirebote

[![Captura-de-pantalla-2024-10-01-204245.png](https://i.postimg.cc/LXHWXCbD/Captura-de-pantalla-2024-10-01-204245.png)](https://postimg.cc/Jy2xYqmH)

Divisor de Reloj

[![Captura-de-pantalla-2024-10-01-211424.png](https://i.postimg.cc/Pr21s6Wh/Captura-de-pantalla-2024-10-01-211424.png)](https://postimg.cc/BXPj2B7w)

Codificador de 4 a 2 

[![Captura-de-pantalla-2024-10-01-213640.png](https://i.postimg.cc/rmP7PGf9/Captura-de-pantalla-2024-10-01-213640.png)](https://postimg.cc/qh2mtKVt)

#### 6. Implementación Física

["Laboratorio_II/Ejercicio_II/README.md"
](https://github.com/DOPALTEC/Taller_Digitales_S2_2024/blob/main/Laboratorio_II/Ejercicio_II/README.md)

# Ejercicio 3


## 1. Desarrollo


### 1.1 Módulo de la Transmisión UART
#### 1. Encabezado del módulo
```SystemVerilog
module uart #(
    input  wire                   clk,
    input  wire                   rst,
    input  wire [DATA_WIDTH-1:0]  s_axis_tdata,
    input  wire                   s_axis_tvalid,
    output wire                   s_axis_tready,
    output wire [DATA_WIDTH-1:0]  m_axis_tdata,
    output wire                   m_axis_tvalid,
    input  wire                   m_axis_tready,
    input  wire                   rxd,
    output wire                   txd,
    output wire                   tx_busy,
    output wire                   rx_busy,
    output wire                   rx_overrun_error,
    output wire                   rx_frame_error,
    input  wire [15:0]            prescale

);
```
#### 2. Parámetros
- `DATA_WIDTH`: Indica el tamaño de los mensajes a enviar y transmitir.

#### 3. Entradas y salidas:
- `clk`: Señal de reloj que controla el protocolo UART
- `rst`: Pulso que controla el reset del reloj
- `s_axis_tdata`: Dato a enviar desde la FPGA con tamaño indicado por el parámetro "DATA_WIDTH". Los bits corresponden a los switches de la FPGA
- `s_axis_tvalid`: En alto, inicia la transmisión del UART a el otro dispositivo. En bajo finaliza la transmisión
- `s_axis_tready`: Indica que la transmisión se está realizando si se encuentra en bajo. En alto, indica que no hay transisión. O bien no ha comenzado o ya finalizó
- `m_axis_tdata`: Recolecta los bits que la FPGA recibe del dispositivo externo y los empaqueta en un solo dato
- `m_axis_tvalid`: Señal de control que indica cuándo el módulo UART tiene datos válidos disponibles en "m_axis_tdata" para ser transferidos. Cuando "m_axis_tvalid" es 1, significa que los datos presentes en "m_axis_tdata" son válidos y pueden ser leídos por el receptor o el siguiente módulo en la cadena de comunicación.
- `m_axis_tready`: Controla la recepción de datos. Indica en alto que se solicitan recibir bits. En bajo, que no está ocurriendo la recepción
- `rxd`: Muestra los bits que se están recibiendo en un determinado ciclo. Representa la cadena de bits que se reciben
- `txd`: Bit correspondiente a el valor que se está transmitiendo durante uno de los ciclos de transmisión. Juntos representan una cadena de bits que se están enviando
- `tx_busy`: Indica en alto que la transmisión está ocurriendo
- `rx_busy`: Indica en alto que la recepción está ocurriendo
- `rx_overrun_error`: Indicador que detecta un desbordamiento en el receptor, recibe un nuevo bit antes de que el anterior sea procesado
- `rx_frame_error`: Habilita el pulso de error cuando se detecta una violación en la estructura esperada de la cadena de datos. No detecta ya sea el bit de inicio o de parada.
- `prescale`: Designa la velocidad en la que el protocolo opera



#### 4. Criterios de diseño

Para plantear un diseño compatible tanto con el teclado, la computadora externa, la fpga y los leds se relacionan las entradas y salidas escenciales físicas del módulo UART propuesto. 
- DATA_WIDTH-1:  Ancho de las señales a transmitir y recibir.
- s_axis_tdata: Representa el dato ingresado con las teclas, y almacenado en una cadena de bits con un ancho denotado por el parámetro. Este dato es el que será transmitido hacia la computadora, el cual tx recorrerá bit por bit para enviarlo de manera serial.
- s_axis_tvalid: Corresponde a el bit de activación de la transmisión de los datos que se ingresaron con el teclado externo. 
- m_axis_tdata: Cadena de bits la cual almacena los bits que se reciben para así enviarlos a los leds de la fpga.
- m_axis_tready: Controla la recepción de datos enviados desde la computadora a la fpga.
- RX (rxd): Bit que representa el valor de uno de los bits recibidos en un determinado ciclo de reloj.
- TX (txd): Pulso que en un tiempo específico muestra el valor de uno de los bits correspondientes al dato a transmitir proveniente del teclado.
- clk: Pulso de reloj para realizar la transmisión.

Es necesario que los datos intruducidos tengan un significado en el codigo hexadecimal para poder ser almacenados en una cadena de bits para que el UART pueda reconocerlos por eso mediante ese codificador, se reciben datos en las teclas que se traducen a un codigo hexadecimal de ancho "DATA_WIDTH-1".

![diagrama_uart](https://github.com/user-attachments/assets/1a6ec625-ac0e-490c-a076-4e89cdfb079d)

Para que se trabaje con una Tang Nano 9k se debe aplicar un valor del "prescale" distinto que el que se usó para el test bench ya que para esas pruebas se utilizó un reloj de 100MHz. Para el caso de la TangNano son 27MHz, por ello:



$$ 
prescale = \frac{F_{clock}}{baudios*8} 
$$

$$ 
prescale = \frac{27000000}{9600*8} = 351
$$



#### 5. Testbench
Se deben sincronizar las pruebas a 9600 baudios para poder obtener correctamente los resultados. Se tiene un reloj de 100MHz para las pruebas y se está trabajando con una escala de tiempo de 1ns / 1ps, por tanto el valor de "prescale" y de los tiempos entre cada bit que se recibe para simular la lectura de bits se deben calcular como:


$$ 
T_{bits} = \frac{1}{9600} [\frac{s_{bit}}{baudios}] = 104167 [ns]
$$

Por tanto el tiempo en la escala entre cada bit enviado es de 104167ns. Para la escala de el módulo, se procede a dividir entre la cantidad de bits a enviar en este caso, 8 bits:

$$
Prescale=\frac{104167}{8}=1302
$$


Antes de aplicar un testbench autoverificable a manera de una mayor comprensión se muestra una prueba de manera "manual".

Se puede observar la inicialización de los dos procesos tanto rx como tx los cuales son controlados con los bits de entrada "m_axis_tready" y "s_axis_tvalid" respectivamente. Despues de que el botón del reseteo del reloj se inactiva. Estos bits de entrada desencadenan la comunicación y otra señales que indican el estado de la misma. 

![tb_uart_0](https://github.com/user-attachments/assets/c66440ae-b5e0-48cc-99b9-614bdf506078)

A gran escala, se puede observar la transmisión a 9600 baudios ó 104167ns por bit. Se observa que para el caso de la transmisión se envía el dato hexadecimal 0xA5 el cual tiene su equivalente en binario como 1010 0101, y contanto con el start bit (0) y el stop bit (1), un valor binario de 0 1010 0101 1. Este valor se observa en la señal tx. Análogamente para la señal recibida se simula que se están recibiendo bits iniciando por el bit menos significativo de el dato a recibir, osea invertido. Para esta prueba se usó el numero 0xDA, traducido como 1101 1010 lo cual se tiene invertido en el pulso rx, mostrado como 0101 1011 y con los bits de inicio y parada el equivalente a 0 0101 1011 1.

![tb_uart_I](https://github.com/user-attachments/assets/96f5890d-1f85-4e46-b403-c4b417187de6)

- LOTE I Autoverificable

  Utilizando la semilla:
```verilog
    seed = 32'h6C1322A8;
```

A pequeña escala se tienen entonces los pulsos:

![image](https://github.com/user-attachments/assets/82028687-66a0-4da3-8db5-b95e5cf29072)



Y a gran escala:
![image](https://github.com/user-attachments/assets/39e4cd2d-0e6c-40bc-a6b0-d8df23f6f7f9)


```bash
Optimizing...
Building models...
PLI/VPI access: +b
Simulation time precision is 1ps.
  [3/4] module tb_uart#(8): 34 functions, 203 basic blocks
Linking image.so...
Using default typical min/typ/max.
=S:Begin run-time elaboration and static initialization...
=N:[dumpMXD] preparing MXD dump to 'waves.mxd'.
=N:[dump] Dump started at time 0
=N:Starting event scheduler...
Transmision y Recepcion Exitosa:
|Dispositivo|---TX---|---RX---|
|-----1-----|---4d---|---d5---|
|-----2-----|---d5---|---4d---|
=N:[dumpMXD] closing MXD dump
=T:Simulation terminated by $finish at time 1876126000 (sim_1\new\tb_uart.v:196);
  System timescale is 1ps / 1ps
  Metrics DSim version: 20240422.9.0 (b:R #c:0 h:d63c52d5c2 os:msys2_)
  Random seed: (defaulted to 1)

```

- LOTE II Autoverificable

  Utilizando la semilla:
```verilog
    seed = 32'hE6712FC1;
```

A pequeña escala se tienen entonces los pulsos:

![image](https://github.com/user-attachments/assets/2149e655-b46a-40d0-916a-4e19a4aba9de)



Y a gran escala:


![image](https://github.com/user-attachments/assets/ef964aa1-671e-4409-9418-60e2b3172102)


```bash

Optimizing...
Building models...
PLI/VPI access: +b 
Simulation time precision is 1ps.
  [3/4] module tb_uart#(8): 34 functions, 203 basic blocks
Linking image.so...
Using default typical min/typ/max.
=S:Begin run-time elaboration and static initialization...
=N:[dumpMXD] preparing MXD dump to 'waves.mxd'.
=N:[dump] Dump started at time 0
=N:Starting event scheduler...
Transmision y Recepcion Exitosa:
|Dispositivo|---TX---|---RX---|
|-----1-----|---ef---|---34---|
|-----2-----|---34---|---ef---|
=N:[dumpMXD] closing MXD dump
=T:Simulation terminated by $finish at time 1876126000 (sim_1\new\tb_uart.v:196);
  System timescale is 1ps / 1ps
  Metrics DSim version: 20240422.9.0 (b:R #c:0 h:d63c52d5c2 os:msys2_)
  Random seed: (defaulted to 1)
```
  
- LOTE III Autoverificable

  Utilizando la semilla:
```verilog
    seed = 32'hA54819CE;
```

A pequeña escala se tienen entonces los pulsos:

![image](https://github.com/user-attachments/assets/2eddcbfb-5bca-49b2-8657-c293527aa524)



Y a gran escala:

![image](https://github.com/user-attachments/assets/132880a9-624a-4ad1-bde2-23db9bcd569c)


```bash
Optimizing...
Building models...
PLI/VPI access: +b
Simulation time precision is 1ps.
  [3/4] module tb_uart#(8): 34 functions, 203 basic blocks
Linking image.so...
Using default typical min/typ/max.
=S:Begin run-time elaboration and static initialization...
=N:[dumpMXD] preparing MXD dump to 'waves.mxd'.
=N:[dump] Dump started at time 0
=N:Starting event scheduler...
Transmision y Recepcion Exitosa:
|Dispositivo|---TX---|---RX---|
|-----1-----|---3b---|---36---|
|-----2-----|---36---|---3b---|
=N:[dumpMXD] closing MXD dump
=T:Simulation terminated by $finish at time 1876126000 (sim_1\new\tb_uart.v:196);
Run directory: D:\UNI\Taller_Digitales_S2_2024\Laboratorio_II\Ejercicio_III\UART\UART.srcs
  System timescale is 1ps / 1ps
  Metrics DSim version: 20240422.9.0 (b:R #c:0 h:d63c52d5c2 os:msys2_)
  Random seed: (defaulted to 1

```


# Ejercicio 4


## 1. Desarrollo


### 1.1 Módulo "genérico"
#### 1. Encabezado del módulo
```SystemVerilog
module mi_modulo(
    input logic     entrada_i,      
    output logic    salida_i 
    );
```
#### 2. Parámetros
- Lista de parámetros

#### 3. Entradas y salidas:
- `entrada_i`: descripción de la entrada
- `salida_i`: descripción de la salida

#### 4. Criterios de diseño
Diagramas, texto explicativo...

#### 5. Testbench
Descripción y resultados de las pruebas hechas

## Apendices:
### Apendice 1:
texto, imágen, etc

