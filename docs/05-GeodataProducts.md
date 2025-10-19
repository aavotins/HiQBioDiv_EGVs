# Geodata products {#Ch05}

Some raw data need extensive processing before EGVs can be created, many EGVs 
depend on processing raw geodata into geodata products before EGVs can be create, 
and in some cases, EGV itself could be created from ras geodata, but it has 
to be spatially restricted to certain locations. This chapter describes these geodata 
products and procedures involved in creating them.

## Terrain products {#Ch05.01}

In order to develop part of the relief-related EGV, such as the topographic 
moisture index (TWI) and non-drainage depressions, it is necessary to address 
water flow in the environment. This is a multi-step procedure that is logical 
and reliable in mountainous areas and environments with little hydrological 
impact. However, in the context of Latvia, this is challenging. These challenges 
can be addressed in various ways. For example, if reliable (accurate) information 
on the exact locations of rivers and ditches were available, it could be 
incorporated into the terrain. Unfortunately, there is no sufficiently 
accurate information available. Therefore, information about network 
structures from the [Melioration Cadastre Information System database](#Ch04.03) 
buffered by 10 m, bridges from the [topographic map](#Ch04.04) and transport structures and bridges 
from [LVM Open Data](#Ch04.06) was used to address the challenges (both buffered 
by 10 m) - information about the minimum height above sea level was incorporated into the 
DEM to be used in further processing.


``` r
# libs
if(!require(terra)) {install.packages("terra"); require(terra)}
if(!require(sf)) {install.packages("sf"); require(sf)}
if(!require(tidyverse)) {install.packages("tidyverse"); require(tidyverse)}
if(!require(arrow)) {install.packages("arrow"); require(arrow)}
if(!require(sfarrow)) {install.packages("sfarrow"); require(sfarrow)}
if(!require(exactextractr)){install.packages("exactextractr");require(exactextractr)}

# reference
template=rast("./Templates/TemplateRasters/LV10m_10km.tif")

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
```

This DEM was then used for geoprocessing to find terrain depressions and 
determine the topographic wetness index (TWI). The topographic 
wetness index was prepared and the search for non-runoff depressions was conducted:

1. drainage depressions and their depth layers were prepared after 
incorporating flow breaks;

2. to calculate the topographic wetness index, the terrain depressions without 
runoff were reviewed, allowing up to ten cell breaks in places of lower 
resistance, the rest were filled in;

3. for additional security, the result of the second step was repeated to 
search for and fill in terrain depressions [@WangLiu2006];

4. the result of the third step was used to determine the specific catchment 
area using d-infinity flow division;

5. by combining the specific catchment area layer with the slope layer, 
the topographic wetness index was calculated. A graphical evaluation revealed 
individual extreme values, which were limited to **20**.



``` r
# libs
if(!require(terra)) {install.packages("terra"); require(terra)}
if(!require(whitebox)){install.packages("whitebox");require(whitebox)}

# reference
template=rast("./Templates/TemplateRasters/LV10m_10km.tif")

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
```

Since the initial DEM input was created by filling in water bodies using 
interpolation methods, the water bodies show a pronounced terrain, which needs 
to be removed. This is done by inserting average values into these polygons.



``` r
# libs
if(!require(terra)) {install.packages("terra"); require(terra)}
if(!require(sf)) {install.packages("sf"); require(sf)}
if(!require(tidyverse)) {install.packages("tidyverse"); require(tidyverse)}
if(!require(arrow)) {install.packages("arrow"); require(arrow)}
if(!require(sfarrow)) {install.packages("sfarrow"); require(sfarrow)}
if(!require(exactextractr)){install.packages("exactextractr");require(exactextractr)}

# reference
template=rast("./Templates/TemplateRasters/LV10m_10km.tif")
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
```



## Soil texture product {#Ch05.02}

In this section one united layer describing categorised soil texture (sand=1, 
silt=2, clay=3, organic=4) is created from multiple preprocessed soil texture 
data sources. Creation of soil texture product consisted of multiple overlay steps. 
These steps are illustrated together with processed geodata used:

1. the basis soil texture source was [Soil texture from the European Soil Database](#Ch04.07.02), 
this layer had to be reclassified to match other layers as it was not performed 
during preprocessing;

2. the layer from the first step was overlaid by [Latvian Quarternary geology data](#Ch04.07.04) 
written as numeric starting with 1;

3. the layer from the second step was overlaid by [20th century topsoil in Latvian farmland](#Ch04.07.03) 
written as numeric starting with 1;

4. the layer from [Organic soils as modelled by Silava](#Ch04.07.05) (presence-only) 
was overlaid by [Organic soils as modelled by University of Latvia](#Ch04.07.06) 
(presence-absence). After the overlay, it was classified as presence-only;

5. the layer from the third step was overlaid by the layer from the fourth and 
saved for EGV creation.



``` r
# libs ----
if(!require(terra)) {install.packages("terra"); require(terra)}

# step 1
step1=rast("./RasterGrids_10m/2024/SoilTXT_ESDAC.tif")
step1x=ifel(step1==1,1,
            ifel(step1==2,2,
                 ifel(step1==3,2,
                      ifel(step1==4,3,
                           ifel(step1==8,4,NA)))))
plot(step1x)
step1xy=as.numeric(step1x)
plot(step1xy)


# step 2
step2a=rast("./RasterGrids_10m/2024/SoilTXT_QuarternaryLV.tif")
step2a=as.numeric(step2a)+1
plot(step2a)

step2=cover(step2a,step1x)
plot(step2)

# step 3
step3a=rast("./RasterGrids_10m/2024/SoilTXT_topSoilLV.tif")
step3a=as.numeric(step3a)+1
plot(step3a)

step3=cover(step3a,step2)
plot(step3)

# step 4
step4a=rast("./RasterGrids_10m/2024/SoilTXT_OrganicLU.tif")
step4b=rast("./RasterGrids_10m/2024/SoilTXT_OrganicSilava.tif")

step4c=cover(step4a,step4b)

step4=ifel(step4c==1,4,NA)
plot(step4)

# step 5

step5=cover(step4,step3)
plot(step5)

writeRaster(step5,
           "./RasterGrids_10m/2024/SoilTXT_combined.tif",
           overwrite=TRUE)
```



## Landscape classification {#Ch05.03}

In this exercise, "landscape" refers to the representation of different types 
of land cover and land use classes, where the order in which these classes are 
drawn is important, because spatial data from different sources often have 
mismatched boundaries, which requires addressing both their overlap (1) and 
filling in gaps where there is no database information (2), and the choice of 
how to emphasize objects with certain processing, such as buffering, because 
some elements that are important for characterizing the environment (especially 
edge effects) may be so small or so poorly positioned that they disappear during 
the rasterization process (3). The general landscape layer also serves as a 
mask for the preparation of further environmental descriptions. This section 
describes the development of a general (simple) landscape and, in the following 
document, its enrichment with more specific environmental eco-geographical 
variables. The general landscape is stored in the file `Ainava_vienk_mask.tif`, 
in which the classes and the procedure for their creation are described in the 
following list:

- class `100` - **roads**: roads from various sources, **filled in sequence** - 
dominates classes with higher values so that relatively small objects are not 
lost and information about edges is provided. The following have been 
combined to create this class:

    - layers `RoadA_COMB` and `RoadL_COMB` (except smallest size groups) from
    [topographic map](#Ch04.04), buffered by 10 m before rasterization;
    
    - [LVM open data](#Ch04.06) layers `LVM_MEZA_AUTOCELI`, `LVM_ATTISTAMIE_AUTOCELI`, 
    `LVM_APGRIESANAS_LAUKUMI`, `LVM_IZMAINISANAS_VIETAS` and `LVM_NOBRAUKTUVES` 
    buffered by 10 m;
    
    - information from the State Forest Register on natural roads has not 
    been used, as these do not usually form a continuous break in the canopy. 
    Information on roads from this register is also available in other 
    resources and has not been duplicated.

The command lines below create a layer with landscape class `100`, which is 
saved in the file `SimpleLandscape_class100_celi.tif` for further processing.



``` r
# Libs ----
if(!require(tidyverse)) {install.packages("tidyverse"); require(tidyverse)}
if(!require(sf)) {install.packages("sf"); require(sf)}
if(!require(arrow)) {install.packages("arrow"); require(arrow)}
if(!require(sfarrow)) {install.packages("sfarrow"); require(sfarrow)}
if(!require(terra)) {install.packages("terra"); require(terra)}
if(!require(raster)) {install.packages("raster"); require(raster)}
if(!require(fasterize)) {install.packages("fasterize"); require(fasterize)}
if(!require(gdalUtilities)){install.packages("gdalUtilities");require(gdalUtilities)}
if(!require(readxl)) {install.packages("readxl"); require(readxl)}

# templates ----
template_t=rast("./Templates/TemplateRasters/LV10m_10km.tif")
template_r=raster(template_t)


# class 100 ----

#poly
celi_topo=st_read_parquet("./Geodata/2024/TopographicMap/RoadA_COMB.parquet")
celi_topo=celi_topo %>% 
  mutate(yes=100) %>% 
  dplyr::select(yes)
ctb=st_buffer(celi_topo,dist=10)
r_celi_topo=fasterize(ctb,template_r,field="yes")

# pts
nobrauktuves=st_read("./Geodata/2024/LVM_OpenData/LVM_NOBRAUKTUVES/LVM_NOBRAUKTUVES_Shape.shp")
nobrauktuves=nobrauktuves %>% 
  mutate(yes=100) %>% 
  dplyr::select(yes)
izmainisanas=st_read("./Geodata/2024/LVM_OpenData/LVM_IZMAINISANAS_VIETAS/LVM_IZMAINISANAS_VIETAS_Shape.shp")
izmainisanas=izmainisanas %>% 
  mutate(yes=100) %>% 
  dplyr::select(yes)
apgriesanas=st_read("./Geodata/2024/LVM_OpenData/LVM_APGRIESANAS_LAUKUMI/LVM_APGRIESANAS_LAUKUMI_Shape.shp")
apgriesanas=apgriesanas %>% 
  mutate(yes=100) %>% 
  dplyr::select(yes)
cp=rbind(nobrauktuves,izmainisanas,apgriesanas)
cpb=st_buffer(cp,dist=10)
r_celi_pts=fasterize(cpb,template_r,field="yes")


# lines
meza_autoceli=st_read("./Geodata/2024/LVM_OpenData/LVM_MEZA_AUTOCELI/LVM_MEZA_AUTOCELI_Shape.shp")
meza_autoceli=meza_autoceli %>% 
  mutate(yes=100) %>% 
  dplyr::select(yes)
attistamie=st_read("./Geodata/2024/LVM_OpenData/LVM_ATTISTAMIE_AUTOCELI/LVM_ATTISTAMIE_AUTOCELI_Shape.shp")
attistamie=attistamie %>% 
  mutate(yes=100) %>% 
  dplyr::select(yes)
topo_lines=st_read_parquet("./Geodata/2024/TopographicMap/RoadL_COMB.parquet")
topo_lines=topo_lines %>% 
  mutate(yes=100) %>% 
  dplyr::select(yes)
cl=bind_rows(meza_autoceli,attistamie,topo_lines)
cl=cl %>% 
  dplyr::select(yes)
clb=st_buffer(cl,dist=10)
r_celi_lines=fasterize(clb,template_r,field="yes")

# cleaning
rm(apgriesanas)
rm(attistamie)
rm(celi_topo)
rm(topo_lines)
rm(ctb)
rm(cl)
rm(clb)
rm(cp)
rm(cpb)
rm(izmainisanas)
rm(meza_autoceli)
rm(nobrauktuves)

# to terra
t_celi_topo=rast(r_celi_topo)
t_celi_pts=rast(r_celi_pts)
t_celi_lines=rast(r_celi_lines)

# cleaning
rm(r_celi_lines)
rm(r_celi_pts)
rm(r_celi_topo)

# union
plot(t_celi_topo)

road_union1=cover(t_celi_topo,t_celi_pts)
road_union2=cover(road_union1,t_celi_lines,
                  filename="./RasterGrids_10m/2024/SimpleLandscape_class100_celi.tif",
                  overwrite=TRUE)

# cleaning
rm(t_celi_topo)
rm(t_celi_pts)
rm(t_celi_lines)
rm(road_union1)
rm(road_union2)
```

- class `200` - **waters**: water bodies from various sources, filled in 
sequence (but see "merging and filling" step of this section) - dominates classes 
with higher values so that relatively small objects are not lost and information 
about the edges is provided. The following were combined to create this class:

    – [topographic map](#Ch04.04) layers `HidroA_COMB` and `HidroL_COMB` (buffered by 5 m);

    – [MKIS](#Ch04.03) layer `Gravji`, buffered by 3 m;

    – [LVM open data](#Ch04.06) layers `LVM_GRAVJI`, buffered by 5 m.

    – Information about ditches from the State Forest Register has not been used, 
    as it is also available in other resources, or is of so small structures that it does 
    not cause a continuous break in the tree canopy.

The command lines below create a layer with landscape class `200`, which is 
saved in the file `SimpleLandscape_class200_udens_premask.tif` for further processing.



``` r
# Libs ----
if(!require(tidyverse)) {install.packages("tidyverse"); require(tidyverse)}
if(!require(sf)) {install.packages("sf"); require(sf)}
if(!require(arrow)) {install.packages("arrow"); require(arrow)}
if(!require(sfarrow)) {install.packages("sfarrow"); require(sfarrow)}
if(!require(terra)) {install.packages("terra"); require(terra)}
if(!require(raster)) {install.packages("raster"); require(raster)}
if(!require(fasterize)) {install.packages("fasterize"); require(fasterize)}
if(!require(gdalUtilities)){install.packages("gdalUtilities");require(gdalUtilities)}
if(!require(readxl)) {install.packages("readxl"); require(readxl)}

# templates ----
template_t=rast("./Templates/TemplateRasters/LV10m_10km.tif")
template_r=raster(template_t)


# class 200 ----

# topo
topo_udens_poly=st_read_parquet("./Geodata/2024/TopographicMap/HidroA_COMB.parquet")
topo_udens_poly=topo_udens_poly %>% 
  mutate(yes=200) %>% 
  dplyr::select(yes) %>% 
  st_transform(crs=3059)
topo_udens_lines=st_read_parquet("./Geodata/2024/TopographicMap/HidroL_COMB.parquet")
topo_udens_lines=topo_udens_lines %>% 
  mutate(yes=200) %>% 
  st_buffer(dist=5) %>% 
  dplyr::select(yes) %>% 
  st_transform(crs=3059)
topo_udens=rbind(topo_udens_poly,topo_udens_lines)
r_topo_udens=fasterize(topo_udens,template_r,field="yes")
raster::writeRaster(r_topo_udens,
                    "./RasterGrids_10m/2024/SimpleLandscape_class200_topo.tif",
                    progress="text")
# cleaning
rm(topo_udens_lines)
rm(topo_udens_poly)
rm(topo_udens)
rm(r_topo_udens)

# mkis
st_layers("./Geodata/2024/MKIS/MKIS_2025.gpkg")
mkis_gravji=st_read("./Geodata/2024/MKIS/MKIS_2025.gpkg",layer="Gravji")

mkis_gravji=mkis_gravji %>% 
  mutate(yes=200) %>% 
  st_buffer(dist=3) %>% 
  dplyr::select(yes)
r_mkis_udens=fasterize(mkis_gravji,template_r,field="yes")
raster::writeRaster(r_mkis_udens,
                    "./RasterGrids_10m/2024/SimpleLandscape_class200_mkis.tif",
                    progress="text")
# cleaning
rm(mkis_gravji)
rm(mkis_gravji2)
rm(mkis_gravji3)
rm(r_mkis_udens)

# lvm
lvm_gravji=st_read("./Geodata/2024/LVM_OpenData/LVM_GRAVJI/LVM_GRAVJI_Shape.shp")
lvm_gravji=lvm_gravji %>% 
  mutate(yes=200) %>% 
  st_buffer(dist=5) %>% 
  dplyr::select(yes)
r_lvm_gravji=fasterize(lvm_gravji,template_r,field="yes")
raster::writeRaster(r_lvm_gravji,
                    "./RasterGrids_10m/2024/SimpleLandscape_class200_lvm.tif",
                    progress="text",
                    overwrite=TRUE)
# cleaning
rm(lvm_gravji)
rm(r_lvm_gravji)


# merging
a200=rast("./RasterGrids_10m/2024/SimpleLandscape_class200_topo.tif")
b200=rast("./RasterGrids_10m/2024/SimpleLandscape_class200_mkis.tif")
c200=rast("./RasterGrids_10m/2024/SimpleLandscape_class200_lvm.tif")

udens_cover1=cover(a200,b200)
udens_cover2=cover(udens_cover1,c200,
                   filename="./RasterGrids_10m/2024/SimpleLandscape_class200_udens_premask.tif",
                   overwrite=TRUE)

# cleaning
rm(a200)
rm(b200)
rm(c200)
rm(udens_cover1)
rm(udens_cover2)
unlink("./RasterGrids_10m/2024/SimpleLandscape_class200_topo.tif")
unlink("./RasterGrids_10m/2024/SimpleLandscape_class200_mkis.tif")
unlink("./RasterGrids_10m/2024/SimpleLandscape_class200_lvm.tif")
```


- class `300` - **farmland**: agricultural land in LAD database **filled in 
sequence** - dominated by classes with higher values, but after the general 
classes were created, the gaps were filled in with information from Dynamic 
World. The following were combined to create this class:

    – [LAD database](#Ch04.02), which, following the decision on grouping (classes are 
    available [here](https://github.com/aavotins/HiQBioDiv_EGVs/blob/main/Data/Geodata/2024/LAD/KulturuKodi_2024.xlsx)), 
    is divided into three broad groups (in order of overlap):

    – arable land with class code `310`;

    – fallow land with class code `320`;

    – grassland with class code `330`;

    – orchards and perennial shrub plantations in the general landscape are placed 
    in other landscape classes.

The command lines below create a layer with landscape class `300` and its 
subclasses, which are saved in the file `SimpleLandscape_class300_lauki_premask.tif` 
for further processing.



``` r
# Libs ----
if(!require(tidyverse)) {install.packages("tidyverse"); require(tidyverse)}
if(!require(sf)) {install.packages("sf"); require(sf)}
if(!require(arrow)) {install.packages("arrow"); require(arrow)}
if(!require(sfarrow)) {install.packages("sfarrow"); require(sfarrow)}
if(!require(terra)) {install.packages("terra"); require(terra)}
if(!require(raster)) {install.packages("raster"); require(raster)}
if(!require(fasterize)) {install.packages("fasterize"); require(fasterize)}
if(!require(gdalUtilities)){install.packages("gdalUtilities");require(gdalUtilities)}
if(!require(readxl)) {install.packages("readxl"); require(readxl)}

# templates ----
template_t=rast("./Templates/TemplateRasters/LV10m_10km.tif")
template_r=raster(template_t)


# class 300 ----

# lad
lad_klasem=read_excel("./Geodata/2024/LAD/KulturuKodi_2024.xlsx")
lad=st_read_parquet("./Geodata/2024/LAD/Lauki_2024.parquet")


## arable
amazemem=lad_klasem %>% 
  filter(str_detect(SDM_grupa_sakums,"aramz"))
aramzemes=lad %>% 
  filter(PRODUCT_CODE %in% amazemem$kods) %>% 
  mutate(yes=310) %>% 
  dplyr::select(yes)
r_aramzemes_lad=fasterize(aramzemes,template_r,field="yes")
raster::writeRaster(r_aramzemes_lad,
                    "./RasterGrids_10m/2024/SimpleLandscape_class310_aramzemes_lad.tif",
                    progress="text",
                    overwrite=TRUE)
# cleaning
rm(amazemem)
rm(aramzemes)
rm(r_aramzemes_lad)


## fallow
papuvem=lad_klasem %>% 
  filter(str_detect(SDM_grupa_sakums,"papuv"))
papuves=lad %>% 
  filter(PRODUCT_CODE %in% papuvem$kods) %>% 
  mutate(yes=320) %>% 
  dplyr::select(yes)
r_papuves_lad=fasterize(papuves,template_r,field="yes")
raster::writeRaster(r_papuves_lad,
                    "./RasterGrids_10m/2024/SimpleLandscape_class320_papuves_lad.tif",
                    progress="text",
                    overwrite=TRUE)
# cleaning
rm(papuvem)
rm(papuves)
rm(r_papuves_lad)

## grassland
zalajiem=lad_klasem %>% 
  filter(str_detect(SDM_grupa_sakums,"zālā"))
zalaji=lad %>% 
  filter(PRODUCT_CODE %in% zalajiem$kods) %>% 
  mutate(yes=330) %>% 
  dplyr::select(yes)
r_zalaji_lad=fasterize(zalaji,template_r,field="yes")
raster::writeRaster(r_zalaji_lad,
                    "./RasterGrids_10m/2024/SimpleLandscape_class330_zalaji_lad.tif",
                    progress="text",
                    overwrite=TRUE)
# cleaning
rm(zalajiem)
rm(zalaji)
rm(r_zalaji_lad)

# merging
a300=rast("./RasterGrids_10m/2024/SimpleLandscape_class310_aramzemes_lad.tif")
b300=rast("./RasterGrids_10m/2024/SimpleLandscape_class320_papuves_lad.tif")
c300=rast("./RasterGrids_10m/2024/SimpleLandscape_class330_zalaji_lad.tif")

farmland_cover1=cover(a300,b300)
farmland_cover2=cover(farmland_cover1,c300,
                          filename="./RasterGrids_10m/2024/SimpleLandscape_class300_lauki_premask.tif",
                          overwrite=TRUE)
# cleaning
rm(lad)
rm(lad_klasem)
rm(a300)
rm(b300)
rm(c300)
rm(farmland_cover1)
rm(farmland_cover2)
unlink("./RasterGrids_10m/2024/SimpleLandscape_class310_aramzemes_lad.tif")
unlink("./RasterGrids_10m/2024/SimpleLandscape_class320_papuves_lad.tif")
unlink("./RasterGrids_10m/2024/SimpleLandscape_class330_zalaji_lad.tif")
```


- class `400` - **allotment gardens and orchards, cottages**, **filled in order** - 
dominate classes with higher values. To create this class, the following were 
combined (in order of overlap):

    – [topographic map](#Ch04.04) layer `BuildA_v3` values "poligons_Vasarnīcu_apbūve","poligons_Viensētu_apbūve" coded with `410`;

    – [topographic map](#Ch04.04) layer `LandusA_COMB` values "poligons_Augludarzs", "poligons_Augļudārzs", "poligons_Sakņudārzs", "poligons_Ogulājs", "poligons_Ogulajs", 
    "poligons_Saknudarzs" coded with `420`;

    – [LAD database](#Ch04.02) rural information layer group (classes are 
    available [here](https://github.com/aavotins/HiQBioDiv_EGVs/blob/main/Data/Geodata/2024/LAD/KulturuKodi_2024.xlsx)) 
    “augļudārzi”, the result of which is coded with `420`.

The command lines below create a layer with landscape class `400`, which is saved 
in the file `SimpleLandscape_class400_vasarnicas_premask.tif` for further 
processing.



``` r
# Libs ----
if(!require(tidyverse)) {install.packages("tidyverse"); require(tidyverse)}
if(!require(sf)) {install.packages("sf"); require(sf)}
if(!require(arrow)) {install.packages("arrow"); require(arrow)}
if(!require(sfarrow)) {install.packages("sfarrow"); require(sfarrow)}
if(!require(terra)) {install.packages("terra"); require(terra)}
if(!require(raster)) {install.packages("raster"); require(raster)}
if(!require(fasterize)) {install.packages("fasterize"); require(fasterize)}
if(!require(readxl)) {install.packages("readxl"); require(readxl)}

# templates ----
template_t=rast("./Templates/TemplateRasters/LV10m_10km.tif")
template_r=raster(template_t)


# class 400 ----


# topo apbuves
viensvasar=st_read_parquet("./Geodata/2024/TopographicMap/BuildA_v3.parquet")
table(viensvasar$FNAME,useNA="always")
viensvasar=viensvasar %>% 
  filter(FNAME %in% c("poligons_Vasarnīcu_apbūve","poligons_Viensētu_apbūve")) %>% 
  mutate(yes=410) %>% 
  dplyr::select(yes)
r_viensetasvasarnicas=fasterize(viensvasar,template_r,field="yes")
raster::writeRaster(r_viensetasvasarnicas,
                    "./RasterGrids_10m/2024/SimpleLandscape_class410_vasarnicasviensetas_topo.tif",
                    progress="text",
                    overwrite=TRUE)
# cleaning
rm(viensvasar)
rm(r_darzini_topo)

# topo
darzini_topo=st_read_parquet("./Geodata/2024/TopographicMap/LandusA_COMB.parquet")
table(darzini_topo$FNAME,useNA="always")
darzini_topo=darzini_topo %>% 
  filter(FNAME %in% c("poligons_Augludarzs","poligons_Augļudārzs","poligons_Sakņudārzs",
                      "poligons_Ogulājs","poligons_Ogulajs","poligons_Saknudarzs")) %>% 
  mutate(yes=410) %>% 
  dplyr::select(yes)
r_darzini_topo=fasterize(darzini_topo,template_r,field="yes")
raster::writeRaster(r_darzini_topo,
                    "./RasterGrids_10m/2024/SimpleLandscape_class410_darzini_topo.tif",
                    progress="text",
                    overwrite=TRUE)
# cleaning
rm(darzini_topo)
rm(r_darzini_topo)

# lad
lad_klasem=read_excel("./Geodata/2024/LAD/KulturuKodi_2024.xlsx")
table(lad_klasem$SDM_grupa_sakums,useNA="always")
augludarziem=lad_klasem %>% 
  filter(SDM_grupa_sakums=="augļudārzi")
lad=st_read_parquet("./Geodata/2024/LAD/Lauki_2024.parquet")
lad=lad %>% 
  filter(PRODUCT_CODE %in% augludarziem$kods) %>% 
  mutate(yes=420) %>% 
  dplyr::select(yes)
r_darzini_lad=fasterize(lad,template_r,field="yes")
raster::writeRaster(r_darzini_lad,
                    "./RasterGrids_10m/2024/SimpleLandscape_class420_darzini_lad.tif",
                    progress="text",
                    overwrite=TRUE)
# cleaning
rm(lad_klasem)
rm(augludarziem)
rm(lad)
rm(r_darzini_lad)

# merging
a400=rast("./RasterGrids_10m/2024/SimpleLandscape_class410_vasarnicasviensetas_topo.tif")
b400=rast("./RasterGrids_10m/2024/SimpleLandscape_class420_darzini_topo.tif")
c400=rast("./RasterGrids_10m/2024/SimpleLandscape_class420_darzini_lad.tif")

allotment_cover=cover(a400,b400,
                     filename="./RasterGrids_10m/2024/SimpleLandscape_class400_varnicas_premask.tif",
                     overwrite=TRUE)

# cleaning
rm(a400)
rm(b400)
rm(allotment_cover)
unlink("./RasterGrids_10m/2024/SimpleLandscape_class410_vasarnicasviensetas_topo.tif")
unlink("./RasterGrids_10m/2024/SimpleLandscape_class420_darzini_topo.tif")
unlink("./RasterGrids_10m/2024/SimpleLandscape_class420_darzini_lad.tif")
```

- class `500` - **built-up**: built-up areas, filled in at the end (see section 
"merging and filling" of this chapter) using information from Dynamic World about 
places not covered by other classes.

- class `600` - **forests, shrublands, clearings**: areas covered with trees and 
shrubs, clearings, and dead forest stands, **filled in order** - dominates 
classes with higher values. The following have been combined to create this 
class (in order of overlap):

    – [The Global Forest Watch](#Ch04.09) layer records of tree canopy cover 
    loss since 2020, coded as `610`;

    – [Forest State Register](#Ch04.01) clearings and dead forest stands, the result 
    of which is coded as `610`;

    – [Forest State Register](#Ch04.01) marked forest stands that are lower than 5 m 
    and seed production plantations, the result of which is coded as `620`;

    – [topographic map](#Ch04.04) layer `FloraL_COMB` classes related to shrubs, 
    buffered by 10 m, coded as `620`;

    – [topographic map](#Ch04.04) layers `LandusA_COMB` clases "poligons_Krūmājs", 
    "poligons_Krumajs", "poligons_Krūmaugu_plant", "poligons_Plantacija_krum", coded as `620`;

    – [LAD database](#Ch04.02) group (classes are 
    available [here](https://github.com/aavotins/HiQBioDiv_EGVs/blob/main/Data/Geodata/2024/LAD/KulturuKodi_2024.xlsx)) 
    “krūmveida ilggadīgie stādījumi”, the result of which is coded with `620`;

    – [Forest State Register](#Ch04.01) forest stands with a height of at least 5 m, 
    coded as `630`;

    – [topographic map](#Ch04.04) layer `LandusA_COMB` classes "poligons_Parks", 
    "poligons_Meza_kapi", "poligons_Kapi", "poligons_Kapi_meza", the result of 
    which is coded as `640`;

    – [topographic map](#Ch04.04) layer `FloraL_COMB` with tree-related classes 
    buffered by 10 m, coded as `640`;

    – [Palsar Forests](#Ch04.10) layer, coded as `630`.

The command lines below create a layer with landscape class `600`, which is saved 
in the file `SimpleLandscape_class600_meziem_premask.tif` for further processing.



``` r
# Libs ----
if(!require(tidyverse)) {install.packages("tidyverse"); require(tidyverse)}
if(!require(sf)) {install.packages("sf"); require(sf)}
if(!require(arrow)) {install.packages("arrow"); require(arrow)}
if(!require(sfarrow)) {install.packages("sfarrow"); require(sfarrow)}
if(!require(terra)) {install.packages("terra"); require(terra)}
if(!require(raster)) {install.packages("raster"); require(raster)}
if(!require(fasterize)) {install.packages("fasterize"); require(fasterize)}
if(!require(readxl)) {install.packages("readxl"); require(readxl)}

# templates ----
template_t=rast("./Templates/TemplateRasters/LV10m_10km.tif")
template_r=raster(template_t)


# class 600 ----

# mvr 
mvr=st_read_parquet("./Geodata/2024/MVR/nogabali_2024janv.parquet")

# clearcuts
izcirtumi=mvr %>% 
  filter(zkat %in% c("12","14")) %>% 
  mutate(yes=610) %>% 
  dplyr::select(yes)
r_izcirtumi_mvr=fasterize(izcirtumi,template_r,field="yes")
raster::writeRaster(r_izcirtumi_mvr,
                    "./RasterGrids_10m/2024/SimpleLandscape_class610_izcirtumi_mvr.tif",
                    progress="text",
                    overwrite=TRUE)
# cleaning
rm(izcirtumi)
rm(r_izcirtumi_mvr)

# low stands
# also zkat 16
zemas_audzes=mvr %>% 
  filter((zkat =="10" & h10<5)|zkat=="16") %>% 
  mutate(yes=620) %>% 
  dplyr::select(yes)
r_zemas_mvr=fasterize(zemas_audzes,template_r,field="yes")
raster::writeRaster(r_zemas_mvr,
                    "./RasterGrids_10m/2024/SimpleLandscape_class620_zemas_mvr.tif",
                    progress="text",
                    overwrite=TRUE)
# cleaning
rm(zemas_audzes)
rm(r_zemas_mvr)


# high stands
augstas_audzes=mvr %>% 
  filter(zkat =="10" & h10>=5) %>% 
  mutate(yes=630) %>% 
  dplyr::select(yes)
r_augstas_mvr=fasterize(augstas_audzes,template_r,field="yes")
raster::writeRaster(r_augstas_mvr,
                    "./RasterGrids_10m/2024/SimpleLandscape_class630_augstas_mvr.tif",
                    progress="text",
                    overwrite=TRUE)
# cleaning
rm(augstas_audzes)
rm(r_augstas_mvr)
rm(mvr)

# tcl - since 2020
tcl=rast("./Geodata/2024/Trees/GFW/TreeCoverLoss_v1_12.tif")
tcl2=ifel(tcl<20,NA,610,
          filename="./RasterGrids_10m/2024/SimpleLandscape_class610_TCL.tif",
          overwrite=TRUE)
# cleaning
rm(tcl)
rm(tcl2)

# palsar
palsar=rast("./Geodata/2024/Trees/Palsar/Palsar_Forests.tif")
palsar2=ifel(palsar==1,630,NA,
             filename="./RasterGrids_10m/2024/SimpleLandscape_class630_Palsar.tif",
             overwrite=TRUE)
# cleaning
rm(palsar)
rm(palsar2)


# lad
lad_klasem=read_excel("./Geodata/2024/LAD/KulturuKodi_2024.xlsx")
table(lad_klasem$SDM_grupa_sakums,useNA="always")
lad=st_read_parquet("./Geodata/2024/LAD/Lauki_2024.parquet")
krumiem=lad_klasem %>% 
  filter(str_detect(SDM_grupa_sakums,"krūmv"))
krumi=lad %>% 
  filter(PRODUCT_CODE %in% krumiem$kods) %>% 
  mutate(yes=620) %>% 
  dplyr::select(yes)
r_krumi_lad=fasterize(krumi,template_r,field="yes")
raster::writeRaster(r_krumi_lad,
                    "./RasterGrids_10m/2024/SimpleLandscape_class620_krumi_lad.tif",
                    progress="text",
                    overwrite=TRUE)
# cleaning
rm(lad_klasem)
rm(lad)
rm(krumiem)
rm(krumi)
rm(r_krumi_lad)

# topo - pkk
pkk_topo=st_read_parquet("./Geodata/2024/TopographicMap/LandusA_COMB.parquet")
table(pkk_topo$FNAME,useNA="always")
pkk_topo=pkk_topo %>% 
  filter(FNAME %in% c("poligons_Parks","poligons_Meza_kapi","poligons_Kapi",
                      "poligons_Kapi_meza")) %>% 
  mutate(yes=640) %>% 
  dplyr::select(yes)
r_pkk_topo=fasterize(pkk_topo,template_r,field="yes")
raster::writeRaster(r_pkk_topo,
                    "./RasterGrids_10m/2024/SimpleLandscape_class640_pkk_topo.tif",
                    progress="text",
                    overwrite=TRUE)
# cleaning
rm(pkk_topo)
rm(r_pkk_topo)

# topo - shrubs
krumi_topo=st_read_parquet("./Geodata/2024/TopographicMap/LandusA_COMB.parquet")
table(krumi_topo$FNAME,useNA="always")
krumi_topo=krumi_topo %>% 
  filter(FNAME %in% c("poligons_Krūmājs","poligons_Krumajs",
                      "poligons_Krūmaugu_plant","poligons_Plantacija_krum")) %>% 
  mutate(yes=620) %>% 
  dplyr::select(yes)
r_krumi_topo=fasterize(krumi_topo,template_r,field="yes")
raster::writeRaster(r_krumi_topo,
                    "./RasterGrids_10m/2024/SimpleLandscape_class620_krumi_topo.tif",
                    progress="text",
                    overwrite=TRUE)
# cleaning
rm(krumi_topo)
rm(r_krumi_topo)

# topo - linear vegetation
linijas_topo=st_read_parquet("./Geodata/2024/TopographicMap/FloraL_COMB.parquet")
table(linijas_topo$FNAME,useNA="always")

# linear shrubs
krumu_linijas_topo=linijas_topo %>% 
  filter(FNAME=="Krūmu rinda dzīvzogs"|FNAME=="Krūmu rinda gar ceļiem upēm"|
           FNAME=="Krumu_rinda_dzivzogs"|FNAME=="Krumu_rinda_gar_celiem_upem") %>% 
  mutate(yes=620) %>% 
  st_buffer(dist=10) %>% 
  dplyr::select(yes)
r_krumu_linijas_topo=fasterize(krumu_linijas_topo,template_r,field="yes")
raster::writeRaster(r_krumu_linijas_topo,
                    "./RasterGrids_10m/2024/SimpleLandscape_class620_KrumuLinijas_topo.tif",
                    progress="text",
                    overwrite=TRUE)
# cleaning
rm(krumu_linijas_topo)
rm(r_krumu_linijas_topo)

# linear trees
koku_linijas_topo=linijas_topo %>% 
  filter(str_detect(FNAME,"Koku")) %>% 
  mutate(yes=640) %>% 
  st_buffer(dist=10) %>% 
  dplyr::select(yes)
r_koku_linijas_topo=fasterize(koku_linijas_topo,template_r,field="yes")
raster::writeRaster(r_koku_linijas_topo,
                    "./RasterGrids_10m/2024/SimpleLandscape_class640_KokuLinijas_topo.tif",
                    progress="text",
                    overwrite=TRUE)
# cleaning
rm(koku_linijas_topo)
rm(r_koku_linijas_topo)
rm(linijas_topo)

# merging
r_krumi_lad=rast("./RasterGrids_10m/2024/SimpleLandscape_class620_krumi_lad.tif")
r_pkk_topo=rast("./RasterGrids_10m/2024/SimpleLandscape_class640_pkk_topo.tif")
r_krumi_topo=rast("./RasterGrids_10m/2024/SimpleLandscape_class620_krumi_topo.tif")
r_krumu_linijas_topo=rast("./RasterGrids_10m/2024/SimpleLandscape_class620_KrumuLinijas_topo.tif")
r_koku_linijas_topo=rast("./RasterGrids_10m/2024/SimpleLandscape_class640_KokuLinijas_topo.tif")
r_palsar=rast("./RasterGrids_10m/2024/SimpleLandscape_class630_palsar.tif")
r_tcl=rast("./RasterGrids_10m/2024/SimpleLandscape_class610_TCL.tif")
r_augstas_mvr=rast("./RasterGrids_10m/2024/SimpleLandscape_class630_augstas_mvr.tif")
r_zemas_mvr=rast("./RasterGrids_10m/2024/SimpleLandscape_class620_zemas_mvr.tif")
r_izcirtumi_mvr=rast("./RasterGrids_10m/2024/SimpleLandscape_class610_izcirtumi_mvr.tif")


mezu_cover=cover(r_tcl,r_izcirtumi_mvr)
mezu_cover=cover(mezu_cover,r_zemas_mvr)
mezu_cover=cover(mezu_cover,r_krumu_linijas_topo)
mezu_cover=cover(mezu_cover,r_krumi_topo)
mezu_cover=cover(mezu_cover,r_krumi_lad)
mezu_cover=cover(mezu_cover,r_augstas_mvr)
mezu_cover=cover(mezu_cover,r_pkk_topo)
mezu_cover=cover(mezu_cover,r_koku_linijas_topo)
mezu_cover=cover(mezu_cover,r_palsar,
                 filename="./RasterGrids_10m/2024/SimpleLandscape_class600_meziem_premask.tif",
                 overwrite=TRUE)


# cleaning
rm(r_krumi_lad)
rm(r_pkk_topo)
rm(r_krumi_topo)
rm(r_krumu_linijas_topo)
rm(r_koku_linijas_topo)
rm(r_palsar)
rm(r_tcl)
rm(r_augstas_mvr)
rm(r_zemas_mvr)
rm(r_izcirtumi_mvr)
rm(mezu_cover)

unlink("./RasterGrids_10m/2024/SimpleLandscape_class620_krumi_lad.tif")
unlink("./RasterGrids_10m/2024/SimpleLandscape_class640_pkk_topo.tif")
unlink("./RasterGrids_10m/2024/SimpleLandscape_class620_krumi_topo.tif")
unlink("./RasterGrids_10m/2024/SimpleLandscape_class620_KrumuLinijas_topo.tif")
unlink("./RasterGrids_10m/2024/SimpleLandscape_class640_KokuLinijas_topo.tif")
unlink("./RasterGrids_10m/2024/SimpleLandscape_class630_palsar.tif")
unlink("./RasterGrids_10m/2024/SimpleLandscape_class610_TCL.tif")
unlink("./RasterGrids_10m/2024/SimpleLandscape_class630_augstas_mvr.tif")
unlink("./RasterGrids_10m/2024/SimpleLandscape_class620_zemas_mvr.tif")
unlink("./RasterGrids_10m/2024/SimpleLandscape_class610_izcirtumi_mvr.tif")
```

- class `700` - **wetlands**: combining geospatial data related to reed beds, 
marshes, mires and bogs, **filled in order except class `720` that dominates over waters** - 
dominates classes with higher values. To create this class, the following were 
combined (in order of overlap):

    – [topographic map](#Ch04.04) layer `LandusA_COMB` classes "Meldrājs_ūdenī_poligons", 
    "poligons_Grislajs", "poligons_Grīslājs", "poligons_Meldrajs", "poligons_Meldrājs", 
    "poligons_Meldrajs_udeni", "poligons_Nec_purvs_grīslājs", "poligons_Nec_purvs_meldrājs", 
    "Sēklis_poligons", the result of which is coded with `720`;

    – [topographic map](#Ch04.04) layer `LandusA_COMB` class "poligons_Nec_purvs_sūnājs", 
    "poligons_Sunajs", "poligons_Sūnājs", the result of which is coded with `710`;

    – [topographic map](#Ch04.04) layer `SwampA_COMB`, the result of which is coded 
    as `710`;

    – land categories “21”, “22”, “23” marked in the [State Forest Register](#Ch04.01), 
    the result of which is coded as `710`;

    – land categories “41” and “42” marked in the [State Forest Register](#Ch04.01), 
    the result of which is coded as `730`;

    - bogs from [Bogs and Mires: EDI](#Ch04.17);

    - transitional mires from [Bogs and Mires: EDI](#Ch04.17);

The command lines below create a layer with landscape class `700`, which is saved 
in the file `SimpleLandscape_class700_mitraji_premask.tif` for further processing.



``` r
# Libs ----
if(!require(tidyverse)) {install.packages("tidyverse"); require(tidyverse)}
if(!require(sf)) {install.packages("sf"); require(sf)}
if(!require(arrow)) {install.packages("arrow"); require(arrow)}
if(!require(sfarrow)) {install.packages("sfarrow"); require(sfarrow)}
if(!require(terra)) {install.packages("terra"); require(terra)}
if(!require(raster)) {install.packages("raster"); require(raster)}
if(!require(fasterize)) {install.packages("fasterize"); require(fasterize)}
if(!require(readxl)) {install.packages("readxl"); require(readxl)}

# templates ----
template_t=rast("./Templates/TemplateRasters/LV10m_10km.tif")
template_r=raster(template_t)


# class 700 ----

# topo
topo=st_read_parquet("./Geodata/2024/TopographicMap/LandusA_COMB.parquet")
table(topo$FNAME,useNA="always")

## ReedSedgeRush
niedraji_topo=topo %>% 
  filter(FNAME %in% c("Meldrājs_ūdenī_poligons","poligons_Grislajs","poligons_Grīslājs",
                      "poligons_Meldrajs","poligons_Meldrājs","poligons_Meldrajs_udeni",
                      "poligons_Nec_purvs_grīslājs",
                      "poligons_Nec_purvs_meldrājs",
                      "Sēklis_poligons")) %>% 
  mutate(yes=720) %>% 
  dplyr::select(yes)
r_niedraji_topo=fasterize(niedraji_topo,template_r,field="yes")
raster::writeRaster(r_niedraji_topo,
                    "./RasterGrids_10m/2024/SimpleLandscape_class720_niedraji_topo.tif",
                    progress="text",
                    overwrite=TRUE)
# cleaning
rm(niedraji_topo)
rm(r_niedraji_topo)


## bogs
purvi_topo=topo %>% 
  filter(FNAME %in% c("poligons_Nec_purvs_sūnājs",
                      "poligons_Sunajs","poligons_Sūnājs")) %>% 
  mutate(yes=710) %>% 
  dplyr::select(yes)
topo_purvi=st_read_parquet("./Geodata/2024/TopographicMap/SwampA_COMB.parquet")
topo_purvi=topo_purvi %>% 
  mutate(yes=710) %>% 
  dplyr::select(yes)
purvi=rbind(purvi_topo,topo_purvi)
r_purvi_topo=fasterize(purvi,template_r,field="yes")
raster::writeRaster(r_purvi_topo,
                    "./RasterGrids_10m/2024/SimpleLandscape_class710_purvi_topo.tif",
                    progress="text",
                    overwrite=TRUE)
# cleaning
rm(purvi_topo)
rm(topo_purvi)
rm(purvi)
rm(r_purvi_topo)


# mvr
mvr=st_read_parquet("./Geodata/2024/MVR/nogabali_2024janv.parquet")

# bogs and mires
mvr_purvi=mvr %>% 
  filter(zkat %in% c("21","22","23")) %>% 
  mutate(yes=710) %>% 
  dplyr::select(yes)
r_purvi_mvr=fasterize(mvr_purvi,template_r,field="yes")
raster::writeRaster(r_purvi_mvr,
                    "./RasterGrids_10m/2024/SimpleLandscape_class710_purvi_mvr.tif",
                    progress="text",
                    overwrite=TRUE)
# cleaning
rm(mvr_purvi)
rm(r_purvi_mvr)

# beavers
mvr_bebri=mvr %>% 
  filter(zkat %in% c("41","42")) %>% 
  mutate(yes=730) %>% 
  dplyr::select(yes)
r_bebri_mvr=fasterize(mvr_bebri,template_r,field="yes")
raster::writeRaster(r_bebri_mvr,
                    "./RasterGrids_10m/2024/SimpleLandscape_class730_bebri_mvr.tif",
                    progress="text",
                    overwrite=TRUE)
# cleaning
rm(mvr_bebri)
rm(r_bebri_mvr)
rm(mvr)



# merging
r_niedraji_topo=rast("./RasterGrids_10m/2024/SimpleLandscape_class720_niedraji_topo.tif")
r_purvi_topo=rast("./RasterGrids_10m/2024/SimpleLandscape_class710_purvi_topo.tif")
r_purvi_mvr=rast("./RasterGrids_10m/2024/SimpleLandscape_class710_purvi_mvr.tif")
r_bebri_mvr=rast("./RasterGrids_10m/2024/SimpleLandscape_class730_bebri_mvr.tif")
mires=rast("./RasterGrids_10m/2024/EDI_TransitionalMiresYN.tif")
miresY=ifel(mires==1,710,NA)
bogs=rast("./RasterGrids_10m/2024/EDI_BogsYN.tif")
bogsY=ifel(bogs==1,710,NA)

wetlands_cover=cover(r_niedraji_topo,r_purvi_topo)
wetlands_cover=cover(wetlands_cover,r_purvi_mvr)
wetlands_cover=cover(wetlands_cover,r_bebri_mvr)
wetlands_cover=cover(wetlands_cover,miresY)
wetlands_cover=cover(wetlands_cover,bogsY,
                            filename="./RasterGrids_10m/2024/SimpleLandscape_class700_mitraji_premask.tif",
                            overwrite=TRUE)
# cleaning
rm(r_niedraji_topo)
rm(r_purvi_topo)
rm(r_purvi_mvr)
rm(r_bebri_mvr)
rm(bogs)
rm(bogsY)
rm(mires)
rm(miresY)
rm(topo)
rm(wetlands_cover)

unlink("./RasterGrids_10m/2024/SimpleLandscape_class710_purvi_topo.tif")
unlink("./RasterGrids_10m/2024/SimpleLandscape_class710_purvi_mvr.tif")
unlink("./RasterGrids_10m/2024/SimpleLandscape_class730_bebri_mvr.tif")
```

- class `800` - **bare soil and quarries**: combining layers related to bare soil, 
heaths, and quarries, **filled in order** - as this is the highest class, it 
dominates only over Dynamic World used to fill gaps. The following have been 
combined to create this class (in order of overlap):

    – [topographic map](#Ch04.04) layer `LandusA_COMB` classes 
    "poligons_Smiltājs", "poligons_Smiltajs", "poligons_Grants", "poligons_Kūdra", 
    "poligons_Virsajs" the result of which is coded with `800`;

    – land categories "33" and "34" marked in the [State Forest Register](#Ch04.01), 
    the result of which is coded as `800`.

The command lines below create a layer with landscape class `800`, which is saved 
in the file `SimpleLandscape_class800_smiltaji_premask.tif` for further processing.



``` r
# Libs ----
if(!require(tidyverse)) {install.packages("tidyverse"); require(tidyverse)}
if(!require(sf)) {install.packages("sf"); require(sf)}
if(!require(arrow)) {install.packages("arrow"); require(arrow)}
if(!require(sfarrow)) {install.packages("sfarrow"); require(sfarrow)}
if(!require(terra)) {install.packages("terra"); require(terra)}
if(!require(raster)) {install.packages("raster"); require(raster)}
if(!require(fasterize)) {install.packages("fasterize"); require(fasterize)}
if(!require(readxl)) {install.packages("readxl"); require(readxl)}

# templates ----
template_t=rast("./Templates/TemplateRasters/LV10m_10km.tif")
template_r=raster(template_t)


# class 800 ----

smiltaji_topo=st_read_parquet("./Geodata/2024/TopographicMap/LandusA_COMB.parquet")
table(smiltaji_topo$FNAME,useNA="always")
smiltaji_topo=smiltaji_topo %>% 
  filter(FNAME %in% c("poligons_Smiltājs","poligons_Smiltajs","poligons_Grants",
                      "poligons_Kūdra","poligons_Virsajs")) %>% 
  mutate(yes=800) %>% 
  dplyr::select(yes)
r_smiltaji_topo=fasterize(smiltaji_topo,template_r,field="yes")
raster::writeRaster(r_smiltaji_topo,
                    "./RasterGrids_10m/2024/SimpleLandscape_class800_SmiltajiKudra_topo.tif",
                    progress="text")
# cleaning
rm(smiltaji_topo)
rm(r_smiltaji_topo)

# mvr zkat 33 un 34
mvr=st_read_parquet("./Geodata/2024/MVR/nogabali_2024janv.parquet")

smiltajiem=mvr %>% 
  filter(zkat %in% c("33","34")) %>% 
  mutate(yes=800) %>% 
  dplyr::select(yes)
r_smiltaji_mvr=fasterize(smiltajiem,template_r,field="yes")
raster::writeRaster(r_smiltaji_mvr,
                    "./RasterGrids_10m/2024/SimpleLandscape_class800_SmiltVirs_mvr.tif",
                    progress="text",
                    overwrite=TRUE)
# cleaning
rm(mvr)
rm(smiltajiem)
rm(r_smiltaji_mvr)

# merging
r_smiltaji_topo=rast("./RasterGrids_10m/2024/SimpleLandscape_class800_SmiltajiKudra_topo.tif")
r_smiltaji_mvr=rast("./RasterGrids_10m/2024/SimpleLandscape_class800_SmiltVirs_mvr.tif")

bare_cover=terra::merge(r_smiltaji_topo,r_smiltaji_mvr,
                               filename="./RasterGrids_10m/2024/SimpleLandscape_class800_smiltaji_premask.tif",
                               overwrite=TRUE)
# cleaning
rm(r_smiltaji_topo)
rm(r_smiltaji_mvr)
rm(bare_cover)

unlink("./RasterGrids_10m/2024/SimpleLandscape_class800_SmiltajiKudra_topo.tif")
unlink("./RasterGrids_10m/2024/SimpleLandscape_class800_SmiltVirs_mvr.tif")
```

**Merging and filling**

The command lines below combine the previously created layers with landscape 
classes in the correct order and ensure that gaps are filled with the appropriately 
classified Dynamic World composite for April-August 2024. After masking to only 
the analysis space, layer is saved in the in the file `Ainava_vienk_mask.tif` 
for further processing.


``` r
# Libs ----
if(!require(terra)) {install.packages("terra"); require(terra)}

# templates ----
template_t=rast("./Templates/TemplateRasters/LV10m_10km.tif")
template_r=raster(template_t)


# final merging and covering ----

# DW  
dynworld=rast("Geodata/2024/DynamicWorld/DW_2024_apraug.tif")
klases=matrix(c(0,200,
                1,620,
                2,330,
                3,720,
                4,310,
                5,710,
                6,500,
                7,800,
                8,500),ncol=2,byrow=TRUE)
dw2=terra::classify(dynworld,klases)
writeRaster(dw2,
            "./RasterGrids_10m/2024/DW_reclass.tif",
            overwrite=TRUE)
# other layers
celi=rast("./RasterGrids_10m/2024/SimpleLandscape_class100_celi.tif")
plot(celi)

niedraji=rast("RasterGrids_10m/2024/SimpleLandscape_class720_niedraji_topo.tif")
plot(niedraji)

udeni=rast("./RasterGrids_10m/2024/SimpleLandscape_class200_udens_premask.tif")
plot(udeni)

lauki=rast("./RasterGrids_10m/2024/SimpleLandscape_class300_lauki_premask.tif")
plot(lauki)

vasarnicas=rast("./RasterGrids_10m/2024/SimpleLandscape_class400_varnicas_premask.tif")
plot(vasarnicas)

mezi=rast("./RasterGrids_10m/2024/SimpleLandscape_class600_meziem_premask.tif")
plot(mezi)

mitraji=rast("./RasterGrids_10m/2024/SimpleLandscape_class700_mitraji_premask.tif")
plot(mitraji)

smiltaji=rast("./RasterGrids_10m/2024/SimpleLandscape_class800_smiltaji_premask.tif")
plot(smiltaji)

dw2=rast("./RasterGrids_10m/2024/DW_reclass.tif")
plot(dw2)

# covering in correct order
rastri_ainavai=cover(celi,niedraji)
rastri_ainavai=cover(rastri_ainavai,udeni)
rastri_ainavai=cover(rastri_ainavai,lauki)
rastri_ainavai=cover(rastri_ainavai,vasarnicas)
rastri_ainavai=cover(rastri_ainavai,mezi)
rastri_ainavai=cover(rastri_ainavai,mitraji)
rastri_ainavai=cover(rastri_ainavai,smiltaji)
rastri_ainavai=cover(rastri_ainavai,dw2,
                           filename="./RasterGrids_10m/2024/Ainava_vienkarsa.tif",
                           overwrite=TRUE)
plot(rastri_ainavai)

# cleaning
rm(celi)
rm(niedraji)
rm(udeni)
rm(lauki)
rm(vasarnicas)
rm(mezi)
rm(mitraji)
rm(smiltaji)
rm(klases)
rm(dynworld)
rm(dw2)
rm(rastri_ainavai)

# masking
rastrs_ainava=rast("./RasterGrids_10m/2024/Ainava_vienkarsa.tif")
plot(rastrs_ainava)
freq(rastrs_ainava)

masketa_ainava=terra::mask(rastrs_ainava,
                           template_t,
                           filename="./RasterGrids_10m/2024/Ainava_vienk_mask.tif",
                           overwrite=TRUE)
plot(masketa_ainava)

# cleaning
rm(rastrs_ainava)
rm(masketa_ainava)
```





## Landscape diversity {#Ch05.04}

This subsection summarizes the input products related to the landscape described 
in the previous section – raster layers prepared with a resolution of 10 m, which 
characterize the classes found in the landscape (environment) and the subsequent 
preprocessing for the preparation of the EGV.

Shannon diversity index calculations are so resource-intensive that it is not 
rationally possible to perform them at every landscape scale around each analysis 
cell. They cannot be directly aggregated to speed up the calculation. Therefore, 
a decision has been made on the raster cell size, which:

- is formed as a multiplication of the analysis cell by an integer;

- is large enough to allow for environmental variability. Therefore, the analysis 
cell itself (or multiplication by 1) is not suitable - there is very little 
variability in land cover and land use in an area of 1 ha. This means that this 
cell must be as large as possible, but an analysis cell that is too large would 
mean an artificial intensification of spatial autocorrelation and a loss of 
spatial relevance;

- any landscape scale must be formed from several diversity-index-level cells.

Since we will use spatially weighted zonal statistics in the preparation of EGVs 
and the smallest landscape scale is r=500 m around the center of the EGV-cell, 
it has been decided to calculate the landscape diversity index for individual cells 
with a side length of 500 m, i.e., 25 ha landscapes. This means that the 
smallest number of units used for the development of the EGVs is nine (for a 
landscape scale of r=500 m around the center of the EGV-cell).

Three principal environments are described using diversity indices: landscape in 
general, farmland and forests. To make them easier to reproduce and find, each 
one is described in a separate section below.

### Landscape in general diversity {#Ch05.04.01}

Combination of three layers is involved to describe landscape in general diversity:

- as the lowest in hierarchy is `Ainava_vienk_mask.tif`, prepared in section 
[Landscape classification](#Ch05.03);

- farmland diversity as a top layer in hierarhy. Prepared based on relatively 
broadly classified [agricultural codes (field - SDM_grupa_sakums)](https://github.com/aavotins/HiQBioDiv_EGVs/blob/main/Data/Geodata/2024/LAD/KulturuKodi_2024.xlsx) from [ural Support Service's information on declared fields](#Ch04.02). Only cells 
at declared fields have values, others are empty to be inherited from other layers during overlay. Codes used range from 351 to 362;

- forest diversity as a second layer in hierarchy. This layer describes tree 
species groups dominant in every stand with stand-level inventory interacted with 
age group as used in forestry practice. Values used in this classification are 
available from [database description](https://www.vmd.gov.lv/lv/meza-valsts-registra-meza-inventarizacijas-failu-struktura).

    - tree species groups:
    
        - coniferous species codes: "1", "3", "13", "14", "15", "22", "23";
        
        - boreal deciduous species codes: "4", "6", "8", "9", "19", "20", "21", 
        "32", "35", "50", "68";
        
        - temperate dciduous species codes: "10", "11", "12", "16", "17", "18", 
        "24", "25", "26", "27", "28", "29", "61", "62", "63", "64", "65", "66", 
        "67", "69";
        
        - classification: forest is considered coniferous, if timber volume of coniferous species in top tree layer is at least 75% of total timer volume, else it can be considered boreal deciduous if the respective proportion is at least 75%, else it can be considered temperate deciduous if the respective proportion is 50%, else it is considered mixed.
    
    - tree age groups: 
    
        - forests are considered young, if they are registered with age groups 
        "1", "2" or "3";
        
        - forests are considered old, if they are registered with age groups 
        "4", or "5";
        
    - created codes are formatted as factors and again as scalars with 660 added.

Once the landscape classification is done, diversity index is calculated at 25 ha 
landscapes with function `egvtools::landscape_function`. To guard value coverage, 
inverse distance weighted (power=2) gap filling is incorporated, however,
there were no gaps to fill.


``` r
# Libs ----
if(!require(egvtools)) {install.packages("egvtools"); require(egvtools)}
if(!require(tidyverse)) {install.packages("tidyverse"); require(tidyverse)}
if(!require(sf)) {install.packages("sf"); require(sf)}
if(!require(arrow)) {install.packages("arrow"); require(arrow)}
if(!require(sfarrow)) {install.packages("sfarrow"); require(sfarrow)}
if(!require(terra)) {install.packages("terra"); require(terra)}
if(!require(readxl)) {install.packages("readxl"); require(readxl)}

# templates ----
template_t=rast("./Templates/TemplateRasters/LV10m_10km.tif")
template_r=raster(template_t)


# general diversity ----

## Farmland broad ----

# classification 
culturecodes=read_excel("./Geodata/2024/LAD/KulturuKodi_2024.xlsx")
culturecodes$kods=as.character(culturecodes$kods)
lad=sfarrow::st_read_parquet("./Geodata/2024/LAD/Lauki_2024.parquet")
lad2=lad %>% 
  left_join(culturecodes, by=c("PRODUCT_CODE"="kods")) %>% 
  mutate(numeric_code=as.numeric(as.factor(SDM_grupa_sakums))+350) %>% 
  filter(!is.na(numeric_code))
table(lad2$numeric_code,useNA = "always")

# input layer
polygon2input(vector_data = lad2,
              template_path = "./Templates/TemplateRasters/LV10m_10km.tif",
              out_path = "./RasterGrids_10m/2024/",
              file_name = "Diversity_FarmlandBroad_only.tif",
              value_field = "numeric_code",
              fun="first",
              prepare=FALSE,
              project_mode = "auto")
# cleaning
rm(culturecodes)
rm(lad)
rm(lad2)


## Forests broad ----

# data
mvr=sfarrow::st_read_parquet("./Geodata/2024/MVR/nogabali_2024janv.parquet")

# species groups
coniferous=c("1","3","13","14","15","22","23") # 7
boreal_deciduous=c("4","6","8","9","19","20","21","32","35","50","68") # 11
temperate_deciduous=c("10","11","12","16","17","18","24","25","26","27","28","29",
            "61","62","63","64","65","66","67","69") # 20

# classification
mvr2=mvr %>% 
  mutate(vol_coniferous=ifelse(s10 %in% coniferous,v10,0)+
           ifelse(s11 %in% coniferous,v11,0)+ifelse(s12 %in% coniferous,v12,0)+
           ifelse(s13 %in% coniferous,v13,0)+ifelse(s14 %in% coniferous,v14,0),
         vol_boreal=ifelse(s10 %in% boreal_deciduous,v10,0)+
           ifelse(s11 %in% boreal_deciduous,v11,0)+ifelse(s12 %in% boreal_deciduous,v12,0)+
           ifelse(s13 %in% boreal_deciduous,v13,0)+ifelse(s14 %in% boreal_deciduous,v14,0),
         vol_temperate=ifelse(s10 %in% temperate_deciduous,v10,0)+
           ifelse(s11 %in% temperate_deciduous,v11,0)+ifelse(s12 %in% temperate_deciduous,v12,0)+
           ifelse(s13 %in% temperate_deciduous,v13,0)+ifelse(s14 %in% temperate_deciduous,v14,0)) %>% 
  mutate(vol_total=vol_coniferous+vol_boreal+vol_temperate) %>% 
  mutate(forest_type=ifelse(vol_coniferous/vol_total>=0.75,"coniferous",
                     ifelse(vol_boreal/vol_total>=0.75,"boreal",
                            ifelse(vol_temperate/vol_total>0.5,"temperate",
                                   "mixed")))) %>% 
  mutate(forest_age=ifelse(vgr=="1"|vgr=="2"|vgr=="3","young",
                           ifelse(vgr=="4"|vgr=="5","old",NA))) %>% 
  filter(!is.na(forest_type)) %>% 
  filter(!is.na(forest_age)) %>% 
  mutate(divbroad_class=paste0(forest_type,"_",forest_age)) %>% 
  mutate(divbroad_numeric=as.numeric(as.factor(divbroad_class))+660) %>% 
  filter(!is.na(divbroad_numeric))

# input layer
polygon2input(vector_data = mvr2,
              template_path = "./Templates/TemplateRasters/LV10m_10km.tif",
              out_path = "./RasterGrids_10m/2024/",
              file_name = "Diversity_ForestBroad_only.tif",
              value_field = "divbroad_numeric",
              fun="first",
              prepare=FALSE,
              project_mode = "auto",
              overwrite = TRUE)
# cleaning
rm(mvr)
rm(mvr2)

## General classification ----

simple_landscape=rast("./RasterGrids_10m/2024/Ainava_vienk_mask.tif")

## Covered classes for general diversity ----

farmland_broad=rast("./RasterGrids_10m/2024/Diversity_FarmlandBroad_only.tif")
forests_broad=rast("./RasterGrids_10m/2024/Diversity_ForestBroad_only.tif")

diversity_classes=cover(farmland_broad,forests_broad)
diversity_classes2=cover(diversity_classes,simple_landscape,
                        filename="./RasterGrids_10m/2024/Diversity_GeneralLandscapeBroad.tif",
                        overwrite=TRUE)

rm(simple_landscape)
rm(farmland_broad)
rm(forests_broad)
rm(diversity_classes)
rm(diversity_classes2)

## Diversity index at 25ha -----


res_tbl <- landscape_function(
  landscape      = "./RasterGrids_10m/2024/Diversity_GeneralLandscapeBroad.tif",
  zones          = "./Templates/TemplateGrids/tikls500_sauzeme.parquet",
  id_field       = "rinda500",
  tile_field     = "tks50km",
  template       = "./Templates/TemplateRasters/LV500m_10km.tif",
  out_dir        = "./RasterGrids_500m/2024/",
  out_filename   = "Diversity_GeneralLandscape_500x.tif",
  out_layername  = "Diversity_GeneralLandscape_500x",
  what           = "lsm_l_shdi",
  rasterize_engine = "fasterize",
  n_workers      = 8,
  future_max_size = 3 * 1024^3,
  fill_gaps      = TRUE,
  plot_gaps      = TRUE,
  plot_result    = TRUE
)
print(res_tbl)
plot(rast("./RasterGrids_500m/2024/Diversity_GeneralLandscape_500x.tif"))
rm(res_tbl)
```


### Forest diversity {#Ch05.04.02}

An input grid with a cell size of 10 m covering the entire territory of Latvia. It 
contains the following values, in order of hierarchy:

- [State Forest Service Forest State Register](#Ch04.01) code, in which the 
code of the dominant tree species is multiplied by 1000 and the age group 
code is added. However, before rasterization, geometries in which no code has 
been created or one of the code components is 0 are excluded;

- forest diversity class values prepared in [Landscape in general diversity](#Ch05.04.01);

- forest classes from [Landscape classification](#Ch05.03);

- value 1 - other cells located in the territory of Latvia.

Once the landscape classification is done, diversity index is calculated at 25 ha 
landscapes with function `egvtools::landscape_function`. To guard value coverage, 
inverse distance weighted (power=2) gap filling is incorporated, however,
there were no gaps to fill.


``` r
# Libs ----
if(!require(egvtools)) {install.packages("egvtools"); require(egvtools)}
if(!require(tidyverse)) {install.packages("tidyverse"); require(tidyverse)}
if(!require(sf)) {install.packages("sf"); require(sf)}
if(!require(arrow)) {install.packages("arrow"); require(arrow)}
if(!require(sfarrow)) {install.packages("sfarrow"); require(sfarrow)}
if(!require(terra)) {install.packages("terra"); require(terra)}
if(!require(readxl)) {install.packages("readxl"); require(readxl)}

# templates ----
template_t=rast("./Templates/TemplateRasters/LV10m_10km.tif")
template_r=raster(template_t)

# forest diversity ----

## forest broad ----
forest_broad=rast("./RasterGrids_10m/2024/Diversity_ForestBroad_only.tif")


## forest codes ----
# mezi
mvr=st_read_parquet("./Geodata/2024/MVR/nogabali_2024janv.parquet")

mvr=mvr %>% 
  mutate(kods1=as.numeric(s10)*1000,
         kods2=as.numeric(vgr),
         kods=kods1+kods2) %>% 
  filter(!is.na(kods)) %>% 
  filter(kods1>0) %>% 
  filter(kods2>0)

# input layer
polygon2input(vector_data = mvr,
              template_path = "./Templates/TemplateRasters/LV10m_10km.tif",
              out_path = "./RasterGrids_10m/2024/",
              file_name = "Diversity_ForestCodes_only.tif",
              value_field = "kods",
              fun="first",
              prepare=FALSE,
              project_mode = "auto",
              overwrite = TRUE)

# cleaning
rm(mvr)

# simple forests
simple_forests=rast("./RasterGrids_10m/2024/SimpleLandscape_class600_meziem_premask.tif")

## Covered classes for forest diversity ----

forest_codes=rast("./RasterGrids_10m/2024/Diversity_ForestCodes_only.tif")
plot(forest_codes)
forest_covered=cover(forest_codes,forest_broad)
forest_covered=cover(forest_covered,simple_forests)
plot(forest_covered)

forest_covered2=cover(forest_covered,template_t,
                        filename="./RasterGrids_10m/2024/Diversity_ForestsDetailed.tif",
                        overwrite=TRUE)
plot(forest_covered2)

# cleaning
rm(forest_codes)
rm(forest_covered)
rm(forest_covered2)
rm(forest_broad)
rm(simple_forests)



## Diversity index at 25ha -----

res_tbl <- landscape_function(
  landscape      = "./RasterGrids_10m/2024/Diversity_ForestsDetailed.tif",
  zones          = "./Templates/TemplateGrids/tikls500_sauzeme.parquet",
  id_field       = "rinda500",
  tile_field     = "tks50km",
  template       = "./Templates/TemplateRasters/LV500m_10km.tif",
  out_dir        = "./RasterGrids_500m/2024/",
  out_filename   = "Diversity_Forests_500x.tif",
  out_layername  = "Diversity_Forests_500x",
  what           = "lsm_l_shdi",
  rasterize_engine = "fasterize",
  n_workers      = 8,
  future_max_size = 3 * 1024^3,
  fill_gaps      = TRUE,
  plot_gaps      = TRUE,
  plot_result    = TRUE
)
print(res_tbl)

plot(rast("./RasterGrids_500m/2024/Diversity_Forests_500x.tif"))
rm(res_tbl)
```




### Farmland diversity {#Ch05.04.03}

A grid with a cell size of 10 m covering the entire territory of Latvia. It 
contains the following values, in order of hierarchy:

- [Rural Support Service](#Ch04.02) crop codes with 1000 added;

- farmland diversity class values prepared in [Landscape in general diversity](#Ch05.04.01);

- farmland classes from [Landscape classification](#Ch05.03);

- value 1 - other cells located in the territory of Latvia.

Once the landscape classification is done, diversity index is calculated at 25 ha 
landscapes with function `egvtools::landscape_function`. To guard value coverage, 
inverse distance weighted (power=2) gap filling is incorporated, however,
there were no gaps to fill.


``` r
# Libs ----
if(!require(egvtools)) {install.packages("egvtools"); require(egvtools)}
if(!require(tidyverse)) {install.packages("tidyverse"); require(tidyverse)}
if(!require(sf)) {install.packages("sf"); require(sf)}
if(!require(arrow)) {install.packages("arrow"); require(arrow)}
if(!require(sfarrow)) {install.packages("sfarrow"); require(sfarrow)}
if(!require(terra)) {install.packages("terra"); require(terra)}
if(!require(readxl)) {install.packages("readxl"); require(readxl)}

# templates ----
template_t=rast("./Templates/TemplateRasters/LV10m_10km.tif")
template_r=raster(template_t)



# farmland diversity -----


## Farmland broad ----

farmland_broad=rast("./RasterGrids_10m/2024/Diversity_FarmlandBroad_only.tif")


## Farmland codes ----

lad=sfarrow::st_read_parquet("./Geodata/2024/LAD/Lauki_2024.parquet")
lad$product_code=as.numeric(lad$PRODUCT_CODE)+1000

# input layer
polygon2input(vector_data = lad,
              template_path = "./Templates/TemplateRasters/LV10m_10km.tif",
              out_path = "./RasterGrids_10m/2024/",
              file_name = "Diversity_FarmlandCodes_only.tif",
              value_field = "product_code",
              fun="first",
              prepare=FALSE,
              project_mode = "auto",
              overwrite = TRUE)

# cleaning
rm(lad)


# simple landscapes input 
simple_farmland=rast("./RasterGrids_10m/2024/SimpleLandscape_class300_lauki_premask.tif")

## Covered classes for farmland diversity ----

farmland_codes=rast("./RasterGrids_10m/2024/Diversity_FarmlandCodes_only.tif")
farmland_covered=cover(farmland_codes,farmland_broad)
farmland_covered=cover(farmland_covered,simple_farmland)
farmland_covered2=cover(farmland_covered,template_t,
                        filename="./RasterGrids_10m/2024/Diversity_FarmlandDetailed.tif",
                        overwrite=TRUE)
plot(farmland_covered2)

# cleaning
rm(farmland_codes)
rm(farmland_covered)
rm(farmland_covered2)
rm(simple_farmland)
rm(farmland_broad)


## Diversity index at 25ha -----

res_tbl <- landscape_function(
  landscape      = "./RasterGrids_10m/2024/Diversity_FarmlandDetailed.tif",
  zones          = "./Templates/TemplateGrids/tikls500_sauzeme.parquet",
  id_field       = "rinda500",
  tile_field     = "tks50km",
  template       = "./Templates/TemplateRasters/LV500m_10km.tif",
  out_dir        = "./RasterGrids_500m/2024/",
  out_filename   = "Diversity_Farmland_500x.tif",
  out_layername  = "Diversity_Farmland_500x",
  what           = "lsm_l_shdi",
  rasterize_engine = "fasterize",
  n_workers      = 8,
  future_max_size = 3 * 1024^3,
  fill_gaps      = TRUE,
  plot_gaps      = TRUE,
  plot_result    = TRUE
)
print(res_tbl)

plot(rast("./RasterGrids_500m/2024/Diversity_Farmland_500x.tif"))
rm(res_tbl)
```
