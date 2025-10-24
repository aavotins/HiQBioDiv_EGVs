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

# clearcut mask ----
clearcut_mask=rast("./RasterGrids_10m/2024/Mask_clearcuts.tif")
plot(clearcut_mask)

# mvr ----
mvr=st_read_parquet("./Geodata/2024/MVR/nogabali_2024janv.parquet")


## tree species groups ----
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


# ForestsQuant_AgeProp-average_cell.tif	egv_290 ----

#Meža likums, 9. pants. https://likumi.lv/ta/id/2825#p9
ozoli=c("10","61")
priedes_lapegles=c("1","13","14","22")
eolgvk=c("3","15","23","11","64","12","62","16","65","24","63")
berzi=c("4")
melnalksni=c("6")
apses=c("8","19","68")

bonA=c("0","1")
bonB=c("2","3")
bonC=c("4","5","6")
bonAB=c("0","1","2","3")

nogabali=mvr %>% 
  mutate(cirtmets=ifelse((s10 %in% ozoli)&(bon %in% bonA),101,
                         ifelse((s10 %in% ozoli),121,NA))) %>% 
  mutate(cirtmets=ifelse((s10 %in% priedes_lapegles)&(bon %in% bonAB),101,
                         ifelse((s10 %in% priedes_lapegles),121,cirtmets))) %>% 
  mutate(cirtmets=ifelse((s10 %in% eolgvk),81,cirtmets)) %>% 
  mutate(cirtmets=ifelse((s10 %in% berzi)&(bon %in% bonAB),71,
                         ifelse((s10 %in% berzi),51,cirtmets))) %>% 
  mutate(cirtmets=ifelse((s10 %in% melnalksni),71,cirtmets))  %>% 
  mutate(cirtmets=ifelse((s10 %in% apses),41,cirtmets))   %>% 
  mutate(cirtmets=ifelse(is.na(cirtmets)&zkat=="10",35,cirtmets)) %>% 
  mutate(nogvec=a10/cirtmets) %>% 
  mutate(nogvec2=ifelse(nogvec>3,3,nogvec)) %>% 
  filter(!is.na(nogvec2))

par(mfrow=c(1,2))
options(scipen=999)
hist(nogabali$nogvec,main="Original",xlab="Relative age")
hist(nogabali$nogvec2,main="Limited",xlab="Relative age")
par(mfrow=c(1,1))
options(scipen=0)
# 700*400

p2i_rez=polygon2input(vector_data=nogabali,
                  template_path = "./Templates/TemplateRasters/LV10m_10km.tif",
                  out_path = "./RasterGrids_10m/2024/",
                  file_name = "ForestQuant_AgeProp.tif",
                  value_field = "nogvec2",
                  fun="max",
                  prepare=FALSE,
                  restrict_to = clearcut_mask,
                  restrict_values = 0,
                  plot_result=TRUE)
p2i_rez
i2e_rez=input2egv(input="./RasterGrids_10m/2024/ForestQuant_AgeProp.tif",
                  egv_template = "./Templates/TemplateRasters/LV100m_10km.tif",
                  summary_function = "average",
                  missing_job = "CoverOutput",
                  output_bg = "./Templates/TemplateRasters/nulls_LV100m_10km.tif",
                  outlocation = "./RasterGrids_100m/2024/RAW/",
                  outfilename = "ForestsQuant_AgeProp-average_cell.tif",
                  layername = "egv_290",
                  plot_final=TRUE)
i2e_rez
rm(nogabali)
rm(p2i_rez)
rm(i2e_rez)
unlink("./RasterGrids_10m/2024/ForestQuant_AgeProp.tif")

# ForestsQuant_DominantDiameter-max_cell.tif	egv_291 ----
nogabali=mvr %>% 
  mutate(valddiam=ifelse(d10>70,70,d10)) %>% 
  filter(!is.na(valddiam))

par(mfrow=c(1,2))
options(scipen=999)
hist(nogabali$d10,main="Original",xlab="Dominant diameter")
hist(nogabali$valddiam,main="Limited",xlab="Dominant diameter")
par(mfrow=c(1,1))
options(scipen=0)

p2i_rez=polygon2input(vector_data=nogabali,
                      template_path = "./Templates/TemplateRasters/LV10m_10km.tif",
                      out_path = "./RasterGrids_10m/2024/",
                      file_name = "ForestQuant_DominantDiameter.tif",
                      value_field = "valddiam",
                      fun="max",
                      prepare=FALSE,
                      restrict_to = clearcut_mask,
                      restrict_values = 0,
                      plot_result=TRUE,
                      overwrite=TRUE)
p2i_rez
i2e_rez=input2egv(input="./RasterGrids_10m/2024/ForestQuant_DominantDiameter.tif",
                  egv_template = "./Templates/TemplateRasters/LV100m_10km.tif",
                  summary_function = "max",
                  missing_job = "CoverOutput",
                  output_bg = "./Templates/TemplateRasters/nulls_LV100m_10km.tif",
                  outlocation = "./RasterGrids_100m/2024/RAW/",
                  outfilename = "ForestsQuant_DominantDiameter-max_cell.tif",
                  layername = "egv_291",
                  plot_final=TRUE)
i2e_rez
rm(p2i_rez)
rm(nogabali)
rm(i2e_rez)
unlink("./RasterGrids_10m/2024/ForestQuant_DominantDiameter.tif")



