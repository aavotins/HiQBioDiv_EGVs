# Libs ----
if(!require(egvtools)) {install.packages("egvtools"); require(egvtools)}
if(!require(tidyverse)) {install.packages("tidyverse"); require(tidyverse)}
if(!require(sf)) {install.packages("sf"); require(sf)}
if(!require(arrow)) {install.packages("arrow"); require(arrow)}
if(!require(sfarrow)) {install.packages("sfarrow"); require(sfarrow)}
if(!require(terra)) {install.packages("terra"); require(terra)}
if(!require(readxl)) {install.packages("readxl"); require(readxl)}

# templates ----
template_t=rast("./Templates/TemplateRasters/LV10m_10km.tif")
template_r=raster(template_t)


# general diversity ----

## Farmland broad ----

# classification 
culturecodes=read_excel("./Geodata/2024/LAD/KulturuKodi_2024.xlsx")
culturecodes$kods=as.character(culturecodes$kods)
lad=sfarrow::st_read_parquet("./Geodata/2024/LAD/Lauki_2024.parquet")
lad2=lad %>% 
  left_join(culturecodes, by=c("PRODUCT_CODE"="kods")) %>% 
  mutate(numeric_code=as.numeric(as.factor(SDM_grupa_sakums))+350) %>% 
  filter(!is.na(numeric_code))
table(lad2$numeric_code,useNA = "always")

# input layer
polygon2input(vector_data = lad2,
              template_path = "./Templates/TemplateRasters/LV10m_10km.tif",
              out_path = "./RasterGrids_10m/2024/",
              file_name = "Diversity_FarmlandBroad_only.tif",
              value_field = "numeric_code",
              fun="first",
              prepare=FALSE,
              project_mode = "auto")
# cleaning
rm(culturecodes)
rm(lad)
rm(lad2)


## Forests broad ----

# data
mvr=sfarrow::st_read_parquet("./Geodata/2024/MVR/nogabali_2024janv.parquet")

# species groups
coniferous=c("1","3","13","14","15","22","23") # 7
boreal_deciduous=c("4","6","8","9","19","20","21","32","35","50","68") # 11
temperate_deciduous=c("10","11","12","16","17","18","24","25","26","27","28","29",
            "61","62","63","64","65","66","67","69") # 20

# classification
mvr2=mvr %>% 
  mutate(vol_coniferous=ifelse(s10 %in% coniferous,v10,0)+
           ifelse(s11 %in% coniferous,v11,0)+ifelse(s12 %in% coniferous,v12,0)+
           ifelse(s13 %in% coniferous,v13,0)+ifelse(s14 %in% coniferous,v14,0),
         vol_boreal=ifelse(s10 %in% boreal_deciduous,v10,0)+
           ifelse(s11 %in% boreal_deciduous,v11,0)+ifelse(s12 %in% boreal_deciduous,v12,0)+
           ifelse(s13 %in% boreal_deciduous,v13,0)+ifelse(s14 %in% boreal_deciduous,v14,0),
         vol_temperate=ifelse(s10 %in% temperate_deciduous,v10,0)+
           ifelse(s11 %in% temperate_deciduous,v11,0)+ifelse(s12 %in% temperate_deciduous,v12,0)+
           ifelse(s13 %in% temperate_deciduous,v13,0)+ifelse(s14 %in% temperate_deciduous,v14,0)) %>% 
  mutate(vol_total=vol_coniferous+vol_boreal+vol_temperate) %>% 
  mutate(forest_type=ifelse(vol_coniferous/vol_total>=0.75,"coniferous",
                     ifelse(vol_boreal/vol_total>=0.75,"boreal",
                            ifelse(vol_temperate/vol_total>0.5,"temperate",
                                   "mixed")))) %>% 
  mutate(forest_age=ifelse(vgr=="1"|vgr=="2"|vgr=="3","young",
                           ifelse(vgr=="4"|vgr=="5","old",NA))) %>% 
  filter(!is.na(forest_type)) %>% 
  filter(!is.na(forest_age)) %>% 
  mutate(divbroad_class=paste0(forest_type,"_",forest_age)) %>% 
  mutate(divbroad_numeric=as.numeric(as.factor(divbroad_class))+660) %>% 
  filter(!is.na(divbroad_numeric))

# input layer
polygon2input(vector_data = mvr2,
              template_path = "./Templates/TemplateRasters/LV10m_10km.tif",
              out_path = "./RasterGrids_10m/2024/",
              file_name = "Diversity_ForestBroad_only.tif",
              value_field = "divbroad_numeric",
              fun="first",
              prepare=FALSE,
              project_mode = "auto",
              overwrite = TRUE)
# cleaning
rm(mvr)
rm(mvr2)

## General classification ----

simple_landscape=rast("./RasterGrids_10m/2024/Ainava_vienk_mask.tif")

## Covered classes for general diversity ----

farmland_broad=rast("./RasterGrids_10m/2024/Diversity_FarmlandBroad_only.tif")
forests_broad=rast("./RasterGrids_10m/2024/Diversity_ForestBroad_only.tif")

diversity_classes=cover(farmland_broad,forests_broad)
diversity_classes2=cover(diversity_classes,simple_landscape,
                        filename="./RasterGrids_10m/2024/Diversity_GeneralLandscapeBroad.tif",
                        overwrite=TRUE)

rm(simple_landscape)
rm(farmland_broad)
rm(forests_broad)
rm(diversity_classes)
rm(diversity_classes2)

## Diversity index at 25ha -----


