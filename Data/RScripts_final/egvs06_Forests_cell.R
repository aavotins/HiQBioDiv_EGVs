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

# mvr ----
mvr=st_read_parquet("./Geodata/2024/MVR/nogabali_2024janv.parquet")
mvr$yes=1

# clear cut mask ----
izcirtumi=mvr %>% 
  filter(zkat %in% c("12","14")) %>% 
  dplyr::select(yes)
r_izcirtumi_mvr=fasterize(izcirtumi,rastrs10,field="yes")
t_izcirtumi_mvr=rast(r_izcirtumi_mvr)
plot(t_izcirtumi_mvr)

tcl=rast("./Geodata/2024/Trees/GFW/TreeCoverLoss_v1_12.tif")
tcl2=ifel(tcl<20,0,1)
tclX=cover(tcl2,nulls10)
plot(tclX)

clearcut_mask=cover(t_izcirtumi_mvr,tclX,
                    filename="./RasterGrids_10m/2024/Mask_clearcuts.tif",
                    overwrite=TRUE)
plot(clearcut_mask)

rm(izcirtumi)
rm(r_izcirtumi_mvr)
rm(t_izcirtumi_mvr)
rm(tcl)
rm(tcl2)
rm(tclX)

# ForestsAge_ClearcutsLowStands_cell.tif	egv_270 ----
zemas_audzes=mvr %>% 
  filter(zkat=="10") %>% 
  filter(h10<5) %>% 
  dplyr::select(yes)
r_zemasaudzes=fasterize(zemas_audzes,rastrs10,field="yes")
t_zemasaudzes=rast(r_zemasaudzes)
plot(t_zemasaudzes)

cleacuts_low=cover(t_zemasaudzes,clearcut_mask)
plot(cleacuts_low)

i2e_rez=egvtools::input2egv(input=cleacuts_low,
                            egv_template= "./Templates/TemplateRasters/LV100m_10km.tif",
                            summary_function = "average",
                            missing_job = "FillOutput",
                            outlocation = "./RasterGrids_100m/2024/RAW/",
                            outfilename = "ForestsAge_ClearcutsLowStands_cell.tif",
                            layername = "egv_270",
                            idw_weight = 2,
                            plot_gaps = FALSE,plot_final = TRUE)
i2e_rez
rm(i2e_rez)
rm(zemas_audzes)
rm(r_zemasaudzes)
rm(t_zemasaudzes)
rm(cleacuts_low)


# ForestsAge_Middle_cell.tif	egv_275 ----
videjas_audzes=mvr %>% 
  filter(zkat=="10") %>% 
  #filter(h10>=5) %>% 
  filter(vgr %in% c("2","3")) %>% 
  dplyr::select(yes)

p2i_rez=egvtools::polygon2input(vector_data = videjas_audzes,
                                template_path = "./Templates/TemplateRasters/LV10m_10km.tif",
                                out_path = "./RasterGrids_10m/2024/",
                                file_name = "ForestsAge_Middle_input.tif",
                                value_field = "yes",
                                restrict_to = clearcut_mask,
                                restrict_values = 0,
                                prepare=FALSE,
                                background_raster = "./Templates/TemplateRasters/nulls_LV10m_10km.tif",
                                plot_result = TRUE)
p2i_rez
i2e_rez=egvtools::input2egv(input=paste0("./RasterGrids_10m/2024/",
                                         "ForestsAge_Middle_input.tif"),
                            egv_template= "./Templates/TemplateRasters/LV100m_10km.tif",
                            summary_function = "average",
                            missing_job = "FillOutput",
                            outlocation = "./RasterGrids_100m/2024/RAW/",
                            outfilename = "ForestsAge_Middle_cell.tif",
                            layername = "egv_275",
                            idw_weight = 2,
                            plot_gaps = FALSE,plot_final = TRUE)
i2e_rez
rm(videjas_audzes)
rm(p2i_rez)
rm(i2e_rez)
unlink("./RasterGrids_10m/2024/ForestsAge_Middle_input.tif")

# ForestsAge_Old_cell.tif	egv_280 ----
vecas=mvr %>% 
  filter(zkat=="10") %>% 
  #filter(h10>=5) %>% 
  filter(vgr %in% c("4","5")) %>% 
  dplyr::select(yes)

p2i_rez=egvtools::polygon2input(vector_data = vecas,
                                template_path = "./Templates/TemplateRasters/LV10m_10km.tif",
                                out_path = "./RasterGrids_10m/2024/",
                                file_name = "ForestsAge_Old_input.tif",
                                value_field = "yes",
                                restrict_to = clearcut_mask,
                                restrict_values = 0,
                                prepare=FALSE,
                                background_raster = "./Templates/TemplateRasters/nulls_LV10m_10km.tif",
                                plot_result = TRUE)
p2i_rez
i2e_rez=egvtools::input2egv(input=paste0("./RasterGrids_10m/2024/",
                                         "ForestsAge_Old_input.tif"),
                            egv_template= "./Templates/TemplateRasters/LV100m_10km.tif",
                            summary_function = "average",
                            missing_job = "FillOutput",
                            outlocation = "./RasterGrids_100m/2024/RAW/",
                            outfilename = "ForestsAge_Old_cell.tif",
                            layername = "egv_280",
                            idw_weight = 2,
                            plot_gaps = FALSE,plot_final = TRUE)
i2e_rez
rm(vecas)
rm(p2i_rez)
rm(i2e_rez)
unlink("./RasterGrids_10m/2024/ForestsAge_Old_input.tif")



# ForestsAge_YoungTallStandsShrubs_cell.tif	egv_285 ----
jaunasaugstas=mvr %>% 
  filter(zkat=="10") %>% 
  filter(h10>=5) %>% 
  filter(vgr %in% c("1")) %>% 
  dplyr::select(yes)
r_jaunasaugstas=fasterize(jaunasaugstas,rastrs10,field="yes")
t_jaunasaugstas=rast(r_jaunasaugstas)
plot(t_jaunasaugstas)

shrubs=ifel(simple_landscape==620,1,0)

younshrubs=cover(t_jaunasaugstas,shrubs)
plot(younshrubs)

younshrubs2=ifel(younshrubs==1&clearcut_mask==0,1,0)
plot(younshrubs2)

i2e_rez=egvtools::input2egv(input=younshrubs2,
                            egv_template= "./Templates/TemplateRasters/LV100m_10km.tif",
                            summary_function = "average",
                            missing_job = "FillOutput",
                            outlocation = "./RasterGrids_100m/2024/RAW/",
                            outfilename = "ForestsAge_YoungTallStandsShrubs_cell.tif",
                            layername = "egv_285",
                            idw_weight = 2,
                            plot_gaps = FALSE,plot_final = TRUE)
i2e_rez
rm(jaunasaugstas)
rm(r_jaunasaugstas)
rm(t_jaunasaugstas)
rm(shrubs)
rm(younshrubs)
rm(younshrubs2)
rm(i2e_rez)


# ForestsSoil_EutrophicDrained_cell.tif	egv_308 ----
EutrophicDrained=mvr %>% 
  filter(mt %in% c("19","21","24","25"))
