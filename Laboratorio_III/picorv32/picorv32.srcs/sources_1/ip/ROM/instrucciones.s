lui x1, 0x2000                              //0x00  000020B7 (Valor base para Direcciones con 0x2000)
lui x2, 0x40000                             //0x04  000401B7 (Valor base para direcciones de RAM 0x40000)
addi x3, x1, 4                              //0x08  00408193 (Direccion de LED 0x2004)
addi x4, x1, 0x10                           //0x0C  01008213 (Direccion de UART A Ctrl 0x2010)
addi x5, x1, 0x18                           //0x10  01808293 (Direccion de UART A Data 1 0x2018)
addi x6, x1, 0x1C                           //0x14  01C08313 (Direccion de UART A Data 2 0x201C)
addi x7, x1, 0x20                           //0x18  02008393 (Direccion de UART B Ctrl 0X2020)
addi x8, x1, 0x28                           //0x1C  02808413 (Direccion de UART B Data 1 0x2028)
addi x9, x1, 0x2C                           //0x20  02C08493 (Direccion de UART B Data 2 0x202C)
sw x0, 0(x4)                                //0x24  00022023 (Inicializa ctrl=0)
addi x10, x0, 2                             //0x28  00200513 (Valor Representativo de ctrl[1]=1)
addi x12, x0, 4                             //0x2C  00400613 (Referencia para contador de bytes en una word de RAM)
addi x13, x0, 0                             //0x30  00000693 (Contador de bytes en una palabra RAM)
lui x14, 0x4000                             //0x34  00040737 (Tamanio de Imagen 1 en RAM upper)
addi x14, x14, 0x008                        //0x38  00870713 (Tamanio de Imagen 1 en RAM lower)
addi x15, x0, 0                             //0x3C  00000793 (Inicializar Contador de transmisiones totales)
lui x19, 0x40000//BORRAR AL IMPLEMENTAR #´s //0x40  000409B7 (Recorre la RAM en +0x4)
addi x11, x0, 1                             //0x44  00100593
lui x27, 0x0F000                            //0x48  00010DB7
addi x27, x27, 0xD24                        //0x4C  D24D8D93
addi x28, x0, 3                             //0X50  00300E13
addi x29, x0, 5                             //0x54  00500E93
addi x30, x0, 6                             //0x58  00600F13
addi x31, x0, 7                             //0x5C  00700F93
check:lw x16, 0(x4)                         //0x60  00022803 Carga el valor actual de ctrl
        and x17, x16, x10                   //0x64  00A878B3 Aisla el bit ctrl[1]
        bne x17, x0, exit_loop_num_img      //0x68  00089A63 Sale de "check" si ctrl==1
        lw x21, 0(x7)                       //0x6C  0003AA83    Carga ctrl de la tang
        and x17, x21, x10                   //0x70  00AAF8B3    Aisla ctrl[1]
        bne x17, x0, exit_loop_tang         //0x74  04089863    Si no es igual a cero sale de "loop_tang" (0x20 instrucciones adelante *4)
        jalr x0, x0, 0x60                   //0x78  06000067 Salta a "check"
exit_loop_num_img:
lw x20,0(x6)                                //0x7C  00032A03 Carga el numero de imagen


//////////////////////////////////////

lui x19, 0x40000                            //0x80  000409B7 (Recorre la RAM en +0x4)
addi x19, x19, 0                            //0x84  00098993 (Direccion de byte en la RAM)

beq x20, x11, loop                          //0x88  00BA0863 (Salta a "loop" si el numero de imagen es 1)
beq x20, x10, img_2                         //0x8C  00AA0263 (Salta a "img_2" si el numero de imagen es 2)
/*
beq x20, x28, img_3
beq x20, x12, img_4
beq x20, x29, img_5
beq x20, x30, img_6
beq x20, x31, img_7
beq x20, x32, img_8
*/

img_2:
        add x19, x19, x27                   //0x90  01B989B3 Genera la direccion 0x4FD24 (Posicion de la imagen 2 en RAM)
        jalr x0,x0, loop                    //0x94  09800067 Salta a "loop" al tener la direccion RAM de imagen 2
