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


/////////////////////////////////RECEPCION DE DATOS DE INTERFAZ UART////////////////////////////////////////////7

//loop que revisa el valor de ctrl[1]
lui x10, 0x4000  //00040537 //Pasar lui al inicio o se perderá el valor de x10, mover los jumps en base a esto
inicio: //label de inicio
lui x1, 0x200  //000020B7 (Guarda en addr un 0x2000)


addi x1,x1,16  //01008093 (Actualiza el valor en x1 a 0x2010)
sw x0, 0(x1) //0000A023  
addi x2, x0, 2 //00200113 (Guarda en x2 un 2 que representa el bit de recepción de la UI de UART)
addi x3, x0, 0x18 //01800193 (Guarda en x3 un 8 que representa el bit de recepción de datos de la UI de UART)
//inicializar ctrl en 0

addi x0, x0, 0 //00000013 (Guarda en x0 un 0)

loop: //label de bucle que revisa el valor de ctrl[1] hasta que sea 1
lw x5, 0(x1) //0000A283 (Carga en x5 el dato recibido)
and x6, x5, x2 //0022F333 (Guarda en x6 el resultado de la operación AND entre x5 y x2)

//bne x6, x0, exit_loop   //00031B63 (Salta a "exit_loop" si x6 es distinto de 0) el offset es de 1 instrucciones
bne x6, x0, ?   //00031463 (Salta a "exit_loop" si x6 es distinto de 0) el offset es de 1 instrucciones

jalr x0, x3, 0  //00018067 (Salta a la dirección de x3) a "loop"

exit_loop: //Label que indica salida del bucle, osea ctrl[1]=1

//Al tener ctrl[1]=1
//lui x1, 0x200  //000020B7 (Guarda en addr un 0x2000)
//addi x1,x1,28  //01C08093 (Actualiza el valor en x1 a 0x201C)
//lw x4, 0(x1) //0000A203 (Carga en x4 el dato recibido)
lui x8, 0x200  //00002437?
addi x8,x8,28  //01C40413?
lw x4, 0(x8) //00042203?

//Escritura en RAM
//lui x1, 0x4000  //000400B7
//sw x4, 0(x1) //0040A023

//lui x10, 0x4000  //00040537 //Pasar lui al inicio o se perderá el valor de x10, mover los jumps en base a esto
sw x4, 0(x10) //00452023
addi x10,x10,4 //00450513

jalr x0, x3, 0  //00018067 (Salta a la dirección de x3) a "loop"

addi x11,x11,1 //00150593? //Contador que llega hasta el tamanio de la imagen
bne x11, x12, exit_loop2 //0005B063? (Salta a "loop" si x11 es distinto de x12) el offset es de 1 instrucciones
//jalr x0, x3, 0  //00018067 (Salta a la dirección de x3) a "loop" regresa a verificar si hay más datos por recibir
//jalr x0, x0, inicio  //00008067
//00018067 (Salta a la dirección de x3) a "loop"
exit_loop2: 



