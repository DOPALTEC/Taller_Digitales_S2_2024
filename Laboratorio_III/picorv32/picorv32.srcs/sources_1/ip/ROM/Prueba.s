lui x1, 0x200                 //0x00  //000020B7 (Guarda en addr un 0x2000)
addi x1,x1,16                 //0x04  //01008093 (Actualiza el valor en x1 a 0x2010 "UART_A ctrl")
sw x0, 0(x1)                  //0x08  //0000A023  (Inicializa ctrl en 0)
lui x10, 0x4000               //0x0C  //00040537  Guarda en x10 un 0x40000 (Ira aumentando de 4 en 4 apuntando a la RAM) 
lui x8, 0x200                 //0x10  //00002437 Guarda en x8 un 0x2000
addi x8,x8,28                 //0x14  //01C40413 Actualiza el valor en x8 a 0x201C "UART_A data_2"
addi x2, x0, 2                //0x18  //00200113 (Guarda en x2 un 2 que representa el bit de recepción de la UI de UART)
addi x3, x0, 0x20             //0x1C  //02000193 Guarda en x3 la dirección de la instrucción "jalr x0, x3, 0" (loop)
loop:   lw x5, 0(x1)          //0x20  //0000A283 (Carga en x5 el dato recibido) Bucla que revisa el valor de ctrl[1] hasta que sea 1 loop=0x20
        and x6, x5, x2        //0x24  //0022F333 (Guarda en x6 el resultado de la operación AND entre x5 y x2)
        bne x6, x0, exit_loop //0x28  //00031463 (Salta a "exit_loop" si x6 es distinto de 0) el offset es de 2 instrucciones
        jalr x0, x3, loop     //0x2C  //00018067 (Salta a la dirección de x3) a "loop"
exit_loop: lw x4, 0(x8)       //0x30  //00042203 //Carga en x4 el dato recibido por la UART //exit_loop=0x30
sw x4, 0(x10)                 //0x34  //00452023
addi x10,x10,4                //0x38  //00450513


bne xx,xx,img_recibida //se deben hacer 64800 transmisiones (0xFD20 transmisiones), imagen completa, si no se hace el bucle de espera de datos continua
jalr x0, x3, loop             //0x40  //00018067 (Salta a la dirección de x3) a "loop"
img_recibida: //Aniadir instrucciones para encender el primer led


lui x7, 0x200                 //0x44  //? Guarda en x7 un 0x2000
addi x7,x7, 44                //0x48  //02C? Actualiza el valor en x7 a 0x2004
addi x11,x11,1                //0x4C  //Almacena en x11 un 1, para comparar  con numero de imagen que se solicita
loop_TANG_NANO: lw x9, 0(x7)  //0x50  //Carga en x9 el dato recibido por la Tang Nano
                beq x11,x9,exit_loop_TANG_NANO //0x54  //Compara x11 con x9, si son iguales salta a exit_loop_TANG_NANO
exit_loop_TANG_NANO:
/*Iniciar transmision de la RAM*/





                
