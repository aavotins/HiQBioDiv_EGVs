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

# kodi ----
kodi=read_excel("./Geodata/2024/LAD/KulturuKodi_2024.xlsx")
kodi$kods=as.character(kodi$kods)
# LAD ----
lad=sfarrow::st_read_parquet("./Geodata/2024/LAD/Lauki_2024.parquet")
lad$yes=1
lad=lad %>% 
  left_join(kodi,by=c("PRODUCT_CODE"="kods"))

# simple landscape ----
simple_landscape=rast("RasterGrids_10m/2024/Ainava_vienk_mask.tif")

# FarmlandCrops_CropsAll_cell.tif	egv_180 ----
aramzemes=lad %>% 
  filter(str_detect(SDM_grupa_sakums,"aramz"))

p2i_rez=egvtools::polygon2input(vector_data = aramzemes,
                        template_path = "./Templates/TemplateRasters/LV10m_10km.tif",
                        out_path = "./RasterGrids_10m/2024/",
                        file_name = "FarmlandCrops_CropsAll_input.tif",
                        value_field = "yes",
                        prepare=FALSE,
                        background_raster = "./Templates/TemplateRasters/nulls_LV10m_10km.tif",
                        plot_result = TRUE)
p2i_rez
i2e_rez=egvtools::input2egv(input=paste0("./RasterGrids_10m/2024/",
                                         "FarmlandCrops_CropsAll_input.tif"),
                    egv_template= "./Templates/TemplateRasters/LV100m_10km.tif",
                    summary_function = "average",
                    missing_job = "FillOutput",
                    outlocation = "./RasterGrids_100m/2024/RAW/",
                    outfilename = "FarmlandCrops_CropsAll_cell.tif",
                    layername = "egv_180",
                    idw_weight = 2,
                    plot_gaps = FALSE,plot_final = TRUE)
i2e_rez
rm(p2i_rez)
rm(i2e_rez)
rm(aramzemes)
unlink("./RasterGrids_10m/2024/FarmlandCrops_CropsAll_input.tif")


# FarmlandCrops_CropsHoed_cell.tif	egv_185 ----
dati=lad %>% 
  filter(str_detect(SDM_grupa_sakums,"ruši"))
table(dati$SDM_grupa_sakums,useNA="always")


p2i_rez=egvtools::polygon2input(vector_data = dati,
                                template_path = "./Templates/TemplateRasters/LV10m_10km.tif",
                                out_path = "./RasterGrids_10m/2024/",
                                file_name = "FarmlandCrops_CropsHoed_input.tif",
                                value_field = "yes",
                                prepare=FALSE,
                                background_raster = "./Templates/TemplateRasters/nulls_LV10m_10km.tif",
                                plot_result = TRUE)
p2i_rez
i2e_rez=egvtools::input2egv(input=paste0("./RasterGrids_10m/2024/",
                                         "FarmlandCrops_CropsHoed_input.tif"),
                            egv_template= "./Templates/TemplateRasters/LV100m_10km.tif",
                            summary_function = "average",
                            missing_job = "FillOutput",
                            outlocation = "./RasterGrids_100m/2024/RAW/",
                            outfilename = "FarmlandCrops_CropsHoed_cell.tif",
                            layername = "egv_185",
                            idw_weight = 2,
                            plot_gaps = FALSE,plot_final = TRUE)
i2e_rez
rm(p2i_rez)
rm(i2e_rez)
rm(dati)
unlink("./RasterGrids_10m/2024/FarmlandCrops_CropsHoed_input.tif")

# FarmlandCrops_CropsOther_cell.tif	egv_190 ----
dati=lad %>% 
  filter(str_detect(SDM_grupa_sakums,"citur neie"))
table(dati$SDM_grupa_sakums,useNA="always")


p2i_rez=egvtools::polygon2input(vector_data = dati,
                                template_path = "./Templates/TemplateRasters/LV10m_10km.tif",
                                out_path = "./RasterGrids_10m/2024/",
                                file_name = "FarmlandCrops_CropsOther_input.tif",
                                value_field = "yes",
                                prepare=FALSE,
                                background_raster = "./Templates/TemplateRasters/nulls_LV10m_10km.tif",
                                plot_result = TRUE)
