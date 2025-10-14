# Libs ----
if(!require(egvtools)) {install.packages("egvtools"); require(egvtools)}
if(!require(terra)) {install.packages("terra"); require(terra)}

# templates ----
template100=rast("./Templates/TemplateRasters/LV100m_10km.tif")


# radii

radius_function(
  kvadrati_path  = "./Templates/TemplateGrids/tiles/",
  radii_path     = "./Templates/TemplateGridPoints/tiles/",
  tikls100_path  = "./Templates/TemplateGrids/tikls100_sauzeme.parquet",
  template_path  = "./Templates/TemplateRasters/LV100m_10km.tif",
  input_layers   = c("./RasterGrids_500m/2024/Diversity_Farmland_500x.tif",
                     "./RasterGrids_500m/2024/Diversity_Forests_500x.tif",
                     "./RasterGrids_500m/2024/Diversity_GeneralLandscape_500x.tif"),
  layer_prefixes = c("Diversity_Farmland",
                     "Diversity_Forest",
                     "Diversity_Total"),
  output_dir     = "./RasterGrids_100m/2024/RAW/",
  n_workers      = 12,
  radii          = c("r500","r1250","r3000","r10000"),
  radius_mode    = "sparse",
  extract_fun    = "mean",
  fill_missing   = TRUE,
  IDW_weight     = 2,
  future_max_size = 5 * 1024^3)




# Diversity_Farmland


# Diversity_Farmland_r500.tif	egv_98
slanis=rast("./RasterGrids_100m/2024/RAW/Diversity_Farmland_r500.tif")
names(slanis)="egv_98"
slanis2=project(slanis,template100)
writeRaster(slanis2,
            "./RasterGrids_100m/2024/RAW/Diversity_Farmland_r500.tif",
            overwrite=TRUE)

# Diversity_Farmland_r1250.tif	egv_99
slanis=rast("./RasterGrids_100m/2024/RAW/Diversity_Farmland_r1250.tif")
names(slanis)="egv_99"
slanis2=project(slanis,template100)
writeRaster(slanis2,
            "./RasterGrids_100m/2024/RAW/Diversity_Farmland_r1250.tif",
            overwrite=TRUE)

# Diversity_Farmland_r3000.tif	egv_100
slanis=rast("./RasterGrids_100m/2024/RAW/Diversity_Farmland_r3000.tif")
names(slanis)="egv_100"
slanis2=project(slanis,template100)
writeRaster(slanis2,
            "./RasterGrids_100m/2024/RAW/Diversity_Farmland_r3000.tif",
            overwrite=TRUE)

# Diversity_Farmland_r10000.tif	egv_101
slanis=rast("./RasterGrids_100m/2024/RAW/Diversity_Farmland_r10000.tif")
names(slanis)="egv_101"
slanis2=project(slanis,template100)
writeRaster(slanis2,
            "./RasterGrids_100m/2024/RAW/Diversity_Farmland_r10000.tif",
            overwrite=TRUE)



# Diversity forests



# Diversity_Forest_r500.tif	egv_102
slanis=rast("./RasterGrids_100m/2024/RAW/Diversity_Forest_r500.tif")
names(slanis)="egv_102"
slanis2=project(slanis,template100)
writeRaster(slanis2,
            "./RasterGrids_100m/2024/RAW/Diversity_Forest_r500.tif",
            overwrite=TRUE)

# Diversity_Forest_r1250.tif	egv_103
slanis=rast("./RasterGrids_100m/2024/RAW/Diversity_Forest_r1250.tif")
names(slanis)="egv_103"
slanis2=project(slanis,template100)
writeRaster(slanis2,
            "./RasterGrids_100m/2024/RAW/Diversity_Forest_r1250.tif",
            overwrite=TRUE)

# Diversity_Forest_r3000.tif	egv_104
slanis=rast("./RasterGrids_100m/2024/RAW/Diversity_Forest_r3000.tif")
names(slanis)="egv_104"
slanis2=project(slanis,template100)
writeRaster(slanis2,
            "./RasterGrids_100m/2024/RAW/Diversity_Forest_r3000.tif",
            overwrite=TRUE)

# Diversity_Forest_r10000.tif	egv_105
slanis=rast("./RasterGrids_100m/2024/RAW/Diversity_Forest_r10000.tif")
names(slanis)="egv_105"
slanis2=project(slanis,template100)
writeRaster(slanis2,
            "./RasterGrids_100m/2024/RAW/Diversity_Forest_r10000.tif",
            overwrite=TRUE)


# Diversity total



# Diversity_Total_r500.tif	egv_106
slanis=rast("./RasterGrids_100m/2024/RAW/Diversity_Total_r500.tif")
names(slanis)="egv_106"
slanis2=project(slanis,template100)
writeRaster(slanis2,
            "./RasterGrids_100m/2024/RAW/Diversity_Total_r500.tif",
            overwrite=TRUE)

# Diversity_Total_r1250.tif	egv_107
slanis=rast("./RasterGrids_100m/2024/RAW/Diversity_Total_r1250.tif")
names(slanis)="egv_107"
slanis2=project(slanis,template100)
writeRaster(slanis2,
            "./RasterGrids_100m/2024/RAW/Diversity_Total_r1250.tif",
            overwrite=TRUE)


# Diversity_Total_r3000.tif	egv_108
slanis=rast("./RasterGrids_100m/2024/RAW/Diversity_Total_r3000.tif")
names(slanis)="egv_108"
slanis2=project(slanis,template100)
writeRaster(slanis2,
            "./RasterGrids_100m/2024/RAW/Diversity_Total_r3000.tif",
            overwrite=TRUE)

# Diversity_Total_r10000.tif	egv_109
slanis=rast("./RasterGrids_100m/2024/RAW/Diversity_Total_r10000.tif")
names(slanis)="egv_109"
slanis2=project(slanis,template100)
writeRaster(slanis2,
            "./RasterGrids_100m/2024/RAW/Diversity_Total_r10000.tif",
            overwrite=TRUE)

