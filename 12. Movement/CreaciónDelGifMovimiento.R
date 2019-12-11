library(purrr)
library(magick)

# Elaboración de Gifs. 
# Imagenes tomadas de http://appecobici.jjsantoso.com

# CREACIÓN DEL GIF. 
list.files()[1:4] %>% 
  map(image_read) %>% # Lee rutas de los archivos. 
  image_join() %>% # Junta imágenes
  image_animate(fps=1) %>% # Anima las imagenes, con 1 segundo entre imágenes. 
  image_write("movment.gif") # Escribe el gif en el directorio. 

??map
