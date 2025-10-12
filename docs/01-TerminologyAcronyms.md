# Terminology and acronyms {#Ch01}

Athough all georeferenced data can be considered *geodata*, in this material we 
use the following terms in the order listed below in our workflows:

- **raw geodata** - considered as raw data obtained for a harmonised description 
of the environment. This may include tables with coordinates, raster or vector data. 
It can be anything that has been or can be used to create *ecogeographical variables*, 
with or without slight processing.

- **geodata product** - processed *raw geodata* that have undegone heavy modifications, e.g. 
spatial overlays and combinations of different sets of *raw geodata*, and are used 
as *input data*. In this document, *geodata products* are categorical 
raster layers that match the *CRS* and the pixel locations of *input data*. When 
split by categories, they become *input data*. The processing step of creating *geodata products* 
is necessary when decisions about the order of spatial overlays are important. For example, 
in a high-resolution pixel, there can only be water or forest, if the edge between water and 
forest need to be calculated.

- **input data** or **input layers** - very-high resolution (multiple times higher than that 
used for *ecogeographical variables*) raster data that are the direct input for the creation 
of most of the *ecogeographical variables*. The creation of such layers is particularly useful 
alongside *geodata products*, as dealing with border misalignment or decisions regarding the 
order of spatial overlays, as well as simple geoprocessing, is much faster with raster 
data.

- **ecogeographical variables** (EGVs) - this is the final product of the workflow 
describing environment for statistical analysis (e.g. *species distribution modelling*). 
They are suitable also for publishing due to standadisation of the values. In other 
words, these are standardised landscape ecological variables in the for of 
high-resolution raster layers (we use 1 ha cells). Each layer contains values 
representing the environment within the cell footprint or a summary of focal 
neighbours. In our case, each layer is of quantitative data describing a natural 
quantity (e.g. timber volume, mean annual temperature), or quantified information of 
categories (e.g. the fraction of class's area in an analysis cell or some neighbourhood, 
the number of pixels creating an edge of a certain class or between two classes in the 
analysis cell or some neighbourhood). The values of each layer are standardised - from 
every cells value layers mean is subtracted and then every cells value is divided 
by layers root mean square error. Therefore, the values are more suitable for 
modelling, and the layers can be made publicly available as they do not directly 
provide exact sensitive information.

In this material, we use the term *species distribution modelling* as a more used term, that 
is synonymous with *ecological niche analysis* and *ecological niche modelling*.

Acronyms:

**CRS** - coordinate reference system

**EGV** - ecogeoraphical variables

**SDM** - species distribution modelling

**SDMs** - species distribution models

**LAD** - Rural support service

**NDMI** - normalized difference moisture index

**NDVI** - normalized difference vegetation index

**NDWI** - normalized difference water index

**MVR** - State Forest Service's stand level inventory database "Forest State Registry"

**VMD** - State Forest Service
