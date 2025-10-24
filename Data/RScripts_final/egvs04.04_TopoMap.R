# libs ----
if(!require(sf)) {install.packages("sf"); require(sf)}
if(!require(openxlsx)) {install.packages("openxlsx"); require(openxlsx)}
if(!require(tidyverse)) {install.packages("tidyverse"); require(tidyverse)}

# v4 ----


slani_v4=st_layers("./Geodata/2024/TopographicMap/Latvija_LKS92_v4_20250703.gdb/")
write.xlsx(slani_v4,"./Geodata/2024/TopographicMap/slani_v4partial.xlsx")

slani_v4$geometrijai=as.character(slani_v4$geomtype)
table(slani_v4$geometrijai)

slani_v4$geometrijai2=ifelse(slani_v4$geometrijai=="3D Point","POINT",
                                   ifelse(slani_v4$geometrijai=="Multi Polygon","MULTIPOLYGON",
                                          ifelse(slani_v4$geometrijai=="3D Multi Line String","MULTILINESTRING",
                                                 ifelse(slani_v4$geometrijai=="3D Multi Polygon","MULTIPOLYGON",NA))))

slani4x=data.frame(name=slani_v4$name,
                   geometrija=slani_v4$geometrijai2)

ciklam4x=levels(factor(slani4x$name))
for(i in seq_along(ciklam4x)){
  print(i)
  sakums=Sys.time()
  nosaukums=ciklam4x[i]
  objekts=slani4x %>% 
    filter(name==nosaukums)
  print(nosaukums)
  slanis=read_sf("./Geodata/2024/TopographicMap/topo10v4/Latvija_LKS92_v4_20250703.gdb/",layer=nosaukums)
  slanisZM=st_zm(slanis)
  slanis2=st_cast(slanisZM,to=objekts$geometrija)
  write_sf(slanis2,"./Geodata/2024/TopographicMap/LGIAtopo10K_v4partial.gpkg",layer=nosaukums,append=FALSE)
  ilgums=Sys.time()-sakums
  print(ilgums)
}



# v3 ----

slani_v3=st_layers("./Geodata/2024/TopographicMap/Latvija_LKS92_v3_pilnais.gdb/")
write.xlsx(slani_v3,"./Geodata/2024/TopographicMap/slani_v3.xlsx")

slani_v3$geometrijai=as.character(slani_v3$geomtype)
table(slani_v3$geometrijai)

slani_v3$geometrijai2=ifelse(slani_v3$geometrijai=="3D Point","POINT",
                                   ifelse(slani_v3$geometrijai=="Multi Polygon","MULTIPOLYGON",
                                          ifelse(slani_v3$geometrijai=="3D Multi Line String","MULTILINESTRING",
                                                 ifelse(slani_v3$geometrijai=="3D Multi Polygon","MULTIPOLYGON",
                                                        ifelse(slani_v3$geometrijai=="Point","POINT",
                                                               ifelse(slani_v3$geometrijai=="Multi Line String","MULTILINESTRING",
                                                                      ifelse(slani_v3$geometrijai=="3D Measured Point","POINT",NA)))))))

slani3x=data.frame(name=slani_v3$name,
                   geometrija=slani_v3$geometrijai2)

ciklam3x=levels(factor(slani3x$name))
for(i in seq_along(ciklam3x)){
  print(i)
  sakums=Sys.time()
  nosaukums=ciklam3x[i]
  objekts=slani3x %>% 
    filter(name==nosaukums)
  print(nosaukums)
  slanis=read_sf("./Geodata/2024/TopographicMap/Latvija_LKS92_v3_pilnais.gdb/",layer=nosaukums)
  slanisZM=st_zm(slanis)
  slanis2=st_cast(slanisZM,to=objekts$geometrija)
  write_sf(slanis2,"./Geodata/2024/TopographicMap/LGIAtopo10K_v3.gpkg",layer=nosaukums,append=FALSE)
  ilgums=Sys.time()-sakums
  print(ilgums)
}


# combination ----
st_layers("./Geodata/2024/TopographicMap/LGIAtopo10K_v3.gpkg")

pages4=st_read("./Geodata/2024/TopographicMap/LGIAtopo10K_v4partial.gpkg",layer="Topo10_lapas")
pages4_united=st_union(pages4)
ggplot(pages4_united)+geom_sf()

# landus_A
landus_3=st_read("./Geodata/2024/TopographicMap/LGIAtopo10K_v3.gpkg",layer="landus_A")
landus_not4=st_difference(landus_3,pages4_united)
landus_not4=landus_not4 %>% 
  dplyr::select(FNAME,FCODE)
landus_4=st_read("./Geodata/2024/TopographicMap/LGIAtopo10K_v4partial.gpkg",layer="landus_A")
landus_4=landus_4 %>% 
  dplyr::select(FNAME,FCODE)
landus_new=rbind(landus_not4,landus_4)
sfarrow::st_write_parquet(landus_new,"./Geodata/2024/TopographicMap/LandusA_COMB.parquet")

# bridge_L
data_3=st_read("./Geodata/2024/TopographicMap/LGIAtopo10K_v3.gpkg",layer="bridge_L")
data_not4=st_difference(data_3,pages4_united)
data_not4=data_not4 %>% 
  dplyr::select(FNAME,FCODE)
