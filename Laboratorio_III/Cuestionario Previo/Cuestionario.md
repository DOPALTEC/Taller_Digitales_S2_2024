
# Cuestionario Previo Laboratorio II

##  1.  Investigue sobre la arquitectura RISC-V. Preste especial atención a las instrucciones que forman parte del conjunto básico de instrucciones para números enteros de 32 bits, RV32I

La arquitectura de una computadora se puede entender como la perspectiva desde la que los programadores interactúan con el sistema. Esta se caracteriza por un conjunto de instrucciones o lenguaje de la máquina, y está formada por elementos como los registros y la memoria. En el caso de la arquitectura RISC-V, las instrucciones están compuestas por palabras de 32 bits, controladas por su conjunto de instrucciones básicas.

RISC-V es una arquitectura de conjunto de instrucciones (ISA) abierta y personalizable que permite diseñar procesadores de manera flexible. Basada en la filosofía de computación con conjunto reducido de instrucciones (RISC), su enfoque se centra en un conjunto de instrucciones sencillo y eficiente, lo que facilita tanto el diseño de hardware como el desarrollo de software. Una de sus principales ventajas es que no está limitada por restricciones de propiedad intelectual, permitiendo a los diseñadores adaptar y ampliar el hardware según sus requerimientos.

Los registros de RISC-V, un total de 32, están asociados a valores enteros. Por ejemplo, x0 siempre contiene el valor 0, x1 el valor 1, y así sucesivamente.

El conjunto básico de instrucciones de RISC-V para enteros de 32 bits, llamado rv32i, incluye diversas operaciones que se dividen en diferentes categorías:

- Aritmética y lógica (Tipo R): Instrucciones como suma (ADD), resta (SUB) y operaciones lógicas (AND, OR, XOR). Un ejemplo sería ADD rd, rs1, rs2, que suma los valores de los registros rs1 y rs2 y almacena el resultado en rd.

- Carga y almacenamiento (Tipo I): Transferencia de datos entre memoria y registros. LW (load word) carga un valor de 32 bits desde la memoria a un registro, mientras que SW (store word) guarda un valor desde un registro en la memoria. Por ejemplo, LW rd, offset(rs1) carga en rd el valor ubicado en la dirección calculada sumando el offset al contenido de rs1.

- Control de flujo (Tipo J): Instrucciones para saltos y ramificaciones, como JAL (jump and link) y BEQ (branch if equal). JAL guarda la dirección de retorno en un registro y salta a otra dirección, mientras que BEQ rs1, rs2, offset realiza un salto si los valores de rs1 y rs2 son iguales.

- Desplazamientos y rotaciones: Estas instrucciones modifican los valores de los registros desplazándolos lógicamente o aritméticamente, como en SLL (shift left logical) y SRL (shift right logical). Por ejemplo, SLL rd, rs1, rs2 desplaza a la izquierda el valor de rs1 según el número de posiciones en rs2 y almacena el resultado en rd.

- Instrucciones del sistema: Manejan excepciones y control del programa, como ECALL (environment call) para solicitar servicios del sistema operativo y EBREAK (breakpoint) para crear puntos de interrupción.



## 2. Investigue que es un toolchain para desarrollo de software empotrado (embedded)

Un toolchain en el enfoque de embebidos, cumple la función de diseñar aplicaciones que se ejecutan en dispositivos que poseen recursos limitados. Por ejemplo, los microcontroladores, sensores o sistemas electrónicos dedicados. Estos sistemas deben ser altamente optimizados debido a sus restricciones en memoria, procesamiento y energía. Como se debe trabajar directamente con el hardware del dispositivo, deben utilizarse herramientas especializadas para compilar el código y permitir la ejecución con arquitecturas específicas. Las partes clave de un toolchain se dividen en:

- Editor de Código (IDE): Facilita la escritura del código, ya que es un editor de entorno de desarrollo integrado especializado para el sistema específico.
  
- Compilador Cruzado (Cross-Compiler): Debido a que el código no se ejecuta en la misma arquitectura en el que se desarrolla, el compilador genera el código binario que se puede ejecutar en el procesador o microcontrolador.

- Enlazador (Linker): Mapea el código generado a áreas de memoria específicas del hardware, tal como la memoria flash o RAM del dispositivo. Asegura que los archivos objeto generados por el compilador estén correctamente organizados y optimizados para el hardware objetivo.

- Depurador para Hardware (Debugger): Se comunica directamente con el hardware a través de alguna interfaz. Pausa la ejecución del código en el dispositvio, inspecciona los estados de los registros del procesador, las variables y las áreas de memoria para así seguir paso a paso la ejecución del programa

