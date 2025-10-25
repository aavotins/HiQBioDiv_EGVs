# Libs ----
if(!require(terra)) {install.packages("terra"); require(terra)}
if(!require(egvtools)) {remotes::install_github("aavotins/egvtools"); require(egvtools)}


# Templates -----
template100=rast("./Templates/TemplateRasters/LV100m_10km.tif")

# Edges_Bogs-Trees_cell.tif	egv_110

landscape_function(
  landscape      = "./RasterGrids_10m/2024/Edges_Bogs-Trees_input.tif",
  zones          = "./Templates/TemplateGrids/tikls100_sauzeme.parquet",
  id_field       = "id",
  tile_field     = "tks50km",
  template       = "./Templates/TemplateRasters/LV100m_10km.tif",
  out_dir        = "./RasterGrids_100m/2024/RAW",
  out_filename   = "Edges_Bogs-Trees_cell.tif",
  out_layername  = "egv_110",
  what             = "lsm_l_te",
  lm_args          = list(count_boundary = FALSE),
  rasterize_engine = "fasterize",
  n_workers      = 12,
  future_max_size = 20 * 1024^3,
  fill_gaps      = TRUE,
  plot_gaps      = FALSE,
  plot_result    = FALSE
)



radius_function(
  kvadrati_path  = "./Templates/TemplateGrids/tiles/",
  radii_path     = "./Templates/TemplateGridPoints/tiles/",
  tikls100_path  = "./Templates/TemplateGrids/tikls100_sauzeme.parquet",
  template_path  = "./Templates/TemplateRasters/LV100m_10km.tif",
  input_layers   = c("./RasterGrids_100m/2024/RAW/Edges_Bogs-Trees_cell.tif"),
  layer_prefixes = c("Edges_Bogs-Trees"),
  output_dir     = "./RasterGrids_100m/2024/RAW/",
  n_workers      = 4,
  radii          = c("r500","r1250","r3000","r10000"),
  radius_mode    = "sparse",
  extract_fun    = "sum",
  fill_missing   = TRUE,
  IDW_weight     = 2,
  future_max_size = 20 * 1024^3)


# Edges_Bogs-Trees_r500.tif	egv_111
slanis=rast("./RasterGrids_100m/2024/RAW/Edges_Bogs-Trees_r500.tif")
names(slanis)="egv_111"
slanis2=project(slanis,template100)
writeRaster(slanis2,
            "./RasterGrids_100m/2024/RAW/Edges_Bogs-Trees_r500.tif",
            overwrite=TRUE)



# Edges_Bogs-Trees_r1250.tif	egv_112
slanis=rast("./RasterGrids_100m/2024/RAW/Edges_Bogs-Trees_r1250.tif")
names(slanis)="egv_112"
slanis2=project(slanis,template100)
writeRaster(slanis2,
            "./RasterGrids_100m/2024/RAW/Edges_Bogs-Trees_r1250.tif",
            overwrite=TRUE)



# Edges_Bogs-Trees_r3000.tif	egv_113
slanis=rast("./RasterGrids_100m/2024/RAW/Edges_Bogs-Trees_r3000.tif")
names(slanis)="egv_113"
slanis2=project(slanis,template100)
writeRaster(slanis2,
            "./RasterGrids_100m/2024/RAW/Edges_Bogs-Trees_r3000.tif",
            overwrite=TRUE)



# Edges_Bogs-Trees_r10000.tif	egv_114
slanis=rast("./RasterGrids_100m/2024/RAW/Edges_Bogs-Trees_r10000.tif")
names(slanis)="egv_114"
slanis2=project(slanis,template100)
writeRaster(slanis2,
            "./RasterGrids_100m/2024/RAW/Edges_Bogs-Trees_r10000.tif",
            overwrite=TRUE)


