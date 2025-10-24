# Libs ----
if(!require(egvtools)) {remotes::install_github("aavotins/egvtools"); require(egvtools)}
if(!require(terra)) {install.packages("terra"); require(terra)}

# template ----
template100=rast("./Templates/TemplateRasters/LV100m_10km.tif")


# radii ----
radius_function(
  kvadrati_path  = "./Templates/TemplateGrids/tiles/",
  radii_path     = "./Templates/TemplateGridPoints/tiles/",
  tikls100_path  = "./Templates/TemplateGrids/tikls100_sauzeme.parquet",
  template_path  = "./Templates/TemplateRasters/LV100m_10km.tif",
  input_layers   = c("./RasterGrids_100m/2024/RAW/General_AllotmentGardens_cell.tif",
                     "./RasterGrids_100m/2024/RAW/General_BareSoilQuarry_cell.tif",
                     "./RasterGrids_100m/2024/RAW/General_Builtup_cell.tif",
                     "./RasterGrids_100m/2024/RAW/General_Farmland_cell.tif",
                     "./RasterGrids_100m/2024/RAW/General_ForestsWithoutInventory_cell.tif",
                     "./RasterGrids_100m/2024/RAW/General_GardensOrchards_cell.tif",
                     "./RasterGrids_100m/2024/RAW/General_ShrubsOrchards_cell.tif",
                     "./RasterGrids_100m/2024/RAW/General_ShrubsOrchardsGardens_cell.tif",
                     "./RasterGrids_100m/2024/RAW/General_SwampsMiresBogsHelophytes_cell.tif",
                     "./RasterGrids_100m/2024/RAW/General_Trees_cell.tif",
                     "./RasterGrids_100m/2024/RAW/General_TreesOutsideForests_cell.tif",
                     "./RasterGrids_100m/2024/RAW/General_Water_cell.tif"),
  layer_prefixes = c("General_AllotmentGardens",
                     "General_BareSoilQuarry",
                     "General_Builtup",
                     "General_Farmland",
                     "General_ForestsWithoutInventory",
                     "General_GardensOrchards",
                     "General_ShrubsOrchards",
                     "General_ShrubsOrchardsGardens",
                     "General_SwampsMiresBogsHelophytes",
                     "General_Trees",
                     "General_TreesOutsideForests",
                     "General_Water"),
  output_dir     = "./RasterGrids_100m/2024/RAW/",
  n_workers      = 6,
  radii          = c("r500","r1250","r3000","r10000"),
  radius_mode    = "sparse",
  extract_fun    = "mean",
  fill_missing   = TRUE,
  IDW_weight     = 2,
  future_max_size = 40 * 1024^3)


# General_AllotmentGardens_cell.tif ----

# General_AllotmentGardens_r500.tif	egv_404
slanis=rast("./RasterGrids_100m/2024/RAW/General_AllotmentGardens_r500.tif")
names(slanis)="egv_404"
slanis2=project(slanis,template100)
writeRaster(slanis2,
            "./RasterGrids_100m/2024/RAW/General_AllotmentGardens_r500.tif",
            overwrite=TRUE)

# General_AllotmentGardens_r1250.tif	egv_405
slanis=rast("./RasterGrids_100m/2024/RAW/General_AllotmentGardens_r1250.tif")
names(slanis)="egv_405"
slanis2=project(slanis,template100)
writeRaster(slanis2,
            "./RasterGrids_100m/2024/RAW/General_AllotmentGardens_r1250.tif",
            overwrite=TRUE)

# General_AllotmentGardens_r3000.tif	egv_406
slanis=rast("./RasterGrids_100m/2024/RAW/General_AllotmentGardens_r3000.tif")
names(slanis)="egv_406"
slanis2=project(slanis,template100)
writeRaster(slanis2,
            "./RasterGrids_100m/2024/RAW/General_AllotmentGardens_r3000.tif",
            overwrite=TRUE)

# General_AllotmentGardens_r10000.tif	egv_407
slanis=rast("./RasterGrids_100m/2024/RAW/General_AllotmentGardens_r10000.tif")
names(slanis)="egv_407"
slanis2=project(slanis,template100)
writeRaster(slanis2,
            "./RasterGrids_100m/2024/RAW/General_AllotmentGardens_r10000.tif",
            overwrite=TRUE)

# General_BareSoilQuarry_cell.tif ----

