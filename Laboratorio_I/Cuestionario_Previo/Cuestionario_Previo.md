# Taller_Digitales_S2_2024
##  1. Investigue las características de las familias TTL bajo las series 74∗xx en particular las diferencias entre las variantes ∗ ∈ {L, LS y HC}.

### Serie 74L (Low Power)

- Consumo de energía bajo
- Menor velocidad de operación en comparación con las otras variantes
- Usadas en aplicaciones donde el ahorro de energía es más importante que la velocidad
- Voltaje de Operación: 4.75V a 5.25V
- Tiempo de Propagación: 33 ns (para puertas lógicas simples)
- Consumo de Energía Aproximado: 1 mW por puerta 

### Serie 74LS (Low Power Schottky)
- Consumo de energía moderado.
- Velocidad de operación mayor al de las series 74L debido a el uso de los diodos Schottky, los cuales por su tecnología reducen los tiempos de conmutación.
- Aplicaciones en sistemas que requieran un consumo de energía y velocidad óptimos
- Voltaje de Operación: 4.75V a 5.25V
- Tiempo de Propagación: 9 ns (para puertas lógicas simples)
- Consumo de Energía Aproximado: 2 mW por puerta 

### Serie 74HC (High-Speed CMOS)

- Bajo consumo de energía, debido al uso de CMOS. Su consumo es comparable a los TTL tradicionales CMOS.
- Velocidad de operación de alta velocidad. Igual o superior a la serie 74LS
- Se utilizan en aplicaciones de alta velocidad y bajo consumo de energía, además de en usos en los cuales se requiera compatibilidad con sistemas CMOS.
- Voltaje de Operación: 2V a 6V
- Tiempo de Propagación: 8 ns (para puertas lógicas simples)
- Consumo de Energía Aproximado: 0.1 mW por puerta 

## 2. Investigue las características de la familia CMOS 4000

Estos circuitos integrados emplean la tecnología lógica de óxido metálico-semiconductor (CMOS) y es conocida por:

- Bajo Consumo de Energía: Consumen poca energía estática lo que los hace atractivos para su uso en aplicaciones alimentadas por batería. 

- Alta inmunidad al ruido lo cual permite que se desempeñen en entornos con alta interferencia y ruido, por ejemplo aplicaciones militares, industriales, circuitos de temporización, secuenciación, controladores de pantalla, sistemas de comunicación así como la rama de las telecomunicaciones.

- Su rango de voltajes es bastante amplio (3V-15V)

- Bajo Consumo de Corriente en estado estático. La corriente de fuga es baja lo que reduce el cunsumo total del sistema del que forma parte el circuito integrado.

- Es compatible con las tecnologías TTL.

- Su tiempo de propagación es más lento que el de las tecnologías TTL y HC


## 3. Investigue qué cuidados deben tenerse al manipular las tecnologías CMOS.

- Al tratar con estos dispositivos se debe evitar el contacto directo con sus terminales. Se recomienda manipularlos por los extremos, usar pinzas o guantes aislantes que eviten daños por descargas electrostáticas. Se recomienda unsar también pulseras antiestáticas y trabajar en areas de trabajo como las ESD-safe.
-Es recomendable tocar una superficie metálica conectada a tierra antes de manipular los componentes.
- Se debe evitar tocar los pines de los dispositivos ya que la humedad y los aceites de la piel causan corrosión y afectan la conectivadad eléctrica
- Almacenar los dispositivos en bolsas antiestáticas cuando no están en uso.
- Mantener los componentes en ambientes secos para prevenir la formación de humedad y utilizar bolsitas con silica gel para prevenir esto.
- Una desventaja es que son susceptibles al fenómeno de latch-up. Esto sucede cuando la salida excede la alimentación por la inducción de la red, lo cual activa un tiristor parásito en CMOS que puede dañar el circuito integrado.
- La tecnología CMOS es sensible a las cargas atrapadas en el óxido, lo cual puede alterar el circuito por partículas alfa o beta, que modifican la tensión umbral de los transistores que componen el chip.

## 4. Investigue el significado de los parámetros V<sub>IL</sub>, V<sub>IH</sub>, V<sub>OL</sub>, V<sub>OH</sub>, V<sub>IK</sub>, V<sub>OK</sub>.

Estos son llamados parámetros de voltaje, y especifican los niveles de entrada y salida para estas tecnologías CMOS y TTL. Definen el comportamiento y compatibilidad de los circuitos lógcios. 

