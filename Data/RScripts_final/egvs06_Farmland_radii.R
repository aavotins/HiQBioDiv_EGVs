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
  input_layers   = c("./RasterGrids_100m/2024/RAW/FarmlandCrops_CropsAll_cell.tif",
                     "./RasterGrids_100m/2024/RAW/FarmlandCrops_CropsHoed_cell.tif",
                     "./RasterGrids_100m/2024/RAW/FarmlandCrops_CropsOther_cell.tif",
                     "./RasterGrids_100m/2024/RAW/FarmlandCrops_CropsSpring_cell.tif",
                     "./RasterGrids_100m/2024/RAW/FarmlandCrops_CropsWinter_cell.tif",
                     "./RasterGrids_100m/2024/RAW/FarmlandCrops_RapeseedsSpring_cell.tif",
                     "./RasterGrids_100m/2024/RAW/FarmlandCrops_RapeseedsWinter_cell.tif",
                     "./RasterGrids_100m/2024/RAW/FarmlandGrassland_GrasslandsAbandoned_cell.tif",
                     "./RasterGrids_100m/2024/RAW/FarmlandGrassland_GrasslandsAll_cell.tif",
                     "./RasterGrids_100m/2024/RAW/FarmlandGrassland_GrasslandsPermanent_cell.tif",
                     "./RasterGrids_100m/2024/RAW/FarmlandGrassland_GrasslandsTemporary_cell.tif",
                     "./RasterGrids_100m/2024/RAW/FarmlandParcels_FieldsActive_cell.tif",
                     "./RasterGrids_100m/2024/RAW/FarmlandPloughed_CropsFallow_cell.tif",
                     "./RasterGrids_100m/2024/RAW/FarmlandPloughed_CropsFallowTempGrass_cell.tif",
                     "./RasterGrids_100m/2024/RAW/FarmlandPloughed_Fallow_cell.tif",
                     "./RasterGrids_100m/2024/RAW/FarmlandSubsidies_BiologicalSubsidies_cell.tif",
                     "./RasterGrids_100m/2024/RAW/FarmlandTrees_PermanentCrops_cell.tif",
                     "./RasterGrids_100m/2024/RAW/FarmlandTrees_ShortRotationCoppice_cell.tif"),
  layer_prefixes = c("FarmlandCrops_CropsAll",
                     "FarmlandCrops_CropsHoed",
                     "FarmlandCrops_CropsOther",
                     "FarmlandCrops_CropsSpring",
                     "FarmlandCrops_CropsWinter",
                     "FarmlandCrops_RapeseedsSpring",
                     "FarmlandCrops_RapeseedsWinter",
                     "FarmlandGrassland_GrasslandsAbandoned",
                     "FarmlandGrassland_GrasslandsAll",
                     "FarmlandGrassland_GrasslandsPermanent",
                     "FarmlandGrassland_GrasslandsTemporary",
                     "FarmlandParcels_FieldsActive",
                     "FarmlandPloughed_CropsFallow",
                     "FarmlandPloughed_CropsFallowTempGrass",
                     "FarmlandPloughed_Fallow",
                     "FarmlandSubsidies_BiologicalSubsidies",
                     "FarmlandTrees_PermanentCrops",
                     "FarmlandTrees_ShortRotationCoppice"),
  output_dir     = "./RasterGrids_100m/2024/RAW/",
  n_workers      = 6,
  radii          = c("r500","r1250","r3000","r10000"),
  radius_mode    = "sparse",
  extract_fun    = "mean",
  fill_missing   = TRUE,
  IDW_weight     = 2,
  future_max_size = 40 * 1024^3)



# FarmlandCrops_CropsAll_cell.tif	egv_180 ----

# FarmlandCrops_CropsAll_r500.tif	egv_181
slanis=rast("./RasterGrids_100m/2024/RAW/FarmlandCrops_CropsAll_r500.tif")
names(slanis)="egv_181"
slanis2=project(slanis,template100)
writeRaster(slanis2,
            "./RasterGrids_100m/2024/RAW/FarmlandCrops_CropsAll_r500.tif",
            overwrite=TRUE)

# FarmlandCrops_CropsAll_r1250.tif	egv_182
slanis=rast("./RasterGrids_100m/2024/RAW/FarmlandCrops_CropsAll_r1250.tif")
names(slanis)="egv_182"
slanis2=project(slanis,template100)
writeRaster(slanis2,
            "./RasterGrids_100m/2024/RAW/FarmlandCrops_CropsAll_r1250.tif",
            overwrite=TRUE)

