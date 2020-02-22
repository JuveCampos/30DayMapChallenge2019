# Librerias
library(raster)
library(sf)
library(tidyverse)
library(leaflet)
library(webshot)
niveles <- function(x) levels(as.factor(x))
# Leemos .csv
datoscsv <- read.csv("population_mex_2018-10-01.csv")
datoscsv <- st_as_sf(datoscsv, coords = c("longitude", "latitude"), crs = 4326)
#datoscsv <- readRDS("")
head(datoscsv)
# saveRDS(datoscsv, "puntosPop.rds")
# rm(datoscsv)

# mini <- datoscsv[1:10000,]
edo <- st_read("dest2018gw/dest2018gw.shp", 
               quiet = TRUE) %>% 
  mutate(ENTIDAD = toupper(NOM_ENT))

niveles(edo$ENTIDAD)

# edos <- c("CAMPECHE", "COAHUILA DE ZARAGOZA", "BAJA CALIFORNIA SUR", 
#           "ZACATECAS", "DURANGO", "CHIHUAHUA", "QUINTANA ROO", "SONORA")

edos <- c("CAMPECHE")

estado <- edos[1]
#for (estado in edos[-1]){

  mor <- edo %>% 
    filter(ENTIDAD == estado)
  
  mini2Mor <- st_intersection(mor,datoscsv)
  #plot(mini2Mor, max.plot = 1)
  
  p <- leaflet(mini2Mor, options = leafletOptions(zoomControl = F)) %>% 
    addProviderTiles("CartoDB.DarkMatter") %>%
    addCircleMarkers(radius = 0.1, color = "#FFFFFF", opacity = 0.1, weight = 0.1, fillOpacity = 0.6) %>% 
    addPolygons(data=mor, weight = 1, color = "#FFFFFF")
  
  p
  
  # save html to png
  htmlwidgets::saveWidget(p, paste0(estado, ".html"), selfcontained = FALSE)