# General_BareSoilQuarry_r500.tif	egv_409
slanis=rast("./RasterGrids_100m/2024/RAW/General_BareSoilQuarry_r500.tif")
names(slanis)="egv_409"
slanis2=project(slanis,template100)
writeRaster(slanis2,
            "./RasterGrids_100m/2024/RAW/General_BareSoilQuarry_r500.tif",
            overwrite=TRUE)

# General_BareSoilQuarry_r1250.tif	egv_410
slanis=rast("./RasterGrids_100m/2024/RAW/General_BareSoilQuarry_r1250.tif")
names(slanis)="egv_410"
slanis2=project(slanis,template100)
writeRaster(slanis2,
            "./RasterGrids_100m/2024/RAW/General_BareSoilQuarry_r1250.tif",
            overwrite=TRUE)

# General_BareSoilQuarry_r3000.tif	egv_411
slanis=rast("./RasterGrids_100m/2024/RAW/General_BareSoilQuarry_r3000.tif")
names(slanis)="egv_411"
slanis2=project(slanis,template100)
writeRaster(slanis2,
            "./RasterGrids_100m/2024/RAW/General_BareSoilQuarry_r3000.tif",
            overwrite=TRUE)

# General_BareSoilQuarry_r10000.tif	egv_412
slanis=rast("./RasterGrids_100m/2024/RAW/General_BareSoilQuarry_r10000.tif")
names(slanis)="egv_412"
slanis2=project(slanis,template100)
writeRaster(slanis2,
            "./RasterGrids_100m/2024/RAW/General_BareSoilQuarry_r10000.tif",
            overwrite=TRUE)

# General_Builtup_cell.tif ----

# General_Builtup_r500.tif	egv_414
slanis=rast("./RasterGrids_100m/2024/RAW/General_Builtup_r500.tif")
names(slanis)="egv_414"
slanis2=project(slanis,template100)
writeRaster(slanis2,
            "./RasterGrids_100m/2024/RAW/General_Builtup_r500.tif",
            overwrite=TRUE)

# General_Builtup_r1250.tif	egv_415
slanis=rast("./RasterGrids_100m/2024/RAW/General_Builtup_r1250.tif")
names(slanis)="egv_415"
slanis2=project(slanis,template100)
writeRaster(slanis2,
            "./RasterGrids_100m/2024/RAW/General_Builtup_r1250.tif",
            overwrite=TRUE)

# General_Builtup_r3000.tif	egv_416
slanis=rast("./RasterGrids_100m/2024/RAW/General_Builtup_r3000.tif")
names(slanis)="egv_416"
slanis2=project(slanis,template100)
writeRaster(slanis2,
            "./RasterGrids_100m/2024/RAW/General_Builtup_r3000.tif",
            overwrite=TRUE)

# General_Builtup_r10000.tif	egv_417
slanis=rast("./RasterGrids_100m/2024/RAW/General_Builtup_r10000.tif")
names(slanis)="egv_417"
slanis2=project(slanis,template100)
writeRaster(slanis2,
            "./RasterGrids_100m/2024/RAW/General_Builtup_r10000.tif",
            overwrite=TRUE)


# General_Farmland_cell.tif ----

# General_Farmland_r500.tif	egv_419
slanis=rast("./RasterGrids_100m/2024/RAW/General_Farmland_r500.tif")
names(slanis)="egv_419"
slanis2=project(slanis,template100)
writeRaster(slanis2,
            "./RasterGrids_100m/2024/RAW/General_Farmland_r500.tif",
            overwrite=TRUE)

# General_Farmland_r1250.tif	egv_420
slanis=rast("./RasterGrids_100m/2024/RAW/General_Farmland_r1250.tif")
names(slanis)="egv_420"
slanis2=project(slanis,template100)
writeRaster(slanis2,
            "./RasterGrids_100m/2024/RAW/General_Farmland_r1250.tif",
            overwrite=TRUE)

# General_Farmland_r3000.tif	egv_421
slanis=rast("./RasterGrids_100m/2024/RAW/General_Farmland_r3000.tif")
names(slanis)="egv_421"
slanis2=project(slanis,template100)
writeRaster(slanis2,
            "./RasterGrids_100m/2024/RAW/General_Farmland_r3000.tif",
            overwrite=TRUE)

# General_Farmland_r10000.tif	egv_422
slanis=rast("./RasterGrids_100m/2024/RAW/General_Farmland_r10000.tif")
names(slanis)="egv_422"
slanis2=project(slanis,template100)
writeRaster(slanis2,
            "./RasterGrids_100m/2024/RAW/General_Farmland_r10000.tif",
            overwrite=TRUE)