### V<sub>IL</sub> (Voltage Input Low):

- Es el voltaje máximo que una entrada de un dispositivo reconoce como un nivel lógico bajo. En otras palabras es un cero lógico.

### V<sub>IH</sub> (Voltage Input High):
- Voltaje mínimo que una entrada de un dipositivo reconoce como un nivel lógico alto. Se toma como un 1 lógico.

### V<sub>OL</sub> (Voltage Output Low): 
- Voltaje máximo de salida que un dispositivo proporciona cuando se está en un estado lógico bajo. Un cero lógico.

### V<sub>OH</sub> (Voltage Output High):
- Cuando el circuito integrado está en un estado lógico alto existe un voltaje mínimo de salida que tiene el dispositivo, el cual se toma como un 1 lógico.

### V<sub>IK</sub> (Input Clamp Voltage):

- Se trata del voltaje en el que el chip comienza a conducir corriente en sentido de la entrada para así proterse de las altas tensiones.


### V<sub>OK</sub> (Output Clamp Voltage):
- Cumple la misma función del V<sub>IK</sub> pero en este caso la corriente conduce en el sentido desde la salida para así protegerse de voltajes altos.


## 5. Investigue qué son los tiempos de propagación t<sub>PD</sub>, t<sub>PLH</sub>, t<sub>PHL</sub> y los tiempos de transición t<sub>t</sub>, t<sub>tr</sub> y t<sub>f</sub>.

Estos tiempos se subdividen en dos principales:

## Tiempos de Propagación:

### t<sub>PD</sub> (Propagation Delay Time):

- Tiempo que tarda una señal en pasar de la entrada hasta la salida de un circuito. En otras palabras es el tiempo que tarda la señal en cambiar de un estado lógico midiendo desde la entrada hasta otro estado lógico en la salida.

### t<sub>PLH</sub> (Propagation Delay Time, Low-to-High):

- Tiempo en el que tarda la salida en cambiar de un valor lógico en bajo a uno en alto, a partir del momento en el que la entrada ha cambiado.

### t<sub>PHL</sub> (Propagation Delay Time, High-to-Low):

- Tiempo que tarda la salida de un circuito en cambiar de un nivel alto a uno bajo despues de detectar un cambio en la entrada.

## Tiempos de Transición: 

- t<sub>t</sub> (Transition Time): Es el tiempo en el que una señal pasa de un estado lógico a otro, ya sea alto o bajo.

- t<sub>r</sub> (Rise Time): Es la denotación apra el tiempo en el que dura una señal digital en pasar de un nivel bajo, el cuál se toma por el 10% del nivel máximo a un nivel alto, el cual se toma a partir de un 90% del nivel máximo.
- t<sub>f</sub> (Fall Time):
- Es el inverso del tiempo de transición t<sub>r</sub>, es el tiempo medido a partir del cambio de un nivel alto el cual se toma a partir del 90% del nivel máximo del pulso, hasta el tiempo en el que el puslo alcanza el 10% de este nivel máximo.

## 6. Investigue qué significa el término fan-out y cuáles valores típicos se encuentran en las familias TTL y CMOS.

Este término se refiere a la capacidad de un sistema digital para manejar multiples cargas de entrada a la vez que su rendimeinto no se degrada de una forma significativa. Es la cantidad máxima de las entradas del dispositivo que puede soportar y controlar de manera que el dispositivo no pierda sus propiedades iniciales o esté dentro de un rango aceptable de las mismas.

- Para las familias TTL el fan-out general es de 10 a 15 compuertas lógicas que pueden ser soportadas. Para las serie 74LS por ejemplo tiene un fan-out de alrededor de 10 mientras que para la 74S, se puede llagar hasta 20.
- En el caso de las familias CMOS, su valor es mucho mayor, en promedio alrededor de unas 50 a 100 compuertas lógicas. Esto debido a que estos dispositivos tienen baja carga de entrada.

## 7. Para cada una de las variantes TTL y CMOS especifique en una tabla:

### a) rango de tensión eléctrica de alimentación V<sub>CC</sub> o V<sub>DD</sub> y V<sub>SS</sub>

### b) rango de tensiones de entrada y salida

### c) tiempos de propagación y transición