p2i_rez=egvtools::polygon2input(vector_data = EutrophicDrained,
                                template_path = "./Templates/TemplateRasters/LV10m_10km.tif",
                                out_path = "./RasterGrids_10m/2024/",
                                file_name = "ForestsSoil_EutrophicDrained_input.tif",
                                value_field = "yes",
                                prepare=FALSE,
                                background_raster = "./Templates/TemplateRasters/nulls_LV10m_10km.tif",
                                plot_result = TRUE)
p2i_rez
i2e_rez=egvtools::input2egv(input=paste0("./RasterGrids_10m/2024/",
                                         "ForestsSoil_EutrophicDrained_input.tif"),
                            egv_template= "./Templates/TemplateRasters/LV100m_10km.tif",
                            summary_function = "average",
                            missing_job = "FillOutput",
                            outlocation = "./RasterGrids_100m/2024/RAW/",
                            outfilename = "ForestsSoil_EutrophicDrained_cell.tif",
                            layername = "egv_308",
                            idw_weight = 2,
                            plot_gaps = FALSE,plot_final = TRUE)
i2e_rez
rm(EutrophicDrained)
rm(p2i_rez)
rm(i2e_rez)
unlink("./RasterGrids_10m/2024/ForestsSoil_EutrophicDrained_input.tif")


# ForestsSoil_EutrophicMineral_cell.tif	egv_313 ----
EutrophicMineral=mvr %>% 
  filter(mt %in% c("5","6","10","11"))
p2i_rez=egvtools::polygon2input(vector_data = EutrophicMineral,
                                template_path = "./Templates/TemplateRasters/LV10m_10km.tif",
                                out_path = "./RasterGrids_10m/2024/",
                                file_name = "ForestsSoil_EutrophicMineral_input.tif",
                                value_field = "yes",
                                prepare=FALSE,
                                background_raster = "./Templates/TemplateRasters/nulls_LV10m_10km.tif",
                                plot_result = TRUE)
p2i_rez
i2e_rez=egvtools::input2egv(input=paste0("./RasterGrids_10m/2024/",
                                         "ForestsSoil_EutrophicMineral_input.tif"),
                            egv_template= "./Templates/TemplateRasters/LV100m_10km.tif",
                            summary_function = "average",
                            missing_job = "FillOutput",
                            outlocation = "./RasterGrids_100m/2024/RAW/",
                            outfilename = "ForestsSoil_EutrophicMineral_cell.tif",
                            layername = "egv_313",
                            idw_weight = 2,
                            plot_gaps = FALSE,plot_final = TRUE)
i2e_rez
rm(EutrophicMineral)
rm(p2i_rez)
rm(i2e_rez)
unlink("./RasterGrids_10m/2024/ForestsSoil_EutrophicMineral_input.tif")


# ForestsSoil_EutrophicOrganic_cell.tif	egv_318 ----
EutrophicOrganic=mvr %>% 
  filter(mt %in% c("15","16"))
p2i_rez=egvtools::polygon2input(vector_data = EutrophicOrganic,
                                template_path = "./Templates/TemplateRasters/LV10m_10km.tif",
                                out_path = "./RasterGrids_10m/2024/",
                                file_name = "ForestsSoil_EutrophicOrganic_input.tif",
                                value_field = "yes",
                                prepare=FALSE,
                                background_raster = "./Templates/TemplateRasters/nulls_LV10m_10km.tif",
                                plot_result = TRUE)
p2i_rez
i2e_rez=egvtools::input2egv(input=paste0("./RasterGrids_10m/2024/",
                                         "ForestsSoil_EutrophicOrganic_input.tif"),
                            egv_template= "./Templates/TemplateRasters/LV100m_10km.tif",
                            summary_function = "average",
                            missing_job = "FillOutput",
                            outlocation = "./RasterGrids_100m/2024/RAW/",
                            outfilename = "ForestsSoil_EutrophicOrganic_cell.tif",
                            layername = "egv_318",
                            idw_weight = 2,
                            plot_gaps = FALSE,plot_final = TRUE)
i2e_rez
rm(EutrophicOrganic)
rm(p2i_rez)
rm(i2e_rez)
unlink("./RasterGrids_10m/2024/ForestsSoil_EutrophicOrganic_input.tif")


# ForestsSoil_MesotrophicMineral_cell.tif	egv_323 ----
MesotrophicMineral=mvr %>% 
  filter(mt %in% c("4","9"))
p2i_rez=egvtools::polygon2input(vector_data = MesotrophicMineral,
                                template_path = "./Templates/TemplateRasters/LV10m_10km.tif",
                                out_path = "./RasterGrids_10m/2024/",
                                file_name = "ForestsSoil_MesotrophicMineral_input.tif",
                                value_field = "yes",
                                prepare=FALSE,
                                background_raster = "./Templates/TemplateRasters/nulls_LV10m_10km.tif",
                                plot_result = TRUE)
p2i_rez
i2e_rez=egvtools::input2egv(input=paste0("./RasterGrids_10m/2024/",
                                         "ForestsSoil_MesotrophicMineral_input.tif"),
                            egv_template= "./Templates/TemplateRasters/LV100m_10km.tif",
                            summary_function = "average",
                            missing_job = "FillOutput",
                            outlocation = "./RasterGrids_100m/2024/RAW/",
                            outfilename = "ForestsSoil_MesotrophicMineral_cell.tif",
                            layername = "egv_323",
                            idw_weight = 2,
                            plot_gaps = FALSE,plot_final = TRUE)
i2e_rez
rm(MesotrophicMineral)
rm(p2i_rez)
rm(i2e_rez)
unlink("./RasterGrids_10m/2024/ForestsSoil_MesotrophicMineral_input.tif")


# ForestsSoil_OligotrophicDrained_cell.tif	egv_328 ----
OligotrophicDrained=mvr %>% 
  filter(mt %in% c("17","18","22","23"))
p2i_rez=egvtools::polygon2input(vector_data = OligotrophicDrained,
                                template_path = "./Templates/TemplateRasters/LV10m_10km.tif",
                                out_path = "./RasterGrids_10m/2024/",
                                file_name = "ForestsSoil_OligotrophicDrained_input.tif",
                                value_field = "yes",
                                prepare=FALSE,
                                background_raster = "./Templates/TemplateRasters/nulls_LV10m_10km.tif",
                                plot_result = TRUE)
p2i_rez
i2e_rez=egvtools::input2egv(input=paste0("./RasterGrids_10m/2024/",
                                         "ForestsSoil_OligotrophicDrained_input.tif"),
                            egv_template= "./Templates/TemplateRasters/LV100m_10km.tif",
                            summary_function = "average",
                            missing_job = "FillOutput",
                            outlocation = "./RasterGrids_100m/2024/RAW/",
                            outfilename = "ForestsSoil_OligotrophicDrained_cell.tif",
                            layername = "egv_328",
                            idw_weight = 2,
                            plot_gaps = FALSE,plot_final = TRUE)
i2e_rez
rm(OligotrophicDrained)
rm(p2i_rez)
rm(i2e_rez)
unlink("./RasterGrids_10m/2024/ForestsSoil_OligotrophicDrained_input.tif")


