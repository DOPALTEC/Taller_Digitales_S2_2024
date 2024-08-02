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
