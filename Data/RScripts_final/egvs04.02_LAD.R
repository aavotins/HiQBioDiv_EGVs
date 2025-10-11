# libs
if(!require(sf)) {install.packages("sf"); require(sf)}
if(!require(arrow)) {install.packages("arrow"); require(arrow)}
if(!require(sfarrow)) {install.packages("sfarrow"); require(sfarrow)}
if(!require(gdalUtilities)) {install.packages("gdalUtilities"); require(gdalUtilities)}

# reading all files
faili=data.frame(celi=list.files("./Geodata/2024/LAD/downloads",full.names = TRUE))
dati=st_read(faili$celi[1])
for(i in 2:length(faili$celi)){
  nakosais=st_read(faili$celi[i])
  dati=bind_rows(dati,nakosais)
  print(nrow(dati))
}

# ensuring geometries
source("./RScripts_final/egvs02.02_UtilityFunctions.R")
nogabali <- ensure_multipolygons(nog)
dati2 <- ensure_multipolygons(dati)
dati3 = dati2[!st_is_empty(dati2),,drop=FALSE] # viss kārtībā
table(st_is_valid(dati3)) 
dati4=st_make_valid(dati3)
table(st_is_valid(dati4))
dati5 <- ensure_multipolygons(dati4)
table(st_is_valid(dati5))

# saving output
st_write(dati5,"./Geodata/2024/LAD/Lauki_2024.gpkg",append = FALSE)
sfarrow::st_write_parquet(dati5,"./Geodata/2024/LAD/Lauki_2024.parquet")

# unlinking downloads
for(i in seq_along(faili$celi)){
  unlink(faili$celi[i])
}
rm(list=ls())