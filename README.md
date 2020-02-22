# 30DayMapChallenge2019
Repositorio de códigos de los mapas del #30DayMapChallenge

Durante el mes de Noviembre se realizó el primer #30DayMapChallenge, el cuál, como el inktober de los ilustradores y diseñadores graficos, consistió en un desafío para elaborar, a lo largo del mes, 1 mapa con una diferente temática por día. El reto organizado por de @tjukanov, y llevado a cabo por geógrafos, cartógrafos, científicos de datos y Datavizeros a lo largo del mundo. 

<blockquote class="twitter-tweet"><p lang="en" dir="ltr">Announcing <a href="https://twitter.com/hashtag/30DayMapChallenge?src=hash&amp;ref_src=twsrc%5Etfw">#30DayMapChallenge</a> in November 2019! Create a map each day of the month with the following themes 🌍🌎🌏<br><br>No restriction on tools. All maps should be created by you. Doing less than 30 maps is fine. <a href="https://twitter.com/hashtag/gischat?src=hash&amp;ref_src=twsrc%5Etfw">#gischat</a> <a href="https://twitter.com/hashtag/geography?src=hash&amp;ref_src=twsrc%5Etfw">#geography</a> <a href="https://twitter.com/hashtag/cartography?src=hash&amp;ref_src=twsrc%5Etfw">#cartography</a> <a href="https://twitter.com/hashtag/dataviz?src=hash&amp;ref_src=twsrc%5Etfw">#dataviz</a> <a href="https://t.co/6Go4VFWcJB">pic.twitter.com/6Go4VFWcJB</a></p>&mdash; Topi Tjukanov (@tjukanov) <a href="https://twitter.com/tjukanov/status/1187713840550744066?ref_src=twsrc%5Etfw">October 25, 2019</a></blockquote> 

## Temáticas. 

Las temáticas propuestas fueron las siguientes: 