# ForestsQuant_LargestDiameter-max_cell.tif	egv_292 ----
nogabali=mvr %>%
  rowwise() %>% 
  mutate(maxDiam=max(c(d10,d11,d12,d13,d14,d22,d23,d24),na.rm=TRUE)) %>% 
  ungroup() %>% 
  mutate(maxDiam2=ifelse(maxDiam>100,100,maxDiam)) %>% 
  filter(!is.na(maxDiam2))

par(mfrow=c(1,2))
options(scipen=999)
hist(nogabali$maxDiam,main="Original",xlab="Largest diameter")
hist(nogabali$maxDiam2,main="Limited",xlab="Largest diameter")
par(mfrow=c(1,1))
options(scipen=0)

p2i_rez=polygon2input(vector_data=nogabali,
                      template_path = "./Templates/TemplateRasters/LV10m_10km.tif",
                      out_path = "./RasterGrids_10m/2024/",
                      file_name = "ForestsQuant_LargestDiameter.tif",
                      value_field = "maxDiam2",
                      fun="max",
                      prepare=FALSE,
                      restrict_to = clearcut_mask,
                      restrict_values = 0,
                      plot_result=TRUE,
                      overwrite=TRUE)
p2i_rez
i2e_rez=input2egv(input="./RasterGrids_10m/2024/ForestsQuant_LargestDiameter.tif",
                  egv_template = "./Templates/TemplateRasters/LV100m_10km.tif",
                  summary_function = "max",
                  missing_job = "CoverOutput",
                  output_bg = "./Templates/TemplateRasters/nulls_LV100m_10km.tif",
                  outlocation = "./RasterGrids_100m/2024/RAW/",
                  outfilename = "ForestsQuant_LargestDiameter-max_cell.tif",
                  layername = "egv_292",
                  plot_final=TRUE)
i2e_rez
rm(p2i_rez)
rm(nogabali)
rm(i2e_rez)
unlink("./RasterGrids_10m/2024/ForestsQuant_LargestDiameter.tif")


# ForestsQuant_TimeSinceDisturbance-average_cell.tif	egv_293 ----
nogabali=mvr %>% 
  mutate(new_PDG=ifelse(p_darbg>2024,NA,
                        ifelse(p_darbv %in% c("1","4","5","6","7","10","11"),p_darbg,NA)),
         new_PDG2=ifelse(new_PDG<1500,NA,new_PDG),
         new_PCG=ifelse(p_cirg>2024,NA,p_cirg),
         new_PCG2=ifelse(new_PCG<1500,NA,new_PCG),
         vecumam=ifelse(a10==0,NA,a10),
         new_PCG3=2024-new_PCG2,
         new_PDG3=2024-new_PDG2) %>% 
  rowwise() %>% 
  mutate(Laikam=min(c(vecumam,new_PDG3,new_PCG3),na.rm=TRUE)) %>% 
  ungroup() %>% 
  mutate(KopsTraucejuma=ifelse(is.infinite(Laikam),NA,Laikam)) %>% 
  mutate(KopsTraucejuma2=ifelse(KopsTraucejuma>200,200,KopsTraucejuma)) %>% 
  filter(!is.na(KopsTraucejuma2))

par(mfrow=c(1,2))
options(scipen=999)
hist(nogabali$KopsTraucejuma,main="Original",xlab="Time since disturbance")
hist(nogabali$KopsTraucejuma2,main="Limited",xlab="Time since disturbance")
par(mfrow=c(1,1))
options(scipen=0)

mvr_trauclaiks=fasterize::fasterize(nogabali,rastrs10,field="KopsTraucejuma2",fun = "min")
t_MVRtrauclaiks=rast(mvr_trauclaiks)
plot(t_MVRtrauclaiks)

gfw=rast("./Geodata/2024/Trees/GFW/TreeCoverLoss_v1_12.tif")
plot(gfw)
gfw2=ifel(gfw>=0,24-gfw,NA)
plot(gfw2)


# No ainavas:
## Mežaudzes un koki = 50
## Krūmāji un parki = 5
## pārējais = 0
aizpildisanai=ifel(simple_landscape==630|simple_landscape==640,50,
                   ifel(simple_landscape==620,5,0))
freq(aizpildisanai)

trauclaiks1=terra::app(c(gfw2,t_MVRtrauclaiks),fun="min",na.rm=TRUE)
plot(trauclaiks1)
trauclaiks2=cover(trauclaiks1,aizpildisanai)
plot(trauclaiks2)

i2e_rez=input2egv(input=trauclaiks2,
                  egv_template = "./Templates/TemplateRasters/LV100m_10km.tif",
                  summary_function = "average",
                  missing_job = "FillOutput",
                  idw_weight = 2,
                  outlocation = "./RasterGrids_100m/2024/RAW/",
                  outfilename = "ForestsQuant_TimeSinceDisturbance-average_cell.tif",
                  layername = "egv_293",
                  plot_final=TRUE)
i2e_rez
rm(nogabali)
rm(mvr_trauclaiks)
rm(t_MVRtrauclaiks)
rm(gfw)
rm(gfw2)
rm(aizpildisanai)
rm(trauclaiks1)
rm(trauclaiks2)
rm(i2e_rez)


# ForestsQuant_VolumeAspen-sum_cell.tif	egv_294 ----

apses=c("8","19","68")
nogabali=mvr %>% 
  mutate(ApsuKraja=ifelse(s10 %in% apses, v10, 0)+ifelse(s11 %in% apses,v11,0)+
           ifelse(s12 %in% apses, v12,0)+ifelse(s13 %in% apses,v13,0)+
           ifelse(s14 %in% apses, v14,0)) %>% 
  mutate(ApsuKraja2=ApsuKraja/10000*10*10) %>% 
  mutate(ApsuKraja3=ifelse(ApsuKraja2>5,5,ApsuKraja2)) %>% 
  filter(!is.na(ApsuKraja2))


