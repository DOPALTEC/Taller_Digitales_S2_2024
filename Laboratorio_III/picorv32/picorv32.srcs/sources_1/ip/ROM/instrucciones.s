//ESCRITURA EN MEMORIA DE DATOS RAM
//DEBE UTILIZARSE LUI PARA CARGAR VALORES MAS ALTOS QUE 0xFFF. Con lui se agregan
//valores en la parte superior del registro y con addi, en la parte inferior para
//asi preparar el valor dentro del registro para establecer un address grande
//y posteriormente enviarlo mediante sw

//GUARDAR EN LA PRIMERA DIRECCION DE ROM (0x40000)
lui x1, 0x4000        // Cargar 0x4000 en los bits altos de x4 (x4 = 0x40000)
addi x2,x0, 10 
sw x2, 0(x1)          // Almacenar el valor de x1 en la dirección 0x40000