# Utilities {#Ch02}

This chapter provides a brief description of the utility functions used in this 
material. Most of these functions are packaged in the R package {egvtools}, which 
was created specifically for this work.

## R package egvtools  {#Ch02.01}

{egvtools} provides a coherent set of wrappers and utilities that facilitate the 
reproducible and efficient creation of large-scale EGVs on real datasets. The 
package relies on robust building blocks — {terra}, {sf}, {sfarrow}, {exactextractr} 
and {whitebox} — and standardises input/output, naming conventions and multi-scale 
zonal statistics, ensuring that the pipelines are repeatable across machines and 
projects.

The package was developed for the project 'HiQBioDiv: High-resolution 
quantification of biodiversity for conservation and management', which was 
funded by the Latvian Council of Science (Ref. No. VPP-VARAM-DABA-2024/1-0002), 
to simplify our work and to facilitate the reproduction of our results. Five of 
the functions are strictly for replication, while others are useful for a wider 
audience.

Package can be installed from [GitHub](https://github.com/aavotins/egvtools) with:


``` r
# install.packages("pak")
pak::pak("aavotins/egvtools")
```

or obtained as a [Docker container](https://hub.docker.com/repository/docker/aavotins/hiqbiodiv-container/general) with all the necessary system and software dependencies.


### Reproduction only functions {#Ch02.01.01} 

These functions are small wrappers, that helps to recreate our 
working environments - template files and their locations in the file tree.

These functions are:

- [`download_raster_templates()`](https://aavotins.github.io/egvtools/reference/download_raster_templates.html) — fetch template rasters from Zenodo repository 
and place them in user specified location on disk, or by default - the 
one we used. By default this functions links 
to [version 2.0.0](https://zenodo.org/records/14497070) of the dataset;

- [`download_vector_templates()`](https://aavotins.github.io/egvtools/reference/download_vector_templates.html) - fetch template vector grids/points from Zenodo 
repository and place them in user specified location on disk, or by default - the 
one we used. By default this functions links 
to [version 1.0.1](https://zenodo.org/records/14277114) of the dataset.



### General purpose functions {#Ch02.01.02} 

Each of those functions are small workflows themselves, that can be combined 
into larger workflows and used more widely, than for Latvia.

- [`tile_vector_grid()`](https://aavotins.github.io/egvtools/reference/tile_vector_grid.html) — tile template (vector) grid for chunked processing. The function internally is linked to our file naming 
convention. As long as it is maintained, function can be used to create tiled grid 
from any {sfarrow} parquet grid file;

- [`tiled_buffers()`](https://aavotins.github.io/egvtools/reference/tiled_buffers.html) — 
precompute buffered tiles for multiple radii around 
points. The function internally is linked to our file naming 
convention. As long as it is maintained, function can be used to create tiled 
polygons with buffers around points from any {sfarrow} parquet grid file. There 
are three buffering modes: **dense** (buffers the best-matching pts100\*.parquet 
(prefers pts100_sauzeme.parquet) for each tile by radii_dense (default: 500, 
1250, 3000, 10000 m ensuring that every analysis grid cell has desired buffer. 
Computationally heavy in the following workflows), **sparse** (uses a file to 
radius mapping and is highly generalizable. 
**In our workflows we used this mode with default mapping**), 
and **specified** (the same as sparse, but with one single 
point file);




## Other utility functions {#Ch02.02}

Other handy functions repeatedly used, not included in {egvtools}
