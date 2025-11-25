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
They are suitable also for publishing due to standardisation of the values. In other 
words, these are standardised landscape ecological variables in the form of 
high-resolution raster layers (we use 1 ha cells). Each layer contains values 
representing the environment within the cell footprint or a summary of focal 
neighbours. In our case, each layer is of quantitative data describing a natural 
quantity (e.g. timber volume, mean annual temperature), or quantified information of 
categories (e.g. the fraction of class's area in an analysis cell or some neighbourhood, 
the number of pixels creating an edge of a certain class or between two classes in the 
analysis cell or some neighbourhood). The values of each layer are standardised: 
for each cell, the layer mean is subtracted and the result is divided 
by the root mean square error. Therefore, the values are more suitable for 
modelling, and the layers can be made publicly available as they do not directly 
provide exact sensitive information.

In this material, we use the term *species distribution modelling* **(SDM)** as 
a more broadly used term, that is synonymous with *ecological niche analysis* 
and *ecological niche modelling*.

Tree species groups:

**coniferous** - following species (codes) as used in the national forest 
stand-level-inventory database:

  - pines (1, 14, 22)
    
  - spruces (3, 15)
    
  - larch (13)
    
  - firs (23, 28)

**boreal deciduous** - following species (codes) as used in the national forest 
stand-level-inventory database:

  - birches (4)
    
  - black alder (6)
    
  - aspens (8, 19, 68)
    
  - grey alder (9)
    
  - willows (20, 21)
    
  - rowan (32)
    
  - eve (35)

**temperate deciduous** - following species (codes) as used in the national forest 
stand-level-inventory database:

  - oaks (10, 61)
    
  - ashes (11, 64)
    
  - lindens (12, 62)
    
  - elms (16, 65)
    
  - beech (17)
    
  - hornbeam (18)
    
  - maples (24, 63)
    
  - cherry (25)
    
  - apple (26)
    
  - pear (27)
    
  - yew (29)
    
  - acacia (50)
    
  - walnut (66)
    
  - chestnut (67)
    
  - robinia (69)


Forest stand **age groups** *(vgr)* as used in the national forest 
stand-level-inventory database:

  - young stands (vgr = 1) in coniferous trees, ashes and oaks - until 40 years, 
    in grey alder - until 10 years, in other tree species - until 20 years;
    
  - medium aged stands (vgr = 2 or vgr = 3) are between young stands (vgr = 1) and legal rotation age;
    
  - old stands (vgr = 4 or vgr = 5) are stands exceeding legal rotation age. This is 
    defined in [by law](https://likumi.lv/ta/id/2825#p9) based on tree species and 
    site quality class (bonity). Generally for oaks, pines and larches it is 101 or 121 years, 
    for spruces, ashes, limes, elms and maples it is 81 years, for birches it is 71 or 51 years, 
    for black alder it is 71 years, for aspens it is 41 years. Currently, there is no minimum 
    rotation age in grey alder. We used 35 years, as it is the age of the youngest 
    stand registered as “full grown” in the databse. This was necessary for the 
    harmonization of EGVs throughout forests.


Acronyms:

**CRS** - coordinate reference system

**DW** - [Dynamic World](#Ch04.08)

**EDI** - Institute of Electronics and Computer Sciences 

**EGV** - ecogeographical variables

**SDM** - species distribution modelling

**SDMs** - species distribution models

**LAD** - Rural Support Service

**LĢIA** - Latvian Geospatial Information Agency

**LULC** - Land use and land cover

**LU** - University of Latvia

**LU ĢZZF** - University of Latvia Faculty of Geography and Earth Sciences

**LVM** - state owned Joint Stock Company "Latvia's State Forests"

**LVMI Silava** - Latvian State Forest Research Institute "Silava"

**NDMI** - normalized difference moisture index

**NDVI** - normalized difference vegetation index

**NDWI** - normalized difference water index

**MVR** - State Forest Service's stand level inventory database "Forest State Registry"

**VMD** - State Forest Service
