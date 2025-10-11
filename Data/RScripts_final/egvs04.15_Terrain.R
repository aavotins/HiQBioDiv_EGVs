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
                filename="./RasterGrids_10m/2024/Slope_10m.tif", overwrite=TRUE)  


## aspect 
reljefs=rast("./Geodata/2024/DEM/mozDEM_10m.tif")
virzieni=terrain(reljefs, v="aspect", neighbors=8, unit="degrees", 
                 filename="./RasterGrids_10m/2024/Aspect_10m.tif", overwrite=TRUE)