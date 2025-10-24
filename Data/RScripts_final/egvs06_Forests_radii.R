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
  input_layers   = c("./RasterGrids_100m/2024/RAW/ForestsAge_ClearcutsLowStands_cell.tif",
                     "./RasterGrids_100m/2024/RAW/ForestsAge_Middle_cell.tif",
                     "./RasterGrids_100m/2024/RAW/ForestsAge_Old_cell.tif",
                     "./RasterGrids_100m/2024/RAW/ForestsAge_YoungTallStandsShrubs_cell.tif",
                     "./RasterGrids_100m/2024/RAW/ForestsSoil_EutrophicDrained_cell.tif",
                     "./RasterGrids_100m/2024/RAW/ForestsSoil_EutrophicMineral_cell.tif",
                     "./RasterGrids_100m/2024/RAW/ForestsSoil_EutrophicOrganic_cell.tif",
                     "./RasterGrids_100m/2024/RAW/ForestsSoil_MesotrophicMineral_cell.tif",
                     "./RasterGrids_100m/2024/RAW/ForestsSoil_OligotrophicDrained_cell.tif",
                     "./RasterGrids_100m/2024/RAW/ForestsSoil_OligotrophicMineral_cell.tif",
                     "./RasterGrids_100m/2024/RAW/ForestsSoil_OligotrophicOrganic_cell.tif",
                     "./RasterGrids_100m/2024/RAW/ForestsTreesAge_BorealDeciduousOld_cell.tif",
                     "./RasterGrids_100m/2024/RAW/ForestsTreesAge_BorealDeciduousYoung_cell.tif",
                     "./RasterGrids_100m/2024/RAW/ForestsTreesAge_ConiferousOld_cell.tif",
                     "./RasterGrids_100m/2024/RAW/ForestsTreesAge_ConiferousYoung_cell.tif",
                     "./RasterGrids_100m/2024/RAW/ForestsTreesAge_MixedOld_cell.tif",
                     "./RasterGrids_100m/2024/RAW/ForestsTreesAge_MixedYoung_cell.tif",
                     "./RasterGrids_100m/2024/RAW/ForestsTreesAge_TemperateDeciduousOld_cell.tif",
                     "./RasterGrids_100m/2024/RAW/ForestsTreesAge_TemperateDeciduousYoung_cell.tif",
                     "./RasterGrids_100m/2024/RAW/ForestsTrees_BorealDeciduous_cell.tif",
                     "./RasterGrids_100m/2024/RAW/ForestsTrees_Coniferous_cell.tif",
                     "./RasterGrids_100m/2024/RAW/ForestsTrees_Mixed_cell.tif",
                     "./RasterGrids_100m/2024/RAW/ForestsTrees_TemperateDeciduous_cell.tif"),
  layer_prefixes = c("ForestsAge_ClearcutsLowStands",
                     "ForestsAge_Middle",
                     "ForestsAge_Old",
                     "ForestsAge_YoungTallStandsShrubs",
                     "ForestsSoil_EutrophicDrained",
                     "ForestsSoil_EutrophicMineral",
                     "ForestsSoil_EutrophicOrganic",
                     "ForestsSoil_MesotrophicMineral",
                     "ForestsSoil_OligotrophicDrained",
                     "ForestsSoil_OligotrophicMineral",
                     "ForestsSoil_OligotrophicOrganic",
                     "ForestsTreesAge_BorealDeciduousOld",
                     "ForestsTreesAge_BorealDeciduousYoung",
                     "ForestsTreesAge_ConiferousOld",
                     "ForestsTreesAge_ConiferousYoung",
                     "ForestsTreesAge_MixedOld",
                     "ForestsTreesAge_MixedYoung",
                     "ForestsTreesAge_TemperateDeciduousOld",
                     "ForestsTreesAge_TemperateDeciduousYoung",
                     "ForestsTrees_BorealDeciduous",
                     "ForestsTrees_Coniferous",
                     "ForestsTrees_Mixed",
                     "ForestsTrees_TemperateDeciduous"),
  output_dir     = "./RasterGrids_100m/2024/RAW/",
  n_workers      = 6,
  radii          = c("r500","r1250","r3000","r10000"),
  radius_mode    = "sparse",
  extract_fun    = "mean",
  fill_missing   = TRUE,
  IDW_weight     = 2,
  future_max_size = 40 * 1024^3)



# ForestsAge_ClearcutsLowStands_cell.tif	egv_270 ----

# ForestsAge_ClearcutsLowStands_r500.tif	egv_271
slanis=rast("./RasterGrids_100m/2024/RAW/ForestsAge_ClearcutsLowStands_r500.tif")
names(slanis)="egv_271"
slanis2=project(slanis,template100)
writeRaster(slanis2,
            "./RasterGrids_100m/2024/RAW/ForestsAge_ClearcutsLowStands_r500.tif",
            overwrite=TRUE)

# ForestsAge_ClearcutsLowStands_r1250.tif	egv_272
slanis=rast("./RasterGrids_100m/2024/RAW/ForestsAge_ClearcutsLowStands_r1250.tif")
names(slanis)="egv_272"
slanis2=project(slanis,template100)
writeRaster(slanis2,
            "./RasterGrids_100m/2024/RAW/ForestsAge_ClearcutsLowStands_r1250.tif",
            overwrite=TRUE)

# ForestsAge_ClearcutsLowStands_r3000.tif	egv_273
slanis=rast("./RasterGrids_100m/2024/RAW/ForestsAge_ClearcutsLowStands_r3000.tif")
names(slanis)="egv_273"
slanis2=project(slanis,template100)
writeRaster(slanis2,
            "./RasterGrids_100m/2024/RAW/ForestsAge_ClearcutsLowStands_r3000.tif",
            overwrite=TRUE)

