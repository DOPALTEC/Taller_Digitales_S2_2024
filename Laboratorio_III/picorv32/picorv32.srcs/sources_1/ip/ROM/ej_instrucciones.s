//ESCRITURA EN MEMORIA DE DATOS RAM
//DEBE UTILIZARSE LUI PARA CARGAR VALORES MAS ALTOS QUE 0xFFF. Con lui se agregan
//valores en la parte superior del registro y con addi, en la parte inferior para
//asi preparar el valor dentro del registro para establecer un address grande
//y posteriormente enviarlo mediante sw

////////////////////////////////////////////////LEDS///////////////////////////////////////////////////
lui x1, 0x200  //000020B7 (Guarda en addr un 0x2000)
addi x1,x1,4  //00408093 (Actualiza el valor en x1 a 0x2004)
addi x2,x0, 10 //00A00113
sw x2, 0(x1) //0020A023

////////////////////////////////////////////////SWITCHES///////////////////////////////////////////////////
lui x1, 0x200  //000020B7 (Guarda en addr un 0x2000)
lw x5, 0(x1) //0050A003 (Carga en x5 el dato recibido)


///////////////////////////////7/////////////////Escritura en RAM/////////////////////////////////////////////////////
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

/////////////////////////////////RECEPCION DE DATOS DE INTERFAZ UART////////////////////////////////////////////7

//loop que revisa el valor de ctrl[1]
lui x1, 0x200  //000020B7 (Guarda en addr un 0x2000)
//addi x1,x1,16  //01008093 (Actualiza el valor en x1 a 0x2010)
addi x1,x1,12  //00C08093 (Actualiza el valor en x1 a 0x200C)

//inicializar ctrl en 0
sw x0, 0(x1) //0000A023

loop: //label de bucle que revisa el valor de ctrl[1] hasta que sea 1

lw x5, 0(x1) //0050A003 (Carga en x5 el dato recibido)

//saca del bucle si el segundo bit de x5 es 1
andi x6, x5, 2          //0022F313 Aislar el segundo bit (x5[1] en x6)
bne x6, x0, exit_loop   //00430663  Si x6 (x5[1]) no es cero, salir del bucle

jal x0, loop  //0000006F   Salta de nuevo a "loop" incondicionalmente

exit_loop: //Label que indica salida del bucle, osea ctrl[1]=1

//if (ctrl): Al tener ctrl[1]=1
lui x1, 0x200  //000020B7 (Guarda en addr un 0x2000)
addi x1,x1,28  //01808093 (Actualiza el valor en x1 a 0x2018)
lw x4, 0(x1) //0040A003 (Carga en x4 el dato recibido)



//////////////////////////////////ENVIO DE DATOS PARA TRANSMITIR A INTERFAZ UART//////////////////////////////////
lui x1, 0x200  //000020B7 (Guarda en addr un 0x2000)
addi x1,x1,24  //01808093 (Actualiza el valor en x1 a 0x2018)

addi x3,x0, 170 //0A500193 (Guarda en un registro el dato a enviar AA(10100101))
sw x3, 0(x1) //0030A023  Envia la direccion correspodiente a datos para tx y envia el dato

memory_initialization_radix=16;
memory_initialization_vector=
000020B7
01808093
0A500193
0030A023;

/////////////////////////////////ENVIO SEÑAL A CONTROL DE INTERFAZ UART/////////////////////////////////////////////
//Siempre inicializar el ctrl en 0
lui x1, 0x200  //000020B7 (Guarda en addr un 0x2000)
addi x1,x1,16  //01008093 (Actualiza el valor en x1 a 0x2010)

addi x3,x0, 1 //00100193 (Guarda en x3 un 1 que representa el bit send de la UI de UART)
sw x3, 0(x1)  //0030A023 (Envía la direccion que desgina al control de UART y el valor de control)

sw x0, 0(x1) //0000A023 Desactiva la transmisión de datos
//Corroborar que ya implementado no genera problemas como en ocasiones anteriores
memory_initialization_radix=16;
memory_initialization_vector=
000020B7 

01008093

00100193 

0030A023

0000A023
;



