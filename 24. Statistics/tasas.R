library(htmlwidgets)
library(webshot)
pacman::p_load(sf, tidyverse, leaflet, stringr, rebus)
niveles <- function(x) levels(as.factor(x))

# readxl::read_xlsx("BaseAguascalientes.xlsx")%>%
#   filter(indicador %in% tasa) %>%
#   filter(proyec != 1) %>%
#   #filter(year == max(year)) %>%
#   write.csv("Datos.csv")

datos <- 
  #readxl::read_xlsx("BaseAguascalientes.xlsx") 
   read_csv("Datos.csv")

mapa <- st_read("https://github.com/JuveCampos/MexicoSinIslas/raw/master/Sin_islas.geojson") %>% 
  mutate(estado = str_replace_all(string = ENTIDAD, c("MICHOACAN DE OCAMPO" = "MICHOACÁN", 
                                    "QUERETARO DE ARTEAGA" = "QUERÉTARO",
                                    "VERACRUZ DE IGNACIO DE LA LLAVE" = "VERACRUZ", 
                                    "COAHUILA DE ZARAGOZA" =   "COAHUILA", 
                                    "YUCATAN"    =         "YUCATÁN" ,
                                    "MEXICO"    =          "MÉXICO"  , 
                                    "SAN LUIS POTOSI"   =  "SAN LUIS POTOSÍ" , 
                                    "NUEVO LEON"     =     "NUEVO LEÓN"    
                                    )))




tasa <- c("Tasa de suicidios" ,
"Tasa de mortalidad infantil"  ,
"Tasa de homicidios por cada 100 mil habitantes" ,
"Tasa de fecundidad en mujeres de 15 a 19 años" ,   
"Tasa de cajeros automáticos por cada 100,000 habitantes" )

unidades <- c(
  " por cada 100,000 habitantes",
  " defunciones de menores de 1 año por cada mil nacidos vivos",
  " por cada 100 mil habitantes",
  " por cada 1,000 mujeres", 
  " por cada 100,000 habitantes"
  )

color <- c("BuPu", 
"Blues",
"YlOrRd",
"Oranges",
"Greens"
)


for (i in 1:5){
#i <- 1
ods <- datos %>% 
  filter(indicador == tasa[i]) %>% 
  filter(proyec != 1) %>% 
  filter(year == max(year)) %>% 
  mutate(estado = toupper(ent)) %>% 
  filter(ent != "Nacional")

map <- merge(mapa, ods, by = "estado")

pal <- colorNumeric(palette = color[i], 
                    domain = map$valor
                    )

leaflet(map, options = leafletOptions(zoomControl = F)) %>% 
  addProviderTiles("CartoDB.Positron") %>% 
  addPolygons(fillColor = pal(map$valor), 
              color = "black", 
              weight = 1, 
              fillOpacity = 0.9,
              label = map$valor
             ) %>% 
  addLegend(title = paste0(first(map$indicador), " ", first(map$year)), 
            pal = pal, 
            values = map$valor, 
            labFormat = labelFormat(suffix = unidades[i]), 
            position = "bottomleft"
            ) -> m

## save html to png
saveWidget(m, "temp.html", selfcontained = FALSE)
webshot("temp.html", file = paste0(tasa[i], ".png"),
        cliprect = "viewport")
}
  

# Elaboracion del *.gif
library(magick)
list.files(pattern = "*.png", full.names = T) %>% 
  map(image_read) %>% # reads each path file
  image_join() %>% # joins image
  image_animate(fps=0.5) %>% # animates, can opt for number of loops
  image_write("ndwi_aug_hgm.gif") # write to current dir

