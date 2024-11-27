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
addi x12, x0, 4                             //0x2C  00400613 (Referencia para contador de bytes en una word de RAM)
addi x13, x0, 0                             //0x30  00000693 (Contador de bytes en una palabra RAM)
lui x14, 0x4000                             //0x34  00040737 (Tamanio de Imagen 1 en RAM upper)
addi x14, x14, 0x008                        //0x38  00870713 (Tamanio de Imagen 1 en RAM lower)
addi x15, x0, 0                             //0x3C  00000793 (Inicializar Contador de transmisiones totales)
lui x19, 0x4000                             //0x40  000409B7 (Recorre la RAM en +0x4)
/*Aniadir tambien que despues de que verifique si no se ha recibido una imagen que corrobore si no se solicita nada de la tang*/
num_img: lw x16, 0(x4)                      //0x44  00022803 Carga el valor actual de ctrl
        and x17, x16, x10                   //0x48  00A878B3 Aisla el bit ctrl[1]
        bne x17, x0, exit_loop_num_img      //0x4C  00089463 Sale de "num_img" si ctrl==1
        jalr x0, x0, 0x44                   //0x50  04400067 Salta a "num_img"
exit_loop_num_img:lw x20,0(x6)              //0x54  00032A03 Carga el numero de imagen
loop:   lw x16, 0(x4)                       //0x58  00022803 (Carga el valor actual de ctrl)
        and x17, x16, x10                   //0x5C  00A878B3 (Aisla el bit ctrl[1])  
        bne x17, x0, exit_loop              //0x60  00089463 (Sale de "loop" si ctrl==1)
        jalr x0, x0, 0x58                   //0x64  05800067 (Salta a "loop")
exit_loop:lw x18, 0(x6)                     //0x68  00032903 Carga el dato recibido
sb x18, 0(x19)                              //0x6C  01298023 Guarda el dato en la direccion de RAM de en un byte
addi x19, x19, 1                            //0x70  00198993 Aumenta en 1 la direccion de byte en la RAM
beq x19, x14, imagen_escrita                //0x74  00E98463 Si todo el tamaño de imagen ya se guardo completo salta a "imagen_enviada"
jalr x0, x0, 0x58                           //0x78  05800067 Salta a "loop" si la imagen aun no se ha guardado por completo
imagen_escrita:
sw x20, 0(x3)                               //0x7C  0141A023 Guarda el numero de imagen en los leds
loop_tang:      lw x21, 0(x7)               //0x80  0003AA83    Carga ctrl de la tang
                and x17, x21, x10           //0x84  00AAF8B3    Aisla ctrl[1]
                bne x17, x0, exit_loop_tang //0x88  00089463    Si no es igual a cero sale de "loop_tang"
                jalr x0, x0, 0x80           //0x8C  08000067    Si hay un dato recibido desde la tang nano sale de "loop_tang"
exit_loop_tang:lw x16, 0(x9)                //0x90  0004A803    Carga el numero de la imagen solicitado por tang
addi x22, x0, 1                             //0x94  00100B13    Valor para transmitir datos ctrl[0]=1=>send      
beq x16, x22, 0x8                           //0x98  01680463    Si el dato recibido es 1 (numero de imagen) sale de "loop_send_tang"
jalr x0, x0, 0x80                           //0x9C  08000067    Si hay un dato recibido desde la tang nano sale de "loop_tang"
lui x25, 0x4000                             //0xA0  00040CB7     Inicializa el contador que Recorre la RAM en +0x4
add x23, x8, x0                             //0xA4  00040BB3    No cambia, es la direccion UART B DATA_2
addi x24, x0, 0                             //0xA8  00000C13    Contador hasta 4
/*
Se debe agregar que al recibir el numero especifico
de la imagen se envie esa imagen
lw x25, 0(x9)
bne x25,x22, loop_tang
*/
loop_send_tang: lb x18, 0(x25)              //0xAC  000C8903    Carga byte de la RAM
                sw x18, 0(x23)              //0xB0  012B8023    Guarda el byte en 0x2028 (UART B DATA_1)
                sw x22, 0(x7)               //0xB4  0163A023    Activa la transmision a la TANG
                sw x0,  0(x7)               //0xB8  00038023    Desactiva el bit de transmision para evitar transmisiones repetidas
                loop_busy_tx:   
                        lw x26, 0(x7)       //0xBC  0003AD03    //Carga ctrl de la tang
                        and x17, x26, x12   //0xC0  00CD78B3    //Aisla ctrl[2]
                        beq x17, x0, 0x8    //0xC4  00088463    //Si ctrl[2]==0 (busy_tx) sale de "loop_busy_tx"
                        jalr x0, x0, 0xBC   //0xC8  0BC00067    //Continua corroborando valor de ctrl[2]
                exit_loop_busy_tx:           
                addi x25,x25, 1             //0xCC  001C8C93    Contador de bytes transmitidos de la imagen en RAM
                beq x25,x14,img_transmitida //0xD0  00EC8463 salto de +x8
                jalr x0, x0, 0xAC           //0xD4  0AC00067
img_transmitida:



