# LABORATORIO 2 

## 1. Abreviaturas y definiciones
- **FPGA**: Field Programmable Gate Arrays

## 2. Referencias
[0] David Harris y Sarah Harris. *Digital Design and Computer Architecture. RISC-V Edition.* Morgan Kaufmann, 2022. ISBN: 978-0-12-820064-3

# Ejercicio 1


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



# Ejercicio 2


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


# Ejercicio 3


## 1. Desarrollo


### 1.1 Módulo "genérico"
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
Diagramas, texto explicativo...

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
Al realizar las pruebas de manera autoverificable se le asignó un valor tanto a el dato a transmitir como a una recepción de un dato, con valores de 0xA5 y 0xDA, para el tx y rx respectivamente.


Y en la grafica de pulsos se observa a baja escala el funcionamiento de los pulsos de validación e iniciación de transmisión y recpción así como los valores constantes que se esperan transmitir y recibir.
![tb_I_verificable_bajaescala](https://github.com/user-attachments/assets/0be96591-752b-4eea-ac13-77f5616f7d35)

Mostrando los pulsos de las pruebas en su totalidad se observa que los datos tanto transmitidos como recibidos coinciden con lo esperado.

![tb_I_verificable_completo](https://github.com/user-attachments/assets/f9b799da-c5d8-47f9-bbbb-6465082532b8)



Dando como resultado en la terminal el display esperado cuando se obtiene una transmisión y recepción exitosa.

```bash
=N:[dumpMXD] preparing MXD dump to 'waves.mxd'.
=N:[dump] Dump started at time 0
=N:Starting event scheduler...
Transmision Exitosa: Los datos enviados (10100101) coinciden con los datos que se esperan transmitir(10100101)
Recepcion Exitosa: Los datos recibidos (11011010) coinciden con los datos que se esperan recibir(11011010)
=N:[dumpMXD] closing MXD dump
```


- LOTE II Autoverificable
A partir de aqui, se hace uso de una semilla distinta para valores aleatorios en cada una de las muestras.

Utilizando la semilla:
```verilog
seed = 32'hDEADBEEF;
```
Se espera obtener para el receptor:

$$
    rx=0x0B
$$

Y para el transmisor:

$$
    tx=0xC5
$$

A pequeña escala se tienen entonces los pulsos:


![tb_2_baja](https://github.com/user-attachments/assets/92ac613f-d1c2-4bb1-ac91-68b7c2a04687)


Y a escala completa:

![tb_2_completo](https://github.com/user-attachments/assets/8378f33e-6d95-410d-a748-55d670e68232)



```bash
    Optimizing...
Building models...
PLI/VPI access: +b
Simulation time precision is 1ps.
  [3/4] module tb_uart#(8): 22 functions, 131 basic blocks
Linking image.so...
Using default typical min/typ/max.
=S:Begin run-time elaboration and static initialization...
=N:[dumpMXD] preparing MXD dump to 'waves.mxd'.
=N:[dump] Dump started at time 0
=N:Starting event scheduler...
Transmision Exitosa: Los datos enviados (11000101) coinciden con los datos que se esperan transmitir(11000101)
Recepcion Exitosa: Los datos recibidos (00001011) coinciden con los datos que se esperan recibir(00001011)
=N:[dumpMXD] closing MXD dump
```
  
- LOTE III Autoverificable

  Utilizando la semilla:
```verilog
    seed = 32'h37FE29A;
```
Se espera obtener para el receptor:

$$
    rx=0x7D
$$

Y para el transmisor:

$$
    tx=0x5D
$$

A pequeña escala se tienen entonces los pulsos:

![tb_3_baja](https://github.com/user-attachments/assets/d3aed1eb-116f-4d0e-aedd-b83c28209896)


Y a gran escala:
![tb_3_completo](https://github.com/user-attachments/assets/7733e5b3-9b7d-4638-a7ef-e8194e3c79c8)

```bash
Optimizing...
Building models...
PLI/VPI access: +b
Simulation time precision is 1ps.
  [3/4] module tb_uart#(8): 22 functions, 131 basic blocks
Linking image.so...
Using default typical min/typ/max.
=S:Begin run-time elaboration and static initialization...
=N:[dumpMXD] preparing MXD dump to 'waves.mxd'.
=N:[dump] Dump started at time 0
=N:Starting event scheduler...
Transmision Exitosa: Los datos enviados (01011101) coinciden con los datos que se esperan transmitir(01011101)
Recepcion Exitosa: Los datos recibidos (01111101) coinciden con los datos que se esperan recibir(01111101)
=N:[dumpMXD] closing MXD dump
=T:Simulation terminated by $finish at time 1042790000 (sim_1\new\tb_uart.v:131);
  System timescale is 1ps / 1ps
  Metrics DSim version: 20240422.9.0 (b:R #c:0 h:d63c52d5c2 os:msys2_)

```
- LOTE IV Autoverificable

Utilizando la semilla:
```verilog

```
Se espera obtener para el receptor:

$$
    rx=0x
$$

Y para el transmisor:

$$
    tx=0x
$$

A pequeña escala se tienen entonces los pulsos:

Y a gran escala:

```bash

```
- LOTE V Autoverificable

Utilizando la semilla:
```verilog

```
Se espera obtener para el receptor:

$$
    rx=0x
$$

Y para el transmisor:

$$
    tx=0x
$$

A pequeña escala se tienen entonces los pulsos:

Y a gran escala:

```bash

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

