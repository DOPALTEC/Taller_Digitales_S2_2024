# LABORATORIO 3: MICROCONTROLADOR

## 1. Abreviaturas y definiciones
- **FPGA**: Field Programmable Gate Arrays

## 2. Referencias
[0] David Harris y Sarah Harris. *Digital Design and Computer Architecture. RISC-V Edition.* Morgan Kaufmann, 2022. ISBN: 978-0-12-820064-3

https://cs.uns.edu.ar/materias/se/2019/descargas/teoria/clase01-introduccion-handouts.pdf

## 3. Desarrollo

### 3.N PLANTILLA PARA MODULOS (COPIAR Y PEGAR)
#### 1. Encabezado del módulo
```SystemVerilog

```
#### 2. Parámetros
- Palabra: Denota el tamaño de bits de las entradas y salidas de los registros.

#### 3. Entradas y salidas:
- `entrada_i`: descripción de la entrada
- `salida_i`: descripción de la salida

#### 4. Criterios de diseño



#### 5. Testbench
Descripción y resultados de las pruebas hechas



### 3.N Iterfaz de Usuario para Protocolo UART
#### 1. Encabezado del módulo
```SystemVerilog

```
#### 2. Parámetros
- Palabra: Denota el tamaño de bits de las entradas y salidas de los registros.

#### 3. Entradas y salidas:
- `entrada_i`: descripción de la entrada
- `salida_i`: descripción de la salida

#### 4. Criterios de diseño



- Consideraciones de Diseño:


  1. En el constraint se aplica rxd y txd con respecto a la computadora, por tanto los valores de transmisión y recepción se invierten ya que los módulos están escritos con respecto a la FPGA.
  2. Para la asignación del baudrate en el módulo se realiza el cálculo del valor que va a tomar "prescale" de la siguiente manera:

  $$
      prescale=\frac{clk}{8*baudios} \rightarrow
  $$

$$
      prescale=\frac{200x10^6}{8*9600} \rightarrow
  $$

  $$
      prescale=2604
  $$



  3. El registro de control no reconoce si el dato cambia y si se está transmitiendo un dato repetidas veces, toma la desición de enviar solamente si en el registro de control send está activo. Le es indiferente si ya se transmitió o no, ya que es obligación del RISCV tomar esto en cuenta.

#### 5. Testbench
Descripción y resultados de las pruebas hechas


### 3.N Microprocesador RV32 
#### 1. Encabezado del módulo
```SystemVerilog
picorv32 (
		.clk(CLK_200MHZ),
		.resetn(rst),
		.mem_valid   (mem_valid  ),
		.mem_instr   (mem_instr  ),
		.mem_ready   (mem_ready  ),
		.mem_addr    (mem_addr   ),
		.mem_wdata   (mem_wdata  ),
		.mem_wstrb   (mem_wstrb  ),
		.mem_rdata   (mem_rdata  ),
		.irq         (irq        )
);
```
#### 2. Parámetros
- `STACKADDR=32'h0007_FFFF`: Denota el tamaño que va a tener el mapa de memoria.
- `PROGADDR_RESET=32'h 0000_0000`: Indica el valor de la posición inicial de lectura de las instrucciones, ubicadas en la memoria de instrucciones ROM.
- `PROGADDR_IRQ=0`: Corresponde a las direcciones de las interrupciones del programa. Se mantendrá deshabilitada (0).
- `BARREL_SHIFTER=1`: Permite realizar operaciones de desplazamiento (shift) de bits, en una sola operación útil para operaciones rápidas de manipulación de bits. Permitiendo que no se implemente en multiples ciclos, sino solo con un ciclo. Esto puede ser útil en el procesamiento de imagenes mejorando la eficiencia.
- `ENABLE_COMPRESSED=0`: Utilizado para las instrucciones comprimidas. Se deshabilita.
- `ENABLE_COUNTERS=1`: Habilita los contadores de rendimiento que se pueden usar para medir la ejecución del procesador, como el conteo de ciclos, instrucciones ejecutadas o propósitos de depuración. Útil para gestionar sincronización o datos procesados. Se puede aplicar para contar píxeles o realizar un bucle en el procesamiento de la imagen.
- `ENABLE_MUL=0`: Deshabilita la multiplicación.
- `ENABLE_DIV=0`: Deshabilita la división.
- `ENABLE_FAST_MUL=0`: Multiplicación rápida deshabilitada.
- `ENABLE_IRQ=0`: desativa las interrupciones en las instrucciones.
- `ENABLE_IRQ_QREGS=0`: Descarta la interrupción en los registros.

#### 3. Entradas y salidas:
- `clk`: Pulsos de Reloj Generado con el PLL
- `resetn`: Señal de reset para reiniciar el sistema
- 

#### 4. Criterios de diseño



#### 5. Testbench
Descripción y resultados de las pruebas hechas



## Apendices:
### Apendice 1: Tabla de Valores Decimal/Binario/Hexadecimal

![Tabla](https://github.com/user-attachments/assets/bcae3896-0cbf-4c12-9fab-c2c38cd8a7da)

### Apendice 2: Mapa de Memoria del Microprocesador

![image](https://github.com/user-attachments/assets/a50e704a-0a38-4c01-b78f-749326d4bb6a)

### Apendice 3: Configuraciónes para despliegue de imagenes del procesador del LCD ST7789V

![image](https://github.com/user-attachments/assets/5030179a-0007-42cb-a36e-270d80de65de)