par(mfrow=c(1,2))
options(scipen=999)
hist(nogabali$ApsuKraja2,main="Original",xlab="Aspen volume")
hist(nogabali$ApsuKraja3,main="Limited",xlab="Aspen volume")
par(mfrow=c(1,1))
options(scipen=0)

p2i_rez=polygon2input(vector_data=nogabali,
                      template_path = "./Templates/TemplateRasters/LV10m_10km.tif",
                      out_path = "./RasterGrids_10m/2024/",
                      file_name = "ForestsQuant_VolumeAspen.tif",
                      value_field = "ApsuKraja3",
                      fun="max",
                      prepare=FALSE,
                      restrict_to = clearcut_mask,
                      restrict_values = 0,
                      plot_result=TRUE,
                      overwrite=TRUE)
p2i_rez
i2e_rez=input2egv(input="./RasterGrids_10m/2024/ForestsQuant_VolumeAspen.tif",
                  egv_template = "./Templates/TemplateRasters/LV100m_10km.tif",
                  summary_function = "sum",
                  missing_job = "CoverOutput",
                  output_bg = "./Templates/TemplateRasters/nulls_LV100m_10km.tif",
                  outlocation = "./RasterGrids_100m/2024/RAW/",
                  outfilename = "ForestsQuant_VolumeAspen-sum_cell.tif",
                  layername = "egv_294",
                  plot_final=TRUE)
i2e_rez
rm(p2i_rez)
rm(nogabali)
rm(apses)
rm(i2e_rez)
unlink("./RasterGrids_10m/2024/ForestsQuant_VolumeAspen.tif")

# ForestsQuant_VolumeBirch-sum_cell.tif	egv_295 ----

berzi=c("4")
nogabali=mvr %>% 
  mutate(BerzuKraja=ifelse(s10 %in% berzi, v10, 0)+ifelse(s11 %in% berzi,v11,0)+
           ifelse(s12 %in% berzi, v12,0)+ifelse(s13 %in% berzi,v13,0)+
           ifelse(s14 %in% berzi, v14,0)) %>% 
  mutate(BerzuKraja2=BerzuKraja/10000*10*10) %>% 
  mutate(BerzuKraja3=ifelse(BerzuKraja2>5,5,BerzuKraja2)) %>% 
  filter(!is.na(BerzuKraja2))

par(mfrow=c(1,2))
options(scipen=999)
hist(nogabali$BerzuKraja2,main="Original",xlab="Birch volume")
hist(nogabali$BerzuKraja3,main="Limited",xlab="Birch volume")
par(mfrow=c(1,1))
options(scipen=0)

p2i_rez=polygon2input(vector_data=nogabali,
                      template_path = "./Templates/TemplateRasters/LV10m_10km.tif",
                      out_path = "./RasterGrids_10m/2024/",
                      file_name = "ForestsQuant_VolumeBirch.tif",
                      value_field = "BerzuKraja3",
                      fun="max",
                      prepare=FALSE,
                      restrict_to = clearcut_mask,
                      restrict_values = 0,
                      plot_result=TRUE,
                      overwrite=TRUE)
p2i_rez
i2e_rez=input2egv(input="./RasterGrids_10m/2024/ForestsQuant_VolumeBirch.tif",
                  egv_template = "./Templates/TemplateRasters/LV100m_10km.tif",
                  summary_function = "sum",
                  missing_job = "CoverOutput",
                  output_bg = "./Templates/TemplateRasters/nulls_LV100m_10km.tif",
                  outlocation = "./RasterGrids_100m/2024/RAW/",
                  outfilename = "ForestsQuant_VolumeBirch-sum_cell.tif",
                  layername = "egv_295",
                  plot_final=TRUE)
i2e_rez
rm(p2i_rez)
rm(nogabali)
rm(berzi)
rm(i2e_rez)
unlink("./RasterGrids_10m/2024/ForestsQuant_VolumeBirch.tif")




# ForestsQuant_VolumeBlackAlder-sum_cell.tif	egv_296 ----

melnalksni=c("6")
nogabali=mvr %>% 
  mutate(MeKraja=ifelse(s10 %in% melnalksni, v10, 0)+ifelse(s11 %in% melnalksni,v11,0)+
           ifelse(s12 %in% melnalksni, v12,0)+ifelse(s13 %in% melnalksni,v13,0)+
           ifelse(s14 %in% melnalksni, v14,0)) %>% 
  mutate(MeKraja2=MeKraja/10000*10*10) %>% 
  mutate(MeKraja3=ifelse(MeKraja2>4,4,MeKraja2)) %>% 
  filter(!is.na(MeKraja2))

par(mfrow=c(1,2))
options(scipen=999)
hist(nogabali$MeKraja2,main="Original",xlab="Black alder volume")
hist(nogabali$MeKraja3,main="Limited",xlab="Black alder volume")
par(mfrow=c(1,1))
options(scipen=0)

p2i_rez=polygon2input(vector_data=nogabali,
                      template_path = "./Templates/TemplateRasters/LV10m_10km.tif",
                      out_path = "./RasterGrids_10m/2024/",
                      file_name = "ForestsQuant_VolumeBlackAlder.tif",
                      value_field = "MeKraja3",
                      fun="max",
                      prepare=FALSE,
                      restrict_to = clearcut_mask,
                      restrict_values = 0,
                      plot_result=TRUE,
                      overwrite=TRUE)
