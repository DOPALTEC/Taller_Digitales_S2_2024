from PIL import Image

def rgb_of_pixel(img_path, x, y):
    # Abre la imagen y asegúrate de que esté en modo RGB
    im = Image.open(img_path).convert('RGB')
    # Obtiene el valor RGB del píxel en las coordenadas (x, y)
    r, g, b = im.getpixel((x, y))
    # Retorna los valores como una tupla
    return (r, g, b)

# Especifica el nombre de la imagen
img = "MEWTWO.jpg"
# Llama a la función e imprime el resultado
print(rgb_of_pixel(img, 5, 5))
