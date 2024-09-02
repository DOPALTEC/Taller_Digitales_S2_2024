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

## 7. Investigue sobre la comunicación serie UART. Preste atención a las diferentes características de configuración necesarias para la comunicación serie mediante UART (por ejemplo, baud rate, paridad, etc). Además, investigue cómo puede utilizar puertos seriales en su computadora, considerando el sistema operativo que utilice.

## 8. Investigue el funcionamiento básico del controlador ST7789V de la pantalla LCD RGB de la tang nano 9k. La hoja de datos será entregado por el profesor del curso.


# Referencias

[1] S. L. Harris & D. M. Harris, Digital Design and Computer Architecture. ARM Edition. Morgan Kaufmann. 2016.

[2] J. F. Wakerly, Digital Design: Principles and Practices, (4th Edition). 2005.

[3] "How to generate a clock enable signal on FPGA,” FPGA4student.com. https://www.fpga4student.com/2017/08/how-to-generate-clock-enable-signal.html 