# ForestsAge_ClearcutsLowStands_r10000.tif	egv_274
slanis=rast("./RasterGrids_100m/2024/RAW/ForestsAge_ClearcutsLowStands_r10000.tif")
names(slanis)="egv_274"
slanis2=project(slanis,template100)
writeRaster(slanis2,
            "./RasterGrids_100m/2024/RAW/ForestsAge_ClearcutsLowStands_r10000.tif",
            overwrite=TRUE)



# ForestsAge_Middle_cell.tif	egv_275 ----

# ForestsAge_Middle_r500.tif	egv_276
slanis=rast("./RasterGrids_100m/2024/RAW/ForestsAge_Middle_r500.tif")
names(slanis)="egv_276"
slanis2=project(slanis,template100)
writeRaster(slanis2,
            "./RasterGrids_100m/2024/RAW/ForestsAge_Middle_r500.tif",
            overwrite=TRUE)

# ForestsAge_Middle_r1250.tif	egv_277
slanis=rast("./RasterGrids_100m/2024/RAW/ForestsAge_Middle_r1250.tif")
names(slanis)="egv_277"
slanis2=project(slanis,template100)
writeRaster(slanis2,
            "./RasterGrids_100m/2024/RAW/ForestsAge_Middle_r1250.tif",
            overwrite=TRUE)

# ForestsAge_Middle_r3000.tif	egv_278
slanis=rast("./RasterGrids_100m/2024/RAW/ForestsAge_Middle_r3000.tif")
names(slanis)="egv_278"
slanis2=project(slanis,template100)
writeRaster(slanis2,
            "./RasterGrids_100m/2024/RAW/ForestsAge_Middle_r3000.tif",
            overwrite=TRUE)

# ForestsAge_Middle_r10000.tif	egv_279
slanis=rast("./RasterGrids_100m/2024/RAW/ForestsAge_Middle_r10000.tif")
names(slanis)="egv_279"
slanis2=project(slanis,template100)
writeRaster(slanis2,
            "./RasterGrids_100m/2024/RAW/ForestsAge_Middle_r10000.tif",
            overwrite=TRUE)



# ForestsAge_Old_cell.tif	egv_280 ----

# ForestsAge_Old_r500.tif	egv_281
slanis=rast("./RasterGrids_100m/2024/RAW/ForestsAge_Old_r500.tif")
names(slanis)="egv_281"
slanis2=project(slanis,template100)
writeRaster(slanis2,
            "./RasterGrids_100m/2024/RAW/ForestsAge_Old_r500.tif",
            overwrite=TRUE)

# ForestsAge_Old_r1250.tif	egv_282
slanis=rast("./RasterGrids_100m/2024/RAW/ForestsAge_Old_r1250.tif")
names(slanis)="egv_282"
slanis2=project(slanis,template100)
writeRaster(slanis2,
            "./RasterGrids_100m/2024/RAW/ForestsAge_Old_r1250.tif",
            overwrite=TRUE)

# ForestsAge_Old_r3000.tif	egv_283
slanis=rast("./RasterGrids_100m/2024/RAW/ForestsAge_Old_r3000.tif")
names(slanis)="egv_283"
slanis2=project(slanis,template100)
writeRaster(slanis2,
            "./RasterGrids_100m/2024/RAW/ForestsAge_Old_r3000.tif",
            overwrite=TRUE)

# ForestsAge_Old_r10000.tif	egv_284
slanis=rast("./RasterGrids_100m/2024/RAW/ForestsAge_Old_r10000.tif")
names(slanis)="egv_284"
slanis2=project(slanis,template100)
writeRaster(slanis2,
            "./RasterGrids_100m/2024/RAW/ForestsAge_Old_r10000.tif",
            overwrite=TRUE)



# ForestsAge_YoungTallStandsShrubs_cell.tif	egv_285 ----

# ForestsAge_YoungTallStandsShrubs_r500.tif	egv_286
slanis=rast("./RasterGrids_100m/2024/RAW/ForestsAge_YoungTallStandsShrubs_r500.tif")
names(slanis)="egv_286"
slanis2=project(slanis,template100)
writeRaster(slanis2,
            "./RasterGrids_100m/2024/RAW/ForestsAge_YoungTallStandsShrubs_r500.tif",
            overwrite=TRUE)

# ForestsAge_YoungTallStandsShrubs_r1250.tif	egv_287
slanis=rast("./RasterGrids_100m/2024/RAW/ForestsAge_YoungTallStandsShrubs_r1250.tif")
names(slanis)="egv_287"
slanis2=project(slanis,template100)
writeRaster(slanis2,
            "./RasterGrids_100m/2024/RAW/ForestsAge_YoungTallStandsShrubs_r1250.tif",
            overwrite=TRUE)

# ForestsAge_YoungTallStandsShrubs_r3000.tif	egv_288
slanis=rast("./RasterGrids_100m/2024/RAW/ForestsAge_YoungTallStandsShrubs_r3000.tif")
names(slanis)="egv_288"
slanis2=project(slanis,template100)
writeRaster(slanis2,
            "./RasterGrids_100m/2024/RAW/ForestsAge_YoungTallStandsShrubs_r3000.tif",
            overwrite=TRUE)

# ForestsAge_YoungTallStandsShrubs_r10000.tif	egv_289
slanis=rast("./RasterGrids_100m/2024/RAW/ForestsAge_YoungTallStandsShrubs_r10000.tif")
names(slanis)="egv_289"
slanis2=project(slanis,template100)
writeRaster(slanis2,
            "./RasterGrids_100m/2024/RAW/ForestsAge_YoungTallStandsShrubs_r10000.tif",
            overwrite=TRUE)



# ForestsSoil_EutrophicDrained_cell.tif	egv_308 ----

# ForestsSoil_EutrophicDrained_r500.tif	egv_309
slanis=rast("./RasterGrids_100m/2024/RAW/ForestsSoil_EutrophicDrained_r500.tif")
names(slanis)="egv_309"
slanis2=project(slanis,template100)
writeRaster(slanis2,
            "./RasterGrids_100m/2024/RAW/ForestsSoil_EutrophicDrained_r500.tif",
            overwrite=TRUE)