//////////////////////////////////////
/*


img_3:
        add x19, x19, x27
        add x19, x19, x27
        beq x19,x19, loop

img_4:
        add x19, x19, x27
        add x19, x19, x27
        add x19, x19, x27
        beq x19,x19, loop

img_5:
        add x19, x19, x27
        add x19, x19, x27
        add x19, x19, x27
        add x19, x19, x27
        beq x19,x19, loop

img_6:
        add x19, x19, x27
        add x19, x19, x27
        add x19, x19, x27
        add x19, x19, x27
        add x19, x19, x27
        beq x19,x19, loop

img_7:
        add x19, x19, x27
        add x19, x19, x27
        add x19, x19, x27
        add x19, x19, x27
        add x19, x19, x27
        add x19, x19, x27
        beq x19,x19, loop

img_8:
        add x19, x19, x27
        add x19, x19, x27
        add x19, x19, x27
        add x19, x19, x27
        add x19, x19, x27
        add x19, x19, x27
        add x19, x19, x27
        beq x19,x19, loop
*/
loop:   
        lw x16, 0(x4)                       //0x98  00022803 (Carga el valor actual de ctrl)
        and x17, x16, x10                   //0x9C  00A878B3 (Aisla el bit ctrl[1])  
        bne x17, x0, exit_loop              //0xA0  00089463 (Sale de "loop" si ctrl==1)
        jalr x0, x0, 0x98                   //0xA4  09800067 (Salta a "loop")
exit_loop:lw x18, 0(x6)                     //0xA8  00032903 Carga el dato recibido
sb x18, 0(x19)                              //0xAC  01298023 Guarda el dato en la direccion de RAM de en un byte
addi x19, x19, 1                            //0xB0  00198993 Aumenta en 1 la direccion de byte en la RAM
beq x19, x14, imagen_escrita                //0xB4  00E98463 Si todo el tamaño de imagen ya se guardo completo salta a "imagen_enviada"
jalr x0, x0, 0x98                           //0xB8  09800067 Salta a "loop" si la imagen aun no se ha guardado por completo
imagen_escrita:
sw x20, 0(x3)                               //0xBC  0141A023 Guarda el numero de imagen en los leds
jalr x0, x0, 0x60                           //0xC0  06000067 Salta a "check"
exit_loop_tang:lw x16, 0(x9)                //0xC4  0004A803    Carga el numero de la imagen solicitado por tang
addi x22, x0, 1                             //0xC8  00100B13    Valor para transmitir datos ctrl[0]=1=>send      
beq x16, x22, 0x8                           //0xCC  01680463    Si el dato recibido es 1 (numero de imagen) sale de "loop_send_tang"
jalr x0, x0, 0x60                           //0xD0  06000067    Si el dato recibido no esta en la lista de imagenes salta a checkeo de ctrl´s[1]
lui x25, 0x4000                             //0xD4  00040CB7     Inicializa el contador que Recorre la RAM en +0x4
add x23, x8, x0                             //0xD8  00040BB3    No cambia, es la direccion UART B DATA_2
addi x24, x0, 0                             //0xDC  00000C13    Contador hasta 4
/*
Se debe agregar que al recibir el numero especifico
de la imagen se envie esa imagen

*/
loop_send_tang: lb x18, 0(x25)              //0xE0  000C8903    Carga byte de la RAM
                sw x18, 0(x23)              //0xE4  012B8023    Guarda el byte en 0x2028 (UART B DATA_1)
                sw x22, 0(x7)               //0xE8  0163A023    Activa la transmision a la TANG
                sw x0,  0(x7)               //0xEC  00038023    Desactiva el bit de transmision para evitar transmisiones repetidas
                loop_busy_tx:   
                        lw x26, 0(x7)       //0xF0  0003AD03    //Carga ctrl de la tang
                        and x17, x26, x12   //0xF4  00CD78B3    //Aisla ctrl[2]
                        beq x17, x0, 0x8    //0xF8  00088463    //Si ctrl[2]==0 (busy_tx) sale de "loop_busy_tx"
                        jalr x0, x0, 0xF0   //0xFC  0F000067    //Continua corroborando valor de ctrl[2]
                exit_loop_busy_tx:           
                addi x25,x25, 1             //0x100  001C8C93    Contador de bytes transmitidos de la imagen en RAM
                beq x25,x14,img_transmitida //0x104  00EC8463 salto de +x8
                jalr x0, x0, 0xE0           //0x108  0E000067
img_transmitida:



