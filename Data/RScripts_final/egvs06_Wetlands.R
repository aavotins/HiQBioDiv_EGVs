# Libs ----
if(!require(egvtools)) {remotes::install_github("aavotins/egvtools"); require(egvtools)}
if(!require(terra)) {install.packages("terra"); require(terra)}

# template ----
template100=rast("./Templates/TemplateRasters/LV100m_10km.tif")

# Wetlands_Bogs_cell.tif	egv_464 ----
bogs=rast("./RasterGrids_10m/2024/EDI_BogsYN.tif")
i2e_rez=egvtools::input2egv(input=bogs,
                            egv_template= "./Templates/TemplateRasters/LV100m_10km.tif",
                            summary_function = "average",
                            missing_job = "FillOutput",
                            outlocation = "./RasterGrids_100m/2024/RAW/",
                            outfilename = "Wetlands_Bogs_cell.tif",
                            layername = "egv_464",
                            idw_weight = 2,
                            plot_gaps = FALSE,plot_final = TRUE)
i2e_rez
rm(bogs)
rm(i2e_rez)

# Wetlands_Mires_cell.tif	egv_469 ----
mires=rast("./RasterGrids_10m/2024/EDI_TransitionalMiresYN.tif")
i2e_rez=egvtools::input2egv(input=mires,
                            egv_template= "./Templates/TemplateRasters/LV100m_10km.tif",
                            summary_function = "average",
                            missing_job = "FillOutput",
                            outlocation = "./RasterGrids_100m/2024/RAW/",
                            outfilename = "Wetlands_Mires_cell.tif",
                            layername = "egv_469",
                            idw_weight = 2,
                            plot_gaps = FALSE,plot_final = TRUE)
i2e_rez
rm(mires)
rm(i2e_rez)


# Wetlands_ReedSedgeRushBeds_cell.tif	egv_474 ----
simple_landscape=rast("RasterGrids_10m/2024/Ainava_vienk_mask.tif")
reedsedgerush=ifel(simple_landscape==720,1,0)

i2e_rez=egvtools::input2egv(input=reedsedgerush,
                            egv_template= "./Templates/TemplateRasters/LV100m_10km.tif",
                            summary_function = "average",
                            missing_job = "FillOutput",
                            outlocation = "./RasterGrids_100m/2024/RAW/",
                            outfilename = "Wetlands_ReedSedgeRushBeds_cell.tif",
                            layername = "egv_474",
                            idw_weight = 2,
                            plot_gaps = FALSE,plot_final = TRUE)
i2e_rez
rm(reedsedgerush)
rm(i2e_rez)
rm(simple_landscape)


# radii ----
radius_function(
  kvadrati_path  = "./Templates/TemplateGrids/tiles/",
  radii_path     = "./Templates/TemplateGridPoints/tiles/",
  tikls100_path  = "./Templates/TemplateGrids/tikls100_sauzeme.parquet",
  template_path  = "./Templates/TemplateRasters/LV100m_10km.tif",
  input_layers   = c("./RasterGrids_100m/2024/RAW/Wetlands_Bogs_cell.tif",
                     "./RasterGrids_100m/2024/RAW/Wetlands_Mires_cell.tif",
                     "./RasterGrids_100m/2024/RAW/Wetlands_ReedSedgeRushBeds_cell.tif"),
  layer_prefixes = c("Wetlands_Bogs",
                     "Wetlands_Mires",
                     "Wetlands_ReedSedgeRushBeds"),
  output_dir     = "./RasterGrids_100m/2024/RAW/",
  n_workers      = 12,
  radii          = c("r500","r1250","r3000","r10000"),
  radius_mode    = "sparse",
  extract_fun    = "mean",
  fill_missing   = TRUE,
  IDW_weight     = 2,
  future_max_size = 20 * 1024^3)


# Wetlands_Bogs ----

# Wetlands_Bogs_r500.tif	egv_465
slanis=rast("./RasterGrids_100m/2024/RAW/Wetlands_Bogs_r500.tif")
names(slanis)="egv_465"
slanis2=project(slanis,template100)
writeRaster(slanis2,
            "./RasterGrids_100m/2024/RAW/Wetlands_Bogs_r500.tif",
            overwrite=TRUE)


# Wetlands_Bogs_r1250.tif	egv_466
slanis=rast("./RasterGrids_100m/2024/RAW/Wetlands_Bogs_r1250.tif")
names(slanis)="egv_466"
slanis2=project(slanis,template100)
writeRaster(slanis2,
            "./RasterGrids_100m/2024/RAW/Wetlands_Bogs_r1250.tif",
            overwrite=TRUE)