- Monitor de Puerto Serie/Consola de Salida: Debido a que muchos sistemas embebidos no tienen una pantalla o sistema de interfaz gráfico, se usa un monitor de puerto serie lo cual permite ver la salida del dispositivo en tiempo real. El dispositivo se conecta a la computadora para mostrar información sobre el funcionamiento del sistema o el estado de las variables en tiempo de ejecución

- Control de Versiones: Fundamnetal para manejar cambios en el código y colaborar en equipos.

- Herramientas de Construcción (Build Tools): Organizan y automatizan el proceso de compilación, enlace y generación del firmware. Configuran el entorno del hardware, incluyendo configuraciones del procesador, memoria y periféricos

- Herramientas de Simulación y Emulación: Permite probar código en un entorno simulado sin necesidad del hardware físico. Depurando el comportamiento de algunos módulos o aplicaciones antes de cargarlos en el dispositivo real.

- Flasher/Programador: Al tener el código listo, debe ser flasheado en la memoria del microcontrolador. Transfiere el archivo binario generado al dispositivo embebido. 
  



## 3. Investigue como se elabora un mapa de memoria de un procesador.

Es una representación gráfica que organiza y asigna de forma estructural la memoria disponible en el sistema, que indica las direcciones de memoria a las que corresponden dispositivos, memorias RAM, ROM ó caché así como regiones de uso. Es recomendable utilizar pasos como los siguientes:

### Identificar el tamaño en memoria: Depende de la cantidad de bits en el bus de direcciones del procesador.

### Categorizar los tipos de la memoria: 

- ROM (Read Only Memory): Almacena rutinas básicas del controlador así como su firmware. Para el caso del proyecto se hace uso de los módulos preestablecidos en el catálogo de IP´s
  
-  RAM (Random Access Memory): Almcena los datos ejecutados en el programa. Para el caso del proyecto se hace uso de los módulos preestablecidos en el catálogo de IP´s

- Periféricos de E/S (Entadas/Salidas): Aqui se le asigna las direcciones en memoria que van a corresponder a dispositivos externos tales como tarjetas de red, puertos u otros dispositivos secundarios.
  
-  Memoria caché (No aplica para el laboratorio): Identifica las memocia chacé que el procesador usa para acelerar el acceso a los datos

-  Zonas Reservadas o Especializadas: Memoria que corresponde a los controladores de dispositivos o buffers.

### Asignar los Rangos de Direcciones: Se deben generar bloques de direcciones a cada sección o rango de memoria dependiendo del diseño del procesador así como su arquitectura. Se deben tomar en cuenta además zonas de memoria protegidas, reservadas u ignoradas para evitar intervenir en sus procesos. 

### Organizar y Representar Gráficamente: La representación gráfica, esquemática o tabular deberá mostrar direcciones iniciales y finales, el rango de tamaño en ya sea bits o hexadecimal de cada una de las regiones de memoria. Por último, el tipo de memoria del que se conforma cada uno de los bloques.


## 4. Investigue sobre el uso de memorias RAM y ROM en FPGA. Tanto memorias internas como externas en la FPGA.

Para el uso de meorias RAM y ROM se hace uso del catálogo de IP´s.

## ROM: La memoria del programa se le asigna un tamaño de 512 palabras (1 palabra son 32 bits), la cual va asignada en el espacio 0x0000 hasta 0x0fff dentro del mapa de memoria. Esto con el motivo de que sea lo primero que el procesador lea. Las instrucciones le darán la orden al procesador de ejecutarse y seguir el protocolo indicado de acuerdo a lo solicitado.

## RAM: En cuanto a la memoria de datos, se solicita que se tenga un tamaño de 100kiB, la cual se ingresa en la región del rango 0x40000 hasta 0x7ffff. En este espacio de memoria es donde se van a almacenar las imagenes enviadas desde la computadora.

Para configurar entonces este RAM en el IP core, se le asigna al ancho de datos un valor de 32 bits, y se sabe que el tamaño total de la memoria es de 100KiB, por tanto se puede calcular la cantidad de profundidad en base a estos números en funcion de una palabra.

Sabemos que:

$$
100KiB=100*1024[bytes]=102400[bytes]
$$

Con lo que es posible calcular el numero de posiciones de memoria, su profundidad. Osea, el número de palabras de 32 bits (4bytes) que se pueden almacenar.

$$
Profundidad(Depth)=\frac{102400[bytes]}{4[\frac{bytes}{palabra}]}
$$

Por tanto,

$$
Profundidad=25600[palabras]
$$

Dando entonces como resultado, la siguiente configuración de la memoria RAM.

![image](https://github.com/user-attachments/assets/01683b6b-3771-4419-99d3-2aa19caee155)




