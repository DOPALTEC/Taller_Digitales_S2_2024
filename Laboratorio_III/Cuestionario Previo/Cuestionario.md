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

## 3. Investigue como se elabora un mapa de memoria de un procesador.

## 4. Investigue sobre el uso de memorias RAM y ROM en FPGA. Tanto memorias internas como externas en la FPGA.
