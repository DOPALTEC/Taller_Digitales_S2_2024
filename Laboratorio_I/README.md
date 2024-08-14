# Lab. 1: Introducción al diseño digital con HDL y herramientas EDA de síntesis

## Abreviaturas y definiciones
- **FPGA**: Field Programmable Gate Arrays

![pin_map](https://github.com/user-attachments/assets/e29f3a75-c2ac-441d-ada5-0436738a9cc2)


## Ejercicio 1

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


#### 5. Testbench
Descripción y resultados de las pruebas hechas


## Ejercicio 2


#### 1. Encabezado del módulo
```SystemVerilog
module TOP_Leds(
    input [3:0] sw,
    output [3:0] led
);
```
#### 2. Parámetros
- N/A

#### 3. Entradas y salidas:
- `sw`: Corresponde a las entradas de valor binario que representa cada switch.
- `led`: Salidas asignadas al valor transformado en complemento a dos de los valores ingresados por el usuario mediante los switches. Este output se asocian a los leds de la fpga.

#### 4. Criterios de diseño

Se muestra en la tabla los resultantes que se van a obtener al aplicar el complemento a dos a los valores binarios de los switches así como el valor decimal de cada uno de ellos.

![image](https://github.com/user-attachments/assets/7ce9306b-c443-49b3-a091-0f471c08fd1c)

Para realizar la codificacion a complemento a dos se aplican dos pasos, primeramente se recurre al complemento a 1 lo cual consiste en invertir los valores de los digitos binarios que forman los switches para posteriormente sumarle a este valor un valor de 0001.

![image](https://github.com/user-attachments/assets/30d69d71-deef-4aa8-aa8f-63fe78ddce4f)


#### 5. Testbench
Para todos los casos de 4 bits que corresponden a los switches se realizó un testbench para todos los posibles casos de los numeros binarios que estos mismos pueden abarcar.

![image](https://github.com/user-attachments/assets/f4b0c271-42ba-4546-ac3b-04e8bfa1a37c)

En el caso de Dsim se realizó la simulación para obtener un resultado con el mismo comportamiento.

```sh
=N:[dumpMXD] preparing MXD dump to 'waves.mxd'.
=N:[dump] Dump started at time 0
=N:Starting event scheduler...
Tiempo   sw      led
------------------------
10ns     0000    0000
20ns     0001    1111
30ns     0010    1110
40ns     0011    1101
50ns     0100    1100
60ns     0101    1011
70ns     0110    1010
80ns     0111    1001
90ns     1000    1000
100ns    1001    0111
110ns    1010    0110
120ns    1011    0101
130ns    1100    0100
140ns    1101    0011
150ns    1110    0010
160ns    1111    0001
=N:[dumpMXD] closing MXD dump
=T:Simulation terminated by $finish at time 160000 (sim_1\new\Complemento_a_2_tb.v:27);
Run directory: D:\UNI\Taller_Digitales_S2_2024\Laboratorio_I\Ejercicio_II\Switch_Button_Led\Switch_Button_Led.srcs
  System timescale is 1ps / 1ps
```
![image](https://github.com/user-attachments/assets/fe3e7383-b1b2-45d5-a128-fb952ebff34c)


## Ejercicio 3



#### 1. Encabezado del módulo
```SystemVerilog
module MUX_4_1 #(parameter N=3)(
    input [N:0] IN_1,
    input [N:0] IN_2,
    input [N:0] IN_3,
    input [N:0] IN_4,
    input [1:0] sel,
    output reg [N:0] OUT
    );
```
#### 2. Parámetros
- `N`: Representa el tamaño en bits que van a tener las entradas y salidas del multiplexor. Para las pruebas solicitadas en el testbench se  denotan como: 4,8 y 16 bits.

#### 3. Entradas y salidas:
- `IN_1,IN_2,IN_3,IN_4`: Bits correspondientes a las entradas del multiplexor
- `sel`: Entrada perteneciente a el selector del multiplexor
- `OUT`: Salida del multiplexor portando el valor de la entrada seleccionada

#### 4. Criterios de diseño

Se solicita un multiplexor parametrizable con lo cual las lineas y salida de entrada serán designadas por N bits mientras que el selector requiere de dos bits.


![image](https://github.com/user-attachments/assets/3afdc2a7-cc07-432c-9960-61fce928d535)


#### 5. Testbench
Se observa la separación en el testbench entre cada prueba con diferentes valores en el parámetro N. 4,8 y 16 respectivamente.

![image](https://github.com/user-attachments/assets/c8f2ed0c-2a17-4e15-97ef-404d636c22d2)

Para el primer muestreo, con salidas y la entrada de 4 bits se obtuvieron los resultados mostrados. Correspondientes a los 50 casos los cuales son valores aleatorios.

![image](https://github.com/user-attachments/assets/48777de1-fe5e-47df-869f-304a93e9f910)

Posteriormente para las entradas y salidas de 8 bits generando el testbench de la figura

![image](https://github.com/user-attachments/assets/1a194984-3c6c-4037-b2cd-03d612450055)

Finalmente se asignaron valores aleatorios a el muestreo con 16 bits entregando un testbench con un comportamiento similar a los anteriores.

![image](https://github.com/user-attachments/assets/33b75e0e-464d-4f05-8a29-1e7e39796dd3)


## Ejercicio 4


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


#### 5. Testbench
Descripción y resultados de las pruebas hechas


## Ejercicio 5



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


#### 5. Testbench
Descripción y resultados de las pruebas hechas



## Referencias
[0] David Harris y Sarah Harris. *Digital Design and Computer Architecture. RISC-V Edition.* Morgan Kaufmann, 2022. ISBN: 978-0-12-820064-3

## Apendices:
### Apendice 1:
texto, imágen, etc
