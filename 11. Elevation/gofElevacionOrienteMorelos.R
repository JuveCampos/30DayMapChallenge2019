###################################################
# RAYSHADER                                       #
# CÓDIGO PARA HACER VIZ DE ELEVACIONES            #
# JORGE JUVENAL CAMPOS FERREIRA                   #
# BASADO EN EL TUTORIAL DE @wcmbishop             #
# https://wcmbishop.github.io/rayshader-demo/     #
###################################################

# Librerias para trabajar con elevaciones
library(raster)
library(rayshader)
library(tidyverse)

# Leemos scripts de funciones locales de @wcmbishop
source("https://raw.githubusercontent.com/wcmbishop/rayshader-demo/master/R/image-size.R")
source("https://raw.githubusercontent.com/wcmbishop/rayshader-demo/master/R/elevation-api.R")
source("https://raw.githubusercontent.com/wcmbishop/rayshader-demo/master/R/read-elevation.R")
source("https://raw.githubusercontent.com/wcmbishop/rayshader-demo/master/R/map-image-api.R")
source("https://raw.githubusercontent.com/wcmbishop/rayshader-demo/master/R/rayshader-gif.R")
source("https://raw.githubusercontent.com/wcmbishop/rayshader-demo/master/R/find-image-coordinates.R")
source("https://raw.githubusercontent.com/wcmbishop/rayshader-demo/master/R/rayshader-gif.R")

# Definimos las coordenadas del rectángulo que vamos a visualizar (latitudes/longitudes).
bbox <- list(
  p1 = list(long = -98.53322, lat = 19.095),
  p2 = list(long = -98.86877, lat = 18.782)
)

# Tamaño de la imágen
image_size <- define_image_size(bbox, major_dim = 600)

# Descargamos datos con el tamaño de la caja desde el API del USGS
elev_file <- file.path("data", "elevation.tif")
get_usgs_elevation_data(bbox, size = image_size$size, file = elev_file,
                        sr_bbox = 4326, sr_image = 4326)

# Cargamos datos de elevaciones descargados del USGS
elev_img <- raster::raster(elev_file)
elev_matrix <- matrix(
  raster::extract(elev_img, raster::extent(elev_img), buffer = 1000), 
  nrow = ncol(elev_img), ncol = nrow(elev_img)
)

# Calculamos las capas del Rayshader
ambmat <- ambient_shade(elev_matrix, zscale = 30)
raymat <- ray_shade(elev_matrix, zscale = 30, lambert = TRUE)
watermap <- detect_water(elev_matrix)

# Hacemos un plot 2D
elev_matrix %>%
  sphere_shade(texture = "imhof4") %>% # imhoff4 es textura desertica. Cambiar. 
  add_water(watermap, color = "imhof4") %>%
  add_shadow(raymat, max_darken = 0.5) %>%
  add_shadow(ambmat, max_darken = 0.5) %>%
  plot_map()

# TEXTURAS: ('imhof1','imhof2','imhof3','imhof4','desert', 'bw', and 'unicorn')


# Buscamos y pegamos imágen de fondo. 
# En este caso, de la librería de ArcGis, que ya viene georreferenciada.
overlay_file <- "images/ocui-map.png"
get_arcgis_map_image(bbox, 
                     map_type = "World_Imagery", 
                     file = overlay_file,
                     width = image_size$width, height = image_size$height, 
                     sr_bbox = 4326)
overlay_img <- png::readPNG(overlay_file)


# Mapa 2D con imágen sobrepuesta
elev_matrix %>%
  sphere_shade(texture = "imhof4") %>%
  add_water(watermap, color = "imhof4") %>%
  add_shadow(raymat, max_darken = 0.5) %>%
  add_shadow(ambmat, max_darken = 0.5) %>%
  add_overlay(overlay_img, alphalayer = 0.5) %>%
  plot_map()


# Definir Etiqueta de punto seleccionado para marcar
label <- list(text = "Ocuituco Morelos")
label$pos <- find_image_coordinates(
  long = -98.780823, lat = 18.86129, bbox = bbox,
  image_width = image_size$width, image_height = image_size$height)

# Escala Z (A mayor z, las elevaciones son más grandes)
zscale <- 30
rgl::clear3d()
elev_matrix %>% 
  sphere_shade(texture = "imhof1") %>% 
  add_water(watermap, color = "imhof1") %>%
  add_overlay(overlay_img, alphalayer = 0.5) %>%
  add_shadow(raymat, max_darken = 0.5) %>%
  add_shadow(ambmat, max_darken = 0.5) %>%
  plot_3d(elev_matrix, zscale = zscale, windowsize = c(1200, 1000),
          water = TRUE, soliddepth = -15, wateralpha = 0,
          theta = 25, phi = 30, zoom = 0.65, fov = 60)
render_label(elev_matrix, x = label$pos$x, y = label$pos$y, z = 1000, 
             zscale = zscale, text = label$text, textsize = 2, linewidth = 5, family = "Arial", freetype = F)
render_snapshot()

##################
# Armado del gif #
##################

# gif transition variables
##############################

# Numero de frames en el *.gif
n_frames <- 30

# Angulo Theta (Variacion para el gif)
theta <- transition_values(from = 0, to = 360, steps = n_frames,
                           one_way = TRUE, type = "lin")

# Angulo Phi (Variación para el gif)
phi <- transition_values(from = 10, to = 70, steps = n_frames,
                         one_way = FALSE, type = "cos")

# Variación del Zoom
zoom <- transition_values(from = 0.4, to = 0.8, steps = n_frames,
                          one_way = FALSE, type = "cos")

# Hacemos el GIF
# # GIF it!
# zscale <- 10

# Librerias para hacer gifs
library(magick)
library(gifski)

# Hacer el Gif con las imágenes creadas en los pasos anteriores.
elev_matrix %>%
  sphere_shade(texture = "imhof1") %>%
  add_water(watermap, color = "imhof1") %>%
  add_overlay(overlay_img, alphalayer = 0.5) %>%
  add_shadow(raymat, 0.4) %>%
  add_shadow(ambmat, 0.4) %>%
  save_3d_gif(elev_matrix, file = "images/ocui-flyby.gif", duration = 10,
              zscale = zscale, windowsize = c(1200, 1000), wateralpha = 0,
              water = TRUE, soliddepth = -15,
              theta = theta, phi = phi, zoom = zoom, fov = 60) 

