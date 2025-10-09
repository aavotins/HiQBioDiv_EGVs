# libs ----
if(!require(egvtools)) {remotes::install_github("aavotins/egvtools"); require(egvtools)}
if(!require(terra)) {install.packages("terra"); require(terra)}
if(!require(tidyverse)) {install.packages("tidyverse"); require(tidyverse)}

# file and layer names ----
naming=read_csv("./Geodata/2024/CHELSA/CHELSAdownload_rename.csv")
naming=naming %>% 
  filter(todownload==1) %>% 
  mutate(reading=paste0("./Geodata/2024/CHELSA/",localname))



# job ----

for(i in seq_along(naming$layername)){
  print(i)
  localname=naming$localname[i]
  layername=naming$layername[i]
  reading=naming$reading[i]
  print(layername)
  
  df <- downscale2egv(
    template_path = "./Templates/TemplateRasters/LV100m_10km.tif",
    grid_path     = "./Templates/TemplateGrids/tikls1km_sauzeme.parquet",
    rawfile_path  = reading,
    out_path      = "./RasterGrids_100m/2024/RAW/",
    file_name     = localname,
    layer_name    = layername,
    fill_gaps     = TRUE,
    smooth        = TRUE,
    smooth_radius_km = 5,
    plot_result   = TRUE
  )
  print(df)
}
