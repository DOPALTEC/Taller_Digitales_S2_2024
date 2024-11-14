import serial
import time
import cv2

# Lista de imágenes disponibles
images = {
    1: "CHARMANDER_LCD.png",
    2: "A.png",
    3: "B.png",
    4: "C.png",
    5: "D.png",
    6: "E.png",
    7: "F.png",
    8: "G.png"
}

# Convertir RGB888 a RGB565
def rgb888_to_rgb565(r, g, b):
    r_565 = (r * 31) // 255  # Convertir R a 5 bits
    g_565 = (g * 63) // 255  # Convertir G a 6 bits
    b_565 = (b * 31) // 255  # Convertir B a 5 bits
    
    # Empacar los valores RGB565 en un solo valor de 16 bits
    rgb_565 = (r_565 << 11) | (g_565 << 5) | b_565  # Desplazamiento y combinación
    return rgb_565

##try:
##    ser = serial.Serial('COM4', baudrate=9600, timeout=1)
##    time.sleep(2)  # Esperar un momento para asegurar la conexión
##    print("Conexión UART establecida.")
##except serial.SerialException:
##    raise ValueError("No se pudo establecer conexión en COM4. Verifica el puerto.")



while True:
    # Mostrar las opciones al usuario
    print("Selecciona una imagen para enviar:")
    for key, img_name in images.items():
        print(f"{key}: {img_name}")

    # Validar la elección del usuario
    while True:
        try:
            choice = int(input("Ingresa el número de la imagen que deseas enviar (1-8): "))
            if 1 <= choice <= 8:
                img_path = images[choice]
                print(f"Has elegido la imagen: {img_path}")
                break
            else:
                print("Por favor, elige un número entre 1 y 8.")
        except ValueError:
            print("Entrada no válida. Por favor, ingresa un número.")

    # Cargar la imagen elegida y verificar su carga
    img_cv2 = cv2.imread(img_path)
    if img_cv2 is None:
        raise ValueError("No se pudo cargar la imagen. Verifica la ruta de la imagen.")

    # Obtener dimensiones de la imagen
    height, width, _ = img_cv2.shape

    # Convertir el ancho a hexadecimal
    width_hex = hex(width)[2:].zfill(6)  # Se asegura de tener al menos 6 caracteres, rellenando con ceros si es necesario
    print(f"Tamaño de Imagen en Hexadecimal (Ancho): {width_hex}")

    # Ejemplo de lectura de un píxel específico
    i, j = 100, 120
    b_test, g_test, r_test = img_cv2[i, j]
    print(f"Pixel en Coordenadas ({i}, {j}): (R={r_test}, G={g_test}, B={b_test})")

    cont=0

    # Enviar cada píxel de la imagen en formato RGB565
    try:
        for y in range(height):
            for x in range(width):
                b, g, r = img_cv2[y, x]
                rgb_565 = rgb888_to_rgb565(r, g, b)
            
            # Dividir el valor RGB565 en 2 bytes (MSB y LSB)
                msb = (rgb_565 >> 8) & 0xFF  # Byte más significativo (8 bits)
                lsb = rgb_565 & 0xFF         # Byte menos significativo (8 bits)
                cont=cont+2
                print(f"Pixel en Coordenadas: ({x}, {y}): (R={r}, G={g}, B={b}) -> RGB565={hex(rgb_565)}")
            
            # Enviar los 2 bytes (MSB y LSB) de RGB565
                ##ser.write(bytes([msb]))  # Enviar byte más significativo
                ##ser.write(bytes([lsb]))  # Enviar byte menos significativo
            
        print("Imagen enviada correctamente.")
        print("Tamaño en Transmisiones de Imagen:")
        print(cont)
    except Exception as e:
        print(f"Ocurrió un error durante el envío de la imagen: {e}")
    # Preguntar si el usuario desea enviar otra imagen
        retry = input("¿Deseas enviar otra imagen? (y/n): ").strip().lower()
        if retry != 'y':
            print("Finalizando el programa.")
            break

# Cerrar la conexión serial
##ser.close()
print("Conexión UART cerrada.")
