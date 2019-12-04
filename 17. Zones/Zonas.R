library(sf)
library(tidyverse)
library(leaflet)
library(stringr)
library(rebus)
library(wesanderson)

niveles <- function(x) levels(as.factor(x))

# Zonificacion geotecnica
zg <- st_read("http://www.atlas.cdmx.gob.mx/datosAbiertos/SPC_Zonificacion_Geotecnica.geojson") %>% 
  st_transform(crs = 4326)
#st_crs(zg)
plot(zg, max.plot = 1)
zonas <- niveles(zg$DESCRIPCIO)

pal <- colorFactor(c("green", "yellow", "blue"), domain = zonas)

zg1 <- zg %>% 
  filter(DESCRIPCIO == zonas[1]) %>% 
  st_union()

zg2 <- zg %>% 
  filter(DESCRIPCIO == zonas[2]) %>% 
  st_union()

zg3 <- zg %>% 
  filter(DESCRIPCIO == zonas[3]) %>% 
  st_union()


 

leaflet() %>% 
  addProviderTiles("CartoDB.Positron", options = leafletOptions(zoomControl = F)) %>% 
  addPolygons(data = zg, 
              fill = F, 
              weight = 1, 
              dashArray = c(3,3)
              ) %>% 
  addPolygons(data = zg1, 
              weight = 2, 
              fillOpacity = 0.5,
              fillColor = "green", 
              color = "black"
              #, 
              #label = zg$DESCRIPCIO
              ) %>% 
  addPolygons(data = zg2, 
              weight = 2, 
              fillOpacity = 0.5,
              fillColor = "yellow", 
              color = "black"
              #, 
              #label = zg$DESCRIPCIO
  ) %>% 
  addPolygons(data = zg3, 
              weight = 2, 
              fillOpacity = 0.5,
              fillColor = "blue", 
              color = "black"
              #, 
              # label = zg$DESCRIPCIO
  ) %>% 
  addLegend(title = "<b style = 'color:green; font-size:20;'>Zonificación Geotécnica</b> <br><b style = 'color:green;'>Ciudad de México</b>", 
            pal = pal, 
            values = zonas,
            position = "bottomright", 
            opacity = 1
            )


?addLegend
