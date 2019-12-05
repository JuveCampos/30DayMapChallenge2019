# Librerias
pacman::p_load("tidyverse",
               "leaflet",
               "sf")

# Leemos base 
edos <- st_read("https://raw.githubusercontent.com/JuveCampos/MexicoSinIslas/master/mexicoTrends.geojson") %>% 
  st_transform(crs = 4326) %>%
  mutate(esSchanuzer = ifelse(ENTIDAD == "SAN LUIS POTOSI",
                              1, 0
                               ))
slp <- edos %>% 
  filter(ENTIDAD == "SAN LUIS POTOSI")

# Graficamos
plot(edos, max.plot = 1)
# Paleta de colores 
palPerrito <- colorFactor(palette = c("#c2f59b", "#f7753e"), 
                          domain = edos$esSchanuzer)

leaflet(edos, options = leafletOptions(zoomControl = F)) %>% 
  addTiles() %>% 
  addPolygons(color = "black", 
              weight = 1, 
              fillColor = palPerrito(edos$esSchanuzer), 
              fillOpacity = 0.8
              ) %>% 
  addLegend(title = "<b style = 'color:red;text-shadow: 0.5px 0.5px #000000;'>Leyenda:</>",
            position = "bottomleft", 
            colors = c("#f7753e", "#c2f59b"), 
            labels = c("Parece perrito", 
                       "No parece perrito"
                       ), 
            opacity = 1
            )

# EL ESTADO SOLO 

leaflet(slp) %>% 
  addPolygons(fillColor = "white", 
              color = "black", 
              opacity = 1,
              fillOpacity = 1)

