# Libs ----
if(!require(terra)) {install.packages("terra"); require(terra)}
if(!require(egvtools)) {remotes::install_github("aavotins/egvtools"); require(egvtools)}

# Templates -----
template100=rast("./Templates/TemplateRasters/LV100m_10km.tif")

# Edges_OldForests_cell.tif	egv_145
landscape_function(
  landscape      = "./RasterGrids_10m/2024/Edges_OldForests_input.tif",
  zones          = "./Templates/TemplateGrids/tikls100_sauzeme.parquet",
  id_field       = "id",
  tile_field     = "tks50km",
  template       = "./Templates/TemplateRasters/LV100m_10km.tif",
  out_dir        = "./RasterGrids_100m/2024/RAW",
  out_filename   = "Edges_OldForests_cell.tif",
  out_layername  = "egv_145",
  what             = "lsm_l_te",
  lm_args          = list(count_boundary = FALSE),
  rasterize_engine = "fasterize",
  n_workers      = 12,
  future_max_size = 5 * 1024^3,
  fill_gaps      = TRUE,
  plot_gaps      = FALSE,
  plot_result    = FALSE
)



radius_function(
  kvadrati_path  = "./Templates/TemplateGrids/tiles/",
  radii_path     = "./Templates/TemplateGridPoints/tiles/",
  tikls100_path  = "./Templates/TemplateGrids/tikls100_sauzeme.parquet",
  template_path  = "./Templates/TemplateRasters/LV100m_10km.tif",
  input_layers   = c("./RasterGrids_100m/2024/RAW/Edges_OldForests_cell.tif"),
  layer_prefixes = c("Edges_OldForests"),
  output_dir     = "./RasterGrids_100m/2024/RAW/",
  n_workers      = 12,
  radii          = c("r500","r1250","r3000","r10000"),
  radius_mode    = "sparse",
  extract_fun    = "mean",
  fill_missing   = TRUE,
  IDW_weight     = 2,
  future_max_size = 5 * 1024^3)


# Edges_OldForests_r500.tif	egv_146
slanis=rast("./RasterGrids_100m/2024/RAW/Edges_OldForests_r500.tif")
names(slanis)="egv_146"
slanis2=project(slanis,template100)
writeRaster(slanis2,
            "./RasterGrids_100m/2024/RAW/Edges_OldForests_r500.tif",
            overwrite=TRUE)



# Edges_OldForests_r1250.tif	egv_147
slanis=rast("./RasterGrids_100m/2024/RAW/Edges_OldForests_r1250.tif")
names(slanis)="egv_147"
slanis2=project(slanis,template100)
writeRaster(slanis2,
            "./RasterGrids_100m/2024/RAW/Edges_OldForests_r1250.tif",
            overwrite=TRUE)



# Edges_OldForests_r3000.tif	egv_148
slanis=rast("./RasterGrids_100m/2024/RAW/Edges_OldForests_r3000.tif")
names(slanis)="egv_148"
slanis2=project(slanis,template100)
writeRaster(slanis2,
            "./RasterGrids_100m/2024/RAW/Edges_OldForests_r3000.tif",
            overwrite=TRUE)



# Edges_OldForests_r10000.tif	egv_149
slanis=rast("./RasterGrids_100m/2024/RAW/Edges_OldForests_r10000.tif")
names(slanis)="egv_149"
slanis2=project(slanis,template100)
writeRaster(slanis2,
            "./RasterGrids_100m/2024/RAW/Edges_OldForests_r10000.tif",
            overwrite=TRUE)


