# Raw geodata {#Ch04}

This chapter describes raw geodata used and the preliminary processing conducted on them.

## State Forest Service's State Forest Registry {#Ch04.01}

krā

## Rural Support Service's information on declared fields {#Ch04.02}

krā

## Melioration Cadaster {#Ch04.03}

krā

## TopographicMap {#Ch04.04}

krā


## Corine Land Cover 2018 {#Ch04.05}

krā


## Publicly available LVM data {#Ch04.06}

krā


## Soil data {#Ch04.07}

krā

### Soil chemistry {#Ch04.07.01}

krā

### Soil texture Europe {#Ch04.07.02}

krā

### Soil texture LIZ {#Ch04.07.03}

krā

### Soil texture Quaternary {#Ch04.07.04}

krā

### Organic soils SILAVA {#Ch04.07.05}

krā

### Organic soils LU {#Ch04.07.06}

krā

## Dynamic World data {#Ch04.08}

krā


## The Global Forest Watch {#Ch04.09}

krā

## Palsar {#Ch04.10}

krā

## CHELSA v2.1 {#Ch04.11}

krā [@CHELSA]

https://chelsa-climate.org/

https://chelsa-climate.org/wp-admin/download-page/CHELSA_tech_specification_V2.pdf



## HydroClim data {#Ch04.12}

krā [@HidroClim]

https://zenodo.org/records/5089529

https://datadryad.org/dataset/doi:10.5061/dryad.dv920



## Sentinel-2 indices {#Ch04.13}