# ForestsSoil_OligotrophicMineral_cell.tif	egv_333 ----
OligotrophicMineral=mvr %>% 
  filter(mt %in% c("1","2","3","7","8"))
p2i_rez=egvtools::polygon2input(vector_data = OligotrophicMineral,
                                template_path = "./Templates/TemplateRasters/LV10m_10km.tif",
                                out_path = "./RasterGrids_10m/2024/",
                                file_name = "ForestsSoil_OligotrophicMineral_input.tif",
                                value_field = "yes",
                                prepare=FALSE,
                                background_raster = "./Templates/TemplateRasters/nulls_LV10m_10km.tif",
                                plot_result = TRUE)
p2i_rez
i2e_rez=egvtools::input2egv(input=paste0("./RasterGrids_10m/2024/",
                                         "ForestsSoil_OligotrophicMineral_input.tif"),
                            egv_template= "./Templates/TemplateRasters/LV100m_10km.tif",
                            summary_function = "average",
                            missing_job = "FillOutput",
                            outlocation = "./RasterGrids_100m/2024/RAW/",
                            outfilename = "ForestsSoil_OligotrophicMineral_cell.tif",
                            layername = "egv_333",
                            idw_weight = 2,
                            plot_gaps = FALSE,plot_final = TRUE)
i2e_rez
rm(OligotrophicMineral)
rm(p2i_rez)
rm(i2e_rez)
unlink("./RasterGrids_10m/2024/ForestsSoil_OligotrophicMineral_input.tif")


# ForestsSoil_OligotrophicOrganic_cell.tif	egv_338 ----
OligotrophicOrganic=mvr %>% 
  filter(mt %in% c("12","14"))
p2i_rez=egvtools::polygon2input(vector_data = OligotrophicOrganic,
                                template_path = "./Templates/TemplateRasters/LV10m_10km.tif",
                                out_path = "./RasterGrids_10m/2024/",
                                file_name = "ForestsSoil_OligotrophicOrganic_input.tif",
                                value_field = "yes",
                                prepare=FALSE,
                                background_raster = "./Templates/TemplateRasters/nulls_LV10m_10km.tif",
                                plot_result = TRUE)
p2i_rez
i2e_rez=egvtools::input2egv(input=paste0("./RasterGrids_10m/2024/",
                                         "ForestsSoil_OligotrophicOrganic_input.tif"),
                            egv_template= "./Templates/TemplateRasters/LV100m_10km.tif",
                            summary_function = "average",
                            missing_job = "FillOutput",
                            outlocation = "./RasterGrids_100m/2024/RAW/",
                            outfilename = "ForestsSoil_OligotrophicOrganic_cell.tif",
                            layername = "egv_338",
                            idw_weight = 2,
                            plot_gaps = FALSE,plot_final = TRUE)
i2e_rez
rm(OligotrophicOrganic)
rm(p2i_rez)
rm(i2e_rez)
unlink("./RasterGrids_10m/2024/ForestsSoil_OligotrophicOrganic_input.tif")


# ForestsTreesAge_BorealDeciduousOld_cell.tif	egv_343 ----
skujkoki=c("1","3","13","14","15","22","23") # 7
saurlapji=c("4","6","8","9","19","20","21","32","35","50","68") # 11
platlapji=c("10","11","12","16","17","18","24","25","26","27","28","29",
            "61","62","63","64","65","66","67","69") # 20
mvr=mvr %>% 
  mutate(kraja_skujkoku=ifelse(s10 %in% skujkoki,v10,0)+
           ifelse(s11 %in% skujkoki,v11,0)+ifelse(s12 %in% skujkoki,v12,0)+
           ifelse(s13 %in% skujkoki,v13,0)+ifelse(s14 %in% skujkoki,v14,0),
         kraja_saurlapju=ifelse(s10 %in% saurlapji,v10,0)+
           ifelse(s11 %in% saurlapji,v11,0)+ifelse(s12 %in% saurlapji,v12,0)+
           ifelse(s13 %in% saurlapji,v13,0)+ifelse(s14 %in% saurlapji,v14,0),
         kraja_platlapju=ifelse(s10 %in% platlapji,v10,0)+
           ifelse(s11 %in% platlapji,v11,0)+ifelse(s12 %in% platlapji,v12,0)+
           ifelse(s13 %in% platlapji,v13,0)+ifelse(s14 %in% platlapji,v14,0)) %>% 
  mutate(kopeja_kraja=kraja_skujkoku+kraja_platlapju+kraja_saurlapju) %>% 
  mutate(tips=ifelse(kraja_skujkoku/kopeja_kraja>=0.75,"skujkoku",
                     ifelse(kraja_saurlapju/kopeja_kraja>=0.75,"saurlapju",
                            ifelse(kraja_platlapju/kopeja_kraja>0.5,"platlapju",
                                   "jauktu koku"))))
nogabali=mvr %>% 
  filter(zkat=="10"&tips=="saurlapju"&(vgr=="4"|vgr=="5"))

p2i_rez=egvtools::polygon2input(vector_data = nogabali,
                                template_path = "./Templates/TemplateRasters/LV10m_10km.tif",
                                out_path = "./RasterGrids_10m/2024/",
                                file_name = "ForestsTreesAge_BorealDeciduousOld_input.tif",
                                value_field = "yes",
                                restrict_to = clearcut_mask,
                                restrict_values = 0,
                                prepare=FALSE,
                                background_raster = "./Templates/TemplateRasters/nulls_LV10m_10km.tif",
                                plot_result = TRUE)
p2i_rez
i2e_rez=egvtools::input2egv(input=paste0("./RasterGrids_10m/2024/",
                                         "ForestsTreesAge_BorealDeciduousOld_input.tif"),
                            egv_template= "./Templates/TemplateRasters/LV100m_10km.tif",
                            summary_function = "average",
                            missing_job = "FillOutput",
                            outlocation = "./RasterGrids_100m/2024/RAW/",
                            outfilename = "ForestsTreesAge_BorealDeciduousOld_cell.tif",
                            layername = "egv_343",
                            idw_weight = 2,
                            plot_gaps = FALSE,plot_final = TRUE)
i2e_rez
rm(nogabali)
rm(p2i_rez)
rm(i2e_rez)
unlink("./RasterGrids_10m/2024/ForestsTreesAge_BorealDeciduousOld_input.tif")



# ForestsTreesAge_BorealDeciduousYoung_cell.tif	egv_348 ----
skujkoki=c("1","3","13","14","15","22","23") # 7
saurlapji=c("4","6","8","9","19","20","21","32","35","50","68") # 11
platlapji=c("10","11","12","16","17","18","24","25","26","27","28","29",
            "61","62","63","64","65","66","67","69") # 20
