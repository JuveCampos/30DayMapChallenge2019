# Librerias
library(sf)
library(dplyr)
library(leaflet)

# Abrimos Datos
ocui <- st_read("Bases De Datos/Shapes Municipales/Muni_2012gw.shp") %>% 
  filter(CVE_ENT == 17 & NOM_MUN == "Ocuituco") 
#plot(ocui, max.plot = 1)
st_write(ocui, "OcuitucoFB.geojson")


pop <- read.csv("/home/juve/Escritorio/popFB/population_mex_2018-10-01.csv") 
pop <-   st_as_sf(pop, coords = c("longitude", "latitude"), crs = 4326)

pop_ocui <- st_intersection(pop, ocui)
rm(pop)
plot(pop_ocui, max.plot = 1)

# Mapa leaflet
popup <- paste0("<b>Población 2015: <b> ",  pop_ocui$population_2015, "<br>",
                "<b>Población 2020: <b> ",  pop_ocui$population_2020, "<br>"
                )
pal <- colorNumeric(palette = "viridis", domain = pop_ocui$population_2015)

leaflet(pop_ocui) %>% 
  #addProviderTiles("CartoDB.Positron") %>% 
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
  
sum(pop_ocui$population_2015)

