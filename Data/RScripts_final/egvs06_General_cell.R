# Libs ----
if(!require(egvtools)) {remotes::install_github("aavotins/egvtools"); require(egvtools)}
if(!require(terra)) {install.packages("terra"); require(terra)}
if(!require(sf)) {install.packages("sf"); require(sf)}
if(!require(tidyverse)) {install.packages("tidyverse"); require(tidyverse)}
if(!require(sfarrow)) {install.packages("sfarrow"); require(sfarrow)}
if(!require(readxl)) {install.packages("readxl"); require(readxl)}
if(!require(raster)) {install.packages("raster"); require(raster)}
if(!require(fasterize)) {install.packages("fasterize"); require(fasterize)}

# templates ----
template100=rast("./Templates/TemplateRasters/LV100m_10km.tif")
template10=rast("./Templates/TemplateRasters/LV10m_10km.tif")
rastrs10=raster(template10)

nulls10=rast("./Templates/TemplateRasters/nulls_LV10m_10km.tif")
nulls100=rast("./Templates/TemplateRasters/nulls_LV100m_10km.tif")

# simple landscape ----
simple_landscape=rast("RasterGrids_10m/2024/Ainava_vienk_mask.tif")
plot(simple_landscape)
freq(simple_landscape)
#     layer value     count
# 1      1   100  18536552
# 2      1   200  44101545
# 3      1   310 109384107
# 4      1   320   6309333
# 5      1   330  68188956
# 6      1   410   1433473
# 7      1   420   2651946
# 8      1   500   5383819
# 9      1   610  31853653
# 10     1   620  50856620
# 11     1   630 285120221
# 12     1   640   3388497
# 13     1   710  10152118
# 14     1   720   6369865
# 15     1   730    156647
# 16     1   800   1811825




# General_AllotmentGardens_cell.tif	egv_403 ----
allotmentgardens=ifel(simple_landscape==410,1,0)
i2e_rez=egvtools::input2egv(input=allotmentgardens,
                            egv_template= "./Templates/TemplateRasters/LV100m_10km.tif",
                            summary_function = "average",
                            missing_job = "FillOutput",
                            outlocation = "./RasterGrids_100m/2024/RAW/",
                            outfilename = "General_AllotmentGardens_cell.tif",
                            layername = "egv_403",
                            idw_weight = 2,
                            plot_gaps = FALSE,plot_final = TRUE)
i2e_rez
rm(allotmentgardens)
rm(i2e_rez)

# General_BareSoilQuarry_cell.tif	egv_408 ----
baresoilquerry=ifel(simple_landscape==800,1,0)
i2e_rez=egvtools::input2egv(input=baresoilquerry,
                            egv_template= "./Templates/TemplateRasters/LV100m_10km.tif",
                            summary_function = "average",
                            missing_job = "FillOutput",
                            outlocation = "./RasterGrids_100m/2024/RAW/",
                            outfilename = "General_BareSoilQuarry_cell.tif",
                            layername = "egv_408",
                            idw_weight = 2,
                            plot_gaps = FALSE,plot_final = TRUE)
i2e_rez
rm(baresoilquerry)
rm(i2e_rez)




# General_Builtup_cell.tif	egv_413 ----
builtup=ifel(simple_landscape==500,1,0)
i2e_rez=egvtools::input2egv(input=builtup,
                            egv_template= "./Templates/TemplateRasters/LV100m_10km.tif",
                            summary_function = "average",
                            missing_job = "FillOutput",
                            outlocation = "./RasterGrids_100m/2024/RAW/",
                            outfilename = "General_Builtup_cell.tif",
                            layername = "egv_413",
                            idw_weight = 2,
                            plot_gaps = FALSE,plot_final = TRUE)
i2e_rez
rm(builtup)
rm(i2e_rez)


# General_Farmland_cell.tif	egv_418 ----
farmland=ifel(simple_landscape>=300&simple_landscape<400,1,0)
i2e_rez=egvtools::input2egv(input=farmland,
                            egv_template= "./Templates/TemplateRasters/LV100m_10km.tif",
                            summary_function = "average",
                            missing_job = "FillOutput",
                            outlocation = "./RasterGrids_100m/2024/RAW/",
                            outfilename = "General_Farmland_cell.tif",
                            layername = "egv_418",
                            idw_weight = 2,
                            plot_gaps = FALSE,plot_final = TRUE)
