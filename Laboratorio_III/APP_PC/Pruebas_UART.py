import serial
import time
import cv2

# Cargar la imagen y obtener su tamaño con cv2
img_path = "CHARMANDER.png"
img_cv2 = cv2.imread(img_path)


###########Tamanio de Imagen#####################
# Obtener dimensiones de la imagen
height, width, _ = img_cv2.shape

# Convertir el tamaño a hexadecimal (elimina el prefijo '0x')
width_hex = hex(width)[2:].zfill(6)  # Asegurarse de que tenga al menos 6 caracteres, rellenando con ceros a la izquierda si es necesario

print(f"Tamaño de Imagen Hexa (Ancho): {width_hex}")
print(f"Bytes individuales a enviar: {width_hex[3:6]}")

##########Valores RGB de la Imagen###########################

# Coordenadas fijas
x, y = 120, 120
b, g, r = img_cv2[y, x]

# Obtener el valor RGB del píxel escogido:

print(f"Pixel en Coordenadas: ({x}, {y}): (R={r}, G={g}, B={b})")

# Configurar la conexión UART en el puerto COM4 y con un baudrate de 9600
ser = serial.Serial('COM4', baudrate=9600, timeout=1)

# Esperar un momento para asegurar la conexión
time.sleep(2)


###############ENVIOS DE DATOS#########################
# Enviar los tres bytes de forma separada
# Primer byte
#byte1 = int(width_hex[4:6], 16)  # Convertir a valor entero el primer byte
#ser.write(bytes([byte1]))  # Enviar primer byte

# Segundo byte
#byte2 = int(width_hex[3], 16)  # Convertir a valor entero el segundo byte
#ser.write(bytes([byte2]))  # Enviar segundo byte

#Byte r de ejemplo de la imagen
#ser.write(bytes([r])) #envia valor de r del pixel escogido

#Byte r de ejemplo de la imagen
ser.write(bytes([g])) #envia valor de r del pixel escogido

#Byte r de ejemplo de la imagen
#ser.write(bytes([b])) #envia valor de r del pixel escogido

# Cerrar la conexión
ser.close()
