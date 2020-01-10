library(sf)
library(tidyverse)

# # Creamos lista de nombres de municipios 
# muni <- st_read("/Users/admin/Desktop/Proyectos/BBVAHackaton/01\ Datos/muni_2018gw/muni_2018gw.shp") 
# nombres <- muni$NOM_MUN
# saveRDS(nombres, "nombresMunicipios.rds")

# Abrimos nombres de municipios.
nombres <- readRDS("nombresMunicipios.rds") %>% 
  as.character()

##--- Funcion para crear el wordcloud
create_wordcloud <- function(data, stop_words = c(), num_words = 100, background = "white",  mask = NULL) {
  # Checar si esta instalado Pacman
  if (!require("pacman")) install.packages("pacman")
  pacman::p_load(wordcloud2, tm, stringr)
  
  # Pre-Función para eliminar simbolos raros
  quitar_signos <- function(x)  stringr::str_remove_all(x, pattern = rebus::char_class("¿¡"))
  
  # If text is provided, convert it to a dataframe of word frequencies
  # Si se provee el texto, convertirlo a un dataframe de frecuencia de palabras 
  if (is.character(data)) {
    # Convertimos a Corpus
    corpus <- Corpus(VectorSource(data))
    # Convertimos el texto dentro del Corpus a Minusculas
    corpus <- tm_map(corpus, tolower)
    # Removemos la puntuacion (.,-!?)
    corpus <- tm_map(corpus, removePunctuation)
    # Removemos los numeros
    corpus <- tm_map(corpus, removeNumbers)
    # Removemos los signos de admiracion e interrogacion al reves
    corpus <- tm_map(corpus, quitar_signos)    
    # Removemos las stopwords (palabras muy muy comunes que se usan para dar coherencia
    # a las oraciones. Para saber cuales, escribir: stopwords("spanish))
    corpus <- tm_map(corpus, removeWords, c(stopwords("spanish"), stop_words))
    # Generamos una matriz para hacer el conteo
    tdm <- as.matrix(TermDocumentMatrix(corpus))
    # Obtenemos el numero de la frecuencia de cada palabra
    data <- sort(rowSums(tdm), decreasing = TRUE)
    # Generamos una tabla con la palabra en una columna y su frecuencia de uso en otra 
    data <- data.frame(word = names(data), freq = as.numeric(data))
  }
  
  freq_palabras <<- data
  
  # WARNING! Parche para bajarle a la primera palabra #
  data[1,2] <- data[2,2]
  
  # Make sure a proper num_words is provided
  # Nos aseguramos que un numero adecuado de palabras `num_provider` es generado`
  if (!is.numeric(num_words) || num_words < 3) {
    num_words <- 3
  }  
  
  # Grab the top n most common words
  # Recortamos la base de datos de palabras a un numero `n` especificado
  data <- head(data, n = num_words)
  if (nrow(data) == 0) {
    return(NULL)
  }
  
  wordcloud2(data, backgroundColor = background, figPath = mask,  color = "random-light",  fontFamily = 'GMX Serif Boald', size = 1.5) 
}

##--- Creamos el WordCloud
create_wordcloud(nombres, background = "black", num_words = 500)

##-- POSTERIORMENTE PANTALLEAMOS EL WC Y LO PASAMOS A POST-PRODUCCION 