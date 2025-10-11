# libs
if(!require(sf)) {install.packages("sf"); require(sf)}
if(!require(arrow)) {install.packages("arrow"); require(arrow)}
if(!require(sfarrow)) {install.packages("sfarrow"); require(sfarrow)}
if(!require(gdalUtilities)) {install.packages("gdalUtilities"); require(gdalUtilities)}

# database
nog=read_sf("./Geodata/2024/MVR/VMD.gdb/",layer="Nogabali_pilna_datubaze")

# ensuring geometries
source("./RScripts_final/egvs02.02_UtilityFunctions.R")
nogabali <- ensure_multipolygons(nog)

# securing geometries
nogabali2 = nogabali[!st_is_empty(nogabali),,drop=FALSE] # 108 tukšas ģeometrijas
validity=st_is_valid(nogabali2) 
table(validity) # 1733 invalid ģeometrijas
nogabali3=st_make_valid(nogabali2)

# transforming CRS
nogabali4=st_transform(nogabali3, crs=3059)

# saving
sfarrow::st_write_parquet(nogabali4, "./Geodata/2024/MVR/nogabali_2024janv.parquet")
