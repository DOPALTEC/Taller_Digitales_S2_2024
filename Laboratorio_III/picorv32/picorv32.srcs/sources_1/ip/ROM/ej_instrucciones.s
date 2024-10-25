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


////////////////////////GUARDAR EN PRIMERAS DIRECCIONES DE ROM 1 (0x40000 a 0x40005) ABCDEF/////////////////////

lui x1, 0x4000 //000400B7       // Cargar 0x4000 en los bits altos de x4 (x4 = 0x40000)
addi x2,x0, 10 //00A00113
addi x5, x0, 13 //
addi x4, x0, 11 //Guarda B en x7
sw x2, 0(x1)   //0020A023         // Almacenar el valor de x1 en la dirección 0x40000

//Equivalente:
memory_initialization_radix=16;
memory_initialization_vector=000400B7 00A00113 0020A023;

////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////PRUEBAS
lui x1, 0x4000  //000400B7
addi x2,x0, 10  //00A00113
addi x5, x0, 13 //00D00293
sw x2, 0(x1)    //0020A023
addi x4, x0, 11 //00B00113
sw x5, 0(x1)    //0050A023 //IR CAMBIANDO TERCER DIGITO PARA VER SI CONTIENE TODOS LOS VALORES DE RD


//Equivalente:
memory_initialization_radix=16;
memory_initialization_vector=000400B7 00A00113 00D00293 0020A023 00B00113 0050A023;
