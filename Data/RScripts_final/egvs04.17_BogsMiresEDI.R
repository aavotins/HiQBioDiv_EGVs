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