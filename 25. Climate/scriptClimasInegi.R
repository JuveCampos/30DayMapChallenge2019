# Libreria
library(sf)
library(readr)
library(leaflet)
library(tidyverse)
niveles <- function(x) levels(as.factor(x))
source("https://raw.githubusercontent.com/JuveCampos/DataVizRepo/master/R/R%20-%20leaflet/Mapas_zona_metropolitana/Norte.R")

# # Abrimos archivos
# shell <- st_read("https://github.com/JuveCampos/Shapes_Resiliencia_CDMX_CIDE/raw/master/Zona%20Metropolitana/ZMVM_shell.geojson")
edos <- st_read("https://github.com/JuveCampos/Shapes_Resiliencia_CDMX_CIDE/raw/master/Zona%20Metropolitana/EstadosZMVM.geojson")
mpios <- st_read("https://github.com/JuveCampos/Shapes_Resiliencia_CDMX_CIDE/raw/master/Zona%20Metropolitana/EdosZM.geojson")
climas_inegi <- st_read("Climas_Inegi.geojson")

# Modificamos la base
climas_inegi$TIPO_C <- as.character(climas_inegi$TIPO_C)
climas_inegi$CLAVE <- as.character(climas_inegi$CLAVE)
climas_inegi$CLIMA_CLAVE <- paste(climas_inegi$CLAVE, climas_inegi$TIPO_C)
climas_inegi$CLIMA_CLAVE <- factor(climas_inegi$CLIMA_CLAVE, levels = niveles(climas_inegi$CLIMA_CLAVE)[c(9,4,5,6,7,8,1,2,3)])

# LEaflet
pal_color <- colorFactor(palette = "Spectral", domain = climas_inegi$CLIMA_CLAVE, reverse = T)
previewColors(pal_color, niveles(climas_inegi$CLIMA_CLAVE))

leaflet(options = leafletOptions(zoomControl = FALSE)) %>%
  addProviderTiles(leaflet::providers$CartoDB.Positron) %>%
  addPolygons(data = climas_inegi, 
              color = "#000000",
              weight = 1,
              fillColor = pal_color(climas_inegi$CLIMA_CLAVE), 
              fillOpacity = 0.9) %>%
  addPolygons(data = mpios, 
              color = "#000000",
              weight = 0.5,
              fill = F, 
              dashArray = c(3,3)
  ) %>% 
  addPolygons(data = edos, fill = F, weight = 2, color = "#000000") %>% 
  addScaleBar(position = "bottomright") %>%
  addLegend(position = "bottomleft", 
            color = "#000000", 
            label = "División Política", 
            opacity = 1) %>%
  addLegend(position = "bottomleft", pal = pal_color, 
            values = climas_inegi$CLIMA_CLAVE, 
            title = "Clima Clasificación Köppen <br>para la ZMVM (INEGI)", 
            opacity = 1) %>%
  norte(posicion = "topright")


# head(climas_inegi)
# climas_inegi$area <- (st_area(climas_inegi)/sum(st_area(climas_inegi))) * 100
# climas_inegi$areaII <- climas_inegi$SHAPE_area/sum(climas_inegi$SHAPE_area) * 100
# 
# d <- cbind(climas_inegi$CLIMA_CLAVE %>% as.character(), climas_inegi$area) %>% 
#   as.data.frame() %>% 
#   mutate(V2 = as.numeric(as.character(V2))) %>%   
#   group_by(V1) %>% 
#   summarize(Area_tot = sum(V2)) %>% 
#   mutate(simbolo = str_extract(V1, pattern = "^\\w+((\\(\\w?\\d?)?\\)?\\w?)+\\s")) %>% 
#   mutate(V1 = factor(V1, levels = niveles(climas_inegi$CLIMA_CLAVE))) %>% 
#   arrange(V1) %>% 
#   mutate(V1 = as.character(V1)) %>% 
#   mutate(V1 = str_remove(V1, pattern = "^\\w+((\\(\\w?\\d?)?\\)?\\w?)+\\s")) 
#   
# write.csv(d,"datos_clima_area.csv", fileEncoding = 'macintosh')
#   
# 
# climas_inegi$CLIMA_CLAVE <- factor(climas_inegi$CLIMA_CLAVE, levels = niveles(climas_inegi$CLIMA_CLAVE)[c(9,4,5,6,7,8,1,2,3)])
# levels(d$V1)  
# class(d$V2)
# 
# 
# 
