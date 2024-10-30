import cv2

# Cargar la imagen y obtener su tamaño con cv2
img_path = "CHARMANDER.png"
img_cv2 = cv2.imread(img_path)

# Coordenadas fijas
x, y = 150, 150

# Obtener el valor RGB del píxel en (150, 150)
b, g, r = img_cv2[y, x]

# Imprimir el resultado
print(f"Pixel at ({x}, {y}): (R={r}, G={g}, B={b})")
