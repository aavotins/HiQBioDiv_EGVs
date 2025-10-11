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