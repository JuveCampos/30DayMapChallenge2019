# Version pequeña
# Librerias
library(sf)
library(dplyr)
library(leaflet)

##############################
# Abrimos las bases de datos #
##############################
# ocui <- st_read("Bases De Datos/Shapes Municipales/Muni_2012gw.shp") %>%
#   filter(CVE_ENT == 17 & NOM_MUN == "Ocuituco")
# st_write(ocui, "OcuitucoFB.geojson")
ocui <- st_read("Bases De Datos/OcuitucoFB.geojson")

##########################################
# Abrimos la base de puntos de población #
##########################################
# pop <- read.csv("/home/juve/Escritorio/popFB/population_mex_2018-10-01.csv") %>%
#   st_as_sf(coords = c("longitude", "latitude"), crs = 4326)
# ## Hacemos intersección del poligono del municipio con los datos de poblacion
# pop_ocui <- st_intersection(pop, ocui)
# rm(pop)
pop_ocui <- st_read("OcuiPop.geojson")


################
# Mapa leaflet #
################
# Creamos el popup
popup <- paste0("<b>Población 2015: <b> ",  pop_ocui$population_2015, "<br>",
                "<b>Población 2020: <b> ",  pop_ocui$population_2020, "<br>")

# Creamos la paleta de colores
pal <- colorNumeric(palette = "viridis", domain = pop_ocui$population_2015)

# Hacemos el mapa 
leaflet(pop_ocui) %>% 
  addProviderTiles("CartoDB.Positron") %>% 
  addTiles() %>% 
  addCircleMarkers(radius = 2, 
                   popup = popup,
                   color = pal(pop_ocui$population_2015)) %>% 
  addPolygons(data = ocui, color = "#000000", weight = 2, fill = F) %>% 
  addLegend(pal = pal, 
            position = "bottomright",
            values = pop_ocui$population_2015, 
            title = "<div a style = 'color:red;'>Población 2015</div>
            Ocuituco, Morelos")

# Sacamos la suma de poblacion total 
sum(pop_ocui$population_2015)
