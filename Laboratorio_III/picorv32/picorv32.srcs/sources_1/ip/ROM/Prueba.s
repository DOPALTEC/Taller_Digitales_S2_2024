lui x1, 0x200        //ya         //0x00  //000020B7 (Guarda en addr un 0x2000)
addi x1,x1,16        //ya         //0x04  //01008093 (Actualiza el valor en x1 a 0x2010 "UART_A ctrl")
sw x0, 0(x1)         //ya         //0x08  //0000A023  (Inicializa ctrl en 0)
lui x10, 0x4000      //ya         //0x0C  //00040537  Guarda en x10 un 0x40000 (Ira aumentando de 4 en 4 apuntando a la RAM) 
lui x8, 0x200        //ya         //0x10  //00002437 Guarda en x8 un 0x2000
addi x8,x8,28        //ya         //0x14  //01C40413 Actualiza el valor en x8 a 0x201C "UART_A data_2"
addi x2, x0, 2       //ya         //0x18  //00200113 (Guarda en x2 un 2 que representa el bit de recepción de la UI de UART)
addi x3, x0, 0x34    //ya         //0x1C  //03400193 Guarda en x3 la dirección de la instrucción "jalr x0, x3, 0" (loop)
lui x12, 0x4000      //ya         //0x20  //00040637??
addi x12, x12, 4     //ya (alterada)         //0x24  //00460613?? //Valor de referencia de posiciones de bytes en una palabra
addi x13, x10, 0     //ya (alterada)         //0x28  //00050693 //Contador de Posicion de RAM a partir de 0x40000
//lui x14, 0x4300               //0x2C  //00044737 //Carga los bits superiores de la direccion RAM final de imagen 1
//addi x14,x14, 0xf67           //0x30  //f6770713 //Direccion de memoria RAM final de imagen 1 de referencia
lui x14, 0x4000      //ya         //0x2C  //00040737 //Carga los bits superiores de la direccion RAM final de imagen 1
addi x14,x14, 0x007  //ya        //0x30  //00770713 //Direccion de memoria RAM final de imagen 1 de referencia
/*Añadir aqui el resto de direcciones de memoria que acotan las otras imagenes*/
////Verifica el valor de ctrl[1] hasta que este activo
loop:   lw x5, 0(x1)          //0x34  //0000A283 (Carga en x5 el dato recibido) Bucla que revisa el valor de ctrl[1] hasta que sea 1 loop=0x20
        and x6, x5, x2        //0x38  //0022F333 (Guarda en x6 el resultado de la operación AND entre x5 y x2)
        bne x6, x0, exit_loop //0x3C  //00031463 (Salta a "exit_loop" si x6 es distinto de 0) el offset es de 2 instrucciones
        jalr x0, x3, loop     //0x40  //00018067 (Salta a la dirección de x3) a "loop"
exit_loop: lw x4, 0(x8)       //0x44  //00042203 //Carga en x4 el dato recibido por la UART //exit_loop=0x30
//Escritura de byte en byte en una palabra de RAM
sb x4, 0(x10)                   //0x48  //00450023??  //Escribe por byte en la RAM para ahorrar espacio
addi x13, x13, 1                //0x4C  //00168693 //Aumenta el valor de la posicion de byte en una palabra
beq x13, x12, restart_addr      //0x50  //00C68463 //Si el valor es igual a la cantidad de bytes en una palabra salta a restart
jalr x0, x3, loop               //0x54  //00018067 (Salta a la dirección de x3) a "loop"
restart_addr:   addi x10,x10,4                  //0x58  //00450513 //Aumenta una direccion de palabra en RAM
                lui x13, 0x0                    //0x5C  //000006B7       //Reinicia el contador


                beq x14,x10,img_recibida        //0x60  //00A70463?? //Por ahora usar espacio de memoria RAM de 2 palabras x14=0x40008


                jalr x0, x3, loop               //0x40  //00018067 (Salta a la dirección de x3) a "loop"
img_recibida: //Aniadir instrucciones para encender el primer led


lui x7, 0x200                 //0x44  //? Guarda en x7 un 0x2000
addi x7,x7, 44                //0x48  //02C? Actualiza el valor en x7 a 0x2004
addi x11,x11,1                //0x4C  //Almacena en x11 un 1, para comparar  con numero de imagen que se solicita
loop_TANG_NANO: lw x9, 0(x7)  //0x50  //Carga en x9 el dato recibido por la Tang Nano
                beq x11,x9,exit_loop_TANG_NANO //0x54  //Compara x11 con x9, si son iguales salta a exit_loop_TANG_NANO
exit_loop_TANG_NANO:
/*Iniciar transmision de la RAM*/





                