p2i_rez
i2e_rez=egvtools::input2egv(input=paste0("./RasterGrids_10m/2024/",
                                         "FarmlandCrops_CropsOther_input.tif"),
                            egv_template= "./Templates/TemplateRasters/LV100m_10km.tif",
                            summary_function = "average",
                            missing_job = "FillOutput",
                            outlocation = "./RasterGrids_100m/2024/RAW/",
                            outfilename = "FarmlandCrops_CropsOther_cell.tif",
                            layername = "egv_190",
                            idw_weight = 2,
                            plot_gaps = FALSE,plot_final = TRUE)
i2e_rez
rm(p2i_rez)
rm(i2e_rez)
rm(dati)
unlink("./RasterGrids_10m/2024/FarmlandCrops_CropsOther_input.tif")

# FarmlandCrops_CropsSpring_cell.tif	egv_195 ----
dati=lad %>% 
  filter(str_detect(SDM_grupa_sakums,"labība-vasarāji"))
table(dati$SDM_grupa_sakums,useNA="always")


p2i_rez=egvtools::polygon2input(vector_data = dati,
                                template_path = "./Templates/TemplateRasters/LV10m_10km.tif",
                                out_path = "./RasterGrids_10m/2024/",
                                file_name = "FarmlandCrops_CropsSpring_input.tif",
                                value_field = "yes",
                                prepare=FALSE,
                                background_raster = "./Templates/TemplateRasters/nulls_LV10m_10km.tif",
                                plot_result = TRUE)
p2i_rez
i2e_rez=egvtools::input2egv(input=paste0("./RasterGrids_10m/2024/",
                                         "FarmlandCrops_CropsSpring_input.tif"),
                            egv_template= "./Templates/TemplateRasters/LV100m_10km.tif",
                            summary_function = "average",
                            missing_job = "FillOutput",
                            outlocation = "./RasterGrids_100m/2024/RAW/",
                            outfilename = "FarmlandCrops_CropsSpring_cell.tif",
                            layername = "egv_195",
                            idw_weight = 2,
                            plot_gaps = FALSE,plot_final = TRUE)
i2e_rez
rm(p2i_rez)
rm(i2e_rez)
rm(dati)
unlink("./RasterGrids_10m/2024/FarmlandCrops_CropsSpring_input.tif")

# FarmlandCrops_CropsWinter_cell.tif	egv_200 ----
dati=lad %>% 
  filter(str_detect(SDM_grupa_sakums,"labība-ziemāji"))
table(dati$SDM_grupa_sakums,useNA="always")


p2i_rez=egvtools::polygon2input(vector_data = dati,
                                template_path = "./Templates/TemplateRasters/LV10m_10km.tif",
                                out_path = "./RasterGrids_10m/2024/",
                                file_name = "FarmlandCrops_CropsWinter_input.tif",
                                value_field = "yes",
                                prepare=FALSE,
                                background_raster = "./Templates/TemplateRasters/nulls_LV10m_10km.tif",
                                plot_result = TRUE)
p2i_rez
i2e_rez=egvtools::input2egv(input=paste0("./RasterGrids_10m/2024/",
                                         "FarmlandCrops_CropsWinter_input.tif"),
                            egv_template= "./Templates/TemplateRasters/LV100m_10km.tif",
                            summary_function = "average",
                            missing_job = "FillOutput",
                            outlocation = "./RasterGrids_100m/2024/RAW/",
                            outfilename = "FarmlandCrops_CropsWinter_cell.tif",
                            layername = "egv_200",
                            idw_weight = 2,
                            plot_gaps = FALSE,plot_final = TRUE)
i2e_rez
rm(p2i_rez)
rm(i2e_rez)
rm(dati)
unlink("./RasterGrids_10m/2024/FarmlandCrops_CropsWinter_input.tif")