i2e_rez
rm(farmland)
rm(i2e_rez)



# General_ForestsWithoutInventory_cell.tif	egv_423 ----
mvr=st_read_parquet("./Geodata/2024/MVR/nogabali_2024janv.parquet")
tksetie=mvr %>% 
  mutate(yes=1) %>% 
  filter(zkat %in% c("10","12","14","16"))
taksetie_r=fasterize(tksetie,rastrs10,field="yes",fun="first")
taksetie_t=rast(taksetie_r)
visi_mezi=ifel(simple_landscape==630,1,0)
netaksetie=ifel(is.na(taksetie_t)&visi_mezi==1,1,0)
plot(netaksetie)

i2e_rez=egvtools::input2egv(input=netaksetie,
                            egv_template= "./Templates/TemplateRasters/LV100m_10km.tif",
                            summary_function = "average",
                            missing_job = "FillOutput",
                            outlocation = "./RasterGrids_100m/2024/RAW/",
                            outfilename = "General_ForestsWithoutInventory_cell.tif",
                            layername = "egv_423",
                            idw_weight = 2,
                            plot_gaps = FALSE,plot_final = TRUE)
i2e_rez
rm(netaksetie)
rm(i2e_rez)
rm(mvr)
rm(tksetie)
rm(taksetie_r)
rm(taksetie_t)
rm(visi_mezi)

# General_GardensOrchards_cell.tif	egv_428 ----
parejie=ifel(simple_landscape>=400&simple_landscape<500,1,0)
i2e_rez=egvtools::input2egv(input=parejie,
                            egv_template= "./Templates/TemplateRasters/LV100m_10km.tif",
                            summary_function = "average",
                            missing_job = "FillOutput",
                            outlocation = "./RasterGrids_100m/2024/RAW/",
                            outfilename = "General_GardensOrchards_cell.tif",
                            layername = "egv_428",
                            idw_weight = 2,
                            plot_gaps = FALSE,plot_final = TRUE)
i2e_rez
rm(parejie)
rm(i2e_rez)


# General_Roads_cell.tif	egv_433 ----
celi=ifel(simple_landscape==100,1,0)
i2e_rez=egvtools::input2egv(input=celi,
                            egv_template= "./Templates/TemplateRasters/LV100m_10km.tif",
                            summary_function = "average",
                            missing_job = "FillOutput",
                            outlocation = "./RasterGrids_100m/2024/RAW/",
                            outfilename = "General_Roads_cell.tif",
                            layername = "egv_433",
                            idw_weight = 2,
                            plot_gaps = FALSE,plot_final = TRUE)
i2e_rez
rm(celi)
rm(i2e_rez)


# General_ShrubsOrchards_cell.tif	egv_434 ----
kodi=read_excel("./Geodata/2024/LAD/KulturuKodi_2024.xlsx")
kodi$kods=as.character(kodi$kods)
table(kodi$SDM_grupa_sakums,useNA="always")
lad=sfarrow::st_read_parquet("./Geodata/2024/LAD/Lauki_2024.parquet")
lad$yes=1
lad=lad %>% 
  left_join(kodi,by=c("PRODUCT_CODE"="kods"))
ilggadigiekrumveida=lad %>% 
  filter(SDM_grupa_sakums == "krūmveida ilggadīgie stādījumi")
krumveida_r=fasterize(ilggadigiekrumveida,rastrs10,field="yes",fun="first")
krumveida_t=rast(krumveida_r)
augludarzi=ifel(simple_landscape==420|simple_landscape==620,1,0)
apvienoti=cover(krumveida_t,augludarzi)
plot(apvienoti)

i2e_rez=egvtools::input2egv(input=apvienoti,
                            egv_template= "./Templates/TemplateRasters/LV100m_10km.tif",
                            summary_function = "average",
                            missing_job = "FillOutput",
                            outlocation = "./RasterGrids_100m/2024/RAW/",
                            outfilename = "General_ShrubsOrchards_cell.tif",
                            layername = "egv_434",
                            idw_weight = 2,
                            plot_gaps = FALSE,plot_final = TRUE)
i2e_rez
rm(apvienoti)
rm(i2e_rez)
rm(ilggadigiekrumveida)
rm(krumveida_r)
rm(krumveida_t)
rm(augludarzi)

rm(kodi)
rm(lad)