# FarmlandCrops_CropsAll_r3000.tif	egv_183
slanis=rast("./RasterGrids_100m/2024/RAW/FarmlandCrops_CropsAll_r3000.tif")
names(slanis)="egv_183"
slanis2=project(slanis,template100)
writeRaster(slanis2,
            "./RasterGrids_100m/2024/RAW/FarmlandCrops_CropsAll_r3000.tif",
            overwrite=TRUE)

# FarmlandCrops_CropsAll_r10000.tif	egv_184
slanis=rast("./RasterGrids_100m/2024/RAW/FarmlandCrops_CropsAll_r10000.tif")
names(slanis)="egv_184"
slanis2=project(slanis,template100)
writeRaster(slanis2,
            "./RasterGrids_100m/2024/RAW/FarmlandCrops_CropsAll_r10000.tif",
            overwrite=TRUE)


# FarmlandCrops_CropsHoed_cell.tif	egv_185 ----

# FarmlandCrops_CropsHoed_r500.tif	egv_186
slanis=rast("./RasterGrids_100m/2024/RAW/FarmlandCrops_CropsHoed_r500.tif")
names(slanis)="egv_186"
slanis2=project(slanis,template100)
writeRaster(slanis2,
            "./RasterGrids_100m/2024/RAW/FarmlandCrops_CropsHoed_r500.tif",
            overwrite=TRUE)

# FarmlandCrops_CropsHoed_r1250.tif	egv_187
slanis=rast("./RasterGrids_100m/2024/RAW/FarmlandCrops_CropsHoed_r1250.tif")
names(slanis)="egv_187"
slanis2=project(slanis,template100)
writeRaster(slanis2,
            "./RasterGrids_100m/2024/RAW/FarmlandCrops_CropsHoed_r1250.tif",
            overwrite=TRUE)

# FarmlandCrops_CropsHoed_r3000.tif	egv_188
slanis=rast("./RasterGrids_100m/2024/RAW/FarmlandCrops_CropsHoed_r3000.tif")
names(slanis)="egv_188"
slanis2=project(slanis,template100)
writeRaster(slanis2,
            "./RasterGrids_100m/2024/RAW/FarmlandCrops_CropsHoed_r3000.tif",
            overwrite=TRUE)

# FarmlandCrops_CropsHoed_r10000.tif	egv_189
slanis=rast("./RasterGrids_100m/2024/RAW/FarmlandCrops_CropsHoed_r10000.tif")
names(slanis)="egv_189"
slanis2=project(slanis,template100)
writeRaster(slanis2,
            "./RasterGrids_100m/2024/RAW/FarmlandCrops_CropsHoed_r10000.tif",
            overwrite=TRUE)



# FarmlandCrops_CropsOther_cell.tif	egv_190 ----

# FarmlandCrops_CropsOther_r500.tif	egv_191
slanis=rast("./RasterGrids_100m/2024/RAW/FarmlandCrops_CropsOther_r500.tif")
names(slanis)="egv_191"
slanis2=project(slanis,template100)
writeRaster(slanis2,
            "./RasterGrids_100m/2024/RAW/FarmlandCrops_CropsOther_r500.tif",
            overwrite=TRUE)

# FarmlandCrops_CropsOther_r1250.tif	egv_192
slanis=rast("./RasterGrids_100m/2024/RAW/FarmlandCrops_CropsOther_r1250.tif")
names(slanis)="egv_192"
slanis2=project(slanis,template100)
writeRaster(slanis2,
            "./RasterGrids_100m/2024/RAW/FarmlandCrops_CropsOther_r1250.tif",
            overwrite=TRUE)

# FarmlandCrops_CropsOther_r3000.tif	egv_193
slanis=rast("./RasterGrids_100m/2024/RAW/FarmlandCrops_CropsOther_r3000.tif")
names(slanis)="egv_193"
slanis2=project(slanis,template100)
writeRaster(slanis2,
            "./RasterGrids_100m/2024/RAW/FarmlandCrops_CropsOther_r3000.tif",
            overwrite=TRUE)

# FarmlandCrops_CropsOther_r10000.tif	egv_194
slanis=rast("./RasterGrids_100m/2024/RAW/FarmlandCrops_CropsOther_r10000.tif")
names(slanis)="egv_194"
slanis2=project(slanis,template100)
writeRaster(slanis2,
            "./RasterGrids_100m/2024/RAW/FarmlandCrops_CropsOther_r10000.tif",
            overwrite=TRUE)



# FarmlandCrops_CropsSpring_cell.tif	egv_195 ----

# FarmlandCrops_CropsSpring_r500.tif	egv_196
slanis=rast("./RasterGrids_100m/2024/RAW/FarmlandCrops_CropsSpring_r500.tif")
names(slanis)="egv_196"
slanis2=project(slanis,template100)
writeRaster(slanis2,
            "./RasterGrids_100m/2024/RAW/FarmlandCrops_CropsSpring_r500.tif",
            overwrite=TRUE)