# ForestsSoil_EutrophicDrained_r1250.tif	egv_310
slanis=rast("./RasterGrids_100m/2024/RAW/ForestsSoil_EutrophicDrained_r1250.tif")
names(slanis)="egv_310"
slanis2=project(slanis,template100)
writeRaster(slanis2,
            "./RasterGrids_100m/2024/RAW/ForestsSoil_EutrophicDrained_r1250.tif",
            overwrite=TRUE)

# ForestsSoil_EutrophicDrained_r3000.tif	egv_311
slanis=rast("./RasterGrids_100m/2024/RAW/ForestsSoil_EutrophicDrained_r3000.tif")
names(slanis)="egv_311"
slanis2=project(slanis,template100)
writeRaster(slanis2,
            "./RasterGrids_100m/2024/RAW/ForestsSoil_EutrophicDrained_r3000.tif",
            overwrite=TRUE)

# ForestsSoil_EutrophicDrained_r10000.tif	egv_312
slanis=rast("./RasterGrids_100m/2024/RAW/ForestsSoil_EutrophicDrained_r10000.tif")
names(slanis)="egv_312"
slanis2=project(slanis,template100)
writeRaster(slanis2,
            "./RasterGrids_100m/2024/RAW/ForestsSoil_EutrophicDrained_r10000.tif",
            overwrite=TRUE)



# ForestsSoil_EutrophicMineral_cell.tif	egv_313 ----

# ForestsSoil_EutrophicMineral_r500.tif	egv_314
slanis=rast("./RasterGrids_100m/2024/RAW/ForestsSoil_EutrophicMineral_r500.tif")
names(slanis)="egv_314"
slanis2=project(slanis,template100)
writeRaster(slanis2,
            "./RasterGrids_100m/2024/RAW/ForestsSoil_EutrophicMineral_r500.tif",
            overwrite=TRUE)

# ForestsSoil_EutrophicMineral_r1250.tif	egv_315
slanis=rast("./RasterGrids_100m/2024/RAW/ForestsSoil_EutrophicMineral_r1250.tif")
names(slanis)="egv_315"
slanis2=project(slanis,template100)
writeRaster(slanis2,
            "./RasterGrids_100m/2024/RAW/ForestsSoil_EutrophicMineral_r1250.tif",
            overwrite=TRUE)

# ForestsSoil_EutrophicMineral_r3000.tif	egv_316
slanis=rast("./RasterGrids_100m/2024/RAW/ForestsSoil_EutrophicMineral_r3000.tif")
names(slanis)="egv_316"
slanis2=project(slanis,template100)
writeRaster(slanis2,
            "./RasterGrids_100m/2024/RAW/ForestsSoil_EutrophicMineral_r3000.tif",
            overwrite=TRUE)

# ForestsSoil_EutrophicMineral_r10000.tif	egv_317
slanis=rast("./RasterGrids_100m/2024/RAW/ForestsSoil_EutrophicMineral_r10000.tif")
names(slanis)="egv_317"
slanis2=project(slanis,template100)
writeRaster(slanis2,
            "./RasterGrids_100m/2024/RAW/ForestsSoil_EutrophicMineral_r10000.tif",
            overwrite=TRUE)



# ForestsSoil_EutrophicOrganic_cell.tif	egv_318 ----

# ForestsSoil_EutrophicOrganic_r500.tif	egv_319
slanis=rast("./RasterGrids_100m/2024/RAW/ForestsSoil_EutrophicOrganic_r500.tif")
names(slanis)="egv_319"
slanis2=project(slanis,template100)
writeRaster(slanis2,
            "./RasterGrids_100m/2024/RAW/ForestsSoil_EutrophicOrganic_r500.tif",
            overwrite=TRUE)

# ForestsSoil_EutrophicOrganic_r1250.tif	egv_320
slanis=rast("./RasterGrids_100m/2024/RAW/ForestsSoil_EutrophicOrganic_r1250.tif")
names(slanis)="egv_320"
slanis2=project(slanis,template100)
writeRaster(slanis2,
            "./RasterGrids_100m/2024/RAW/ForestsSoil_EutrophicOrganic_r1250.tif",
            overwrite=TRUE)

# ForestsSoil_EutrophicOrganic_r3000.tif	egv_321
slanis=rast("./RasterGrids_100m/2024/RAW/ForestsSoil_EutrophicOrganic_r3000.tif")
names(slanis)="egv_321"
slanis2=project(slanis,template100)
writeRaster(slanis2,
            "./RasterGrids_100m/2024/RAW/ForestsSoil_EutrophicOrganic_r3000.tif",
            overwrite=TRUE)

# ForestsSoil_EutrophicOrganic_r10000.tif	egv_322
slanis=rast("./RasterGrids_100m/2024/RAW/ForestsSoil_EutrophicOrganic_r10000.tif")
names(slanis)="egv_322"
slanis2=project(slanis,template100)
writeRaster(slanis2,
            "./RasterGrids_100m/2024/RAW/ForestsSoil_EutrophicOrganic_r10000.tif",
            overwrite=TRUE)




# ForestsSoil_MesotrophicMineral_cell.tif	egv_323 ----

# ForestsSoil_MesotrophicMineral_r500.tif	egv_324
slanis=rast("./RasterGrids_100m/2024/RAW/ForestsSoil_MesotrophicMineral_r500.tif")
names(slanis)="egv_324"
slanis2=project(slanis,template100)
writeRaster(slanis2,
            "./RasterGrids_100m/2024/RAW/ForestsSoil_MesotrophicMineral_r500.tif",
            overwrite=TRUE)

