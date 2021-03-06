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
# https://www.inegi.org.mx/app/api/indicadores/desarrolladores/jsonxml/INDICATOR/[IdIndicador]/[Idioma]/[�rea Geogr�fica]/[Recientes]/[Fuente de datos]/[Versi�n][Token]?type=[Formato]

# Partes de la URL:
# https://www.inegi.org.mx/app/api/indicadores/desarrolladores/jsonxml/INDICATOR/
# [IdIndicador]/ -  Seleccionar el indicador e identificar su clave.
# [Idioma]/ -  Seleccionar el idioma como espa�ol [es] o ingl�s [en].
# [�rea Geogr�fica]/ - Seleccionar nacional [00], entidad federativa [99] o municipal [999].
# [Recientes]/ - Seleccionar el dato m�s reciente [true] o la serie hist�rica completa [false].
# [Fuente de datos]/ - Seleccionar la fuente de diseminaci�n [BISE] o [BIE].
# Banco de Informaci�n Econ�mica (BIE).
# Banco de Indicadores Sociodemogr�ficos y Econ�micos (BISE).
# [Versi�n] - Seleccionar la edici�n [2.0] del servicio de provisi�n de datos.
# [Token] - https://www.inegi.org.mx/app/desarrolladores/generatoken/Usuarios/token_Verify
# ?type=[Formato] - Seleccionar: JSON [json], JSONP [jsonp] o XML [xml].

# Llamando a la API
URL <- "https://www.inegi.org.mx/app/api/indicadores/desarrolladores/jsonxml/INDICATOR/494782/es/0700/false/BIE/2.0/[Token]?type=json"

# Opci�n 1 para convertir en cadenas
Respuesta <- GET(URL)
Flujo_de_datos <- rawToChar(Respuesta$content)

# Opci�n 2 para convertir en cadenas
Respuesta <- GET(URL)
Datos_generales <- content(Respuesta, "text")
Flujo_de_datos <- paste(Datos_generales, collapse = " ")

# Obtenci�n de la lista de observaciones 
Flujo_de_datos <- fromJSON(Flujo_de_datos)
Flujo_de_datos <- Flujo_de_datos$Series
Flujo_de_datos <- Flujo_de_datos[[1]]$OBSERVATIONS

# Generaci�n del marco de datos
Datos <- 0;
for (i in 1:length(Flujo_de_datos)){
  Datos[i]<-Flujo_de_datos[[i]]$OBS_VALUE
}
Datos <- as.numeric(Datos)
Marco_de_datos <- data.frame(Datos)

# Promedio de las observaciones
print(mean(Marco_de_datos$Datos))