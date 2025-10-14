# libs ----
if(!require(terra)) {install.packages("terra"); require(terra)}
if(!require(sf)) {install.packages("sf"); require(sf)}
if(!require(sfarrow)) {install.packages("sfarrow"); require(sfarrow)}
if(!require(tidyverse)) {install.packages("tidyverse"); require(tidyverse)}

# templates ----
template100=rast("./Templates/TemplateRasters/LV100m_10km.tif")
tikls1km=sfarrow::st_read_parquet("./Templates/TemplateGrids/tikls1km_sauzeme.parquet")

# reading HydroClim ----
videjie=terra::rast("./Geodata/2024/HydroClim/hydroclim_average+sum.nc")

# reading dictionary -----
slanu_nosaukumi=read_csv("./Geodata/2024/HydroClim/HydroClim_renaming.csv")

# cropping ---
tikls1km_reproj=st_transform(tikls1km,crs=st_crs(videjie))
telpai=tikls1km %>% 
  mutate(yes=1) %>% 
  summarise(yes=max(yes)) %>% 
  st_buffer(.,dist=10000) %>% 
  st_transform(.,crs=st_crs(videjie))
videjie=terra::crop(videjie,telpai)

# layer names ----
names(videjie)=slanu_nosaukumi$local_name

# saving files ----
for(i in seq_along(slanu_nosaukumi$local_name)){
  nosaukumam=slanu_nosaukumi$local_name[i]
  writeRaster(videjie[[i]],
              paste0("./Geodata/2024/HydroClim/",nosaukumam),
              overwrite=TRUE)
}
