# libs ----
if(!require(terra)) {install.packages("terra"); require(terra)}
if(!require(tidyverse)) {install.packages("tidyverse"); require(tidyverse)}


# 10 m raster template ----
template10=rast("./Templates/TemplateRasters/LV10m_10km.tif")

# Fails as exported from GEE ----
faili=data.frame(fails=list.files("./Geodata/2024/S2indices/RAW/",pattern = ".tif"))
faili$celi_sakums=paste0("./Geodata/2024/S2indices/RAW/",faili$fails)


# file names ----
faili=faili %>% 
  separate(fails,into=c("nosaukums","vidus","beigas"),sep="-",remove = FALSE) %>% 
  mutate(mosaic_name=paste0("EO_",nosaukums,"-",beigas,tolower(vidus),".tif"),
         masaic_cels=paste0("./Geodata/2024/S2indices/Mosaics/",mosaic_name))


unikalie=levels(factor(faili$mosaic_name))
min(table(faili$mosaic_name))
max(table(faili$mosaic_name))

# preparation of mosaics ----
for(i in seq_along(unikalie)){
  sakums=Sys.time()
  unikalais=faili %>% filter(mosaic_name==unikalie[i])
  beigu_cels=unique(unikalais$masaic_cels)
  
  print(i)
  
  # there are exactly 2 tiles per file
  viens=rast(unikalais$celi_sakums[1])
  divi=rast(unikalais$celi_sakums[2])
  
  viens2=terra::project(viens,template10)
  divi2=terra::project(divi,template10)
  
  mozaika=terra::merge(viens2,divi2)
  maskets=mask(mozaika,template10,
               filename=beigu_cels,overwrite=TRUE,
               gdal=c("COMPRESS=LZW","TILED=YES","BIGTIFF=IF_SAFER"),
               datatype="FLT4S",
               NAflag=NA)
  
  plot(maskets,main=unikalie[i])
  print(beigu_cels)
  beigas=Sys.time()
  ilgums=beigas-sakums
  print(ilgums)
}
