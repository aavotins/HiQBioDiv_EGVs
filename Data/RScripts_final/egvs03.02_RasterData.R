if(!require(egvtools)) {remotes::install_github("aavotins/egvtools"); require(egvtools)}

# doenload rater data ----
download_raster_templates(
  url = "https://zenodo.org/api/records/14497070/files-archive",
  out_dir = "./Templates/TemplateRasters",
  overwrite = TRUE,
  quiet = FALSE
)

# create null backgrounds ----

create_backgrounds(in_dir="./Templates/TemplateRasters/",
                   out_dir = "./Templates/TemplateRasters/",
                   background_value = 0,
                   out_prefix = "nulls_",
                   overwrite=TRUE)
