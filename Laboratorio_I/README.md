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
module ALU_TOP #(parameter N=3) (
    input [N:0] A,
    input [N:0] B,
    input [N:0] ALUControl,
    input ALUFlagIn,
    output reg C,
    output reg Z,
    output reg [N:0] Y
);
```
#### 2. Parámetros
- parameter N=3: Representa el tamaño que van a tener tanto los operandos, como la salida del resultado Y.

#### 3. Entradas y salidas:
- `A`: Entrada correspondiente al primer operando de la ALU, se considera el operando principal al que se le aplican las operaciones.
- `B`: Input referente al segundo operando, este operando varía más con respecto a cual de las operaciones a realizar, puede estar sujeto a indicar cuantos corrimientos se hacen para el caso de esa operación o el segundo operando de las operaciones lógicas o aritméticas.
- `ALUControl`: Señal de dos bits correspondiente al selector de la operación a realizar, de las cuales hay 10 disponibles y cada una con su código de operación correspondiente. 
- `ALUFlagIn`: Entrada de un bit con distintas aplicaciones dependiendo de la operación a realizar, puede representar un acarreo de entrada o un valor binario para rellenar un operando por ejemplo.
  
- `C`: Corresponde a la bandera de salida que representa un bit de acarreo para las operaciones aritméticas o para el caso de corrimientos, el último bit que sale de el arreglo escogido.
- `Z`: Bandera de salida que resulta al momento en el que se tiene un resultado de la operación correspondiente a un cero.
- `Y`: Arreglo de bits que representa la salida de la ALU principal, la cual es la operación resultante dependiendo de la operación elegida por el control.

#### 4. Criterios de diseño

Para al ALU solicitada se realiza un diseño para visualizar las salidas y entradas así como su funcionalidad.

![image](https://github.com/user-attachments/assets/6e1316e9-ab7e-4641-bf51-b3a71b94a3fe)

A modo de simplicidad se muestra solo la tabla de verdad correspondiente a operandos de dos bits.

Operación AND:

![image](https://github.com/user-attachments/assets/e0a46ae0-9af8-4006-b299-86c31075a227)

Operación OR:


## Tabla de Verdad para la Operación OR

### Operación OR (ALUControl = 1)

| **ALUControl** | **ALUFlagIn** | **Operando A (2 bits)** | **Operando B (2 bits)** | **Y = OR (A | B) (2 bits)** | **Zero** |
|:--------------:|:-------------:|:-----------------------:|:-----------------------:|:--------------------------:|:--------:|
| 1              | 0             | A = 00                  | B = 00                  | 00                         | 1        |
| 1              | 0             | A = 00                  | B = 01                  | 01                         | 0        |
| 1              | 0             | A = 00                  | B = 10                  | 10                         | 0        |
| 1              | 0             | A = 00                  | B = 11                  | 11                         | 0        |
| 1              | 0             | A = 01                  | B = 00                  | 01                         | 0        |
| 1              | 0             | A = 01                  | B = 01                  | 01                         | 0        |
| 1              | 0             | A = 01                  | B = 10                  | 11                         | 0        |
| 1              | 0             | A = 01                  | B = 11                  | 11                         | 0        |
| 1              | 1             | A = 00                  | B = 00                  | 00                         | 1        |
| 1              | 1             | A = 00                  | B = 01                  | 01                         | 0        |
| 1              | 1             | A = 00                  | B = 10                  | 10                         | 0        |
| 1              | 1             | A = 00                  | B = 11                  | 11                         | 0        |
| 1              | 1             | A = 01                  | B = 00                  | 01                         | 0        |
| 1              | 1             | A = 01                  | B = 01                  | 01                         | 0        |
| 1              | 1             | A = 01                  | B = 10                  | 11                         | 0        |
| 1              | 1             | A = 01                  | B = 11                  | 11                         | 0        |
| Otros valores  | -             | -                       | -                       | -                          | -        |

- **ALUControl**: 1 (en hexadecimal) indica que se debe realizar la operación OR.
- **ALUFlagIn**: 0 indica que se selecciona A para la operación OR; 1 indica que se selecciona B.
- **Y** es el resultado de la operación OR aplicada a los operandos seleccionados, solo cuando **ALUControl** es 1.
- **Zero** es 1 cuando el resultado **Y** es 00.


Operación Suma (Complemento a 2):

| **ALUControl** | **ALUFlagIn** | **Operando A (2 bits)** | **Operando B (2 bits)** | **Y = Suma (A + B) (2 bits)** | **C_out** | **Zero** |
|:--------------:|:-------------:|:-----------------------:|:-----------------------:|:----------------------------:|:---------:|:--------:|
| 2              | 0             | A = 00                  | B = 00                  | 00                           | 0         | 1        |
| 2              | 0             | A = 00                  | B = 01                  | 01                           | 0         | 0        |
| 2              | 0             | A = 00                  | B = 10                  | 10                           | 0         | 0        |
| 2              | 0             | A = 00                  | B = 11                  | 11                           | 0         | 0        |
| 2              | 0             | A = 01                  | B = 00                  | 01                           | 0         | 0        |
| 2              | 0             | A = 01                  | B = 01                  | 10                           | 0         | 0        |
| 2              | 0             | A = 01                  | B = 10                  | 11                           | 0         | 0        |
| 2              | 0             | A = 01                  | B = 11                  | 00                           | 1         | 1        |
| 2              | 0             | A = 10                  | B = 00                  | 10                           | 0         | 0        |
| 2              | 0             | A = 10                  | B = 01                  | 11                           | 0         | 0        |
| 2              | 0             | A = 10                  | B = 10                  | 00                           | 1         | 1        |
| 2              | 0             | A = 10                  | B = 11                  | 01                           | 1         | 0        |
| 2              | 0             | A = 11                  | B = 00                  | 11                           | 0         | 0        |
| 2              | 0             | A = 11                  | B = 01                  | 00                           | 1         | 1        |
| 2              | 0             | A = 11                  | B = 10                  | 01                           | 1         | 0        |
| 2              | 0             | A = 11                  | B = 11                  | 10                           | 1         | 0        |
| 2              | 1             | A = 00                  | B = 00                  | 00                           | 0         | 1        |
| 2              | 1             | A = 00                  | B = 01                  | 01                           | 0         | 0        |
| 2              | 1             | A = 00                  | B = 10                  | 10                           | 0         | 0        |
| 2              | 1             | A = 00                  | B = 11                  | 11                           | 0         | 0        |
| 2              | 1             | A = 01                  | B = 00                  | 01                           | 0         | 0        |
| 2              | 1             | A = 01                  | B = 01                  | 10                           | 0         | 0        |
| 2              | 1             | A = 01                  | B = 10                  | 11                           | 0         | 0        |
| 2              | 1             | A = 01                  | B = 11                  | 00                           | 1         | 1        |
| 2              | 1             | A = 10                  | B = 00                  | 10                           | 0         | 0        |
| 2              | 1             | A = 10                  | B = 01                  | 11                           | 0         | 0        |
| 2              | 1             | A = 10                  | B = 10                  | 00                           | 1         | 1        |
| 2              | 1             | A = 10                  | B = 11                  | 01                           | 1         | 0        |
| 2              | 1             | A = 11                  | B = 00                  | 11                           | 0         | 0        |
| 2              | 1             | A = 11                  | B = 01                  | 00                           | 1         | 1        |
| 2              | 1             | A = 11                  | B = 10                  | 01                           | 1         | 0        |
| 2              | 1             | A = 11                  | B = 11                  | 10                           | 1         | 0        |



Incremento en Uno:

![image](https://github.com/user-attachments/assets/31efacd8-b49c-40ed-8b1f-185ccd263ebd)


Decremento en Uno:

![image](https://github.com/user-attachments/assets/ba19edd3-da8b-4670-ad75-a36e35273a27)


Operación NOT:

![image](https://github.com/user-attachments/assets/88582561-aa01-43aa-adf4-cef904c9ce02)


#### 5. Testbench


Con Semilla para randoms: seed = 32'hDEADBEEF;

![image](https://github.com/user-attachments/assets/771ed6c4-6b3d-4b35-bb3e-08e286356524)




## Referencias
[0] David Harris y Sarah Harris. *Digital Design and Computer Architecture. RISC-V Edition.* Morgan Kaufmann, 2022. ISBN: 978-0-12-820064-3

## Apendices:
### Apendice 1:
texto, imágen, etc