data_4=st_read("./Geodata/2024/TopographicMap/LGIAtopo10K_v4partial.gpkg",layer="bridge_L")
data_4=data_4 %>% 
  dplyr::select(FNAME,FCODE)
data_new=rbind(data_not4,data_4)
sfarrow::st_write_parquet(data_new,"./Geodata/2024/TopographicMap/BridgeL_COMB.parquet")

# bridge_P
data_3=st_read("./Geodata/2024/TopographicMap/LGIAtopo10K_v3.gpkg",layer="bridge_P")
data_not4=st_difference(data_3,pages4_united)
data_not4=data_not4 %>% 
  dplyr::select(FNAME,FCODE)
data_4=st_read("./Geodata/2024/TopographicMap/LGIAtopo10K_v4partial.gpkg",layer="bridge_P")
data_4=data_4 %>% 
  dplyr::select(FNAME,FCODE)
data_new=rbind(data_not4,data_4)
sfarrow::st_write_parquet(data_new,"./Geodata/2024/TopographicMap/BridgeP_COMB.parquet")

# hidro_A
data_3=st_read("./Geodata/2024/TopographicMap/LGIAtopo10K_v3.gpkg",layer="hidro_A")
data_not4=st_difference(data_3,pages4_united)
data_not4=data_not4 %>% 
  dplyr::select(FNAME,FCODE)
data_4=st_read("./Geodata/2024/TopographicMap/LGIAtopo10K_v4partial.gpkg",layer="hidro_A")
data_4=data_4 %>% 
  dplyr::select(FNAME,FCODE)
data_new=rbind(data_not4,data_4)
sfarrow::st_write_parquet(data_new,"./Geodata/2024/TopographicMap/HidroA_COMB.parquet")

# hidro_L
data_3=st_read("./Geodata/2024/TopographicMap/LGIAtopo10K_v3.gpkg",layer="hidro_L")
data_not4=st_difference(data_3,pages4_united)
data_not4=data_not4 %>% 
  dplyr::select(FNAME,FCODE)
data_4=st_read("./Geodata/2024/TopographicMap/LGIAtopo10K_v4partial.gpkg",layer="hidro_L")
data_4=data_4 %>% 
  dplyr::select(FNAME,FCODE)
data_new=rbind(data_not4,data_4)
sfarrow::st_write_parquet(data_new,"./Geodata/2024/TopographicMap/HidroL_COMB.parquet")

# road_A
data_3=st_read("./Geodata/2024/TopographicMap/LGIAtopo10K_v3.gpkg",layer="road_A")
data_not4=st_difference(data_3,pages4_united)
data_not4=data_not4 %>% 
  dplyr::select(FNAME,FCODE)
data_4=st_read("./Geodata/2024/TopographicMap/LGIAtopo10K_v4partial.gpkg",layer="road_A")
data_4=data_4 %>% 
  dplyr::select(FNAME,FCODE)
data_new=rbind(data_not4,data_4)
sfarrow::st_write_parquet(data_new,"./Geodata/2024/TopographicMap/RoadA_COMB.parquet")

# road_L
data_3=st_read("./Geodata/2024/TopographicMap/LGIAtopo10K_v3.gpkg",layer="road_L")
data_not4=st_difference(data_3,pages4_united)
data_not4=data_not4 %>% 
  dplyr::select(FNAME,FCODE)
data_4=st_read("./Geodata/2024/TopographicMap/LGIAtopo10K_v4partial.gpkg",layer="road_L")
data_4=data_4 %>% 
  dplyr::select(FNAME,FCODE)
data_new=rbind(data_not4,data_4)
sfarrow::st_write_parquet(data_new,"./Geodata/2024/TopographicMap/RoadL_COMB.parquet")

# swamp_A
data_3=st_read("./Geodata/2024/TopographicMap/LGIAtopo10K_v3.gpkg",layer="swamp_A")
data_not4=st_difference(data_3,pages4_united)
data_not4=data_not4 %>% 
  dplyr::select(FNAME,FCODE)
data_4=st_read("./Geodata/2024/TopographicMap/LGIAtopo10K_v4partial.gpkg",layer="swamp_A")
data_4=data_4 %>% 
  dplyr::select(FNAME,FCODE)
data_new=rbind(data_not4,data_4)
sfarrow::st_write_parquet(data_new,"./Geodata/2024/TopographicMap/SwampA_COMB.parquet")



# flora_L
data_3=st_read("./Geodata/2024/TopographicMap/LGIAtopo10K_v3.gpkg",layer="flora_L")
data_not4=st_difference(data_3,pages4_united)
data_not4=data_not4 %>% 
  dplyr::select(FNAME,FCODE)
data_4=st_read("./Geodata/2024/TopographicMap/LGIAtopo10K_v4partial.gpkg",layer="flora_L")
data_4=data_4 %>% 
  dplyr::select(FNAME,FCODE)
data_new=rbind(data_not4,data_4)
sfarrow::st_write_parquet(data_new,"./Geodata/2024/TopographicMap/FloraL_COMB.parquet")

# build_A
data_3=st_read("./Geodata/2024/TopographicMap/LGIAtopo10K_v3.gpkg",layer="build_A")
data_3=data_3 %>% 
  dplyr::select(FNAME,FCODE)
sfarrow::st_write_parquet(data_3,"./Geodata/2024/TopographicMap/BuildA_v3.parquet")