# ForestsSoil_MesotrophicMineral_r1250.tif	egv_325
slanis=rast("./RasterGrids_100m/2024/RAW/ForestsSoil_MesotrophicMineral_r1250.tif")
names(slanis)="egv_325"
slanis2=project(slanis,template100)
writeRaster(slanis2,
            "./RasterGrids_100m/2024/RAW/ForestsSoil_MesotrophicMineral_r1250.tif",
            overwrite=TRUE)

# ForestsSoil_MesotrophicMineral_r3000.tif	egv_326
slanis=rast("./RasterGrids_100m/2024/RAW/ForestsSoil_MesotrophicMineral_r3000.tif")
names(slanis)="egv_326"
slanis2=project(slanis,template100)
writeRaster(slanis2,
            "./RasterGrids_100m/2024/RAW/ForestsSoil_MesotrophicMineral_r3000.tif",
            overwrite=TRUE)

# ForestsSoil_MesotrophicMineral_r10000.tif	egv_327
slanis=rast("./RasterGrids_100m/2024/RAW/ForestsSoil_MesotrophicMineral_r10000.tif")
names(slanis)="egv_327"
slanis2=project(slanis,template100)
writeRaster(slanis2,
            "./RasterGrids_100m/2024/RAW/ForestsSoil_MesotrophicMineral_r10000.tif",
            overwrite=TRUE)



# ForestsSoil_OligotrophicDrained_cell.tif	egv_328 ----

# ForestsSoil_OligotrophicDrained_r500.tif	egv_329
slanis=rast("./RasterGrids_100m/2024/RAW/ForestsSoil_OligotrophicDrained_r500.tif")
names(slanis)="egv_329"
slanis2=project(slanis,template100)
writeRaster(slanis2,
            "./RasterGrids_100m/2024/RAW/ForestsSoil_OligotrophicDrained_r500.tif",
            overwrite=TRUE)

# ForestsSoil_OligotrophicDrained_r1250.tif	egv_330
slanis=rast("./RasterGrids_100m/2024/RAW/ForestsSoil_OligotrophicDrained_r1250.tif")
names(slanis)="egv_330"
slanis2=project(slanis,template100)
writeRaster(slanis2,
            "./RasterGrids_100m/2024/RAW/ForestsSoil_OligotrophicDrained_r1250.tif",
            overwrite=TRUE)

# ForestsSoil_OligotrophicDrained_r3000.tif	egv_331
slanis=rast("./RasterGrids_100m/2024/RAW/ForestsSoil_OligotrophicDrained_r3000.tif")
names(slanis)="egv_331"
slanis2=project(slanis,template100)
writeRaster(slanis2,
            "./RasterGrids_100m/2024/RAW/ForestsSoil_OligotrophicDrained_r3000.tif",
            overwrite=TRUE)

# ForestsSoil_OligotrophicDrained_r10000.tif	egv_332
slanis=rast("./RasterGrids_100m/2024/RAW/ForestsSoil_OligotrophicDrained_r10000.tif")
names(slanis)="egv_332"
slanis2=project(slanis,template100)
writeRaster(slanis2,
            "./RasterGrids_100m/2024/RAW/ForestsSoil_OligotrophicDrained_r10000.tif",
            overwrite=TRUE)



# ForestsSoil_OligotrophicMineral_cell.tif	egv_333 ----

# ForestsSoil_OligotrophicMineral_r500.tif	egv_334
slanis=rast("./RasterGrids_100m/2024/RAW/ForestsSoil_OligotrophicMineral_r500.tif")
names(slanis)="egv_334"
slanis2=project(slanis,template100)
writeRaster(slanis2,
            "./RasterGrids_100m/2024/RAW/ForestsSoil_OligotrophicMineral_r500.tif",
            overwrite=TRUE)

# ForestsSoil_OligotrophicMineral_r1250.tif	egv_335
slanis=rast("./RasterGrids_100m/2024/RAW/ForestsSoil_OligotrophicMineral_r1250.tif")
names(slanis)="egv_335"
slanis2=project(slanis,template100)
writeRaster(slanis2,
            "./RasterGrids_100m/2024/RAW/ForestsSoil_OligotrophicMineral_r1250.tif",
            overwrite=TRUE)

# ForestsSoil_OligotrophicMineral_r3000.tif	egv_336
slanis=rast("./RasterGrids_100m/2024/RAW/ForestsSoil_OligotrophicMineral_r3000.tif")
names(slanis)="egv_336"
slanis2=project(slanis,template100)
writeRaster(slanis2,
            "./RasterGrids_100m/2024/RAW/ForestsSoil_OligotrophicMineral_r3000.tif",
            overwrite=TRUE)

# ForestsSoil_OligotrophicMineral_r10000.tif	egv_337
slanis=rast("./RasterGrids_100m/2024/RAW/ForestsSoil_OligotrophicMineral_r10000.tif")
names(slanis)="egv_337"
slanis2=project(slanis,template100)
writeRaster(slanis2,
            "./RasterGrids_100m/2024/RAW/ForestsSoil_OligotrophicMineral_r10000.tif",
            overwrite=TRUE)



# ForestsSoil_OligotrophicOrganic_cell.tif	egv_338 ----

# ForestsSoil_OligotrophicOrganic_r500.tif	egv_339
slanis=rast("./RasterGrids_100m/2024/RAW/ForestsSoil_OligotrophicOrganic_r500.tif")
names(slanis)="egv_339"
slanis2=project(slanis,template100)
writeRaster(slanis2,
            "./RasterGrids_100m/2024/RAW/ForestsSoil_OligotrophicOrganic_r500.tif",
            overwrite=TRUE)

# ForestsSoil_OligotrophicOrganic_r1250.tif	egv_340
slanis=rast("./RasterGrids_100m/2024/RAW/ForestsSoil_OligotrophicOrganic_r1250.tif")
names(slanis)="egv_340"
slanis2=project(slanis,template100)
writeRaster(slanis2,
            "./RasterGrids_100m/2024/RAW/ForestsSoil_OligotrophicOrganic_r1250.tif",
            overwrite=TRUE)

