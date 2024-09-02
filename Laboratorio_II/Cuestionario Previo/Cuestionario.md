# Cuestionario Previo Laboratorio II

##  1. Investigue sobre el funcionamiento de máquinas de estado finitos. Explique la diferencia entre una máquina de Moore y una de Mealy, y muestre la diferencia por medio de diagramas de estados y señales.

Las máquinas de estados finitos (FSM) cuentan con un circuito con k registros que puede estar en uno de un número finito (2^k) de estados únicos. Tiene M entradas, N salidas y k bits de estado. Además, cuenta con un bloque de lógica de siguiente estado, un bloque de lógica de salida y un registro que almacena el estado. En cada borde del reloj, la FSM avanza al siguiente estado, calculado en función del estado actual y las entradas [1]. 
En las máquinas de Moore, las salidas dependen únicamente del estado actual de la máquina. En las máquinas de Mealy, las salidas dependen tanto del estado actual como de las entradas actuales, tal como se muestra en los siguientes diagramas [1].

[![Captura-de-pantalla-2024-09-01-085032.png](https://i.postimg.cc/5tRybY1T/Captura-de-pantalla-2024-09-01-085032.png)](https://postimg.cc/p9KRBdmJ)

## 2. Explique los conceptos de setup time y hold time. ¿Qué importancia tienen en el diseño de sistemas digitales?

### Setup Time

Se define como el periodo de tiempo mínimo que la señal de entrada debe permanecer estable antes del flanco del reloj para que el registro pueda garantizar su correcta captura. Al diseñar sistemas digitales es importante establecer este tiempo, ya que, si la señal de entrada no se mantiene estable y varía muy cerca del flanco del reloj, puede causar metaestabilidad en el registro, ocasionando un funcionamiento erróneo del sistema [2].

### Hold Time

Periodo de tiempo que la señal de entrada debe permanecer estable después del flanco para que los datos entrantes no interfieran con los datos almacenados en el registro. Al diseñar sistemas digitales es importante que este tiempo se cumpla, ya que, si la señal varía muy rápido después del flanco del reloj, se pueden afectar los datos del registro, llevando a un mal funcionamiento del sistema [2].

## 3. Explique los conceptos de tiempos de propagación y tiempos de contaminación en circuitos combinacionales. Investigue sobre la ruta crítica y cómo esta afecta en el diseño de sistemas digitales complejos; por ejemplo, un procesador con pipeline. Investigue su relación con la frecuencia máxima de operación de un circuito.

### Tiempo de Propagación

Tiempo desde que la señal de entrada recorre un dato hasta que la salida responde a dicha entrada. Este tiempo limita la frecuencia máxima a la que se puede trabajar, por lo que se considera un retardo [1].

### Tiempo de Contaminación

Tiempo mínimo que debe pasar después de que una entrada cambie de estado e influya en la operación del circuito, esto para que las señales se mantengan estables y no se afecte el funcionamiento del circuito. Con este tiempo, se garantiza la confiabilidad en la propagación e interpretación de los datos [1].

### Ruta Crítica

Ruta de datos más lenta, es decir que tarda más tiempo en realizarse. Es utilizada para determinar la velocidad máxima de operación del sistema y para realizar mejoras. Para determinarla, se toman los tiempos de retardo de cada componente del sistema y se suman para analizar cual ruta tarda más en completarse [1].
Los sistemas pipeline se utilizan para maximizar la lectura de instrucciones. Estos sistemas recorren todas las etapas: decodificación, ejecución, escritura, lectura. Si alguna de estas etapas tarda más de lo esperado puede generar un retraso en la ejecución de las demás instrucciones. Debido a esto, la frecuencia máxima está ligada a la instrucción que requiera más etapas y más tiempo [1]. 


## 4. Investigue sobre las mejores prácticas para la asignación de relojes y división de frecuencia en FPGAs. En este apartado haga énfasis en el uso de las entradas habilitadoras de reloj (clock enables) presentes en las celdas de la FPGA, para lograr tener tiempos de ejecución diferentes a lo largo del sistema mientras se utiliza un solo reloj.


Los habilitadores de reloj son recomendados, ya que pueden ayudar a optimizar el uso de recursos de reloj en la FPGA y mejorar tanto las características de temporización como el análisis de temporización del diseño. El cruce de dominios de reloj es un problema común en el diseño de lógica digital. Cuando las señales atraviesan diferentes dominios de reloj, es posible que ocurran metástasis y pérdida de datos debido a violaciones en los tiempos de configuración y mantenimiento. La solución más común a este problema es el uso de sincronizadores compuestos por varios Flip-Flops, los cuales sincronizan las señales que provienen de otro dominio de reloj. Para evitar problemas de temporización o cruces de dominios de reloj en la FPGA, se recomienda generar una señal de habilitación de reloj lenta en lugar de crear un nuevo reloj (utilizando divisores de reloj o habilitadores de reloj) para controlar otra parte lógica del diseño [3]. 

Primero, es necesario establecer una fase de control basada en Phase Locked Loop (PLL) o Delay Locked Loop, lo cual permitirá un mayor control interno y la implementación de múltiples relojes en caso de ser necesario. Finalmente, el conteo de n bits se realiza mediante el conteo de ciclos del reloj, donde un flip-flop tipo D almacena el estado final y gestiona el cambio del estado de salida (divisor de reloj). Esto permite que todo el sistema funcione dentro de un solo dominio de reloj, pero con habilitadores de reloj que simulan trabajar con diferentes frecuencias [3]. 




## 5. Investigue sobre el fenómeno de rebotes y ruido en pulsadores e interruptores. Defina qué técnicas digitales (circuitos) se utilizan para cancelar este fenómeno. Además, investigue sobre los problemas de metastabilidad cuando se tienen entradas asíncronas en circuitos digitales. Finalmente, presente circuitos que permitan la sincronización de entradas como pulsadores e interruptores.

 
La metaestabilidad es un fenómeno que ocurre cuando se violan los tiempos de configuración (set up) y de umbral (treshold), lo que provoca que un flip-flop pueda combinar estados de manera impredecible, haciendo imposible predecir su próximo estado. Para evitar la metaestabilidad, se pueden usar dos flip-flops en serie. El primer flip-flop recibe la señal de forma asíncrona y puede entrar en un estado de metaestabilidad. El segundo flip-flop, al recibir la señal del primero, la sincroniza, aunque esto conlleva un aumento en la latencia del sistema [2]. 

 


## 6. Investigue sobre la especificación de la interfaz SPI. Preste atención a los aspectos necesarios para poder diseñar un controlador maestro de SPI, además de los diferentes modos de SPI.

Es un protocolo de comunicación serial síncrono, osea, que siempre existe una coordinación temporal entre el transmisor y el receptor. Es usada comúnmente para la comunicación de alta velocidad entre microcontroladores y periféricos como sensores pantallas y memorias. Es un protocolo de cuatro líneas que opera en modo maestro-esclavo, donde el dispositivo maestro controla el reloj y la sincronización de datos. 

Para diseñar el controlador master hay varios aspectos a tomar en cuenta:

- MOSI (Master Out Slave In): Es la línea de datos o paquete de datos donde el maestro envía hacia el esclavo.

- MISO (Master In Slave Out): Es la línea de datos donde el esclavo envía datos al maestro.

- SCLK (Serial Clock): Línea de reloj generada por el maestro que sincreoniza la transferencia de datos. Genera la señal de reloj para tener esa referencia de "sincronía".

- SS/CS (Slave Select/Chip Select): Esta línea es utilizada para seleccionar el esclavo a activar. Está controlada por el maestro y es en general, activa en bajo.

Este protocolo, posee varios modos que se determinan por dos parámetros que controlan la sincronización del reloj con los datos de diferentes formas.

- Modo 0 (CPOL = 0, CPHA = 0): El reloj es bajo cuando está inactivo. La muestra de datos se realiza en el flanco de subida.
- Modo 1 (CPOL = 0, CPHA = 1): El reloj es bajo cuando está inactivo. La muestra de datos se realiza en el flanco de bajada.
- Modo 2 (CPOL = 1, CPHA = 0): El reloj es alto cuando está inactivo. La muestra de datos se realiza en el flanco de bajada.
- Modo 3 (CPOL = 1, CPHA = 1): El reloj es alto cuando está inactivo. La muestra de datos se realiza en el flanco de subida.

La longitud de la palabra de los datos transferidos suele ser de 8 bits y además, la configuración, permite que el orden de los bits sea el más significativo primero o el menos significativo.



## 7. Investigue sobre la comunicación serie UART. Preste atención a las diferentes características de configuración necesarias para la comunicación serie mediante UART (por ejemplo, baud rate, paridad, etc). Además, investigue cómo puede utilizar puertos seriales en su computadora, considerando el sistema operativo que utilice.

Es un protocolo de comunicación serial asíncrona, osea que no utiliza un reloj como referencia para sincronizar. Es utilizado comúnmente para la comunicación entre dispositivos electrónicos, como microcontroladores, ordenadores, sensores y módulos de comunicación. Transmite datos bit a bit a través de dos líneas, una para transmisión (tx) y otra para recepión (rx).

Existen varios conceptos a cosiderar:

- Velocidad en Baudios (Baud Rate): Define la cantidad de bits transmitidos por segundo (bps). Debe considerarse que tanto el transmisor como el receptor tengan configurada la misma velocidad de baud para una comunicación efectiva. Entre las velocidades más generales y comunes están 9600, 19200, 38400, 57600, 115200 bps.
- Formato del Marco de Datos (Data Frame): El bit de inicio (start bit) tiene un valor de 0 que indica el comienzo de la transmisión. El bit de datos generalmente es de 5-9 bits, dependiendo de la configuración del UART pero lo más comíun son 8 bits. Bit de paridad, el cual es opcional, es un bit utilizado para detectar errores el cual viene en configuraciones como par (even), impar (odd) o ninguno. La paridad solo detecta un bit de error. El bit de parada (Stop Bits), tiene un valor de 1, e indica el final de la transmisión. 
- Error de Framing: Ocurre cuando el rx no tedecta el bit de parada al final de un marco de datos.
- Error de Overrun: Cuando el rx no puede procesar los datos recibidos lo suficientemenete rápido y se pierden datos.

Es necesario además, entender como funcionan los modos de comunicación del protocolo.

- Modo de Transmisión: El tx envía datos al rx a través de la linea, cada transmisión se incia con un bit de inicio, luego le siguen los datos y luego el o los bits de parada.
- Modo de Recepción: El rx traduce los bits para detectar el bit de inicio, y al detectarlo, se sincroniza y procede a leer los datos en función de la velocidad de baudios configurada.
- Modo Full-Duplex: Este modo significa que puede transmitir y recibir datos simultáneamente. Las lineas tx y rx operan de forma independiente. Pero implica tener más líneas. 
- Modo Half-Duplex: Es un modo con el fin de reducir el numero de lineas de comunicación, la cual alterna entre la transmisión y recepción en la misma línea.



## 8. Investigue el funcionamiento básico del controlador ST7789V de la pantalla LCD RGB de la tang nano 9k. La hoja de datos será entregado por el profesor del curso.

Es un componente de visualización que se utiliza en la FPGA Tang Nano 9K. Se trata de un controlador de pantalla LCD a color, de 240x240 píxeles diseñado para pantallas TFT (Thin Film Transistor). El cual es una pantalla de matriz activa en la que cada píxel de la pantalla se ilumina individualmente. Esto proporciona una buena calidad de imagen lo cual la hace ideal para visualización de gráficos, texto y otros elementos visuales. Este controlador utiliza la interfaz de comunicación SPI para poder conectarse con la FPGA. El controlador gestiona la interfaz, la memoria de cuadro y las funciones de procesamiento de gráficos de la pantalla. 

La pantalla RGB de 262,000 colores, lo cual son 18 bits por píxel, permite una amplia gama de estos colores en consecuencia, una buena representación visual. Al integrar esta pantalla a la FPGA, permite a los desarrolladores visualizar datos directamente. Además es capaz de operar en diferentes modos de color.
- 12 bits/píxel: Formato RGB 4-4-4
- 16 bits/píxel: Formato RGB 5-6-5
- 18 bits/píxel: Formato RGB 6-6-6

El controlador admite varias interfaces además de la SPI, tales como:
- Interfaz Paralela tipo MCU (8080-series): Admite buses de datos de 8, 9, 16 y 18 bits.

- Interfaz RGB: Permite la transmisión de datos de imagen RGB mediante señales de sincronización como: VSYNC, HSYNC, DOTCLK, ENABLE
- Interfaz VSYNC: Utiliza la sincronización vertical para la actualización de la pantalla





# Referencias

[1] S. L. Harris & D. M. Harris, Digital Design and Computer Architecture. ARM Edition. Morgan Kaufmann. 2016.

[2] J. F. Wakerly, Digital Design: Principles and Practices, (4th Edition). 2005.

[3] "How to generate a clock enable signal on FPGA,” FPGA4student.com. https://www.fpga4student.com/2017/08/how-to-generate-clock-enable-signal.html

[4] Sitronix Technology Corporation, "ST7789V Datasheet," Version 1.0, 2013.
