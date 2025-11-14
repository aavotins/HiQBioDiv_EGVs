# libs ----
if(!require(terra)) {install.packages("terra"); require(terra)}
if(!require(sf)) {install.packages("sf"); require(sf)}
if(!require(tidyverse)) {install.packages("tidyverse"); require(tidyverse)}

# Template ----
template10=rast("./Templates/TemplateRasters/LV10m_10km.tif")

# Farmland soil texture ----

augsnes=st_read("./Geodata/2024/Soils/TopSoil_LV/soil.gpkg",layer="soilunion")

# calculate parcels area
augsnes$platiba_ha=as.numeric(st_area(augsnes))/10000

# only parcels with existing information on texture
tuksas=augsnes %>% 
  filter(GrSast=="")

# classification
clay=c("M","M1","Mp","M2","sM1","sMp1")
silt=c("sM", "sMp", "sM2", "sMp2", "sM3", "sMp3")
sand=c("mS", "mSp", "S", "sS", "iS", "Gr", "mGr", "D")
peat=c("l", "vd", "vj", "n","T")
augsnes=augsnes %>% 
  mutate(grupas=case_when(GrSast %in% sand~"Sand",
                          GrSast %in% silt~"Silt",
                          GrSast %in% clay~"Clay",
                          GrSast %in% peat~"organika",
                          .default=NA)) %>% 
  mutate(grupas_num=case_when(GrSast %in% sand~"1",
                              GrSast %in% silt~"2",
                              GrSast %in% clay~"3",
                              GrSast %in% peat~"4",
                              .default=NA))

# crs
augsnes_3059=st_transform(augsnes,crs=3059)

# only existing texture classification
augsnes_3059=augsnes_3059 %>% 
  filter(!is.na(grupas_num))

# parcels up to 200 ha
augsnes_3059small=augsnes_3059 %>% 
  filter(!is.na(grupas_num)) %>% 
  filter(platiba_ha<200)

# rasterization
virsaugsnem2=rasterize(augsnes_3059small,template10,field="grupas_num",fun="max",
                       filename="./RasterGrids_10m/2024/SoilTXT_topSoilLV.tif",
                       overwrite=TRUE)
plot(virsaugsnem2)

