if(!require(egvtools)) {remotes::install_github("aavotins/egvtools"); require(egvtools)}

download_raster_templates(
  url = "https://zenodo.org/api/records/14497070/files-archive",
  out_dir = "./Templates/TemplateRasters",
  overwrite = TRUE,
  quiet = FALSE
)
