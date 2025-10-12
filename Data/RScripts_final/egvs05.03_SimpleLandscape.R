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


# class 400 ----

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
a400=rast("./RasterGrids_10m/2024/SimpleLandscape_class410_darzini_topo.tif")
b400=rast("./RasterGrids_10m/2024/SimpleLandscape_class420_darzini_lad.tif")

allotment_cover=cover(a400,b400,
                     filename="./RasterGrids_10m/2024/SimpleLandscape_class400_varnicas_premask.tif",
                     overwrite=TRUE)

# cleaning
rm(a400)
rm(b400)
rm(allotment_cover)
unlink("./RasterGrids_10m/2024/SimpleLandscape_class410_darzini_topo.tif")
unlink("./RasterGrids_10m/2024/SimpleLandscape_class420_darzini_lad.tif")


# class 500 ----
# not yet

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
bogs=rast("./RasterGrids_10m/2024/EDI_BogsYN.tif")

wetlands_cover=cover(r_niedraji_topo,r_purvi_topo)
wetlands_cover=cover(wetlands_cover,r_purvi_mvr)
wetlands_cover=cover(wetlands_cover,r_bebri_mvr)
wetlands_cover=cover(wetlands_cover,mires)
wetlands_cover=cover(wetlands_cover,bogs,
                            filename="./RasterGrids_10m/2024/SimpleLandscape_class700_mitraji_premask.tif",
                            overwrite=TRUE)
# cleaning
rm(r_niedraji_topo)
rm(r_purvi_topo)
rm(r_purvi_mvr)
rm(r_bebri_mvr)
rm(bogs)
rm(mires)
rm(topo)
rm(wetlands_cover)

unlink("./RasterGrids_10m/2024/SimpleLandscape_class710_purvi_topo.tif")
unlink("./RasterGrids_10m/2024/SimpleLandscape_class710_purvi_mvr.tif")
unlink("./RasterGrids_10m/2024/SimpleLandscape_class730_bebri_mvr.tif")

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
# liekā aizvākšana
rm(r_smiltaji_topo)
rm(r_smiltaji_mvr)
rm(bare_cover)

unlink("./RasterGrids_10m/2024/SimpleLandscape_class800_SmiltajiKudra_topo.tif")
unlink("./RasterGrids_10m/2024/SimpleLandscape_class800_SmiltVirs_mvr.tif")




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
niedraji=rast("RasterGrids_10m/2024/SimpleLandscape_class720_niedraji_topo.tif")
udeni=rast("./RasterGrids_10m/2024/SimpleLandscape_class200_udens_premask.tif")
lauki=rast("./RasterGrids_10m/2024/SimpleLandscape_class300_lauki_premask.tif")
vasarnicas=rast("./RasterGrids_10m/2024/SimpleLandscape_class400_varnicas_premask.tif")
mezi=rast("./RasterGrids_10m/2024/SimpleLandscape_class600_meziem_premask.tif")
mitraji=rast("./RasterGrids_10m/2024/SimpleLandscape_class700_mitraji_premask.tif")
smiltaji=rast("./RasterGrids_10m/2024/SimpleLandscape_class800_smiltaji_premask.tif")
dw2=rast("./RasterGrids_10m/2024/DW_reclass.tif")

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
masketa_ainava=terra::mask(rastrs_ainava,
                           template_t,
                           filename="./RasterGrids_10m/2024/Ainava_vienk_mask.tif",
                           overwrite=TRUE)
plot(masketa_ainava)

# cleaning
rm(rastrs_ainava)
rm(masketa_ainava)

