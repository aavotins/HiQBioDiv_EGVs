# libs ----
if(!require(egvtools)) {remotes::install_github("aavotins/egvtools"); require(egvtools)}
if(!require(terra)) {install.packages("terra"); require(terra)}
if(!require(tidyverse)) {install.packages("tidyverse"); require(tidyverse)}

# P ----

egv=downscale2egv(
  template_path = "./Templates/TemplateRasters/LV100m_10km.tif",
  grid_path     = "./Templates/TemplateGrids/tikls1km_sauzeme.parquet",
  rawfile_path  = "./Geodata/2024/Soils/ESDAC/chemistry/chemistry/P/P.tif",
  out_path      = "./RasterGrids_100m/2024/RAW/",
  file_name     = "SoilChemistry_ESDAC-P_cell.tif",
  layer_name    = "egv_504",
  fill_gaps     = TRUE,
  smooth        = FALSE,
  plot_result   = TRUE)
egv

# N ----

egv=downscale2egv(
  template_path = "./Templates/TemplateRasters/LV100m_10km.tif",
  grid_path     = "./Templates/TemplateGrids/tikls1km_sauzeme.parquet",
  rawfile_path  = "./Geodata/2024/Soils/ESDAC/chemistry/chemistry/N/N.tif",
  out_path      = "./RasterGrids_100m/2024/RAW/",
  file_name     = "SoilChemistry_ESDAC-N_cell.tif",
  layer_name    = "egv_503",
  fill_gaps     = TRUE,
  smooth        = FALSE,
  plot_result   = TRUE)
egv

# K ----

egv=downscale2egv(
  template_path = "./Templates/TemplateRasters/LV100m_10km.tif",
  grid_path     = "./Templates/TemplateGrids/tikls1km_sauzeme.parquet",
  rawfile_path  = "./Geodata/2024/Soils/ESDAC/chemistry/chemistry/K/K.tif",
  out_path      = "./RasterGrids_100m/2024/RAW/",
  file_name     = "SoilChemistry_ESDAC-K_cell.tif",
  layer_name    = "egv_502",
  fill_gaps     = TRUE,
  smooth        = FALSE,
  plot_result   = TRUE)
egv

# CN ----

egv=downscale2egv(
  template_path = "./Templates/TemplateRasters/LV100m_10km.tif",
  grid_path     = "./Templates/TemplateGrids/tikls1km_sauzeme.parquet",
  rawfile_path  = "./Geodata/2024/Soils/ESDAC/chemistry/chemistry/CN/CN.tif",
  out_path      = "./RasterGrids_100m/2024/RAW/",
  file_name     = "SoilChemistry_ESDAC-CN_cell.tif",
  layer_name    = "egv_500",
  fill_gaps     = TRUE,
  smooth        = FALSE,
  plot_result   = TRUE)
egv

# pH_H2O ----

egv=downscale2egv(
  template_path = "./Templates/TemplateRasters/LV100m_10km.tif",
  grid_path     = "./Templates/TemplateGrids/tikls1km_sauzeme.parquet",
  rawfile_path  = "./Geodata/2024/Soils/ESDAC/chemistry/chemistry/pH_H2O/pH_H2O.tif",
  out_path      = "./RasterGrids_100m/2024/RAW/",
  file_name     = "SoilChemistry_ESDAC-phH2O_cell.tif",
  layer_name    = "egv_505",
  fill_gaps     = TRUE,
  smooth        = FALSE,
  plot_result   = TRUE)
egv

# CaCO3 ----


egv=downscale2egv(
  template_path = "./Templates/TemplateRasters/LV100m_10km.tif",
  grid_path     = "./Templates/TemplateGrids/tikls1km_sauzeme.parquet",
  rawfile_path  = "./Geodata/2024/Soils/ESDAC/chemistry/chemistry/Caco3/CaCO3.tif",
  out_path      = "./RasterGrids_100m/2024/RAW/",
  file_name     = "SoilChemistry_ESDAC-CaCo3_cell.tif",
  layer_name    = "egv_501",
  fill_gaps     = TRUE,
  smooth        = FALSE,
  plot_result   = TRUE)
egv
