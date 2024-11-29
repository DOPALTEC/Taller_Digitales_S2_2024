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
addi x15, x0, 0                             //0x34  00000793 (Inicializar Contador de transmisiones totales)
lui x19, 0x40000                            //0x38  000409B7 (Recorre la RAM en +0x4)
addi x11, x0, 1                             //0x3C  00100593
lui x27, 0x0F000                            //0x40  00010DB7
addi x27, x27, 0xD24                        //0x44  D24D8D93
addi x28, x0, 3                             //0X48  00300E13
addi x29, x0, 5                             //0x4C  00500E93
addi x30, x0, 6                             //0x50  00600F13
addi x31, x0, 7                             //0x54  00700F93
addi x23, x0, 8                             //0x58  00800B93

check:  lw x16, 0(x4)                       //0x5C  00022803 Carga el valor actual de ctrl
        and x17, x16, x10                   //0x60  00A878B3 Aisla el bit ctrl[1]
        bne x17, x0, exit_loop_num_img      //0x64  00089A63 Sale de "check" si ctrl==1
        lw x21, 0(x7)                       //0x68  0003AA83 Carga ctrl de la tang
        and x17, x21, x10                   //0x6C  00AAF8B3 Aisla ctrl[1]
        bne x17, x0, exit_loop_tang         //0x70  10089A63 Si no es igual a cero sale de "loop_tang" (0x20 instrucciones adelante *4)
        jalr x0, x0, check                  //0x74  05C00067 Salta a "check"

exit_loop_num_img:
lw x20,0(x6)                                //0x78  00032A03 Carga el numero de imagen
lui x19, 0x40000                            //0x7C  000409B7 (Recorre la RAM en +0x4)
addi x19, x19, 0                            //0x80  00098993 (Direccion de byte en la RAM)
lui x14, 0x40000                            //0x84  00040737 (Tamanio de Imagen 1 en RAM upper)

beq x20, x11, img_1                         //0x88  02BA0063 (Salta a "img_1" si el numero de imagen es 1)
beq x20, x10, img_2                         //0x8C  02AA0263 (Salta a "img_2" si el numero de imagen es 2)
beq x20, x28, img_3                         //0x90  03CA0663 (Salta a "img_3" si el numero de imagen es 3)          
beq x20, x12, img_4                         //0x94  02CA0C63 (Salta a "img_4" si el numero de imagen es 4)
beq x20, x29, img_5                         //0x98  05DA0463 (Salta a "img_5" si el numero de imagen es 5)
beq x20, x30, img_6                         //0x9C  05EA0E63 (Salta a "img_6" si el numero de imagen es 6)
beq x20, x31, img_7                         //0xA0  07FA0A63 (Salta a "img_7" si el numero de imagen es 7)
beq x20, x23, img_8                         //0xA4  097A0863 (Salta a "img_8" si el numero de imagen es 8)

img_1:
        addi x14, x14, 0x008                //0xA8  00870713 (Tamanio de Imagen 1 en RAM lower)
        jalr x0,x0, loop                    //0xAC  15800067 Salta a "loop" al tener la direccion RAM de imagen 2

img_2:
        add x19, x19, x27                   //0xB0  01B989B3 Genera la direccion 0x4FD24 (Posicion de la imagen 2 en RAM)
        addi x14, x19, 0x008                //0xB4  00898713 (Tamanio de Imagen 1 en RAM lower)
        jalr x0,x0, loop                    //0xB8  15800067 Salta a "loop" al tener la direccion RAM de imagen 2

img_3:
        add x19, x19, x27                   //0xBC  01B989B3
        add x19, x19, x27                   //0xC0  01B989B3
        addi x14, x19, 0x008                //0xC4  00898713
        jalr x0,x0, loop                    //0xC8  15800067

img_4:
        add x19, x19, x27                   //0xCC  01B989B3
        add x19, x19, x27                   //0xD0  01B989B3
        add x19, x19, x27                   //0xD4  01B989B3
        addi x14, x19, 0x008                //0xD8  00898713
        jalr x0,x0, loop                    //0xDC  15800067

img_5:
        add x19, x19, x27                   //0xE0  01B989B3     
        add x19, x19, x27                   //0xE4  01B989B3
        add x19, x19, x27                   //0xE8  01B989B3
        add x19, x19, x27                   //0xEC  01B989B3
        addi x14, x19, 0x008                //0xF0  00898713
        jalr x0,x0, loop                    //0xF4  15800067

img_6:
        add x19, x19, x27                   //0xF8  01B989B3
        add x19, x19, x27                   //0xFC  01B989B3
        add x19, x19, x27                   //0x100  01B989B3
        add x19, x19, x27                   //0x104  01B989B3
        add x19, x19, x27                   //0x108  01B989B3
        addi x14, x19, 0x008                //0x10C  00898713
        jalr x0,x0, loop                    //0x110  15800067

