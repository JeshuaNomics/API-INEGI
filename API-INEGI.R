# API-INEGI
install.packages("httr")
library(httr)
install.packages("jsonlite")
library(jsonlite)
install.packages("rjson")
library(rjson)
install.packages("plotly")
library(plotly)

# URL API de INEGI
# https://www.inegi.org.mx/servicios/api_indicadores.html#indicadorI

# URL estandar:
# https://www.inegi.org.mx/app/api/indicadores/desarrolladores/jsonxml/INDICATOR/[IdIndicador]/[Idioma]/[Área Geográfica]/[Recientes]/[Fuente de datos]/[Versión][Token]?type=[Formato]

# Partes de la URL:
# https://www.inegi.org.mx/app/api/indicadores/desarrolladores/jsonxml/INDICATOR/
# [IdIndicador]/ -  Seleccionar el indicador e identificar su clave.
# [Idioma]/ -  Seleccionar el idioma como español [es] o inglés [en].
# [Área Geográfica]/ - Seleccionar nacional [00], entidad federativa [99] o municipal [999].
# [Recientes]/ - Seleccionar el dato más reciente [true] o la serie histórica completa [false].
# [Fuente de datos]/ - Seleccionar la fuente de diseminación [BISE] o [BIE].
# Banco de Información Económica (BIE).
# Banco de Indicadores Sociodemográficos y Económicos (BISE).
# [Versión] - Seleccionar la edición [2.0] del servicio de provisión de datos.
# [Token] - https://www.inegi.org.mx/app/desarrolladores/generatoken/Usuarios/token_Verify
# ?type=[Formato] - Seleccionar: JSON [json], JSONP [jsonp] o XML [xml].

# Llamando a la API
URL <- "https://www.inegi.org.mx/app/api/indicadores/desarrolladores/jsonxml/INDICATOR/494782/es/0700/false/BIE/2.0/[Token]?type=json"

# Opción 1 para convertir en cadenas
Respuesta <- GET(URL)
Flujo_de_datos <- rawToChar(Respuesta$content)

# Opción 2 para convertir en cadenas
Respuesta <- GET(URL)
Datos_generales <- content(Respuesta, "text")
Flujo_de_datos <- paste(Datos_generales, collapse = " ")

# Obtención de la lista de observaciones 
Flujo_de_datos <- fromJSON(Flujo_de_datos)
Flujo_de_datos <- Flujo_de_datos$Series
Flujo_de_datos <- Flujo_de_datos[[1]]$OBSERVATIONS

# Generación del marco de datos
Datos <- 0;
for (i in 1:length(Flujo_de_datos)){
  Datos[i]<-Flujo_de_datos[[i]]$OBS_VALUE
}
Datos <- as.numeric(Datos)
Marco_de_datos <- data.frame(Datos)

# Promedio de las observaciones
print(mean(Marco_de_datos$Datos))