# General_ShrubsOrchardsGardens_cell.tif	egv_439 ----
kodi=read_excel("./Geodata/2024/LAD/KulturuKodi_2024.xlsx")
kodi$kods=as.character(kodi$kods)
table(kodi$SDM_grupa_sakums,useNA="always")
lad=sfarrow::st_read_parquet("./Geodata/2024/LAD/Lauki_2024.parquet")
lad$yes=1
lad=lad %>% 
  left_join(kodi,by=c("PRODUCT_CODE"="kods"))
ilggadigiekrumveida=lad %>% 
  filter(SDM_grupa_sakums == "krūmveida ilggadīgie stādījumi")
krumveida_r=fasterize(ilggadigiekrumveida,rastrs10,field="yes",fun="first")
krumveida_t=rast(krumveida_r)
parejie=ifel((simple_landscape>=400&simple_landscape<500)|
               simple_landscape==620,1,0)
apvienoti=cover(krumveida_t,parejie)
plot(apvienoti)

i2e_rez=egvtools::input2egv(input=apvienoti,
                            egv_template= "./Templates/TemplateRasters/LV100m_10km.tif",
                            summary_function = "average",
                            missing_job = "FillOutput",
                            outlocation = "./RasterGrids_100m/2024/RAW/",
                            outfilename = "General_ShrubsOrchardsGardens_cell.tif",
                            layername = "egv_439",
                            idw_weight = 2,
                            plot_gaps = FALSE,plot_final = TRUE)
i2e_rez
rm(apvienoti)
rm(i2e_rez)
rm(ilggadigiekrumveida)
rm(krumveida_r)
rm(krumveida_t)
rm(parejie)


# General_SwampsMiresBogsHelophytes_cell.tif	egv_444 ----
purvi=ifel(simple_landscape>=700&simple_landscape<800,1,0)
i2e_rez=egvtools::input2egv(input=purvi,
                            egv_template= "./Templates/TemplateRasters/LV100m_10km.tif",
                            summary_function = "average",
                            missing_job = "FillOutput",
                            outlocation = "./RasterGrids_100m/2024/RAW/",
                            outfilename = "General_SwampsMiresBogsHelophytes_cell.tif",
                            layername = "egv_444",
                            idw_weight = 2,
                            plot_gaps = FALSE,plot_final = TRUE)
i2e_rez
rm(purvi)
rm(i2e_rez)

# General_Trees_cell.tif	egv_449 ----
kokimezi=ifel(simple_landscape>=600&simple_landscape<700,1,0)
i2e_rez=egvtools::input2egv(input=kokimezi,
                            egv_template= "./Templates/TemplateRasters/LV100m_10km.tif",
                            summary_function = "average",
                            missing_job = "FillOutput",
                            outlocation = "./RasterGrids_100m/2024/RAW/",
                            outfilename = "General_Trees_cell.tif",
                            layername = "egv_449",
                            idw_weight = 2,
                            plot_gaps = FALSE,plot_final = TRUE)
i2e_rez
rm(kokimezi)
rm(i2e_rez)

# General_TreesOutsideForests_cell.tif	egv_454 ----
kokiarpuse=ifel(simple_landscape==640,1,0)
i2e_rez=egvtools::input2egv(input=kokiarpuse,
                            egv_template= "./Templates/TemplateRasters/LV100m_10km.tif",
                            summary_function = "average",
                            missing_job = "FillOutput",
                            outlocation = "./RasterGrids_100m/2024/RAW/",
                            outfilename = "General_TreesOutsideForests_cell.tif",
                            layername = "egv_454",
                            idw_weight = 2,
                            plot_gaps = FALSE,plot_final = TRUE)
i2e_rez
rm(kokiarpuse)
rm(i2e_rez)


# General_Water_cell.tif	egv_459 ----
udens=ifel(simple_landscape==200,1,0)
i2e_rez=egvtools::input2egv(input=udens,
                            egv_template= "./Templates/TemplateRasters/LV100m_10km.tif",
                            summary_function = "average",
                            missing_job = "FillOutput",
                            outlocation = "./RasterGrids_100m/2024/RAW/",
                            outfilename = "General_Water_cell.tif",
                            layername = "egv_459",
                            idw_weight = 2,
                            plot_gaps = FALSE,plot_final = TRUE)
i2e_rez
rm(udens)
rm(i2e_rez)


