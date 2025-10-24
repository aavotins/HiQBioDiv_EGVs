# libs ----
if(!require(terra)) {install.packages("terra"); require(terra)}
if(!require(tidyverse)) {install.packages("tidyverse"); require(tidyverse)}
if(!require(readxl)) {install.packages("readxl"); require(readxl)}
if(!require(openxlsx)) {install.packages("openxlsx"); require(openxlsx)}


# planned names ----
nosaukumiem=read_excel("./RasterGrids_100m/2024/HiQBioDiv_EGVnosaukumi_20250831.xlsx")
nosaukumiem=nosaukumiem %>% 
  mutate(egv_filename=new_filename,
         egv_layername=new_layername,
         egv_radius=radius,
         egv_mean=NA,
         egv_rms=NA) %>% 
  dplyr::select(egv_filename,egv_layername,egv_radius,
                longname_english,longname_latvian,suggested_updating,
                egv_mean,egv_rms)


# standartization -----

for(i in seq_along(nosaukumiem$egv_filename)){
  sakums=Sys.time()
  print(i)
  nosaukums=nosaukumiem$egv_filename[i]
  print(nosaukums)
  ielasisanas_cels=paste0("./RasterGrids_100m/2024/RAW/",nosaukums)
  saglabasanas_cels=paste0("./RasterGrids_100m/2024/Scaled/",nosaukums)
  
  slanis=rast(ielasisanas_cels)
  
  videjais=global(slanis,fun="mean",na.rm=TRUE)
  centrets=slanis-videjais[,1]
  standartnovirze=terra::global(centrets,fun="rms",na.rm=TRUE)
  merogots=centrets/standartnovirze[,1]
  nosaukumiem$egv_mean[i]=videjais
  nosaukumiem$egv_rms[i]=standartnovirze
  writeRaster(merogots,
              filename=saglabasanas_cels,
              overwrite=TRUE)
  beigas=Sys.time()
  ilgums=beigas-sakums
  print(ilgums)
  
}


# documentation ----

## excel ----
field_column=names(nosaukumiem)
description_column=c("File name of the standartized ecogeographical variable",
                     "Layer name of the standartized ecogeographical variable",
                     "Scale: 0 = 1ha, other values denote radius around the center of 1 ha cells",
                     "Long name of the ecogeographical variable in English",
                     "Long name of the ecogeographical variable in Latvian",
                     "Sugested updating to reproject SDMs",
                     "Value used for centering",
                     "Value used for scaling")

lauku_apraksti=data.frame(Field=field_column,
                          Description=description_column)

lapam=list("EGVs"=nosaukumiem,
           "README"=lauku_apraksti)

write.xlsx(lapam,
           "./RasterGrids_100m/2024/HiQBioDiv_EGVs_2024.xlsx")

## csv ----
write_excel_csv(nosaukumiem,"./RasterGrids_100m/2024/HiQBioDiv_EGVs_2024.csv")
write_excel_csv(lauku_apraksti,"./RasterGrids_100m/2024/HiQBioDiv_EGVs_2024_README.csv")




