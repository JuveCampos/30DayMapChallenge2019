#####################################################################
# Mapa Raster                                                       #
# Temperaturas extremas del Norte de México.                        #
# Datos provenientes de http://atlasclimatico.unam.mx/atlas/kml/    #
# Jorge Juvenal Campos Ferreira                                     #
#####################################################################

# Librerias
library(sf)
library(raster)
library(tidyverse)
library(leaflet)
library(webshot)
library(htmlwidgets)

# Leemos estados
edos <- st_read("https://github.com/JuveCampos/MexicoSinIslas/raw/master/Sin_islas.geojson")

# Filtramos para quedarnos con los estados del Norte de México (Donde hace más calor)
edos_norte <- edos %>% 
  filter(ENTIDAD %in% c("BAJA CALIFORNIA", 
                        "CHIHUAHUA", 
                        "COAHUILA DE ZARAGOZA", 
                        "NUEVO LEON", 
                        "TAMAULIPAS", 
                        "SONORA"
                        ))

# Vector de Meses
meses <- c("Enero","Febrero", 
           "Marzo","Abril", 
           "Mayo","Junio", 
           "Julio","Agosto", 
           "Septiembre","Octubre", 
           "Noviembre","Diciembre")

# Descarga de Archivos
sapply(1:12, function(x) {
  curl::curl_download(paste0("http://uniatmos.atmosfera.unam.mx/atlas/datosZip/tmax_30s/tmax_", x, ".zip"), 
                      destfile = paste0("01_Datos/tmax_", x, ".zip")
                      )
})

# Descomprimiendo los zips
sapply(1:12, function(x) {
  unzip(paste0("01_Datos/tmax_", x, ".zip"),exdir = paste0("01_Datos/tmax_", x))
})

# Haciendo los mapas
for (i in 1:12){

    tip <- paste0("01_Datos/tmax_", i, "/tmax_", i, "/tmax_", i, "/Geotiff/tmax_", i, ".tif")
    r <- raster(tip)
    
    # Convert edos_norte to a Spatial object
    edos_norteSp <- as(edos_norte, "Spatial")
    
    # Mask the temperature layer with edos_norte and save as norte_mask
    norte_mask <- mask(r, mask = edos_norteSp)
    
    # Crop norte_mask with edos_norte #
    norte_crop <- crop(norte_mask, edos_norteSp)
    
    # Creamos paleta de colores #
    pal <- colorNumeric(palette = "magma", domain = values(r), 
                        na.color = "transparent", reverse = FALSE)
    
    # Creamos mapa en Leaflet #
    (m <- leaflet(options = leafletOptions(zoomControl = FALSE)) %>% 
      addTiles() %>% 
      addRasterImage(norte_crop, 
                     colors = pal, 
                     opacity = 0.9
                     ) %>% addLegend(pal = pal, values = values(r),
                      title = paste0("<b style = 'color: #c26400;'>Temperatura<br>Máxima registrada<br>", meses[i], "</b>"),
                      position = "bottomright",
                      labFormat = labelFormat(suffix = "°C"))  )
    
    ## save html to png
    saveWidget(m, paste0(meses[i], "_temp.html"), selfcontained = FALSE)
    webshot(paste0(meses[i], "_temp.html"), file = paste0("03_Graficas/", meses[i], ".png"),
            cliprect = "viewport")
    print(paste0("Listo: mes ", meses[i]))

}


# Elaboracion del *.gif
library(magick)
list.files("03_Graficas/", pattern = "*.png", full.names = T)[c(4,5,8,1,9,7,6,2,12,11,10,3)] %>% 
  map(image_read) %>% # lee cada archivo de imagen
  image_join() %>% # junta las imagenes
  image_animate(fps=2) %>% # animates, can opt for number of loops
  image_write("5 Raster.gif") # guarda en el directorio actual


