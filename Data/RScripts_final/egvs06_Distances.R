# libs ----
if(!require(terra)) {install.packages("terra"); require(terra)}
if(!require(sf)) {install.packages("sf"); require(sf)}
if(!require(sfarrow)) {install.packages("sfarrow"); require(sfarrow)}
if(!require(tidyverse)) {install.packages("tidyverse"); require(tidyverse)}
if(!require(readxl)) {install.packages("readxl"); require(readxl)}
if(!require(raster)) {install.packages("raster"); require(raster)}
if(!require(fasterize)) {install.packages("fasterize"); require(fasterize)}
if(!require(egvtools)) {install.packages("egvtools"); require(egvtools)}

# templates ----
template100=rast("./Templates/TemplateRasters/LV100m_10km.tif")
template10=rast("./Templates/TemplateRasters/LV10m_10km.tif")
nulls100=rast("./Templates/TemplateRasters/nulls_LV100m_10km.tif")
nulls10=rast("./Templates/TemplateRasters/nulls_LV10m_10km.tif")

rastra_pamatne=raster(template10)

# Distance_Builtup_cell.tif	egv_89 ----
simple_landscape=rast("./RasterGrids_10m/2024/Ainava_vienk_mask.tif")
builtup=ifel(simple_landscape==500,1,0)
plot(builtup)
distegv=distance2egv(input = builtup,
                     template_egv = template100,
                     values_as_one = 1,
                     fill_gaps = TRUE, idw_weight = 2,
                     outlocation = "RasterGrids_100m/2024/RAW/",
                     outfilename = "Distance_Builtup_cell.tif",
                     layername = "egv_89")
distegv
plot(rast("RasterGrids_100m/2024/RAW/Distance_Builtup_cell.tif"))
rm(builtup)
rm(distegv)

# Distance_ForestInside_cell.tif	egv_90 ----
simple_landscape=rast("./RasterGrids_10m/2024/Ainava_vienk_mask.tif")
trees_inside=ifel(simple_landscape>=630&simple_landscape<700,0,1)
plot(trees_inside)
distegv=distance2egv(input = trees_inside,
                     template_egv = template100,
                     values_as_one = 1,
                     fill_gaps = TRUE, idw_weight = 2,
                     outlocation = "RasterGrids_100m/2024/RAW/",
                     outfilename = "Distance_ForestInside_cell.tif",
                     layername = "egv_90")
distegv
plot(rast("RasterGrids_100m/2024/RAW/Distance_ForestInside_cell.tif"))
rm(trees_inside)
rm(distegv)



# Distance_GrasslandPermanent_cell.tif	egv_91 ----
kodes=read_excel("./Geodata/2024/LAD/KulturuKodi_2024.xlsx")
lad=sfarrow::st_read_parquet("./Geodata/2024/LAD/Lauki_2024.parquet")
permgrass=lad %>% 
  filter(PRODUCT_CODE=="710") %>% 
  mutate(yes=1)
permgrass_r=fasterize(permgrass,rastra_pamatne,field="yes",fun="first")
permgrass_t=rast(permgrass_r)
permgrass_t2=cover(permgrass_t,nulls10)
plot(permgrass_t2)
distegv=distance2egv(input = permgrass_t2,
                     template_egv = template100,
                     values_as_one = 1,
                     fill_gaps = TRUE, idw_weight = 2,
                     outlocation = "RasterGrids_100m/2024/RAW/",
                     outfilename = "Distance_GrasslandPermanent_cell.tif",
                     layername = "egv_91")
distegv
plot(rast("RasterGrids_100m/2024/RAW/Distance_GrasslandPermanent_cell.tif"))
rm(distegv)
rm(kodes)
rm(lad)
rm(permgrass)
rm(permgrass_r)
rm(permgrass_t)
rm(permgrass_t2)







# Distance_Landfill_cell.tif egv_92 ----

# reading coordinates
landfills=read_excel("./Geodata/2024/GarbageWasteLandfills/Atkritumi.xlsx",sheet="Poligoni")
#sf object
landfills_sf=st_as_sf(landfills,coords=c("X","Y"),crs=3059)
# rasterize
landfills_rast=rasterize(landfills_sf,template100)
# raster to 1=Cell of interest, 0=background
landfills_bg=cover(landfills_rast,nulls100)

