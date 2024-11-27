# LABORATORIO 3: MICROCONTROLADOR

## 1. Abreviaturas y definiciones
- **FPGA**: Field Programmable Gate Arrays

## 2. Referencias
[0] David Harris y Sarah Harris. *Digital Design and Computer Architecture. RISC-V Edition.* Morgan Kaufmann, 2022. ISBN: 978-0-12-820064-3

https://cs.uns.edu.ar/materias/se/2019/descargas/teoria/clase01-introduccion-handouts.pdf

https://shadowcode.io/how-to-package-picorv32-vivado-ip-integrator/

https://riscv.org/wp-content/uploads/2017/05/riscv-spec-v2.2.pdf

http://www.riscvbook.com/greencard-20181213.pdf

http://riscvbook.com/spanish/guia-practica-de-risc-v-1.0.5.pdf

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

Set de instrucciones para probar funcionalidad de operaciones.

### 3.N LCD y ST7789V
#### 1. Encabezado del módulo
```SystemVerilog

```
#### 2. Parámetros
- Palabra: Denota el tamaño de bits de las entradas y salidas de los registros.

#### 3. Entradas y salidas:
- `entrada_i`: descripción de la entrada
- `salida_i`: descripción de la salida

#### 4. Criterios de diseño

- La configuración elegida para el despliegue de imágenes de 16-bit/pixel (RGB 5-6-5-bit input)
- El tamaño de la pantalla LCD es de 240x135. Cada palabra de RAM podría almacenar dos pixeles de 16bits cada uno, por tanto se requeriría de espacio en memoria 16.200 palabras por imagen.


#### 5. Testbench

Set de instrucciones para probar funcionalidad de operaciones.



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


  2. El registro de control no reconoce si el dato cambia y si se está transmitiendo un dato repetidas veces, toma la desición de enviar solamente si en el registro de control send está activo. Le es indiferente si ya se transmitió o no, ya que es obligación del RISCV tomar esto en cuenta.

#### 5. Testbench
Descripción y resultados de las pruebas hechas


