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

### 3.1 Interfaz de Protocolo UART para la Tang Nano 9k
#### 1. Encabezado del módulo
```SystemVerilog
module top
    (
    input clk,
    input rst_n,
    input [1:0] enable,  
    output [1:0] count,
    output reg count_bit1_reg,
    output reg count_bit0_reg,
    output reg enable_bit1_reg,
    output reg enable_bit0_reg,
    output uart_tx,

    input resetn,
    input ser_rx,
    output lcd_resetn,
    output lcd_clk,
    output lcd_cs,
    output lcd_rs,
    output lcd_data 
);
```
#### 2. Parámetros
- 

#### 3. Entradas y salidas:
- `clk`: Señal de reloj del sistema que sincroniza las operaciones del módulo.
- `rst_n`: Señal de reset global para reiniciar el sistema.
- `enable`: Controla la habilitación de ciertas operaciones dentro del módulo.
- `resten`: Señal de reset específica para ciertas partes del módulo, posiblemente independiente de rst_n.
- `ser_rx`: Recibe datos en serie para la UART desde un dispositivo externo.
- `count`: Proporciona el valor actual de un contador.
- `count_bit1_reg`: Valor del bit 1 del registro del contador.
- `count_bit0_reg`: Valor del bit 0 del registro del contador.
- `enable_bit1_reg`: Refleja el estado del bit 1 del registro de habilitación.
- `enable_bit0_reg`: Refleja el estado del bit 0 del registro de habilitación.
- `uart_tx`: Transmite datos en serie desde la UART hacia un dispositivo externo.
- `lcd_resetn`: Señal de reset para el módulo LCD.
- `lcd_clk`: Señal de reloj para el módulo LCD.
- `lcd_cs`: Señal de selección de chip para el módulo LCD.
- `lcd_rs`: Señal para seleccionar entre comandos o datos para el LCD.
- `lcd_data`: Línea de datos para el módulo LCD.

### 3.2 LCD y ST7789V
#### 1. Encabezado del módulo
```SystemVerilog
module lcd_controller (
    input wire clk,
    input wire resetn,
    input wire [7:0] uart_data,
    input wire byte_ready,
    output wire lcd_resetn,
    
    output wire lcd_clk,
    output wire lcd_cs,
    output wire lcd_rs,
    output wire lcd_data
```
#### 2. Parámetros
- 

#### 3. Entradas y salidas:
- `clk`: Señal de reloj del sistema que sincroniza todas las operaciones del controlador LCD.
- `resetn`: Señal de reinicio para reestablecer el módulo.
- `uart_data`: Contiene los datos recibidos por UART que deben procesarse o enviarse al LCD.
- `byte_ready`: Señal que indica que un nuevo byte de datos está listo para ser procesado.
- `lcd_resetn`: Señal de reset para el módulo LCD que permite reiniciar el hardware del display.
- `lcd_clk`: Señal de reloj enviada al LCD, utilizada para sincronizar las comunicaciones.
- `lcd_cs`: Señal de selección de chip para el LCD. Indica cuándo el módulo LCD está siendo activamente controlado.
- `lcd_rs`: Señal de selección de registro para distinguir entre comandos y datos enviados al LCD
- `lcd_data`: Línea que transporta los datos enviados al LCD para ser mostrados o utilizados en comandos.

#### 4. Criterios de diseño

- La configuración elegida para el despliegue de imágenes de 16-bit/pixel (RGB 5-6-5-bit input)
- El tamaño de la pantalla LCD es de 240x135. Cada palabra de RAM podría almacenar dos pixeles de 16bits cada uno, por tanto se requeriría de espacio en memoria 16.200 palabras por imagen.


### 3.3 Iterfaz para Protocolo UART
#### 1. Encabezado del módulo
```SystemVerilog
module Interfaz_UART_Nexys #(parameter palabra = 32, parameter prescale = 1302)(
    input  wire clk,
    input  wire rst,
    input wire wr_i,
    input wire reg_sel_i,
    input wire addr_i,
    input wire [palabra-1:0] entrada_i,
    input wire [palabra-1:0] entrada_i_data,
    output wire [palabra-1:0] ctrl,
    output wire [palabra-1:0] data,
    input  wire rxd,
    output wire txd
    );
```
#### 2. Parámetros
- `palabra`: Tamaño solicitado de 32 bits para los valores de la interfaz, tanto para los datos como para la señal de control
- `prescale`: Escala equivalente para realizar comunicaciones a 9600 baudios

