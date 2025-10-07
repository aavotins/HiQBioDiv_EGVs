# Terminology and acronyms {#Ch01}

Even though every data that are or can be georeferenced may be 
considered *geodata*, in this material we try to seperately use following 
terms in their particular order in our workflows:

- **raw geodata** - considered raw data as obtained for harmonized description 
of the environment. It may be tables with coordinates, raster of vector data. 
Literally anything that can or has been used for creation of *ecogeographical variables* 
without or with only slight processing.

- **geodata product** - processed *raw geodata* that needed heavy modifications, e.g. 
spatial overlayrs and combinations of different sets of *raw geodata* to be used 
as *input data*. In this document *geodata products* are categorical 
raster layers matching CRS and pixel locations of *input data*. When splitted by 
categories, they become *input data*. The processing step of creating *geodata products* 
is necessary when decidions of spatial overlay order are important, e.g. in one high 
resolution pixel there can be only water or forest, if the edge between water and 
forest need to be calculated.

- **input data** or **input layers** - very-high resolution (multiple from the one 
used for *ecogeographical variables*) raster data, that are direct input in creation 
of most of the *ecogeographical variables*. Creation of such layers ir particularly useful 
in line with *geodata products* as dealing with border misalignment or decissions of 
order of spatial overlay as well as simple geoprocessing is much faster with raster 
data.

- **ecogeographical variables** (EGVs) - this is the final product of the workflow 
describing environment for statistical analysis (e.g. *species distribution modelling*) 
and is suitable for publishing due to standadisation of the values. In other terms, these are 
standardised landscape ecological variables as high-resolution (we use 1 ha cells) 
raster layers. Each layer contains values representing environment within the 
cells footprint or a summary of focal neighbours. In our case every layer is of 
quantitative data, describing natural quantity (i.e., timber volume in the 
analysis cell, mean annual temperature), or quantified information of 
categories (e.g., fraction of class area at analysis cell or some neighbourhood, 
number of pixels creating an edge of some class or between two classes in the 
analysis cell or some neighbourhood). Each layers values are standardised - from 
every cells value layers mean is subtracted and then every cells value is divided 
by layers root mean square error. Therefore the values are more suitable for 
modelling and layers can be made publically available as they directly do not 
provide exact sensitive information.

In this material we use *species ditribution modelling* as a more used term, that 
is synonymous to *ecological niche analysis* and *ecological niche modelling*.

Acronyms:

**CRS** - coordinate reference system

**EGV** - ecogeoraphical variables

**SDM** - species distribution modelling

**SDMs** - species distribution models