# ForestsSoil_OligotrophicOrganic_r3000.tif	egv_341
slanis=rast("./RasterGrids_100m/2024/RAW/ForestsSoil_OligotrophicOrganic_r3000.tif")
names(slanis)="egv_341"
slanis2=project(slanis,template100)
writeRaster(slanis2,
            "./RasterGrids_100m/2024/RAW/ForestsSoil_OligotrophicOrganic_r3000.tif",
            overwrite=TRUE)

# ForestsSoil_OligotrophicOrganic_r10000.tif	egv_342
slanis=rast("./RasterGrids_100m/2024/RAW/ForestsSoil_OligotrophicOrganic_r10000.tif")
names(slanis)="egv_342"
slanis2=project(slanis,template100)
writeRaster(slanis2,
            "./RasterGrids_100m/2024/RAW/ForestsSoil_OligotrophicOrganic_r10000.tif",
            overwrite=TRUE)



# ForestsTreesAge_BorealDeciduousOld_cell.tif	egv_343 ----

# ForestsTreesAge_BorealDeciduousOld_r500.tif	egv_344
slanis=rast("./RasterGrids_100m/2024/RAW/ForestsTreesAge_BorealDeciduousOld_r500.tif")
names(slanis)="egv_344"
slanis2=project(slanis,template100)
writeRaster(slanis2,
            "./RasterGrids_100m/2024/RAW/ForestsTreesAge_BorealDeciduousOld_r500.tif",
            overwrite=TRUE)

# ForestsTreesAge_BorealDeciduousOld_r1250.tif	egv_345
slanis=rast("./RasterGrids_100m/2024/RAW/ForestsTreesAge_BorealDeciduousOld_r1250.tif")
names(slanis)="egv_345"
slanis2=project(slanis,template100)
writeRaster(slanis2,
            "./RasterGrids_100m/2024/RAW/ForestsTreesAge_BorealDeciduousOld_r1250.tif",
            overwrite=TRUE)

# ForestsTreesAge_BorealDeciduousOld_r3000.tif	egv_346
slanis=rast("./RasterGrids_100m/2024/RAW/ForestsTreesAge_BorealDeciduousOld_r3000.tif")
names(slanis)="egv_346"
slanis2=project(slanis,template100)
writeRaster(slanis2,
            "./RasterGrids_100m/2024/RAW/ForestsTreesAge_BorealDeciduousOld_r3000.tif",
            overwrite=TRUE)


# ForestsTreesAge_BorealDeciduousOld_r10000.tif	egv_347
slanis=rast("./RasterGrids_100m/2024/RAW/ForestsTreesAge_BorealDeciduousOld_r10000.tif")
names(slanis)="egv_347"
slanis2=project(slanis,template100)
writeRaster(slanis2,
            "./RasterGrids_100m/2024/RAW/ForestsTreesAge_BorealDeciduousOld_r10000.tif",
            overwrite=TRUE)



# ForestsTreesAge_BorealDeciduousYoung_cell.tif	egv_348 ----

# ForestsTreesAge_BorealDeciduousYoung_r500.tif	egv_349
slanis=rast("./RasterGrids_100m/2024/RAW/ForestsTreesAge_BorealDeciduousYoung_r500.tif")
names(slanis)="egv_349"
slanis2=project(slanis,template100)
writeRaster(slanis2,
            "./RasterGrids_100m/2024/RAW/ForestsTreesAge_BorealDeciduousYoung_r500.tif",
            overwrite=TRUE)

# ForestsTreesAge_BorealDeciduousYoung_r1250.tif	egv_350
slanis=rast("./RasterGrids_100m/2024/RAW/ForestsTreesAge_BorealDeciduousYoung_r1250.tif")
names(slanis)="egv_350"
slanis2=project(slanis,template100)
writeRaster(slanis2,
            "./RasterGrids_100m/2024/RAW/ForestsTreesAge_BorealDeciduousYoung_r1250.tif",
            overwrite=TRUE)

# ForestsTreesAge_BorealDeciduousYoung_r3000.tif	egv_351
slanis=rast("./RasterGrids_100m/2024/RAW/ForestsTreesAge_BorealDeciduousYoung_r3000.tif")
names(slanis)="egv_351"
slanis2=project(slanis,template100)
writeRaster(slanis2,
            "./RasterGrids_100m/2024/RAW/ForestsTreesAge_BorealDeciduousYoung_r3000.tif",
            overwrite=TRUE)

# ForestsTreesAge_BorealDeciduousYoung_r10000.tif	egv_352
slanis=rast("./RasterGrids_100m/2024/RAW/ForestsTreesAge_BorealDeciduousYoung_r10000.tif")
names(slanis)="egv_352"
slanis2=project(slanis,template100)
writeRaster(slanis2,
            "./RasterGrids_100m/2024/RAW/ForestsTreesAge_BorealDeciduousYoung_r10000.tif",
            overwrite=TRUE)



# ForestsTreesAge_ConiferousOld_cell.tif	egv_353 ----

# ForestsTreesAge_ConiferousOld_r500.tif	egv_354
slanis=rast("./RasterGrids_100m/2024/RAW/ForestsTreesAge_ConiferousOld_r500.tif")
names(slanis)="egv_354"
slanis2=project(slanis,template100)
writeRaster(slanis2,
            "./RasterGrids_100m/2024/RAW/ForestsTreesAge_ConiferousOld_r500.tif",
            overwrite=TRUE)

# ForestsTreesAge_ConiferousOld_r1250.tif	egv_355
slanis=rast("./RasterGrids_100m/2024/RAW/ForestsTreesAge_ConiferousOld_r1250.tif")
names(slanis)="egv_355"
slanis2=project(slanis,template100)
writeRaster(slanis2,
            "./RasterGrids_100m/2024/RAW/ForestsTreesAge_ConiferousOld_r1250.tif",
            overwrite=TRUE)

