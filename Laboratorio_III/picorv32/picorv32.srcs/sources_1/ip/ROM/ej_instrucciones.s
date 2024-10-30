//ESCRITURA EN MEMORIA DE DATOS RAM
//DEBE UTILIZARSE LUI PARA CARGAR VALORES MAS ALTOS QUE 0xFFF. Con lui se agregan
//valores en la parte superior del registro y con addi, en la parte inferior para
//asi preparar el valor dentro del registro para establecer un address grande
//y posteriormente enviarlo mediante sw

//GUARDAR EN LA PRIMERA DIRECCION DE ROM 1 (0x40000)
lui x1, 0x4000        // Cargar 0x4000 en los bits altos de x4 (x4 = 0x40000)
addi x2,x0, 10 
sw x2, 0(x1)          // Almacenar el valor de x2 en la dirección 0x40000

//Equivalente:
memory_initialization_radix=16;
memory_initialization_vector=000400B7 00A00113 0020A023;


///////////INICIALIZACION DE REGISTROS Y SW's///////////////////////////////////////////////
lui x1, 0x4000   //000400B7
addi x2,x0, 10   //00A00113
addi x3, x0, 11  //00B00193
addi x4, x0, 12  //00C00213 Guarda 0xC_16 = 12_10 en x4
addi x5, x0, 13  //00D00293 
addi x6, x0, 14  //00E00313
addi x7, x0, 15  //00F00393
addi x8, x0, 16  //01000413 Guarda 0x10_16 = 16_10 en x8
addi x9, x0, 17  //01100493 
addi x10, x0, 18 //01200513
addi x11, x0, 19 //01300593
addi x12, x0, 20 //01400613
addi x13, x0, 21 //01500693
addi x14, x0, 22 //01600713
addi x15, x0, 23 //01700793
addi x16, x0, 24 //01800813 Guarda 0x18_16 = 24_10 en x16 

addi x17, x0, 25 //01900893
addi x18, x0, 26 //01A00913
addi x19, x0, 27 //01B00993
addi x20, x0, 28 //01C00A13
addi x21, x0, 29 //01D00A93
addi x22, x0, 30 //01E00B13
addi x23, x0, 31 //01F00B93
addi x24, x0, 32 //02000C13
addi x25, x0, 33 //02100C93
addi x26, x0, 34 //02200D13
addi x27, x0, 35 //02300D93
addi x28, x0, 36 //02400E13
addi x29, x0, 37 //02500E93
addi x30, x0, 38 //02600F13
addi x31, x0, 39 //02700F93

sw x2, 0(x1)     //0020A023
sw x3, 0(x1)     //0030A023
sw x4, 0(x1)     //0040A023
sw x5, 0(x1)     //0050A023 
sw x6, 0(x1)     //0060A023
sw x7, 0(x1)     //0070A023
sw x8, 0(x1)     //0080A023
sw x9, 0(x1)     //0090A023
sw x10, 0(x1)    //00A0A023
sw x11, 0(x1)    //00B0A023
sw x12, 0(x1)    //00C0A023

sw x16, 0(x1)    //0100A023
sw x31, 0(x1)    //01F0A023 




//Equivalente:
memory_initialization_radix=16;
memory_initialization_vector=
000400B7 

00A00113 
00B00193 
00C00213 
00D00293 
00E00313 
00F00393 
01000413
01100493
01200513
01300593
01400613
01500693
01600713
01700793
01800813

01900893
01A00913
01B00993
01C00A13
01D00A93
01E00B13
01F00B93
02000C13
02100C93
02200D13
02300D93
02400E13
02500E93
02600F13
02700F93

0020A023 
0030A023
0040A023
0050A023
0060A023
0070A023
0080A023
0090A023
00A0A023
00B0A023
00C0A023

0100A023 //sw x16, 0(x0)
01F0A023 //sw x31, 0(x0)

0071A023 //sw x7, 0(x3)???

;

//////2D0 TEST
memory_initialization_radix=16;
memory_initialization_vector=

01E00093 //addi x1, x0, 30
00100113 //addi x2, x0, 1
00200193 //addi x3, x0, 2
00300213 //addi x4, x0, 3
00400293 //addi x5, x0, 4
00500313 //addi x6, x0, 5
00600393 //addi x7, x0, 6
00700413 // addi x8, x0, 7
00800493 // addi x9, x0, 8
00900513 // addi x10, x0, 9
00A00593 // addi x11, x0, 10
00B00613 // addi x12, x0, 11
00C00693 // addi x13, x0, 12
00D00713 // addi x14, x0, 13
00E00793 // addi x15, x0, 14
00F00813 // addi x16, x0, 15
01000893 // addi x17, x0, 16
01100913 // addi x18, x0, 17
01200993 // addi x19, x0, 18
01300A13 // addi x20, x0, 19
01400A93 // addi x21, x0, 20
01500B13 // addi x22, x0, 21

//Registro de resultados
//sw´s de x2=1=wdata
00212023 //addr=0, wdata=1
00222023 //addr=0, wdata=1
00232023 //addr=4, wdata=1
00242023 //addr=4, wdata=1
00252023 //addr=8, wdata=1
00262023 //addr=8, wdata=1
00272023 //addr=12, wdata=1
00282023 //addr=12, wdata=1
00292023 //addr=16(0x10), wdata=1
002A2023 //addr=16(0x10), wdata=1

;

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