# General_ForestsWithoutInventory_cell.tif ----

# General_ForestsWithoutInventory_r500.tif	egv_424
slanis=rast("./RasterGrids_100m/2024/RAW/General_ForestsWithoutInventory_r500.tif")
names(slanis)="egv_424"
slanis2=project(slanis,template100)
writeRaster(slanis2,
            "./RasterGrids_100m/2024/RAW/General_ForestsWithoutInventory_r500.tif",
            overwrite=TRUE)

# General_ForestsWithoutInventory_r1250.tif	egv_425
slanis=rast("./RasterGrids_100m/2024/RAW/General_ForestsWithoutInventory_r1250.tif")
names(slanis)="egv_425"
slanis2=project(slanis,template100)
writeRaster(slanis2,
            "./RasterGrids_100m/2024/RAW/General_ForestsWithoutInventory_r1250.tif",
            overwrite=TRUE)

# General_ForestsWithoutInventory_r3000.tif	egv_426
slanis=rast("./RasterGrids_100m/2024/RAW/General_ForestsWithoutInventory_r3000.tif")
names(slanis)="egv_426"
slanis2=project(slanis,template100)
writeRaster(slanis2,
            "./RasterGrids_100m/2024/RAW/General_ForestsWithoutInventory_r3000.tif",
            overwrite=TRUE)

# General_ForestsWithoutInventory_r10000.tif	egv_427
slanis=rast("./RasterGrids_100m/2024/RAW/General_ForestsWithoutInventory_r10000.tif")
names(slanis)="egv_427"
slanis2=project(slanis,template100)
writeRaster(slanis2,
            "./RasterGrids_100m/2024/RAW/General_ForestsWithoutInventory_r10000.tif",
            overwrite=TRUE)




# General_GardensOrchards_cell.tif ----

# General_GardensOrchards_r500.tif	egv_429
slanis=rast("./RasterGrids_100m/2024/RAW/General_GardensOrchards_r500.tif")
names(slanis)="egv_429"
slanis2=project(slanis,template100)
writeRaster(slanis2,
            "./RasterGrids_100m/2024/RAW/General_GardensOrchards_r500.tif",
            overwrite=TRUE)

# General_GardensOrchards_r1250.tif	egv_430
slanis=rast("./RasterGrids_100m/2024/RAW/General_GardensOrchards_r1250.tif")
names(slanis)="egv_430"
slanis2=project(slanis,template100)
writeRaster(slanis2,
            "./RasterGrids_100m/2024/RAW/General_GardensOrchards_r1250.tif",
            overwrite=TRUE)

# General_GardensOrchards_r3000.tif	egv_431
slanis=rast("./RasterGrids_100m/2024/RAW/General_GardensOrchards_r3000.tif")
names(slanis)="egv_431"
slanis2=project(slanis,template100)
writeRaster(slanis2,
            "./RasterGrids_100m/2024/RAW/General_GardensOrchards_r3000.tif",
            overwrite=TRUE)

# General_GardensOrchards_r10000.tif	egv_432
slanis=rast("./RasterGrids_100m/2024/RAW/General_GardensOrchards_r10000.tif")
names(slanis)="egv_432"
slanis2=project(slanis,template100)
writeRaster(slanis2,
            "./RasterGrids_100m/2024/RAW/General_GardensOrchards_r10000.tif",
            overwrite=TRUE)



# General_ShrubsOrchards_cell.tif ----

# General_ShrubsOrchards_r500.tif	egv_435
slanis=rast("./RasterGrids_100m/2024/RAW/General_ShrubsOrchards_r500.tif")
names(slanis)="egv_435"
slanis2=project(slanis,template100)
writeRaster(slanis2,
            "./RasterGrids_100m/2024/RAW/General_ShrubsOrchards_r500.tif",
            overwrite=TRUE)

# General_ShrubsOrchards_r1250.tif	egv_436
slanis=rast("./RasterGrids_100m/2024/RAW/General_ShrubsOrchards_r1250.tif")
names(slanis)="egv_436"
slanis2=project(slanis,template100)
writeRaster(slanis2,
            "./RasterGrids_100m/2024/RAW/General_ShrubsOrchards_r1250.tif",
            overwrite=TRUE)