img_7:
        add x19, x19, x27                   //0x114  01B989B3
        add x19, x19, x27                   //0x118  01B989B3
        add x19, x19, x27                   //0x11C  01B989B3
        add x19, x19, x27                   //0x120  01B989B3
        add x19, x19, x27                   //0x124  01B989B3
        add x19, x19, x27                   //0x128  01B989B3
        addi x14, x19, 0x008                //0x12C  00898713
        jalr x0,x0, loop                    //0x130  15800067

img_8:
        add x19, x19, x27                   //0x134  01B989B3
        add x19, x19, x27                   //0x138  01B989B3
        add x19, x19, x27                   //0x13C  01B989B3
        add x19, x19, x27                   //0x140  01B989B3
        add x19, x19, x27                   //0x144  01B989B3
        add x19, x19, x27                   //0x148  01B989B3
        add x19, x19, x27                   //0x14C  01B989B3 
        addi x14, x19, 0x008                //0x150  00898713   
        jalr x0,x0, loop                    //0x154  15800067

loop:   
        lw x16, 0(x4)                       //0x158  00022803 (Carga el valor actual de ctrl)
        and x17, x16, x10                   //0x15C  00A878B3 (Aisla el bit ctrl[1])  
        bne x17, x0, exit_loop              //0x160  00089463 (Sale de "loop" si ctrl==1)
        jalr x0, x0, loop                   //0x164  15800067 (Salta a "loop")
exit_loop:lw x18, 0(x6)                     //0x168  00032903 Carga el dato recibido
sb x18, 0(x19)                              //0x16C  01298023 Guarda el dato en la direccion de RAM de en un byte
addi x19, x19, 1                            //0x170  00198993 Aumenta en 1 la direccion de byte en la RAM
beq x19, x14, imagen_escrita                //0x174  00E98463 Si todo el tamaño de imagen ya se guardo completo salta a "imagen_enviada"
jalr x0, x0, loop                           //0x178  15800067 Salta a "loop" si la imagen aun no se ha guardado por completo
imagen_escrita:
sw x20, 0(x3)                               //0x17C  0141A023 Guarda el numero de imagen en LED correspondiente
jalr x0, x0, check                          //0x180  05C00067 Salta a "check"


/////////////////////////////////TRANSMISION A TANG/////////////////////////////////////
exit_loop_tang:
lui x24, 0x40000                            //0x184  00040C37       Inicializa el contador que Recorre la RAM en +0x4
addi x24, x24, 0                            //0x188  000C0C13
lui x25, 0x40000                            //0x18C  00040CB7      Inicializa el contador que Recorre la RAM en +0x4
addi x25, x25, 0                            //0x190  000C8C93
lw x16, 0(x9)                               //0x194  0004A803    Carga el numero de la imagen solicitado por tang

beq x16, x11, img_1_tx                      //0x198  00B80663
beq x16, x10, img_2_tx                      //0x19C  00A80863
/*
beq x16, x28, img_3_tx
beq x16, x12, img_4_tx
beq x16, x29, img_5_tx
beq x16, x30, img_6_tx
beq x16, x31, img_7_tx
beq x16, x23, img_8_tx
*/

jalr x0, x0, check                          //0x1A0  05C00067   Si no se cumple que se reciba un numero valido de imagen, vuelve al checkeo


img_1_tx:
        addi x24, x24, 0x008                //0x1A4  008C0C13
        jalr x0,x0, loop_send_tang          //0x1A8  1B800067
img_2_tx:
        add x25, x25, x27                   //0x1AC  01BC8CB3
        addi x24, x25, 0x008                //0x1B0  008C8C13
        jalr x0,x0, loop_send_tang          //0x1B4  1B800067
/*
img_3_tx:

img_4_tx:

img_5_tx:

img_6_tx:

img_7_tx:

img_8_tx:
*/

loop_send_tang: lb x18, 0(x25)              //0x1B8  000C8903 Carga byte de la RAM
                sw x18, 0(x8)               //0x1BC  01242023 Guarda el byte en 0x2028 (UART B DATA_1)
                sw x11, 0(x7)               //0x1C0  00B3A023 Activa la transmision a la TANG
                sw x0,  0(x7)               //0x1C4  00038023 Desactiva el bit de transmision para evitar transmisiones repetidas
                loop_busy_tx:   
                        lw x26, 0(x7)             //0x1C8  0003AD03 Carga ctrl de la tang
                        and x17, x26, x12         //0x1CC  00CD78B3 Aisla ctrl[2]
                        beq x17, x0, 0x8          //0x1D0  00088463 Si ctrl[2]==0 (busy_tx) sale de "loop_busy_tx"
                        jalr x0, x0, loop_busy_tx //0x1D4  1C800067 Continua corroborando valor de ctrl[2]
                exit_loop_busy_tx:           
                addi x25,x25, 1             //0x1D8  001C8C93 Contador de bytes transmitidos de la imagen en RAM
                beq x25,x24,img_transmitida //0x1DC  018C8463 Si el conteo de bytes transmitidos es igual al tamanio de la imagen en RAM, sale de "loop_send_tang"
                jalr x0, x0, loop_send_tang //0x1E0  1B800067 Continua transmitiendo bytes de la imagen en RAM A tang
img_transmitida:



