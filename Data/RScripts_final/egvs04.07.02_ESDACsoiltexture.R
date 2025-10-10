# libs ----
if(!require(terra)) {install.packages("terra"); require(terra)}
if(!require(sf)) {install.packages("sf"); require(sf)}
if(!require(tidyverse)) {install.packages("tidyverse"); require(tidyverse)}

# Template ----
template10=rast("./Templates/TemplateRasters/LV10m_10km.tif")

# ESDAC texture ----

sdTEXT=rast("./Geodata/2024/Soils/ESDAC/texture/SoilDatabaseV2_raster/ESDB-Raster-Library-1k-GeoTIFF-20240507/TEXT/TEXT.tif")
plot(sdTEXT)

sdTEXT=project(sdTEXT,template10,method="near")
plot(sdTEXT)

sdTEXT=subst(sdTEXT,0,NA)
plot(sdTEXT)

sdTEXT2=mask(sdTEXT,template10,
             filename="./RasterGrids_10m/2024/SoilTXT_ESDAC.tif",
             overwrite=TRUE)
plot(sdTEXT2)
