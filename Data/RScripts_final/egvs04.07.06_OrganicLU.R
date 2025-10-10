# libs ----
if(!require(terra)) {install.packages("terra"); require(terra)}
if(!require(sf)) {install.packages("sf"); require(sf)}
if(!require(tidyverse)) {install.packages("tidyverse"); require(tidyverse)}

# Template ----
template10=rast("./Templates/TemplateRasters/LV10m_10km.tif")

# Organic Soils LU ----


kudra_norvegi=rast("./Geodata/2024/Soils/OrganicSoils_LU/YN_prognozes_smooth.tif")
kudra_norvLV=project(kudra_norvegi,template10)
plot(kudra_norvLV)

writeRaster(kudra_norvLV,
            "./RasterGrids_10m/2024/SoilTXT_OrganicLU.tif",
            overwrite=TRUE)

