# libs ----
if(!require(terra)) {install.packages("terra"); require(terra)}
if(!require(egvtools)) {remotes::install_github("aavotins/egvtools"); require(egvtools)}

# templates ----
template100=rast("./Templates/TemplateRasters/LV100m_10km.tif")



# Terrain_ASL-average_cell.tif	egv_526
input2egv(input="./Geodata/2024/DEM/mozDEM_10m.tif",
          egv_template="./Templates/TemplateRasters/LV100m_10km.tif",
          summary_function = "average",
          missing_job = "FillOutput",
          idw_weight = 2,
          outlocation = "./RasterGrids_100m/2024/RAW/",
          outfilename = "Terrain_ASL-average_cell.tif",
          layername="egv_526",
          return_visible = TRUE,
          plot_final = TRUE)


# Terrain_Aspect-average_cell.tif	egv_527
input2egv(input="./RasterGrids_10m/2024/Terrain_Aspect_udeni2_10m.tif",
          egv_template="./Templates/TemplateRasters/LV100m_10km.tif",
          summary_function = "average",
          missing_job = "FillOutput",
          idw_weight = 2,
          outlocation = "./RasterGrids_100m/2024/RAW/",
          outfilename = "Terrain_Aspect-average_cell.tif",
          layername="egv_527",
          return_visible = TRUE,
          plot_final = TRUE)


# Terrain_Aspect-iqr_cell.tif	egv_528
p25rez=input2egv(input="./RasterGrids_10m/2024/Terrain_Aspect_udeni2_10m.tif",
                 egv_template= "./Templates/TemplateRasters/LV100m_10km.tif",
                 summary_function = "q1",
                 missing_job = "FillOutput",
                 outlocation = "./RasterGrids_100m/2024/",
                 outfilename = "draza_p25.tif",
                 layername = "egv_528",
                 idw_weight = 2)
p25rez_r=rast("./RasterGrids_100m/2024/draza_p25.tif")


p75rez=input2egv(input="./RasterGrids_10m/2024/Terrain_Aspect_udeni2_10m.tif",
                 egv_template= "./Templates/TemplateRasters/LV100m_10km.tif",
                 summary_function = "q3",
                 missing_job = "FillOutput",
                 outlocation = "./RasterGrids_100m/2024/",
                 outfilename = "draza_p75.tif",
                 layername = "egv_528",
                 idw_weight = 2)
p75rez_r=rast("./RasterGrids_100m/2024/draza_p75.tif")

iqr_rez=p75rez_r-p25rez_r
iqr_rez
plot(iqr_rez)

writeRaster(iqr_rez,
            "./RasterGrids_100m/2024/RAW/Terrain_Aspect-iqr_cell.tif",
            overwrite=TRUE)

unlink("./RasterGrids_100m/2024/draza_p75.tif")
unlink("./RasterGrids_100m/2024/draza_p25.tif")


# Terrain_DiS-max_cell.tif	egv_534
input2egv(input="./RasterGrids_10m/2024/Terrain_DiS_udeni2_10m.tif",
          egv_template="./Templates/TemplateRasters/LV100m_10km.tif",
          summary_function = "max",
          missing_job = "FillOutput",
          idw_weight = 2,
          outlocation = "./RasterGrids_100m/2024/RAW/",
          outfilename = "Terrain_DiS-max_cell.tif",
          layername="egv_534",
          return_visible = TRUE,
          plot_final = TRUE)



# Terrain_DiS-mean_cell.tif	egv_535
input2egv(input="./RasterGrids_10m/2024/Terrain_DiS_udeni2_10m.tif",
          egv_template="./Templates/TemplateRasters/LV100m_10km.tif",
          summary_function = "average",
          missing_job = "FillOutput",
          idw_weight = 2,
          outlocation = "./RasterGrids_100m/2024/RAW/",
          outfilename = "Terrain_DiS-mean_cell.tif",
          layername="egv_535",
          return_visible = TRUE,
          plot_final = TRUE)




# Terrain_Slope-average_cell.tif	egv_536
input2egv(input="./RasterGrids_10m/2024/Terrain_Slope_udeni2_10m.tif",
          egv_template="./Templates/TemplateRasters/LV100m_10km.tif",
          summary_function = "average",
          missing_job = "FillOutput",
          idw_weight = 2,
          outlocation = "./RasterGrids_100m/2024/RAW/",
          outfilename = "Terrain_Slope-average_cell.tif",
          layername="egv_536",
          return_visible = TRUE,
          plot_final = TRUE)



# Terrain_Slope-iqr_cell.tif	egv_537
p25rez=input2egv(input="./RasterGrids_10m/2024/Terrain_Slope_udeni2_10m.tif",
                 egv_template= "./Templates/TemplateRasters/LV100m_10km.tif",
                 summary_function = "q1",
                 missing_job = "FillOutput",
                 outlocation = "./RasterGrids_100m/2024/",
                 outfilename = "draza_p25.tif",
                 layername = "egv_537",
                 idw_weight = 2)
