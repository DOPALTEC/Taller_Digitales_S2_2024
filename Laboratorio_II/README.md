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