#### 3. Entradas y salidas:
- `clk`: Reloj utilizado para sincronizar los pulsos
- `rst`: Botón asignado al reseteo del sistema
- `wr_i`: Representa la escritura ya sea en el registro de datos o de control
- `reg_sel_i`: Selecciona a cual de los dos registros se le va a aplicar el proceso solicitado
- `addr_i`: Elige entre las dos direcciones disponibles que tiene el registro de datos, ya sea del dato que se va a enviar o el dato que se recibió
- `entrada_i`: Representa el codigo de control que se le va a envíar al registro de control, usado para activar el bit "send" y transmitir lo que esté guardado en el registro de datos
- `entrada_i_data`: Representa el dato que se va a enviar vía UART mediante tx
- `ctrl`: Representa la salida del registro de control
- `data`: Representa la salida del registro de datos
- `rxd`: Representa los pulsos correspondientes al recibimiento de datos en protocolo UART
- `txd`: Denota los bits de transmisión en formato UART
#### 4. Criterios de diseño



- Consideraciones de Diseño:


  1. En el constraint se aplica rxd y txd con respecto a la computadora, por tanto los valores de transmisión y recepción se invierten ya que los módulos están escritos con respecto a la FPGA.


  2. El registro de control no reconoce si el dato cambia y si se está transmitiendo un dato repetidas veces, toma la desición de enviar solamente si en el registro de control send está activo. Le es indiferente si ya se transmitió o no, ya que es obligación del RISCV tomar esto en cuenta.

#### 5. Testbench
- Usando el mismo tb correspondiente a la sección del procesadro RV32, se realizó una simulación de una imagen con un tamaño de 8 bytes, denotada como la imagen 3.
- Al activarse reg_sel y addr_i, indica que se solicita un dato recibido lo cual inmediatamente limpia el valor del registro de datos.
- El valor de ctrl[1] se activa en alto para indicar que se recibió un byte nuevo y se desactiva cuando se solicita ese dato.