# ForestsTreesAge_ConiferousOld_r3000.tif	egv_356
slanis=rast("./RasterGrids_100m/2024/RAW/ForestsTreesAge_ConiferousOld_r3000.tif")
names(slanis)="egv_356"
slanis2=project(slanis,template100)
writeRaster(slanis2,
            "./RasterGrids_100m/2024/RAW/ForestsTreesAge_ConiferousOld_r3000.tif",
            overwrite=TRUE)

# ForestsTreesAge_ConiferousOld_r10000.tif	egv_357
slanis=rast("./RasterGrids_100m/2024/RAW/ForestsTreesAge_ConiferousOld_r10000.tif")
names(slanis)="egv_357"
slanis2=project(slanis,template100)
writeRaster(slanis2,
            "./RasterGrids_100m/2024/RAW/ForestsTreesAge_ConiferousOld_r10000.tif",
            overwrite=TRUE)



# ForestsTreesAge_ConiferousYoung_cell.tif	egv_358 ----

# ForestsTreesAge_ConiferousYoung_r500.tif	egv_359
slanis=rast("./RasterGrids_100m/2024/RAW/ForestsTreesAge_ConiferousYoung_r500.tif")
names(slanis)="egv_359"
slanis2=project(slanis,template100)
writeRaster(slanis2,
            "./RasterGrids_100m/2024/RAW/ForestsTreesAge_ConiferousYoung_r500.tif",
            overwrite=TRUE)

# ForestsTreesAge_ConiferousYoung_r1250.tif	egv_360
slanis=rast("./RasterGrids_100m/2024/RAW/ForestsTreesAge_ConiferousYoung_r1250.tif")
names(slanis)="egv_360"
slanis2=project(slanis,template100)
writeRaster(slanis2,
            "./RasterGrids_100m/2024/RAW/ForestsTreesAge_ConiferousYoung_r1250.tif",
            overwrite=TRUE)

# ForestsTreesAge_ConiferousYoung_r3000.tif	egv_361
slanis=rast("./RasterGrids_100m/2024/RAW/ForestsTreesAge_ConiferousYoung_r3000.tif")
names(slanis)="egv_361"
slanis2=project(slanis,template100)
writeRaster(slanis2,
            "./RasterGrids_100m/2024/RAW/ForestsTreesAge_ConiferousYoung_r3000.tif",
            overwrite=TRUE)

# ForestsTreesAge_ConiferousYoung_r10000.tif	egv_362
slanis=rast("./RasterGrids_100m/2024/RAW/ForestsTreesAge_ConiferousYoung_r10000.tif")
names(slanis)="egv_362"
slanis2=project(slanis,template100)
writeRaster(slanis2,
            "./RasterGrids_100m/2024/RAW/ForestsTreesAge_ConiferousYoung_r10000.tif",
            overwrite=TRUE)



# ForestsTreesAge_MixedOld_cell.tif	egv_363 ----

# ForestsTreesAge_MixedOld_r500.tif	egv_364
slanis=rast("./RasterGrids_100m/2024/RAW/ForestsTreesAge_MixedOld_r500.tif")
names(slanis)="egv_364"
slanis2=project(slanis,template100)
writeRaster(slanis2,
            "./RasterGrids_100m/2024/RAW/ForestsTreesAge_MixedOld_r500.tif",
            overwrite=TRUE)

# ForestsTreesAge_MixedOld_r1250.tif	egv_365
slanis=rast("./RasterGrids_100m/2024/RAW/ForestsTreesAge_MixedOld_r1250.tif")
names(slanis)="egv_365"
slanis2=project(slanis,template100)
writeRaster(slanis2,
            "./RasterGrids_100m/2024/RAW/ForestsTreesAge_MixedOld_r1250.tif",
            overwrite=TRUE)

# ForestsTreesAge_MixedOld_r3000.tif	egv_366
slanis=rast("./RasterGrids_100m/2024/RAW/ForestsTreesAge_MixedOld_r3000.tif")
names(slanis)="egv_366"
slanis2=project(slanis,template100)
writeRaster(slanis2,
            "./RasterGrids_100m/2024/RAW/ForestsTreesAge_MixedOld_r3000.tif",
            overwrite=TRUE)

# ForestsTreesAge_MixedOld_r10000.tif	egv_367
slanis=rast("./RasterGrids_100m/2024/RAW/ForestsTreesAge_MixedOld_r10000.tif")
names(slanis)="egv_367"
slanis2=project(slanis,template100)
writeRaster(slanis2,
            "./RasterGrids_100m/2024/RAW/ForestsTreesAge_MixedOld_r10000.tif",
            overwrite=TRUE)



# ForestsTreesAge_MixedYoung_cell.tif	egv_368 ----

# ForestsTreesAge_MixedYoung_r500.tif	egv_369
slanis=rast("./RasterGrids_100m/2024/RAW/ForestsTreesAge_MixedYoung_r500.tif")
names(slanis)="egv_369"
slanis2=project(slanis,template100)
writeRaster(slanis2,
            "./RasterGrids_100m/2024/RAW/ForestsTreesAge_MixedYoung_r500.tif",
            overwrite=TRUE)

# ForestsTreesAge_MixedYoung_r1250.tif	egv_370
slanis=rast("./RasterGrids_100m/2024/RAW/ForestsTreesAge_MixedYoung_r1250.tif")
names(slanis)="egv_370"
slanis2=project(slanis,template100)
writeRaster(slanis2,
            "./RasterGrids_100m/2024/RAW/ForestsTreesAge_MixedYoung_r1250.tif",
            overwrite=TRUE)

# ForestsTreesAge_MixedYoung_r3000.tif	egv_371
slanis=rast("./RasterGrids_100m/2024/RAW/ForestsTreesAge_MixedYoung_r3000.tif")
names(slanis)="egv_371"
slanis2=project(slanis,template100)
writeRaster(slanis2,
            "./RasterGrids_100m/2024/RAW/ForestsTreesAge_MixedYoung_r3000.tif",
            overwrite=TRUE)