![](https://raw.githubusercontent.com/JuveCampos/30DayMapChallenge2019/master/imagenesRepo30days/0.%20Tematicas.jpeg)

En el presente repositorio iré mostrando los mapas que fuí realizando para dicho evento. 

## Dia 5. Raster. 

Mapa de la Temperatura Máxima Promedio en los estados de la Frontera Norte de la República Mexicana. 

**Datos:** Uniatmos, UNAM. 

**Herramientas:** RStats {leaflet, magick}

![](https://github.com/JuveCampos/30DayMapChallenge2019/raw/master/imagenesRepo30days/05.%20Raster.gif)

## Dia 6. Azul (Blue).

Mapa que muestra la distribución de los votos obtenidos por el Candidato del PAN-coalición en las elecciones extraordinarias de Puebla del 2019. En este mapa se ve la excesiva concentración de votos en el municipio de Puebla, el cual concentró casi el 50% de los votos emitidos para este candidato.

**Datos:** Prep de las elecciones extraordinarias de Puebla, consultable en: https://prep2019-pue.ine.mx/publicacion/basedatos

**Herramientas:** RStats {leaflet}

![](https://raw.githubusercontent.com/JuveCampos/30DayMapChallenge2019/master/imagenesRepo30days/06.%20Blue.png)

## Dia 7. Rojo (Red). 

En este mapa mostramos el mapa de nombres del jitomate en las distintas entidades de la República Mexicana. 

**Datos:** RAE y sondeo con conocidos. 

**Herramientas:** RStats {Leaflet}.

![](https://raw.githubusercontent.com/JuveCampos/30DayMapChallenge2019/master/imagenesRepo30days/07.%20Red.png)

## Dia 8. Verde (Green). 

Mapa que muestra, por estado, la composición de la comunidad de estudiantes de Chapingo en el 2018. 

**Datos:** Anuario de Chapingo 2005-2018 

http://upom.chapingo.mx/Descargas/base_datos/acumuladas/BD_Alumnos_2005-2018.xlsx

**Herramientas:** RStats {ggplot2}.

![](https://raw.githubusercontent.com/JuveCampos/30DayMapChallenge2019/master/imagenesRepo30days/08.%20Green.jpeg)

## Dia 11. Elevación. 

Visualización de la elevación de la región de los Altos de Morelos, en el Estado de Morelos, abarcando los municipios de Yecapixtla, Tetela del Volcán, Ocuituco y Zacualpan de Amilpas, así como municipios del Estado de México (Ecatzingo) y Puebla (Tochimilco) próximos al volcán Popocatépetl, el cuál se aprecia como el punto más alto. 

**Datos:** Consulta del API del USGS en base a la función de @wcmbishop

**Herramientas:** RStats {raster, rayshader, magick}

![](https://github.com/JuveCampos/30DayMapChallenge2019/raw/master/imagenesRepo30days/11.%20Elevacion.gif)

## Dia 12. Movimiento (Movement). 

Elaboración de un “.gif de un trabajo realizado con datos de Ecoboci de la Ciudad de México. 

El trabajo original puede consultarse en http://appecobici.jjsantoso.com 

![](https://raw.githubusercontent.com/JuveCampos/30DayMapChallenge2019/master/imagenesRepo30days/12.%20Movement.gif)

## Dia 14. Límites (Boundaries)

En este mapa se muestra el código para hacer mapas de municipios con enclaves presentes dentro del conjunto de municipios de la República Mexicana. El código contiene una función para hacer highlight sobre un municipio, `x`, de interés. 

**Datos:** Municipios de México, 2010. 
http://www.conabio.gob.mx/informacion/gis/

**Herramienta:** RStats {leaflet}.

![](https://raw.githubusercontent.com/JuveCampos/30DayMapChallenge2019/master/imagenesRepo30days/14.%20Boundaries.png)

## Dia 15. Nombres (Names)

Nube de palabras (con un mapa de México) de las palabras mas utilizadas en los nombres de  los municipios de México. 

**Datos:** Municipios de México, 2018. 
http://www.conabio.gob.mx/informacion/gis/

**Herramienta:** RStats {tm, WordCloud2} y Keynote para post-producción.

![](https://raw.githubusercontent.com/JuveCampos/30DayMapChallenge2019/master/imagenesRepo30days/15.%20Names.jpeg)

## Día 17. Zonas (Zones)

Mapa de la zonificación geotécnica de la Ciudad de México. Esta zonificación está en función de las características y propiedades del suelo de la ciudad y de regiones circundantes del EdoMex. Estas características definen el comportamiento de este tipo de suelos ante sísmos y movimientos telúricos. 

**Datos:** Atlas de Riesgo de la Ciudad de México.

**Herramienta:** RStats {leaflet}.

![](https://raw.githubusercontent.com/JuveCampos/30DayMapChallenge2019/master/imagenesRepo30days/17.%20Zones.png)

## Dia 18. Globo (Globe). 

Shiny con visualización de globo a partir de Plotly.

Visitable (si sigue disponible) en la siguiente dirección: https://juvecampos.shinyapps.io/shinyAlcohol/

**Datos:**  Los datos de consumo de alcohol en mayores de 18 años por país del mundo provienen de https://ourworldindata.org/alcohol-consumption. 

**Herramienta:** RStats {plotly, shiny}

![](https://raw.githubusercontent.com/JuveCampos/30DayMapChallenge2019/master/imagenesRepo30days/18.%20Globe.jpeg)

## Dia 19. Urbano (Urban). 

Mapa de las rutas de transporte concecionado en la CDMX y los eventos de Robo a Pasajeros reportados por la ADIP en 2018 en las distintas rutas de transporte de la Ciudad. 

**Datos:**

1. _Rutas de transporte concesionado:_

https://datos.cdmx.gob.mx/explore/dataset/rutas-y-corredores-del-transporte-publico-concesionado/custom/

2. _Carpetas de investigación:_

https://datos.cdmx.gob.mx/explore/dataset/carpetas-de-investigacion-pgj-cdmx/custom/

**Herramientas:** RStats {leaflet}

![](https://raw.githubusercontent.com/JuveCampos/30DayMapChallenge2019/master/imagenesRepo30days/19.%20Urban.png)

## Dia 22. Ambiente Construido (Built Environment). 

**Herramientas:** RStats {leaflet}

Densidad de población en las zonas denominadas por el gobierno de la Ciudad de México como _"Suelo de conservación"_. Data de población proveniente de [humdata.org](https://data.humdata.org/dataset/mexico-high-resolution-population-density-maps-demographic-estimates) y _shapefile_ del suelo de conservación proveniente del Atlas de Riesgo de la Ciudad de México. 

![](https://raw.githubusercontent.com/JuveCampos/30DayMapChallenge2019/master/imagenesRepo30days/22.%20Built%20Environment.png)

## Dia 24. Estadísticas (Statistics). 

Mapa de diversas estadísticas e indicadores generados en el Laboratorio Nacional de Políticas Públicas, y publicadas con motivo de esta día del Challenge. La mayoría consta de tasas a nivel estatal de la información mencionada. 

**Datos:** Indicadores LNPP. 

**Herramienta:** RStats {leaflet, magick}.  

![](https://raw.githubusercontent.com/JuveCampos/30DayMapChallenge2019/master/imagenesRepo30days/24.%20Statistics.gif)


## Dia 25. Clima (Climate). 

Mapa donde se muestran los polígonos de las regiones de los climas bajo la clasificación de Köppen. 

**Datos:** INEGI. https://www.inegi.org.mx/temas/climatologia/

**Herramienta:** RStats {leaflet}.

![](https://raw.githubusercontent.com/JuveCampos/30DayMapChallenge2019/master/imagenesRepo30days/25.%20Climate.png)

## Dia 27. Recursos. (Resources). 

Mapa que muestra la situación de explotación de los acuíferos cercanos a la Ciudad de México y su zona metropolitana. 

**Datos:**  SINA-CONAGUA, Sección de Acuíferos.

http://sina.conagua.gob.mx/sina/tema.php?tema=acuiferos&ver=mapa&o=0&n=nacional

**Herramienta:** RStats {leaflet}.

![](https://raw.githubusercontent.com/JuveCampos/30DayMapChallenge2019/master/imagenesRepo30days/27.%20Resources.jpeg)


## Dia 28. Divertido (Funny). 

Mapa donde se muestra que el estado de San Luis Potosí tiene forma de perrito. 

**Aclaración:** Si parece un Scottish Terrier pero la verdad me gustan mas los Schnauzers y le ví más cara de Schnauzer que de la otra raza. (Sesgo de Schnauzer o _Schnauzer´s Bias_).

**Herramientas:** RStats {leaflet} con post-producción en Keynote (Apple).

![](https://raw.githubusercontent.com/JuveCampos/30DayMapChallenge2019/master/imagenesRepo30days/28.%20Funny.jpg)