# FarmlandCrops_CropsSpring_r1250.tif	egv_197
slanis=rast("./RasterGrids_100m/2024/RAW/FarmlandCrops_CropsSpring_r1250.tif")
names(slanis)="egv_197"
slanis2=project(slanis,template100)
writeRaster(slanis2,
            "./RasterGrids_100m/2024/RAW/FarmlandCrops_CropsSpring_r1250.tif",
            overwrite=TRUE)

# FarmlandCrops_CropsSpring_r3000.tif	egv_198
slanis=rast("./RasterGrids_100m/2024/RAW/FarmlandCrops_CropsSpring_r3000.tif")
names(slanis)="egv_198"
slanis2=project(slanis,template100)
writeRaster(slanis2,
            "./RasterGrids_100m/2024/RAW/FarmlandCrops_CropsSpring_r3000.tif",
            overwrite=TRUE)

# FarmlandCrops_CropsSpring_r10000.tif	egv_199
slanis=rast("./RasterGrids_100m/2024/RAW/FarmlandCrops_CropsSpring_r10000.tif")
names(slanis)="egv_199"
slanis2=project(slanis,template100)
writeRaster(slanis2,
            "./RasterGrids_100m/2024/RAW/FarmlandCrops_CropsSpring_r10000.tif",
            overwrite=TRUE)



# FarmlandCrops_CropsWinter_cell.tif	egv_200 ----

# FarmlandCrops_CropsWinter_r500.tif	egv_201
slanis=rast("./RasterGrids_100m/2024/RAW/FarmlandCrops_CropsWinter_r500.tif")
names(slanis)="egv_201"
slanis2=project(slanis,template100)
writeRaster(slanis2,
            "./RasterGrids_100m/2024/RAW/FarmlandCrops_CropsWinter_r500.tif",
            overwrite=TRUE)

# FarmlandCrops_CropsWinter_r1250.tif	egv_202
slanis=rast("./RasterGrids_100m/2024/RAW/FarmlandCrops_CropsWinter_r1250.tif")
names(slanis)="egv_202"
slanis2=project(slanis,template100)
writeRaster(slanis2,
            "./RasterGrids_100m/2024/RAW/FarmlandCrops_CropsWinter_r1250.tif",
            overwrite=TRUE)

# FarmlandCrops_CropsWinter_r3000.tif	egv_203
slanis=rast("./RasterGrids_100m/2024/RAW/FarmlandCrops_CropsWinter_r3000.tif")
names(slanis)="egv_203"
slanis2=project(slanis,template100)
writeRaster(slanis2,
            "./RasterGrids_100m/2024/RAW/FarmlandCrops_CropsWinter_r3000.tif",
            overwrite=TRUE)

# FarmlandCrops_CropsWinter_r10000.tif	egv_204
slanis=rast("./RasterGrids_100m/2024/RAW/FarmlandCrops_CropsWinter_r10000.tif")
names(slanis)="egv_204"
slanis2=project(slanis,template100)
writeRaster(slanis2,
            "./RasterGrids_100m/2024/RAW/FarmlandCrops_CropsWinter_r10000.tif",
            overwrite=TRUE)



# FarmlandCrops_RapeseedsSpring_cell.tif	egv_205 ----

# FarmlandCrops_RapeseedsSpring_r500.tif	egv_206
slanis=rast("./RasterGrids_100m/2024/RAW/FarmlandCrops_RapeseedsSpring_r500.tif")
names(slanis)="egv_206"
slanis2=project(slanis,template100)
writeRaster(slanis2,
            "./RasterGrids_100m/2024/RAW/FarmlandCrops_RapeseedsSpring_r500.tif",
            overwrite=TRUE)

# FarmlandCrops_RapeseedsSpring_r1250.tif	egv_207
slanis=rast("./RasterGrids_100m/2024/RAW/FarmlandCrops_RapeseedsSpring_r1250.tif")
names(slanis)="egv_207"
slanis2=project(slanis,template100)
writeRaster(slanis2,
            "./RasterGrids_100m/2024/RAW/FarmlandCrops_RapeseedsSpring_r1250.tif",
            overwrite=TRUE)

# FarmlandCrops_RapeseedsSpring_r3000.tif	egv_208
slanis=rast("./RasterGrids_100m/2024/RAW/FarmlandCrops_RapeseedsSpring_r3000.tif")
names(slanis)="egv_208"
slanis2=project(slanis,template100)
writeRaster(slanis2,
            "./RasterGrids_100m/2024/RAW/FarmlandCrops_RapeseedsSpring_r3000.tif",
            overwrite=TRUE)

