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
