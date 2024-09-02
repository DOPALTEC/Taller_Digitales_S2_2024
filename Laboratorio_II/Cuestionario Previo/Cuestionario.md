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

## 5. Investigue sobre el fenómeno de rebotes y ruido en pulsadores e interruptores. Defina qué técnicas digitales (circuitos) se utilizan para cancelar este fenómeno. Además, investigue sobre los problemas de metastabilidad cuando se tienen entradas asíncronas en circuitos digitales. Finalmente, presente circuitos que permitan la sincronización de entradas como pulsadores e interruptores.

## 6. Investigue sobre la especificación de la interfaz SPI. Preste atención a los aspectos necesarios para poder diseñar un controlador maestro de SPI, además de los diferentes modos de SPI.

## 7. Investigue sobre la comunicación serie UART. Preste atención a las diferentes características de configuración necesarias para la comunicación serie mediante UART (por ejemplo, baud rate, paridad, etc). Además, investigue cómo puede utilizar puertos seriales en su computadora, considerando el sistema operativo que utilice.

## 8. Investigue el funcionamiento básico del controlador ST7789V de la pantalla LCD RGB de la tang nano 9k. La hoja de datos será entregado por el profesor del curso.


# Referencias

[1] S. L. Harris & D. M. Harris, Digital Design and Computer Architecture. ARM Edition. Morgan Kaufmann. 2016.

[2] J. F. Wakerly, Digital Design: Principles and Practices, (4th Edition). 2005.
