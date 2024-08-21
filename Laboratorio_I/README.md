# Lab. 1: Introducción al diseño digital con HDL y herramientas EDA de síntesis

## Abreviaturas y definiciones
- **FPGA (Field Programmable Gate Arrays)** Dispositivo semiconductor que se puede programar para realizar tareas lógicas específicas después de su fabricación.

## Referencias
[0] David Harris y Sarah Harris. *Digital Design and Computer Architecture. RISC-V Edition.* Morgan Kaufmann, 2022. ISBN: 978-0-12-820064-3

[1] Morris Mano y Michael D. Ciletti. Digital Design: With an Introduction to the Verilog HDL, VHDL, and SystemVerilog. 6ta edición. Pearson, 2017. ISBN: 978-0-13-454989-7

[2] Pong P. Chu. FPGA Prototyping by Verilog Examples: Xilinx Spartan-3 Version. Wiley-Interscience, 2008. ISBN: 978-0-470-18532-2.



## Ejercicio 1

#### 1. Criterios de diseño:
Se muestra el diseño realizado para el decodificador de 2 a 4 con salida baja activa. 

[![Decoder.png](https://i.postimg.cc/TPNNG1bd/Decoder.png)](https://postimg.cc/2qv77zTM)

Se utilizaron dos compuertas NOT y cuatro compuertas NAND para la activación de cada columna del teclado cuando se recibe un cero lógico. A continuación, se muestran los resultados de la tabla de verdad, así como la simplificación con mapas de Karnaugh utilizados en el proceso de diseño.

[![Captura-de-pantalla-2024-08-15-002457.png](https://i.postimg.cc/Dy6JpXsM/Captura-de-pantalla-2024-08-15-002457.png)](https://postimg.cc/tY14Y7B3)

[![Captura-de-pantalla-2024-08-15-002719.png](https://i.postimg.cc/76XrrwVw/Captura-de-pantalla-2024-08-15-002719.png)](https://postimg.cc/CBZQjyXQ)

[![Captura-de-pantalla-2024-08-14-225149.png](https://i.postimg.cc/4xSpx9WS/Captura-de-pantalla-2024-08-14-225149.png)](https://postimg.cc/4YpY8mk6)

[![Captura-de-pantalla-2024-08-14-225224.png](https://i.postimg.cc/PxmDyFTg/Captura-de-pantalla-2024-08-14-225224.png)](https://postimg.cc/0Myr2n6n)

[![Captura-de-pantalla-2024-08-14-225259.png](https://i.postimg.cc/1XBqhngM/Captura-de-pantalla-2024-08-14-225259.png)](https://postimg.cc/SYXscKfz)

Para el bloque de codificación 2 key-rollover y key detect se diseñó un codificador de 4 a 2 con salida baja activa. Para esto se utilizaron dos compuertas NAND, lo que permite mostrar la fila presionada.
Se muestra a continuación el diseño realizado, así como la tabla de verdad y ecuación booleana utilizadas en el proceso de diseño.

[![Captura-de-pantalla-2024-08-20-120031.png](https://i.postimg.cc/KjmXTjHV/Captura-de-pantalla-2024-08-20-120031.png)](https://postimg.cc/FdCn5rmg)

[![Captura-de-pantalla-2024-08-20-121628.png](https://i.postimg.cc/SRdBfq0K/Captura-de-pantalla-2024-08-20-121628.png)](https://postimg.cc/RJ3pvkZr)

#### 2. Implementación Física

Laboratorio_I/Ejercicio_I/README.md

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

#### 6. Implementación Física

Laboratorio_I/Ejercicio_II/README.md

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

#### 6. Implementación Física



## Ejercicio 4


#### 1. Encabezado del módulo
```SystemVerilog
module pwm_generador( 
    input clk,
    input [3:0] switch,  //Entrada de los switches 
    output reg led
    );
```
#### 2. Parámetros
- COUNTER_MAX: Un parámetro local establecido en 100_000 - 1. Este valor representa el valor máximo del contador y corresponde a un período de 1 ms cuando se utiliza
  un reloj de 100 MHz. El contador contará hasta este valor antes de reiniciarse, definiendo así el período de la señal PWM.
- counter: Un registro de 17 bits que se utiliza para contar ciclos de reloj. Este contador se incrementa en cada flanco de subida del reloj y se reinicia cuando
  alcanza COUNTER_MAX.

#### 3. Entradas y salidas:
Entradas
- clk: Señal de reloj. Es la señal principal que impulsa el módulo y determina el tiempo de la señal PWM.
- switch: Entrada de 4 bits que determina el ciclo de trabajo de la señal PWM. El valor puede variar entre 0 y 15.

Salida
- led: Señal de salida PWM. El ciclo de trabajo de esta señal varía según el valor de switch. Esta salida puede utilizarse para controlar un LED, un motor u otros
  dispositivos que requieran PWM.

#### 4. Criterios de diseño
1.	Contador de Reloj (counter):
	- El registro counter se incrementa en cada flanco de subida de la señal clk.
	- Cuando counter alcanza COUNTER_MAX, se reinicia a cero. Este proceso define la longitud del período de PWM.
2.	Ciclo de Trabajo del PWM:
    -  El ciclo de trabajo se controla comparando el valor de counter con una versión escalada de la entrada switch.
	-  El factor de escalado (6667) se elige de manera que el valor máximo de switch (15) corresponda al ciclo de trabajo máximo, cercano al 100%.

   ```SystemVerilog
led <= (counter < (switch * 6667)) ? 1 : 0;
```
- Si counter es menor que el producto de switch * 6667, la salida led estará en alto (1). De lo contrario, estará en bajo (0).

Cálculo del Ciclo de Trabajo

- switch = 0: La señal PWM tiene un ciclo de trabajo del 0% (siempre en bajo).
- switch = 15: La señal PWM tiene un ciclo de trabajo cercano al 100% (mayormente en alto).

#### 5. Testbench
![WhatsApp Image 2024-08-14 at 17 05 48](https://github.com/user-attachments/assets/f23f9898-a5c5-4143-8990-9a7d98b56374)


- clk: Es la señal de reloj. En la imagen, está constantemente en alto, indicando que es la señal que impulsa el contador interno.
- switch[3:0]: Representa el valor de los switches. En la imagen, su valor es 15.
- led: Es la señal PWM generada por el módulo, que se controla en función del valor de switch.

Análisis de la Señal led:

La señal led que vemos en la imagen tiene diferentes duraciones de estado alto y bajo, lo que corresponde al ciclo de trabajo (duty cycle) de la señal PWM.

1.	Periodo de 1 a 1.5 ms:
      - Cuando el valor del switch es 1, la señal led está en alto durante una pequeña fracción del periodo. Esto
     significa que el ciclo de trabajo es bajo (~6.67% deltiempo total).
2.	Periodo de 1.5 a 2.5 ms:
      - Para el valor del switch igual a 4, la señal led está en alto durante una mayor fracción del tiempo comparado
        con el anterior (~26.68% del tiempo total).
3.	Periodo de 2.5 a 3.5 ms:
	  - Con el switch configurado a 8, la señal led está en alto durante aproximadamente la mitad del periodo (~53.36%
        del tiempo total).
4.	Periodo de 3.5 a 4.5 ms:
	  - Cuando el switch tiene el valor máximo de 15, la señal led permanece en alto durante casi todo el periodo
        (~100% del tiempo total). Esto significa que el ciclo de trabajo es cercano al 100%.

 #### 6. Implementación Física

Laboratorio_I/Ejercicio_IV/README.md 


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

| **ALUControl** | **ALUFlagIn** | **Operando A (2 bits)** | **Operando B (2 bits)** | **Y = A and B** | **Zero** |
|:--------------:|:-------------:|:-----------------------:|:-----------------------:|:---------------:|:--------:|
| 0              | X             | 00                     | 00                     | 00              | 1        |
| 0              | X             | 00                     | 01                     | 00              | 1        |
| 0              | X             | 00                     | 10                     | 00              | 1        |
| 0              | X             | 00                     | 11                     | 00              | 1        |
| 0              | X             | 01                     | 00                     | 00              | 1        |
| 0              | X             | 01                     | 01                     | 01              | 0        |
| 0              | X             | 01                     | 10                     | 00              | 1        |
| 0              | X             | 01                     | 11                     | 01              | 0        |
| 0              | X             | 10                     | 00                     | 00              | 1        |
| 0              | X             | 10                     | 01                     | 00              | 1        |
| 0              | X             | 10                     | 10                     | 10              | 0        |
| 0              | X             | 10                     | 11                     | 10              | 0        |
| 0              | X             | 11                     | 00                     | 00              | 1        |
| 0              | X             | 11                     | 01                     | 01              | 0        |
| 0              | X             | 11                     | 10                     | 10              | 0        |
| 0              | X             | 11                     | 11                     | 11              | 0        |


Operación OR:
| **ALUControl** | **ALUFlagIn** | **Operando A (2 bits)** | **Operando B (2 bits)** | **Y = A or B** | **Zero** |
|:--------------:|:-------------:|:-----------------------:|:-----------------------:|:--------------:|:--------:|
| 1              | X             | 00                     | 00                     | 00             | 1        |
| 1              | X             | 00                     | 01                     | 01             | 0        |
| 1              | X             | 00                     | 10                     | 10             | 0        |
| 1              | X             | 00                     | 11                     | 11             | 0        |
| 1              | X             | 01                     | 00                     | 01             | 0        |
| 1              | X             | 01                     | 01                     | 01             | 0        |
| 1              | X             | 01                     | 10                     | 11             | 0        |
| 1              | X             | 01                     | 11                     | 11             | 0        |
| 1              | X             | 10                     | 00                     | 10             | 0        |
| 1              | X             | 10                     | 01                     | 11             | 0        |
| 1              | X             | 10                     | 10                     | 10             | 0        |
| 1              | X             | 10                     | 11                     | 11             | 0        |
| 1              | X             | 11                     | 00                     | 11             | 0        |
| 1              | X             | 11                     | 01                     | 11             | 0        |
| 1              | X             | 11                     | 10                     | 11             | 0        |
| 1              | X             | 11                     | 11                     | 11             | 0        |



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

| **ALUControl** | **ALUFlagIn** | **Operando A (2 bits)** | **Operando B (2 bits)** | **Y = A + 1** | **C (Carry Out)** | **Zero** |
|:--------------:|:-------------:|:-----------------------:|:-----------------------:|:-------------:|:-----------------:|:--------:|
| 3              | 0             | 00                     | 00                     | 01            | 0                 | 0        |
| 3              | 0             | 01                     | 00                     | 10            | 0                 | 0        |
| 3              | 0             | 10                     | 00                     | 11            | 0                 | 0        |
| 3              | 0             | 11                     | 00                     | 00            | 1                 | 1        |
| 3              | 1             | 00                     | 00                     | 01            | 0                 | 0        |
| 3              | 1             | 01                     | 00                     | 10            | 0                 | 0        |
| 3              | 1             | 10                     | 00                     | 11            | 0                 | 0        |
| 3              | 1             | 11                     | 00                     | 00            | 1                 | 1        |
| 3              | 0             | 00                     | 01                     | 01            | 0                 | 0        |
| 3              | 0             | 01                     | 01                     | 10            | 0                 | 0        |
| 3              | 0             | 10                     | 01                     | 11            | 0                 | 0        |
| 3              | 0             | 11                     | 01                     | 00            | 1                 | 1        |
| 3              | 1             | 00                     | 01                     | 01            | 0                 | 0        |
| 3              | 1             | 01                     | 01                     | 10            | 0                 | 0        |
| 3              | 1             | 10                     | 01                     | 11            | 0                 | 0        |
| 3              | 1             | 11                     | 01                     | 00            | 1                 | 1        |
| 3              | 0             | 00                     | 10                     | 10            | 0                 | 0        |
| 3              | 0             | 01                     | 10                     | 11            | 0                 | 0        |
| 3              | 0             | 10                     | 10                     | 00            | 1                 | 1        |
| 3              | 0             | 11                     | 10                     | 01            | 1                 | 0        |
| 3              | 1             | 00                     | 10                     | 10            | 0                 | 0        |
| 3              | 1             | 01                     | 10                     | 11            | 0                 | 0        |
| 3              | 1             | 10                     | 10                     | 00            | 1                 | 1        |
| 3              | 1             | 11                     | 10                     | 01            | 1                 | 0        |
| 3              | 0             | 00                     | 11                     | 11            | 0                 | 0        |
| 3              | 0             | 01                     | 11                     | 00            | 1                 | 1        |
| 3              | 0             | 10                     | 11                     | 01            | 1                 | 0        |
| 3              | 0             | 11                     | 11                     | 10            | 1                 | 0        |
| 3              | 1             | 00                     | 11                     | 11            | 0                 | 0        |
| 3              | 1             | 01                     | 11                     | 00            | 1                 | 1        |
| 3              | 1             | 10                     | 11                     | 01            | 1                 | 0        |
| 3              | 1             | 11                     | 11                     | 10            | 1                 | 0        |


Decremento en Uno:

| **ALUControl** | **ALUFlagIn** | **Operando A (2 bits)** | **Operando B (2 bits)** | **Y = A - 1** | **C (Carry Out)** | **Zero** |
|:--------------:|:-------------:|:-----------------------:|:-----------------------:|:-------------:|:-----------------:|:--------:|
| 4              | 0             | 00                     | 00                     | 11            | 1                 | 0        |
| 4              | 0             | 01                     | 00                     | 00            | 1                 | 1        |
| 4              | 0             | 10                     | 00                     | 01            | 0                 | 0        |
| 4              | 0             | 11                     | 00                     | 10            | 0                 | 0        |
| 4              | 1             | 00                     | 00                     | 11            | 1                 | 0        |
| 4              | 1             | 01                     | 00                     | 00            | 1                 | 1        |
| 4              | 1             | 10                     | 00                     | 01            | 0                 | 0        |
| 4              | 1             | 11                     | 00                     | 10            | 0                 | 0        |
| 4              | 0             | 00                     | 01                     | 11            | 1                 | 0        |
| 4              | 0             | 01                     | 01                     | 00            | 1                 | 1        |
| 4              | 0             | 10                     | 01                     | 01            | 0                 | 0        |
| 4              | 0             | 11                     | 01                     | 10            | 0                 | 0        |
| 4              | 1             | 00                     | 01                     | 11            | 1                 | 0        |
| 4              | 1             | 01                     | 01                     | 00            | 1                 | 1        |
| 4              | 1             | 10                     | 01                     | 01            | 0                 | 0        |
| 4              | 1             | 11                     | 01                     | 10            | 0                 | 0        |
| 4              | 0             | 00                     | 10                     | 01            | 0                 | 0        |
| 4              | 0             | 01                     | 10                     | 10            | 0                 | 0        |
| 4              | 0             | 10                     | 10                     | 11            | 1                 | 0        |
| 4              | 0             | 11                     | 10                     | 00            | 1                 | 1        |
| 4              | 1             | 00                     | 10                     | 01            | 0                 | 0        |
| 4              | 1             | 01                     | 10                     | 10            | 0                 | 0        |
| 4              | 1             | 10                     | 10                     | 11            | 1                 | 0        |
| 4              | 1             | 11                     | 10                     | 00            | 1                 | 1        |
| 4              | 0             | 00                     | 11                     | 10            | 0                 | 0        |
| 4              | 0             | 01                     | 11                     | 00            | 1                 | 1        |
| 4              | 0             | 10                     | 11                     | 01            | 0                 | 0        |
| 4              | 0             | 11                     | 11                     | 10            | 0                 | 0        |
| 4              | 1             | 00                     | 11                     | 10            | 0                 | 0        |
| 4              | 1             | 01                     | 11                     | 00            | 1                 | 1        |
| 4              | 1             | 10                     | 11                     | 01            | 0                 | 0        |
| 4              | 1             | 11                     | 11                     | 10            | 0                 | 0        |

Operación NOT:

| **ALUControl** | **ALUFlagIn** | **Operando A (2 bits)** | **Operando B (2 bits)** | **Y = NOT (Operando Seleccionado)** | **Zero** |
|:--------------:|:-------------:|:-----------------------:|:-----------------------:|:----------------------------------:|:--------:|
| 5              | 0             | 00                     | 00                     | 11                                 | 0        |
| 5              | 0             | 01                     | 00                     | 10                                 | 0        |
| 5              | 0             | 10                     | 00                     | 01                                 | 0        |
| 5              | 0             | 11                     | 00                     | 00                                 | 1        |
| 5              | 1             | 00                     | 00                     | 11                                 | 0        |
| 5              | 1             | 01                     | 00                     | 10                                 | 0        |
| 5              | 1             | 10                     | 00                     | 01                                 | 0        |
| 5              | 1             | 11                     | 00                     | 00                                 | 1        |
| 5              | 0             | 00                     | 01                     | 11                                 | 0        |
| 5              | 0             | 01                     | 01                     | 10                                 | 0        |
| 5              | 0             | 10                     | 01                     | 01                                 | 0        |
| 5              | 0             | 11                     | 01                     | 00                                 | 1        |
| 5              | 1             | 00                     | 01                     | 11                                 | 0        |
| 5              | 1             | 01                     | 01                     | 10                                 | 0        |
| 5              | 1             | 10                     | 01                     | 01                                 | 0        |
| 5              | 1             | 11                     | 01                     | 00                                 | 1        |
| 5              | 0             | 00                     | 10                     | 01                                 | 0        |
| 5              | 0             | 01                     | 10                     | 10                                 | 0        |
| 5              | 0             | 10                     | 10                     | 01                                 | 0        |
| 5              | 0             | 11                     | 10                     | 00                                 | 1        |
| 5              | 1             | 00                     | 10                     | 01                                 | 0        |
| 5              | 1             | 01                     | 10                     | 10                                 | 0        |
| 5              | 1             | 10                     | 10                     | 01                                 | 0        |
| 5              | 1             | 11                     | 10                     | 00                                 | 1        |
| 5              | 0             | 00                     | 11                     | 00                                 | 1        |
| 5              | 0             | 01                     | 11                     | 10                                 | 0        |
| 5              | 0             | 10                     | 11                     | 01                                 | 0        |
| 5              | 0             | 11                     | 11                     | 00                                 | 1        |
| 5              | 1             | 00                     | 11                     | 00                                 | 1        |
| 5              | 1             | 01                     | 11                     | 10                                 | 0        |
| 5              | 1             | 10                     | 11                     | 01                                 | 0        |
| 5              | 1             | 11                     | 11                     | 00                                 | 1        |


Resta (Complemento a 2):

| **ALUControl** | **ALUFlagIn** | **Operando A (2 bits)** | **Operando B (2 bits)** | **Y = A - B + ALUFlagIn** | **C (Carry Out)** | **Zero** |
|:--------------:|:-------------:|:-----------------------:|:-----------------------:|:-------------------------:|:-----------------:|:--------:|
| 6              | 0             | 00                     | 00                     | 00                        | 0                 | 1        |
| 6              | 0             | 00                     | 01                     | 11                        | 1                 | 0        |
| 6              | 0             | 00                     | 10                     | 01                        | 0                 | 0        |
| 6              | 0             | 00                     | 11                     | 10                        | 0                 | 0        |
| 6              | 0             | 01                     | 00                     | 01                        | 0                 | 0        |
| 6              | 0             | 01                     | 01                     | 00                        | 1                 | 1        |
| 6              | 0             | 01                     | 10                     | 11                        | 1                 | 0        |
| 6              | 0             | 01                     | 11                     | 10                        | 0                 | 0        |
| 6              | 0             | 10                     | 00                     | 10                        | 0                 | 0        |
| 6              | 0             | 10                     | 01                     | 01                        | 0                 | 0        |
| 6              | 0             | 10                     | 10                     | 00                        | 1                 | 1        |
| 6              | 0             | 10                     | 11                     | 11                        | 1                 | 0        |
| 6              | 0             | 11                     | 00                     | 11                        | 1                 | 0        |
| 6              | 0             | 11                     | 01                     | 10                        | 0                 | 0        |
| 6              | 0             | 11                     | 10                     | 01                        | 0                 | 0        |
| 6              | 0             | 11                     | 11                     | 00                        | 1                 | 1        |
| 6              | 1             | 00                     | 00                     | 01                        | 0                 | 0        |
| 6              | 1             | 00                     | 01                     | 00                        | 1                 | 1        |
| 6              | 1             | 00                     | 10                     | 10                        | 0                 | 0        |
| 6              | 1             | 00                     | 11                     | 11                        | 0                 | 0        |
| 6              | 1             | 01                     | 00                     | 10                        | 0                 | 0        |
| 6              | 1             | 01                     | 01                     | 01                        | 0                 | 0        |
| 6              | 1             | 01                     | 10                     | 00                        | 1                 | 1        |
| 6              | 1             | 01                     | 11                     | 01                        | 0                 | 0        |
| 6              | 1             | 10                     | 00                     | 11                        | 0                 | 0        |
| 6              | 1             | 10                     | 01                     | 10                        | 0                 | 0        |
| 6              | 1             | 10                     | 10                     | 01                        | 0                 | 0        |
| 6              | 1             | 10                     | 11                     | 10                        | 0                 | 0        |
| 6              | 1             | 11                     | 00                     | 00                        | 1                 | 1        |
| 6              | 1             | 11                     | 01                     | 11                        | 0                 | 0        |
| 6              | 1             | 11                     | 10                     | 10                        | 0                 | 0        |
| 6              | 1             | 11                     | 11                     | 01                        | 0                 | 0        |


Operación XOR:

| **ALUControl** | **ALUFlagIn** | **Operando A (2 bits)** | **Operando B (2 bits)** | **Y = A XOR B (2 bits)** | **C (Carry Out)** | **Zero** |
|:--------------:|:-------------:|:-----------------------:|:-----------------------:|:-------------------------:|:-----------------:|:--------:|
| 7              | x             | 00                     | 00                     | 00                        | 0                 | 1        |
| 7              | x             | 00                     | 01                     | 01                        | 0                 | 0        |
| 7              | x             | 00                     | 10                     | 10                        | 0                 | 0        |
| 7              | x             | 00                     | 11                     | 11                        | 0                 | 0        |
| 7              | x             | 01                     | 00                     | 01                        | 0                 | 0        |
| 7              | x             | 01                     | 01                     | 00                        | 0                 | 1        |
| 7              | x             | 01                     | 10                     | 11                        | 0                 | 0        |
| 7              | x             | 01                     | 11                     | 10                        | 0                 | 0        |
| 7              | x             | 10                     | 00                     | 10                        | 0                 | 0        |
| 7              | x             | 10                     | 01                     | 11                        | 0                 | 0        |
| 7              | x             | 10                     | 10                     | 00                        | 0                 | 1        |
| 7              | x             | 10                     | 11                     | 01                        | 0                 | 0        |
| 7              | x             | 11                     | 00                     | 11                        | 0                 | 0        |
| 7              | x             | 11                     | 01                     | 10                        | 0                 | 0        |
| 7              | x             | 11                     | 10                     | 01                        | 0                 | 0        |
| 7              | x             | 11                     | 11                     | 00                        | 0                 | 1        |

Corrimiento a la Izquierda:

| **ALUControl** | **ALUFlagIn** | **Operando A (2 bits)** | **Operando B (2 bits)** | **Y = A << B (2 bits)** | **C (Carry Out)** | **Zero** |
|:--------------:|:-------------:|:-----------------------:|:-----------------------:|:------------------------:|:-----------------:|:--------:|
| 8              | 0             | 00                     | 00                     | 00                       | 0                 | 1        |
| 8              | 0             | 00                     | 01                     | 00                       | 0                 | 1        |
| 8              | 0             | 00                     | 10                     | 00                       | 0                 | 1        |
| 8              | 0             | 00                     | 11                     | 00                       | 0                 | 1        |
| 8              | 0             | 01                     | 00                     | 01                       | 0                 | 0        |
| 8              | 0             | 01                     | 01                     | 10                       | 0                 | 0        |
| 8              | 0             | 01                     | 10                     | 00                       | 1                 | 1        |
| 8              | 0             | 01                     | 11                     | 00                       | 1                 | 1        |
| 8              | 0             | 10                     | 00                     | 10                       | 0                 | 0        |
| 8              | 0             | 10                     | 01                     | 00                       | 1                 | 1        |
| 8              | 0             | 10                     | 10                     | 00                       | 1                 | 1        |
| 8              | 0             | 10                     | 11                     | 00                       | 1                 | 1        |
| 8              | 0             | 11                     | 00                     | 11                       | 0                 | 0        |
| 8              | 0             | 11                     | 01                     | 10                       | 0                 | 0        |
| 8              | 0             | 11                     | 10                     | 00                       | 1                 | 1        |
| 8              | 0             | 11                     | 11                     | 00                       | 1                 | 1        |
| 8              | 1             | 00                     | 00                     | 00                       | 0                 | 1        |
| 8              | 1             | 00                     | 01                     | 00                       | 0                 | 1        |
| 8              | 1             | 00                     | 10                     | 00                       | 0                 | 1        |
| 8              | 1             | 00                     | 11                     | 00                       | 0                 | 1        |
| 8              | 1             | 01                     | 00                     | 11                       | 0                 | 0        |
| 8              | 1             | 01                     | 01                     | 11                       | 0                 | 0        |
| 8              | 1             | 01                     | 10                     | 11                       | 0                 | 0        |
| 8              | 1             | 01                     | 11                     | 11                       | 0                 | 0        |
| 8              | 1             | 10                     | 00                     | 11                       | 0                 | 0        |
| 8              | 1             | 10                     | 01                     | 11                       | 0                 | 0        |
| 8              | 1             | 10                     | 10                     | 11                       | 0                 | 0        |
| 8              | 1             | 10                     | 11                     | 11                       | 0                 | 0        |
| 8              | 1             | 11                     | 00                     | 11                       | 0                 | 0        |
| 8              | 1             | 11                     | 01                     | 11                       | 0                 | 0        |
| 8              | 1             | 11                     | 10                     | 11                       | 0                 | 0        |
| 8              | 1             | 11                     | 11                     | 11                       | 0                 | 0        |

Corrimiento a la Derecha:

| **ALUControl** | **ALUFlagIn** | **Operando A (2 bits)** | **Operando B (2 bits)** | **Y = A >> B (2 bits)** | **C (Carry Out)** | **Zero** |
|:--------------:|:-------------:|:-----------------------:|:-----------------------:|:------------------------:|:-----------------:|:--------:|
| 9              | 0             | 00                     | 00                     | 00                       | 0                 | 1        |
| 9              | 0             | 00                     | 01                     | 00                       | 0                 | 1        |
| 9              | 0             | 00                     | 10                     | 00                       | 0                 | 1        |
| 9              | 0             | 00                     | 11                     | 00                       | 0                 | 1        |
| 9              | 0             | 01                     | 00                     | 01                       | 0                 | 0        |
| 9              | 0             | 01                     | 01                     | 00                       | 1                 | 1        |
| 9              | 0             | 01                     | 10                     | 00                       | 1                 | 1        |
| 9              | 0             | 01                     | 11                     | 00                       | 1                 | 1        |
| 9              | 0             | 10                     | 00                     | 10                       | 0                 | 0        |
| 9              | 0             | 10                     | 01                     | 01                       | 1                 | 0        |
| 9              | 0             | 10                     | 10                     | 00                       | 1                 | 1        |
| 9              | 0             | 10                     | 11                     | 00                       | 1                 | 1        |
| 9              | 0             | 11                     | 00                     | 11                       | 0                 | 0        |
| 9              | 0             | 11                     | 01                     | 01                       | 1                 | 0        |
| 9              | 0             | 11                     | 10                     | 00                       | 1                 | 1        |
| 9              | 0             | 11                     | 11                     | 00                       | 1                 | 1        |
| 9              | 1             | 00                     | 00                     | 00                       | 0                 | 1        |
| 9              | 1             | 00                     | 01                     | 00                       | 0                 | 1        |
| 9              | 1             | 00                     | 10                     | 00                       | 0                 | 1        |
| 9              | 1             | 00                     | 11                     | 00                       | 0                 | 1        |
| 9              | 1             | 01                     | 00                     | 01                       | 0                 | 0        |
| 9              | 1             | 01                     | 01                     | 00                       | 1                 | 1        |
| 9              | 1             | 01                     | 10                     | 00                       | 1                 | 1        |
| 9              | 1             | 01                     | 11                     | 00                       | 1                 | 1        |
| 9              | 1             | 10                     | 00                     | 10                       | 0                 | 0        |
| 9              | 1             | 10                     | 01                     | 11                       | 1                 | 0        |
| 9              | 1             | 10                     | 10                     | 01                       | 1                 | 0        |
| 9              | 1             | 10                     | 11                     | 01                       | 1                 | 0        |
| 9              | 1             | 11                     | 00                     | 11                       | 0                 | 0        |
| 9              | 1             | 11                     | 01                     | 11                       | 0                 | 0        |
| 9              | 1             | 11                     | 10                     | 11                       | 0                 | 0        |
| 9              | 1             | 11                     | 11                     | 11                       | 0                 | 0        |


#### 5. Testbench

Las semillas para generar numeros aleatorios se puede cambiar de manera accesible mediante el testbench cambiando el valor hexa de 32 bits de la variable "seed".

Con Semilla para randoms: seed = 32'hA3F7B9C1;

```bash
Using default typical min/typ/max.
=S:Begin run-time elaboration and static initialization...
=N:[dumpMXD] preparing MXD dump to 'waves.mxd'.
=N:[dump] Dump started at time 0
=N:Starting event scheduler...
Operaci¾n Exitosa: ALUControl=0000, A=0111, B=0001, ALUFlagIn=1, Y=0001, C=x, Z=0
Operaci¾n Exitosa: ALUControl=0001, A=1111, B=1111, ALUFlagIn=0, Y=1111, C=x, Z=0
Operaci¾n Exitosa: ALUControl=0010, A=0110, B=1001, ALUFlagIn=1, Y=0000, C=1, Z=1
Operaci¾n Exitosa: ALUControl=0011, A=0111, B=1111, ALUFlagIn=1, Y=0000, C=1, Z=1
Operaci¾n Exitosa: ALUControl=0100, A=0100, B=1101, ALUFlagIn=1, Y=1100, C=0, Z=0
Operaci¾n Exitosa: ALUControl=0101, A=1001, B=1100, ALUFlagIn=0, Y=0110, C=x, Z=0
Operaci¾n Exitosa: ALUControl=0110, A=1101, B=1000, ALUFlagIn=1, Y=0110, C=0, Z=0
Operaci¾n Exitosa: ALUControl=0111, A=0110, B=1000, ALUFlagIn=1, Y=1110, C=x, Z=0
Operaci¾n Exitosa: ALUControl=1000, A=0001, B=1000, ALUFlagIn=0, Y=0000, C=0, Z=1
Operaci¾n Exitosa: ALUControl=1001, A=1010, B=1110, ALUFlagIn=0, Y=0000, C=0, Z=1
=N:[dumpMXD] closing MXD dump
=T:Simulation terminated by $finish at time 100000 (sim_1\new\ALU_tb.v:135);
```
![image](https://github.com/user-attachments/assets/d7d06fc7-c0d6-4d8a-81f2-ece2f17951e0)



Con semilla para randoms: seed = 32'hDFADAEAF;

Y utilizando la herramienta dsim se obtuvo en la terminal:

```bash
=S:Begin run-time elaboration and static initialization...
=N:[dumpMXD] preparing MXD dump to 'waves.mxd'.
=N:[dump] Dump started at time 0
=N:Starting event scheduler...
Operaci¾n Exitosa: ALUControl=0000, A=1101, B=0010, ALUFlagIn=0, Y=0000, C=x, Z=1
Operaci¾n Exitosa: ALUControl=0001, A=0000, B=0100, ALUFlagIn=1, Y=0100, C=x, Z=0
Operaci¾n Exitosa: ALUControl=0010, A=0100, B=0110, ALUFlagIn=0, Y=1010, C=0, Z=0
Operaci¾n Exitosa: ALUControl=0011, A=0101, B=1100, ALUFlagIn=1, Y=1101, C=0, Z=0
Operaci¾n Exitosa: ALUControl=0100, A=0010, B=0011, ALUFlagIn=1, Y=0010, C=0, Z=0
Operaci¾n Exitosa: ALUControl=0101, A=1001, B=0110, ALUFlagIn=1, Y=1001, C=x, Z=0
Operaci¾n Exitosa: ALUControl=0110, A=0111, B=1110, ALUFlagIn=0, Y=1001, C=1, Z=0
Operaci¾n Exitosa: ALUControl=0111, A=0101, B=1101, ALUFlagIn=0, Y=1000, C=x, Z=0
Operaci¾n Exitosa: ALUControl=1000, A=1000, B=1100, ALUFlagIn=1, Y=1111, C=1, Z=0
Operaci¾n Exitosa: ALUControl=1001, A=1110, B=1101, ALUFlagIn=1, Y=1111, C=1, Z=0
=N:[dumpMXD] closing MXD dump
=T:Simulation terminated by $finish at time 100000 (sim_1\new\ALU_tb.v:135);
```
![image](https://github.com/user-attachments/assets/3890b563-b3c5-4cbe-a22f-f9da1aee7082)

Como última prueba se generaron los valores con la semilla: seed = 32'h7E5D3A9F;


```bash
=N:[dumpMXD] preparing MXD dump to 'waves.mxd'.
=N:[dump] Dump started at time 0
=N:Starting event scheduler...
Operaci¾n Exitosa: ALUControl=0000, A=1110, B=0001, ALUFlagIn=0, Y=0000, C=x, Z=1
Operaci¾n Exitosa: ALUControl=0001, A=0110, B=1010, ALUFlagIn=1, Y=1110, C=x, Z=0
Operaci¾n Exitosa: ALUControl=0010, A=0010, B=0110, ALUFlagIn=1, Y=1001, C=0, Z=0
Operaci¾n Exitosa: ALUControl=0011, A=1011, B=1000, ALUFlagIn=0, Y=1100, C=0, Z=0
Operaci¾n Exitosa: ALUControl=0100, A=0001, B=1010, ALUFlagIn=0, Y=0000, C=0, Z=1
Operaci¾n Exitosa: ALUControl=0101, A=1110, B=1000, ALUFlagIn=0, Y=0001, C=x, Z=0
Operaci¾n Exitosa: ALUControl=0110, A=0001, B=0000, ALUFlagIn=0, Y=0001, C=0, Z=0
Operaci¾n Exitosa: ALUControl=0111, A=1101, B=0111, ALUFlagIn=0, Y=1010, C=x, Z=0
Operaci¾n Exitosa: ALUControl=1000, A=1100, B=1100, ALUFlagIn=0, Y=0000, C=0, Z=1
Operaci¾n Exitosa: ALUControl=1001, A=1111, B=0010, ALUFlagIn=0, Y=0011, C=1, Z=0
=N:[dumpMXD] closing MXD dump
=T:Simulation terminated by $finish at time 100000 (sim_1\new\ALU_tb.v:135);
```

![image](https://github.com/user-attachments/assets/ac0bce5c-c7a8-4c30-b9d6-a88c704a519b)



## Apendices:
### Apendice 1: Notación de Pines Tang Nano
![pin_map](https://github.com/user-attachments/assets/e29f3a75-c2ac-441d-ada5-0436738a9cc2)


