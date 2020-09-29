# Librerias
library(leaflet)
library(sf)
library(tidyverse)

# Mapas
mapa <- st_read("ResultadosExtraordinaria2019PUE.geojson")
plot(mapa, max.plot = 1)
edo <-st_read("https://raw.githubusercontent.com/JuveCampos/MexicoSinIslas/master/Sin_islas.geojson") %>%  
  filter(ENTIDAD == "PUEBLA")

# Mapa 1. Ganador
paleta <- colorFactor(c("#439e3b", "#001885", "#d02a21"), mapa$Ganador)

leaflet(mapa, options = leafletOptions(zoomControl = FALSE)) %>% 
  addProviderTiles("CartoDB.Positron") %>% 
  addPolygons(highlightOptions = highlightOptions(color = "white"),
              color = "#444444", 
              weight = 0.5, 
              smoothFactor = 0.5, 
              opacity = 1, 
              fillOpacity = 0.8, 
              #dashArray = c("3,3"),
              fillColor = paleta(mapa$Ganador)) %>% 
  addScaleBar(position = "bottomright") %>%   
  addLegend(position = "bottomleft", 
            pal = paleta, 
            values = mapa$Ganador, 
            title = "Ganador a nivel Municipal<br>Elección extraordinaria en Puebla (2019)", 
            labFormat = labelFormat(prefix = ""))

# Mapa de ECS
ECS <- mapa %>% 
  mutate(ECS_pctje = (ECS/sum(ECS))*100) %>% 
  mutate(catPctje = case_when(ECS_pctje < 0.01 ~ "Menor al 0.01%", 
                              between(ECS_pctje, 0.01, 1) ~ "Entre 0.01% y 1%", 
                              between(ECS_pctje, 1, 3)    ~ "Entre 1% y 3%", 
                              between(ECS_pctje, 3, 5) ~ "Entre 3% y 5%", 
                              ECS_pctje > 5 ~ "45.19 % (PUEBLA)"
                              )) %>% 
  mutate(catPctje = factor(catPctje, levels = c("Menor al 0.01%","Entre 0.01% y 1%","Entre 1% y 3%","Entre 3% y 5%", "45.19 % (PUEBLA)")))

pal <- colorFactor(palette = "Blues", 
                  domain = ECS$catPctje, 
                  reverse = FALSE
                  )

leaflet(ECS, options = leafletOptions(zoomControl = FALSE)) %>% 
  addProviderTiles("CartoDB.Positron") %>% 
  addPolygons(fillColor = pal(ECS$catPctje), 
              color = "black", 
              label = lapply(paste0("Municipio: ", ECS$MUNICIPIO, "<br>",
                                    "<b>Aportación: </b>", formatC(ECS$ECS_pctje, 4), " %<br>"), htmltools::HTML),
              fillOpacity = 1,
              weight = 0.6) %>% 
  addPolygons(data = edo, fill = F, color = "black", weight = 2) %>% 
  addLegend(title = "Aportación de los municipios <br>al total de votos obtenidos <br>por Enrique Cárdenas (Coalición <br>PAN-PRD-MC) en la elección <br>Extraordinaria a Gobernador de <br>Puebla (MX) en 2019",
    pal = pal, values = ECS$catPctje, 
    position = "bottomright")

# Estados de Mexico en Mayusculas
estados <- c('AGUASCALIENTES',
             'BAJA CALIFORNIA',
             'BAJA CALIFORNIA SUR',
             'CAMPECHE',
             'CHIAPAS',
             'CHIHUAHUA',
             'CIUDAD DE MÉXICO',
             'COAHUILA DE ZARAGOZA',
             'COLIMA',
             'DURANGO',
             'GUANAJUATO',
             'GUERRERO',
             'HIDALGO',
             'JALISCO',
             'MÉXICO',
             'MICHOACÁN DE OCAMPO',
             'MORELOS',
             'NAYARIT',
             'NUEVO LEÓN',
             'OAXACA',
             'PUEBLA',
             'QUERÉTARO',
             'QUINTANA ROO',
             'SAN LUIS POTOSÍ',
             'SINALOA',
             'SONORA',
             'TABASCO',
             'TAMAULIPAS',
             'TLAXCALA',
             'VERACRUZ DE IGNACIO DE LA LLAVE',
             'YUCATÁN',
             'ZACATECAS')

# write.csv(estados, "Estados.csv", row.names = F)
  