mvr=mvr %>% 
  mutate(kraja_skujkoku=ifelse(s10 %in% skujkoki,v10,0)+
           ifelse(s11 %in% skujkoki,v11,0)+ifelse(s12 %in% skujkoki,v12,0)+
           ifelse(s13 %in% skujkoki,v13,0)+ifelse(s14 %in% skujkoki,v14,0),
         kraja_saurlapju=ifelse(s10 %in% saurlapji,v10,0)+
           ifelse(s11 %in% saurlapji,v11,0)+ifelse(s12 %in% saurlapji,v12,0)+
           ifelse(s13 %in% saurlapji,v13,0)+ifelse(s14 %in% saurlapji,v14,0),
         kraja_platlapju=ifelse(s10 %in% platlapji,v10,0)+
           ifelse(s11 %in% platlapji,v11,0)+ifelse(s12 %in% platlapji,v12,0)+
           ifelse(s13 %in% platlapji,v13,0)+ifelse(s14 %in% platlapji,v14,0)) %>% 
  mutate(kopeja_kraja=kraja_skujkoku+kraja_platlapju+kraja_saurlapju) %>% 
  mutate(tips=ifelse(kraja_skujkoku/kopeja_kraja>=0.75,"skujkoku",
                     ifelse(kraja_saurlapju/kopeja_kraja>=0.75,"saurlapju",
                            ifelse(kraja_platlapju/kopeja_kraja>0.5,"platlapju",
                                   "jauktu koku"))))
nogabali=mvr %>% 
  filter(zkat=="10"&tips=="saurlapju"&(vgr=="1"|vgr=="2"|vgr=="3"))

p2i_rez=egvtools::polygon2input(vector_data = nogabali,
                                template_path = "./Templates/TemplateRasters/LV10m_10km.tif",
                                out_path = "./RasterGrids_10m/2024/",
                                file_name = "ForestsTreesAge_BorealDeciduousYoung_input.tif",
                                value_field = "yes",
                                restrict_to = clearcut_mask,
                                restrict_values = 0,
                                prepare=FALSE,
                                background_raster = "./Templates/TemplateRasters/nulls_LV10m_10km.tif",
                                plot_result = TRUE)
p2i_rez
i2e_rez=egvtools::input2egv(input=paste0("./RasterGrids_10m/2024/",
                                         "ForestsTreesAge_BorealDeciduousYoung_input.tif"),
                            egv_template= "./Templates/TemplateRasters/LV100m_10km.tif",
                            summary_function = "average",
                            missing_job = "FillOutput",
                            outlocation = "./RasterGrids_100m/2024/RAW/",
                            outfilename = "ForestsTreesAge_BorealDeciduousYoung_cell.tif",
                            layername = "egv_348",
                            idw_weight = 2,
                            plot_gaps = FALSE,plot_final = TRUE)
i2e_rez
rm(nogabali)
rm(p2i_rez)
rm(i2e_rez)
unlink("./RasterGrids_10m/2024/ForestsTreesAge_BorealDeciduousYoung_input.tif")


# ForestsTreesAge_ConiferousOld_cell.tif	egv_353 ----
skujkoki=c("1","3","13","14","15","22","23") # 7
saurlapji=c("4","6","8","9","19","20","21","32","35","50","68") # 11
platlapji=c("10","11","12","16","17","18","24","25","26","27","28","29",
            "61","62","63","64","65","66","67","69") # 20
mvr=mvr %>% 
  mutate(kraja_skujkoku=ifelse(s10 %in% skujkoki,v10,0)+
           ifelse(s11 %in% skujkoki,v11,0)+ifelse(s12 %in% skujkoki,v12,0)+
           ifelse(s13 %in% skujkoki,v13,0)+ifelse(s14 %in% skujkoki,v14,0),
         kraja_saurlapju=ifelse(s10 %in% saurlapji,v10,0)+
           ifelse(s11 %in% saurlapji,v11,0)+ifelse(s12 %in% saurlapji,v12,0)+
           ifelse(s13 %in% saurlapji,v13,0)+ifelse(s14 %in% saurlapji,v14,0),
         kraja_platlapju=ifelse(s10 %in% platlapji,v10,0)+
           ifelse(s11 %in% platlapji,v11,0)+ifelse(s12 %in% platlapji,v12,0)+
           ifelse(s13 %in% platlapji,v13,0)+ifelse(s14 %in% platlapji,v14,0)) %>% 
  mutate(kopeja_kraja=kraja_skujkoku+kraja_platlapju+kraja_saurlapju) %>% 
  mutate(tips=ifelse(kraja_skujkoku/kopeja_kraja>=0.75,"skujkoku",
                     ifelse(kraja_saurlapju/kopeja_kraja>=0.75,"saurlapju",
                            ifelse(kraja_platlapju/kopeja_kraja>0.5,"platlapju",
                                   "jauktu koku"))))
nogabali=mvr %>% 
  filter(zkat=="10"&tips=="skujkoku"&(vgr=="4"|vgr=="5"))

p2i_rez=egvtools::polygon2input(vector_data = nogabali,
                                template_path = "./Templates/TemplateRasters/LV10m_10km.tif",
                                out_path = "./RasterGrids_10m/2024/",
                                file_name = "ForestsTreesAge_ConiferousOld_input.tif",
                                value_field = "yes",
                                restrict_to = clearcut_mask,
                                restrict_values = 0,
                                prepare=FALSE,
                                background_raster = "./Templates/TemplateRasters/nulls_LV10m_10km.tif",
                                plot_result = TRUE)
p2i_rez
i2e_rez=egvtools::input2egv(input=paste0("./RasterGrids_10m/2024/",
                                         "ForestsTreesAge_ConiferousOld_input.tif"),
                            egv_template= "./Templates/TemplateRasters/LV100m_10km.tif",
                            summary_function = "average",
                            missing_job = "FillOutput",
                            outlocation = "./RasterGrids_100m/2024/RAW/",
                            outfilename = "ForestsTreesAge_ConiferousOld_cell.tif",
                            layername = "egv_353",
                            idw_weight = 2,
                            plot_gaps = FALSE,plot_final = TRUE)
i2e_rez
rm(nogabali)
rm(p2i_rez)
rm(i2e_rez)
unlink("./RasterGrids_10m/2024/ForestsTreesAge_ConiferousOld_input.tif")


# ForestsTreesAge_ConiferousYoung_cell.tif	egv_358 ----
skujkoki=c("1","3","13","14","15","22","23") # 7
saurlapji=c("4","6","8","9","19","20","21","32","35","50","68") # 11
platlapji=c("10","11","12","16","17","18","24","25","26","27","28","29",
            "61","62","63","64","65","66","67","69") # 20
mvr=mvr %>% 
  mutate(kraja_skujkoku=ifelse(s10 %in% skujkoki,v10,0)+
           ifelse(s11 %in% skujkoki,v11,0)+ifelse(s12 %in% skujkoki,v12,0)+
           ifelse(s13 %in% skujkoki,v13,0)+ifelse(s14 %in% skujkoki,v14,0),
         kraja_saurlapju=ifelse(s10 %in% saurlapji,v10,0)+
           ifelse(s11 %in% saurlapji,v11,0)+ifelse(s12 %in% saurlapji,v12,0)+
           ifelse(s13 %in% saurlapji,v13,0)+ifelse(s14 %in% saurlapji,v14,0),
         kraja_platlapju=ifelse(s10 %in% platlapji,v10,0)+
           ifelse(s11 %in% platlapji,v11,0)+ifelse(s12 %in% platlapji,v12,0)+
           ifelse(s13 %in% platlapji,v13,0)+ifelse(s14 %in% platlapji,v14,0)) %>% 
  mutate(kopeja_kraja=kraja_skujkoku+kraja_platlapju+kraja_saurlapju) %>% 
  mutate(tips=ifelse(kraja_skujkoku/kopeja_kraja>=0.75,"skujkoku",
                     ifelse(kraja_saurlapju/kopeja_kraja>=0.75,"saurlapju",
                            ifelse(kraja_platlapju/kopeja_kraja>0.5,"platlapju",
                                   "jauktu koku"))))