res_tbl <- landscape_function(
  landscape      = "./RasterGrids_10m/2024/Diversity_GeneralLandscapeBroad.tif",
  zones          = "./Templates/TemplateGrids/tikls500_sauzeme.parquet",
  id_field       = "rinda500",
  tile_field     = "tks50km",
  template       = "./Templates/TemplateRasters/LV500m_10km.tif",
  out_dir        = "./RasterGrids_500m/2024/",
  out_filename   = "Diversity_GeneralLandscape_500x.tif",
  out_layername  = "Diversity_GeneralLandscape_500x",
  what           = "lsm_l_shdi",
  rasterize_engine = "fasterize",
  n_workers      = 8,
  future_max_size = 3 * 1024^3,
  fill_gaps      = TRUE,
  plot_gaps      = TRUE,
  plot_result    = TRUE
)
print(res_tbl)

plot(rast("./RasterGrids_500m/2024/Diversity_GeneralLandscape_500x.tif"))

rm(res_tbl)







# farmland diversity -----


## Farmland broad ----

farmland_broad=rast("./RasterGrids_10m/2024/Diversity_FarmlandBroad_only.tif")


## Farmland codes ----

lad=sfarrow::st_read_parquet("./Geodata/2024/LAD/Lauki_2024.parquet")
lad$product_code=as.numeric(lad$PRODUCT_CODE)+1000

# input layer
polygon2input(vector_data = lad,
              template_path = "./Templates/TemplateRasters/LV10m_10km.tif",
              out_path = "./RasterGrids_10m/2024/",
              file_name = "Diversity_FarmlandCodes_only.tif",
              value_field = "product_code",
              fun="first",
              prepare=FALSE,
              project_mode = "auto",
              overwrite = TRUE)

# cleaning
rm(lad)


## Covered classes for farmland diversity ----

farmland_codes=rast("./RasterGrids_10m/2024/Diversity_FarmlandCodes_only.tif")
farmland_covered=cover(farmland_codes,farmland_broad)
farmland_covered2=cover(farmland_covered,template_t,
                        filename="./RasterGrids_10m/2024/Diversity_FarmlandDetailed.tif",
                        overwrite=TRUE)
plot(farmland_covered2)

# cleaning
rm(farmland_codes)
rm(farmland_covered)
rm(farmland_covered2)
rm(farmland_broad)


## Diversity index at 25ha -----

res_tbl <- landscape_function(
  landscape      = "./RasterGrids_10m/2024/Diversity_FarmlandDetailed.tif",
  zones          = "./Templates/TemplateGrids/tikls500_sauzeme.parquet",
  id_field       = "rinda500",
  tile_field     = "tks50km",
  template       = "./Templates/TemplateRasters/LV500m_10km.tif",
  out_dir        = "./RasterGrids_500m/2024/",
  out_filename   = "Diversity_Farmland_500x.tif",
  out_layername  = "Diversity_Farmland_500x",
  what           = "lsm_l_shdi",
  rasterize_engine = "fasterize",
  n_workers      = 8,
  future_max_size = 3 * 1024^3,
  fill_gaps      = TRUE,
  plot_gaps      = TRUE,
  plot_result    = TRUE
)
print(res_tbl)

plot(rast("./RasterGrids_500m/2024/Diversity_Farmland_500x.tif"))
rm(res_tbl)



# forest diversity ----

## forest broad ----

forest_broad=rast("./RasterGrids_10m/2024/Diversity_ForestBroad_only.tif")


## forest codes ----


# mezi
mvr=st_read_parquet("./Geodata/2024/MVR/nogabali_2024janv.parquet")

mvr=mvr %>% 
  mutate(kods1=as.numeric(s10)*1000,
         kods2=as.numeric(vgr),
         kods=kods1+kods2) %>% 
  filter(!is.na(kods)) %>% 
  filter(kods1>0) %>% 
  filter(kods2>0)

# input layer
polygon2input(vector_data = mvr,
              template_path = "./Templates/TemplateRasters/LV10m_10km.tif",
              out_path = "./RasterGrids_10m/2024/",
              file_name = "Diversity_ForestCodes_only.tif",
              value_field = "kods",
              fun="first",
              prepare=FALSE,
              project_mode = "auto",
              overwrite = TRUE)

# cleaning
rm(mvr)

## Covered classes for forest diversity ----

forest_codes=rast("./RasterGrids_10m/2024/Diversity_ForestCodes_only.tif")
plot(forest_codes)
forest_covered=cover(forest_codes,forest_broad)
plot(forest_covered)

forest_covered2=cover(forest_covered,template_t,
                        filename="./RasterGrids_10m/2024/Diversity_ForestsDetailed.tif",
                        overwrite=TRUE)
plot(forest_covered2)

# cleaning
rm(forest_codes)
rm(forest_covered)
rm(forest_covered2)
rm(forest_broad)



## Diversity index at 25ha -----

res_tbl <- landscape_function(
  landscape      = "./RasterGrids_10m/2024/Diversity_ForestsDetailed.tif",
  zones          = "./Templates/TemplateGrids/tikls500_sauzeme.parquet",
  id_field       = "rinda500",
  tile_field     = "tks50km",
  template       = "./Templates/TemplateRasters/LV500m_10km.tif",
  out_dir        = "./RasterGrids_500m/2024/",
  out_filename   = "Diversity_Forests_500x.tif",
  out_layername  = "Diversity_Forests_500x",
  what           = "lsm_l_shdi",
  rasterize_engine = "fasterize",
  n_workers      = 8,
  future_max_size = 3 * 1024^3,
  fill_gaps      = TRUE,
  plot_gaps      = TRUE,
  plot_result    = TRUE
)
print(res_tbl)

plot(rast("./RasterGrids_500m/2024/Diversity_Forests_500x.tif"))
rm(res_tbl)