p2i_rez
i2e_rez=input2egv(input="./RasterGrids_10m/2024/ForestsQuant_VolumeBlackAlder.tif",
                  egv_template = "./Templates/TemplateRasters/LV100m_10km.tif",
                  summary_function = "sum",
                  missing_job = "CoverOutput",
                  output_bg = "./Templates/TemplateRasters/nulls_LV100m_10km.tif",
                  outlocation = "./RasterGrids_100m/2024/RAW/",
                  outfilename = "ForestsQuant_VolumeBlackAlder-sum_cell.tif",
                  layername = "egv_296",
                  plot_final=TRUE)
i2e_rez
rm(p2i_rez)
rm(nogabali)
rm(melnalksni)
rm(i2e_rez)
unlink("./RasterGrids_10m/2024/ForestsQuant_VolumeBlackAlder.tif")




# ForestsQuant_VolumeBorealDeciduousOther-sum_cell.tif	egv_297 ----

sl_citi=c("9","20","21","32","35","50")
nogabali=mvr %>% 
  mutate(SaurlapjuCKraja=ifelse(s10 %in% sl_citi, v10, 0)+ifelse(s11 %in% sl_citi,v11,0)+
           ifelse(s12 %in% sl_citi, v12,0)+ifelse(s13 %in% sl_citi,v13,0)+
           ifelse(s14 %in% sl_citi, v14,0)) %>% 
  mutate(SaurlapjuCKraja2=SaurlapjuCKraja/10000*10*10) %>% 
  mutate(SaurlapjuCKraja3=ifelse(SaurlapjuCKraja2>3,3,SaurlapjuCKraja2)) %>% 
  filter(!is.na(SaurlapjuCKraja2))

par(mfrow=c(1,2))
options(scipen=999)
hist(nogabali$SaurlapjuCKraja2,main="Original",xlab="Other boreal deciduous volume")
hist(nogabali$SaurlapjuCKraja3,main="Limited",xlab="Other boreal deciduous volume")
par(mfrow=c(1,1))
options(scipen=0)

p2i_rez=polygon2input(vector_data=nogabali,
                      template_path = "./Templates/TemplateRasters/LV10m_10km.tif",
                      out_path = "./RasterGrids_10m/2024/",
                      file_name = "ForestsQuant_VolumeBorealDeciduousOther.tif",
                      value_field = "SaurlapjuCKraja3",
                      fun="max",
                      prepare=FALSE,
                      restrict_to = clearcut_mask,
                      restrict_values = 0,
                      plot_result=TRUE,
                      overwrite=TRUE)
p2i_rez
i2e_rez=input2egv(input="./RasterGrids_10m/2024/ForestsQuant_VolumeBorealDeciduousOther.tif",
                  egv_template = "./Templates/TemplateRasters/LV100m_10km.tif",
                  summary_function = "sum",
                  missing_job = "CoverOutput",
                  output_bg = "./Templates/TemplateRasters/nulls_LV100m_10km.tif",
                  outlocation = "./RasterGrids_100m/2024/RAW/",
                  outfilename = "ForestsQuant_VolumeBorealDeciduousOther-sum_cell.tif",
                  layername = "egv_297",
                  plot_final=TRUE)
i2e_rez
rm(p2i_rez)
rm(nogabali)
rm(sl_citi)
rm(i2e_rez)
unlink("./RasterGrids_10m/2024/ForestsQuant_VolumeBorealDeciduousOther.tif")



# ForestsQuant_VolumeBorealDeciduousTotal-sum_cell.tif	egv_298 ----

sl_visi=c("4","6","8","9","19","20","21","32","35","50","68")
nogabali=mvr %>% 
  mutate(SaurlapjuVKraja=ifelse(s10 %in% sl_visi, v10, 0)+ifelse(s11 %in% sl_visi,v11,0)+
           ifelse(s12 %in% sl_visi, v12,0)+ifelse(s13 %in% sl_visi,v13,0)+
           ifelse(s14 %in% sl_visi, v14,0)) %>% 
  mutate(SaurlapjuVKraja2=SaurlapjuVKraja/10000*10*10) %>% 
  mutate(SaurlapjuVKraja3=ifelse(SaurlapjuVKraja2>6,6,SaurlapjuVKraja2)) %>% 
  filter(!is.na(SaurlapjuVKraja2))

par(mfrow=c(1,2))
options(scipen=999)
hist(nogabali$SaurlapjuVKraja2,main="Original",xlab="All boreal deciduous volume")
hist(nogabali$SaurlapjuVKraja3,main="Limited",xlab="All boreal deciduous volume")
par(mfrow=c(1,1))
options(scipen=0)

p2i_rez=polygon2input(vector_data=nogabali,
                      template_path = "./Templates/TemplateRasters/LV10m_10km.tif",
                      out_path = "./RasterGrids_10m/2024/",
                      file_name = "ForestsQuant_VolumeBorealDeciduousTotal.tif",
                      value_field = "SaurlapjuVKraja3",
                      fun="max",
                      prepare=FALSE,
                      restrict_to = clearcut_mask,
                      restrict_values = 0,
                      plot_result=TRUE,
                      overwrite=TRUE)
p2i_rez
i2e_rez=input2egv(input="./RasterGrids_10m/2024/ForestsQuant_VolumeBorealDeciduousTotal.tif",
                  egv_template = "./Templates/TemplateRasters/LV100m_10km.tif",
                  summary_function = "sum",
                  missing_job = "CoverOutput",
                  output_bg = "./Templates/TemplateRasters/nulls_LV100m_10km.tif",
                  outlocation = "./RasterGrids_100m/2024/RAW/",
                  outfilename = "ForestsQuant_VolumeBorealDeciduousTotal-sum_cell.tif",
                  layername = "egv_298",
                  plot_final=TRUE)
