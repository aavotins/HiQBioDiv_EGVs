# libs ----
if(!require(terra)) {install.packages("terra"); require(terra)}

# 10 m rastra template ----
template10=rast("./Templates/TemplateRasters/LV10m_10km.tif")

# TreeCoverLoss ----
treecoverloss=rast("./Geodata/2024/Trees/GFW/RAW/TreeCoverLoss_v1_12.tif")

tcl=ifel(treecoverloss<1,NA,treecoverloss)

tcl2=terra::project(tcl,paraugs)
tcl3=mask(tcl2,paraugs,filename="./Geodata/2024/Trees/GFW/TreeCoverLoss_v1_12.tif",overwrite=TRUE)