nogabali=mvr %>% 
  filter(zkat=="10"&tips=="skujkoku"&(vgr=="1"|vgr=="2"|vgr=="3"))

p2i_rez=egvtools::polygon2input(vector_data = nogabali,
                                template_path = "./Templates/TemplateRasters/LV10m_10km.tif",
                                out_path = "./RasterGrids_10m/2024/",
                                file_name = "ForestsTreesAge_ConiferousYoung_input.tif",
                                value_field = "yes",
                                restrict_to = clearcut_mask,
                                restrict_values = 0,
                                prepare=FALSE,
                                background_raster = "./Templates/TemplateRasters/nulls_LV10m_10km.tif",
                                plot_result = TRUE)
p2i_rez
i2e_rez=egvtools::input2egv(input=paste0("./RasterGrids_10m/2024/",
                                         "ForestsTreesAge_ConiferousYoung_input.tif"),
                            egv_template= "./Templates/TemplateRasters/LV100m_10km.tif",
                            summary_function = "average",
                            missing_job = "FillOutput",
                            outlocation = "./RasterGrids_100m/2024/RAW/",
                            outfilename = "ForestsTreesAge_ConiferousYoung_cell.tif",
                            layername = "egv_358",
                            idw_weight = 2,
                            plot_gaps = FALSE,plot_final = TRUE)
i2e_rez
rm(nogabali)
rm(p2i_rez)
rm(i2e_rez)
unlink("./RasterGrids_10m/2024/ForestsTreesAge_ConiferousYoung_input.tif")


# ForestsTreesAge_MixedOld_cell.tif	egv_363 ----
skujkoki=c("1","3","13","14","15","22","23") # 7
saurlapji=c("4","6","8","9","19","20","21","32","35","50","68") # 11
platlapji=c("10","11","12","16","17","18","24","25","26","27","28","29",
            "61","62","63","64","65","66","67","69") # 20
mvr=mvr %>% 
  mutate(kraja_skujkoku=ifelse(s10 %in% skujkoki,v10,0)+
           ifelse(s11 %in% skujkoki,v11,0)+ifelse(s12 %in% skujkoki,v12,0)+
           ifelse(s13 %in% skujkoki,v13,0)+ifelse(s14 %in% skujkoki,v14,0),
         kraja_saurlapju=ifelse(s10 %in% saurlapji,v10,0)+
           ifelse(s11 %in% saurlapji,v11,0)+ifelse(s12 %in% saurlapji,v12,0)+
           ifelse(s13 %in% saurlapji,v13,0)+ifelse(s14 %in% saurlapji,v14,0),
         kraja_platlapju=ifelse(s10 %in% platlapji,v10,0)+
           ifelse(s11 %in% platlapji,v11,0)+ifelse(s12 %in% platlapji,v12,0)+
           ifelse(s13 %in% platlapji,v13,0)+ifelse(s14 %in% platlapji,v14,0)) %>% 
  mutate(kopeja_kraja=kraja_skujkoku+kraja_platlapju+kraja_saurlapju) %>% 
  mutate(tips=ifelse(kraja_skujkoku/kopeja_kraja>=0.75,"skujkoku",
                     ifelse(kraja_saurlapju/kopeja_kraja>=0.75,"saurlapju",
                            ifelse(kraja_platlapju/kopeja_kraja>0.5,"platlapju",
                                   "jauktu koku"))))
nogabali=mvr %>% 
  filter(zkat=="10"&tips=="jauktu koku"&(vgr=="4"|vgr=="5"))

p2i_rez=egvtools::polygon2input(vector_data = nogabali,
                                template_path = "./Templates/TemplateRasters/LV10m_10km.tif",
                                out_path = "./RasterGrids_10m/2024/",
                                file_name = "ForestsTreesAge_MixedOld_input.tif",
                                value_field = "yes",
                                restrict_to = clearcut_mask,
                                restrict_values = 0,
                                prepare=FALSE,
                                background_raster = "./Templates/TemplateRasters/nulls_LV10m_10km.tif",
                                plot_result = TRUE)
p2i_rez
i2e_rez=egvtools::input2egv(input=paste0("./RasterGrids_10m/2024/",
                                         "ForestsTreesAge_MixedOld_input.tif"),
                            egv_template= "./Templates/TemplateRasters/LV100m_10km.tif",
                            summary_function = "average",
                            missing_job = "FillOutput",
                            outlocation = "./RasterGrids_100m/2024/RAW/",
                            outfilename = "ForestsTreesAge_MixedOld_cell.tif",
                            layername = "egv_363",
                            idw_weight = 2,
                            plot_gaps = FALSE,plot_final = TRUE)
i2e_rez
rm(nogabali)
rm(p2i_rez)
rm(i2e_rez)
unlink("./RasterGrids_10m/2024/ForestsTreesAge_MixedOld_input.tif")


# ForestsTreesAge_MixedYoung_cell.tif	egv_368 ----
skujkoki=c("1","3","13","14","15","22","23") # 7
saurlapji=c("4","6","8","9","19","20","21","32","35","50","68") # 11
platlapji=c("10","11","12","16","17","18","24","25","26","27","28","29",
            "61","62","63","64","65","66","67","69") # 20
mvr=mvr %>% 
  mutate(kraja_skujkoku=ifelse(s10 %in% skujkoki,v10,0)+
           ifelse(s11 %in% skujkoki,v11,0)+ifelse(s12 %in% skujkoki,v12,0)+
           ifelse(s13 %in% skujkoki,v13,0)+ifelse(s14 %in% skujkoki,v14,0),
         kraja_saurlapju=ifelse(s10 %in% saurlapji,v10,0)+
           ifelse(s11 %in% saurlapji,v11,0)+ifelse(s12 %in% saurlapji,v12,0)+
           ifelse(s13 %in% saurlapji,v13,0)+ifelse(s14 %in% saurlapji,v14,0),
         kraja_platlapju=ifelse(s10 %in% platlapji,v10,0)+
           ifelse(s11 %in% platlapji,v11,0)+ifelse(s12 %in% platlapji,v12,0)+
           ifelse(s13 %in% platlapji,v13,0)+ifelse(s14 %in% platlapji,v14,0)) %>% 
  mutate(kopeja_kraja=kraja_skujkoku+kraja_platlapju+kraja_saurlapju) %>% 
  mutate(tips=ifelse(kraja_skujkoku/kopeja_kraja>=0.75,"skujkoku",
                     ifelse(kraja_saurlapju/kopeja_kraja>=0.75,"saurlapju",
                            ifelse(kraja_platlapju/kopeja_kraja>0.5,"platlapju",
                                   "jauktu koku"))))
