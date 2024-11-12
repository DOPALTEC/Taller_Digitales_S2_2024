import cv2
import serial
import time

# Cargar la imagen y obtener su tamaño con cv2
img_path = "CHARMANDER.png"
img_cv2 = cv2.imread(img_path)

# Obtener dimensiones de la imagen
height, width, _ = img_cv2.shape

# Convertir el tamaño a hexadecimal
width_hex = hex(width)
height_hex = hex(height)

# Coordenadas fijas
x, y = 347, 347

# Obtener el valor RGB del píxel en (347, 347)
b, g, r = img_cv2[y, x]

# Imprimir el tamaño de la imagen y el valor del píxel en decimal y hexadecimal
print(f"Image size (decimal): {width}x{height}")
print(f"Tamaño de Imagen Hexa (Ancho): {width_hex}")
print(f"Tamaño de Imagen Hexa (Alto): {height_hex}")
print(f"Pixel at ({x}, {y}): (R={r}, G={g}, B={b})")

# Configurar la conexión UART
ser = serial.Serial('COM4', baudrate=9600, timeout=1)
time.sleep(2)

# Enviar el tamaño de la imagen en hexadecimal
size_hex_to_send = f"{width_hex},{height_hex}\n"  # Formato: width_hex,height_hex
ser.write(size_hex_to_send.encode())  # Codificar y enviar
print(f"Sent image size (hex): {size_hex_to_send.strip()}")  # Imprimir valor enviado en hexadecimal

# Enviar los datos RGB del píxel
#data_to_send = f"{r},{g},{b}\n"  # Formato: R,G,B
#ser.write(data_to_send.encode())  # Codificar y enviar
#print(f"Sent RGB data: {data_to_send.strip()}")  # Imprimir el valor enviado

# Cerrar la conexión
ser.close()
