# libs ----
if(!require(egvtools)) {remotes::install_github("aavotins/egvtools"); require(egvtools)}
if(!require(terra)) {install.packages("terra"); require(terra)}
if(!require(tidyverse)) {install.packages("tidyverse"); require(tidyverse)}
if(!require(sf)) {install.packages("sf"); require(sf)}
if(!require(sfarrow)) {install.packages("sfarrow"); require(sfarrow)}
if(!require(exactextractr)) {install.packages("exactextractr"); require(exactextractr)}

# file and layer names ----
naming=read_csv("./Geodata/2024/HydroClim/HydroClim_renaming.csv")

naming=naming %>% 
  separate_wider_delim(local_name,delim=c("-"),names=c("one","two"),cols_remove=FALSE) %>% 
  separate_wider_delim(two,delim=c("_"),names=c("summary_function","three"),cols_remove=FALSE) %>% 
  dplyr::select(local_name,layername,summary_function)

# basins ----
level12=st_read("./Geodata/2024/HydroClim/hybas_lake_eu_lev01-12_v1c/hybas_lake_eu_lev12_v1c.shp")
grid_1km=sfarrow::st_read_parquet("./Templates/TemplateGrids/tikls1km_sauzeme.parquet")
grid_1km=st_transform(grid_1km,crs=3059)
level12=st_transform(level12,crs=3059)
level12=level12[grid_1km,,]

level12=st_make_valid(level12)

# job ----

for(i in seq_along(naming$local_name)){
  print(i)
  sakums=Sys.time()
  localname=naming$local_name[i]
  layername=naming$layername[i]
  summary_function=naming$summary_function[i]
  
  slanis=rast(paste0("./Geodata/2024/HydroClim/",localname))
  level12$Hydro_values=exact_extract(slanis,level12,fun=summary_function)
  
  polygon2input(vector_data = level12,
                template_path = "./Templates/TemplateRasters/LV10m_10km.tif",
                out_path = "./RasterGrids_10m/2024/",
                file_name = localname,
                value_field = "Hydro_values",
                fun="first",
                value_type = "continuous",
                prepare=FALSE,
                project_mode = "auto",
                check_na = FALSE,
                plot_result=FALSE,
                plot_gaps = FALSE,
                overwrite=TRUE)
  
  egvrez=input2egv(input=paste0("./RasterGrids_10m/2024/",localname),
                   egv_template= "./Templates/TemplateRasters/LV100m_10km.tif",
                   summary_function = "average",
                   missing_job = "FillOutput",
                   input_template = "./Templates/TemplateRasters/LV10m_10km.tif",
                   outlocation = "./RasterGrids_100m/2024/RAW/",
                   outfilename = localname,
                   layername = layername,
                   idw_weight = 2,
                   plot_gaps = FALSE,plot_final = FALSE)
  egvrez
  
  unlink(paste0("./RasterGrids_10m/2024/",localname))
  beigas=Sys.time()
  ilgums=beigas-sakums
  print(ilgums)
}