nogabali=mvr %>% 
  filter(zkat=="10"&tips=="jauktu koku"&(vgr=="1"|vgr=="2"|vgr=="3"))

p2i_rez=egvtools::polygon2input(vector_data = nogabali,
                                template_path = "./Templates/TemplateRasters/LV10m_10km.tif",
                                out_path = "./RasterGrids_10m/2024/",
                                file_name = "ForestsTreesAge_MixedYoung_input.tif",
                                value_field = "yes",
                                restrict_to = clearcut_mask,
                                restrict_values = 0,
                                prepare=FALSE,
                                background_raster = "./Templates/TemplateRasters/nulls_LV10m_10km.tif",
                                plot_result = TRUE)
p2i_rez
i2e_rez=egvtools::input2egv(input=paste0("./RasterGrids_10m/2024/",
                                         "ForestsTreesAge_MixedYoung_input.tif"),
                            egv_template= "./Templates/TemplateRasters/LV100m_10km.tif",
                            summary_function = "average",
                            missing_job = "FillOutput",
                            outlocation = "./RasterGrids_100m/2024/RAW/",
                            outfilename = "ForestsTreesAge_MixedYoung_cell.tif",
                            layername = "egv_368",
                            idw_weight = 2,
                            plot_gaps = FALSE,plot_final = TRUE)
i2e_rez
rm(nogabali)
rm(p2i_rez)
rm(i2e_rez)
unlink("./RasterGrids_10m/2024/ForestsTreesAge_MixedYoung_input.tif")


# ForestsTreesAge_TemperateDeciduousOld_cell.tif	egv_373 ----
skujkoki=c("1","3","13","14","15","22","23") # 7
saurlapji=c("4","6","8","9","19","20","21","32","35","50","68") # 11
platlapji=c("10","11","12","16","17","18","24","25","26","27","28","29",
            "61","62","63","64","65","66","67","69") # 20
mvr=mvr %>% 
  mutate(kraja_skujkoku=ifelse(s10 %in% skujkoki,v10,0)+
           ifelse(s11 %in% skujkoki,v11,0)+ifelse(s12 %in% skujkoki,v12,0)+
           ifelse(s13 %in% skujkoki,v13,0)+ifelse(s14 %in% skujkoki,v14,0),
         kraja_saurlapju=ifelse(s10 %in% saurlapji,v10,0)+
           ifelse(s11 %in% saurlapji,v11,0)+ifelse(s12 %in% saurlapji,v12,0)+
           ifelse(s13 %in% saurlapji,v13,0)+ifelse(s14 %in% saurlapji,v14,0),
         kraja_platlapju=ifelse(s10 %in% platlapji,v10,0)+
           ifelse(s11 %in% platlapji,v11,0)+ifelse(s12 %in% platlapji,v12,0)+
           ifelse(s13 %in% platlapji,v13,0)+ifelse(s14 %in% platlapji,v14,0)) %>% 
  mutate(kopeja_kraja=kraja_skujkoku+kraja_platlapju+kraja_saurlapju) %>% 
  mutate(tips=ifelse(kraja_skujkoku/kopeja_kraja>=0.75,"skujkoku",
                     ifelse(kraja_saurlapju/kopeja_kraja>=0.75,"saurlapju",
                            ifelse(kraja_platlapju/kopeja_kraja>0.5,"platlapju",
                                   "jauktu koku"))))
nogabali=mvr %>% 
  filter(zkat=="10"&tips=="platlapju"&(vgr=="4"|vgr=="5"))

p2i_rez=egvtools::polygon2input(vector_data = nogabali,
                                template_path = "./Templates/TemplateRasters/LV10m_10km.tif",
                                out_path = "./RasterGrids_10m/2024/",
                                file_name = "ForestsTreesAge_TemperateDeciduousOld_input.tif",
                                value_field = "yes",
                                restrict_to = clearcut_mask,
                                restrict_values = 0,
                                prepare=FALSE,
                                background_raster = "./Templates/TemplateRasters/nulls_LV10m_10km.tif",
                                plot_result = TRUE)
p2i_rez
i2e_rez=egvtools::input2egv(input=paste0("./RasterGrids_10m/2024/",
                                         "ForestsTreesAge_TemperateDeciduousOld_input.tif"),
                            egv_template= "./Templates/TemplateRasters/LV100m_10km.tif",
                            summary_function = "average",
                            missing_job = "FillOutput",
                            outlocation = "./RasterGrids_100m/2024/RAW/",
                            outfilename = "ForestsTreesAge_TemperateDeciduousOld_cell.tif",
                            layername = "egv_373",
                            idw_weight = 2,
                            plot_gaps = FALSE,plot_final = TRUE)
i2e_rez
rm(nogabali)
rm(p2i_rez)
rm(i2e_rez)
unlink("./RasterGrids_10m/2024/ForestsTreesAge_TemperateDeciduousOld_input.tif")


# ForestsTreesAge_TemperateDeciduousYoung_cell.tif	egv_378 ----
skujkoki=c("1","3","13","14","15","22","23") # 7
saurlapji=c("4","6","8","9","19","20","21","32","35","50","68") # 11
platlapji=c("10","11","12","16","17","18","24","25","26","27","28","29",
            "61","62","63","64","65","66","67","69") # 20
mvr=mvr %>% 
  mutate(kraja_skujkoku=ifelse(s10 %in% skujkoki,v10,0)+
           ifelse(s11 %in% skujkoki,v11,0)+ifelse(s12 %in% skujkoki,v12,0)+
           ifelse(s13 %in% skujkoki,v13,0)+ifelse(s14 %in% skujkoki,v14,0),
         kraja_saurlapju=ifelse(s10 %in% saurlapji,v10,0)+
           ifelse(s11 %in% saurlapji,v11,0)+ifelse(s12 %in% saurlapji,v12,0)+
           ifelse(s13 %in% saurlapji,v13,0)+ifelse(s14 %in% saurlapji,v14,0),
         kraja_platlapju=ifelse(s10 %in% platlapji,v10,0)+
           ifelse(s11 %in% platlapji,v11,0)+ifelse(s12 %in% platlapji,v12,0)+
           ifelse(s13 %in% platlapji,v13,0)+ifelse(s14 %in% platlapji,v14,0)) %>% 
  mutate(kopeja_kraja=kraja_skujkoku+kraja_platlapju+kraja_saurlapju) %>% 
  mutate(tips=ifelse(kraja_skujkoku/kopeja_kraja>=0.75,"skujkoku",
                     ifelse(kraja_saurlapju/kopeja_kraja>=0.75,"saurlapju",
                            ifelse(kraja_platlapju/kopeja_kraja>0.5,"platlapju",
                                   "jauktu koku"))))
nogabali=mvr %>% 
  filter(zkat=="10"&tips=="platlapju"&(vgr=="1"|vgr=="2"|vgr=="3"))