# FarmlandCrops_RapeseedsSpring_cell.tif	egv_205 ----
dati=lad %>% 
  filter(str_detect(SDM_grupa_sakums,"vasaras rapsis"))
table(dati$SDM_grupa_sakums,useNA="always")


p2i_rez=egvtools::polygon2input(vector_data = dati,
                                template_path = "./Templates/TemplateRasters/LV10m_10km.tif",
                                out_path = "./RasterGrids_10m/2024/",
                                file_name = "FarmlandCrops_RapeseedsSpring_input.tif",
                                value_field = "yes",
                                prepare=FALSE,
                                background_raster = "./Templates/TemplateRasters/nulls_LV10m_10km.tif",
                                plot_result = TRUE)
p2i_rez
i2e_rez=egvtools::input2egv(input=paste0("./RasterGrids_10m/2024/",
                                         "FarmlandCrops_RapeseedsSpring_input.tif"),
                            egv_template= "./Templates/TemplateRasters/LV100m_10km.tif",
                            summary_function = "average",
                            missing_job = "FillOutput",
                            outlocation = "./RasterGrids_100m/2024/RAW/",
                            outfilename = "FarmlandCrops_RapeseedsSpring_cell.tif",
                            layername = "egv_205",
                            idw_weight = 2,
                            plot_gaps = FALSE,plot_final = TRUE)
i2e_rez
rm(p2i_rez)
rm(i2e_rez)
rm(dati)
unlink("./RasterGrids_10m/2024/FarmlandCrops_RapeseedsSpring_input.tif")

# FarmlandCrops_RapeseedsWinter_cell.tif	egv_210 ----
dati=lad %>% 
  filter(str_detect(SDM_grupa_sakums,"ziemas rapsis"))
table(dati$SDM_grupa_sakums,useNA="always")


p2i_rez=egvtools::polygon2input(vector_data = dati,
                                template_path = "./Templates/TemplateRasters/LV10m_10km.tif",
                                out_path = "./RasterGrids_10m/2024/",
                                file_name = "FarmlandCrops_RapeseedsWinter_input.tif",
                                value_field = "yes",
                                prepare=FALSE,
                                background_raster = "./Templates/TemplateRasters/nulls_LV10m_10km.tif",
                                plot_result = TRUE)
p2i_rez
i2e_rez=egvtools::input2egv(input=paste0("./RasterGrids_10m/2024/",
                                         "FarmlandCrops_RapeseedsWinter_input.tif"),
                            egv_template= "./Templates/TemplateRasters/LV100m_10km.tif",
                            summary_function = "average",
                            missing_job = "FillOutput",
                            outlocation = "./RasterGrids_100m/2024/RAW/",
                            outfilename = "FarmlandCrops_RapeseedsWinter_cell.tif",
                            layername = "egv_210",
                            idw_weight = 2,
                            plot_gaps = FALSE,plot_final = TRUE)
i2e_rez
rm(p2i_rez)
rm(i2e_rez)
rm(dati)
unlink("./RasterGrids_10m/2024/FarmlandCrops_RapeseedsWinter_input.tif")

# FarmlandGrassland_GrasslandsAbandoned_cell.tif	egv_215 ----
landscape_grasslands=ifel(simple_landscape==330,1,0)

dati=lad %>% 
  filter(str_detect(SDM_grupa_sakums,"zālāji"))
table(dati$SDM_grupa_sakums,useNA="always")

lad_zalajiem=fasterize(dati,rastrs10,field="yes",fun="first")
lad_zalaji=rast(lad_zalajiem)

abandoned=ifel(landscape_grasslands==1&is.na(lad_zalaji),1,0)
plot(abandoned)

i2e_rez=egvtools::input2egv(input=abandoned,
                            egv_template= "./Templates/TemplateRasters/LV100m_10km.tif",
                            summary_function = "average",
                            missing_job = "FillOutput",
                            outlocation = "./RasterGrids_100m/2024/RAW/",
                            outfilename = "FarmlandGrassland_GrasslandsAbandoned_cell.tif",
                            layername = "egv_215",
                            idw_weight = 2,
                            plot_gaps = FALSE,plot_final = TRUE)
