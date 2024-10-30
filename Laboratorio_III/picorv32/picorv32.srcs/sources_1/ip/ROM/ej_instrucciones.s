//ESCRITURA EN MEMORIA DE DATOS RAM
//DEBE UTILIZARSE LUI PARA CARGAR VALORES MAS ALTOS QUE 0xFFF. Con lui se agregan
//valores en la parte superior del registro y con addi, en la parte inferior para
//asi preparar el valor dentro del registro para establecer un address grande
//y posteriormente enviarlo mediante sw

//////////////Escritura en RAM////////////////////////////////
//Se escribe a partir de 0x40000. Debe ser de 4 en 4, la RAM lo traduce como de 1 en 1
lui x1, 0x4000  //000400B7
addi x1,x1,4 //00408093

addi x2,x0, 10 //00A00113 
addi x3,x0, 11 //00B00193

sw x2, 0(x1) //0020A023
sw x3, 0(x0) //00302023

memory_initialization_radix=16;
memory_initialization_vector=
000400B7 

00408093

00A00113 

0020A023;

////////////ENVIO DATOS A CONTROL DE INTERFAZ UART///////////////////
lui x1, 0x200  //000020B7 (Guarda en addr un 0x2000)
addi x1,x1,16  //01008093 (Actualiza el valor en x1 a 0x2010)

addi x3,x0, 1 //00100193 (Guarda en x3 un 1 que representa el bit send de la UI de UART)
sw x3, 0(x1)  //0030A023 (Envía la direccion que desgina al control de UART y el valor de control)

memory_initialization_radix=16;
memory_initialization_vector=
000020B7 

01008093

00100193 

0030A023;

