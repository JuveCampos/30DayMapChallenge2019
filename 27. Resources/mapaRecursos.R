pacman::p_load(sf, tidyverse, leaflet)
niveles <- function(x) levels(as.factor(x))

# Acuifero (Procesamiento original)
# acu <- st_read("Acuiferos_condicion_2018/Acuiferos_condicion_2018.shp") %>% 
#   st_transform(crs = 4326)  %>% 
#   st_write("acu.geojson")

acu <- st_read("acu.geojson")

# Informacion municipal Zona Metropolitana
muni <- st_read("https://github.com/JuveCampos/Shapes_Resiliencia_CDMX_CIDE/raw/master/Zona%20Metropolitana/EdosZM.geojson") 

# Infomacion Municipal CDMX
cdmx <- st_read("https://github.com/JuveCampos/Shapes_Resiliencia_CDMX_CIDE/raw/master/Zona%20Metropolitana/EdosZM.geojson") %>% 
  filter(CVE_ENT == "09")

# Condicion de sobreexplotacion 
acu$condi

# Condicion de ZM
zm$NOM_SUN
# Valle de M‚xico 
#	E4001B

pal2 <- colorFactor(palette = c("blue", "red"), 
                    domain = niveles(acu$condi)
                    )
acu %>% 
  leaflet(options = leafletOptions(zoomControl = F)) %>% 
  addProviderTiles("CartoDB.DarkMatter") %>% 
  addPolygons(color = "white", 
              fillColor = pal2(acu$condi), 
              weight = 0.5, 
              label = acu$condi,
              fillOpacity = 0.8
              ) %>% 
  addLegend(title = "Acuíferos en México y Condición de explotación", 
            pal = pal2, 
            values = acu$condi, 
            position= "bottomleft"
            )

acu2 <- acu[st_intersects(muni, acu) %>% unlist() %>% unique(),] 

leaflet(options = leafletOptions(zoomControl = FALSE)) %>% 
  addProviderTiles("CartoDB.Positron") %>% 
  addPolygons(data = acu2, 
              opacity = 1,
              fillOpacity = 0.5,
              fillColor = pal2(acu2$condi), 
              color = "black"
              ) %>% 
  addPolygons(data = cdmx, 
              fillColor = "gold", 
              fillOpacity = 1, 
              color = "black",
              weight = 1,
              dashArray = c(1,1)
              ) %>% 
  addLegend( 
            colors = "gold", 
            labels = "Polígono de la CDMX", 
            position= "bottomleft"
  ) %>% 
  addLegend(title = "Acuíferos en la ZMVM y Condición de explotación", 
            pal = pal2, 
            values = acu$condi, 
            position= "bottomleft"
  )