i2e_rez
rm(p2i_rez)
rm(nogabali)
rm(sl_visi)
rm(i2e_rez)
unlink("./RasterGrids_10m/2024/ForestsQuant_VolumeBorealDeciduousTotal.tif")



# ForestsQuant_VolumeConiferous-sum_cell.tif	egv_299 ----

skujkoki=c("1","14","22","3","13","15","23")
nogabali=mvr %>% 
  mutate(SkujkokuKraja=ifelse(s10 %in% skujkoki, v10, 0)+ifelse(s11 %in% skujkoki,v11,0)+
           ifelse(s12 %in% skujkoki, v12,0)+ifelse(s13 %in% skujkoki,v13,0)+
           ifelse(s14 %in% skujkoki, v14,0)) %>% 
  mutate(SkujkokuKraja2=SkujkokuKraja/10000*10*10) %>% 
  mutate(SkujkokuKraja3=ifelse(SkujkokuKraja2>7,7,SkujkokuKraja2)) %>% 
  filter(!is.na(SkujkokuKraja2))

par(mfrow=c(1,2))
options(scipen=999)
hist(nogabali$SkujkokuKraja2,main="Original",xlab="Coniferous volume")
hist(nogabali$SkujkokuKraja3,main="Limited",xlab="Coniferous volume")
par(mfrow=c(1,1))
options(scipen=0)

p2i_rez=polygon2input(vector_data=nogabali,
                      template_path = "./Templates/TemplateRasters/LV10m_10km.tif",
                      out_path = "./RasterGrids_10m/2024/",
                      file_name = "ForestsQuant_VolumeConiferous.tif",
                      value_field = "SkujkokuKraja3",
                      fun="max",
                      prepare=FALSE,
                      restrict_to = clearcut_mask,
                      restrict_values = 0,
                      plot_result=TRUE,
                      overwrite=TRUE)
p2i_rez
i2e_rez=input2egv(input="./RasterGrids_10m/2024/ForestsQuant_VolumeConiferous.tif",
                  egv_template = "./Templates/TemplateRasters/LV100m_10km.tif",
                  summary_function = "sum",
                  missing_job = "CoverOutput",
                  output_bg = "./Templates/TemplateRasters/nulls_LV100m_10km.tif",
                  outlocation = "./RasterGrids_100m/2024/RAW/",
                  outfilename = "ForestsQuant_VolumeConiferous-sum_cell.tif",
                  layername = "egv_299",
                  plot_final=TRUE)
i2e_rez
rm(p2i_rez)
rm(nogabali)
rm(skujkoki)
rm(i2e_rez)
unlink("./RasterGrids_10m/2024/ForestsQuant_VolumeConiferous.tif")



# ForestsQuant_VolumeOak-sum_cell.tif	egv_300 ----
ozoli=c("10","61")
nogabali=mvr %>% 
  mutate(OzoluKraja=ifelse(s10 %in% ozoli, v10, 0)+ifelse(s11 %in% ozoli,v11,0)+
           ifelse(s12 %in% ozoli, v12,0)+ifelse(s13 %in% ozoli,v13,0)+
           ifelse(s14 %in% ozoli, v14,0)) %>% 
  mutate(OzoluKraja2=OzoluKraja/10000*10*10) %>% 
  mutate(OzoluKraja3=ifelse(OzoluKraja2>2,2,OzoluKraja2)) %>% 
  filter(!is.na(OzoluKraja2))

par(mfrow=c(1,2))
options(scipen=999)
hist(nogabali$OzoluKraja2,main="Original",xlab="Oak volume")
hist(nogabali$OzoluKraja3,main="Limited",xlab="Oak volume")
par(mfrow=c(1,1))
options(scipen=0)

p2i_rez=polygon2input(vector_data=nogabali,
                      template_path = "./Templates/TemplateRasters/LV10m_10km.tif",
                      out_path = "./RasterGrids_10m/2024/",
                      file_name = "ForestsQuant_VolumeOak.tif",
                      value_field = "OzoluKraja3",
                      fun="max",
                      prepare=FALSE,
                      restrict_to = clearcut_mask,
                      restrict_values = 0,
                      plot_result=TRUE,
                      overwrite=TRUE)
p2i_rez
i2e_rez=input2egv(input="./RasterGrids_10m/2024/ForestsQuant_VolumeOak.tif",
                  egv_template = "./Templates/TemplateRasters/LV100m_10km.tif",
                  summary_function = "sum",
                  missing_job = "CoverOutput",
                  output_bg = "./Templates/TemplateRasters/nulls_LV100m_10km.tif",
                  outlocation = "./RasterGrids_100m/2024/RAW/",
                  outfilename = "ForestsQuant_VolumeOak-sum_cell.tif",
                  layername = "egv_300",
                  plot_final=TRUE)
i2e_rez
rm(p2i_rez)
rm(nogabali)
rm(ozoli)
rm(i2e_rez)
unlink("./RasterGrids_10m/2024/ForestsQuant_VolumeOak.tif")




