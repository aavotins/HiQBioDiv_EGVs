# Libs ----
if(!require(terra)) {install.packages("terra"); require(terra)}
if(!require(egvtools)) {remotes::install_github("aavotins/egvtools"); require(egvtools)}

if(!require(sf)) {install.packages("sf"); require(sf)}
if(!require(sfarrow)) {install.packages("sfarrow"); require(sfarrow)}
if(!require(raster)) {install.packages("raster"); require(raster)}
if(!require(fasterize)) {install.packages("fasterize"); require(fasterize)}
if(!require(tidyverse)) {install.packages("tidyverse"); require(tidyverse)}


# Templates -----
template10=rast("./Templates/TemplateRasters/LV10m_10km.tif")

# simple landscape ----
simple_landscape=rast("./RasterGrids_10m/2024/Ainava_vienk_mask.tif")
freq(simple_landscape)
#     layer value     count
# 1      1   100  18536552
# 2      1   200  44101968
# 3      1   310 109625663
# 4      1   320   6309333
# 5      1   330  68303618
# 6      1   410   2052578
# 7      1   420    604234
# 8      1   500   5614845
# 9      1   610  31855488
# 10     1   620  51243354
# 11     1   630 285557658
# 12     1   640   3399429
# 13     1   710  10156026
# 14     1   720   6369903
# 15     1   730    156649
# 16     1   800   1811879

# Edges_Bogs-Trees_input.tif

trees_from620=ifel(simple_landscape>=620 & simple_landscape<700,0,NA)
plot(trees_from620)

bogs=rast("./RasterGrids_10m/2024/EDI_BogsYN.tif")
bogs=subst(bogs,0,NA)
plot(bogs)
mires=rast("./RasterGrids_10m/2024/EDI_TransitionalMiresYN.tif")
mires=subst(mires,0,NA)
plot(mires)
bogs_mires=cover(bogs,mires)
plot(bogs_mires)

bm_trees=cover(bogs_mires,trees_from620)
plot(bm_trees)

edge_bm_trees=project(bm_trees,template10,
                      filename="./RasterGrids_10m/2024/Edges_Bogs-Trees_input.tif",
                      overwrite=TRUE)

rm(edge_bm_trees)
rm(bm_trees)

# Edges_Bogs-Water_input.tif


bogs=rast("./RasterGrids_10m/2024/EDI_BogsYN.tif")
bogs=subst(bogs,0,NA)
plot(bogs)
mires=rast("./RasterGrids_10m/2024/EDI_TransitionalMiresYN.tif")
mires=subst(mires,0,NA)
plot(mires)
bogs_mires=cover(bogs,mires)
plot(bogs_mires)

water=ifel(simple_landscape==200,0,NA)
plot(water)

bm_water=cover(bogs_mires,water)
plot(bm_water)

edge_bm_water=project(bm_water,template10,
                      filename="./RasterGrids_10m/2024/Edges_Bogs-Water_input.tif",
                      overwrite=TRUE)
rm(edge_bm_water)
rm(bm_water)

# Edges_Farmland-Builtup_input.tif

farmland=ifel(simple_landscape>300 & simple_landscape<400,1,NA)
plot(farmland)

builtup=ifel(simple_landscape==500,0,NA)
plot(builtup)

farmland_builtup=cover(farmland,builtup)
plot(farmland_builtup)

edge_farmland_builtup=project(farmland_builtup,template10,
                      filename="./RasterGrids_10m/2024/Edges_Farmland-Builtup_input.tif",
                      overwrite=TRUE)
rm(edge_farmland_builtup)
rm(farmland_builtup)

# Edges_Trees-Builtup_input.tif

trees_from630=ifel(simple_landscape>=630 & simple_landscape<700,1,NA)
plot(trees_from630)

builtup=ifel(simple_landscape==500,0,NA)
plot(builtup)

trees630_builtup=cover(trees_from630,builtup)
plot(trees630_builtup)

edge_trees630_builtup=project(trees630_builtup,template10,
                              filename="./RasterGrids_10m/2024/Edges_Trees-Builtup_input.tif",
                              overwrite=TRUE)
rm(edge_trees630_builtup)
rm(trees630_builtup)

# Edges_CropsFallow_input.tif


cropsfallow=ifel(simple_landscape>=310 & simple_landscape<325,1,NA)
plot(cropsfallow)