[![Captura-de-pantalla-2024-07-28-182350.png](https://i.postimg.cc/SKcxs7p0/Captura-de-pantalla-2024-07-28-182350.png)](https://postimg.cc/p9XHcjTk)

## 8. Revise la hoja de datos de los circuitos integrados 74∗00,74∗02,74∗04,74∗14, 4001, 4011, 4069 y 40106. Resuma para qué sirve cada uno.

- 74*00: Cuenta con cuatro compuertas NAND de dos entradas.
- 74*02: Cuenta con cuatro compuertas NOR de dos entradas. 
- 74*04: Cuenta con seis inversores independientes. 
- 74*14: Cuenta con seis inversores con disparador Schmitt.
- 4001: Cuenta con cuatro compuertas NOR.
- 4011: Cuenta con cuatro compuertas NAND.
- 4069: Cuenta con seis inversores. 
- 40106: Cuenta con seis inversores con disparador Schmitt.

## 9. Revise la estructura básica, a nivel de transistores, de una compuerta NAND en circuitos integrados CMOS.

Esta compuerta se compone de transistores MOSFET. Se conectan dos transistores tipo PMOS en paralelo entre la fuente de alimentación (V_DD) y la salida, y dos transistores tipo NMOS en serie con tierra. Cada entrada de la compuerta se conecta en las compuertas de cada NMOS. Cuando alguna de las entradas es 0, al menos uno de los transistores PMOS conduce V_DD, por lo que la salida está en estado alto. Si ambas entradas son 1, los NMOS se activan, conectando la salida a tierra y generando que esta se encuentre en estado bajo [9].

## 10. Investigue sobre el concepto y el uso de los de circuitos pull-up y pull-down en electrónica digital.

Las resistencias pull-up y pull-down se utilizan para que el circuito tome un valor específico (alto o bajo). La resistencia pull-up se conecta entre la fuente de alimentación y la señal de entrada. Cuando esta señal no está conducida por otro dispositivo la resistencia se encarga de mantener la salida en alto. Por otro lado, la resistencia de pull-down se conecta directamente a tierra para mantener la salida en bajo mientras la señal no esté conducida por otro dispositivo. [10].

## 11. Investigue qué es un circuito disparador Schmitt (Schmitt trigger). Revise las características técnicas del circuito 74∗14.

El circuito disparador Schmitt se encarga de convertir una señal de entrada analógica en una señal de salida digital con histéresis, por lo que la señal cambia de estado alto a bajo cuando cruza el voltaje de umbral superior, y de bajo a alto cuando cruza el voltaje de umbral inferior (la diferencia entre ambos umbrales es conocida como histéresis). La histéresis evita que el circuito responda al ruido, haciéndolo más estable [11].

### Características Técnicas del 7414

- Cuenta con seis inversores con disparador Schmitt.
- Tecnología CMOS.
- Voltaje de Operación: 4.75 V a 5.25 V.
- Consumo de corriente bajo.

## 12. Investigue en que consiste la modulación de ancho de pulso (PWM).

La modulación de ancho de pulso (PWM) se utiliza para controlar la cantidad de potencia que se transmite a una carga. Para lograrlo, se regula el ancho de los pulsos de la señal, por lo que entre más ancho sea el pulso, mayor potencia tendrá la carga. Al aumentar el ancho de los pulsos se incrementa el ciclo de trabajo, el cual representa el porcentaje de un periodo en el que la señal está en alto [12].

## 13. Investigue qué es el efecto de rebote y típicos circuitos anti-rebote (debouncing circuits).

El efecto de rebote se define como el cambio no deseado de un valor lógico causado por variaciones en la señal. Normalmente se relaciona con pulsadores o algún otro tipo de interruptor, ya que cuando este se presiona, se pueden generar múltiples pulsos antes de que el circuito se estabilice [13].

### Circuitos Anti-rebote

- Filtro RC: Se utiliza una resistencia y un capacitor para cargar y descargar lentamente las respuestas a la señal de entrada para estabilizar la salida del circuito.
- Flip-Flop SR: Se conecta la salida del interruptor a las entradas del flip-flop para que solo se registre un estado cuando la salida se ha estabilizado.
- Circuito Disparador Schmitt: El circuito cambia de estado hasta que sobrepase alguno de los umbrales, evitando las oscilaciones no deseadas y generando una salida más estable.


## 14. Explique qué es el modelado de comportamiento y de estructura en diseño digital. Brinde un ejemplo de cada uno.

- Modelado de Comportamiento: Define la función básica del sistema y describe su comportamiento en términos de entradas y salidas [11]. 
- Ejemplo: Modelar un contador binario de 4 bits, en el que se especifica que este aumenta su valor cada vez que recibe una señal de reloj y que al llegar al valor más alto (1111) se reinicia a 0000, sin entrar en detalle de cómo se compone físicamente.
- Modelado de Estructura: Describe como se construye el sistema y qué componentes utiliza, así como sus interconexiones [11].
- Ejemplo: Un MUX 2 a 1 compuesto por compuertas AND, NOT y OR.


## 15. Explique el proceso de síntesis lógica en el diseño de circuitos digitales, tanto para el desarrollo de un ASIC como para una FPGA.

El proceso de síntesis lógica en el diseño de circuitos digitales se encarga de convertir una descripción de un diseño de alto nivel (escrita en HDL como Verilog o SystemVerilog) en una de bajo nivel para aplicarlo en hardware [14].

## 16. Investigue sobre la tecnología de FPGAs. Describa el funcionamiento de la lógica programable en general, así como los componentes básicos de una.

Una FPGA es un dispositivo de lógica programable, lo cual permite configurar circuitos de acuerdo con las especificaciones requeridas. Se configura inicialmente con un archivo que define el comportamiento del circuito, generado a partir de un HDL. Se configuran las conexiones para que los bloques lógicos programables se comuniquen entre sí, para luego programar las diferentes entradas y salidas y así cumplir con el comportamiento esperado. Se compone principalmente de look-up tables, bloques lógicos programables, flip flops, bloques de memoria, entradas y salidas. [15]. 

## 17. Investigue sobre los proyectos de YOSYS y nextpnr ¿Cuáles son sus funciones como herramientas?

- YOSYS: Herramienta de síntesis que transforma un diseño descrito en HDL en una netlist (representación de los componentes lógicos interconectados), utilizada principalmente en el ámbito de diseño de circuitos digitales. Puede ser utilizado para extraer FMS y realizar operaciones en ellas [16].
- Nextpnr: Herramienta de Place and Route, la cual se encarga de tomar la netlist generada por YOSYS y ubicar físicamente los componentes de la FPGA y sus interconexiones. Además, produce un archivo de configuración que se carga en la FPGA para implementar el diseño [17].


# Referencias

[1] La Familia Lógica «74»”, Unican.es. Recuperado de https://personales.unican.es/manzanom/Planantiguo/EDigitalI/Familia74.pdf

[2] Millman, J., & Grabel, A. (1987). Microelectronics. McGraw-Hill.

[3] Horowitz, P., & Hill, W. (1989). The Art of Electronics (2nd ed.). Cambridge University Press.

[4] Texas Instruments. (n.d.). SN54LS00 [Hoja de Datos]. Recuperado de https://www.ti.com/lit/ds/symlink/sn54ls00.pdf

[6] ON Semiconductor. (n.d.). 4000 Series CMOS [Hoja de Datos]. Recuperado de https://www.onsemi.com/pdf/datasheet/mc14001b-d.pdf

[7] Techopedia. (n.d.) Clamping Voltage. https://www.techopedia.com/definition/1735/clamping-voltage#:~:text=Clamping%20voltage%20refers%20to%20the,is%20protected%20from%20electrical%20surges.

[8] Harris, D. M., & Harris, S. L. (2015). Digital Design and Computer Architecture: ARM Edition. Morgan Kaufmann.

[9] González, J.L., Castaño, A., & Morales, F. (2018). Compuerta NAND CMOS para Módulo de Electrónica. Universidad Autónoma del Estado de Hidalgo. https://doi.org/10.29057/icbi.v6i11.3032

[10] González, J. L. M. (2006). Electrónica digital. Delta Publicaciones.

[11] Wakerly, J. F. (2001). Diseño digital. Pearson educación.

[12] Bolton, W. (2018). Mecatrónica: Sistemas de Control Electrónico en la Ingeniería Mecánica y Eléctrica (5ta ed.). Alfaomega. 

[13] Maloney, T. J. (2006). Electrónica industrial moderna. Pearson Educación.

[14] Harris, S.L., & Harris, D. M. (2016). Digital Design and Computer Architecture. Morgan Kaufmann.

[15] Iida, M. (2018). Principles and Structures of FPGAs. Springer.

[16] Haase, J. (2012). Models, Methods, and Tools for Complex Chip Design. Springer.

[17] Jantsch, A. (2023). Taking AIMS at Digital Design. Springer.