# Wetlands_Bogs_r3000.tif	egv_467
slanis=rast("./RasterGrids_100m/2024/RAW/Wetlands_Bogs_r3000.tif")
names(slanis)="egv_467"
slanis2=project(slanis,template100)
writeRaster(slanis2,
            "./RasterGrids_100m/2024/RAW/Wetlands_Bogs_r3000.tif",
            overwrite=TRUE)



# Wetlands_Bogs_r10000.tif	egv_468
slanis=rast("./RasterGrids_100m/2024/RAW/Wetlands_Bogs_r10000.tif")
names(slanis)="egv_468"
slanis2=project(slanis,template100)
writeRaster(slanis2,
            "./RasterGrids_100m/2024/RAW/Wetlands_Bogs_r10000.tif",
            overwrite=TRUE)



# Wetlands_Mires ----


# Wetlands_Mires_r500.tif	egv_470
slanis=rast("./RasterGrids_100m/2024/RAW/Wetlands_Mires_r500.tif")
names(slanis)="egv_470"
slanis2=project(slanis,template100)
writeRaster(slanis2,
            "./RasterGrids_100m/2024/RAW/Wetlands_Mires_r500.tif",
            overwrite=TRUE)



# Wetlands_Mires_r1250.tif	egv_471
slanis=rast("./RasterGrids_100m/2024/RAW/Wetlands_Mires_r1250.tif")
names(slanis)="egv_471"
slanis2=project(slanis,template100)
writeRaster(slanis2,
            "./RasterGrids_100m/2024/RAW/Wetlands_Mires_r1250.tif",
            overwrite=TRUE)



# Wetlands_Mires_r3000.tif	egv_472
slanis=rast("./RasterGrids_100m/2024/RAW/Wetlands_Mires_r3000.tif")
names(slanis)="egv_472"
slanis2=project(slanis,template100)
writeRaster(slanis2,
            "./RasterGrids_100m/2024/RAW/Wetlands_Mires_r3000.tif",
            overwrite=TRUE)



# Wetlands_Mires_r10000.tif	egv_473
slanis=rast("./RasterGrids_100m/2024/RAW/Wetlands_Mires_r10000.tif")
names(slanis)="egv_473"
slanis2=project(slanis,template100)
writeRaster(slanis2,
            "./RasterGrids_100m/2024/RAW/Wetlands_Mires_r10000.tif",
            overwrite=TRUE)




# Wetlands_ReedSedgeRushBeds ----

# Wetlands_ReedSedgeRushBeds_r500.tif	egv_475
slanis=rast("./RasterGrids_100m/2024/RAW/Wetlands_ReedSedgeRushBeds_r500.tif")
names(slanis)="egv_475"
slanis2=project(slanis,template100)
writeRaster(slanis2,
            "./RasterGrids_100m/2024/RAW/Wetlands_ReedSedgeRushBeds_r500.tif",
            overwrite=TRUE)


# Wetlands_ReedSedgeRushBeds_r1250.tif	egv_476
slanis=rast("./RasterGrids_100m/2024/RAW/Wetlands_ReedSedgeRushBeds_r1250.tif")
names(slanis)="egv_476"
slanis2=project(slanis,template100)
writeRaster(slanis2,
            "./RasterGrids_100m/2024/RAW/Wetlands_ReedSedgeRushBeds_r1250.tif",
            overwrite=TRUE)


# Wetlands_ReedSedgeRushBeds_r3000.tif	egv_477
slanis=rast("./RasterGrids_100m/2024/RAW/Wetlands_ReedSedgeRushBeds_r3000.tif")
names(slanis)="egv_477"
slanis2=project(slanis,template100)
writeRaster(slanis2,
            "./RasterGrids_100m/2024/RAW/Wetlands_ReedSedgeRushBeds_r3000.tif",
            overwrite=TRUE)


# Wetlands_ReedSedgeRushBeds_r10000.tif	egv_478
slanis=rast("./RasterGrids_100m/2024/RAW/Wetlands_ReedSedgeRushBeds_r10000.tif")
names(slanis)="egv_478"
slanis2=project(slanis,template100)
writeRaster(slanis2,
            "./RasterGrids_100m/2024/RAW/Wetlands_ReedSedgeRushBeds_r10000.tif",
            overwrite=TRUE)


