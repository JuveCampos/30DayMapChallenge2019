library(raster)
library(sf)
library(tidyverse)
library(leaflet)
library(webshot)

# Leemos datos
datos <- raster("population_mex_2018-10-01.tif")
object.size(datos)
plot(datos)


# Leemos .csv
datoscsv <- read.csv("population_mex_2018-10-01.csv")
datoscsv <- st_as_sf(datoscsv, coords = c("longitude", "latitude"), crs = 4326)
head(datoscsv)
rm(datoscsv)

mini <- datoscsv[1:10000,]
edo <- st_read("https://raw.githubusercontent.com/JuveCampos/MexicoSinIslas/master/mexicoTrends.geojson", 
               quiet = TRUE)

mor <- edo %>% 
  filter(ENTIDAD == "MORELOS")

mini2 <- st_as_sf(mini, coords = c("longitude", "latitude"), crs = 4326)
plot(mini2, max.plot = 1)


mini2Mor <- st_intersection(mor,datoscsv)
plot(mini2Mor, max.plot = 1)

p <- leaflet(mini2Mor, options = leafletOptions(zoomControl = F)) %>% 
  addProviderTiles("CartoDB.DarkMatter") %>%
  addCircleMarkers(radius = 0.1, color = "#FFFFFF", opacity = 0.1, weight = 0.1, fillOpacity = 0.6) %>% 
  addPolygons(data=mor, weight = 1, color = "#FFFFFF")

## save html to png
htmlwidgets::saveWidget(p, "temp.html", selfcontained = FALSE)
webshot("temp.html", file = "Rplot.png",
        cliprect = "viewport")

