if(!require(egvtools)) {remotes::install_github("aavotins/egvtools"); require(egvtools)}

# Download vector templates
download_vector_templates(
  url = "https://zenodo.org/api/records/14277114/files-archive",
  grid_dir = "./Templates/TemplateGrids",
  points_dir = "./Templates/TemplateGridPoints",
  gpkg_dir = "./Templates",
  overwrite = FALSE,
  quiet = FALSE
)
gc()

# tile 100m grid
tile_vector_grid(
  grid_path = "./Templates/TemplateGrids/tikls100_sauzeme.parquet",
  out_dir = "./Templates/TemplateGrids/tiles",
  tile_field = "tks50km",
  chunk_size = 50000L,
  overwrite = FALSE,
  quiet = FALSE
)
gc()

# tile and buffer points with sparse mode
tiled_buffers(
  in_dir = "./Templates/TemplateGridPoints",
  out_dir = "./Templates/TemplateGridPoints/tiles",
  buffer_mode = "sparse",
  mapping_sparse = list("pts100_sauzeme.parquet" = c(500, 1250), 
                        "pts300_sauzeme.parquet" = 3000, 
                        "pts1000_sauzeme.parquet" = 10000),
  split_field = "tks50km",
  n_workers = 4,
  os_type = NULL,
  future_max_mem_gb = 4,
  overwrite = FALSE,
  quiet = FALSE
)
gc()