### 3.N Microprocesador RV32 
#### 1. Encabezado del módulo
```SystemVerilog
module picorv32 #(
	parameter [ 0:0] ENABLE_COUNTERS = 1,
	parameter [ 0:0] ENABLE_COUNTERS64 = 1,
	parameter [ 0:0] ENABLE_REGS_16_31 = 1,
	parameter [ 0:0] ENABLE_REGS_DUALPORT = 1,
	parameter [ 0:0] LATCHED_MEM_RDATA = 0,
	parameter [ 0:0] TWO_STAGE_SHIFT = 1,
	parameter [ 0:0] BARREL_SHIFTER = 0,
	parameter [ 0:0] TWO_CYCLE_COMPARE = 0,
	parameter [ 0:0] TWO_CYCLE_ALU = 0,
	parameter [ 0:0] COMPRESSED_ISA = 0,
	parameter [ 0:0] CATCH_MISALIGN = 1,
	parameter [ 0:0] CATCH_ILLINSN = 1,
	parameter [ 0:0] ENABLE_PCPI = 0,
	parameter [ 0:0] ENABLE_MUL = 0,
	parameter [ 0:0] ENABLE_FAST_MUL = 0,
	parameter [ 0:0] ENABLE_DIV = 0,
	parameter [ 0:0] ENABLE_IRQ = 0,
	parameter [ 0:0] ENABLE_IRQ_QREGS = 1,
	parameter [ 0:0] ENABLE_IRQ_TIMER = 1,
	parameter [ 0:0] ENABLE_TRACE = 0,
	parameter [ 0:0] REGS_INIT_ZERO = 0,
	parameter [31:0] MASKED_IRQ = 32'h 0000_0000,
	parameter [31:0] LATCHED_IRQ = 32'h ffff_ffff,
	parameter [31:0] PROGADDR_RESET = 32'h 0000_0000,
	parameter [31:0] PROGADDR_IRQ = 32'h 0000_0010,
	parameter [31:0] STACKADDR = 32'h ffff_ffff
) (
	input clk, resetn,
	output reg        mem_valid,
	output reg        mem_instr,
	input             mem_ready,

	output reg [31:0] mem_addr,
	output reg [31:0] mem_wdata,
	output reg [ 3:0] mem_wstrb,
	input      [31:0] mem_rdata,
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
**ENTRADAS**
- `clk`: Pulsos de Reloj Generado con el PLL
- `resetn`: Señal de reset para reiniciar el sistema
- `mem_ready`: Señal que indica que la operación de memoria ha finalizado y que los datos están disponibles o que se ha completado la escritura. El núcleo utiliza esta señal para saber cuándo puede proceder después de haber iniciado una transferencia de memoria.
- `mem_rdata`: Contiene los datos leídos de la memoria en una operación de lectura. El valor en esta señal es accesible para el núcleo cuando mem_ready está activo tras una solicitud de lectura.


**SALIDAS**
- `trap`: Señal que indica si se ha producido un evento de trampa (trap) en el núcleo. Un evento de trampa es una condición especial que puede ser causada por excepciones o interrupciones. Si se activa, puede requerir que el sistema maneje esta condición de manera especial.
- `mem_valid`: Señal que indica que el núcleo está realizando una transferencia de memoria. Esta señal se activa cuando el núcleo desea leer o escribir en la memoria, permaneciendo activa mientras el núcleo espera que mem_ready se active.
- `mem_instr`: Indica si la transferencia de memoria es una operación de lectura de instrucción. Se utiliza para distinguir entre las operaciones de lectura de datos y de instrucciones, permitiendo que el controlador de memoria maneje cada tipo de operación adecuadamente. La transferencia de memoria se está llevando a cabo, es una solicitud para obtener una instrucción. Cuando está activa, el núcleo señala que se intenta acceder a la memoria para obtener instrucciones en vez de datos.
- `mem_addr`: Representa la dirección de memoria en la que se realizará la operación de lectura o escritura. Esta señal debe ser válida y estable durante la operación de transferencia de memoria.
- `mem_wdata`: Datos que se desean escribir en la memoria durante una operación de escritura. Este valor se utiliza solo cuando mem_valid está activo y mem_wstrb no es cero.
- `mem_wstrb`: Señal de habilitación de escritura que indica qué bytes del dato en mem_wdata deben ser escritos en la memoria. Cada uno de los 4 bits de esta señal corresponde a un byte en la dirección especificada por mem_addr.

#### 4. Criterios de diseño

- La memoria ROM va de address en address, mientras que el Contador de Programa de RV32 va de 4 bytes en 4 bytes, se debe por tanto, dividir el archivo de instrucciones en 4 partes por instrucción, para que así la dirección ingresada corresponda a un formato de bytes. 
- Para los accesos a memorias como RAM debido a que estan en direcciones de valor alto en el mapa de memoria se debe accesar a ellas cargando parte de ellas en un registro base con una instrucción `lui` y luego aplicar el desplazamiento necesario ya que un inmediato solo llega hasta 12 bits. La RV32 no reconoce direcciones de memoria de 0x40000. Se debe hacer un tratamiento a una señal de escritura basada en sus limites. `FFF`.
- La salida del sw propiamente ocurre después de que la instrucción que le procede se haya ejecutado. 
- En el mapa de memoria la RAM se encuentra entre 0x40000 y 0x80000 dando como resultado que se el tamaño que abarcan las direcciones de memoria es 0x40000. Esta cantidad de direcciones tiene un valor de 262144 bytes. Por cada instruccion se requieren 4 bytes dando como resultado entonces que se pueden almacenar 65536 direcciones, por ende esa misma cantidad de palabras. El IP core posee exactamente este límite por lo cual solo es necesario utilizar una RAM.
- El último bit del inmediato representa la extensión de signo por tanto el inmediato solo puede llegar hasta 0x7FF = 2047.
- Para las instrucciones sw, solamente se obtienen direcciones de escritura de múltiplos de 4 por lo tanto debe haber una traducción para la RAM.
- El procesador no soporta 200MHz. Se comporta correctamente con 100MHz
- Despues de dos saltos de instrucción pc+4 si solo hay ceros, el procesador se detiene el mismo.
- El tamaño de una imagen es de 64800 transmisiones. A estas transmisiones se le envía un número al final que corresponde a el número de imagen.

**SOFTWARE PARA PROCESAR LAS IMÁGENES**
```


```

#### 5. Testbench





## Apendices:
### Apendice 1: Tabla de Valores Decimal/Binario/Hexadecimal

![Tabla](https://github.com/user-attachments/assets/bcae3896-0cbf-4c12-9fab-c2c38cd8a7da)

### Apendice 2: Mapa de Memoria del Microprocesador

![image](https://github.com/user-attachments/assets/a50e704a-0a38-4c01-b78f-749326d4bb6a)

### Apendice 3: Configuraciónes para despliegue de imagenes del procesador del LCD ST7789V

![image](https://github.com/user-attachments/assets/5030179a-0007-42cb-a36e-270d80de65de)

### Apendice 4: Posición en RAM que ocupará cada Imagen

| Imagen # | Dirección de inicio | Dirección de fin |
|----------|----------------------|------------------|
| 1        | 0x40000             | 0x4FD20         |
| 2        | 0x4FD24             | 0x5FA44         |
| 3        | 0x5FA48             | 0x6F768         |
| 4        | 0x6F76C             | 0x7F48C         |
| 5        | 0x7F490             | 0x8F1B0         |
| 6        | 0x8F1B4             | 0x9EED4         |
| 7        | 0x9EED8             | 0xAEBF8         |
| 8        | 0xAEBFC             | 0xBE91C         |