# FarmlandCrops_RapeseedsSpring_r10000.tif	egv_209
slanis=rast("./RasterGrids_100m/2024/RAW/FarmlandCrops_RapeseedsSpring_r10000.tif")
names(slanis)="egv_209"
slanis2=project(slanis,template100)
writeRaster(slanis2,
            "./RasterGrids_100m/2024/RAW/FarmlandCrops_RapeseedsSpring_r10000.tif",
            overwrite=TRUE)



# FarmlandCrops_RapeseedsWinter_cell.tif	egv_210 ----

# FarmlandCrops_RapeseedsWinter_r500.tif	egv_211
slanis=rast("./RasterGrids_100m/2024/RAW/FarmlandCrops_RapeseedsWinter_r500.tif")
names(slanis)="egv_211"
slanis2=project(slanis,template100)
writeRaster(slanis2,
            "./RasterGrids_100m/2024/RAW/FarmlandCrops_RapeseedsWinter_r500.tif",
            overwrite=TRUE)

# FarmlandCrops_RapeseedsWinter_r1250.tif	egv_212
slanis=rast("./RasterGrids_100m/2024/RAW/FarmlandCrops_RapeseedsWinter_r1250.tif")
names(slanis)="egv_212"
slanis2=project(slanis,template100)
writeRaster(slanis2,
            "./RasterGrids_100m/2024/RAW/FarmlandCrops_RapeseedsWinter_r1250.tif",
            overwrite=TRUE)

# FarmlandCrops_RapeseedsWinter_r3000.tif	egv_213
slanis=rast("./RasterGrids_100m/2024/RAW/FarmlandCrops_RapeseedsWinter_r3000.tif")
names(slanis)="egv_213"
slanis2=project(slanis,template100)
writeRaster(slanis2,
            "./RasterGrids_100m/2024/RAW/FarmlandCrops_RapeseedsWinter_r3000.tif",
            overwrite=TRUE)

# FarmlandCrops_RapeseedsWinter_r10000.tif	egv_214
slanis=rast("./RasterGrids_100m/2024/RAW/FarmlandCrops_RapeseedsWinter_r10000.tif")
names(slanis)="egv_214"
slanis2=project(slanis,template100)
writeRaster(slanis2,
            "./RasterGrids_100m/2024/RAW/FarmlandCrops_RapeseedsWinter_r10000.tif",
            overwrite=TRUE)



# FarmlandGrassland_GrasslandsAbandoned_cell.tif	egv_215 ----

# FarmlandGrassland_GrasslandsAbandoned_r500.tif	egv_216
slanis=rast("./RasterGrids_100m/2024/RAW/FarmlandGrassland_GrasslandsAbandoned_r500.tif")
names(slanis)="egv_216"
slanis2=project(slanis,template100)
writeRaster(slanis2,
            "./RasterGrids_100m/2024/RAW/FarmlandGrassland_GrasslandsAbandoned_r500.tif",
            overwrite=TRUE)

# FarmlandGrassland_GrasslandsAbandoned_r1250.tif	egv_217
slanis=rast("./RasterGrids_100m/2024/RAW/FarmlandGrassland_GrasslandsAbandoned_r1250.tif")
names(slanis)="egv_217"
slanis2=project(slanis,template100)
writeRaster(slanis2,
            "./RasterGrids_100m/2024/RAW/FarmlandGrassland_GrasslandsAbandoned_r1250.tif",
            overwrite=TRUE)

# FarmlandGrassland_GrasslandsAbandoned_r3000.tif	egv_218
slanis=rast("./RasterGrids_100m/2024/RAW/FarmlandGrassland_GrasslandsAbandoned_r3000.tif")
names(slanis)="egv_218"
slanis2=project(slanis,template100)
writeRaster(slanis2,
            "./RasterGrids_100m/2024/RAW/FarmlandGrassland_GrasslandsAbandoned_r3000.tif",
            overwrite=TRUE)

# FarmlandGrassland_GrasslandsAbandoned_r10000.tif	egv_219
slanis=rast("./RasterGrids_100m/2024/RAW/FarmlandGrassland_GrasslandsAbandoned_r10000.tif")
names(slanis)="egv_219"
slanis2=project(slanis,template100)
writeRaster(slanis2,
            "./RasterGrids_100m/2024/RAW/FarmlandGrassland_GrasslandsAbandoned_r10000.tif",
            overwrite=TRUE)



# FarmlandGrassland_GrasslandsAll_cell.tif	egv_220 ----

# FarmlandGrassland_GrasslandsAll_r500.tif	egv_221
slanis=rast("./RasterGrids_100m/2024/RAW/FarmlandGrassland_GrasslandsAll_r500.tif")
names(slanis)="egv_221"
slanis2=project(slanis,template100)
writeRaster(slanis2,
            "./RasterGrids_100m/2024/RAW/FarmlandGrassland_GrasslandsAll_r500.tif",
            overwrite=TRUE)

