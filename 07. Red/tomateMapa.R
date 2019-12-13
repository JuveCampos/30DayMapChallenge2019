# Librerias
library(leaflet)
library(sf)
library(tidyverse)
library(stringr)

# Mapas
edo <-st_read("https://raw.githubusercontent.com/JuveCampos/MexicoSinIslas/master/Sin_islas.geojson") 
edo$ENTIDAD

# Jitomate
jito <- read.csv("EstadosTomate.csv")

# Modificacion de variables
jito$Estado <- str_replace_all(jito$Estado,  
                  c(
                    "MÉXICO" = "MEXICO",
                    "MICHOACÁN DE OCAMPO" = "MICHOACAN DE OCAMPO",
                    "NUEVO LEÓN" = "NUEVO LEON",
                    "QUERÉTARO" = "QUERETARO DE ARTEAGA",
                    "SAN LUIS POTOSÍ" = "SAN LUIS POTOSI",
                    "YUCATÁN" = "YUCATAN", 
                    "CIUDAD DE MEXICO" = "CIUDAD DE MÉXICO"
                  )
                )

# NINGUNO
jito$Estado[which(!(jito$Estado %in% edo$ENTIDAD))] 

# MERGEAMOS
datos <- merge(edo, jito, by.x = "ENTIDAD",  by.y = "Estado")

# Convertimos a factor
datos$Nombre <- datos$Nombre %>% 
  factor(levels = c("tomate", "jitomate", "ambos"))

# Paleta
pal <- colorFactor(palette = c("#800026", "#e31a1c", "#fd8d3c"), 
                   domain = datos$Nombre
                   )
# Codigo del mapa leaflet
leaflet(datos, options = leafletOptions(zoomControl = FALSE)) %>% 
  addProviderTiles("Esri.WorldTerrain") %>% 
  addPolygons(color = "#FFFFFF", 
              fillColor = pal(datos$Nombre), 
              weight = 2,
              fillOpacity = 0.9,
              label = datos$Nombre
              ) %>% 
  addLegend(title = "<b>Nombre: 🍅 </b>", 
            pal = pal, 
            values = datos$Nombre, 
            position = "bottomright"
            )