# ForestsQuant_VolumeOakMaple-sum_cell.tif	egv_301 ----
ozolklavas=c("10","61","24","63")
nogabali=mvr %>% 
  mutate(OzolKlavuKraja=ifelse(s10 %in% ozolklavas, v10, 0)+ifelse(s11 %in% ozolklavas,v11,0)+
           ifelse(s12 %in% ozolklavas, v12,0)+ifelse(s13 %in% ozolklavas,v13,0)+
           ifelse(s14 %in% ozolklavas, v14,0)) %>% 
  mutate(OzolKlavuKraja2=OzolKlavuKraja/10000*10*10) %>% 
  mutate(OzolKlavuKraja3=ifelse(OzolKlavuKraja2>3,3,OzolKlavuKraja2)) %>% 
  filter(!is.na(OzolKlavuKraja2))

par(mfrow=c(1,2))
options(scipen=999)
hist(nogabali$OzolKlavuKraja2,main="Original",xlab="Oak and maple volume")
hist(nogabali$OzolKlavuKraja3,main="Limited",xlab="Oak and maple volume")
par(mfrow=c(1,1))
options(scipen=0)

p2i_rez=polygon2input(vector_data=nogabali,
                      template_path = "./Templates/TemplateRasters/LV10m_10km.tif",
                      out_path = "./RasterGrids_10m/2024/",
                      file_name = "ForestsQuant_VolumeOakMaple.tif",
                      value_field = "OzolKlavuKraja3",
                      fun="max",
                      prepare=FALSE,
                      restrict_to = clearcut_mask,
                      restrict_values = 0,
                      plot_result=TRUE,
                      overwrite=TRUE)
p2i_rez
i2e_rez=input2egv(input="./RasterGrids_10m/2024/ForestsQuant_VolumeOakMaple.tif",
                  egv_template = "./Templates/TemplateRasters/LV100m_10km.tif",
                  summary_function = "sum",
                  missing_job = "CoverOutput",
                  output_bg = "./Templates/TemplateRasters/nulls_LV100m_10km.tif",
                  outlocation = "./RasterGrids_100m/2024/RAW/",
                  outfilename = "ForestsQuant_VolumeOakMaple-sum_cell.tif",
                  layername = "egv_301",
                  plot_final=TRUE)
i2e_rez
rm(p2i_rez)
rm(nogabali)
rm(ozolklavas)
rm(i2e_rez)
unlink("./RasterGrids_10m/2024/ForestsQuant_VolumeOakMaple.tif")



# ForestsQuant_VolumePine-sum_cell.tif	egv_302 ----

priedes=c("1","14","22")
nogabali=mvr %>% 
  mutate(PriezuKraja=ifelse(s10 %in% priedes, v10, 0)+ifelse(s11 %in% priedes,v11,0)+
           ifelse(s12 %in% priedes, v12,0)+ifelse(s13 %in% priedes,v13,0)+
           ifelse(s14 %in% priedes, v14,0)) %>% 
  mutate(PriezuKraja2=PriezuKraja/10000*10*10) %>% 
  mutate(PriezuKraja3=ifelse(PriezuKraja2>6,6,PriezuKraja2)) %>% 
  filter(!is.na(PriezuKraja2))

par(mfrow=c(1,2))
options(scipen=999)
hist(nogabali$PriezuKraja2,main="Original",xlab="Pine volume")
hist(nogabali$PriezuKraja3,main="Limited",xlab="Pine volume")
par(mfrow=c(1,1))
options(scipen=0)

p2i_rez=polygon2input(vector_data=nogabali,
                      template_path = "./Templates/TemplateRasters/LV10m_10km.tif",
                      out_path = "./RasterGrids_10m/2024/",
                      file_name = "ForestsQuant_VolumePine.tif",
                      value_field = "PriezuKraja3",
                      fun="max",
                      prepare=FALSE,
                      restrict_to = clearcut_mask,
                      restrict_values = 0,
                      plot_result=TRUE,
                      overwrite=TRUE)
p2i_rez
i2e_rez=input2egv(input="./RasterGrids_10m/2024/ForestsQuant_VolumePine.tif",
                  egv_template = "./Templates/TemplateRasters/LV100m_10km.tif",
                  summary_function = "sum",
                  missing_job = "CoverOutput",
                  output_bg = "./Templates/TemplateRasters/nulls_LV100m_10km.tif",
                  outlocation = "./RasterGrids_100m/2024/RAW/",
                  outfilename = "ForestsQuant_VolumePine-sum_cell.tif",
                  layername = "egv_302",
                  plot_final=TRUE)
i2e_rez
rm(p2i_rez)
rm(nogabali)
rm(priedes)
rm(i2e_rez)
unlink("./RasterGrids_10m/2024/ForestsQuant_VolumePine.tif")



# ForestsQuant_VolumeSpruce-sum_cell.tif	egv_303 ----

egles=c("3","13","15","23")
nogabali=mvr %>% 
  mutate(EgluKraja=ifelse(s10 %in% egles, v10, 0)+ifelse(s11 %in% egles,v11,0)+
           ifelse(s12 %in% egles, v12,0)+ifelse(s13 %in% egles,v13,0)+
           ifelse(s14 %in% egles, v14,0)) %>% 
  mutate(EgluKraja2=EgluKraja/10000*10*10) %>% 
  mutate(EgluKraja3=ifelse(EgluKraja2>5,5,EgluKraja2)) %>% 
  filter(!is.na(EgluKraja2))

par(mfrow=c(1,2))
options(scipen=999)
hist(nogabali$EgluKraja2,main="Original",xlab="Spruce volume")
hist(nogabali$EgluKraja3,main="Limited",xlab="Spruce volume")
par(mfrow=c(1,1))
options(scipen=0)

