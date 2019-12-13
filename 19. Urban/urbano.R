# Librerias
library(tidyverse)
library(sf)
library(leaflet)
library(stringr)
niveles <- function(x) levels(as.factor(x))

# Leer informacion 
datos <- st_read("carpetas-de-investigacion-pgj-de-la-ciudad-de-mexico.geojson") %>% 
  st_transform(crs = 4326)

rutas <- st_read("rutas-y-corredores-del-transporte-publico-concesionado.geojson") %>% 
  st_transform(crs = 4326) %>% 
  st_zm()

plot(rutas, max.plot = 1)
head(datos)
niveles(datos$delito)

# Pasajero
datos <- datos %>% 
  mutate(pasajero = str_detect(string = delito, pattern = "PASAJERO")) %>% 
  filter(pasajero) %>% 
  filter(delito == "ROBO A PASAJERO A BORDO DE PESERO COLECTIVO CON VIOLENCIA"  )

leaflet(datos, options = leafletOptions(zoomControl = FALSE)) %>% 
  addProviderTiles("CartoDB.DarkMatter") %>% 
  addPolylines(data = rutas, 
               weight = 0.3, 
               label = rutas$ruta_corre
  ) %>% 
  addCircleMarkers(fillColor = "red", 
                   color = "red",
                   fillOpacity = 0.3, 
                   radius = 0.1
                   )
  

# plot(datos, max.plot = 1)
# niveles(datos$delito %>% as.character())
