# libs ----
if(!require(terra)) {install.packages("terra"); require(terra)}

# step 1
step1=rast("./RasterGrids_10m/2024/SoilTXT_ESDAC.tif")
step1x=ifel(step1==1,1,
            ifel(step1==2,2,
                 ifel(step1==3,2,
                      ifel(step1==4,3,
                           ifel(step1==8,4,NA)))))
plot(step1x)
step1xy=as.numeric(step1x)
plot(step1xy)


# step 2
step2a=rast("./RasterGrids_10m/2024/SoilTXT_QuarternaryLV.tif")
step2a=as.numeric(step2a)+1
plot(step2a)

step2=cover(step2a,step1x)
plot(step2)

# step 3
step3a=rast("./RasterGrids_10m/2024/SoilTXT_topSoilLV.tif")
step3a=as.numeric(step3a)+1
plot(step3a)

step3=cover(step3a,step2)
plot(step3)

# step 4
step4a=rast("./RasterGrids_10m/2024/SoilTXT_OrganicLU.tif")
step4b=rast("./RasterGrids_10m/2024/SoilTXT_OrganicSilava.tif")

step4c=cover(step4a,step4b)

step4=ifel(step4c==1,4,NA)
plot(step4)

# step 5

step5=cover(step4,step3)
plot(step5)

writeRaster(step5,
           "./RasterGrids_10m/2024/SoilTXT_combined.tif",
           overwrite=TRUE)