i2e_rez
rm(i2e_rez)
rm(dati)
rm(lad_zalajiem)
rm(lad_zalaji)

# FarmlandGrassland_GrasslandsAll_cell.tif	egv_220 ----
landscape_grasslands=ifel(simple_landscape==330,1,0)

i2e_rez=egvtools::input2egv(input=landscape_grasslands,
                            egv_template= "./Templates/TemplateRasters/LV100m_10km.tif",
                            summary_function = "average",
                            missing_job = "FillOutput",
                            outlocation = "./RasterGrids_100m/2024/RAW/",
                            outfilename = "FarmlandGrassland_GrasslandsAll_cell.tif",
                            layername = "egv_220",
                            idw_weight = 2,
                            plot_gaps = FALSE,plot_final = TRUE)
i2e_rez
rm(i2e_rez)
rm(landscape_grasslands)

# FarmlandGrassland_GrasslandsPermanent_cell.tif	egv_225 ----
dati=lad %>% 
  filter(SDM_grupa_sakums=="zālāji (ilggadīgie)")
  
table(dati$SDM_grupa_sakums,useNA="always")

p2i_rez=egvtools::polygon2input(vector_data = dati,
                                template_path = "./Templates/TemplateRasters/LV10m_10km.tif",
                                out_path = "./RasterGrids_10m/2024/",
                                file_name = "FarmlandGrassland_GrasslandsPermanent_input.tif",
                                value_field = "yes",
                                prepare=FALSE,
                                background_raster = "./Templates/TemplateRasters/nulls_LV10m_10km.tif",
                                plot_result = TRUE)
p2i_rez
i2e_rez=egvtools::input2egv(input=paste0("./RasterGrids_10m/2024/",
                                         "FarmlandGrassland_GrasslandsPermanent_input.tif"),
                            egv_template= "./Templates/TemplateRasters/LV100m_10km.tif",
                            summary_function = "average",
                            missing_job = "FillOutput",
                            outlocation = "./RasterGrids_100m/2024/RAW/",
                            outfilename = "FarmlandGrassland_GrasslandsPermanent_cell.tif",
                            layername = "egv_225",
                            idw_weight = 2,
                            plot_gaps = FALSE,plot_final = TRUE)
i2e_rez
rm(p2i_rez)
rm(i2e_rez)
rm(dati)
unlink("./RasterGrids_10m/2024/FarmlandGrassland_GrasslandsPermanent_input.tif")


# FarmlandGrassland_GrasslandsTemporary_cell.tif	egv_230 ----
dati=lad %>% 
  filter(str_detect(SDM_grupa_sakums,"kultivēt"))
table(dati$SDM_grupa_sakums,useNA="always")

p2i_rez=egvtools::polygon2input(vector_data = dati,
                                template_path = "./Templates/TemplateRasters/LV10m_10km.tif",
                                out_path = "./RasterGrids_10m/2024/",
                                file_name = "FarmlandGrassland_GrasslandsTemporary_input.tif",
                                value_field = "yes",
                                prepare=FALSE,
                                background_raster = "./Templates/TemplateRasters/nulls_LV10m_10km.tif",
                                plot_result = TRUE)
p2i_rez
i2e_rez=egvtools::input2egv(input=paste0("./RasterGrids_10m/2024/",
                                         "FarmlandGrassland_GrasslandsTemporary_input.tif"),
                            egv_template= "./Templates/TemplateRasters/LV100m_10km.tif",
                            summary_function = "average",
                            missing_job = "FillOutput",
                            outlocation = "./RasterGrids_100m/2024/RAW/",
                            outfilename = "FarmlandGrassland_GrasslandsTemporary_cell.tif",
                            layername = "egv_230",
                            idw_weight = 2,
                            plot_gaps = FALSE,plot_final = TRUE)
