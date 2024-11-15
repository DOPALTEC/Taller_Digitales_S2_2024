lui x1, 0x200                               //0x00  000020B7 (Valor base para Direcciones con 0x2000)
lui x2, 0x4000                              //0x04  000401B7 (Valor base para direcciones de RAM 0x40000)
addi x3, x1, 4                              //0x08  00408193 (Direccion de LED 0x2004)
addi x4, x1, 0x10                           //0x0C  01008213 (Direccion de UART A Ctrl 0x2010)
addi x5, x1, 0x18                           //0x10  01808293 (Direccion de UART A Data 1 0x2018)
addi x6, x1, 0x1C                           //0x14  01C08313 (Direccion de UART A Data 2 0x201C)
addi x7, x1, 0x20                           //0x18  02008393 (Direccion de UART B Ctrl 0X2020)
addi x8, x1, 0x28                           //0x1C  02808413 (Direccion de UART B Data 1 0x2028)
addi x9, x1, 0x2C                           //0x20  02C08493 (Direccion de UART B Data 2 0x202C)
sw x0, 0(x4)                                //0x24  00022023 (Inicializa ctrl=0)
addi x10, x0, 2                             //0x28  00200513 (Valor Representativo de ctrl[1]=1)
addi x11, x0, loop  //(SIN USO)             //0x2C  04800593 (Direccion de instruccion de etiqueta loop)
addi x12, x0, 4                             //0x30  00400613 (Referencia para contador de bytes en una word de RAM)
addi x13, x0, 0                             //0x34  00000693 (Contador de bytes en una palabra RAM)
lui x14, 0x4000                             //0x38  00040737 (Tamanio de Imagen 1 en RAM upper)
addi x14, x0, 0x007                         //0x3C  00700713 (Tamanio de Imagen 1 en RAM lower)
addi x15, x0, 0                             //0x40  00000793 (Inicializar Contador de transmisiones totales)
lui x19, 0x4000                             //0x44  000409B7 (Recorre la RAM en +0x4)
loop:   lw x16, 0(x4)                       //0x48  00022803 (Carga el valor actual de ctrl)
        and x17, x16, x10                   //0x4C  00A878B3 (Aisla el bit ctrl[1])  
        bne x17, x0, exit_loop              //0x50  00089463 (Sale de "loop" si ctrl==1)
        jalr x0, x0, 0x48                   //0X54  04800067 (Salta a "loop")
exit_loop:lw x18, 0(x6)                     //0x58  00032903
sb x18, 0(x19)                              //0x5C  01298023
addi x19, x19, 1                            //0x60  00198993
beq x19, x14, imagen_enviada                //0x64  00E98463
jalr x0, x0, 0x48                           //0x68  04800067

/*Enviar al final de la transmision el numero de imagen que es
para escribir ese numero en los leds
*/

                        
imagen_enviada:addi x20,x0,1                //0x6C
x20, sw ,0(x3)                              //0x70

loop_tang:      lw x21, 0(x7)               //0x74