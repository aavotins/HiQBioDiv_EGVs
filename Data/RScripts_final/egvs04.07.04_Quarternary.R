# libs ----
if(!require(terra)) {install.packages("terra"); require(terra)}
if(!require(sf)) {install.packages("sf"); require(sf)}
if(!require(tidyverse)) {install.packages("tidyverse"); require(tidyverse)}

# Template ----
template10=rast("./Templates/TemplateRasters/LV10m_10km.tif")

# Quarternary geology ----

kvartars=sfarrow::st_read_parquet("./Geodata/2024/Soils/QuaternaryGeology_LV/Kvartargeologija.parquet")

# reclassification
kvartars=kvartars %>% 
  mutate(grupas = case_when(Litologija=="aleirits"~"Silt",
                            Litologija=="aleirits_malains"~"Silt",
                            Litologija=="dunjas"~"organika",
                            Litologija=="kudra"~"organika",
                            Litologija=="mals"~"Clay",
                            Litologija=="mals_aleiritisks"~"Clay",
                            Litologija=="morena"~"Silt",
                            Litologija=="smilts"~"Sand",
                            Litologija=="smilts_aleiritiska"~"Sand",
                            Litologija=="smilts_aleirits_mals"~"Silt",
                            Litologija=="smilts_aleirits_sapropelis"~"Silt",
                            Litologija=="smilts_dunjaina"~"Sand",
                            Litologija=="smilts_grants"~"Sand",
                            Litologija=="smilts_grants_oli"~"Sand",
                            Litologija=="smilts_grants_oli_aleirits"~"Sand",
                            Litologija=="smilts_kudraina"~"Sand",
                            Litologija=="smilts_malaina_dazadgraudaina, malsmilts"~"Silt",
                            Litologija=="smilts_videjgraudaina, malsmilts"~"Sand",
                            Litologija=="smilts_videjgraudaina"~"Sand",
                            .default=NA))
# numeric codes
kvartars=kvartars %>% 
  mutate(grupas_num=case_when(grupas == "Sand" ~"1",
                              grupas == "Silt" ~"2",
                              grupas == "Clay" ~"3",
                              grupas == "organika" ~"4",
                              .default=NA))

# crs transformation
kvartars_3059=st_transform(kvartars,crs=3059)

# nonmissing classes
kvartars_3059=kvartars_3059 %>% 
  filter(!is.na(grupas_num))

# rasterization
apaksaugsnem=rasterize(kvartars_3059,template10,field="grupas_num",fun="max",
                       filename="./RasterGrids_10m/2024/SoilTXT_QuarternaryLV.tif",
                       overwrite=TRUE)
plot(apaksaugsnem)
