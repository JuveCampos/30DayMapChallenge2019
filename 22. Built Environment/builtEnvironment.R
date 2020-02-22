    # Librerias
    library(raster)
    library(sf)
    library(tidyverse)
    library(leaflet)
    library(webshot)
    
  # Leemos datos
  sc <- st_read("http://rir.geoint.mx/RIR/archivos/90_Suele_de_Conservacion_CdM.geojson")
  plot(sc, max.plot = 1)
  
# Leemos datos de poblacion
# Estos datos hay que descargarlos de humdata.org,
# https://data.humdata.org/dataset/mexico-high-resolution-population-density-maps-demographic-estimates  
pop <- read.csv("population_mex_2018-10-01.csv") %>% 
    st_as_sf(coords = c("longitude", "latitude"), crs = 4326)

# Poligono de recorte  
pol <- st_read("https://raw.githubusercontent.com/JuveCampos/Shapes_Resiliencia_CDMX_CIDE/master/Shape%20Ciudad%20de%20M%C3%A9xico/CDMX_mpal.geojson")
  
# Recortando los datos
datos <- st_intersection(pop, sc)
plot(pol, max.plot = 1)

# Elaborando el mapa
leaflet(datos, options = leafletOptions(zoomControl = F)) %>%
  addProviderTiles(providers$CartoDB.PositronNoLabels) %>%
  addPolygons(data = sc,
              color = "black",
              weight = 1,
              fillColor = "green", 
              fillOpacity = 0.8
              ) %>% 
  addCircleMarkers(radius = 0.5, 
                   color = "brown", 
                   opacity = 1
                   ) %>% 
  addPolygons(data = pol, 
              weight = 1, 
              color = "black", 
              fillOpacity = 0.3,
              dashArray = c(1,1)
              ) %>% 
  addPolygons(data = st_union(pol), 
              fill = F, 
              weight = 2, 
              color = "black"
              ) %>% 
  addLegend(title = "Leyenda", 
            colors = c("green", "brown"), 
            labels = c("Suelo de <br> conservación", "Población viviendo<br>en suelo de conservación"), 
            position = "bottomleft"
            ) -> p

# Removiendo los datos  
rm(datos)

# save html to png - Guardando una versión HTML del mapa.
htmlwidgets::saveWidget(p, "temp.html",  selfcontained = FALSE)
webshot("temp.html", file = "mapaPopSC.png",
        cliprect = "viewport")