# FarmlandGrassland_GrasslandsAll_r1250.tif	egv_222
slanis=rast("./RasterGrids_100m/2024/RAW/FarmlandGrassland_GrasslandsAll_r1250.tif")
names(slanis)="egv_222"
slanis2=project(slanis,template100)
writeRaster(slanis2,
            "./RasterGrids_100m/2024/RAW/FarmlandGrassland_GrasslandsAll_r1250.tif",
            overwrite=TRUE)

# FarmlandGrassland_GrasslandsAll_r3000.tif	egv_223
slanis=rast("./RasterGrids_100m/2024/RAW/FarmlandGrassland_GrasslandsAll_r3000.tif")
names(slanis)="egv_223"
slanis2=project(slanis,template100)
writeRaster(slanis2,
            "./RasterGrids_100m/2024/RAW/FarmlandGrassland_GrasslandsAll_r3000.tif",
            overwrite=TRUE)

# FarmlandGrassland_GrasslandsAll_r10000.tif	egv_224
slanis=rast("./RasterGrids_100m/2024/RAW/FarmlandGrassland_GrasslandsAll_r10000.tif")
names(slanis)="egv_224"
slanis2=project(slanis,template100)
writeRaster(slanis2,
            "./RasterGrids_100m/2024/RAW/FarmlandGrassland_GrasslandsAll_r10000.tif",
            overwrite=TRUE)



# FarmlandGrassland_GrasslandsPermanent_cell.tif	egv_225 ----

# FarmlandGrassland_GrasslandsPermanent_r500.tif	egv_226
slanis=rast("./RasterGrids_100m/2024/RAW/FarmlandGrassland_GrasslandsPermanent_r500.tif")
names(slanis)="egv_226"
slanis2=project(slanis,template100)
writeRaster(slanis2,
            "./RasterGrids_100m/2024/RAW/FarmlandGrassland_GrasslandsPermanent_r500.tif",
            overwrite=TRUE)

# FarmlandGrassland_GrasslandsPermanent_r1250.tif	egv_227
slanis=rast("./RasterGrids_100m/2024/RAW/FarmlandGrassland_GrasslandsPermanent_r1250.tif")
names(slanis)="egv_227"
slanis2=project(slanis,template100)
writeRaster(slanis2,
            "./RasterGrids_100m/2024/RAW/FarmlandGrassland_GrasslandsPermanent_r1250.tif",
            overwrite=TRUE)

# FarmlandGrassland_GrasslandsPermanent_r3000.tif	egv_228
slanis=rast("./RasterGrids_100m/2024/RAW/FarmlandGrassland_GrasslandsPermanent_r3000.tif")
names(slanis)="egv_228"
slanis2=project(slanis,template100)
writeRaster(slanis2,
            "./RasterGrids_100m/2024/RAW/FarmlandGrassland_GrasslandsPermanent_r3000.tif",
            overwrite=TRUE)

# FarmlandGrassland_GrasslandsPermanent_r10000.tif	egv_229
slanis=rast("./RasterGrids_100m/2024/RAW/FarmlandGrassland_GrasslandsPermanent_r10000.tif")
names(slanis)="egv_229"
slanis2=project(slanis,template100)
writeRaster(slanis2,
            "./RasterGrids_100m/2024/RAW/FarmlandGrassland_GrasslandsPermanent_r10000.tif",
            overwrite=TRUE)



# FarmlandGrassland_GrasslandsTemporary_cell.tif	egv_230 ----

# FarmlandGrassland_GrasslandsTemporary_r500.tif	egv_231
slanis=rast("./RasterGrids_100m/2024/RAW/FarmlandGrassland_GrasslandsTemporary_r500.tif")
names(slanis)="egv_231"
slanis2=project(slanis,template100)
writeRaster(slanis2,
            "./RasterGrids_100m/2024/RAW/FarmlandGrassland_GrasslandsTemporary_r500.tif",
            overwrite=TRUE)

# FarmlandGrassland_GrasslandsTemporary_r1250.tif	egv_232
slanis=rast("./RasterGrids_100m/2024/RAW/FarmlandGrassland_GrasslandsTemporary_r1250.tif")
names(slanis)="egv_232"
slanis2=project(slanis,template100)
writeRaster(slanis2,
            "./RasterGrids_100m/2024/RAW/FarmlandGrassland_GrasslandsTemporary_r1250.tif",
            overwrite=TRUE)

