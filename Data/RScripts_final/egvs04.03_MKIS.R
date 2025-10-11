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


# aizsargdambji ----

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

# dabiskās ūdensteces ----

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



# dambju piketi ----


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


# drenas ----

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




# drenu kolektori ----


bwk_client$getFeatureTypes(pretty = TRUE)

# geometrijam
bwk_client$getFeatureTypes(pretty = TRUE)
url$query <- list(service = "wfs",
                  request = "GetFeature",
                  srsName="EPSG:3059",
                  typename = "zmni:zmni_draincollectors",
                  count=1)
request <- build_url(url)

geometrijam <- read_sf(request)
geometrijam

# skaitam
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


# lejupielādei
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




# drenāžas tīkla būves ----

link="https://lvmgeoserver.lvm.lv/geoserver/zmni/ows?"
url=parse_url(link)

url$query <- list(service = "wfs",request = "GetCapabilities")
request <- build_url(url)
bwk_client <- WFSClient$new(link,serviceVersion = "2.0.0")

bwk_client$getFeatureTypes(pretty = TRUE)

# geometrijam

url$query <- list(service = "wfs",
                  request = "GetFeature",
                  srsName="EPSG:3059",
                  typename = "zmni:zmni_networkstructures",
                  count=1)
request <- build_url(url)

geometrijam <- read_sf(request)
geometrijam



# lejupielādei
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




# grāvji -----


link="https://lvmgeoserver.lvm.lv/geoserver/zmni/ows?"
url=parse_url(link)

url$query <- list(service = "wfs",request = "GetCapabilities")
request <- build_url(url)
bwk_client <- WFSClient$new(link,serviceVersion = "2.0.0")

bwk_client$getFeatureTypes(pretty = TRUE)

# geometrijam

url$query <- list(service = "wfs",
                  request = "GetFeature",
                  srsName="EPSG:3059",
                  typename = "zmni:zmni_ditches",
                  count=100)
request <- build_url(url)

geometrijam <- read_sf(request)
geometrijam



# lejupielādei
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




# hidrometriskie posteņi ----


link="https://lvmgeoserver.lvm.lv/geoserver/zmni/ows?"
url=parse_url(link)

url$query <- list(service = "wfs",request = "GetCapabilities")
request <- build_url(url)
bwk_client <- WFSClient$new(link,serviceVersion = "2.0.0")

bwk_client$getFeatureTypes(pretty = TRUE)

# geometrijam

url$query <- list(service = "wfs",
                  request = "GetFeature",
                  srsName="EPSG:3059",
                  typename = "zmni:zmni_hydropost",
                  count=100)
request <- build_url(url)

geometrijam <- read_sf(request)
geometrijam



# lejupielādei
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


# liela diametra kolektori ----


link="https://lvmgeoserver.lvm.lv/geoserver/zmni/ows?"
url=parse_url(link)

url$query <- list(service = "wfs",request = "GetCapabilities")
request <- build_url(url)
bwk_client <- WFSClient$new(link,serviceVersion = "2.0.0")

bwk_client$getFeatureTypes(pretty = TRUE)

# geometrijam

url$query <- list(service = "wfs",
                  request = "GetFeature",
                  srsName="EPSG:3059",
                  typename = "zmni:zmni_bigdraincollectors",
                  count=100)
request <- build_url(url)

geometrijam <- read_sf(request)
geometrijam



# lejupielādei
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




# piketi ----



link="https://lvmgeoserver.lvm.lv/geoserver/zmni/ows?"
url=parse_url(link)

url$query <- list(service = "wfs",request = "GetCapabilities")
request <- build_url(url)
bwk_client <- WFSClient$new(link,serviceVersion = "2.0.0")

bwk_client$getFeatureTypes(pretty = TRUE)

# geometrijam

url$query <- list(service = "wfs",
                  request = "GetFeature",
                  srsName="EPSG:3059",
                  typename = "zmni:zmni_stateriverspickets",
                  count=100)
request <- build_url(url)

geometrijam <- read_sf(request)
geometrijam



# lejupielādei
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


# polderu sūkņu stacijas -----


link="https://lvmgeoserver.lvm.lv/geoserver/zmni/ows?"
url=parse_url(link)

url$query <- list(service = "wfs",request = "GetCapabilities")
request <- build_url(url)
bwk_client <- WFSClient$new(link,serviceVersion = "2.0.0")

bwk_client$getFeatureTypes(pretty = TRUE)

# geometrijam

url$query <- list(service = "wfs",
                  request = "GetFeature",
                  srsName="EPSG:3059",
                  typename = "zmni:zmni_polderpumpingstation",
                  count=100)
request <- build_url(url)

geometrijam <- read_sf(request)
geometrijam



# lejupielādei
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



# polderu teritorijas -----


link="https://lvmgeoserver.lvm.lv/geoserver/zmni/ows?"
url=parse_url(link)

url$query <- list(service = "wfs",request = "GetCapabilities")
request <- build_url(url)
bwk_client <- WFSClient$new(link,serviceVersion = "2.0.0")

bwk_client$getFeatureTypes(pretty = TRUE)

# geometrijam

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


# lejupielādei
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


# sateces baseini ----


link="https://lvmgeoserver.lvm.lv/geoserver/zmni/ows?"
url=parse_url(link)

