import cv2
import serial
import time

# Cargar la imagen y obtener su tamaño con cv2
img_path = "CHARMANDER.png"
img_cv2 = cv2.imread(img_path)

# Coordenadas fijas
x, y = 150, 150

# Obtener el valor RGB del píxel en (150, 150)
b, g, r = img_cv2[y, x]

# Imprimir el resultado
print(f"Pixel at ({x}, {y}): (R={r}, G={g}, B={b})")

# Configurar la conexión UART
# Asegúrate de reemplazar 'COM3' con el puerto correcto de tu sistema
# y ajusta el baudrate según sea necesario
ser = serial.Serial('COM3', baudrate=9600, timeout=1)

# Esperar un momento para asegurar la conexión
time.sleep(2)

# Enviar los datos por UART
data_to_send = f"{r},{g},{b}\n"  # Formato: R,G,B
ser.write(data_to_send.encode())  # Codificar y enviar

# Cerrar la conexión
ser.close()
