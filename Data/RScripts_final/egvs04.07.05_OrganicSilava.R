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