# FarmlandGrassland_GrasslandsTemporary_r3000.tif	egv_233
slanis=rast("./RasterGrids_100m/2024/RAW/FarmlandGrassland_GrasslandsTemporary_r3000.tif")
names(slanis)="egv_233"
slanis2=project(slanis,template100)
writeRaster(slanis2,
            "./RasterGrids_100m/2024/RAW/FarmlandGrassland_GrasslandsTemporary_r3000.tif",
            overwrite=TRUE)

# FarmlandGrassland_GrasslandsTemporary_r10000.tif	egv_234
slanis=rast("./RasterGrids_100m/2024/RAW/FarmlandGrassland_GrasslandsTemporary_r10000.tif")
names(slanis)="egv_234"
slanis2=project(slanis,template100)
writeRaster(slanis2,
            "./RasterGrids_100m/2024/RAW/FarmlandGrassland_GrasslandsTemporary_r10000.tif",
            overwrite=TRUE)



# FarmlandParcels_FieldsActive_cell.tif	egv_235 ----

# FarmlandParcels_FieldsActive_r500.tif	egv_236
slanis=rast("./RasterGrids_100m/2024/RAW/FarmlandParcels_FieldsActive_r500.tif")
names(slanis)="egv_236"
slanis2=project(slanis,template100)
writeRaster(slanis2,
            "./RasterGrids_100m/2024/RAW/FarmlandParcels_FieldsActive_r500.tif",
            overwrite=TRUE)

# FarmlandParcels_FieldsActive_r1250.tif	egv_237
slanis=rast("./RasterGrids_100m/2024/RAW/FarmlandParcels_FieldsActive_r1250.tif")
names(slanis)="egv_237"
slanis2=project(slanis,template100)
writeRaster(slanis2,
            "./RasterGrids_100m/2024/RAW/FarmlandParcels_FieldsActive_r1250.tif",
            overwrite=TRUE)

# FarmlandParcels_FieldsActive_r3000.tif	egv_238
slanis=rast("./RasterGrids_100m/2024/RAW/FarmlandParcels_FieldsActive_r3000.tif")
names(slanis)="egv_238"
slanis2=project(slanis,template100)
writeRaster(slanis2,
            "./RasterGrids_100m/2024/RAW/FarmlandParcels_FieldsActive_r3000.tif",
            overwrite=TRUE)

# FarmlandParcels_FieldsActive_r10000.tif	egv_239
slanis=rast("./RasterGrids_100m/2024/RAW/FarmlandParcels_FieldsActive_r10000.tif")
names(slanis)="egv_239"
slanis2=project(slanis,template100)
writeRaster(slanis2,
            "./RasterGrids_100m/2024/RAW/FarmlandParcels_FieldsActive_r10000.tif",
            overwrite=TRUE)



# FarmlandPloughed_CropsFallow_cell.tif	egv_240 ----

# FarmlandPloughed_CropsFallow_r500.tif	egv_241
slanis=rast("./RasterGrids_100m/2024/RAW/FarmlandPloughed_CropsFallow_r500.tif")
names(slanis)="egv_241"
slanis2=project(slanis,template100)
writeRaster(slanis2,
            "./RasterGrids_100m/2024/RAW/FarmlandPloughed_CropsFallow_r500.tif",
            overwrite=TRUE)

# FarmlandPloughed_CropsFallow_r1250.tif	egv_242
slanis=rast("./RasterGrids_100m/2024/RAW/FarmlandPloughed_CropsFallow_r1250.tif")
names(slanis)="egv_242"
slanis2=project(slanis,template100)
writeRaster(slanis2,
            "./RasterGrids_100m/2024/RAW/FarmlandPloughed_CropsFallow_r1250.tif",
            overwrite=TRUE)

# FarmlandPloughed_CropsFallow_r3000.tif	egv_243
slanis=rast("./RasterGrids_100m/2024/RAW/FarmlandPloughed_CropsFallow_r3000.tif")
names(slanis)="egv_243"
slanis2=project(slanis,template100)
writeRaster(slanis2,
            "./RasterGrids_100m/2024/RAW/FarmlandPloughed_CropsFallow_r3000.tif",
            overwrite=TRUE)

# FarmlandPloughed_CropsFallow_r10000.tif	egv_244
slanis=rast("./RasterGrids_100m/2024/RAW/FarmlandPloughed_CropsFallow_r10000.tif")
names(slanis)="egv_244"
slanis2=project(slanis,template100)
writeRaster(slanis2,
            "./RasterGrids_100m/2024/RAW/FarmlandPloughed_CropsFallow_r10000.tif",
            overwrite=TRUE)



# FarmlandPloughed_CropsFallowTempGrass_cell.tif	egv_245 ----