p2i_rez=egvtools::polygon2input(vector_data = nogabali,
                                template_path = "./Templates/TemplateRasters/LV10m_10km.tif",
                                out_path = "./RasterGrids_10m/2024/",
                                file_name = "ForestsTreesAge_TemperateDeciduousYoung_input.tif",
                                value_field = "yes",
                                restrict_to = clearcut_mask,
                                restrict_values = 0,
                                prepare=FALSE,
                                background_raster = "./Templates/TemplateRasters/nulls_LV10m_10km.tif",
                                plot_result = TRUE)
p2i_rez
i2e_rez=egvtools::input2egv(input=paste0("./RasterGrids_10m/2024/",
                                         "ForestsTreesAge_TemperateDeciduousYoung_input.tif"),
                            egv_template= "./Templates/TemplateRasters/LV100m_10km.tif",
                            summary_function = "average",
                            missing_job = "FillOutput",
                            outlocation = "./RasterGrids_100m/2024/RAW/",
                            outfilename = "ForestsTreesAge_TemperateDeciduousYoung_cell.tif",
                            layername = "egv_378",
                            idw_weight = 2,
                            plot_gaps = FALSE,plot_final = TRUE)
i2e_rez
rm(nogabali)
rm(p2i_rez)
rm(i2e_rez)
unlink("./RasterGrids_10m/2024/ForestsTreesAge_TemperateDeciduousYoung_input.tif")


# ForestsTrees_BorealDeciduous_cell.tif	egv_383 ----
skujkoki=c("1","3","13","14","15","22","23") # 7
saurlapji=c("4","6","8","9","19","20","21","32","35","50","68") # 11
platlapji=c("10","11","12","16","17","18","24","25","26","27","28","29",
            "61","62","63","64","65","66","67","69") # 20
mvr=mvr %>% 
  mutate(kraja_skujkoku=ifelse(s10 %in% skujkoki,v10,0)+
           ifelse(s11 %in% skujkoki,v11,0)+ifelse(s12 %in% skujkoki,v12,0)+
           ifelse(s13 %in% skujkoki,v13,0)+ifelse(s14 %in% skujkoki,v14,0),
         kraja_saurlapju=ifelse(s10 %in% saurlapji,v10,0)+
           ifelse(s11 %in% saurlapji,v11,0)+ifelse(s12 %in% saurlapji,v12,0)+
           ifelse(s13 %in% saurlapji,v13,0)+ifelse(s14 %in% saurlapji,v14,0),
         kraja_platlapju=ifelse(s10 %in% platlapji,v10,0)+
           ifelse(s11 %in% platlapji,v11,0)+ifelse(s12 %in% platlapji,v12,0)+
           ifelse(s13 %in% platlapji,v13,0)+ifelse(s14 %in% platlapji,v14,0)) %>% 
  mutate(kopeja_kraja=kraja_skujkoku+kraja_platlapju+kraja_saurlapju) %>% 
  mutate(tips=ifelse(kraja_skujkoku/kopeja_kraja>=0.75,"skujkoku",
                     ifelse(kraja_saurlapju/kopeja_kraja>=0.75,"saurlapju",
                            ifelse(kraja_platlapju/kopeja_kraja>0.5,"platlapju",
                                   "jauktu koku"))))
nogabali=mvr %>% 
  filter(zkat=="10"&tips=="saurlapju")

p2i_rez=egvtools::polygon2input(vector_data = nogabali,
                                template_path = "./Templates/TemplateRasters/LV10m_10km.tif",
                                out_path = "./RasterGrids_10m/2024/",
                                file_name = "ForestsTrees_BorealDeciduous_input.tif",
                                value_field = "yes",
                                restrict_to = clearcut_mask,
                                restrict_values = 0,
                                prepare=FALSE,
                                background_raster = "./Templates/TemplateRasters/nulls_LV10m_10km.tif",
                                plot_result = TRUE)
p2i_rez
i2e_rez=egvtools::input2egv(input=paste0("./RasterGrids_10m/2024/",
                                         "ForestsTrees_BorealDeciduous_input.tif"),
                            egv_template= "./Templates/TemplateRasters/LV100m_10km.tif",
                            summary_function = "average",
                            missing_job = "FillOutput",
                            outlocation = "./RasterGrids_100m/2024/RAW/",
                            outfilename = "ForestsTrees_BorealDeciduous_cell.tif",
                            layername = "egv_383",
                            idw_weight = 2,
                            plot_gaps = FALSE,plot_final = TRUE)
i2e_rez
rm(nogabali)
rm(p2i_rez)
rm(i2e_rez)
unlink("./RasterGrids_10m/2024/ForestsTrees_BorealDeciduous_input.tif")


# ForestsTrees_Coniferous_cell.tif	egv_388 ----
skujkoki=c("1","3","13","14","15","22","23") # 7
saurlapji=c("4","6","8","9","19","20","21","32","35","50","68") # 11
platlapji=c("10","11","12","16","17","18","24","25","26","27","28","29",
            "61","62","63","64","65","66","67","69") # 20
mvr=mvr %>% 
  mutate(kraja_skujkoku=ifelse(s10 %in% skujkoki,v10,0)+
           ifelse(s11 %in% skujkoki,v11,0)+ifelse(s12 %in% skujkoki,v12,0)+
           ifelse(s13 %in% skujkoki,v13,0)+ifelse(s14 %in% skujkoki,v14,0),
         kraja_saurlapju=ifelse(s10 %in% saurlapji,v10,0)+
           ifelse(s11 %in% saurlapji,v11,0)+ifelse(s12 %in% saurlapji,v12,0)+
           ifelse(s13 %in% saurlapji,v13,0)+ifelse(s14 %in% saurlapji,v14,0),
         kraja_platlapju=ifelse(s10 %in% platlapji,v10,0)+
           ifelse(s11 %in% platlapji,v11,0)+ifelse(s12 %in% platlapji,v12,0)+
           ifelse(s13 %in% platlapji,v13,0)+ifelse(s14 %in% platlapji,v14,0)) %>% 
  mutate(kopeja_kraja=kraja_skujkoku+kraja_platlapju+kraja_saurlapju) %>% 
  mutate(tips=ifelse(kraja_skujkoku/kopeja_kraja>=0.75,"skujkoku",
                     ifelse(kraja_saurlapju/kopeja_kraja>=0.75,"saurlapju",
                            ifelse(kraja_platlapju/kopeja_kraja>0.5,"platlapju",
                                   "jauktu koku"))))
nogabali=mvr %>% 
  filter(zkat=="10"&tips=="skujkoku")

p2i_rez=egvtools::polygon2input(vector_data = nogabali,
                                template_path = "./Templates/TemplateRasters/LV10m_10km.tif",
                                out_path = "./RasterGrids_10m/2024/",
                                file_name = "ForestsTrees_Coniferous_input.tif",
                                value_field = "yes",
                                restrict_to = clearcut_mask,
                                restrict_values = 0,
                                prepare=FALSE,
                                background_raster = "./Templates/TemplateRasters/nulls_LV10m_10km.tif",
                                plot_result = TRUE)
