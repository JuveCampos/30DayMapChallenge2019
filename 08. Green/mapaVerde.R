# Este mapa es continuacion del codigo visto en clase.  #
# Hay que correr ese primero, o esto no va a funcionar  #

# Librerias
library(sf)
library(stringr)
library(rebus)
library(viridis)
library(readxl)


# Bases de Datos
bd <- read_xlsx("anuarioChapingo.xlsx") %>% 
  clean_names()

# Creamos y guardamos la base de datos. 
bd_plot <- bd %>% 
  filter(ano == 2018) %>% 
  group_by(estado_de_nacimiento) %>% 
  summarise(num_alumnos2 = sum(num_alumnos)) %>% 
  ungroup() %>% 
  filter(estado_de_nacimiento != "EXTRANJERO") 


# Tema de mi mapa de ggplot
theme_map <- function(...) {
  theme_minimal() +
    theme(
      # Nota! Instalen esta fuente primero!!
      text = element_text(family = "Asap-Bold", color = "#22211d"),
      axis.line = element_blank(),
      axis.text.x = element_blank(),
      axis.text.y = element_blank(),
      axis.ticks = element_blank(),
      axis.title.x = element_blank(),
      axis.title.y = element_blank(),
      # panel.grid.minor = element_line(color = "#ebebe5", size = 0.2),
      panel.grid.major = element_line(color = "#ebebe5", size = 0.2),
      panel.grid.minor = element_blank(),
      plot.background = element_rect(fill = "white", color = NA), 
      panel.background = element_rect(fill = "#e0fffc", color = NA), 
      legend.background = element_rect(fill = "white", color = NA),
      panel.border = element_blank(),
      plot.title = element_text(hjust = 0.5, size = 24, color = "#419067"), 
      plot.subtitle = element_text(hjust = 0.5, size = 20),
      ...
    )
}

# Modificamos un poquito la base del laboratorio
bd_plot <- bd_plot %>% 
  rename(Alumnos = num_alumnos2) %>% 
  mutate(pctje = (Alumnos/sum(Alumnos)) * 100) %>% 
  print(n = Inf)


# Mapa Verde
bd_plot$Alumnos %>% 
  as.factor() %>% 
  levels()

# Leemos el archivo *.geojson que contiene el mapa base (los estados)
edo <-st_read("https://raw.githubusercontent.com/JuveCampos/MexicoSinIslas/master/Sin_islas.geojson") 

# En estas lineas, comprobamos que los nombres de los estados 
# en ambas bases sean los mismos!!! IMPORTANTE!! 

bd_plot$estado_de_nacimiento %in% edo$ENTIDAD
bd_plot$estado_de_nacimiento[which(!(bd_plot$estado_de_nacimiento %in% edo$ENTIDAD))]

# Aqui cambiamos los nombres con la funcion stringr::str_replace()
bd_plot$estado_de_nacimiento <- bd_plot$estado_de_nacimiento %>% 
  str_replace_all(c("COAHUILA" = "COAHUILA DE ZARAGOZA", 
                    #"MÉXICO" = "MEXICO",
                    "MICHOACÁN" = "MICHOACAN DE OCAMPO",
                    "NUEVO LEÓN" = "NUEVO LEON",
                    "QUERÉTARO" = "QUERETARO DE ARTEAGA",
                    "SAN LUIS POTOSÍ" = "SAN LUIS POTOSI",
                    "VERACRUZ" = "VERACRUZ DE IGNACIO DE LA LLAVE",
                    "YUCATÁN" = "YUCATAN"
                    ))

# Seguimos cambiando nombres
bd_plot$estado_de_nacimiento <- str_replace(bd_plot$estado_de_nacimiento, 
                                            pattern = exactly("MÉXICO"), 
                                            replacement = "MEXICO")
# Comprobamos que sean los mismos nombres
bd_plot$estado_de_nacimiento[which(!(bd_plot$estado_de_nacimiento %in% edo$ENTIDAD))]

# Mergeamos la base (pegamos el mapa base y los datos de la clase)
mapa <- merge(edo, bd_plot, by.y = "estado_de_nacimiento", 
      by.x = "ENTIDAD"
      )
class(mapa)

# Mapa. 
# No se ofusquen si no le entienden a todo... 
# La mayoria es codigo que copipegué de internet

# Generamos los breaks de la leyenda
pretty_breaks <- c(1, 50, 100, 500, 1000, 1500, 2000)

# Valor minimo
minVal <- min(mapa$Alumnos, na.rm = T)
# Valor maximo
maxVal <- max(mapa$Alumnos, na.rm = T)

# compute labels
labels <- c()
brks <- c(minVal, pretty_breaks, maxVal)
# round the labels (actually, only the extremes)
for(idx in 1:length(brks)){
  labels <- c(labels,round(brks[idx + 1], 2))
}
labels <- labels[1:length(labels)-1]

# define a new variable on the data set just as above
mapa$brks <- cut(mapa$Alumnos, 
                     breaks = brks, 
                     include.lowest = TRUE, 
                     labels = labels)
brks_scale <- levels(mapa$brks)
labels_scale <- rev(brks_scale)

# Ahora si, hacemos el mapa. 
mapa %>% 
  ggplot(aes(fill = brks)) +
  geom_sf(color = "white") + 
  #scale_fill_distiller(palette = "Greens", direction = 1) + 
  theme_map() +
  theme(legend.position = "bottom") + 
  labs(title = "Universidad Autónoma Chapingo", 
       subtitle = "Alumnos por Entidad Federativa, 2018", 
       # tag  = "Alumnos: ",
       caption = "Fuente: http://upom.chapingo.mx/Descargas/base_datos/acumuladas/BD_Alumnos_2005-2018.xlsx") + 
  scale_fill_manual(
    # in manual scales, one has to define colors, well, manually
    # I can directly access them using viridis' magma-function
    values = rev(viridis(length(brks))),
    breaks = rev(brks_scale),
    name = "No. de Alumnos",
    drop = FALSE,
    labels = labels_scale,
    guide = guide_legend(
      direction = "horizontal",
      keyheight = unit(2, units = "mm"),
      keywidth = unit(70 / length(labels), units = "mm"),
      title.position = 'top',
      # I shift the labels around, the should be placed 
      # exactly at the right end of each legend key
      title.hjust = 0.5,
      label.hjust = 1,
      nrow = 1,
      byrow = T,
      # also the guide needs to be reversed
      reverse = T,
      label.position = "bottom"
    )
  )  

