# Raw geodata {#Ch04}

This chapter describes raw geodata used and the preliminary processing conducted on them.

## State Forest Service's State Forest Register {#Ch04.01}

The State Forest Service's State Forest Register database (ESRI file geodatabase), 
which compiles indicators and spatial data characterizing forest compartments 
(stand level inventory database), was received by the University of 
Latvia on January 7, 2024, to support study and research processes. The structure 
of the received database version corresponds to 
the [State Forest Register Forest Inventory File Structure](https://www.vmd.gov.lv/lv/meza-valsts-registra-meza-inventarizacijas-failu-struktura), but 
lowercase letters are used in field names. 

After downloading, the CRS is guarded, geometries are checked and saved in 
GeoParquet format.

Files are stored at `Geodata/2024/MVR/`.


``` r
# libs
if(!require(sf)) {install.packages("sf"); require(sf)}
if(!require(arrow)) {install.packages("arrow"); require(arrow)}
if(!require(sfarrow)) {install.packages("sfarrow"); require(sfarrow)}
if(!require(gdalUtilities)) {install.packages("gdalUtilities"); require(gdalUtilities)}

# database
nog=read_sf("./Geodata/2024/MVR/VMD.gdb/",layer="Nogabali_pilna_datubaze")

# ensuring geometries
source("./RScripts_final/egvs02.02_UtilityFunctions.R")
nogabali <- ensure_multipolygons(nog)

# securing geometries
nogabali2 = nogabali[!st_is_empty(nogabali),,drop=FALSE] # 108 tukšas ģeometrijas
validity=st_is_valid(nogabali2) 
table(validity) # 1733 invalid ģeometrijas
nogabali3=st_make_valid(nogabali2)

# transforming CRS
nogabali4=st_transform(nogabali3, crs=3059)

# saving
sfarrow::st_write_parquet(nogabali4, "./Geodata/2024/MVR/nogabali_2024janv.parquet")
```


## Rural Support Service's information on declared fields {#Ch04.02}

The Rural Support Service maintains [regularly updated information on the open 
data portal](https://data.gov.lv/dati/lv/organization/lad). An archive (since 2016) is 
also available there, and the data sets that can be used contain the keyword “deklarētās platības”. 

After downloading files to `Geodata/2024/LAD/downloads/`, they are unzipped and read into R. 
Files are checked, empty geometries are deleted and the rest are validated, and all individual 
files are combined into one, which is saved in GeoPackage and GeoParquet formats 
at `Geodata/2024/LAD/`. At the end, downloaded files are unlinked.


``` r
# libs
if(!require(sf)) {install.packages("sf"); require(sf)}
if(!require(arrow)) {install.packages("arrow"); require(arrow)}
if(!require(sfarrow)) {install.packages("sfarrow"); require(sfarrow)}
if(!require(gdalUtilities)) {install.packages("gdalUtilities"); require(gdalUtilities)}

# reading all files
faili=data.frame(celi=list.files("./Geodata/2024/LAD/downloads",full.names = TRUE))
dati=st_read(faili$celi[1])
for(i in 2:length(faili$celi)){
  nakosais=st_read(faili$celi[i])
  dati=bind_rows(dati,nakosais)
  print(nrow(dati))
}

# ensuring geometries
source("./RScripts_final/egvs02.02_UtilityFunctions.R")
nogabali <- ensure_multipolygons(nog)
dati2 <- ensure_multipolygons(dati)
dati3 = dati2[!st_is_empty(dati2),,drop=FALSE] # viss kārtībā
table(st_is_valid(dati3)) 
dati4=st_make_valid(dati3)
table(st_is_valid(dati4))
dati5 <- ensure_multipolygons(dati4)
table(st_is_valid(dati5))

# saving output
st_write(dati5,"./Geodata/2024/LAD/Lauki_2024.gpkg",append = FALSE)
sfarrow::st_write_parquet(dati5,"./Geodata/2024/LAD/Lauki_2024.parquet")

# unlinking downloads
for(i in seq_along(faili$celi)){
  unlink(faili$celi[i])
}
rm(list=ls())
```



## Melioration Cadaster {#Ch04.03}

The Land Improvement Cadastre Information System database was downloaded layer 
by layer from Geoserver. Geometries were tested and validated for each layer, and 
layers were all combined into a single GeoPackage file stored at `Geodata/2024/MKIS/`.

Initially, no additional processing was performed on this data. It was used to 
prepare [Geodata products](#Ch05) - both [Terrain products](#Ch05.01) and [Landscape classification](#Ch05.03).



``` r
# libs
if(!require(sf)) {install.packages("sf"); require(sf)}
if(!require(tidyverse)) {install.packages("tidyverse"); require(tidyverse)}
if(!require(httr)) {install.packages("httr"); require(httr)}
if(!require(ows4R)) {install.packages("ows4R"); require(ows4R)}

# basis information ----
link="https://lvmgeoserver.lvm.lv/geoserver/zmni/ows?"
url=parse_url(link)
url$query <- list(service = "wfs",
                  #version = "2.0.0", # facultative
                  request = "GetCapabilities")
request <- build_url(url)
request
bwk_client <- WFSClient$new(link, 
                            serviceVersion = "2.0.0")
bwk_client
bwk_client$getFeatureTypes(pretty = TRUE)


# dams ----

bwk_client$getFeatureTypes(pretty = TRUE)
url$query <- list(service = "wfs",
                  request = "GetFeature",
                  srsName="EPSG:3059",
                  typename = "zmni:zmni_dam")
request <- build_url(url)
aizsargdambji <- read_sf(request)
aizsargdambji = aizsargdambji %>% st_set_crs(st_crs(3059))
aizsargdambji=st_cast(aizsargdambji,"MULTILINESTRING")

ggplot(aizsargdambji)+geom_sf()

table(st_is_valid(aizsargdambji))

write_sf(aizsargdambji,
         "./Geodata/2024/MKIS/MKIS_2025.gpkg",
         layer="Aizsargdambji",
         append=FALSE)
rm(aizsargdambji)

# watercourses ----

bwk_client$getFeatureTypes(pretty = TRUE)
url$query <- list(service = "wfs",
                  request = "GetFeature",
                  srsName="EPSG:3059",
                  typename = "zmni:zmni_watercourses")
request <- build_url(url)

DabiskasUdensteces <- read_sf(request)
DabiskasUdensteces = DabiskasUdensteces %>% st_set_crs(st_crs(3059))
DabiskasUdensteces=st_cast(DabiskasUdensteces,"MULTILINESTRING")

ggplot(DabiskasUdensteces)+geom_sf()

table(st_is_valid(DabiskasUdensteces))

write_sf(DabiskasUdensteces,
         "./Geodata/2024/MKIS/MKIS_2025.gpkg",
         layer="DabiskasUdensteces",
         append=FALSE)
rm(DabiskasUdensteces)



# dam pickets ----


bwk_client$getFeatureTypes(pretty = TRUE)
url$query <- list(service = "wfs",
                  request = "GetFeature",
                  srsName="EPSG:3059",
                  typename = "zmni:zmni_dampicket")
request <- build_url(url)

DambjuPiketi <- read_sf(request)
DambjuPiketi = DambjuPiketi %>% st_set_crs(st_crs(3059))
DambjuPiketi=st_cast(DambjuPiketi,"POINT")

ggplot(DambjuPiketi)+geom_sf()

table(st_is_valid(DambjuPiketi))

write_sf(DambjuPiketi,
         "./Geodata/2024/MKIS/MKIS_2025.gpkg",
         layer="DambjuPiketi",
         append=FALSE)
rm(DambjuPiketi)


# drainpipes ----

bwk_client$getFeatureTypes(pretty = TRUE)

base_url <- "https://lvmgeoserver.lvm.lv/geoserver/zmni/ows?"
type_name <- "zmni:zmni_drainpipes"
crs_code <- 3059
chunk_size <- 100000
gpkg_path <- "./Geodata/2024/MKIS/temp_MKIS_2025.gpkg"
layer_name <- "temp_Drenas"
i <- 0

repeat {
  message("Fetching features ", i * chunk_size + 1, " to ", (i + 1) * chunk_size, "...")
  
  query <- list(
    service = "WFS",
    version = "2.0.0",
    request = "GetFeature",
    typename = type_name,
    srsName = paste0("EPSG:", crs_code),
    count = chunk_size,
    startIndex = i * chunk_size
  )
  
  req_url <- modify_url(base_url, query = query)
  
  try({
    chunk <- read_sf(req_url)
    if (nrow(chunk) == 0) break
    
    # Set CRS and cast to MULTILINESTRING
    chunk <- chunk %>%
      st_set_crs(st_crs(crs_code)) %>%
      st_cast("MULTILINESTRING")
    
    # Write chunk to GeoPackage (append mode after first)
    st_write(
      chunk, 
      dsn = gpkg_path,
      layer = layer_name,
      append = i != 0,
      quiet = FALSE
    )
    
    i <- i + 1
  }, silent = TRUE)
}

message("All chunks written to ", gpkg_path, " in layer ", layer_name)

Drenas_all=st_read("./Geodata/2024/MKIS/temp_MKIS_2025.gpkg",
                   layer="temp_Drenas")
Drenas_all2 = Drenas_all[!st_is_empty(Drenas_all),,drop=FALSE] # 1
table(st_is_valid(Drenas_all2))


write_sf(Drenas_all2,
         "./Geodata/2024/MKIS/MKIS_2025.gpkg",
         layer="Drenas",
         append=FALSE)
rm(list=ls())




# drain collectors ----


bwk_client$getFeatureTypes(pretty = TRUE)

# geoms
bwk_client$getFeatureTypes(pretty = TRUE)
url$query <- list(service = "wfs",
                  request = "GetFeature",
                  srsName="EPSG:3059",
                  typename = "zmni:zmni_draincollectors",
                  count=1)
request <- build_url(url)

geometrijam <- read_sf(request)
geometrijam

# count
url$query <- list(service = "wfs",
                  request = "GetFeature",
                  srsName="EPSG:3059",
                  typename = "zmni:zmni_draincollectors",
                  resultType="hits")
request <- build_url(url)
result <- GET(request)
parsed <- xml2::as_list(content(result, "parsed"))
n_features <- attr(parsed$FeatureCollection, "numberMatched")
n_features


# download
base_url <- "https://lvmgeoserver.lvm.lv/geoserver/zmni/ows?"
type_name <- "zmni:zmni_draincollectors"
crs_code <- 3059
chunk_size <- 100000
gpkg_path <- "./Geodata/2024/MKIS/temp_MKIS_2025.gpkg"
layer_name <- "temp_DrenuKolektori"
i <- 0

repeat {
  message("Fetching features ", i * chunk_size + 1, " to ", (i + 1) * chunk_size, "...")
  
  query <- list(
    service = "WFS",
    version = "2.0.0",
    request = "GetFeature",
    typename = type_name,
    srsName = paste0("EPSG:", crs_code),
    count = chunk_size,
    startIndex = i * chunk_size
  )
  
  req_url <- modify_url(base_url, query = query)
  
  try({
    chunk <- read_sf(req_url)
    if (nrow(chunk) == 0) break
    
    # Set CRS and cast to MULTILINESTRING
    chunk <- chunk %>%
      st_set_crs(st_crs(crs_code)) %>%
      st_cast("MULTILINESTRING")
    
    # Write chunk to GeoPackage (append mode after first)
    st_write(
      chunk, 
      dsn = gpkg_path,
      layer = layer_name,
      append = i != 0,
      quiet = FALSE
    )
    
    i <- i + 1
  }, silent = TRUE)
}

message("All chunks written to ", gpkg_path, " in layer ", layer_name)

DrenuKolektori_all=st_read("./Geodata/2024/MKIS/temp_MKIS_2025.gpkg",
                           layer="temp_DrenuKolektori")
DrenuKolektori_all2 = DrenuKolektori_all[!st_is_empty(DrenuKolektori_all),,drop=FALSE] # 1
table(st_is_valid(DrenuKolektori_all2))


write_sf(DrenuKolektori_all2,
         "./Geodata/2024/MKIS/MKIS_2025.gpkg",
         layer="DrenuKolektori",
         append=FALSE)
rm(list=ls())




# drenage network structures ----

link="https://lvmgeoserver.lvm.lv/geoserver/zmni/ows?"
url=parse_url(link)

url$query <- list(service = "wfs",request = "GetCapabilities")
request <- build_url(url)
bwk_client <- WFSClient$new(link,serviceVersion = "2.0.0")

bwk_client$getFeatureTypes(pretty = TRUE)

# geoms

url$query <- list(service = "wfs",
                  request = "GetFeature",
                  srsName="EPSG:3059",
                  typename = "zmni:zmni_networkstructures",
                  count=1)
request <- build_url(url)

geometrijam <- read_sf(request)
geometrijam



# download
base_url <- "https://lvmgeoserver.lvm.lv/geoserver/zmni/ows?"
type_name <- "zmni:zmni_networkstructures"
crs_code <- 3059
chunk_size <- 100000
gpkg_path <- "./Geodata/2024/MKIS/temp_MKIS_2025.gpkg"
layer_name <- "temp_DrenazasTiklaBuves"
i <- 0

repeat {
  message("Fetching features ", i * chunk_size + 1, " to ", (i + 1) * chunk_size, "...")
  
  query <- list(
    service = "WFS",
    version = "2.0.0",
    request = "GetFeature",
    typename = type_name,
    srsName = paste0("EPSG:", crs_code),
    count = chunk_size,
    startIndex = i * chunk_size
  )
  
  req_url <- modify_url(base_url, query = query)
  
  try({
    chunk <- read_sf(req_url)
    if (nrow(chunk) == 0) break
    
    # Set CRS and cast to MULTILINESTRING
    chunk <- chunk %>%
      st_set_crs(st_crs(crs_code)) %>%
      st_cast("POINT")
    
    # Write chunk to GeoPackage (append mode after first)
    st_write(
      chunk, 
      dsn = gpkg_path,
      layer = layer_name,
      append = i != 0,
      quiet = FALSE
    )
    
    i <- i + 1
  }, silent = TRUE)
}

message("All chunks written to ", gpkg_path, " in layer ", layer_name)

DrenazasTiklaBuves_all=st_read("./Geodata/2024/MKIS/temp_MKIS_2025.gpkg",
                               layer="temp_DrenazasTiklaBuves")
DrenazasTiklaBuves_all2 = DrenazasTiklaBuves_all[!st_is_empty(DrenazasTiklaBuves_all),,drop=FALSE] # 0
table(st_is_valid(DrenazasTiklaBuves_all2))


write_sf(DrenazasTiklaBuves_all2,
         "./Geodata/2024/MKIS/MKIS_2025.gpkg",
         layer="DrenazasTiklaBuves",
         append=FALSE)
rm(list=ls())




# dithces -----


link="https://lvmgeoserver.lvm.lv/geoserver/zmni/ows?"
url=parse_url(link)

url$query <- list(service = "wfs",request = "GetCapabilities")
request <- build_url(url)
bwk_client <- WFSClient$new(link,serviceVersion = "2.0.0")

bwk_client$getFeatureTypes(pretty = TRUE)

# geoms

url$query <- list(service = "wfs",
                  request = "GetFeature",
                  srsName="EPSG:3059",
                  typename = "zmni:zmni_ditches",
                  count=100)
request <- build_url(url)

geometrijam <- read_sf(request)
geometrijam



# download
base_url <- "https://lvmgeoserver.lvm.lv/geoserver/zmni/ows?"
type_name <- "zmni:zmni_ditches"
crs_code <- 3059
chunk_size <- 100000
gpkg_path <- "./Geodata/2024/MKIS/temp_MKIS_2025.gpkg"
layer_name <- "temp_Gravji"
i <- 0

repeat {
  message("Fetching features ", i * chunk_size + 1, " to ", (i + 1) * chunk_size, "...")
  
  query <- list(
    service = "WFS",
    version = "2.0.0",
    request = "GetFeature",
    typename = type_name,
    srsName = paste0("EPSG:", crs_code),
    count = chunk_size,
    startIndex = i * chunk_size
  )
  
  req_url <- modify_url(base_url, query = query)
  
  try({
    chunk <- read_sf(req_url)
    if (nrow(chunk) == 0) break
    
    # Set CRS and cast to MULTILINESTRING
    chunk <- chunk %>%
      st_set_crs(st_crs(crs_code)) %>%
      st_cast("MULTILINESTRING")
    
    # Write chunk to GeoPackage (append mode after first)
    st_write(
      chunk, 
      dsn = gpkg_path,
      layer = layer_name,
      append = i != 0,
      quiet = FALSE
    )
    
    i <- i + 1
  }, silent = TRUE)
}

message("All chunks written to ", gpkg_path, " in layer ", layer_name)

Gravji_all=st_read("./Geodata/2024/MKIS/temp_MKIS_2025.gpkg",
                   layer="temp_Gravji")
Gravji_all2 = Gravji_all[!st_is_empty(Gravji_all),,drop=FALSE] # 0
table(st_is_valid(Gravji_all2))


write_sf(Gravji_all2,
         "./Geodata/2024/MKIS/MKIS_2025.gpkg",
         layer="Gravji",
         append=FALSE)
rm(list=ls())




# hydrometric posts ----


link="https://lvmgeoserver.lvm.lv/geoserver/zmni/ows?"
url=parse_url(link)

url$query <- list(service = "wfs",request = "GetCapabilities")
request <- build_url(url)
bwk_client <- WFSClient$new(link,serviceVersion = "2.0.0")

bwk_client$getFeatureTypes(pretty = TRUE)

# geoms

url$query <- list(service = "wfs",
                  request = "GetFeature",
                  srsName="EPSG:3059",
                  typename = "zmni:zmni_hydropost",
                  count=100)
request <- build_url(url)

geometrijam <- read_sf(request)
geometrijam



# download
base_url <- "https://lvmgeoserver.lvm.lv/geoserver/zmni/ows?"
type_name <- "zmni:zmni_hydropost"
crs_code <- 3059
chunk_size <- 100000
gpkg_path <- "./IevadesDati/MKIS/temp_MKIS_2025.gpkg"
layer_name <- "temp_HidrometriskiePosteni"
i <- 0

repeat {
  message("Fetching features ", i * chunk_size + 1, " to ", (i + 1) * chunk_size, "...")
  
  query <- list(
    service = "WFS",
    version = "2.0.0",
    request = "GetFeature",
    typename = type_name,
    srsName = paste0("EPSG:", crs_code),
    count = chunk_size,
    startIndex = i * chunk_size
  )
  
  req_url <- modify_url(base_url, query = query)
  
  try({
    chunk <- read_sf(req_url)
    if (nrow(chunk) == 0) break
    
    # Set CRS and cast to MULTILINESTRING, POINT, MULTIPOLYGON
    chunk <- chunk %>%
      st_set_crs(st_crs(crs_code)) %>%
      st_cast("POINT")
    
    # Write chunk to GeoPackage (append mode after first)
    st_write(
      chunk, 
      dsn = gpkg_path,
      layer = layer_name,
      append = i != 0,
      quiet = FALSE
    )
    
    i <- i + 1
  }, silent = TRUE)
}

message("All chunks written to ", gpkg_path, " in layer ", layer_name)

HidrometriskiePosteni_all=st_read("./Geodata/2024/MKIS/temp_MKIS_2025.gpkg",
                                  layer="temp_HidrometriskiePosteni")
HidrometriskiePosteni_all2 = HidrometriskiePosteni_all[!st_is_empty(HidrometriskiePosteni_all),,drop=FALSE] # 0
table(st_is_valid(HidrometriskiePosteni_all2))


write_sf(HidrometriskiePosteni_all2,
         "./Geodata/2024/MKIS/MKIS_2025.gpkg",
         layer="HidrometriskiePosteni",
         append=FALSE)
rm(list=ls())


# large diameter drain collectors ----


link="https://lvmgeoserver.lvm.lv/geoserver/zmni/ows?"
url=parse_url(link)

url$query <- list(service = "wfs",request = "GetCapabilities")
request <- build_url(url)
bwk_client <- WFSClient$new(link,serviceVersion = "2.0.0")

bwk_client$getFeatureTypes(pretty = TRUE)

# geoms

url$query <- list(service = "wfs",
                  request = "GetFeature",
                  srsName="EPSG:3059",
                  typename = "zmni:zmni_bigdraincollectors",
                  count=100)
request <- build_url(url)

geometrijam <- read_sf(request)
geometrijam



# download
base_url <- "https://lvmgeoserver.lvm.lv/geoserver/zmni/ows?"
type_name <- "zmni:zmni_bigdraincollectors"
crs_code <- 3059
chunk_size <- 100000
gpkg_path <- "./Geodata/2024/MKIS/temp_MKIS_2025.gpkg"
layer_name <- "temp_LielaDiametraKolektori"
i <- 0

repeat {
  message("Fetching features ", i * chunk_size + 1, " to ", (i + 1) * chunk_size, "...")
  
  query <- list(
    service = "WFS",
    version = "2.0.0",
    request = "GetFeature",
    typename = type_name,
    srsName = paste0("EPSG:", crs_code),
    count = chunk_size,
    startIndex = i * chunk_size
  )
  
  req_url <- modify_url(base_url, query = query)
  
  try({
    chunk <- read_sf(req_url)
    if (nrow(chunk) == 0) break
    
    # Set CRS and cast to MULTILINESTRING, POINT, MULTIPOLYGON
    chunk <- chunk %>%
      st_set_crs(st_crs(crs_code)) %>%
      st_cast("MULTILINESTRING")
    
    # Write chunk to GeoPackage (append mode after first)
    st_write(
      chunk, 
      dsn = gpkg_path,
      layer = layer_name,
      append = i != 0,
      quiet = FALSE
    )
    
    i <- i + 1
  }, silent = TRUE)
}

message("All chunks written to ", gpkg_path, " in layer ", layer_name)

LielaDiametraKolektori_all=st_read("./Geodata/2024/MKIS/temp_MKIS_2025.gpkg",
                                   layer="temp_LielaDiametraKolektori")
LielaDiametraKolektori_all2 = LielaDiametraKolektori_all[!st_is_empty(LielaDiametraKolektori_all),,drop=FALSE] # 0
table(st_is_valid(LielaDiametraKolektori_all2))


write_sf(LielaDiametraKolektori_all2,
         "./Geodata/2024/MKIS/MKIS_2025.gpkg",
         layer="LielaDiametraKolektori",
         append=FALSE)
rm(list=ls())




# river pickets ----



link="https://lvmgeoserver.lvm.lv/geoserver/zmni/ows?"
url=parse_url(link)

url$query <- list(service = "wfs",request = "GetCapabilities")
request <- build_url(url)
bwk_client <- WFSClient$new(link,serviceVersion = "2.0.0")

bwk_client$getFeatureTypes(pretty = TRUE)

# geoms

url$query <- list(service = "wfs",
                  request = "GetFeature",
                  srsName="EPSG:3059",
                  typename = "zmni:zmni_stateriverspickets",
                  count=100)
request <- build_url(url)

geometrijam <- read_sf(request)
geometrijam



# download
base_url <- "https://lvmgeoserver.lvm.lv/geoserver/zmni/ows?"
type_name <- "zmni:zmni_stateriverspickets"
crs_code <- 3059
chunk_size <- 100000
gpkg_path <- "./Geodata/2024/MKIS/temp_MKIS_2025.gpkg"
layer_name <- "temp_Piketi"
i <- 0

repeat {
  message("Fetching features ", i * chunk_size + 1, " to ", (i + 1) * chunk_size, "...")
  
  query <- list(
    service = "WFS",
    version = "2.0.0",
    request = "GetFeature",
    typename = type_name,
    srsName = paste0("EPSG:", crs_code),
    count = chunk_size,
    startIndex = i * chunk_size
  )
  
  req_url <- modify_url(base_url, query = query)
  
  try({
    chunk <- read_sf(req_url)
    if (nrow(chunk) == 0) break
    
    # Set CRS and cast to MULTILINESTRING, POINT, MULTIPOLYGON
    chunk <- chunk %>%
      st_set_crs(st_crs(crs_code)) %>%
      st_cast("POINT")
    
    # Write chunk to GeoPackage (append mode after first)
    st_write(
      chunk, 
      dsn = gpkg_path,
      layer = layer_name,
      append = i != 0,
      quiet = FALSE
    )
    
    i <- i + 1
  }, silent = TRUE)
}

message("All chunks written to ", gpkg_path, " in layer ", layer_name)

Piketi_all=st_read("./Geodata/2024/MKIS/temp_MKIS_2025.gpkg",
                   layer="temp_Piketi")
Piketi_all2 = Piketi_all[!st_is_empty(Piketi_all),,drop=FALSE] # 0
table(st_is_valid(Piketi_all2))


write_sf(Piketi_all2,
         "./Geodata/2024/MKIS/MKIS_2025.gpkg",
         layer="Piketi",
         append=FALSE)
rm(list=ls())


# polder pumping stations -----


link="https://lvmgeoserver.lvm.lv/geoserver/zmni/ows?"
url=parse_url(link)

url$query <- list(service = "wfs",request = "GetCapabilities")
request <- build_url(url)
bwk_client <- WFSClient$new(link,serviceVersion = "2.0.0")

bwk_client$getFeatureTypes(pretty = TRUE)

# geoms

url$query <- list(service = "wfs",
                  request = "GetFeature",
                  srsName="EPSG:3059",
                  typename = "zmni:zmni_polderpumpingstation",
                  count=100)
request <- build_url(url)

geometrijam <- read_sf(request)
geometrijam



# download
base_url <- "https://lvmgeoserver.lvm.lv/geoserver/zmni/ows?"
type_name <- "zmni:zmni_polderpumpingstation"
crs_code <- 3059
chunk_size <- 100000
gpkg_path <- "./Geodata/2024/MKIS/temp_MKIS_2025.gpkg"
layer_name <- "temp_PolderuSuknuStacijas"
i <- 0

repeat {
  message("Fetching features ", i * chunk_size + 1, " to ", (i + 1) * chunk_size, "...")
  
  query <- list(
    service = "WFS",
    version = "2.0.0",
    request = "GetFeature",
    typename = type_name,
    srsName = paste0("EPSG:", crs_code),
    count = chunk_size,
    startIndex = i * chunk_size
  )
  
  req_url <- modify_url(base_url, query = query)
  
  try({
    chunk <- read_sf(req_url)
    if (nrow(chunk) == 0) break
    
    # Set CRS and cast to MULTILINESTRING, POINT, MULTIPOLYGON
    chunk <- chunk %>%
      st_set_crs(st_crs(crs_code)) %>%
      st_cast("POINT")
    
    # Write chunk to GeoPackage (append mode after first)
    st_write(
      chunk, 
      dsn = gpkg_path,
      layer = layer_name,
      append = i != 0,
      quiet = FALSE
    )
    
    i <- i + 1
  }, silent = TRUE)
}

message("All chunks written to ", gpkg_path, " in layer ", layer_name)

PolderuSuknuStacijas_all=st_read("./Geodata/2024/MKIS/temp_MKIS_2025.gpkg",
                                 layer="temp_PolderuSuknuStacijas")
PolderuSuknuStacijas_all2 = PolderuSuknuStacijas_all[!st_is_empty(PolderuSuknuStacijas_all),,drop=FALSE] # 0
table(st_is_valid(PolderuSuknuStacijas_all2))


write_sf(PolderuSuknuStacijas_all2,
         "./Geodata/2024/MKIS/MKIS_2025.gpkg",
         layer="PolderuSuknuStacijas",
         append=FALSE)
rm(list=ls())



# polders -----


link="https://lvmgeoserver.lvm.lv/geoserver/zmni/ows?"
url=parse_url(link)

url$query <- list(service = "wfs",request = "GetCapabilities")
request <- build_url(url)
bwk_client <- WFSClient$new(link,serviceVersion = "2.0.0")

bwk_client$getFeatureTypes(pretty = TRUE)

# geoms

url$query <- list(service = "wfs",
                  request = "GetFeature",
                  srsName="EPSG:3059",
                  typename = "zmni:zmni_polderterritory",
                  count=100)
request <- build_url(url)

geometrijam <- read_sf(request)
geometrijam

geometrijas=st_set_crs(geometrijam,st_crs(3059))

library(gdalUtilities)
ensure_multipolygons <- function(X) {
  tmp1 <- tempfile(fileext = ".gpkg")
  tmp2 <- tempfile(fileext = ".gpkg")
  st_write(X, tmp1)
  ogr2ogr(tmp1, tmp2, f = "GPKG", nlt = "MULTIPOLYGON")
  Y <- st_read(tmp2)
  st_sf(st_drop_geometry(X), geom = st_geometry(Y))
}
poligoni <- ensure_multipolygons(geometrijas)
PolderuTeritorijas_all2 = poligoni[!st_is_empty(poligoni),,drop=FALSE] # 0
table(st_is_valid(PolderuTeritorijas_all2))


# download
base_url <- "https://lvmgeoserver.lvm.lv/geoserver/zmni/ows?"
type_name <- "zmni:zmni_polderterritory"
crs_code <- 3059
chunk_size <- 100000
gpkg_path <- "./Geodata/2024/MKIS/temp_MKIS_2025.gpkg"
layer_name <- "temp_PolderuTeritorijas"
i <- 0

repeat {
  message("Fetching features ", i * chunk_size + 1, " to ", (i + 1) * chunk_size, "...")
  
  query <- list(
    service = "WFS",
    version = "2.0.0",
    request = "GetFeature",
    typename = type_name,
    srsName = paste0("EPSG:", crs_code),
    count = chunk_size,
    startIndex = i * chunk_size
  )
  
  req_url <- modify_url(base_url, query = query)
  
  try({
    chunk <- read_sf(req_url)
    if (nrow(chunk) == 0) break
    
    # Set CRS and cast to MULTILINESTRING, POINT, MULTIPOLYGON
    chunk <- chunk %>%
      st_set_crs(st_crs(crs_code)) %>%
      st_cast("MULTIPOLYGON")
    
    # Write chunk to GeoPackage (append mode after first)
    st_write(
      chunk, 
      dsn = gpkg_path,
      layer = layer_name,
      append = i != 0,
      quiet = FALSE
    )
    
    i <- i + 1
  }, silent = TRUE)
  Sys.sleep(0.5)
}

message("All chunks written to ", gpkg_path, " in layer ", layer_name)


PolderuTeritorijas_all=st_read("./Geodata/2024/MKIS/temp_MKIS_2025.gpkg",
                               layer="temp_PolderuTeritorijas")
PolderuTeritorijas_all2 = PolderuTeritorijas_all[!st_is_empty(PolderuTeritorijas_all),,drop=FALSE] # 0
table(st_is_valid(PolderuTeritorijas_all2))


write_sf(PolderuTeritorijas_all2,
         "./Geodata/2024/MKIS/MKIS_2025.gpkg",
         layer="PolderuTeritorijas",
         append=FALSE)
rm(list=ls())


# catchment basins ----


link="https://lvmgeoserver.lvm.lv/geoserver/zmni/ows?"
url=parse_url(link)

url$query <- list(service = "wfs",request = "GetCapabilities")
request <- build_url(url)
bwk_client <- WFSClient$new(link,serviceVersion = "2.0.0")

bwk_client$getFeatureTypes(pretty = TRUE)

# geoms

url$query <- list(service = "wfs",
                  request = "GetFeature",
                  srsName="EPSG:3059",
                  typename = "zmni:zmni_catchment",
                  count=100)
request <- build_url(url)

geometrijam <- read_sf(request)
geometrijam



# download
base_url <- "https://lvmgeoserver.lvm.lv/geoserver/zmni/ows?"
type_name <- "zmni:zmni_catchment"
crs_code <- 3059
chunk_size <- 100000
gpkg_path <- "./Geodata/2024/MKIS/temp_MKIS_2025.gpkg"
layer_name <- "temp_SatecesBaseini"
i <- 0

repeat {
  message("Fetching features ", i * chunk_size + 1, " to ", (i + 1) * chunk_size, "...")
  
  query <- list(
    service = "WFS",
    version = "2.0.0",
    request = "GetFeature",
    typename = type_name,
    srsName = paste0("EPSG:", crs_code),
    count = chunk_size,
    startIndex = i * chunk_size
  )
  
  req_url <- modify_url(base_url, query = query)
  
  try({
    chunk <- read_sf(req_url)
    if (nrow(chunk) == 0) break
    
    # Set CRS and cast to MULTILINESTRING, POINT, MULTIPOLYGON
    chunk <- chunk %>%
      st_set_crs(st_crs(crs_code))
    
    ensure_multipolygons <- function(X) {
      tmp1 <- tempfile(fileext = ".gpkg")
      tmp2 <- tempfile(fileext = ".gpkg")
      st_write(X, tmp1)
      ogr2ogr(tmp1, tmp2, f = "GPKG", nlt = "MULTIPOLYGON")
      Y <- st_read(tmp2)
      st_sf(st_drop_geometry(X), geom = st_geometry(Y))
    }
    chunk <- ensure_multipolygons(chunk)
    
    
    # Write chunk to GeoPackage (append mode after first)
    st_write(
      chunk, 
      dsn = gpkg_path,
      layer = layer_name,
      append = i != 0,
      quiet = FALSE
    )
    
    i <- i + 1
  }, silent = TRUE)
  Sys.sleep(0.5)
}

message("All chunks written to ", gpkg_path, " in layer ", layer_name)


SatecesBaseini_all=st_read("./Geodata/2024/MKIS/temp_MKIS_2025.gpkg",
                           layer="temp_SatecesBaseini")
SatecesBaseini_all2 = SatecesBaseini_all[!st_is_empty(SatecesBaseini_all),,drop=FALSE] # 0
table(st_is_valid(SatecesBaseini_all2))

SatecesBaseini_all3=st_make_valid(SatecesBaseini_all2)
table(st_is_valid(SatecesBaseini_all3))
SatecesBaseini_all3

write_sf(SatecesBaseini_all3,
         "./Geodata/2024/MKIS/MKIS_2025.gpkg",
         layer="SatecesBaseini",
         append=FALSE)
rm(list=ls())


# drenage connection points ----


link="https://lvmgeoserver.lvm.lv/geoserver/zmni/ows?"
url=parse_url(link)

url$query <- list(service = "wfs",request = "GetCapabilities")
request <- build_url(url)
bwk_client <- WFSClient$new(link,serviceVersion = "2.0.0")

bwk_client$getFeatureTypes(pretty = TRUE)

# geoms

url$query <- list(service = "wfs",
                  request = "GetFeature",
                  srsName="EPSG:3059",
                  typename = "zmni:zmni_connectionpoints",
                  count=100)
request <- build_url(url)

geometrijam <- read_sf(request)
geometrijam



# download
base_url <- "https://lvmgeoserver.lvm.lv/geoserver/zmni/ows?"
type_name <- "zmni:zmni_connectionpoints"
crs_code <- 3059
chunk_size <- 100000
gpkg_path <- "./Geodata/2024/MKIS/temp_MKIS_2025.gpkg"
layer_name <- "temp_Savienojumi"
i <- 0

repeat {
  message("Fetching features ", i * chunk_size + 1, " to ", (i + 1) * chunk_size, "...")
  
  query <- list(
    service = "WFS",
    version = "2.0.0",
    request = "GetFeature",
    typename = type_name,
    srsName = paste0("EPSG:", crs_code),
    count = chunk_size,
    startIndex = i * chunk_size
  )
  
  req_url <- modify_url(base_url, query = query)
  
  try({
    chunk <- read_sf(req_url)
    if (nrow(chunk) == 0) break
    
    # Set CRS and cast to MULTILINESTRING, POINT, MULTIPOLYGON
    chunk <- chunk %>%
      st_set_crs(st_crs(crs_code))
    
    chunk=st_cast(chunk,"POINT")
    
    # Write chunk to GeoPackage (append mode after first)
    st_write(
      chunk, 
      dsn = gpkg_path,
      layer = layer_name,
      append = i != 0,
      quiet = FALSE
    )
    
    i <- i + 1
  }, silent = TRUE)
  Sys.sleep(0.5)
}

message("All chunks written to ", gpkg_path, " in layer ", layer_name)


Savienojumi_all=st_read("./Geodata/2024/MKIS/temp_MKIS_2025.gpkg",
                        layer="temp_Savienojumi")
Savienojumi_all2 = Savienojumi_all[!st_is_empty(Savienojumi_all),,drop=FALSE] # 0
table(st_is_valid(Savienojumi_all2))


write_sf(Savienojumi_all2,
         "./Geodata/2024/MKIS/MKIS_2025.gpkg",
         layer="Savienojumi",
         append=FALSE)
rm(list=ls())


# state controlled rivers -----


link="https://lvmgeoserver.lvm.lv/geoserver/zmni/ows?"
url=parse_url(link)

url$query <- list(service = "wfs",request = "GetCapabilities")
request <- build_url(url)
bwk_client <- WFSClient$new(link,serviceVersion = "2.0.0")

bwk_client$getFeatureTypes(pretty = TRUE)

# geoms

url$query <- list(service = "wfs",
                  request = "GetFeature",
                  srsName="EPSG:3059",
                  typename = "zmni:zmni_statecontrolledrivers",
                  count=100)
request <- build_url(url)

geometrijam <- read_sf(request)
geometrijam



# download
base_url <- "https://lvmgeoserver.lvm.lv/geoserver/zmni/ows?"
type_name <- "zmni:zmni_statecontrolledrivers"
crs_code <- 3059
chunk_size <- 100000
gpkg_path <- "./Geodata/2024/MKIS/temp_MKIS_2025.gpkg"
layer_name <- "temp_ValstsNozimesUdensnotekas"
i <- 0

repeat {
  message("Fetching features ", i * chunk_size + 1, " to ", (i + 1) * chunk_size, "...")
  
  query <- list(
    service = "WFS",
    version = "2.0.0",
    request = "GetFeature",
    typename = type_name,
    srsName = paste0("EPSG:", crs_code),
    count = chunk_size,
    startIndex = i * chunk_size
  )
  
  req_url <- modify_url(base_url, query = query)
  
  try({
    chunk <- read_sf(req_url)
    if (nrow(chunk) == 0) break
    
    # Set CRS and cast to MULTILINESTRING, POINT, MULTIPOLYGON
    chunk <- chunk %>%
      st_set_crs(st_crs(crs_code))
    
    chunk=st_cast(chunk,"MULTILINESTRING")
    
    # Write chunk to GeoPackage (append mode after first)
    st_write(
      chunk, 
      dsn = gpkg_path,
      layer = layer_name,
      append = i != 0,
      quiet = FALSE
    )
    
    i <- i + 1
  }, silent = TRUE)
  Sys.sleep(0.5)
}

message("All chunks written to ", gpkg_path, " in layer ", layer_name)


ValstsNozimesUdensnotekas_all=st_read("./Geodata/2024/MKIS/temp_MKIS_2025.gpkg",
                                      layer="temp_ValstsNozimesUdensnotekas")
ValstsNozimesUdensnotekas_all2 = ValstsNozimesUdensnotekas_all[!st_is_empty(ValstsNozimesUdensnotekas_all),,drop=FALSE] # 0
table(st_is_valid(ValstsNozimesUdensnotekas_all2))


write_sf(ValstsNozimesUdensnotekas_all2,
         "./Geodata/2024/MKIS/MKIS_2025.gpkg",
         layer="ValstsNozimesUdensnotekas",
         append=FALSE)
rm(list=ls())


# zmni regions ----


link="https://lvmgeoserver.lvm.lv/geoserver/zmni/ows?"
url=parse_url(link)

url$query <- list(service = "wfs",request = "GetCapabilities")
request <- build_url(url)
bwk_client <- WFSClient$new(link,serviceVersion = "2.0.0")

bwk_client$getFeatureTypes(pretty = TRUE)

# geoms

url$query <- list(service = "wfs",
                  request = "GetFeature",
                  srsName="EPSG:3059",
                  typename = "zmni:zmni_zmniregion",
                  count=100)
request <- build_url(url)

geometrijam <- read_sf(request)
geometrijam


library(gdalUtilities)


# download
base_url <- "https://lvmgeoserver.lvm.lv/geoserver/zmni/ows?"
type_name <- "zmni:zmni_zmniregion"
crs_code <- 3059
chunk_size <- 100000
gpkg_path <- "./Geodata/2024/MKIS/temp_MKIS_2025.gpkg"
layer_name <- "temp_ZMNIRegions"
i <- 0

repeat {
  message("Fetching features ", i * chunk_size + 1, " to ", (i + 1) * chunk_size, "...")
  
  query <- list(
    service = "WFS",
    version = "2.0.0",
    request = "GetFeature",
    typename = type_name,
    srsName = paste0("EPSG:", crs_code),
    count = chunk_size,
    startIndex = i * chunk_size
  )
  
  req_url <- modify_url(base_url, query = query)
  
  try({
    chunk <- read_sf(req_url)
    if (nrow(chunk) == 0) break
    
    # Set CRS and cast to MULTILINESTRING, POINT, MULTIPOLYGON
    chunk <- chunk %>%
      st_set_crs(st_crs(crs_code))
    
    ensure_multipolygons <- function(X) {
      tmp1 <- tempfile(fileext = ".gpkg")
      tmp2 <- tempfile(fileext = ".gpkg")
      st_write(X, tmp1)
      ogr2ogr(tmp1, tmp2, f = "GPKG", nlt = "MULTIPOLYGON")
      Y <- st_read(tmp2)
      st_sf(st_drop_geometry(X), geom = st_geometry(Y))
    }
    chunk <- ensure_multipolygons(chunk)
    
    
    # Write chunk to GeoPackage (append mode after first)
    st_write(
      chunk, 
      dsn = gpkg_path,
      layer = layer_name,
      append = i != 0,
      quiet = FALSE
    )
    
    i <- i + 1
  }, silent = TRUE)
  Sys.sleep(0.5)
}

message("All chunks written to ", gpkg_path, " in layer ", layer_name)


ZMNIRegions_all=st_read("./Geodata/2024/MKIS/temp_MKIS_2025.gpkg",
                        layer="temp_ZMNIRegions")
ZMNIRegions_all2 = ZMNIRegions_all[!st_is_empty(ZMNIRegions_all),,drop=FALSE] # 0
table(st_is_valid(ZMNIRegions_all2))


write_sf(ZMNIRegions_all2,
         "./Geodata/2024/MKIS/MKIS_2025.gpkg",
         layer="ZMNIRegions",
         append=FALSE)
rm(list=ls())




# water drenage ditches -----


link="https://lvmgeoserver.lvm.lv/geoserver/zmni/ows?"
url=parse_url(link)

url$query <- list(service = "wfs",request = "GetCapabilities")
request <- build_url(url)
bwk_client <- WFSClient$new(link,serviceVersion = "2.0.0")

bwk_client$getFeatureTypes(pretty = TRUE)

# geoms

url$query <- list(service = "wfs",
                  request = "GetFeature",
                  srsName="EPSG:3059",
                  typename = "zmni:zmni_waterdrainditches",
                  count=100)
request <- build_url(url)

geometrijam <- read_sf(request)
geometrijam



# download
base_url <- "https://lvmgeoserver.lvm.lv/geoserver/zmni/ows?"
type_name <- "zmni:zmni_waterdrainditches"
crs_code <- 3059
chunk_size <- 100000
gpkg_path <- "./Geodata/2024/MKIS/temp_MKIS_2025.gpkg"
layer_name <- "temp_UdensnotekasNovadgravji"
i <- 0

repeat {
  message("Fetching features ", i * chunk_size + 1, " to ", (i + 1) * chunk_size, "...")
  
  query <- list(
    service = "WFS",
    version = "2.0.0",
    request = "GetFeature",
    typename = type_name,
    srsName = paste0("EPSG:", crs_code),
    count = chunk_size,
    startIndex = i * chunk_size
  )
  
  req_url <- modify_url(base_url, query = query)
  
  try({
    chunk <- read_sf(req_url)
    if (nrow(chunk) == 0) break
    
    # Set CRS and cast to MULTILINESTRING, POINT, MULTIPOLYGON
    chunk <- chunk %>%
      st_set_crs(st_crs(crs_code))
    
    chunk=st_cast(chunk,"MULTILINESTRING")
    
    # Write chunk to GeoPackage (append mode after first)
    st_write(
      chunk, 
      dsn = gpkg_path,
      layer = layer_name,
      append = i != 0,
      quiet = FALSE
    )
    
    i <- i + 1
  }, silent = TRUE)
  Sys.sleep(0.5)
}

message("All chunks written to ", gpkg_path, " in layer ", layer_name)


UdensnotekasNovadgravji_all=st_read("./Geodata/2024/MKIS/temp_MKIS_2025.gpkg",
                                    layer="temp_UdensnotekasNovadgravji")
UdensnotekasNovadgravji_all2 = UdensnotekasNovadgravji_all[!st_is_empty(UdensnotekasNovadgravji_all),,drop=FALSE] # 0
table(st_is_valid(UdensnotekasNovadgravji_all2))


write_sf(UdensnotekasNovadgravji_all2,
         "./Geodata/2024/MKIS/MKIS_2025.gpkg",
         layer="UdensnotekasNovadgravji",
         append=FALSE)
rm(list=ls())




# ditch pickets ----



link="https://lvmgeoserver.lvm.lv/geoserver/zmni/ows?"
url=parse_url(link)

url$query <- list(service = "wfs",request = "GetCapabilities")
request <- build_url(url)
bwk_client <- WFSClient$new(link,serviceVersion = "2.0.0")

bwk_client$getFeatureTypes(pretty = TRUE)

# geoms

url$query <- list(service = "wfs",
                  request = "GetFeature",
                  srsName="EPSG:3059",
                  typename = "zmni:zmni_ditchpicket",
                  count=100)
request <- build_url(url)

geometrijam <- read_sf(request)
geometrijam



# download
base_url <- "https://lvmgeoserver.lvm.lv/geoserver/zmni/ows?"
type_name <- "zmni:zmni_ditchpicket"
crs_code <- 3059
chunk_size <- 100000
gpkg_path <- "./Geodata/2024/MKIS/temp_MKIS_2025.gpkg"
layer_name <- "temp_UdensnotekuNovadgravjuPiketi"
i <- 0

repeat {
  message("Fetching features ", i * chunk_size + 1, " to ", (i + 1) * chunk_size, "...")
  
  query <- list(
    service = "WFS",
    version = "2.0.0",
    request = "GetFeature",
    typename = type_name,
    srsName = paste0("EPSG:", crs_code),
    count = chunk_size,
    startIndex = i * chunk_size
  )
  
  req_url <- modify_url(base_url, query = query)
  
  try({
    chunk <- read_sf(req_url)
    if (nrow(chunk) == 0) break
    
    # Set CRS and cast to MULTILINESTRING, POINT, MULTIPOLYGON
    chunk <- chunk %>%
      st_set_crs(st_crs(crs_code)) %>%
      st_cast("POINT")
    
    # Write chunk to GeoPackage (append mode after first)
    st_write(
      chunk, 
      dsn = gpkg_path,
      layer = layer_name,
      append = i != 0,
      quiet = FALSE
    )
    
    i <- i + 1
  }, silent = TRUE)
}

message("All chunks written to ", gpkg_path, " in layer ", layer_name)

UdensnotekuNovadgravjuPiketi_all=st_read("./Geodata/2024/MKIS/temp_MKIS_2025.gpkg",
                                         layer="temp_UdensnotekuNovadgravjuPiketi")
UdensnotekuNovadgravjuPiketi_all2 = UdensnotekuNovadgravjuPiketi_all[!st_is_empty(UdensnotekuNovadgravjuPiketi_all),,drop=FALSE] # 0
table(st_is_valid(UdensnotekuNovadgravjuPiketi_all2))


write_sf(UdensnotekuNovadgravjuPiketi_all2,
         "./Geodata/2024/MKIS/MKIS_2025.gpkg",
         layer="UdensnotekuNovadgravjuPiketi",
         append=FALSE)
rm(list=ls())



# state river axis ----


link="https://lvmgeoserver.lvm.lv/geoserver/zmni/ows?"
url=parse_url(link)

url$query <- list(service = "wfs",request = "GetCapabilities")
request <- build_url(url)
bwk_client <- WFSClient$new(link,serviceVersion = "2.0.0")

bwk_client$getFeatureTypes(pretty = TRUE)

# geoms

url$query <- list(service = "wfs",
                  request = "GetFeature",
                  srsName="EPSG:3059",
                  typename = "zmni:zmni_stateriversline",
                  count=100)
request <- build_url(url)

geometrijam <- read_sf(request)
geometrijam



# download
base_url <- "https://lvmgeoserver.lvm.lv/geoserver/zmni/ows?"
type_name <- "zmni:zmni_stateriversline"
crs_code <- 3059
chunk_size <- 100000
gpkg_path <- "./Geodata/2024/MKIS/temp_MKIS_2025.gpkg"
layer_name <- "temp_UdenstecuAsis"
i <- 0

repeat {
  message("Fetching features ", i * chunk_size + 1, " to ", (i + 1) * chunk_size, "...")
  
  query <- list(
    service = "WFS",
    version = "2.0.0",
    request = "GetFeature",
    typename = type_name,
    srsName = paste0("EPSG:", crs_code),
    count = chunk_size,
    startIndex = i * chunk_size
  )
  
  req_url <- modify_url(base_url, query = query)
  
  try({
    chunk <- read_sf(req_url)
    if (nrow(chunk) == 0) break
    
    # Set CRS and cast to MULTILINESTRING, POINT, MULTIPOLYGON
    chunk <- chunk %>%
      st_set_crs(st_crs(crs_code))
    
    chunk=st_cast(chunk,"MULTILINESTRING")
    
    # Write chunk to GeoPackage (append mode after first)
    st_write(
      chunk, 
      dsn = gpkg_path,
      layer = layer_name,
      append = i != 0,
      quiet = FALSE
    )
    
    i <- i + 1
  }, silent = TRUE)
  Sys.sleep(0.5)
}

message("All chunks written to ", gpkg_path, " in layer ", layer_name)


UdenstecuAsis_all=st_read("./Geodata/2024/MKIS/temp_MKIS_2025.gpkg",
                          layer="temp_UdenstecuAsis")
UdenstecuAsis_all2 = UdenstecuAsis_all[!st_is_empty(UdenstecuAsis_all),,drop=FALSE] # 0
table(st_is_valid(UdenstecuAsis_all2))


write_sf(UdenstecuAsis_all2,
         "./Geodata/2024/MKIS/MKIS_2025.gpkg",
         layer="UdenstecuAsis",
         append=FALSE)
rm(list=ls())



# river surface ----


link="https://lvmgeoserver.lvm.lv/geoserver/zmni/ows?"
url=parse_url(link)

url$query <- list(service = "wfs",request = "GetCapabilities")
request <- build_url(url)
bwk_client <- WFSClient$new(link,serviceVersion = "2.0.0")

bwk_client$getFeatureTypes(pretty = TRUE)

# geoms

url$query <- list(service = "wfs",
                  request = "GetFeature",
                  srsName="EPSG:3059",
                  typename = "zmni:zmni_stateriverspolygon",
                  count=100)
request <- build_url(url)

geometrijam <- read_sf(request)
geometrijam


# download
base_url <- "https://lvmgeoserver.lvm.lv/geoserver/zmni/ows?"
type_name <- "zmni:zmni_stateriverspolygon"
crs_code <- 3059
chunk_size <- 100000
gpkg_path <- "./Geodata/2024/MKIS/temp_MKIS_2025.gpkg"
layer_name <- "temp_UdenstecuVirsmasLaukumi"
i <- 0

repeat {
  message("Fetching features ", i * chunk_size + 1, " to ", (i + 1) * chunk_size, "...")
  
  query <- list(
    service = "WFS",
    version = "2.0.0",
    request = "GetFeature",
    typename = type_name,
    srsName = paste0("EPSG:", crs_code),
    count = chunk_size,
    startIndex = i * chunk_size
  )
  
  req_url <- modify_url(base_url, query = query)
  
  try({
    chunk <- read_sf(req_url)
    if (nrow(chunk) == 0) break
    
    # Set CRS and cast to MULTILINESTRING, POINT, MULTIPOLYGON
    chunk <- chunk %>%
      st_set_crs(st_crs(crs_code))
    
    ensure_multipolygons <- function(X) {
      tmp1 <- tempfile(fileext = ".gpkg")
      tmp2 <- tempfile(fileext = ".gpkg")
      st_write(X, tmp1)
      ogr2ogr(tmp1, tmp2, f = "GPKG", nlt = "MULTIPOLYGON")
      Y <- st_read(tmp2)
      st_sf(st_drop_geometry(X), geom = st_geometry(Y))
    }
    chunk <- ensure_multipolygons(chunk)
    
    
    # Write chunk to GeoPackage (append mode after first)
    st_write(
      chunk, 
      dsn = gpkg_path,
      layer = layer_name,
      append = i != 0,
      quiet = FALSE
    )
    
    i <- i + 1
  }, silent = TRUE)
  Sys.sleep(0.5)
}

message("All chunks written to ", gpkg_path, " in layer ", layer_name)


UdenstecuVirsmasLaukumi_all=st_read("./Geodata/2024/MKIS/temp_MKIS_2025.gpkg",
                                    layer="temp_UdenstecuVirsmasLaukumi")
UdenstecuVirsmasLaukumi_all2 = UdenstecuVirsmasLaukumi_all[!st_is_empty(UdenstecuVirsmasLaukumi_all),,drop=FALSE] # 0
table(st_is_valid(UdenstecuVirsmasLaukumi_all2))

UdenstecuVirsmasLaukumi_all3=st_make_valid(UdenstecuVirsmasLaukumi_all2)
table(st_is_valid(UdenstecuVirsmasLaukumi_all3))

write_sf(UdenstecuVirsmasLaukumi_all3,
         "./Geodata/2024/MKIS/MKIS_2025.gpkg",
         layer="UdenstecuVirsmasLaukumi",
         append=FALSE)
rm(list=ls())
```


## Topographic Map {#Ch04.04}

To support research process at the University of Latvia, the third (completed 
by January 1, 2018) and fourth (unfinished) versions of the Latvian Geospatial 
Information Agency's topographic map M:10000 vector geodatabase were received. 
The most recent version is available for [public viewing](https://kartes.lgia.gov.lv/karte/?x=311986.74&y=506887.35&zoom=3&basemap=topokarte), 
but access to the vector data is restricted.

For the purposes of this project, the ESRI geodatabase has been converted to a 
GeoPackage file. As part of the file format change, geometries (empty, their 
validity checked and corrected where necessary) and coordinate system have 
been checked.

Files were stored at `Geodata/2024/TopographicMap/`.

After processing each database separately, we combined the layers used in this 
project, selecting the most recent layer per map sheet. These layers are:

- `brigde_L`, describing bridges as lines;

- `bridge_P`, describing bridges as points;

- `hidro_A`, describing waterbodies as polygons;

- `hidro_L`, describing ditches and small rivers as lines;

- `landus_A`, describing LULC as polygons;

- `road_A`, describing larger roads as polygons;

- `road_L`, including very small or disused ones, as lines;

- `swamp_A`, describing bogs as polygons;

- `flora_L`, describing linear tree and shrub formations;

- `build_A`, describing types of built-up areas. Version 4 available at the 
University of Latvia does not include all the classes present in Version 3, 
therefore version 3 is used.


``` r
# libs ----
if(!require(sf)) {install.packages("sf"); require(sf)}
if(!require(openxlsx)) {install.packages("openxlsx"); require(openxlsx)}
if(!require(tidyverse)) {install.packages("tidyverse"); require(tidyverse)}

# v4 ----
slani_v4=st_layers("./Geodata/2024/TopographicMap/Latvija_LKS92_v4_20250703.gdb/")
write.xlsx(slani_v4,"./Geodata/2024/TopographicMap/slani_v4partial.xlsx")

slani_v4$geometrijai=as.character(slani_v4$geomtype)
table(slani_v4$geometrijai)

slani_v4$geometrijai2=ifelse(slani_v4$geometrijai=="3D Point","POINT",
                                   ifelse(slani_v4$geometrijai=="Multi Polygon","MULTIPOLYGON",
                                          ifelse(slani_v4$geometrijai=="3D Multi Line String","MULTILINESTRING",
                                                 ifelse(slani_v4$geometrijai=="3D Multi Polygon","MULTIPOLYGON",NA))))

slani4x=data.frame(name=slani_v4$name,
                   geometrija=slani_v4$geometrijai2)

ciklam4x=levels(factor(slani4x$name))
for(i in seq_along(ciklam4x)){
  print(i)
  sakums=Sys.time()
  nosaukums=ciklam4x[i]
  objekts=slani4x %>% 
    filter(name==nosaukums)
  print(nosaukums)
  slanis=read_sf("./Geodata/2024/TopographicMap/topo10v4/Latvija_LKS92_v4_20250703.gdb/",layer=nosaukums)
  slanisZM=st_zm(slanis)
  slanis2=st_cast(slanisZM,to=objekts$geometrija)
  write_sf(slanis2,"./Geodata/2024/TopographicMap/LGIAtopo10K_v4partial.gpkg",layer=nosaukums,append=FALSE)
  ilgums=Sys.time()-sakums
  print(ilgums)
}



# v3 ----
slani_v3=st_layers("./Geodata/2024/TopographicMap/Latvija_LKS92_v3_pilnais.gdb/")
write.xlsx(slani_v3,"./Geodata/2024/TopographicMap/slani_v3.xlsx")

slani_v3$geometrijai=as.character(slani_v3$geomtype)
table(slani_v3$geometrijai)

slani_v3$geometrijai2=ifelse(slani_v3$geometrijai=="3D Point","POINT",
                                   ifelse(slani_v3$geometrijai=="Multi Polygon","MULTIPOLYGON",
                                          ifelse(slani_v3$geometrijai=="3D Multi Line String","MULTILINESTRING",
                                                 ifelse(slani_v3$geometrijai=="3D Multi Polygon","MULTIPOLYGON",
                                                        ifelse(slani_v3$geometrijai=="Point","POINT",
                                                               ifelse(slani_v3$geometrijai=="Multi Line String","MULTILINESTRING",
                                                                      ifelse(slani_v3$geometrijai=="3D Measured Point","POINT",NA)))))))

slani3x=data.frame(name=slani_v3$name,
                   geometrija=slani_v3$geometrijai2)

ciklam3x=levels(factor(slani3x$name))
for(i in seq_along(ciklam3x)){
  print(i)
  sakums=Sys.time()
  nosaukums=ciklam3x[i]
  objekts=slani3x %>% 
    filter(name==nosaukums)
  print(nosaukums)
  slanis=read_sf("./Geodata/2024/TopographicMap/Latvija_LKS92_v3_pilnais.gdb/",layer=nosaukums)
  slanisZM=st_zm(slanis)
  slanis2=st_cast(slanisZM,to=objekts$geometrija)
  write_sf(slanis2,"./Geodata/2024/TopographicMap/LGIAtopo10K_v3.gpkg",layer=nosaukums,append=FALSE)
  ilgums=Sys.time()-sakums
  print(ilgums)
}


# combination ----
st_layers("./Geodata/2024/TopographicMap/LGIAtopo10K_v3.gpkg")

pages4=st_read("./Geodata/2024/TopographicMap/LGIAtopo10K_v4partial.gpkg",layer="Topo10_lapas")
pages4_united=st_union(pages4)
ggplot(pages4_united)+geom_sf()

# landus_A
landus_3=st_read("./Geodata/2024/TopographicMap/LGIAtopo10K_v3.gpkg",layer="landus_A")
landus_not4=st_difference(landus_3,pages4_united)
landus_not4=landus_not4 %>% 
  dplyr::select(FNAME,FCODE)
landus_4=st_read("./Geodata/2024/TopographicMap/LGIAtopo10K_v4partial.gpkg",layer="landus_A")
landus_4=landus_4 %>% 
  dplyr::select(FNAME,FCODE)

landus_new=rbind(landus_not4,landus_4)
sfarrow::st_write_parquet(landus_new,"./Geodata/2024/TopographicMap/LandusA_COMB.parquet")

# bridge_L
data_3=st_read("./Geodata/2024/TopographicMap/LGIAtopo10K_v3.gpkg",layer="bridge_L")
data_not4=st_difference(data_3,pages4_united)
data_not4=data_not4 %>% 
  dplyr::select(FNAME,FCODE)
data_4=st_read("./Geodata/2024/TopographicMap/LGIAtopo10K_v4partial.gpkg",layer="bridge_L")
data_4=data_4 %>% 
  dplyr::select(FNAME,FCODE)

data_new=rbind(data_not4,data_4)
sfarrow::st_write_parquet(data_new,"./Geodata/2024/TopographicMap/BridgeL_COMB.parquet")

# bridge_P
data_3=st_read("./Geodata/2024/TopographicMap/LGIAtopo10K_v3.gpkg",layer="bridge_P")
data_not4=st_difference(data_3,pages4_united)
data_not4=data_not4 %>% 
  dplyr::select(FNAME,FCODE)
data_4=st_read("./Geodata/2024/TopographicMap/LGIAtopo10K_v4partial.gpkg",layer="bridge_P")
data_4=data_4 %>% 
  dplyr::select(FNAME,FCODE)

data_new=rbind(data_not4,data_4)
sfarrow::st_write_parquet(data_new,"./Geodata/2024/TopographicMap/BridgeP_COMB.parquet")

# hidro_A
data_3=st_read("./Geodata/2024/TopographicMap/LGIAtopo10K_v3.gpkg",layer="hidro_A")
data_not4=st_difference(data_3,pages4_united)
data_not4=data_not4 %>% 
  dplyr::select(FNAME,FCODE)
data_4=st_read("./Geodata/2024/TopographicMap/LGIAtopo10K_v4partial.gpkg",layer="hidro_A")
data_4=data_4 %>% 
  dplyr::select(FNAME,FCODE)

data_new=rbind(data_not4,data_4)
sfarrow::st_write_parquet(data_new,"./Geodata/2024/TopographicMap/HidroA_COMB.parquet")

# hidro_L
data_3=st_read("./Geodata/2024/TopographicMap/LGIAtopo10K_v3.gpkg",layer="hidro_L")
data_not4=st_difference(data_3,pages4_united)
data_not4=data_not4 %>% 
  dplyr::select(FNAME,FCODE)
data_4=st_read("./Geodata/2024/TopographicMap/LGIAtopo10K_v4partial.gpkg",layer="hidro_L")
data_4=data_4 %>% 
  dplyr::select(FNAME,FCODE)

data_new=rbind(data_not4,data_4)
sfarrow::st_write_parquet(data_new,"./Geodata/2024/TopographicMap/HidroL_COMB.parquet")


# road_A
data_3=st_read("./Geodata/2024/TopographicMap/LGIAtopo10K_v3.gpkg",layer="road_A")
data_not4=st_difference(data_3,pages4_united)
data_not4=data_not4 %>% 
  dplyr::select(FNAME,FCODE)
data_4=st_read("./Geodata/2024/TopographicMap/LGIAtopo10K_v4partial.gpkg",layer="road_A")
data_4=data_4 %>% 
  dplyr::select(FNAME,FCODE)

data_new=rbind(data_not4,data_4)
sfarrow::st_write_parquet(data_new,"./Geodata/2024/TopographicMap/RoadA_COMB.parquet")



# road_L
data_3=st_read("./Geodata/2024/TopographicMap/LGIAtopo10K_v3.gpkg",layer="road_L")
data_not4=st_difference(data_3,pages4_united)
data_not4=data_not4 %>% 
  dplyr::select(FNAME,FCODE)
data_4=st_read("./Geodata/2024/TopographicMap/LGIAtopo10K_v4partial.gpkg",layer="road_L")
data_4=data_4 %>% 
  dplyr::select(FNAME,FCODE)

data_new=rbind(data_not4,data_4)
sfarrow::st_write_parquet(data_new,"./Geodata/2024/TopographicMap/RoadL_COMB.parquet")



# swamp_A
data_3=st_read("./Geodata/2024/TopographicMap/LGIAtopo10K_v3.gpkg",layer="swamp_A")
data_not4=st_difference(data_3,pages4_united)
data_not4=data_not4 %>% 
  dplyr::select(FNAME,FCODE)
data_4=st_read("./Geodata/2024/TopographicMap/LGIAtopo10K_v4partial.gpkg",layer="swamp_A")
data_4=data_4 %>% 
  dplyr::select(FNAME,FCODE)

data_new=rbind(data_not4,data_4)
sfarrow::st_write_parquet(data_new,"./Geodata/2024/TopographicMap/SwampA_COMB.parquet")



# flora_L
data_3=st_read("./Geodata/2024/TopographicMap/LGIAtopo10K_v3.gpkg",layer="flora_L")
data_not4=st_difference(data_3,pages4_united)
data_not4=data_not4 %>% 
  dplyr::select(FNAME,FCODE)
data_4=st_read("./Geodata/2024/TopographicMap/LGIAtopo10K_v4partial.gpkg",layer="flora_L")
data_4=data_4 %>% 
  dplyr::select(FNAME,FCODE)

data_new=rbind(data_not4,data_4)
sfarrow::st_write_parquet(data_new,"./Geodata/2024/TopographicMap/FloraL_COMB.parquet")


# build_A
data_3=st_read("./Geodata/2024/TopographicMap/LGIAtopo10K_v3.gpkg",layer="build_A")
data_3=data_3 %>% 
  dplyr::select(FNAME,FCODE)
sfarrow::st_write_parquet(data_3,"./Geodata/2024/TopographicMap/BuildA_v3.parquet")
```



## Corine Land Cover 2018 {#Ch04.05}

Corine Land Cover is publicly available geodata that characterizes land cover 
and land use (LULC) across Europe over a long period of time using a generally 
consistent (comparable) methodology (https://land.copernicus.eu/content/corine-land -cover-nomenclature-guidelines/docs/pdf/CLC2018_Nomenclature_illustrated_guide_20190510.pdf), 
providing results for individual years - 1990, 2000, 2006, 2012, 
2018 (https://land.copernicus.eu/en/products/corine-land-cover). 
Although the dataset has a coarse resolution – the mapping unit is 25 ha areas 
that are at least 100 m wide – it provides sufficient information for general 
use, such as workflow testing and observation filtering. This project uses 
data from 2018.

The downloaded data set has been transformed into the Latvian coordinate 
system (EPSG:3059), and the file format has been changed to GeoParquet to 
facilitate and speed up further work. As part of the file format change, 
geometries (empty, validity) have been checked.

Data are stored at `Geodata/2024/CLC/`.


``` r
# libs ----
if(!require(sf)) {install.packages("sf"); require(sf)}
if(!require(arrow)) {install.packages("arrow"); require(arrow)}
if(!require(sfarrow)) {install.packages("sfarrow"); require(sfarrow)}

# downloaded data
clcLV=st_read("./Geodata/2024/CLC/clcLV.gpkg",layer="clcLV")

# empty geoms
clcLV2 = clcLV[!st_is_empty(clcLV),,drop=FALSE] # OK

# validation
validity=st_is_valid(clcLV2) 
table(validity) # 3 non-valid
clcLV3=st_make_valid(clcLV2)

# crs
clcLV3=st_transform(clcLV3,crs=3059)

# saving
sfarrow::st_write_parquet(clcLV3, "./Geodata/2024/CLC/CLC_LV_2018.parquet")
```



## Publicly available LVM data {#Ch04.06}

[Latvian State Forests geospatial data on forest infrastructure and its description](https://data.gov.lv/dati/lv/dataset/as-latvijas-valsts-mezi-mezsaimniecibas-infrastruktura). The 
following data sets were used in the project:
- roads:
    - forest roads;
    - forest roads to be developed;
    - turning areas;
    - changeover areas;
    - driveways;
- drainage systems:
    - ditches;
    - drainage systems;
    - renovated drainage facilities.
Initially, no additional processing of this data was performed. It was used to 
prepare [geodata products](#Ch05) (more specifically, [Landscape classification](#Ch05.03)).

Data were downloaded to `Geodata/2024/LVM_OpenData`

## Soil data {#Ch04.07}

Directory `Geodata/2024/Soils/` contains various soil related datasets that need 
to be combined (soil texture) or can be used individually (soil chemistry). These 
datasets and their location in the filetree are documented in following subchapters.

### Soil chemistry {#Ch04.07.01}

Data on soil chemistry are obtained from [European Soil Data Centre's](https://esdac.jrc.ec.europa.eu/) European 
Soil database [@esdac2]. Dataset decribing soil chemistry is derived from [LUCAS 
2009/2012 topsoil data](https://esdac.jrc.ec.europa.eu/content/chemical-properties-european-scale-based-lucas-topsoil-data). There are several chemical properties available with 
download, however not all of them are experts chosen for SDM, therefore not used 
further in this work:

- "P": used;

- "N": used;

- "K": used;

- "CEC": not used;

- "CN": used;

- "pH_CaCl": not used;

- "ph_H2o_ration_ph_CaCl": not used;

- "pH_H2O": used;

- "CaCO3": used.

Files were downloaded to `Geodata/2024/Soils/ESDAC/chemistry/` and no preprocessing 
was carried out.

### Soil texture: Europe {#Ch04.07.02}

Data on soil texture are obtained from [European Soil Data Centre's](https://esdac.jrc.ec.europa.eu/) European 
Soil database [@esdac2]. Dataset is available as [European Soil Database v2 Raster Library 1kmx1km](https://esdac.jrc.ec.europa.eu/content/european-soil-database-v2-raster-library-1kmx1km). There 
are several properties available with download, `TXT` was used to 
create [soil texture product](#Ch05.02). Files were downloaded to `eodata/2024/Soils/ESDAC/texture/`. 

During the preprocessing (code below) layer was 
projected to match 10 m template with "near" as interpolation method, value `0` 
substituted with `NA` and masked and cropped to template. Result was saved for further 
processing.


``` r
# libs ----
if(!require(terra)) {install.packages("terra"); require(terra)}
if(!require(sf)) {install.packages("sf"); require(sf)}
if(!require(tidyverse)) {install.packages("tidyverse"); require(tidyverse)}

# Template ----
template10=rast("./Templates/TemplateRasters/LV10m_10km.tif")

# ESDAC texture ----

sdTEXT=rast("./Geodata/2024/Soils/ESDAC/texture/SoilDatabaseV2_raster/ESDB-Raster-Library-1k-GeoTIFF-20240507/TEXT/TEXT.tif")
plot(sdTEXT)

sdTEXT=project(sdTEXT,template10,method="near")
plot(sdTEXT)

sdTEXT=subst(sdTEXT,0,NA)
plot(sdTEXT)

sdTEXT2=mask(sdTEXT,template10,
             filename="./RasterGrids_10m/2024/SoilTXT_ESDAC.tif",
             overwrite=TRUE)
plot(sdTEXT2)
```



### Soil texture: Farmland {#Ch04.07.03}

Topsoil characteristics in Latvia were mapped in the mid-20th century, almost 
exclusively in farmlands. With time, data were digitised and combined with some 
other information creating artefacts. Therefore preprocessing was necessary. The 
version we used was obtained form project "GOODWATER" C1D1_Deliverable_R2.

File is stored at `Geodata/2024/Soils/TopSoil_LV/`.

Preprocessing included:

- reclassification:

    - we coded as `clay` (3) following labels from field `GrSast` - "M","M1","Mp","M2","sM1","sMp1";
    
    - we coded as `silt` (2) following labels from field `GrSast` - "sM", "sMp", "M2", "sM2", "sMp2", "sM3", "sMp3";

    - we coded as `sand` (1) following labels from field `GrSast` - "mS", "mSp", "S", "sS", "iS", "Gr", "mGr", "D";
    
    - we coded as `organic` (4) following labels from field `GrSast` - "l", "vd", "vj", "n","T";
    
    - left others as unclassified.
    
- coordinate transformation to epsg:3059;

- invsestigated resulting layer looking for anomalies by scrolling in interactive 
GIS. Investigations led to exclusion of land parcels from 200 ha.

- rasterization to 10 m template with highest class code prevailing.



``` r
# libs ----
if(!require(terra)) {install.packages("terra"); require(terra)}
if(!require(sf)) {install.packages("sf"); require(sf)}
if(!require(tidyverse)) {install.packages("tidyverse"); require(tidyverse)}

# Template ----
template10=rast("./Templates/TemplateRasters/LV10m_10km.tif")

# Farmland soil texture ----

augsnes=st_read("./Geodata/2024/Soils/TopSoil_LV/soil.gpkg",layer="soilunion")

# calculate parcels area
augsnes$platiba_ha=as.numeric(st_area(augsnes))/10000

# only parcels with existing information on texture
tuksas=augsnes %>% 
  filter(GrSast=="")

# classification
clay=c("M","M1","Mp","M2","sM1","sMp1")
silt=c("sM", "sMp", "M2", "sM2", "sMp2", "sM3", "sMp3")
sand=c("mS", "mSp", "S", "sS", "iS", "Gr", "mGr", "D")
peat=c("l", "vd", "vj", "n","T")
augsnes=augsnes %>% 
  mutate(grupas=case_when(GrSast %in% sand~"Sand",
                          GrSast %in% silt~"Silt",
                          GrSast %in% clay~"Clay",
                          GrSast %in% peat~"organika",
                          .default=NA)) %>% 
  mutate(grupas_num=case_when(GrSast %in% sand~"1",
                              GrSast %in% silt~"2",
                              GrSast %in% clay~"3",
                              GrSast %in% peat~"4",
                              .default=NA))

# crs
augsnes_3059=st_transform(augsnes,crs=3059)

# only existing texture classification
augsnes_3059=augsnes_3059 %>% 
  filter(!is.na(grupas_num))

# parcels up to 200 ha
augsnes_3059small=augsnes_3059 %>% 
  filter(!is.na(grupas_num)) %>% 
  filter(platiba_ha<200)

# rasterization
virsaugsnem2=rasterize(augsnes_3059small,template10,field="grupas_num",fun="max",
                       filename="./RasterGrids_10m/2024/SoilTXT_topSoilLV.tif",
                       overwrite=TRUE)
plot(virsaugsnem2)
```


### Soil texture: Quaternary {#Ch04.07.04}

Data on Quaternary Geology are digitised and stored by University of Latvia 
Geology group.

File is stored at `Geodata/2024/Soils/QuaternaryGeology_LV/`.

Preprocessing included:

- reclassification:

    - we coded as `sand` (1) following values from field `Litologija` - "smilts", "smilts_aleiritiska", 
    "smilts_dunjaina", "smilts_grants", "smilts_grants_oli", "smilts_grants_oli_aleirits", "smilts_kudraina", 
    "smilts_videjgraudaina, malsmilts", "smilts_videjgraudaina"~"Sand";
    
    - we coded as `silt` (2) following values from field `Litologija` - "aleirits", "aleirits_malains",
    "morena", "smilts_aleirits_mals", "smilts_aleirits_sapropelis", "smilts_malaina_dazadgraudaina, malsmilts";
    
    - we coded as `clay` (3) following values from field `Litologija` - "mals", "mals_aleiritisks";
    
    - we coded as `organic` (4) following values from field `Litologija` - "dunjas", "kudra";

- coordinate transformation to epsg:3059;

- rasterization to 10 m template with highest class code prevailing.



``` r
# libs ----
if(!require(terra)) {install.packages("terra"); require(terra)}
if(!require(sf)) {install.packages("sf"); require(sf)}
if(!require(tidyverse)) {install.packages("tidyverse"); require(tidyverse)}

# Template ----
template10=rast("./Templates/TemplateRasters/LV10m_10km.tif")

# Quarternary geology ----

kvartars=sfarrow::st_read_parquet("./Geodata/2024/Soils/QuaternaryGeology_LV/Kvartargeologija.parquet")

# reclassification
kvartars=kvartars %>% 
  mutate(grupas = case_when(Litologija=="aleirits"~"Silt",
                            Litologija=="aleirits_malains"~"Silt",
                            Litologija=="dunjas"~"organika",
                            Litologija=="kudra"~"organika",
                            Litologija=="mals"~"Clay",
                            Litologija=="mals_aleiritisks"~"Clay",
                            Litologija=="morena"~"Silt",
                            Litologija=="smilts"~"Sand",
                            Litologija=="smilts_aleiritiska"~"Sand",
                            Litologija=="smilts_aleirits_mals"~"Silt",
                            Litologija=="smilts_aleirits_sapropelis"~"Silt",
                            Litologija=="smilts_dunjaina"~"Sand",
                            Litologija=="smilts_grants"~"Sand",
                            Litologija=="smilts_grants_oli"~"Sand",
                            Litologija=="smilts_grants_oli_aleirits"~"Sand",
                            Litologija=="smilts_kudraina"~"Sand",
                            Litologija=="smilts_malaina_dazadgraudaina, malsmilts"~"Silt",
                            Litologija=="smilts_videjgraudaina, malsmilts"~"Sand",
                            Litologija=="smilts_videjgraudaina"~"Sand",
                            .default=NA))
# numeric codes
kvartars=kvartars %>% 
  mutate(grupas_num=case_when(grupas == "Sand" ~"1",
                              grupas == "Silt" ~"2",
                              grupas == "Clay" ~"3",
                              grupas == "organika" ~"4",
                              .default=NA))

# crs transformation
kvartars_3059=st_transform(kvartars,crs=3059)

# nonmissing classes
kvartars_3059=kvartars_3059 %>% 
  filter(!is.na(grupas_num))

# rasterization
apaksaugsnem=rasterize(kvartars_3059,template10,field="grupas_num",fun="max",
                       filename="./RasterGrids_10m/2024/SoilTXT_QuarternaryLV.tif",
                       overwrite=TRUE)
plot(apaksaugsnem)
```



### Organic soils: SILAVA {#Ch04.07.05}

The distribution of organic soils was modelled by EU LIFE Programme project 
"Demonstration of climate change mitigation potential of nutrients rich organic 
soils in Baltic States and Finland" at the scientific institue SILAVA. Results are 
available from their web service: https://silava.forestradar.com/geoserver/silava

Downloaded file was stored at `Geodata/2024/Soils/OrganicSoils_SILAVA/`.

Even tough the layer covers whole of Latvia, it has visible inconsistencies, 
particularly stripes. These were drawn manually (as vector polygons) and masked 
out as a part of preprocessing. 

For further soil texture analysis we saved a GeoTIFF file with only presences.


``` r
# libs ----
if(!require(terra)) {install.packages("terra"); require(terra)}
if(!require(sf)) {install.packages("sf"); require(sf)}
if(!require(tidyverse)) {install.packages("tidyverse"); require(tidyverse)}

# Template ----
template10=rast("./Templates/TemplateRasters/LV10m_10km.tif")

# Organic Soils SILAVA ----

organika_silava=rast("./Geodata/2024/Soils/OrganicSoils_SILAVA/Silava_OrgSoils.tif")
plot(organika_silava)
# visible stripes

# only 40+ cm deep
organika_silava=ifel(organika_silava==2,1,NA)
organika_silavaLV=project(organika_silava,template10)

# stripes drawn manually, rasterization
silavas_telpai=st_read("./Geodata/2024/Soils/OrganicSoils_SILAVA/stripam.gpkg",
                       layer="stripam")
silavas_telpai=st_transform(silavas_telpai,crs=3059)
silavas_telpai$yes=1
SilavasTelpa_10=rasterize(silavas_telpai,template10,field="yes")

# presence-only layer without stripes
silava_BezStripam1=ifel(organika_silavaLV==1&SilavasTelpa_10==1,1,NA)
silava_BezStripam=mask(silava_BezStripam1,template10)
plot(silava_BezStripam)
writeRaster(silava_BezStripam,
            "./RasterGrids_10m/2024/SoilTXT_OrganicSilava.tif",
            overwrite=TRUE)
```


### Organic soils: LU {#Ch04.07.06}

The distribution of organic soils in farmlands was modelled by the University of 
Latvia project "Improvement of sustainable soil resource management in agriculture".

From all the results we used layer `YN_prognozes_smooth.tif` stored 
at `Geodata/2024/Soils/OrganicSoils_LU/`.

Preprocessing consisted of projecting the layer to match 10 m template. Both presences 
and absences were saved for further processing.


``` r
# libs ----
if(!require(terra)) {install.packages("terra"); require(terra)}
if(!require(sf)) {install.packages("sf"); require(sf)}
if(!require(tidyverse)) {install.packages("tidyverse"); require(tidyverse)}

# Template ----
template10=rast("./Templates/TemplateRasters/LV10m_10km.tif")

# Organic Soils LU ----


kudra_norvegi=rast("./Geodata/2024/Soils/OrganicSoils_LU/YN_prognozes_smooth.tif")
kudra_norvLV=project(kudra_norvegi,template10)
plot(kudra_norvLV)

writeRaster(kudra_norvLV,
            "./RasterGrids_10m/2024/SoilTXT_OrganicLU.tif",
            overwrite=TRUE)
```




## Dynamic World data {#Ch04.08}

Dynamic World (DW) is a relatively new Earth observation system product that 
classifies land cover and land use (LULC) into nine categories (0=water, 1=trees, 
2=grass, 3=flooded_vegetation, 4=crops, 5=shrub_and_scrub, 6=built, 7=bare, 
8=snow_and_ice), for each ESA Copernicus Sentinel-2 image with identified 
cloudiness ≤35, allowing for filtering and various aggregations [@DynWorld].

DW input information - raster layer for each season in each year - prepared on 
the Google Earth Engine platform [@GEEpaper] using 
a [replication script](https://code.earthengine.google.com/0f9fd61ee41af11d218ce8692abebe9b). 
To use this script, you need a [GEE account and project](https://console.cloud.google.com/earth-engine/welcome) 
and sufficient space on Google Drive. When executing the command line, a download 
will be offered for a file covering the time period from the value in row 7 to 
the value in row 8 (the file name should be specified in row 32, its 
description in row 33 and the directory on Google Drive in row 31, or 
all of this can be specified by confirming the save). This script is not optimized 
for preparing all seasonal sections for all years, so in order to reproduce or 
expand this study, it is necessary to change it manually.

Downloaded files are to be stored at `Geodata/2024/DynamicWorld/RAW/`.

During download, it can be seen that each layer covering the whole of Latvia is 
divided into several sheets. This is because, in order to ensure a true zero 
class (class "water" rather than background), the layers are encoded as Float 
rather than integers. All of these tiles need to be downloaded, and the following 
R command lines combine them, ensuring that the coordinate system and pixels 
correspond to the reference raster.


``` r
# libs ----
if(!require(terra)) {install.packages("terra"); require(terra)}
if(!require(tidyverse)) {install.packages("tidyverse"); require(tidyverse)}

# 10 m template ----
template10=rast("./Templates/TemplateRasters/LV10m_10km.tif")

# DW export no GEE ----
faili=data.frame(faili=list.files("./Geodata/2024/DynamicWorld/RAW/"))
faili$celi_sakums=paste0("./Geodata/2024/DynamicWorld/RAW/",faili$faili)

# prepping ----
faili=faili %>% 
  separate(faili,into=c("DW","gads","periods","parejais"),sep="_",remove = FALSE) %>% 
  mutate(unikalais=paste0(DW,"_",gads,"_",periods),
         mosaic_name=paste0(unikalais,".tif"),
         masaic_cels=paste0("./Geodata/2024/DynamicWorld/",mosaic_name))

# every layer consists of two tiles
unikalie=levels(factor(faili$unikalais))
min(table(faili$unikalais))
max(table(faili$unikalais))

# job
for(i in seq_along(unikalie)){
  unikalais=faili %>% filter(unikalais==unikalie[i])
  beigu_cels=unique(unikalais$masaic_cels)
  
  print(i)
  
  viens=rast(unikalais$celi_sakums[1])
  divi=rast(unikalais$celi_sakums[2])
  
  viens2=project(viens,template10)
  divi2=project(divi,template10)
  
  mozaika=mosaic(viens2,divi2,fun="first")
  maskets=mask(mozaika,template10,
               filename=beigu_cels,
               overwrite=TRUE)
  
  print(beigu_cels)
}
```


## The Global Forest Watch {#Ch04.09}

The Global Forest Watch (GFW) is a widely known product that describes tree 
canopy cover in 2000, its annual growth from 2001 to 2012, and its annual 
loss from 2001 to the current version, which is updated annually [@theGFW]. The 
data is available both on the [project website](https://data.globalforestwatch.org/documents/941f17325a494ed78c4817f9bb20f33a/explore) 
and on [GEE](https://developers.google.com/earth-engine/datasets/catalog/UMD_hansen_global_forest_change_2024_v1_12), where 
it was developed. This project uses v1.12, in which the last year of tree loss 
dating is 2024, preparing it for download on the GEE platform with 
this [replication script](https://code.earthengine.google.com/4a12b7504ceafe7f422dd7efbe804b67). 
To use this script, you need a [GEE account and project](https://console.cloud.google.com/earth-engine/welcome) 
and sufficient space on Google Drive. When executing the command lines, you will 
be offered to download the file, which you need to save to Google Drive.

After executing the command lines and preparing the results in Google Drive, 
four files are available for download. The location to download them is 
`Geodata/2024/Trees/GFW/RAW/`. After download, these files need to be projected 
to match the reference raster.



``` r
# libs ----
if(!require(terra)) {install.packages("terra"); require(terra)}

# 10 m rastra template ----
template10=rast("./Templates/TemplateRasters/LV10m_10km.tif")

# TreeCoverLoss ----
treecoverloss=rast("./Geodata/2024/Trees/GFW/RAW/TreeCoverLoss_v1_12.tif")

tcl=ifel(treecoverloss<1,NA,treecoverloss)

tcl2=terra::project(tcl,paraugs)
tcl3=mask(tcl2,paraugs,filename="./Geodata/2024/Trees/GFW/TreeCoverLoss_v1_12.tif",overwrite=TRUE)
```


## Palsar {#Ch04.10}

The Palsar Forests resource is based on PALSAR-2 synthetic aperture radar (SAR) 
reflectance classification of forest and non-forest land with a pixel 
resolution of 25 m. Forests are classified as areas of at least 0.5 ha covered 
with trees, where tree cover (at least 5 m high) is at least 10% [@PALSARForest]. 
The data is available at [GEE](https://developers.google.com/earth-engine/datasets/catalog/JAXA_ALOS_PALSAR_YEARLY_FNF4). 
This project uses a 4-class version (1=Dense Forest, 2=Non-dense Forest, 
3=Non-Forest, 4=Water), in which the last tree cover dating year is 2020, 
prepared for download on the GEE platform with this 
[replication script](https://code.earthengine.google.com/3ec78ab057e6c8910cb1546002132b34). 
To use this script, you need a [GEE account and project](https://console.cloud.google.com/earth-engine/welcome) 
and sufficient space on Google Drive. When executing the command lines, you will 
be offered to download the file, which you need to save to Google Drive.

After executing the command lines and preparing the results in Google Drive, 
four files are available for download. The location to download them is 
`Geodata/2024/Trees/Palsar/RAW/`. After download, these files need to be projected 
to match the reference raster and merged. In this resource, trees are coded into 
two groups: 1=Dense Forest and 2=Non-dense Forest, which need to be merged and 
the rest converted to missing values (code below).

Although the data in this resource describes the situation in 2020 rather 
than 2024, it has been used because [The Global Forest Watch data](#Ch04.09) is 
available to describe the disappearance of tree canopy cover, but the appearance 
of canopy cover is not so rapid that there would be significant changes over a 
four-year period.


``` r
# libs ----
if(!require(terra)) {install.packages("terra"); require(terra)}

# 10 m rastra template ----
template10=rast("./Templates/TemplateRasters/LV10m_10km.tif")


# PALSAR Forests ----

fnf1=rast("./Geodata/2024/Trees/Palsar/RAW/ForestNonForest-0000023296-0000023296.tif")
fnf2=rast("./Geodata/2024/Trees/Palsar/RAW/ForestNonForest-0000023296-0000000000.tif")
fnf3=rast("./Geodata/2024/Trees/Palsar/RAW/ForestNonForest-0000000000-0000023296.tif")
fnf4=rast("./Geodata/2024/Trees/Palsar/RAW/ForestNonForest-0000000000-0000000000.tif")

fnf1p=terra::project(fnf1,template10)
fnf2p=terra::project(fnf2,template10)
fnf3p=terra::project(fnf3,template10)
fnf4p=terra::project(fnf4,template10)

fnfA=terra::merge(fnf1p,fnf2p)
fnfB=terra::merge(fnfA,fnf3p)
fnfC=terra::merge(fnfB,fnf4p)
plot(fnfC)

fnf_X=ifel(fnfC<=2&fnfC>=1,1,NA)
plot(fnf_X)

fnf_XX=mask(fnf_X,template10,
            filename="./Geodata/2024/Trees/Palsar/Palsar_Forests.tif",
            overwrite=TRUE)
```



## CHELSA v2.1 {#Ch04.11}

Climatologies at high resolution for the Earth's land surface areas (CHELSA) is 
30 arc second global downscaled climate data set [@CHELSA]. The temperature algorithm 
is based on statistical downscaling of atmospheric temperatures. The precipitation 
algorithm incorporates orographic predictors including wind fields, valley 
exposition, and boundary layer height, with a subsequent bias correction. CHELSA 
climatological data has a similar accuracy as other products for temperature, but 
that its predictions of precipitation patterns are better [@CHELSA]. Data 
(1980-2010 baseline) are freely available for download 
from [homepage](https://chelsa-climate.org/) forwarding 
to download server, providing download links for selected products. There is also technical 
specification available, to decode layer names (https://chelsa-climate.org/wp-admin/download-page/CHELSA_tech_specification_V2.pdf).

The download links we used together with renaming scheme are [available](https://github.com/aavotins/HiQBioDiv_EGVs/blob/main/Data/Geodata/2024/CHELSA/CHELSAdownload_rename.csv) 
with this document. The following command lines perform download, crop to the 
extent of Latvia (using 1 km vector grid) and saves files for further processing 
described with other [EGVs](#Ch06).


``` r
# libs ----
if(!require(terra)) {install.packages("terra"); require(terra)}
if(!require(sf)) {install.packages("sf"); require(sf)}
if(!require(sfarrow)) {install.packages("sfarrow"); require(sfarrow)}
if(!require(tidyverse)) {install.packages("tidyverse"); require(tidyverse)}
if(!require(curl)) {install.packages("curl"); require(curl)}

# templates ----
# 1km grid
tikls1km=sfarrow::st_read_parquet("./Templates/TemplateGrids/tikls1km_sauzeme.parquet")
telpai=tikls1km %>% 
  mutate(yes=1) %>% 
  summarise(yes=max(yes)) %>% 
  st_buffer(.,dist=10000)

# download and crop ----

links_names=read_csv("./Geodata/2024/CHELSA/CHELSAdownload_rename.csv")
links_names=links_names %>% 
  filter(todownload==1)

for(i in seq_along(links_names$localname)){
  print(i)
  sakums=Sys.time()
  links=links_names$weblocation[i]
  saving1="./Geodata/2024/CHELSA/draza.tif"
  saving2=paste0("./Geodata/2024/CHELSA/",links_names$localname[i])
  
  curl_download(url=links,destfile = saving1,quiet = FALSE)
  fails=rast(saving1)
  telpa=st_transform(telpai,crs=st_crs(fails))
  nogriezts=crop(fails,telpa,
                 filename=saving2,
                 overwrite=TRUE)
  unlink(saving1)
  beigas=Sys.time()
  ilgums=beigas-sakums
  print(ilgums)
}
```




## HydroClim data {#Ch04.12}

HydroClim is a near-global freshwater-specific environmental variable dataset, 
created for biodiversity analysis at 1 km resolution [@HydroClim]. Dataset 
contains many different variables along the HydroSHEDS river 
network [@HydroSheds], including upstream climate recalculated from 
worldclim [@worldclim_hijmans]. We downloaded (to `Geodata/2024/HydroClim/`) 
averaged upstream climate from [Zenodo repository](https://zenodo.org/records/5089529) 
(available also from [Dryad](https://datadryad.org/dataset/doi:10.5061/dryad.dv920)) 
and cropped to the extent of Latvia and renamed files for further processing 
with the code below. Renaming scheme is [published with document](https://github.com/aavotins/HiQBioDiv_EGVs/blob/main/Data/Geodata/2024/HydroClim/HydroClim_renaming.csv)


``` r
# libs ----
if(!require(terra)) {install.packages("terra"); require(terra)}
if(!require(sf)) {install.packages("sf"); require(sf)}
if(!require(sfarrow)) {install.packages("sfarrow"); require(sfarrow)}
if(!require(tidyverse)) {install.packages("tidyverse"); require(tidyverse)}

# templates ----
template100=rast("./Templates/TemplateRasters/LV100m_10km.tif")
tikls1km=sfarrow::st_read_parquet("./Templates/TemplateGrids/tikls1km_sauzeme.parquet")

# reading HydroClim ----
videjie=terra::rast("./Geodata/2024/HydroClim/hydroclim_average+sum.nc")

# reading dictionary -----
slanu_nosaukumi=read_csv("./Geodata/2024/HydroClim/HydroClim_renaming.csv")

# cropping ---
tikls1km_reproj=st_transform(tikls1km,crs=st_crs(videjie))
telpai=tikls1km %>% 
  mutate(yes=1) %>% 
  summarise(yes=max(yes)) %>% 
  st_buffer(.,dist=10000) %>% 
  st_transform(.,crs=st_crs(videjie))
videjie=terra::crop(videjie,telpai)

# layer names ----
names(videjie)=slanu_nosaukumi$local_name

# saving files ----
for(i in seq_along(slanu_nosaukumi$local_name)){
  nosaukumam=slanu_nosaukumi$local_name[i]
  writeRaster(videjie[[i]],
              paste0("./Geodata/2024/HydroClim/",nosaukumam),
              overwrite=TRUE)
}
```

The raster dataset contains values only where large enough rivers are detected 
in HydroSHEDS. However, for species distribution modelling in this project 
we need continuously covered raster surfaces. For necessary geoprocessing to create such surfaces, we downloaded also HydroBASINS [@HydroBasins] [dataset](https://www.hydrosheds.org/products/hydrobasins) to `Geodata/2024/HydroClim/`. 
These procedures were EGV-specific and are described with other [EGVs](#Ch06).

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
you need a [GEE account and project](https://console.cloud.google.com/earth-engine/welcome) 
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
located at `Geodata/2024/S2indices/RAW`. The following R commands combine them, 
ensuring the coordinate systems and its naming, and pixels match the reference 
raster, while renaming files to ``EO_[index]-[term: ST or LY][statistic]``.


``` r
# libs ----
if(!require(terra)) {install.packages("terra"); require(terra)}
if(!require(tidyverse)) {install.packages("tidyverse"); require(tidyverse)}


# 10 m raster template ----
template10=rast("./Templates/TemplateRasters/LV10m_10km.tif")

# Fails as exported from GEE ----
faili=data.frame(fails=list.files("./Geodata/2024/S2indices/RAW/",pattern = ".tif"))
faili$celi_sakums=paste0("./Geodata/2024/S2indices/RAW/",faili$fails)


# file names ----
faili=faili %>% 
  separate(fails,into=c("nosaukums","vidus","beigas"),sep="-",remove = FALSE) %>% 
  mutate(mosaic_name=paste0("EO_",nosaukums,"-",beigas,tolower(vidus),".tif"),
         masaic_cels=paste0("./Geodata/2024/S2indices/Mosaics/",mosaic_name))


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
prepared in the University of Latvia project "Improvement of sustainable soil resource management 
in agriculture", was used as the base DEM. The resolution of this DEM is 1 m, 
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


``` r
# libs
if(!require(terra)) {install.packages("terra"); require(terra)}
if(!require(sf)) {install.packages("sf"); require(sf)}

# reference
template10=rast("./Templates/TemplateRasters/LV10m_10km.tif")

# LiDAR DEM 1 m to 10 m 

lapas_1m=data.frame(faili=list.files("./Geodata/2024/DEM/meanDEM_1mOLD/",pattern="*.tif$"))
lapas_1m$numurs=substr(lapas_1m$faili,10,13)
lapas_1m$cels1=paste0("./Geodata/2024/DEM/meanDEM_1mOLD/",lapas_1m$faili)
lapas_1m$cels2=paste0("./Geodata/2024/DEM/meanDEM_10mOLD/",lapas_1m$faili)

kvadrati=st_read(dsn="GIS_Latvija10.2.gdb",layer="tks93_50000")
kvadrati$name=as.character(kvadrati$num50tk)

moz2=rast("./Geodata/2024/DEM/Nartiss_visa_Latvija/dem10_20_kopa.tif")

for(i in 1:length(kvadrati$name)){
  kvadrats=kvadrati[i,]
  nosaukums=kvadrats$name
  telpa=terra::ext(kvadrats)
  
  paraugs=crop(template10,telpa)
  nart=crop(moz2,telpa)
  nart2=project(nart,paraugs,mask=TRUE)
  
  dem1m=lapas_1m[lapas_1m$numurs==kvadrats$name,]
  if(nrow(dem1m)>0){
    sakumcels=dem1m$cels1
    dem=rast(sakumcels)
    reproj=project(dem,paraugs,mask=TRUE,method="bilinear",use_gdal=TRUE)
    videjais <- ifel(is.na(nart2),nart2,ifel(is.na(reproj),nart2,
                                             app(c(nart2,reproj), mean)))
    writeRaster(videjais,overwrite=TRUE,
                filename=paste0("./Geodata/2024/DEM/meanDEM_10m/","vidDEM_",
                                nosaukums,".tif"))
  }
  else{
    writeRaster(nart2,overwrite=TRUE,
                filename=paste0("./Geodata/2024/DEM/meanDEM_10m/","vidDEM_",
                                nosaukums,".tif"))
  }
}

# vrt un mozaic
lapas_10=data.frame(faili=list.files("./Geodata/2024/DEM/meanDEM_10m/",pattern="*.tif$"))
lapas_10$celi1=paste0("./Geodata/2024/DEM/meanDEM_10m/",lapas_10$faili)
mozaikai=vrt(lapas_10$celi1,overwrite=TRUE,
             filename="./Geodata/2024/DEM/vrtDEM_10m.tif")
mozaika=rast("./Geodata/2024/DEM/vrtDEM_10m.tif")
writeRaster(mozaika,"./Geodata/2024/DEM/mozDEM_10m.tif")


## slope
reljefs=rast("./Geodata/2024/DEM/mozDEM_10m.tif")
slipumi=terrain(reljefs, v="slope", neighbors=8, unit="degrees", 
                filename="./Geodata/2024/DEM/Terrain_Slope_10m.tif", overwrite=TRUE)  

## aspect 
reljefs=rast("./Geodata/2024/DEM/mozDEM_10m.tif")
virzieni=terrain(reljefs, v="aspect", neighbors=8, unit="degrees", 
                 filename="./Geodata/2024/DEM/Terrain_Aspect_10m.tif", overwrite=TRUE)
```



## Latvian Exclusive Economic Zone polygon {#Ch04.16}

The waters of Latvia's Exclusive Economic Zone were obtained from 
the [HELCOM map and data service](https://maps.helcom.fi/website/mapservice/?datasetID=ae58c373-674c-45d1-be0f-1ff69a59f9ba). After downloading, this line file was 
analogically connected to the coastline file obtained from the same resource.



## Bogs and Mires: EDI {#Ch04.17}

Data (training and classification) used in project "Remote Sensing and Machine 
Learning for Peatland Habitat Monitoring (PurvEO)" by Institute of electronics 
and computer science are stored at `Geodata/2024/Bogs_EDI`.

Preprocessing combines this information to create two layers:

- `EDI_BogsYN.tif`: training and classification results on open raised bogs (EU 
protected habitat codes 7110 and 7120) and locations where on of those overlaps 
with transitional mires (EU protected habitat code 7140);

- `EDI_TransitionalMiresYN.tif`: training and classification results on 
transitional mires (EU protected habitat code 7140) with no overlap with open 
rised bogs.




``` r
# libs
if(!require(sf)) {install.packages("sf"); require(sf)}
if(!require(tidyverse)) {install.packages("tidyverse"); require(tidyverse)}
if(!require(terra)) {install.packages("terra"); require(terra)}


# Templates ----
template10=rast("./Templates/TemplateRasters/LV10m_10km.tif")
template100=rast("./Templates/TemplateRasters/LV100m_10km.tif")

nulles10=rast("./Templates/TemplateRasters/nulls_LV10m_10km.tif")


# Bogs ----
neatklata71107120=rast("./Geodata/2024/Bogs_EDI/purvi_EDI_projekts/purvi/!LV_kopa_apv1020_30_05_2022/!LV_kopa_apv1020_30_05_2022/Neatklata_purviem_raksturiga_zemsedze_7110_7120.tif")
neatklata71107120=ifel(neatklata71107120>0,1,NA)
plot(neatklata71107120)
neatklata7140=rast("./Geodata/2024/Bogs_EDI/purvi_EDI_projekts/purvi/!LV_kopa_apv1020_30_05_2022/!LV_kopa_apv1020_30_05_2022/Neatklata_purviem_raksturiga_zemsedze_7140.tif")
neatklata7140=ifel(neatklata7140>0,1,NA)

raskturiga71107120=rast("./Geodata/2024/Bogs_EDI/purvi_EDI_projekts/purvi/!LV_kopa_apv1020_30_05_2022/!LV_kopa_apv1020_30_05_2022/Purviem_neraksturiga_zemsedze_7110_7120.tif")
raskturiga71107120=ifel(raskturiga71107120>0,1,NA)
raksturiga7140=rast("./Geodata/2024/Bogs_EDI/purvi_EDI_projekts/purvi/!LV_kopa_apv1020_30_05_2022/!LV_kopa_apv1020_30_05_2022/Purviem_neraksturiga_zemsedze_7140.tif")
raksturiga7140=ifel(raksturiga7140>0,1,NA)

labels71107120=rast("./Geodata/2024/Bogs_EDI/purvi_EDI_projekts/purvi/!LV_kopa_apv1020_30_05_2022/!LV_kopa_apv1020_30_05_2022/latvija_Labels_B7110_7120.tif")
labels71107120=ifel(labels71107120>0,1,NA)
labels7140=rast("./Geodata/2024/Bogs_EDI/purvi_EDI_projekts/purvi/!LV_kopa_apv1020_30_05_2022/!LV_kopa_apv1020_30_05_2022/latvija_Labels_B7140.tif")
labels7140=ifel(labels7140>0,1,NA)

augstie=cover(cover(neatklata71107120,raskturiga71107120),labels71107120)
parejas=cover(cover(neatklata7140,raksturiga7140),labels7140)
tikai_parejas=ifel(parejas==1&augstie==1,NA,parejas)
sunainie=ifel(parejas==1&augstie==1,parejas,NA)

sunu_purvi=cover(augstie,sunainie)

sunu_proj=project(sunu_purvi,template10)
sunuYN=cover(sunu_proj,nulles10)
plot(sunuYN)
writeRaster(sunuYN,
            overwrite=TRUE,
            filename="./RasterGrids_10m/2024/EDI_BogsYN.tif")



# Transitional mires ----
parejas_proj=project(tikai_parejas,template10)
parejasYN=cover(parejas_proj,nulles10)
plot(parejasYN)
writeRaster(parejasYN,
            overwrite=TRUE,
            filename="./RasterGrids_10m/2024/EDI_TransitionalMiresYN.tif")
```