p2i_rez
i2e_rez=egvtools::input2egv(input=paste0("./RasterGrids_10m/2024/",
                                         "ForestsTrees_Coniferous_input.tif"),
                            egv_template= "./Templates/TemplateRasters/LV100m_10km.tif",
                            summary_function = "average",
                            missing_job = "FillOutput",
                            outlocation = "./RasterGrids_100m/2024/RAW/",
                            outfilename = "ForestsTrees_Coniferous_cell.tif",
                            layername = "egv_388",
                            idw_weight = 2,
                            plot_gaps = FALSE,plot_final = TRUE)
i2e_rez
rm(nogabali)
rm(p2i_rez)
rm(i2e_rez)
unlink("./RasterGrids_10m/2024/ForestsTrees_Coniferous_input.tif")


# ForestsTrees_Mixed_cell.tif	egv_393 ----
skujkoki=c("1","3","13","14","15","22","23") # 7
saurlapji=c("4","6","8","9","19","20","21","32","35","50","68") # 11
platlapji=c("10","11","12","16","17","18","24","25","26","27","28","29",
            "61","62","63","64","65","66","67","69") # 20
mvr=mvr %>% 
  mutate(kraja_skujkoku=ifelse(s10 %in% skujkoki,v10,0)+
           ifelse(s11 %in% skujkoki,v11,0)+ifelse(s12 %in% skujkoki,v12,0)+
           ifelse(s13 %in% skujkoki,v13,0)+ifelse(s14 %in% skujkoki,v14,0),
         kraja_saurlapju=ifelse(s10 %in% saurlapji,v10,0)+
           ifelse(s11 %in% saurlapji,v11,0)+ifelse(s12 %in% saurlapji,v12,0)+
           ifelse(s13 %in% saurlapji,v13,0)+ifelse(s14 %in% saurlapji,v14,0),
         kraja_platlapju=ifelse(s10 %in% platlapji,v10,0)+
           ifelse(s11 %in% platlapji,v11,0)+ifelse(s12 %in% platlapji,v12,0)+
           ifelse(s13 %in% platlapji,v13,0)+ifelse(s14 %in% platlapji,v14,0)) %>% 
  mutate(kopeja_kraja=kraja_skujkoku+kraja_platlapju+kraja_saurlapju) %>% 
  mutate(tips=ifelse(kraja_skujkoku/kopeja_kraja>=0.75,"skujkoku",
                     ifelse(kraja_saurlapju/kopeja_kraja>=0.75,"saurlapju",
                            ifelse(kraja_platlapju/kopeja_kraja>0.5,"platlapju",
                                   "jauktu koku"))))
nogabali=mvr %>% 
  filter(zkat=="10"&tips=="jauktu koku")

p2i_rez=egvtools::polygon2input(vector_data = nogabali,
                                template_path = "./Templates/TemplateRasters/LV10m_10km.tif",
                                out_path = "./RasterGrids_10m/2024/",
                                file_name = "ForestsTrees_Mixed_input.tif",
                                value_field = "yes",
                                restrict_to = clearcut_mask,
                                restrict_values = 0,
                                prepare=FALSE,
                                background_raster = "./Templates/TemplateRasters/nulls_LV10m_10km.tif",
                                plot_result = TRUE)
p2i_rez
i2e_rez=egvtools::input2egv(input=paste0("./RasterGrids_10m/2024/",
                                         "ForestsTrees_Mixed_input.tif"),
                            egv_template= "./Templates/TemplateRasters/LV100m_10km.tif",
                            summary_function = "average",
                            missing_job = "FillOutput",
                            outlocation = "./RasterGrids_100m/2024/RAW/",
                            outfilename = "ForestsTrees_Mixed_cell.tif",
                            layername = "egv_393",
                            idw_weight = 2,
                            plot_gaps = FALSE,plot_final = TRUE)
i2e_rez
rm(nogabali)
rm(p2i_rez)
rm(i2e_rez)
unlink("./RasterGrids_10m/2024/ForestsTrees_Mixed_input.tif")


# ForestsTrees_TemperateDeciduous_cell.tif	egv_398 ----
skujkoki=c("1","3","13","14","15","22","23") # 7
saurlapji=c("4","6","8","9","19","20","21","32","35","50","68") # 11
platlapji=c("10","11","12","16","17","18","24","25","26","27","28","29",
            "61","62","63","64","65","66","67","69") # 20
mvr=mvr %>% 
  mutate(kraja_skujkoku=ifelse(s10 %in% skujkoki,v10,0)+
           ifelse(s11 %in% skujkoki,v11,0)+ifelse(s12 %in% skujkoki,v12,0)+
           ifelse(s13 %in% skujkoki,v13,0)+ifelse(s14 %in% skujkoki,v14,0),
         kraja_saurlapju=ifelse(s10 %in% saurlapji,v10,0)+
           ifelse(s11 %in% saurlapji,v11,0)+ifelse(s12 %in% saurlapji,v12,0)+
           ifelse(s13 %in% saurlapji,v13,0)+ifelse(s14 %in% saurlapji,v14,0),
         kraja_platlapju=ifelse(s10 %in% platlapji,v10,0)+
           ifelse(s11 %in% platlapji,v11,0)+ifelse(s12 %in% platlapji,v12,0)+
           ifelse(s13 %in% platlapji,v13,0)+ifelse(s14 %in% platlapji,v14,0)) %>% 
  mutate(kopeja_kraja=kraja_skujkoku+kraja_platlapju+kraja_saurlapju) %>% 
  mutate(tips=ifelse(kraja_skujkoku/kopeja_kraja>=0.75,"skujkoku",
                     ifelse(kraja_saurlapju/kopeja_kraja>=0.75,"saurlapju",
                            ifelse(kraja_platlapju/kopeja_kraja>0.5,"platlapju",
                                   "jauktu koku"))))
nogabali=mvr %>% 
  filter(zkat=="10"&tips=="platlapju")

p2i_rez=egvtools::polygon2input(vector_data = nogabali,
                                template_path = "./Templates/TemplateRasters/LV10m_10km.tif",
                                out_path = "./RasterGrids_10m/2024/",
                                file_name = "ForestsTrees_TemperateDeciduous_input.tif",
                                value_field = "yes",
                                restrict_to = clearcut_mask,
                                restrict_values = 0,
                                prepare=FALSE,
                                background_raster = "./Templates/TemplateRasters/nulls_LV10m_10km.tif",
                                plot_result = TRUE)
p2i_rez
i2e_rez=egvtools::input2egv(input=paste0("./RasterGrids_10m/2024/",
                                         "ForestsTrees_TemperateDeciduous_input.tif"),
                            egv_template= "./Templates/TemplateRasters/LV100m_10km.tif",
                            summary_function = "average",
                            missing_job = "FillOutput",
                            outlocation = "./RasterGrids_100m/2024/RAW/",
                            outfilename = "ForestsTrees_TemperateDeciduous_cell.tif",
                            layername = "egv_398",
                            idw_weight = 2,
                            plot_gaps = FALSE,plot_final = TRUE)
i2e_rez
rm(nogabali)
rm(p2i_rez)
rm(i2e_rez)
unlink("./RasterGrids_10m/2024/ForestsTrees_TemperateDeciduous_input.tif")