i2e_rez
rm(p2i_rez)
rm(i2e_rez)
rm(dati)
unlink("./RasterGrids_10m/2024/FarmlandGrassland_GrasslandsTemporary_input.tif")

# FarmlandParcels_FieldsActive_cell.tif	egv_235 ----
p2i_rez=egvtools::polygon2input(vector_data = lad,
                                template_path = "./Templates/TemplateRasters/LV10m_10km.tif",
                                out_path = "./RasterGrids_10m/2024/",
                                file_name = "FarmlandParcels_FieldsActive_input.tif",
                                value_field = "yes",
                                prepare=FALSE,
                                background_raster = "./Templates/TemplateRasters/nulls_LV10m_10km.tif",
                                plot_result = TRUE)
p2i_rez
i2e_rez=egvtools::input2egv(input=paste0("./RasterGrids_10m/2024/",
                                         "FarmlandParcels_FieldsActive_input.tif"),
                            egv_template= "./Templates/TemplateRasters/LV100m_10km.tif",
                            summary_function = "average",
                            missing_job = "FillOutput",
                            outlocation = "./RasterGrids_100m/2024/RAW/",
                            outfilename = "FarmlandParcels_FieldsActive_cell.tif",
                            layername = "egv_235",
                            idw_weight = 2,
                            plot_gaps = FALSE,plot_final = TRUE)
i2e_rez
rm(p2i_rez)
rm(i2e_rez)
rm(dati)
unlink("./RasterGrids_10m/2024/FarmlandParcels_FieldsActive_input.tif")

# FarmlandPloughed_CropsFallow_cell.tif	egv_240 ----
dati=lad %>% 
  filter(SDM_grupa_sakums %in% c("aramzemes (citur neiekļautās)",
                                 "aramzemes (labība-vasarāji)",
                                 "aramzemes (labība-ziemāji)",
                                 "aramzemes (vagu un rušināmkultūru)",
                                 "aramzemes (vasaras rapsis un rispsis, kukurūzas, zirņi un pupas, soja, kaņepes)",
                                 "aramzemes (ziemas rapsis un ripsis)",
                                 "papuves"))
table(dati$SDM_grupa_sakums,useNA="always")

p2i_rez=egvtools::polygon2input(vector_data = dati,
                                template_path = "./Templates/TemplateRasters/LV10m_10km.tif",
                                out_path = "./RasterGrids_10m/2024/",
                                file_name = "FarmlandPloughed_CropsFallow_input.tif",
                                value_field = "yes",
                                prepare=FALSE,
                                background_raster = "./Templates/TemplateRasters/nulls_LV10m_10km.tif",
                                plot_result = TRUE)
p2i_rez
i2e_rez=egvtools::input2egv(input=paste0("./RasterGrids_10m/2024/",
                                         "FarmlandPloughed_CropsFallow_input.tif"),
                            egv_template= "./Templates/TemplateRasters/LV100m_10km.tif",
                            summary_function = "average",
                            missing_job = "FillOutput",
                            outlocation = "./RasterGrids_100m/2024/RAW/",
                            outfilename = "FarmlandPloughed_CropsFallow_cell.tif",
                            layername = "egv_240",
                            idw_weight = 2,
                            plot_gaps = FALSE,plot_final = TRUE)
i2e_rez
rm(p2i_rez)
rm(i2e_rez)
rm(dati)
unlink("./RasterGrids_10m/2024/FarmlandPloughed_CropsFallow_input.tif")

# FarmlandPloughed_CropsFallowTempGrass_cell.tif	egv_245 ----
dati=lad %>% 
  filter(SDM_grupa_sakums %in% c("aramzemes (citur neiekļautās)",
                                 "aramzemes (labība-vasarāji)",
                                 "aramzemes (labība-ziemāji)",
                                 "aramzemes (vagu un rušināmkultūru)",
                                 "aramzemes (vasaras rapsis un rispsis, kukurūzas, zirņi un pupas, soja, kaņepes)",
                                 "aramzemes (ziemas rapsis un ripsis)",
                                 "papuves",
                                 "zālāji (kultivētie)"))
