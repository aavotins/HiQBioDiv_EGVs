# libs
if(!require(terra)) {install.packages("terra"); require(terra)}
if(!require(sf)) {install.packages("sf"); require(sf)}
if(!require(tidyverse)) {install.packages("tidyverse"); require(tidyverse)}
if(!require(arrow)) {install.packages("arrow"); require(arrow)}
if(!require(sfarrow)) {install.packages("sfarrow"); require(sfarrow)}
if(!require(exactextractr)){install.packages("exactextractr");require(exactextractr)}
if(!require(whitebox)){install.packages("whitebox");require(whitebox)}

# reference
template=rast("./Templates/TemplateRasters/LV10m_10km.tif")
templis=raster::raster(template)

# part one ----

# reljefs
reljefs=rast("./Geodata/2024/DEM/mozDEM_10m.tif")

# drainage network structures
st_layers("./Geodata/2024/MKIS/MKIS_2025.gpkg")

dtb=st_read("./Geodata/2024/MKIS/MKIS_2025.gpkg",layer="DrenazasTiklaBuves")
dtb_buffer=st_buffer(dtb,dist=10)

# bridges 
tiltiL=sfarrow::st_read_parquet("./Geodata/2024/TopographicMap/BridgeL_COMB.parquet")
tiltiL_buffer=st_buffer(tiltiL,dist=30)
tiltiP=sfarrow::st_read_parquet("./Geodata/2024/TopographicMap/BridgeL_COMB.parquet")
tiltiP_buffer=st_buffer(tiltiP,dist=30)

# LVM
lvm_caurtekas=st_read("./Geodata/2024/LVM_OpenData/LVM_CAURTEKAS/LVM_CAURTEKAS_Shape.shp")
lvm_buffer=st_buffer(lvm_caurtekas,dist=30)


# buffers
st_geometry(dtb_buffer)="geometry"
st_geometry(tiltiL_buffer)="geometry"
st_geometry(tiltiP_buffer)="geometry"
st_geometry(lvm_buffer)="geometry"
visi_buferi=bind_rows(dtb_buffer,tiltiL_buffer,tiltiP_buffer,lvm_buffer)

# incorporation in DEM
visi_buferi$vertiba=exactextractr::exact_extract(reljefs,visi_buferi,"min")

caurumi=fasterize::fasterize(visi_buferi,templis,field="vertiba")
caurumi2=rast(caurumi)
caurumains=app(c(reljefs,caurumi2),fun="min",na.rm=TRUE,
               overwrite=TRUE,
               filename="./Geodata/2024/DEM/caurtDEM_10m.tif")

# cleaning
rm(caurumi)
rm(caurumi2)
rm(dtb)
rm(dtb_buffer)
rm(lvm_buffer)
rm(lvm_caurtekas)
rm(reljefs)
rm(tiltiL)
rm(tiltiL_buffer)
rm(tiltiP)
rm(tiltiP_buffer)
rm(visi_buferi)
rm(caurumains)

# part two ----

# DEM
caurumainis=rast("./Geodata/2024/DEM/caurtDEM_10m.tif")

# Sinks
## breached sinks and depth in sinks
wbt_breach_depressions_least_cost(
  dem = "./Geodata/2024/DEM/caurtDEM_10m.tif",
  output = "./Geodata/2024/DEM/caurtDEM_breachedNF.tif",
  dist = 10,
  fill = FALSE)
wbt_depth_in_sink(dem="./Geodata/2024/DEM/caurtDEM_breachedNF.tif",
                  output="./Geodata/2024/DEM/Terrain_DiS_breached_10m.tif",
                  zero_background = TRUE)
wbt_sink(input = "./Geodata/2024/DEM/caurtDEM_breachedNF.tif",
         output = "./Geodata/2024/DEM/Terrain_Sink_breached_10m.tif",
         verbose_mode = FALSE,zero_background = TRUE)
sinks=rast("./Geodata/2024/DEM/Terrain_Sink_breached_10m.tif")

sinks2 <- ifel(sinks >= 1, 1, sinks,
               filename="./Geodata/2024/DEM/Terrain_SinkYN_breached_10m.tif")
plot(sinks2)
unlink("./Geodata/2024/DEM/Terrain_Sink_breached_10m.tif")

# TWI
## breaching
wbt_breach_depressions_least_cost(
  dem = "./Geodata/2024/DEM/caurtDEM_10m.tif",
  output = "./Geodata/2024/DEM/caurtDEM_breachedF.tif",
  dist = 10,
  fill = TRUE)

### filling
wbt_fill_depressions_wang_and_liu(
  dem = "./Geodata/2024/DEM/caurtDEM_breachedF.tif",
  output = "./Geodata/2024/DEM/caurtDEM_BreachFill.tif"
)

### (d inf) flow direction
wbt_d_inf_flow_accumulation(input = "./Geodata/2024/DEM/caurtDEM_BreachFill.tif",
                            output = "./Geodata/2024/DEM/caurtDEM_DInfAccu_SCA.tif",
                            out_type = "Specific Contributing Area")

### twi
wbt_wetness_index(sca = "./Geodata/2024/DEM/caurtDEM_DInfAccu_SCA.tif",
                  slope = "./Geodata/2024/DEM/Terrain_Slope_10m.tif",
                  output = "./Geodata/2024/DEM/TWI_caurtDEM.tif")