# ForestsTreesAge_MixedYoung_r10000.tif	egv_372
slanis=rast("./RasterGrids_100m/2024/RAW/ForestsTreesAge_MixedYoung_r10000.tif")
names(slanis)="egv_372"
slanis2=project(slanis,template100)
writeRaster(slanis2,
            "./RasterGrids_100m/2024/RAW/ForestsTreesAge_MixedYoung_r10000.tif",
            overwrite=TRUE)



# ForestsTreesAge_TemperateDeciduousOld_cell.tif	egv_373 ----

# ForestsTreesAge_TemperateDeciduousOld_r500.tif	egv_374
slanis=rast("./RasterGrids_100m/2024/RAW/ForestsTreesAge_TemperateDeciduousOld_r500.tif")
names(slanis)="egv_374"
slanis2=project(slanis,template100)
writeRaster(slanis2,
            "./RasterGrids_100m/2024/RAW/ForestsTreesAge_TemperateDeciduousOld_r500.tif",
            overwrite=TRUE)

# ForestsTreesAge_TemperateDeciduousOld_r1250.tif	egv_375
slanis=rast("./RasterGrids_100m/2024/RAW/ForestsTreesAge_TemperateDeciduousOld_r1250.tif")
names(slanis)="egv_375"
slanis2=project(slanis,template100)
writeRaster(slanis2,
            "./RasterGrids_100m/2024/RAW/ForestsTreesAge_TemperateDeciduousOld_r1250.tif",
            overwrite=TRUE)

# ForestsTreesAge_TemperateDeciduousOld_r3000.tif	egv_376
slanis=rast("./RasterGrids_100m/2024/RAW/ForestsTreesAge_TemperateDeciduousOld_r3000.tif")
names(slanis)="egv_376"
slanis2=project(slanis,template100)
writeRaster(slanis2,
            "./RasterGrids_100m/2024/RAW/ForestsTreesAge_TemperateDeciduousOld_r3000.tif",
            overwrite=TRUE)

# ForestsTreesAge_TemperateDeciduousOld_r10000.tif	egv_377
slanis=rast("./RasterGrids_100m/2024/RAW/ForestsTreesAge_TemperateDeciduousOld_r10000.tif")
names(slanis)="egv_377"
slanis2=project(slanis,template100)
writeRaster(slanis2,
            "./RasterGrids_100m/2024/RAW/ForestsTreesAge_TemperateDeciduousOld_r10000.tif",
            overwrite=TRUE)



# ForestsTreesAge_TemperateDeciduousYoung_cell.tif	egv_378 ----

# ForestsTreesAge_TemperateDeciduousYoung_r500.tif	egv_379
slanis=rast("./RasterGrids_100m/2024/RAW/ForestsTreesAge_TemperateDeciduousYoung_r500.tif")
names(slanis)="egv_379"
slanis2=project(slanis,template100)
writeRaster(slanis2,
            "./RasterGrids_100m/2024/RAW/ForestsTreesAge_TemperateDeciduousYoung_r500.tif",
            overwrite=TRUE)

# ForestsTreesAge_TemperateDeciduousYoung_r1250.tif	egv_380
slanis=rast("./RasterGrids_100m/2024/RAW/ForestsTreesAge_TemperateDeciduousYoung_r1250.tif")
names(slanis)="egv_380"
slanis2=project(slanis,template100)
writeRaster(slanis2,
            "./RasterGrids_100m/2024/RAW/ForestsTreesAge_TemperateDeciduousYoung_r1250.tif",
            overwrite=TRUE)

# ForestsTreesAge_TemperateDeciduousYoung_r3000.tif	egv_381
slanis=rast("./RasterGrids_100m/2024/RAW/ForestsTreesAge_TemperateDeciduousYoung_r3000.tif")
names(slanis)="egv_381"
slanis2=project(slanis,template100)
writeRaster(slanis2,
            "./RasterGrids_100m/2024/RAW/ForestsTreesAge_TemperateDeciduousYoung_r3000.tif",
            overwrite=TRUE)

# ForestsTreesAge_TemperateDeciduousYoung_r10000.tif	egv_382
slanis=rast("./RasterGrids_100m/2024/RAW/ForestsTreesAge_TemperateDeciduousYoung_r10000.tif")
names(slanis)="egv_382"
slanis2=project(slanis,template100)
writeRaster(slanis2,
            "./RasterGrids_100m/2024/RAW/ForestsTreesAge_TemperateDeciduousYoung_r10000.tif",
            overwrite=TRUE)



# ForestsTrees_BorealDeciduous_cell.tif	egv_383 ----

# ForestsTrees_BorealDeciduous_r500.tif	egv_384
slanis=rast("./RasterGrids_100m/2024/RAW/ForestsTrees_BorealDeciduous_r500.tif")
names(slanis)="egv_384"
slanis2=project(slanis,template100)
writeRaster(slanis2,
            "./RasterGrids_100m/2024/RAW/ForestsTrees_BorealDeciduous_r500.tif",
            overwrite=TRUE)

# ForestsTrees_BorealDeciduous_r1250.tif	egv_385
slanis=rast("./RasterGrids_100m/2024/RAW/ForestsTrees_BorealDeciduous_r1250.tif")
names(slanis)="egv_385"
slanis2=project(slanis,template100)
writeRaster(slanis2,
            "./RasterGrids_100m/2024/RAW/ForestsTrees_BorealDeciduous_r1250.tif",
            overwrite=TRUE)

# ForestsTrees_BorealDeciduous_r3000.tif	egv_386
slanis=rast("./RasterGrids_100m/2024/RAW/ForestsTrees_BorealDeciduous_r3000.tif")
names(slanis)="egv_386"
slanis2=project(slanis,template100)
writeRaster(slanis2,
            "./RasterGrids_100m/2024/RAW/ForestsTrees_BorealDeciduous_r3000.tif",
            overwrite=TRUE)

