# LABORATORIO 2 

## 1. Abreviaturas y definiciones
- **FPGA**: Field Programmable Gate Arrays

## 2. Referencias
[0] David Harris y Sarah Harris. *Digital Design and Computer Architecture. RISC-V Edition.* Morgan Kaufmann, 2022. ISBN: 978-0-12-820064-3

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

##### Divisor de Reloj

##### Antirebote

#### 5. Testbench
Descripción y resultados de las pruebas hechas

#### 6. Implementación Física



# Ejercicio 3


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