p2i_rez=polygon2input(vector_data=nogabali,
                      template_path = "./Templates/TemplateRasters/LV10m_10km.tif",
                      out_path = "./RasterGrids_10m/2024/",
                      file_name = "ForestsQuant_VolumeSpruce.tif",
                      value_field = "EgluKraja3",
                      fun="max",
                      prepare=FALSE,
                      restrict_to = clearcut_mask,
                      restrict_values = 0,
                      plot_result=TRUE,
                      overwrite=TRUE)
p2i_rez
i2e_rez=input2egv(input="./RasterGrids_10m/2024/ForestsQuant_VolumeSpruce.tif",
                  egv_template = "./Templates/TemplateRasters/LV100m_10km.tif",
                  summary_function = "sum",
                  missing_job = "CoverOutput",
                  output_bg = "./Templates/TemplateRasters/nulls_LV100m_10km.tif",
                  outlocation = "./RasterGrids_100m/2024/RAW/",
                  outfilename = "ForestsQuant_VolumeSpruce-sum_cell.tif",
                  layername = "egv_303",
                  plot_final=TRUE)
i2e_rez
rm(p2i_rez)
rm(nogabali)
rm(egles)
rm(i2e_rez)
unlink("./RasterGrids_10m/2024/ForestsQuant_VolumeSpruce.tif")



# ForestsQuant_VolumeTemperateDeciduousTotal-sum_cell.tif	egv_304 ----

platlapji=c("10","11","12","16","17","18","24","25","26","27","28","29",
            "61","62","63","64","65","66","67","69")
nogabali=mvr %>% 
  mutate(PlatKraja=ifelse(s10 %in% platlapji, v10, 0)+ifelse(s11 %in% platlapji,v11,0)+
           ifelse(s12 %in% platlapji, v12,0)+ifelse(s13 %in% platlapji,v13,0)+
           ifelse(s14 %in% platlapji, v14,0)) %>% 
  mutate(PlatKraja2=PlatKraja/10000*10*10) %>% 
  mutate(PlatKraja3=ifelse(PlatKraja2>4,4,PlatKraja2)) %>% 
  filter(!is.na(PlatKraja2))

par(mfrow=c(1,2))
options(scipen=999)
hist(nogabali$PlatKraja2,main="Original",xlab="Total volume\ntemperate deciduous")
hist(nogabali$PlatKraja3,main="Limited",xlab="Total volume\ntemperate deciduous")
par(mfrow=c(1,1))
options(scipen=0)

p2i_rez=polygon2input(vector_data=nogabali,
                      template_path = "./Templates/TemplateRasters/LV10m_10km.tif",
                      out_path = "./RasterGrids_10m/2024/",
                      file_name = "ForestsQuant_VolumeTemperateDeciduousTotal.tif",
                      value_field = "PlatKraja3",
                      fun="max",
                      prepare=FALSE,
                      restrict_to = clearcut_mask,
                      restrict_values = 0,
                      plot_result=TRUE,
                      overwrite=TRUE)
p2i_rez
i2e_rez=input2egv(input="./RasterGrids_10m/2024/ForestsQuant_VolumeTemperateDeciduousTotal.tif",
                  egv_template = "./Templates/TemplateRasters/LV100m_10km.tif",
                  summary_function = "sum",
                  missing_job = "CoverOutput",
                  output_bg = "./Templates/TemplateRasters/nulls_LV100m_10km.tif",
                  outlocation = "./RasterGrids_100m/2024/RAW/",
                  outfilename = "ForestsQuant_VolumeTemperateDeciduousTotal-sum_cell.tif",
                  layername = "egv_304",
                  plot_final=TRUE)
i2e_rez
rm(p2i_rez)
rm(nogabali)
rm(platlapji)
rm(i2e_rez)
unlink("./RasterGrids_10m/2024/ForestsQuant_VolumeTemperateDeciduousTotal.tif")



# ForestsQuant_VolumeTemperateWithoutOak-sum_cell.tif	egv_305 ----
neozoli=c("11","12","16","17","18","24","25","26","27","28","29",
          "62","63","64","65","66","67","69")
nogabali=mvr %>% 
  mutate(BezOzoluKraja=ifelse(s10 %in% neozoli, v10, 0)+ifelse(s11 %in% neozoli,v11,0)+
           ifelse(s12 %in% neozoli, v12,0)+ifelse(s13 %in% neozoli,v13,0)+
           ifelse(s14 %in% neozoli, v14,0)) %>% 
  mutate(BezOzoluKraja2=BezOzoluKraja/10000*10*10) %>% 
  mutate(BezOzoluKraja3=ifelse(BezOzoluKraja2>3,3,BezOzoluKraja2)) %>% 
  filter(!is.na(BezOzoluKraja2))

par(mfrow=c(1,2))
options(scipen=999)
hist(nogabali$BezOzoluKraja2,main="Original",xlab="Temperate deciduous volume\n without oak")
hist(nogabali$BezOzoluKraja3,main="Limited",xlab="Temperate deciduous volume\nwithout oak")
par(mfrow=c(1,1))
options(scipen=0)

p2i_rez=polygon2input(vector_data=nogabali,
                      template_path = "./Templates/TemplateRasters/LV10m_10km.tif",
                      out_path = "./RasterGrids_10m/2024/",
                      file_name = "ForestsQuant_VolumeTemperateWithoutOak.tif",
                      value_field = "BezOzoluKraja3",
                      fun="max",
                      prepare=FALSE,
                      restrict_to = clearcut_mask,
                      restrict_values = 0,
                      plot_result=TRUE,
                      overwrite=TRUE)