edge_cropsfallow=project(cropsfallow,template10,
                       filename="./RasterGrids_10m/2024/Edges_CropsFallow_input.tif",
                       overwrite=TRUE)
rm(edge_cropsfallow)

# Edges_FarmlandShrubs-Trees_input.tif

farmshrub=ifel((simple_landscape>300 & simple_landscape<400)|
                 (simple_landscape>600 & simple_landscape<630),0,NA)

trees_from630=ifel(simple_landscape>=630 & simple_landscape<700,1,NA)
plot(trees_from630)

farmshrub_trees630=cover(farmshrub,trees_from630)
plot(farmshrub_trees630)

edge_farmshrub_trees630=project(farmshrub_trees630,template10,
                              filename="./RasterGrids_10m/2024/Edges_FarmlandShrubs-Trees_input.tif",
                              overwrite=TRUE)
rm(edge_farmshrub_trees630)
rm(farmshrub_trees630)

# Edges_Grasslands_input.tif

grassland=ifel(simple_landscape==330,1,NA)
plot(grassland)

edge_grassland=project(grassland,template10,
                           filename="./RasterGrids_10m/2024/Edges_Grasslands_input.tif",
                           overwrite=TRUE)
rm(edge_grassland)

# Edges_OldForests_input.tif

mvr=sfarrow::st_read_parquet("./Geodata/2024/MVR/nogabali_2024janv.parquet")
mvr2=mvr %>% 
  mutate(forest_age=ifelse(vgr=="4"|vgr=="5",1,NA)) %>% 
  filter(!is.na(forest_age))

rast_old=fasterize(mvr2,raster(template10),field="forest_age")
terra_old=rast(rast_old)
plot(terra_old)

edge_old=project(terra_old,template10,
                       filename="./RasterGrids_10m/2024/Edges_OldForests_input.tif",
                       overwrite=TRUE)
rm(mvr)
rm(mvr2)
rm(rast_old)
rm(terra_old)
rm(edge_old)

# Edges_Roads_input.tif


roads=ifel(simple_landscape==100,1,NA)
plot(roads)

edge_roads=project(roads,template10,
                   filename="./RasterGrids_10m/2024/Edges_Roads_input.tif",
                   overwrite=TRUE)
rm(edge_roads)


# Edges_Trees_input.tif

trees_from630=ifel(simple_landscape>=630 & simple_landscape<700,1,NA)
plot(trees_from630)

edge_trees_from630=project(trees_from630,template10,
                   filename="./RasterGrids_10m/2024/Edges_Trees_input.tif",
                   overwrite=TRUE)
rm(edge_trees_from630)

# Edges_Water_input.tif

water=ifel(simple_landscape==200,0,NA)
plot(water)

edge_water=project(water,template10,
                            filename="./RasterGrids_10m/2024/Edges_Water_input.tif",
                            overwrite=TRUE)
rm(edge_water)

# Edges_Water-Farmland_input.tif

water=ifel(simple_landscape==200,0,NA)
plot(water)

farmland=ifel(simple_landscape>300 & simple_landscape<400,1,NA)
plot(farmland)

water_farmland=cover(water,farmland)
plot(water_farmland)

edge_water_farmland=project(water_farmland,template10,
                              filename="./RasterGrids_10m/2024/Edges_Water-Farmland_input.tif",
                              overwrite=TRUE)
rm(edge_water_farmland)
rm(water_farmland)

# Edges_Water-Grassland_input.tif

water=ifel(simple_landscape==200,0,NA)
plot(water)

grassland=ifel(simple_landscape==330,1,NA)
plot(grassland)

water_grassland=cover(water,grassland)
plot(water_grassland)

edge_water_grassland=project(water_grassland,template10,
                            filename="./RasterGrids_10m/2024/Edges_Water-Grassland_input.tif",
                            overwrite=TRUE)
rm(edge_water_grassland)
rm(water_grassland)

# Edges_ReedSedgeRushBeds-Water_input.tif

water=ifel(simple_landscape==200,0,NA)
plot(water)

reedsedgerush=ifel(simple_landscape==720,1,NA)
plot(reedsedgerush)


reedsedgerush_water=cover(reedsedgerush,water)
plot(reedsedgerush_water)

edge_reedsedgerush_water=project(reedsedgerush_water,template10,
                             filename="./RasterGrids_10m/2024/Edges_ReedSedgeRushBeds-Water_input.tif",
                             overwrite=TRUE)
rm(edge_reedsedgerush_water)
rm(reedsedgerush_water)