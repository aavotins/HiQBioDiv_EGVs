# Geodata products {#Ch05}

Some raw data need extensive processing before EGVs can be created, many EGVs 
depend on processing raw geodata into geodata products before EGVs can be create, 
and in some cases, EGV itself could be created from ras geodata, but it has 
to be spatially restricted to certain locations. This chapter describes these geodata 
products and procedures involved in creating them.

## Terrain products {#Ch05.01}

In order to develop part of the relief-related EGV, such as the topographic 
moisture index (TWI) and non-drainage depressions, it is necessary to address 
water flow in the environment. This is a multi-step procedure that is logical 
and reliable in mountainous areas and environments with little hydrological 
impact. However, in the context of Latvia, this is challenging. These challenges 
can be addressed in various ways. For example, if reliable (accurate) information 
on the exact locations of rivers and ditches were available, it could be 
incorporated into the terrain. Unfortunately, there is no sufficiently 
accurate information available. Therefore, information about transport 
structures from the [Melioration Cadastre Information System database](#Ch04.03), bridges 
from the [topographic map](#Ch04.04) and transport structures and bridges 
from [LVM Open Data](#Ch04.06) was used to address the challenges - 
information about the minimum height above sea level was incorporated into the 
DEM to be used further in a 30 m buffer around these locations.


``` r
# Libs

# arī LVM
```

This DEM was then used for geoprocessing to find terrain depressions and 
determine the topographic wetness index (TWI). First, terrain depressions were 
calculated, assuming that all runoff that should be known is known and taken 
into account (adjusted DEM values - previous code area). Then, the topographic 
wetness index was prepared and the search for non-runoff depressions was repeated:

1. to calculate the topographic wetness index, the terrain depressions without 
runoff were reviewed, allowing up to ten cell breaks in places of lower 
resistance, the rest were filled in;

2. precise drainage depressions and their depth layers were prepared after 
incorporating flow breaks;

3. for additional security, the result of the first step was repeated to 
search for and fill in relief depressions [@WangLiu2006];

4. the result of the third step was used to determine the specific catchment 
area using d-infinity flow division;

5. by combining the specific catchment area layer with the slope layer, 
the topographic wetness index was calculated. A graphical evaluation revealed 
individual extreme values, which were limited to **20**.



``` r
# Libs
```

Since the initial DEM input was created by filling in water bodies using 
interpolation methods, the water bodies show a pronounced terrain, which needs 
to be removed. This is done by inserting average values into these polygons.



``` r
# Libs
```



## Soil texture product {#Ch05.02}

In this section one united layer describing categorised soil texture (sand=1, 
silt=2, clay=3, organic=4) is created from multiple preprocessed soil texture 
data sources. Creation of soil texture product consisted of multiple overlay steps. 
These steps are illustrated together with processed geodata used:

1. the basis soil texture source was [Soil texture from the European Soil Database](#Ch04.07.02), 
this layer had to be reclassified to match other layers as it was not performed 
during preprocessing;

2. the layer from the first step was overlaid by [Latvian Quarternary geology data](#Ch04.07.04) 
written as numeric starting with 1;

3. the layer from the second step was overlaid by [20th century topsoil in Latvian farmland](#Ch04.07.03) 
written as numeric starting with 1;

4. the layer from [Organic soils as modelled by Silava](#Ch04.07.05) (presence-only) 
was overlaid by [Organic soils as modelled by University of Latvia](#Ch04.07.06) 
(presence-absence). After the overlay, it was classified as presence-only;

5. the layer from the third step was overlaid by the layer from the fourth and 
saved for EGV creation.



``` r
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
```



## Landscape classification {#Ch05.03}

In this exercise, "landscape" refers to the representation of different types 
of land cover and land use classes, where the order in which these classes are 
drawn is important, because spatial data from different sources often have 
mismatched boundaries, which requires addressing both their overlap (1) and 
filling in gaps where there is no database information (2), and the choice of 
how to emphasize objects with certain processing, such as buffering, because 
some elements that are important for characterizing the environment (especially 
edge effects) may be so small or so poorly positioned that they disappear during 
the rasterization process (3). The general landscape layer also serves as a 
mask for the preparation of further environmental descriptions. This section 
describes the development of a general (simple) landscape and, in the following 
document, its enrichment with more specific environmental eco-geographical 
variables. The general landscape is stored in the file `Ainava_vienk_mask.tif`, 
in which the classes and the procedure for their creation are described in the 
following list:

- class `100` - **roads**: roads from various sources, **filled in sequence** - 
dominates classes with higher values so that relatively small objects are not 
lost and information about edges is provided. The following have been 
combined to create this class:

    - layers `RoadA_COMB` and `RoadL_COMB` (except smallest size groups) from
    [topographic map](#Ch04.04), buffered by 10 m before rasterization;
    
    - [LVM open data](#Ch04.06) layers `LVM_MEZA_AUTOCELI`, `LVM_ATTISTAMIE_AUTOCELI`, 
    `LVM_APGRIESANAS_LAUKUMI`, `LVM_IZMAINISANAS_VIETAS` and `LVM_NOBRAUKTUVES` 
    buffered by 10 m;
    
    - information from the State Forest Register on natural roads has not 
    been used, as these do not usually form a continuous break in the canopy. 
    Information on roads from this register is also available in other 
    resources and has not been duplicated.

The command lines below create a layer with landscape class `100`, which is 
saved in the file `SimpleLandscape_class100_celi.tif` for further work.








## Landscape diversity {#Ch05.04}

krā

### Forest diversity {#Ch05.04.01}

krā

### Farmland diversity {#Ch05.04.02}

krā


### Landscape in general diversity {#Ch05.04.03}

krā