# FarmlandPloughed_CropsFallowTempGrass_r500.tif	egv_246
slanis=rast("./RasterGrids_100m/2024/RAW/FarmlandPloughed_CropsFallowTempGrass_r500.tif")
names(slanis)="egv_246"
slanis2=project(slanis,template100)
writeRaster(slanis2,
            "./RasterGrids_100m/2024/RAW/FarmlandPloughed_CropsFallowTempGrass_r500.tif",
            overwrite=TRUE)

# FarmlandPloughed_CropsFallowTempGrass_r1250.tif	egv_247
slanis=rast("./RasterGrids_100m/2024/RAW/FarmlandPloughed_CropsFallowTempGrass_r1250.tif")
names(slanis)="egv_247"
slanis2=project(slanis,template100)
writeRaster(slanis2,
            "./RasterGrids_100m/2024/RAW/FarmlandPloughed_CropsFallowTempGrass_r1250.tif",
            overwrite=TRUE)

# FarmlandPloughed_CropsFallowTempGrass_r3000.tif	egv_248
slanis=rast("./RasterGrids_100m/2024/RAW/FarmlandPloughed_CropsFallowTempGrass_r3000.tif")
names(slanis)="egv_248"
slanis2=project(slanis,template100)
writeRaster(slanis2,
            "./RasterGrids_100m/2024/RAW/FarmlandPloughed_CropsFallowTempGrass_r3000.tif",
            overwrite=TRUE)

# FarmlandPloughed_CropsFallowTempGrass_r10000.tif	egv_249
slanis=rast("./RasterGrids_100m/2024/RAW/FarmlandPloughed_CropsFallowTempGrass_r10000.tif")
names(slanis)="egv_249"
slanis2=project(slanis,template100)
writeRaster(slanis2,
            "./RasterGrids_100m/2024/RAW/FarmlandPloughed_CropsFallowTempGrass_r10000.tif",
            overwrite=TRUE)



# FarmlandPloughed_Fallow_cell.tif	egv_250 ----

# FarmlandPloughed_Fallow_r500.tif	egv_251
slanis=rast("./RasterGrids_100m/2024/RAW/FarmlandPloughed_Fallow_r500.tif")
names(slanis)="egv_251"
slanis2=project(slanis,template100)
writeRaster(slanis2,
            "./RasterGrids_100m/2024/RAW/FarmlandPloughed_Fallow_r500.tif",
            overwrite=TRUE)

# FarmlandPloughed_Fallow_r1250.tif	egv_252
slanis=rast("./RasterGrids_100m/2024/RAW/FarmlandPloughed_Fallow_r1250.tif")
names(slanis)="egv_252"
slanis2=project(slanis,template100)
writeRaster(slanis2,
            "./RasterGrids_100m/2024/RAW/FarmlandPloughed_Fallow_r1250.tif",
            overwrite=TRUE)

# FarmlandPloughed_Fallow_r3000.tif	egv_253
slanis=rast("./RasterGrids_100m/2024/RAW/FarmlandPloughed_Fallow_r3000.tif")
names(slanis)="egv_253"
slanis2=project(slanis,template100)
writeRaster(slanis2,
            "./RasterGrids_100m/2024/RAW/FarmlandPloughed_Fallow_r3000.tif",
            overwrite=TRUE)

# FarmlandPloughed_Fallow_r10000.tif	egv_254
slanis=rast("./RasterGrids_100m/2024/RAW/FarmlandPloughed_Fallow_r10000.tif")
names(slanis)="egv_254"
slanis2=project(slanis,template100)
writeRaster(slanis2,
            "./RasterGrids_100m/2024/RAW/FarmlandPloughed_Fallow_r10000.tif",
            overwrite=TRUE)



# FarmlandSubsidies_BiologicalSubsidies_cell.tif	egv_255 ----

# FarmlandSubsidies_BiologicalSubsidies_r500.tif	egv_256
slanis=rast("./RasterGrids_100m/2024/RAW/FarmlandSubsidies_BiologicalSubsidies_r500.tif")
names(slanis)="egv_256"
slanis2=project(slanis,template100)
writeRaster(slanis2,
            "./RasterGrids_100m/2024/RAW/FarmlandSubsidies_BiologicalSubsidies_r500.tif",
            overwrite=TRUE)

# FarmlandSubsidies_BiologicalSubsidies_r1250.tif	egv_257
slanis=rast("./RasterGrids_100m/2024/RAW/FarmlandSubsidies_BiologicalSubsidies_r1250.tif")
names(slanis)="egv_257"
slanis2=project(slanis,template100)
writeRaster(slanis2,
            "./RasterGrids_100m/2024/RAW/FarmlandSubsidies_BiologicalSubsidies_r1250.tif",
            overwrite=TRUE)