The European Space Agency (ESA) Copernicus program's Sentinel-2 mission is a 
constellation of two (three since 09/05/2024) identical satellites orbiting in 
the same orbit. The first satellite, Sentinel-2A, entered its orbit and 
underwent calibration tests on 2015-06-23, the second (Sentinel-2B) on 2017-03-07, 
with the first images available earlier. Each satellite captures high-resolution 
images (from 10 m (at the equator) pixel resolution) in 13 spectral channels 
with a return time of up to 5 days (more frequently closer to the poles) (https://www.esa.int/Applications/Observing_the_Earth/Copernicus/Sentinel-2). The 
data from this mission is freely available, including on the Google Earth Engine 
platform [@GEEpaper] for various large-scale pre-processing and analysis. We use 
the harmonized Level-2A (https://developers.google.com/earth-engine/datasets/catalog/COPERNICUS_S2_SR_HARMONIZED#description) product, applying a cloud mask that includes not only cloud filtering but also 
shadow filtering, so that for each filtered (cloud and seasonal - from April to 
October and from 2020 to 2024) to calculate the normalized difference vegetation 
index (NDVI), the normalized difference moisture index (NDMI), and the 
normalized difference water index (NDWI) as well as various metrics. 
A [replication script](https://code.earthengine.google.com/78024b3354cccb526159fd865b214771) 
can be used to prepare the data. To use this script, 
you need a [GEE account and project]() 
and sufficient space on Google Drive. When executing the command lines, the 
following files will be offered for download:

- `NDVI_median-ST-[runtag, 20250820 by default]` - NDVI short-term median (2020-2024) of annual medians (April to October)

- `NDVI_p25-ST-[runtag, 20250820 by default]` - NDVI short-term median (2020-2024) of annual 25th percentiles (April to October)

- `NDVI_p75-ST-[runtag, 20250820 by default]`- NDVI short-term median (2020-2024) of annual 75th percentiles (April to October)

- `NDVI_iqr-ST-[runtag, 20250820 by default]` - NDVI short-term median (2020-2024) of inter-quartile ranges (April to October)

- `NDVI_median-LY-[runtag, 20250820 by default]` - NDVI last-years (2024) median (April to October)

- `NDMI_median-ST-[runtag, 20250820 by default]` - NDMI short-term median (2020-2024) of annual medians (April to October)

- `NDMI_p25-ST-[runtag, 20250820 by default]` - NDMI short-term median (2020-2024) of annual 25th percentiles (April to October)

- `NDMI_p75-ST-[runtag, 20250820 by default]` - NDMI short-term median (2020-2024) of annual 75th percentiles (April to October)

- `NDMI_iqr-ST-[runtag, 20250820 by default]` - NDMI short-term median (2020-2024) of inter-quartile ranges (April to October)

- `NDMI_median-LY-[runtag, 20250820 by default]` - NDMI last-years (2024) median (April to October)

- `NDWI_median-ST-[runtag, 20250820 by default]` - NDMI short-term median (2020-2024) of annual medians (April to October)

- `NDWI_p25-ST-[runtag, 20250820 by default]` - NDWI short-term median (2020-2024) of annual 25th percentiles (April to October)

- `NDWI_p75-ST-[runtag, 20250820 by default]` - NDWI short-term median (2020-2024) of annual 75th percentiles (April to October)

- `NDWI_iqr-ST-[runtag, 20250820 by default]` - NDWI short-term median (2020-2024) of inter-quartile ranges (April to October)

- `NDWI_median-LY-[runtag, 20250820 by default]` - NDWI last-years (2024) median (April to October)

After executing the command line and preparing the results in Google Drive, it 
can be seen that each layer covering the whole of Latvia is divided into 
several tiles. This is because the layers are encoded as Float and exceed 4 GB 
in size before GeoTIFF compression. All of these files need to be downloaded and 
located at `Geodata/S2indices/RAW`. The following R commands combine them, 
ensuring the coordinate systems and its naming, and pixels match the reference 
raster, while renaming files to ``EO_[index_]-[term: ST or LY][statistic]``.


``` r
# libs ----
if(!require(terra)) {install.packages("terra"); require(terra)}
if(!require(tidyverse)) {install.packages("tidyverse"); require(tidyverse)}


# 10 m raster template ----
template10=rast("./Templates/TemplateRasters/LV10m_10km.tif")

# Fails as exported from GEE ----
faili=data.frame(fails=list.files("./Geodata/S2indices/RAW/"))
faili$celi_sakums=paste0("./Geodata/S2indices/RAW/",faili$fails)

faili=faili[-1,]

# file names ----
faili=faili %>% 
  separate(fails,into=c("nosaukums","vidus","beigas"),sep="-",remove = FALSE) %>% 
  mutate(mosaic_name=paste0("EO_",nosaukums,"-",beigas,tolower(vidus),".tif"),
         masaic_cels=paste0("./Geodata/S2indices/Mosaics/",mosaic_name))


unikalie=levels(factor(faili$mosaic_name))
min(table(faili$mosaic_name))
max(table(faili$mosaic_name))

# preparation of mosaics ----
for(i in seq_along(unikalie)){
  sakums=Sys.time()
  unikalais=faili %>% filter(mosaic_name==unikalie[i])
  beigu_cels=unique(unikalais$masaic_cels)
  
  print(i)
  
  # there are exactly 2 tiles per file
  viens=rast(unikalais$celi_sakums[1])
  divi=rast(unikalais$celi_sakums[2])
  
  viens2=terra::project(viens,template10)
  divi2=terra::project(divi,template10)
  
  mozaika=terra::merge(viens2,divi2)
  maskets=mask(mozaika,template10,
               filename=beigu_cels,overwrite=TRUE,
               gdal=c("COMPRESS=LZW","TILED=YES","BIGTIFF=IF_SAFER"),
               datatype="FLT4S",
               NAflag=NA)
  
  plot(maskets,main=unikalie[i])
  print(beigu_cels)
  beigas=Sys.time()
  ilgums=beigas-sakums
  print(ilgums)
}
```


## Waste and garbage disposal sites, landfills {#Ch04.14}

Information on landfills has been compiled from [VARAM](https://www.varam.gov.lv/sites/varam/files/content/files/atkritumu_poligoni_lv_karte.pdf) and 
Latvian Environment, Geology and Meteorology Center 
["Report on landfills in Latvia in 2023"](https://videscentrs.lvgmc.lv/files/Vide/Atkritumi_un_radiacijas_objekti/Nr_3_parskats_par_atkritumiem/3Atkritumi_kopsavilkums_2023.pdf) listed landfills and their addresses. The coordinates required 
for the preparation of EGVs were found by combining the 
resources https://www.google.com/maps and https://balticmaps.eu/. In addition to 
the resources mentioned above, an object was added at the address 
"Dardedzes C, Mārupes pag., Mārupes nov., Latvia, LV-2166".

In addition, information from the [State Environmental Service on 
separated waste and deposit packaging collection points](https://skiroviegli.lv/#/) 
was used, exporting it to an Excel file.

Both data sets were combined into a single file 
and [added](https://github.com/aavotins/HiQBioDiv_EGVs/blob/main/Data/Geodata/2024/GarbageWasteLandfills/Atkritumi.xlsx) to this material.


## Digital elevation/terrain models {#Ch04.15}

With the publication of continuous aerial laser scanning data for the territory of Latvia (https://www.lgia.gov.lv/lv/digitalie-augstuma-modeli-0), various 
high-resolution (1 m and higher) digital surface models (DSM) and 
digital elevation models (DEM) have been developed. Since the input data is the 
same in all cases, the values of these (corresponding) models are identical 
across almost the entire territory of the country. However, airborne laser 
scanning data (1) is not available for the entire territory of the country, 
and (2) there are differences between the models in terms of filling (availability 
of values) outside inland waters and (3) filling of water bodies themselves. 
However, for areas covered by data on land, the values are almost 
identical (Pearson's correlation coefficients between the DEMs developed 
by LU ĢZZF, LVMI Silava, and LĢIA are greater than 0.999999).

The arithmetic mean between the DEMs developed by LU ĢZZF and LVMI Silava, 
prepared in the LU project "Improvement of sustainable soil resource management 
in agriculture," was used as the base DEM. The resolution of this DEM is 1 m, 
which is not necessary for species distribution modeling input data, therefore 
the layer is designed to correspond to the reference 10 m raster.

When comparing the projected DEM with the reference, there are clearly 
distinguishable areas where there is no data. This has been solved by using 
the DEM with a resolution of 10 m developed by Māris Nartišs (LU ĢZZF) in 2018, 
which covers the entire territory of Latvia without gaps. To prevent sharp 
edges from forming in the fill areas (smooth transitions), an arithmetic mean 
layer was created, covering the entire territory of Latvia and matching the 
reference raster.

A slope layer has also been created from this raster, which is designed in 
accordance with the reference. The slope is expressed in degrees and calculated 
using the 8-neighbor approach. The same applies to the aspect or slope 
direction.





## Latvian Exclusive Economic Zone polygon {#Ch04.16}

The waters of Latvia's Exclusive Economic Zone were obtained from 
the [HELCOM map and data service](https://maps.helcom.fi/website/mapservice/?datasetID=ae58c373-674c-45d1-be0f-1ff69a59f9ba). After downloading, this line file was 
analogically connected to the coastline file obtained from the same resource.


## Nature Conservation Agency's data {#Ch04.17}

vai tiešām izmantoju?