twi=rast("./Geodata/2024/DEM/TWI_caurtDEM.tif")
hist(twi) # vietumis ir sevišķi ekscesīvas vērtības
plot(twi)
twi2=ifel(twi>20,20,twi)
plot(twi2)
twi2x=ifel(is.na(twi2)&!is.na(template),20,twi2) # Lake Burtnieks

writeRaster(twi2x,filename="./Geodata/2024/DEM/Terrain_TWI_lim20_caurtDEM.tif")

# cleaning
rm(sinks)
rm(sinks2)
rm(caurumainis)
rm(twi)
rm(twi2)


# third part ----


#  dealing with waterbodies 
udeni=sfarrow::st_read_parquet("./Geodata/2024/TopographicMap/HidroA_COMB.parquet")

slope=rast("./Geodata/2024/DEM/Terrain_Slope_10m.tif")
aspect=rast("./Geodata/2024/DEM/Terrain_Aspect_10m.tif")
twi=rast("./Geodata/2024/DEM/Terrain_TWI_lim20_caurtDEM.tif")
dis=rast("./Geodata/2024/DEM/Terrain_DiS_breached_10m.tif")


# average per waterbody
udeni$slopes=exactextractr::exact_extract(slope,udeni,"mean")
caurumi_slope=fasterize::fasterize(udeni,templis,field="slopes")
caurumi_slope2=rast(caurumi_slope)
caurumains_slope=app(c(caurumi_slope2,slope),fun="first",na.rm=TRUE,
                     overwrite=TRUE,
                     filename="./Geodata/2024/DEM/Terrain_Slope_udeni_10m.tif")
caurumains_slope=terra::rast("./Geodata/2024/DEM/Terrain_Slope_udeni_10m.tif")
caurumains_slope2=terra::mask(caurumains_slope,template,
                              overwrite=TRUE,
                              filename="./RasterGrids_10m/2024/Terrain_Slope_udeni2_10m.tif")
rm(slope)
rm(caurumi_slope)
rm(caurumi_slope2)
rm(caurumains_slope)
rm(caurumains_slope2)


udeni$aspect=exactextractr::exact_extract(aspect,udeni,"mean")
caurumi_aspect=fasterize::fasterize(udeni,templis,field="aspect")
caurumi_aspect2=rast(caurumi_aspect)
caurumi_aspect=app(c(caurumi_aspect2,aspect),fun="first",na.rm=TRUE,
                   overwrite=TRUE,
                   filename="./Geodata/2024/DEM/Terrain_Aspect_udeni_10m.tif")
caurumains_aspect=terra::rast("./Geodata/2024/DEM/Terrain_Aspect_udeni_10m.tif")
caurumains_aspect2=terra::mask(caurumains_aspect,template,
                               overwrite=TRUE,
                               filename="./RasterGrids_10m/2024/Terrain_Aspect_udeni2_10m.tif")
rm(aspect)
rm(caurumi_aspect)
rm(caurumi_aspect2)
rm(caurumains_aspect)
rm(caurumains_aspect2)



udeni$twis=exactextractr::exact_extract(twi,udeni,"mean")
caurumi_TWI=fasterize::fasterize(udeni,templis,field="twis")
caurumi_TWI2=rast(caurumi_TWI)
caurumains_TWI=app(c(caurumi_TWI2,twi),fun="first",na.rm=TRUE,
                   overwrite=TRUE,
                   filename="./Geodata/2024/DEM/Terrain_TWI_udeni_10m.tif")
caurumains_TWI=terra::rast("./Geodata/2024/DEM/Terrain_TWI_udeni_10m.tif")
caurumains_TWI2=terra::mask(caurumains_TWI,template,
                            overwrite=TRUE,
                            filename="./RasterGrids_10m/2024/Terrain_TWI_udeni2_10m.tif")
rm(twi)
rm(caurumi_TWI)
rm(caurumi_TWI2)
rm(caurumains_TWI)
rm(caurumains_TWI2)


udeni$disi=exactextractr::exact_extract(dis,udeni,"mean")
caurumi_DiS=fasterize::fasterize(udeni,templis,field="disi")
caurumi_DiS2=rast(caurumi_DiS)
caurumains_DiS=app(c(caurumi_DiS2,dis),fun="first",na.rm=TRUE,
                   overwrite=TRUE,
                   filename="./Geodata/2024/DEM/Terrain_DiS_udeni_10m.tif")
caurumains_DiS=terra::rast("./Geodata/2024/DEM/Terrain_DiS_udeni_10m.tif")
caurumains_DiS2=terra::mask(caurumains_DiS,template,
                            overwrite=TRUE,
                            filename="./RasterGrids_10m/2024/Terrain_DiS_udeni2_10m.tif")
rm(udeni)
rm(dis)
rm(caurumi_DiS)
rm(caurumi_DiS2)
rm(caurumains_DiS)
rm(caurumains_DiS2)


# cleaning
unlink("./Geodata/2024/DEM/caurtDEM_breachedF.tif")
unlink("./Geodata/2024/DEM/caurtDEM_breachedNF.tif")
unlink("./Geodata/2024/DEM/caurtDEM_BreachFill.tif")
unlink("./Geodata/2024/DEM/caurtDEM_DInfAccu_SCA.tif")

unlink("./Geodata/2024/DEM/Terrain_Slope_udeni_10m.tif")
unlink("./Geodata/2024/DEM/Terrain_Aspect_udeni_10m.tif")
unlink("./Geodata/2024/DEM/Terrain_DiS_udeni_10m.tif")
unlink("./Geodata/2024/DEM/Terrain_TWI_udeni_10m.tif")