url$query <- list(service = "wfs",request = "GetCapabilities")
request <- build_url(url)
bwk_client <- WFSClient$new(link,serviceVersion = "2.0.0")

bwk_client$getFeatureTypes(pretty = TRUE)

# geometrijam

url$query <- list(service = "wfs",
                  request = "GetFeature",
                  srsName="EPSG:3059",
                  typename = "zmni:zmni_catchment",
                  count=100)
request <- build_url(url)

geometrijam <- read_sf(request)
geometrijam



# lejupielādei
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


# savienojumi ----


link="https://lvmgeoserver.lvm.lv/geoserver/zmni/ows?"
url=parse_url(link)

url$query <- list(service = "wfs",request = "GetCapabilities")
request <- build_url(url)
bwk_client <- WFSClient$new(link,serviceVersion = "2.0.0")

bwk_client$getFeatureTypes(pretty = TRUE)

# geometrijam

url$query <- list(service = "wfs",
                  request = "GetFeature",
                  srsName="EPSG:3059",
                  typename = "zmni:zmni_connectionpoints",
                  count=100)
request <- build_url(url)

geometrijam <- read_sf(request)
geometrijam



# lejupielādei
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


# valsts nozīme ūdensnotekas -----


link="https://lvmgeoserver.lvm.lv/geoserver/zmni/ows?"
url=parse_url(link)

url$query <- list(service = "wfs",request = "GetCapabilities")
request <- build_url(url)
bwk_client <- WFSClient$new(link,serviceVersion = "2.0.0")

bwk_client$getFeatureTypes(pretty = TRUE)

# geometrijam

url$query <- list(service = "wfs",
                  request = "GetFeature",
                  srsName="EPSG:3059",
                  typename = "zmni:zmni_statecontrolledrivers",
                  count=100)
request <- build_url(url)

geometrijam <- read_sf(request)
geometrijam



# lejupielādei
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


# zmni reģions ----


link="https://lvmgeoserver.lvm.lv/geoserver/zmni/ows?"
url=parse_url(link)

url$query <- list(service = "wfs",request = "GetCapabilities")
request <- build_url(url)
bwk_client <- WFSClient$new(link,serviceVersion = "2.0.0")

bwk_client$getFeatureTypes(pretty = TRUE)

# geometrijam

url$query <- list(service = "wfs",
                  request = "GetFeature",
                  srsName="EPSG:3059",
                  typename = "zmni:zmni_zmniregion",
                  count=100)
request <- build_url(url)

geometrijam <- read_sf(request)
geometrijam


library(gdalUtilities)


# lejupielādei
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




# ūdensnotekas (novadrāvji) -----


link="https://lvmgeoserver.lvm.lv/geoserver/zmni/ows?"
url=parse_url(link)

url$query <- list(service = "wfs",request = "GetCapabilities")
request <- build_url(url)
bwk_client <- WFSClient$new(link,serviceVersion = "2.0.0")

bwk_client$getFeatureTypes(pretty = TRUE)

# geometrijam

url$query <- list(service = "wfs",
                  request = "GetFeature",
                  srsName="EPSG:3059",
                  typename = "zmni:zmni_waterdrainditches",
                  count=100)
request <- build_url(url)

geometrijam <- read_sf(request)
geometrijam



# lejupielādei
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




# ūdensnoteku un grāvju piketi ----



link="https://lvmgeoserver.lvm.lv/geoserver/zmni/ows?"
url=parse_url(link)

url$query <- list(service = "wfs",request = "GetCapabilities")
request <- build_url(url)
bwk_client <- WFSClient$new(link,serviceVersion = "2.0.0")

bwk_client$getFeatureTypes(pretty = TRUE)

# geometrijam

url$query <- list(service = "wfs",
                  request = "GetFeature",
                  srsName="EPSG:3059",
                  typename = "zmni:zmni_ditchpicket",
                  count=100)
request <- build_url(url)

geometrijam <- read_sf(request)
geometrijam



# lejupielādei
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



# ūdensteču asis ----


link="https://lvmgeoserver.lvm.lv/geoserver/zmni/ows?"
url=parse_url(link)

url$query <- list(service = "wfs",request = "GetCapabilities")
request <- build_url(url)
bwk_client <- WFSClient$new(link,serviceVersion = "2.0.0")

bwk_client$getFeatureTypes(pretty = TRUE)

# geometrijam

url$query <- list(service = "wfs",
                  request = "GetFeature",
                  srsName="EPSG:3059",
                  typename = "zmni:zmni_stateriversline",
                  count=100)
request <- build_url(url)

geometrijam <- read_sf(request)
geometrijam



# lejupielādei
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



# ūdenstešu ūdens virsmas laukumi ----


link="https://lvmgeoserver.lvm.lv/geoserver/zmni/ows?"
url=parse_url(link)

url$query <- list(service = "wfs",request = "GetCapabilities")
request <- build_url(url)
bwk_client <- WFSClient$new(link,serviceVersion = "2.0.0")

bwk_client$getFeatureTypes(pretty = TRUE)

# geometrijam

url$query <- list(service = "wfs",
                  request = "GetFeature",
                  srsName="EPSG:3059",
                  typename = "zmni:zmni_stateriverspolygon",
                  count=100)
request <- build_url(url)

geometrijam <- read_sf(request)
geometrijam


# lejupielādei
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