![image](https://github.com/user-attachments/assets/0a45dacf-529a-4fc9-aacb-433880dc25e4)

- new_rx es activado en alto el cual representa el valor de ctrl[1] y a su vez WR2_ctrl e IN2_ctrl se activan para actualizar el valor de la salida de control.

![image](https://github.com/user-attachments/assets/3de98e04-53e6-44d9-97d1-639f1c26a731)

- Para el caso de la comunicación con la TANG NANO, se habilitó otro módulo duplicado de esta interfaz.
- Al detectar que se recibe algo, con la ayuda del procesador si es uno de los numeros correspondiente a una imagen, procede a transmitir lo que esté guardado en la posición específica de la RAM que se le asigno a ese número de imagen.
- Recorre la RAM y envía el tamaño de la imagen
 

![image](https://github.com/user-attachments/assets/14c8a1b2-ea67-430f-94a1-a848c6437238)

- El bit send se activa las veces necesarias para transmitir la cantidad de bytes que tenga la imagen.

  ![image](https://github.com/user-attachments/assets/58d428bd-0bec-4c68-91db-675d3e6cd3ea)


### 3.3 Microprocesador RV32 
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
lui x1, 0x2000                              //0x00  000020B7 (Valor base para Direcciones con 0x2000)
lui x2, 0x40000                             //0x04  000401B7 (Valor base para direcciones de RAM 0x40000)
addi x3, x1, 4                              //0x08  00408193 (Direccion de LED 0x2004)
addi x4, x1, 0x10                           //0x0C  01008213 (Direccion de UART A Ctrl 0x2010)
addi x5, x1, 0x18                           //0x10  01808293 (Direccion de UART A Data 1 0x2018)
addi x6, x1, 0x1C                           //0x14  01C08313 (Direccion de UART A Data 2 0x201C)
addi x7, x1, 0x20                           //0x18  02008393 (Direccion de UART B Ctrl 0X2020)
addi x8, x1, 0x28                           //0x1C  02808413 (Direccion de UART B Data 1 0x2028)
addi x9, x1, 0x2C                           //0x20  02C08493 (Direccion de UART B Data 2 0x202C)
sw x0, 0(x4)                                //0x24  00022023 (Inicializa ctrl=0)
addi x10, x0, 2                             //0x28  00200513 (Valor Representativo de ctrl[1]=1)
addi x12, x0, 4                             //0x2C  00400613 (Referencia para contador de bytes en una word de RAM)
addi x13, x0, 0                             //0x30  00000693 (Contador de bytes en una palabra RAM)
addi x15, x0, 0                             //0x34  00000793 (Inicializar Contador de transmisiones totales)
lui x19, 0x40000                            //0x38  000409B7 (Recorre la RAM en +0x4)
addi x11, x0, 1                             //0x3C  00100593
lui x27, 0x0F000                            //0x40  00010DB7
addi x27, x27, 0xD24                        //0x44  D24D8D93
addi x28, x0, 3                             //0X48  00300E13
addi x29, x0, 5                             //0x4C  00500E93
addi x30, x0, 6                             //0x50  00600F13
addi x31, x0, 7                             //0x54  00700F93
addi x23, x0, 8                             //0x58  00800B93

check:  lw x16, 0(x4)                       //0x5C  00022803 Carga el valor actual de ctrl
        and x17, x16, x10                   //0x60  00A878B3 Aisla el bit ctrl[1]
        bne x17, x0, exit_loop_num_img      //0x64  00089A63 Sale de "check" si ctrl==1
        lw x21, 0(x7)                       //0x68  0003AA83 Carga ctrl de la tang
        and x17, x21, x10                   //0x6C  00AAF8B3 Aisla ctrl[1]
        bne x17, x0, exit_loop_tang         //0x70  10089A63 Si no es igual a cero sale de "loop_tang" (0x20 instrucciones adelante *4)
        jalr x0, x0, check                  //0x74  05C00067 Salta a "check"

exit_loop_num_img:
lw x20,0(x6)                                //0x78  00032A03 Carga el numero de imagen
lui x19, 0x40000                            //0x7C  000409B7 (Recorre la RAM en +0x4)
addi x19, x19, 0                            //0x80  00098993 (Direccion de byte en la RAM)
lui x14, 0x40000                            //0x84  00040737 (Tamanio de Imagen 1 en RAM upper)

beq x20, x11, img_1                         //0x88  02BA0063 (Salta a "img_1" si el numero de imagen es 1)
beq x20, x10, img_2                         //0x8C  02AA0263 (Salta a "img_2" si el numero de imagen es 2)
beq x20, x28, img_3                         //0x90  03CA0663 (Salta a "img_3" si el numero de imagen es 3)          
beq x20, x12, img_4                         //0x94  02CA0C63 (Salta a "img_4" si el numero de imagen es 4)
beq x20, x29, img_5                         //0x98  05DA0463 (Salta a "img_5" si el numero de imagen es 5)
beq x20, x30, img_6                         //0x9C  05EA0E63 (Salta a "img_6" si el numero de imagen es 6)
beq x20, x31, img_7                         //0xA0  07FA0A63 (Salta a "img_7" si el numero de imagen es 7)
beq x20, x23, img_8                         //0xA4  097A0863 (Salta a "img_8" si el numero de imagen es 8)

img_1:
        addi x14, x14, 0x008                //0xA8  00870713 (Tamanio de Imagen 1 en RAM lower)
        jalr x0,x0, loop                    //0xAC  15800067 Salta a "loop" al tener la direccion RAM de imagen 2

img_2:
        add x19, x19, x27                   //0xB0  01B989B3 Genera la direccion 0x4FD24 (Posicion de la imagen 2 en RAM)
        addi x14, x19, 0x008                //0xB4  00898713 (Tamanio de Imagen 1 en RAM lower)
        jalr x0,x0, loop                    //0xB8  15800067 Salta a "loop" al tener la direccion RAM de imagen 2

img_3:
        add x19, x19, x27                   //0xBC  01B989B3
        add x19, x19, x27                   //0xC0  01B989B3
        addi x14, x19, 0x008                //0xC4  00898713
        jalr x0,x0, loop                    //0xC8  15800067

img_4:
        add x19, x19, x27                   //0xCC  01B989B3
        add x19, x19, x27                   //0xD0  01B989B3
        add x19, x19, x27                   //0xD4  01B989B3
        addi x14, x19, 0x008                //0xD8  00898713
        jalr x0,x0, loop                    //0xDC  15800067

img_5:
        add x19, x19, x27                   //0xE0  01B989B3     
        add x19, x19, x27                   //0xE4  01B989B3
        add x19, x19, x27                   //0xE8  01B989B3
        add x19, x19, x27                   //0xEC  01B989B3
        addi x14, x19, 0x008                //0xF0  00898713
        jalr x0,x0, loop                    //0xF4  15800067

img_6:
        add x19, x19, x27                   //0xF8  01B989B3
        add x19, x19, x27                   //0xFC  01B989B3
        add x19, x19, x27                   //0x100  01B989B3
        add x19, x19, x27                   //0x104  01B989B3
        add x19, x19, x27                   //0x108  01B989B3
        addi x14, x19, 0x008                //0x10C  00898713
        jalr x0,x0, loop                    //0x110  15800067

img_7:
        add x19, x19, x27                   //0x114  01B989B3
        add x19, x19, x27                   //0x118  01B989B3
        add x19, x19, x27                   //0x11C  01B989B3
        add x19, x19, x27                   //0x120  01B989B3
        add x19, x19, x27                   //0x124  01B989B3
        add x19, x19, x27                   //0x128  01B989B3
        addi x14, x19, 0x008                //0x12C  00898713
        jalr x0,x0, loop                    //0x130  15800067

img_8:
        add x19, x19, x27                   //0x134  01B989B3
        add x19, x19, x27                   //0x138  01B989B3
        add x19, x19, x27                   //0x13C  01B989B3
        add x19, x19, x27                   //0x140  01B989B3
        add x19, x19, x27                   //0x144  01B989B3
        add x19, x19, x27                   //0x148  01B989B3
        add x19, x19, x27                   //0x14C  01B989B3 
        addi x14, x19, 0x008                //0x150  00898713   
        jalr x0,x0, loop                    //0x154  15800067

loop:   
        lw x16, 0(x4)                       //0x158  00022803 (Carga el valor actual de ctrl)
        and x17, x16, x10                   //0x15C  00A878B3 (Aisla el bit ctrl[1])  
        bne x17, x0, exit_loop              //0x160  00089463 (Sale de "loop" si ctrl==1)
        jalr x0, x0, loop                   //0x164  15800067 (Salta a "loop")
exit_loop:lw x18, 0(x6)                     //0x168  00032903 Carga el dato recibido
sb x18, 0(x19)                              //0x16C  01298023 Guarda el dato en la direccion de RAM de en un byte
addi x19, x19, 1                            //0x170  00198993 Aumenta en 1 la direccion de byte en la RAM
beq x19, x14, imagen_escrita                //0x174  00E98463 Si todo el tamaño de imagen ya se guardo completo salta a "imagen_enviada"
jalr x0, x0, loop                           //0x178  15800067 Salta a "loop" si la imagen aun no se ha guardado por completo
imagen_escrita:
sw x20, 0(x3)                               //0x17C  0141A023 Guarda el numero de imagen en LED correspondiente
jalr x0, x0, check                          //0x180  05C00067 Salta a "check"


/////////////////////////////////TRANSMISION A TANG/////////////////////////////////////
exit_loop_tang:
lui x24, 0x40000                            //0x184  00040C37       Inicializa el contador que Recorre la RAM en +0x4
addi x24, x24, 0                            //0x188  000C0C13
lui x25, 0x40000                            //0x18C  00040CB7      Inicializa el contador que Recorre la RAM en +0x4
addi x25, x25, 0                            //0x190  000C8C93
lw x16, 0(x9)                               //0x194  0004A803    Carga el numero de la imagen solicitado por tang

beq x16, x11, img_1_tx                      //0x198  02B80263
beq x16, x10, img_2_tx                      //0x19C  02A80463
beq x16, x28, img_3_tx                      //0x1A0  03C80863
beq x16, x12, img_4_tx                      //0x1A4  02C80E63
beq x16, x29, img_5_tx                      //0x1A8  05D80663
beq x16, x30, img_6_tx                      //0x1AC  07E80063
beq x16, x31, img_7_tx                      //0x1B0  07F80C63
beq x16, x23, img_8_tx                      //0x1B4  09780A63

jalr x0, x0, check                          //0x1B8  05C00067   Si no se cumple que se reciba un numero valido de imagen, vuelve al checkeo


img_1_tx:
        addi x24, x24, 0x008                //0x1BC  008C0C13
        jalr x0,x0, loop_send_tang          //0x1C0  26C00067
img_2_tx:
        add x25, x25, x27                   //0x1C4  01BC8CB3
        addi x24, x25, 0x008                //0x1C8  008C8C13
        jalr x0,x0, loop_send_tang          //0x1CC  26C00067

img_3_tx:
        add x25, x25, x27                   //0x1D0  01BC8CB3
        add x25, x25, x27                   //0x1D4  01BC8CB3
        addi x24, x25, 0x008                //0x1D8  008C8C13
        jalr x0,x0, loop_send_tang          //0x1DC  26C00067
img_4_tx:
        add x25, x25, x27                   //0x1E0  01BC8CB3
        add x25, x25, x27                   //0x1E4  01BC8CB3
        add x25, x25, x27                   //0x1E8  01BC8CB3
        addi x24, x25, 0x008                //0x1EC  008C8C13
        jalr x0,x0, loop_send_tang          //0x1F0  26C00067

img_5_tx:
        add x25, x25, x27                   //0x1F4  01BC8CB3
        add x25, x25, x27                   //0x1F8  01BC8CB3
        add x25, x25, x27                   //0x1FC  01BC8CB3
        add x25, x25, x27                   //0x200  01BC8CB3
        addi x24, x25, 0x008                //0x204  008C8C13
        jalr x0,x0, loop_send_tang          //0x208  26C00067

img_6_tx:
        add x25, x25, x27                   //0x20C  01BC8CB3
        add x25, x25, x27                   //0x210  01BC8CB3
        add x25, x25, x27                   //0x214  01BC8CB3
        add x25, x25, x27                   //0x218  01BC8CB3
        add x25, x25, x27                   //0x21C  01BC8CB3
        addi x24, x25, 0x008                //0x220  008C8C13
        jalr x0,x0, loop_send_tang          //0x224  26C00067

img_7_tx:
        add x25, x25, x27                   //0x228  01BC8CB3
        add x25, x25, x27                   //0x22C  01BC8CB3
        add x25, x25, x27                   //0x230  01BC8CB3
        add x25, x25, x27                   //0x234  01BC8CB3
        add x25, x25, x27                   //0x238  01BC8CB3
        add x25, x25, x27                   //0x23C  01BC8CB3
        addi x24, x25, 0x008                //0x240  008C8C13
        jalr x0,x0, loop_send_tang          //0x244  26C00067

img_8_tx:
        add x25, x25, x27                   //0x248  01BC8CB3
        add x25, x25, x27                   //0x24C  01BC8CB3
        add x25, x25, x27                   //0x250  01BC8CB3
        add x25, x25, x27                   //0x254  01BC8CB3
        add x25, x25, x27                   //0x258  01BC8CB3
        add x25, x25, x27                   //0x25C  01BC8CB3
        add x25, x25, x27                   //0x260  01BC8CB3
        addi x24, x25, 0x008                //0x264  008C8C13
        jalr x0,x0, loop_send_tang          //0x268  26C00067

loop_send_tang: lb x18, 0(x25)              //0x26C  000C8903 Carga byte de la RAM
                sw x18, 0(x8)               //0x270  01242023 Guarda el byte en 0x2028 (UART B DATA_1)
                sw x11, 0(x7)               //0x274  00B3A023 Activa la transmision a la TANG
                sw x0,  0(x7)               //0x278  00038023 Desactiva el bit de transmision para evitar transmisiones repetidas
                loop_busy_tx:   
                        lw x26, 0(x7)             //0x27C  0003AD03 Carga ctrl de la tang
                        and x17, x26, x12         //0x280  00CD78B3 Aisla ctrl[2]
                        beq x17, x0, 0x8          //0x284  00088463 Si ctrl[2]==0 (busy_tx) sale de "loop_busy_tx"
                        jalr x0, x0, loop_busy_tx //0x288  27C00067 Continua corroborando valor de ctrl[2]
                exit_loop_busy_tx:           
                addi x25,x25, 1             //0x28C  001C8C93 Contador de bytes transmitidos de la imagen en RAM
                beq x25,x24,img_transmitida //0x290  018C8463 Si el conteo de bytes transmitidos es igual al tamanio de la imagen en RAM, sale de "loop_send_tang"
                jalr x0, x0, loop_send_tang //0x294  26C00067 Continua transmitiendo bytes de la imagen en RAM A tang
img_transmitida:

```

#### 5. Testbench

- A gran escala, se observa el recibimiento de una imagen simulada con tamaño de 8 bytes. La cual se transmite a la TANG nano al solicitarse una de las imagenes, en este caso la #3.
- Adicionalmente, se muestran los pulsos donde se escriben en la memoria RAM los datos, así como su consulta cuando se van transmitiendo.

![image](https://github.com/user-attachments/assets/7da6e027-7507-4c3c-b3c7-8d5b9f118650)

Para el periferico LED, se enciende el posicionado en el tercer espacio, mediante un valor binario de 4, justo despues de recibir la imagen completa. 

![image](https://github.com/user-attachments/assets/a721858b-b0e0-4831-b786-62c9db0f3a29)


- Correspondientemente a la imagen 3, esta se almacena en la posición especificada en el apendice 4. La cual hace referencia a la imagen 3. Entre cada dirección existe un distanciamiento de 0xFD20, lo cual corresponde al tamaño real de una imagen.
- Cada byte de la RAM se va escribiendo gracias al valor de mem_wstrb el cual selecciona el sloth de la palabra en el que se quiere escribir.

![image](https://github.com/user-attachments/assets/38756519-77bc-482a-bde6-377a04edfb94)


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



