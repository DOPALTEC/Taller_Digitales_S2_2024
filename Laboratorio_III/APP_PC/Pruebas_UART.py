import serial
import time
import cv2

# Cargar la imagen y obtener su tamaño con cv2
img_path = "CHARMANDER.png"
img_cv2 = cv2.imread(img_path)

# Obtener dimensiones de la imagen
height, width, _ = img_cv2.shape

# Convertir el tamaño a hexadecimal (elimina el prefijo '0x')
width_hex = hex(width)[2:].zfill(6)  # Asegurarse de que tenga al menos 6 caracteres, rellenando con ceros a la izquierda si es necesario

print(f"Tamaño de Imagen Hexa (Ancho): {width_hex}")
print(f"Bytes individuales a enviar: {width_hex[3:6]}")

# Configurar la conexión UART en el puerto COM4 y con un baudrate de 9600
ser = serial.Serial('COM4', baudrate=9600, timeout=1)

# Esperar un momento para asegurar la conexión
time.sleep(2)

# Enviar los tres bytes de forma separada
# Primer byte
byte1 = int(width_hex[4:6], 16)  # Convertir a valor entero el primer byte
ser.write(bytes([byte1]))  # Enviar primer byte

# Segundo byte
byte2 = int(width_hex[3], 16)  # Convertir a valor entero el segundo byte
ser.write(bytes([byte2]))  # Enviar segundo byte

# Cerrar la conexión
ser.close()