p25rez_r=rast("./RasterGrids_100m/2024/draza_p25.tif")


p75rez=input2egv(input="./RasterGrids_10m/2024/Terrain_Slope_udeni2_10m.tif",
                 egv_template= "./Templates/TemplateRasters/LV100m_10km.tif",
                 summary_function = "q3",
                 missing_job = "FillOutput",
                 outlocation = "./RasterGrids_100m/2024/",
                 outfilename = "draza_p75.tif",
                 layername = "egv_537",
                 idw_weight = 2)
p75rez_r=rast("./RasterGrids_100m/2024/draza_p75.tif")

iqr_rez=p75rez_r-p25rez_r
iqr_rez
plot(iqr_rez)

writeRaster(iqr_rez,
            "./RasterGrids_100m/2024/RAW/Terrain_Slope-iqr_cell.tif",
            overwrite=TRUE)

unlink("./RasterGrids_100m/2024/draza_p75.tif")
unlink("./RasterGrids_100m/2024/draza_p25.tif")

# Terrain_TWI-average_cell.tif	egv_538
input2egv(input="./RasterGrids_10m/2024/Terrain_TWI_udeni2_10m.tif",
          egv_template="./Templates/TemplateRasters/LV100m_10km.tif",
          summary_function = "average",
          missing_job = "FillOutput",
          idw_weight = 2,
          outlocation = "./RasterGrids_100m/2024/RAW/",
          outfilename = "Terrain_TWI-average_cell.tif",
          layername="egv_538",
          return_visible = TRUE,
          plot_final = TRUE)



# Terrain_DiS-area_cell.tif	egv_529
dis=rast("./RasterGrids_10m/2024/Terrain_DiS_udeni2_10m.tif")
dis2=ifel(dis>0,1,dis)

input2egv(input=dis2,
          egv_template="./Templates/TemplateRasters/LV100m_10km.tif",
          summary_function = "average",
          missing_job = "FillOutput",
          idw_weight = 2,
          outlocation = "./RasterGrids_100m/2024/RAW/",
          outfilename = "Terrain_DiS-area_cell.tif",
          layername="egv_529",
          return_visible = TRUE,
          plot_final = TRUE)

# radii
radius_function(
  kvadrati_path  = "./Templates/TemplateGrids/tiles/",
  radii_path     = "./Templates/TemplateGridPoints/tiles/",
  tikls100_path  = "./Templates/TemplateGrids/tikls100_sauzeme.parquet",
  template_path  = "./Templates/TemplateRasters/LV100m_10km.tif",
  input_layers   = c("./RasterGrids_100m/2024/RAW/Terrain_DiS-area_cell.tif"),
  layer_prefixes = c("Terrain_DiS-area"),
  output_dir     = "./RasterGrids_100m/2024/RAW/",
  n_workers      = 5,
  radii          = c("r500","r1250","r3000","r10000"),
  radius_mode    = "sparse",
  extract_fun    = "mean",
  fill_missing   = TRUE,
  IDW_weight     = 2,
  future_max_size = 5 * 1024^3)


# templates ----
template100=rast("./Templates/TemplateRasters/LV100m_10km.tif")

# Terrain_DiS-area_r500.tif	egv_530
slanis=rast("./RasterGrids_100m/2024/RAW/Terrain_DiS-area_r500.tif")
names(slanis)="egv_530"
slanis2=project(slanis,template100)
writeRaster(slanis2,
            "./RasterGrids_100m/2024/RAW/Terrain_DiS-area_r500.tif",
            overwrite=TRUE)

# Terrain_DiS-area_r1250.tif	egv_531
slanis=rast("./RasterGrids_100m/2024/RAW/Terrain_DiS-area_r1250.tif")
names(slanis)="egv_531"
slanis2=project(slanis,template100)
writeRaster(slanis2,
            "./RasterGrids_100m/2024/RAW/Terrain_DiS-area_r1250.tif",
            overwrite=TRUE)

# Terrain_DiS-area_r3000.tif	egv_532
slanis=rast("./RasterGrids_100m/2024/RAW/Terrain_DiS-area_r3000.tif")
names(slanis)="egv_532"
slanis2=project(slanis,template100)
writeRaster(slanis2,
            "./RasterGrids_100m/2024/RAW/Terrain_DiS-area_r3000.tif",
            overwrite=TRUE)

# Terrain_DiS-area_r10000.tif	egv_533
slanis=rast("./RasterGrids_100m/2024/RAW/Terrain_DiS-area_r10000.tif")
names(slanis)="egv_533"
slanis2=project(slanis,template100)
writeRaster(slanis2,
            "./RasterGrids_100m/2024/RAW/Terrain_DiS-area_r10000.tif",
            overwrite=TRUE)

