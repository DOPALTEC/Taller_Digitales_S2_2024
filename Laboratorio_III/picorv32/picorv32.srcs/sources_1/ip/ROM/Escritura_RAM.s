//Se escribe a partir de 0x40000. Debe ser de 4 en 4, la RAM lo traduce como de 1 en 1
lui x10, 0x4000  //00040537
addi x2,x0, 10 //00A00113 
addi x3,x0, 11 //00B00193
sw x2, 0(x10) //00252023

addi x10,x10,4 //00450513
sw x3, 0(x10)  //00352023