# General_ShrubsOrchards_r3000.tif	egv_437
slanis=rast("./RasterGrids_100m/2024/RAW/General_ShrubsOrchards_r3000.tif")
names(slanis)="egv_437"
slanis2=project(slanis,template100)
writeRaster(slanis2,
            "./RasterGrids_100m/2024/RAW/General_ShrubsOrchards_r3000.tif",
            overwrite=TRUE)

# General_ShrubsOrchards_r10000.tif	egv_438
slanis=rast("./RasterGrids_100m/2024/RAW/General_ShrubsOrchards_r10000.tif")
names(slanis)="egv_438"
slanis2=project(slanis,template100)
writeRaster(slanis2,
            "./RasterGrids_100m/2024/RAW/General_ShrubsOrchards_r10000.tif",
            overwrite=TRUE)




# General_ShrubsOrchardsGardens_cell.tif ----

# General_ShrubsOrchardsGardens_r500.tif	egv_440
slanis=rast("./RasterGrids_100m/2024/RAW/General_ShrubsOrchardsGardens_r500.tif")
names(slanis)="egv_440"
slanis2=project(slanis,template100)
writeRaster(slanis2,
            "./RasterGrids_100m/2024/RAW/General_ShrubsOrchardsGardens_r500.tif",
            overwrite=TRUE)

# General_ShrubsOrchardsGardens_r1250.tif	egv_441
slanis=rast("./RasterGrids_100m/2024/RAW/General_ShrubsOrchardsGardens_r1250.tif")
names(slanis)="egv_441"
slanis2=project(slanis,template100)
writeRaster(slanis2,
            "./RasterGrids_100m/2024/RAW/General_ShrubsOrchardsGardens_r1250.tif",
            overwrite=TRUE)

# General_ShrubsOrchardsGardens_r3000.tif	egv_442
slanis=rast("./RasterGrids_100m/2024/RAW/General_ShrubsOrchardsGardens_r3000.tif")
names(slanis)="egv_442"
slanis2=project(slanis,template100)
writeRaster(slanis2,
            "./RasterGrids_100m/2024/RAW/General_ShrubsOrchardsGardens_r3000.tif",
            overwrite=TRUE)

# General_ShrubsOrchardsGardens_r10000.tif	egv_443
slanis=rast("./RasterGrids_100m/2024/RAW/General_ShrubsOrchardsGardens_r10000.tif")
names(slanis)="egv_443"
slanis2=project(slanis,template100)
writeRaster(slanis2,
            "./RasterGrids_100m/2024/RAW/General_ShrubsOrchardsGardens_r10000.tif",
            overwrite=TRUE)



# General_SwampsMiresBogsHelophytes_cell.tif ----

# General_SwampsMiresBogsHelophytes_r500.tif	egv_445
slanis=rast("./RasterGrids_100m/2024/RAW/General_SwampsMiresBogsHelophytes_r500.tif")
names(slanis)="egv_445"
slanis2=project(slanis,template100)
writeRaster(slanis2,
            "./RasterGrids_100m/2024/RAW/General_SwampsMiresBogsHelophytes_r500.tif",
            overwrite=TRUE)

# General_SwampsMiresBogsHelophytes_r1250.tif	egv_446
slanis=rast("./RasterGrids_100m/2024/RAW/General_SwampsMiresBogsHelophytes_r1250.tif")
names(slanis)="egv_446"
slanis2=project(slanis,template100)
writeRaster(slanis2,
            "./RasterGrids_100m/2024/RAW/General_SwampsMiresBogsHelophytes_r1250.tif",
            overwrite=TRUE)

# General_SwampsMiresBogsHelophytes_r3000.tif	egv_447
slanis=rast("./RasterGrids_100m/2024/RAW/General_SwampsMiresBogsHelophytes_r3000.tif")
names(slanis)="egv_447"
slanis2=project(slanis,template100)
writeRaster(slanis2,
            "./RasterGrids_100m/2024/RAW/General_SwampsMiresBogsHelophytes_r3000.tif",
            overwrite=TRUE)

# General_SwampsMiresBogsHelophytes_r10000.tif	egv_448
slanis=rast("./RasterGrids_100m/2024/RAW/General_SwampsMiresBogsHelophytes_r10000.tif")
names(slanis)="egv_448"
slanis2=project(slanis,template100)
writeRaster(slanis2,
            "./RasterGrids_100m/2024/RAW/General_SwampsMiresBogsHelophytes_r10000.tif",
            overwrite=TRUE)




# General_Trees_cell.tif ----