p2i_rez
i2e_rez=input2egv(input="./RasterGrids_10m/2024/ForestsQuant_VolumeTemperateWithoutOak.tif",
                  egv_template = "./Templates/TemplateRasters/LV100m_10km.tif",
                  summary_function = "sum",
                  missing_job = "CoverOutput",
                  output_bg = "./Templates/TemplateRasters/nulls_LV100m_10km.tif",
                  outlocation = "./RasterGrids_100m/2024/RAW/",
                  outfilename = "ForestsQuant_VolumeTemperateWithoutOak-sum_cell.tif",
                  layername = "egv_305",
                  plot_final=TRUE)
i2e_rez
rm(p2i_rez)
rm(nogabali)
rm(neozoli)
rm(i2e_rez)
unlink("./RasterGrids_10m/2024/ForestsQuant_VolumeTemperateWithoutOak.tif")




# ForestsQuant_VolumeTemperateWithoutOakMaple-sum_cell.tif	egv_306 ----
neozolklavas=c("11","12","16","17","18","25","26","27","28","29",
               "62","64","65","66","67","69")
nogabali=mvr %>% 
  mutate(BezOzolKlavuKraja=ifelse(s10 %in% neozolklavas, v10, 0)+ifelse(s11 %in% neozolklavas,v11,0)+
           ifelse(s12 %in% neozolklavas, v12,0)+ifelse(s13 %in% neozolklavas,v13,0)+
           ifelse(s14 %in% neozolklavas, v14,0)) %>% 
  mutate(BezOzolKlavuKraja2=BezOzolKlavuKraja/10000*10*10) %>% 
  mutate(BezOzolKlavuKraja3=ifelse(BezOzolKlavuKraja2>3,3,BezOzolKlavuKraja2)) %>% 
  filter(!is.na(BezOzolKlavuKraja2))

par(mfrow=c(1,2))
options(scipen=999)
hist(nogabali$BezOzolKlavuKraja2,main="Original",xlab="Temperate deciduous volume\n without oak and maple")
hist(nogabali$BezOzolKlavuKraja3,main="Limited",xlab="Temperate deciduous volume\nwithout oak and maple")
par(mfrow=c(1,1))
options(scipen=0)

p2i_rez=polygon2input(vector_data=nogabali,
                      template_path = "./Templates/TemplateRasters/LV10m_10km.tif",
                      out_path = "./RasterGrids_10m/2024/",
                      file_name = "ForestsQuant_VolumeTemperateWithoutOakMaple.tif",
                      value_field = "BezOzolKlavuKraja3",
                      fun="max",
                      prepare=FALSE,
                      restrict_to = clearcut_mask,
                      restrict_values = 0,
                      plot_result=TRUE,
                      overwrite=TRUE)
p2i_rez
i2e_rez=input2egv(input="./RasterGrids_10m/2024/ForestsQuant_VolumeTemperateWithoutOakMaple.tif",
                  egv_template = "./Templates/TemplateRasters/LV100m_10km.tif",
                  summary_function = "sum",
                  missing_job = "CoverOutput",
                  output_bg = "./Templates/TemplateRasters/nulls_LV100m_10km.tif",
                  outlocation = "./RasterGrids_100m/2024/RAW/",
                  outfilename = "ForestsQuant_VolumeTemperateWithoutOakMaple-sum_cell.tif",
                  layername = "egv_306",
                  plot_final=TRUE)
i2e_rez
rm(p2i_rez)
rm(nogabali)
rm(neozolklavas)
rm(i2e_rez)
unlink("./RasterGrids_10m/2024/ForestsQuant_VolumeTemperateWithoutOakMaple.tif")


# ForestsQuant_VolumeTotal-sum_cell.tif	egv_307 ----

nogabali=mvr %>% 
  mutate(KopejaKraja=v10+v11+v12+v13+v14) %>% 
  mutate(KopejaKraja2=KopejaKraja/10000*10*10) %>% 
  mutate(KopejaKraja3=ifelse(KopejaKraja2>8,8,KopejaKraja2)) %>% 
  filter(!is.na(KopejaKraja2))

par(mfrow=c(1,2))
options(scipen=999)
hist(nogabali$KopejaKraja2,main="Original",xlab="Timber volume")
hist(nogabali$KopejaKraja3,main="Limited",xlab="Timber volume")
par(mfrow=c(1,1))
options(scipen=0)

p2i_rez=polygon2input(vector_data=nogabali,
                      template_path = "./Templates/TemplateRasters/LV10m_10km.tif",
                      out_path = "./RasterGrids_10m/2024/",
                      file_name = "ForestsQuant_VolumeTotal.tif",
                      value_field = "KopejaKraja3",
                      fun="max",
                      prepare=FALSE,
                      restrict_to = clearcut_mask,
                      restrict_values = 0,
                      plot_result=TRUE,
                      overwrite=TRUE)
p2i_rez
i2e_rez=input2egv(input="./RasterGrids_10m/2024/ForestsQuant_VolumeTotal.tif",
                  egv_template = "./Templates/TemplateRasters/LV100m_10km.tif",
                  summary_function = "sum",
                  missing_job = "CoverOutput",
                  output_bg = "./Templates/TemplateRasters/nulls_LV100m_10km.tif",
                  outlocation = "./RasterGrids_100m/2024/RAW/",
                  outfilename = "ForestsQuant_VolumeTotal-sum_cell.tif",
                  layername = "egv_307",
                  plot_final=TRUE)
i2e_rez
rm(p2i_rez)
rm(nogabali)
rm(i2e_rez)
unlink("./RasterGrids_10m/2024/ForestsQuant_VolumeTotal.tif")