table(dati$SDM_grupa_sakums,useNA="always")

p2i_rez=egvtools::polygon2input(vector_data = dati,
                                template_path = "./Templates/TemplateRasters/LV10m_10km.tif",
                                out_path = "./RasterGrids_10m/2024/",
                                file_name = "FarmlandPloughed_CropsFallowTempGrass_input.tif",
                                value_field = "yes",
                                prepare=FALSE,
                                background_raster = "./Templates/TemplateRasters/nulls_LV10m_10km.tif",
                                plot_result = TRUE)
p2i_rez
i2e_rez=egvtools::input2egv(input=paste0("./RasterGrids_10m/2024/",
                                         "FarmlandPloughed_CropsFallowTempGrass_input.tif"),
                            egv_template= "./Templates/TemplateRasters/LV100m_10km.tif",
                            summary_function = "average",
                            missing_job = "FillOutput",
                            outlocation = "./RasterGrids_100m/2024/RAW/",
                            outfilename = "FarmlandPloughed_CropsFallowTempGrass_cell.tif",
                            layername = "egv_245",
                            idw_weight = 2,
                            plot_gaps = FALSE,plot_final = TRUE)
i2e_rez
rm(p2i_rez)
rm(i2e_rez)
rm(dati)
unlink("./RasterGrids_10m/2024/FarmlandPloughed_CropsFallowTempGrass_input.tif")

# FarmlandPloughed_Fallow_cell.tif	egv_250 ----
dati=lad %>% 
  filter(SDM_grupa_sakums == "papuves")
table(dati$SDM_grupa_sakums,useNA="always")

p2i_rez=egvtools::polygon2input(vector_data = dati,
                                template_path = "./Templates/TemplateRasters/LV10m_10km.tif",
                                out_path = "./RasterGrids_10m/2024/",
                                file_name = "FarmlandPloughed_Fallow_input.tif",
                                value_field = "yes",
                                prepare=FALSE,
                                background_raster = "./Templates/TemplateRasters/nulls_LV10m_10km.tif",
                                plot_result = TRUE)
p2i_rez
i2e_rez=egvtools::input2egv(input=paste0("./RasterGrids_10m/2024/",
                                         "FarmlandPloughed_Fallow_input.tif"),
                            egv_template= "./Templates/TemplateRasters/LV100m_10km.tif",
                            summary_function = "average",
                            missing_job = "FillOutput",
                            outlocation = "./RasterGrids_100m/2024/RAW/",
                            outfilename = "FarmlandPloughed_Fallow_cell.tif",
                            layername = "egv_250",
                            idw_weight = 2,
                            plot_gaps = FALSE,plot_final = TRUE)
i2e_rez
rm(p2i_rez)
rm(i2e_rez)
rm(dati)
unlink("./RasterGrids_10m/2024/FarmlandPloughed_Fallow_input.tif")

# FarmlandSubsidies_BiologicalSubsidies_cell.tif	egv_255 ----
dati=lad %>% 
  filter(str_detect(AID_FORMS,"BLA"))
table(dati$AID_FORMS,useNA="always")

p2i_rez=egvtools::polygon2input(vector_data = dati,
                                template_path = "./Templates/TemplateRasters/LV10m_10km.tif",
                                out_path = "./RasterGrids_10m/2024/",
                                file_name = "FarmlandSubsidies_BiologicalSubsidies_input.tif",
                                value_field = "yes",
                                prepare=FALSE,
                                background_raster = "./Templates/TemplateRasters/nulls_LV10m_10km.tif",
                                plot_result = TRUE)
p2i_rez
i2e_rez=egvtools::input2egv(input=paste0("./RasterGrids_10m/2024/",
                                         "FarmlandSubsidies_BiologicalSubsidies_input.tif"),
                            egv_template= "./Templates/TemplateRasters/LV100m_10km.tif",
                            summary_function = "average",
                            missing_job = "FillOutput",
                            outlocation = "./RasterGrids_100m/2024/RAW/",
                            outfilename = "FarmlandSubsidies_BiologicalSubsidies_cell.tif",
                            layername = "egv_255",
                            idw_weight = 2,
                            plot_gaps = FALSE,plot_final = TRUE)