# ForestsTrees_BorealDeciduous_r10000.tif	egv_387
slanis=rast("./RasterGrids_100m/2024/RAW/ForestsTrees_BorealDeciduous_r10000.tif")
names(slanis)="egv_387"
slanis2=project(slanis,template100)
writeRaster(slanis2,
            "./RasterGrids_100m/2024/RAW/ForestsTrees_BorealDeciduous_r10000.tif",
            overwrite=TRUE)



# ForestsTrees_Coniferous_cell.tif	egv_388 ----

# ForestsTrees_Coniferous_r500.tif	egv_389
slanis=rast("./RasterGrids_100m/2024/RAW/ForestsTrees_Coniferous_r500.tif")
names(slanis)="egv_389"
slanis2=project(slanis,template100)
writeRaster(slanis2,
            "./RasterGrids_100m/2024/RAW/ForestsTrees_Coniferous_r500.tif",
            overwrite=TRUE)

# ForestsTrees_Coniferous_r1250.tif	egv_390
slanis=rast("./RasterGrids_100m/2024/RAW/ForestsTrees_Coniferous_r1250.tif")
names(slanis)="egv_390"
slanis2=project(slanis,template100)
writeRaster(slanis2,
            "./RasterGrids_100m/2024/RAW/ForestsTrees_Coniferous_r1250.tif",
            overwrite=TRUE)

# ForestsTrees_Coniferous_r3000.tif	egv_391
slanis=rast("./RasterGrids_100m/2024/RAW/ForestsTrees_Coniferous_r3000.tif")
names(slanis)="egv_391"
slanis2=project(slanis,template100)
writeRaster(slanis2,
            "./RasterGrids_100m/2024/RAW/ForestsTrees_Coniferous_r3000.tif",
            overwrite=TRUE)

# ForestsTrees_Coniferous_r10000.tif	egv_392
slanis=rast("./RasterGrids_100m/2024/RAW/ForestsTrees_Coniferous_r10000.tif")
names(slanis)="egv_392"
slanis2=project(slanis,template100)
writeRaster(slanis2,
            "./RasterGrids_100m/2024/RAW/ForestsTrees_Coniferous_r10000.tif",
            overwrite=TRUE)



# ForestsTrees_Mixed_cell.tif	egv_393 ----

# ForestsTrees_Mixed_r500.tif	egv_394
slanis=rast("./RasterGrids_100m/2024/RAW/ForestsTrees_Mixed_r500.tif")
names(slanis)="egv_394"
slanis2=project(slanis,template100)
writeRaster(slanis2,
            "./RasterGrids_100m/2024/RAW/ForestsTrees_Mixed_r500.tif",
            overwrite=TRUE)

# ForestsTrees_Mixed_r1250.tif	egv_395
slanis=rast("./RasterGrids_100m/2024/RAW/ForestsTrees_Mixed_r1250.tif")
names(slanis)="egv_395"
slanis2=project(slanis,template100)
writeRaster(slanis2,
            "./RasterGrids_100m/2024/RAW/ForestsTrees_Mixed_r1250.tif",
            overwrite=TRUE)

# ForestsTrees_Mixed_r3000.tif	egv_396
slanis=rast("./RasterGrids_100m/2024/RAW/ForestsTrees_Mixed_r3000.tif")
names(slanis)="egv_396"
slanis2=project(slanis,template100)
writeRaster(slanis2,
            "./RasterGrids_100m/2024/RAW/ForestsTrees_Mixed_r3000.tif",
            overwrite=TRUE)

# ForestsTrees_Mixed_r10000.tif	egv_397
slanis=rast("./RasterGrids_100m/2024/RAW/ForestsTrees_Mixed_r10000.tif")
names(slanis)="egv_397"
slanis2=project(slanis,template100)
writeRaster(slanis2,
            "./RasterGrids_100m/2024/RAW/ForestsTrees_Mixed_r10000.tif",
            overwrite=TRUE)



# ForestsTrees_TemperateDeciduous_cell.tif	egv_398 ----

# ForestsTrees_TemperateDeciduous_r500.tif	egv_399
slanis=rast("./RasterGrids_100m/2024/RAW/ForestsTrees_TemperateDeciduous_r500.tif")
names(slanis)="egv_399"
slanis2=project(slanis,template100)
writeRaster(slanis2,
            "./RasterGrids_100m/2024/RAW/ForestsTrees_TemperateDeciduous_r500.tif",
            overwrite=TRUE)

# ForestsTrees_TemperateDeciduous_r1250.tif	egv_400
slanis=rast("./RasterGrids_100m/2024/RAW/ForestsTrees_TemperateDeciduous_r1250.tif")
names(slanis)="egv_400"
slanis2=project(slanis,template100)
writeRaster(slanis2,
            "./RasterGrids_100m/2024/RAW/ForestsTrees_TemperateDeciduous_r1250.tif",
            overwrite=TRUE)

# ForestsTrees_TemperateDeciduous_r3000.tif	egv_401
slanis=rast("./RasterGrids_100m/2024/RAW/ForestsTrees_TemperateDeciduous_r3000.tif")
names(slanis)="egv_401"
slanis2=project(slanis,template100)
writeRaster(slanis2,
            "./RasterGrids_100m/2024/RAW/ForestsTrees_TemperateDeciduous_r3000.tif",
            overwrite=TRUE)

# ForestsTrees_TemperateDeciduous_r10000.tif	egv_402
slanis=rast("./RasterGrids_100m/2024/RAW/ForestsTrees_TemperateDeciduous_r10000.tif")
names(slanis)="egv_402"
slanis2=project(slanis,template100)
writeRaster(slanis2,
            "./RasterGrids_100m/2024/RAW/ForestsTrees_TemperateDeciduous_r10000.tif",
            overwrite=TRUE)