# General_Trees_r500.tif	egv_450
slanis=rast("./RasterGrids_100m/2024/RAW/General_Trees_r500.tif")
names(slanis)="egv_450"
slanis2=project(slanis,template100)
writeRaster(slanis2,
            "./RasterGrids_100m/2024/RAW/General_Trees_r500.tif",
            overwrite=TRUE)

# General_Trees_r1250.tif	egv_451
slanis=rast("./RasterGrids_100m/2024/RAW/General_Trees_r1250.tif")
names(slanis)="egv_451"
slanis2=project(slanis,template100)
writeRaster(slanis2,
            "./RasterGrids_100m/2024/RAW/General_Trees_r1250.tif",
            overwrite=TRUE)

# General_Trees_r3000.tif	egv_452
slanis=rast("./RasterGrids_100m/2024/RAW/General_Trees_r3000.tif")
names(slanis)="egv_452"
slanis2=project(slanis,template100)
writeRaster(slanis2,
            "./RasterGrids_100m/2024/RAW/General_Trees_r3000.tif",
            overwrite=TRUE)

# General_Trees_r10000.tif	egv_453
slanis=rast("./RasterGrids_100m/2024/RAW/General_Trees_r10000.tif")
names(slanis)="egv_453"
slanis2=project(slanis,template100)
writeRaster(slanis2,
            "./RasterGrids_100m/2024/RAW/General_Trees_r10000.tif",
            overwrite=TRUE)






# General_TreesOutsideForests_cell.tif ----

# General_TreesOutsideForests_r500.tif	egv_455
slanis=rast("./RasterGrids_100m/2024/RAW/General_TreesOutsideForests_r500.tif")
names(slanis)="egv_455"
slanis2=project(slanis,template100)
writeRaster(slanis2,
            "./RasterGrids_100m/2024/RAW/General_TreesOutsideForests_r500.tif",
            overwrite=TRUE)

# General_TreesOutsideForests_r1250.tif	egv_456
slanis=rast("./RasterGrids_100m/2024/RAW/General_TreesOutsideForests_r1250.tif")
names(slanis)="egv_456"
slanis2=project(slanis,template100)
writeRaster(slanis2,
            "./RasterGrids_100m/2024/RAW/General_TreesOutsideForests_r1250.tif",
            overwrite=TRUE)

# General_TreesOutsideForests_r3000.tif	egv_457
slanis=rast("./RasterGrids_100m/2024/RAW/General_TreesOutsideForests_r3000.tif")
names(slanis)="egv_457"
slanis2=project(slanis,template100)
writeRaster(slanis2,
            "./RasterGrids_100m/2024/RAW/General_TreesOutsideForests_r3000.tif",
            overwrite=TRUE)

# General_TreesOutsideForests_r10000.tif	egv_458
slanis=rast("./RasterGrids_100m/2024/RAW/General_TreesOutsideForests_r10000.tif")
names(slanis)="egv_458"
slanis2=project(slanis,template100)
writeRaster(slanis2,
            "./RasterGrids_100m/2024/RAW/General_TreesOutsideForests_r10000.tif",
            overwrite=TRUE)





# General_Water_cell.tif ----

# General_Water_r500.tif	egv_460
slanis=rast("./RasterGrids_100m/2024/RAW/General_Water_r500.tif")
names(slanis)="egv_460"
slanis2=project(slanis,template100)
writeRaster(slanis2,
            "./RasterGrids_100m/2024/RAW/General_Water_r500.tif",
            overwrite=TRUE)

# General_Water_r1250.tif	egv_461
slanis=rast("./RasterGrids_100m/2024/RAW/General_Water_r1250.tif")
names(slanis)="egv_461"
slanis2=project(slanis,template100)
writeRaster(slanis2,
            "./RasterGrids_100m/2024/RAW/General_Water_r1250.tif",
            overwrite=TRUE)

# General_Water_r3000.tif	egv_462
slanis=rast("./RasterGrids_100m/2024/RAW/General_Water_r3000.tif")
names(slanis)="egv_462"
slanis2=project(slanis,template100)
writeRaster(slanis2,
            "./RasterGrids_100m/2024/RAW/General_Water_r3000.tif",
            overwrite=TRUE)

# General_Water_r10000.tif	egv_463
slanis=rast("./RasterGrids_100m/2024/RAW/General_Water_r10000.tif")
names(slanis)="egv_463"
slanis2=project(slanis,template100)
writeRaster(slanis2,
            "./RasterGrids_100m/2024/RAW/General_Water_r10000.tif",
            overwrite=TRUE)