i2e_rez
rm(p2i_rez)
rm(i2e_rez)
rm(dati)
unlink("./RasterGrids_10m/2024/FarmlandSubsidies_BiologicalSubsidies_input.tif")

# FarmlandTrees_PermanentCrops_cell.tif	egv_260 ----
dati=lad %>% 
  filter(SDM_grupa_sakums == "augļudārzi")
table(dati$SDM_grupa_sakums,useNA="always")
dati=dati %>% 
  dplyr::select(yes)

topo=sfarrow::st_read_parquet("./Geodata/2024/TopographicMap/LandusA_COMB.parquet")
dati_topo= topo %>% 
  filter(FNAME %in% c("poligons_Augludarzs","poligons_Augļudārzs",
                      "poligons_Ogulājs","poligons_Ogulajs")) %>% 
  mutate(yes=1) %>% 
  dplyr::select(yes)
abidati=rbind(dati,dati_topo)

p2i_rez=egvtools::polygon2input(vector_data = abidati,
                                template_path = "./Templates/TemplateRasters/LV10m_10km.tif",
                                out_path = "./RasterGrids_10m/2024/",
                                file_name = "FarmlandTrees_PermanentCrops_input.tif",
                                value_field = "yes",
                                prepare=FALSE,
                                background_raster = "./Templates/TemplateRasters/nulls_LV10m_10km.tif",
                                plot_result = TRUE)
p2i_rez
i2e_rez=egvtools::input2egv(input=paste0("./RasterGrids_10m/2024/",
                                         "FarmlandTrees_PermanentCrops_input.tif"),
                            egv_template= "./Templates/TemplateRasters/LV100m_10km.tif",
                            summary_function = "average",
                            missing_job = "FillOutput",
                            outlocation = "./RasterGrids_100m/2024/RAW/",
                            outfilename = "FarmlandTrees_PermanentCrops_cell.tif",
                            layername = "egv_260",
                            idw_weight = 2,
                            plot_gaps = FALSE,plot_final = TRUE)
i2e_rez
rm(p2i_rez)
rm(i2e_rez)
rm(dati)
rm(topo)
rm(dati_topo)
rm(abidati)
unlink("./RasterGrids_10m/2024/FarmlandTrees_PermanentCrops_input.tif")

# FarmlandTrees_ShortRotationCoppice_cell.tif	egv_265 ----
dati=lad %>% 
  filter(SDM_grupa_sakums == "krūmveida ilggadīgie stādījumi")
table(dati$SDM_grupa_sakums,useNA="always")

p2i_rez=egvtools::polygon2input(vector_data = dati,
                                template_path = "./Templates/TemplateRasters/LV10m_10km.tif",
                                out_path = "./RasterGrids_10m/2024/",
                                file_name = "FarmlandTrees_ShortRotationCoppice_input.tif",
                                value_field = "yes",
                                prepare=FALSE,
                                background_raster = "./Templates/TemplateRasters/nulls_LV10m_10km.tif",
                                plot_result = TRUE)
p2i_rez
i2e_rez=egvtools::input2egv(input=paste0("./RasterGrids_10m/2024/",
                                         "FarmlandTrees_ShortRotationCoppice_input.tif"),
                            egv_template= "./Templates/TemplateRasters/LV100m_10km.tif",
                            summary_function = "average",
                            missing_job = "FillOutput",
                            outlocation = "./RasterGrids_100m/2024/RAW/",
                            outfilename = "FarmlandTrees_ShortRotationCoppice_cell.tif",
                            layername = "egv_265",
                            idw_weight = 2,
                            plot_gaps = FALSE,plot_final = TRUE)
i2e_rez
rm(p2i_rez)
rm(i2e_rez)
rm(dati)
unlink("./RasterGrids_10m/2024/FarmlandTrees_ShortRotationCoppice_input.tif")