# FarmlandSubsidies_BiologicalSubsidies_r3000.tif	egv_258
slanis=rast("./RasterGrids_100m/2024/RAW/FarmlandSubsidies_BiologicalSubsidies_r3000.tif")
names(slanis)="egv_258"
slanis2=project(slanis,template100)
writeRaster(slanis2,
            "./RasterGrids_100m/2024/RAW/FarmlandSubsidies_BiologicalSubsidies_r3000.tif",
            overwrite=TRUE)

# FarmlandSubsidies_BiologicalSubsidies_r10000.tif	egv_259
slanis=rast("./RasterGrids_100m/2024/RAW/FarmlandSubsidies_BiologicalSubsidies_r10000.tif")
names(slanis)="egv_259"
slanis2=project(slanis,template100)
writeRaster(slanis2,
            "./RasterGrids_100m/2024/RAW/FarmlandSubsidies_BiologicalSubsidies_r10000.tif",
            overwrite=TRUE)



# FarmlandTrees_PermanentCrops_cell.tif	egv_260 ----

# FarmlandTrees_PermanentCrops_r500.tif	egv_261
slanis=rast("./RasterGrids_100m/2024/RAW/FarmlandTrees_PermanentCrops_r500.tif")
names(slanis)="egv_261"
slanis2=project(slanis,template100)
writeRaster(slanis2,
            "./RasterGrids_100m/2024/RAW/FarmlandTrees_PermanentCrops_r500.tif",
            overwrite=TRUE)

# FarmlandTrees_PermanentCrops_r1250.tif	egv_262
slanis=rast("./RasterGrids_100m/2024/RAW/FarmlandTrees_PermanentCrops_r1250.tif")
names(slanis)="egv_262"
slanis2=project(slanis,template100)
writeRaster(slanis2,
            "./RasterGrids_100m/2024/RAW/FarmlandTrees_PermanentCrops_r1250.tif",
            overwrite=TRUE)

# FarmlandTrees_PermanentCrops_r3000.tif	egv_263
slanis=rast("./RasterGrids_100m/2024/RAW/FarmlandTrees_PermanentCrops_r3000.tif")
names(slanis)="egv_263"
slanis2=project(slanis,template100)
writeRaster(slanis2,
            "./RasterGrids_100m/2024/RAW/FarmlandTrees_PermanentCrops_r3000.tif",
            overwrite=TRUE)

# FarmlandTrees_PermanentCrops_r10000.tif	egv_264
slanis=rast("./RasterGrids_100m/2024/RAW/FarmlandTrees_PermanentCrops_r10000.tif")
names(slanis)="egv_264"
slanis2=project(slanis,template100)
writeRaster(slanis2,
            "./RasterGrids_100m/2024/RAW/FarmlandTrees_PermanentCrops_r10000.tif",
            overwrite=TRUE)



# FarmlandTrees_ShortRotationCoppice_cell.tif	egv_265 ----

# FarmlandTrees_ShortRotationCoppice_r500.tif	egv_266
slanis=rast("./RasterGrids_100m/2024/RAW/FarmlandTrees_ShortRotationCoppice_r500.tif")
names(slanis)="egv_266"
slanis2=project(slanis,template100)
writeRaster(slanis2,
            "./RasterGrids_100m/2024/RAW/FarmlandTrees_ShortRotationCoppice_r500.tif",
            overwrite=TRUE)

# FarmlandTrees_ShortRotationCoppice_r1250.tif	egv_267
slanis=rast("./RasterGrids_100m/2024/RAW/FarmlandTrees_ShortRotationCoppice_r1250.tif")
names(slanis)="egv_267"
slanis2=project(slanis,template100)
writeRaster(slanis2,
            "./RasterGrids_100m/2024/RAW/FarmlandTrees_ShortRotationCoppice_r1250.tif",
            overwrite=TRUE)

# FarmlandTrees_ShortRotationCoppice_r3000.tif	egv_268
slanis=rast("./RasterGrids_100m/2024/RAW/FarmlandTrees_ShortRotationCoppice_r3000.tif")
names(slanis)="egv_268"
slanis2=project(slanis,template100)
writeRaster(slanis2,
            "./RasterGrids_100m/2024/RAW/FarmlandTrees_ShortRotationCoppice_r3000.tif",
            overwrite=TRUE)

# FarmlandTrees_ShortRotationCoppice_r10000.tif	egv_269
slanis=rast("./RasterGrids_100m/2024/RAW/FarmlandTrees_ShortRotationCoppice_r10000.tif")
names(slanis)="egv_269"
slanis2=project(slanis,template100)
writeRaster(slanis2,
            "./RasterGrids_100m/2024/RAW/FarmlandTrees_ShortRotationCoppice_r10000.tif",
            overwrite=TRUE)