# create an egv
distegv=distance2egv(input = landfills_bg,
                     template_egv = template100,
                     values_as_one = 1,
                     fill_gaps = TRUE, idw_weight = 2,
                     outlocation = "RasterGrids_100m/2024/RAW/",
                     outfilename = "Distance_Landfill_cell.tif",
                     layername = "egv_92")
distegv

# Distance_Sea_cell.tif	egv_93 ----

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
plot(rast("RasterGrids_100m/2024/RAW/Distance_Sea_cell.tif"))
rm(sea)
rm(sea_r)
rm(sea_rast)
rm(sea_bg)
rm(distegv)

# Distance_Trees_cell.tif	egv_94 ----
simple_landscape=rast("./RasterGrids_10m/2024/Ainava_vienk_mask.tif")
trees=ifel(simple_landscape>=630&simple_landscape<700,1,0)
plot(trees)
distegv=distance2egv(input = trees,
                     template_egv = template100,
                     values_as_one = 1,
                     fill_gaps = TRUE, idw_weight = 2,
                     outlocation = "RasterGrids_100m/2024/RAW/",
                     outfilename = "Distance_Trees_cell.tif",
                     layername = "egv_94")
distegv
plot(rast("RasterGrids_100m/2024/RAW/Distance_Trees_cell.tif"))
rm(trees)
rm(distegv)


# Distance_Waste_cell.tif egv_95 ----
# reading coordinates
waste=read_excel("./Geodata/2024/GarbageWasteLandfills/Atkritumi.xlsx",sheet="AtkritumuVietas")
# cleaning names
waste2=janitor::clean_names(waste)
#sf object
waste_sf=st_as_sf(waste2,coords=c("y_koordinata_lks92_tm","x_koordinata_lks92_tm"),crs=3059)
# filtering to non-deposit
table(waste_sf$pienemsanas_vietas_tips)
waste_sf2=waste_sf %>% 
  filter(!str_detect(pienemsanas_vietas_tips,"Depozīta"))
# rasterize
waste_rast=rasterize(waste_sf2,template100)
# raster to 1=Cell of interest, 0=background
wastw_bg=cover(waste_rast,nulls100)

# create an egv
distegv=distance2egv(input = wastw_bg,
                     template_egv = template100,
                     values_as_one = 1,
                     fill_gaps = TRUE, idw_weight = 2,
                     outlocation = "RasterGrids_100m/2024/RAW/",
                     outfilename = "Distance_Waste_cell.tif",
                     layername = "egv_95")
distegv
rm(waste)
rm(waste2)
rm(waste_sf)
rm(waste_sf2)
rm(waste_rast)
rm(wastw_bg)
rm(distegv)



# Distance_Water_cell.tif	egv_96 ----
simple_landscape=rast("./RasterGrids_10m/2024/Ainava_vienk_mask.tif")
water=ifel(simple_landscape==200,1,0)
plot(water)
distegv=distance2egv(input = water,
                     template_egv = template100,
                     values_as_one = 1,
                     fill_gaps = TRUE, idw_weight = 2,
                     outlocation = "RasterGrids_100m/2024/RAW/",
                     outfilename = "Distance_Water_cell.tif",
                     layername = "egv_96")
distegv
plot(rast("RasterGrids_100m/2024/RAW/Distance_Water_cell.tif"))
rm(water)
rm(distegv)



# Distance_WaterInside_cell.tif	egv_97 ----
simple_landscape=rast("./RasterGrids_10m/2024/Ainava_vienk_mask.tif")
water_outside=ifel(simple_landscape==200,0,1)
plot(water_outside)
distegv=distance2egv(input = water_outside,
                     template_egv = template100,
                     values_as_one = 1,
                     fill_gaps = TRUE, idw_weight = 2,
                     outlocation = "RasterGrids_100m/2024/RAW/",
                     outfilename = "Distance_WaterInside_cell.tif",
                     layername = "egv_97")
distegv
plot(rast("RasterGrids_100m/2024/RAW/Distance_WaterInside_cell.tif"))
rm(water_outside)
rm(distegv)