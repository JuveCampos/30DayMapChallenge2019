library(sf)
library(tidyverse)
library(leaflet)
niveles <- function(x) levels(as.factor(x))

datos <- st_read("muni_2015gw.geojson", quiet = T) 

datos %>% 
  filter(NOM_ENT == "Morelos") %>% 
  plot(max.plot = 1)

niveles(datos$NOM_ENT)

#·····························································#
# Aquí cambiaba el nombre del municipio con enclaves, y el    #
# codigo restante hacia el resto del mapa.                    #
# La misma lógica detrás de una función                       #
#·····························································#
edo <- datos %>% 
  filter(NOM_ENT == "México" ) %>% 
  mutate(enclave = str_detect(NOM_MUN, pattern = "San Martín de las Pirámides"))

edo$NOM_MUN %>% as.character() %>% niveles()

niveles(edo$NOM_MUN %>% as.character())

# Paleta de colores
pal <- colorFactor(c("yellow", "red"), domain = edo$enclave)
pal(edo$enclave) %>% table()

#%>%  Mapa! 
leaflet(edo) %>% 
  addProviderTiles("CartoDB.DarkMatter") %>% 
  addPolygons(color = "#000000" ,
              weight = 1, 
              smoothFactor = 0.5,
              opacity = 1.0,
              fillOpacity = 0.9,
              fill = "white",
              fillColor = ~pal(edo$enclave),    # Color de llenado
              #layerId = ~shape$CVE_EDO,                  
              highlightOptions = highlightOptions(color = "white", weight = 2,
                                                  bringToFront = TRUE), #highlight cuando pasas el cursor
              label =  lapply(paste0("<b style = 'color: red;'>Municipio: </b><br>", edo$NOM_MUN, ", ", edo$NOM_ENT), htmltools::HTML),                                  # etiqueta cuando pasas el cursor
              labelOptions = labelOptions(direction = "auto")
              # ,
              # popup = popup
              )

