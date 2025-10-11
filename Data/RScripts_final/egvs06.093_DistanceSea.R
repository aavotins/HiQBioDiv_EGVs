# libs ----
if(!require(terra)) {install.packages("terra"); require(terra)}
if(!require(sf)) {install.packages("sf"); require(sf)}
if(!require(egvtools)) {install.packages("egvtools"); require(egvtools)}
if(!require(raster)) {install.packages("raster"); require(raster)}
if(!require(fasterize)) {install.packages("fasterize"); require(fasterize)}


# templates ----
template10=rast("./Templates/TemplateRasters/LV10m_10km.tif")
nulls10=rast("./Templates/TemplateRasters/nulls_LV10m_10km.tif")
rastrs10=raster::raster(template10)


# Distance_Sea_cell.tif egv_93 ----

# sea layer, sf
sea=st_read("./Geodata/2024/LV_EEZ/LV_EEZ.shp")

# quick rasterization
sea_r=fasterize(sea,rastrs10,field="LV_EEZ")
sea_rast=rast(sea_r)

# # raster to 1=Cell of interest, 0=background
sea_bg=cover(sea_rast,nulls10)

# create an egv
distegv=distance2egv(input = sea_bg,
                     template_egv = "./Templates/TemplateRasters/LV100m_10km.tif",
                     values_as_one = 1,
                     project_to_template_input=TRUE, # fasterize stores CRS differently
                     template_input=template10,
                     fill_gaps = TRUE, idw_weight = 2,
                     outlocation = "RasterGrids_100m/2024/RAW/",
                     outfilename = "Distance_Sea_cell.tif",
                     layername = "egv_93")
distegv


apskatit=rast("./RasterGrids_100m/2024/RAW/Distance_Sea_cell.tif")
plot(apskatit)
apskatit

