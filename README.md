# High-resolution ecogeographical variables for species distribution modelling describing Latvia, 2024

This repository form part of the "HiQBioDiv: High-resolution quantification of biodiversity for 
conservation and management" project, which is funded by the Latvian Council of 
Science (Ref. No. VPP-VARAM-DABA-2024/1-0002). The main code repository is 
available at [https://github.com/aavotins/HiQBioDiv](https://github.com/aavotins/HiQBioDiv), and 
the data (geoprocessing templates and results) are stored in 
a [Zenodo community repository](https://zenodo.org/communities/hiqbiodiv/records?q=&l=list&p=1&s=10&sort=newest).

Here, we provide a detailed description of the geodata used and the geoprocessing 
workflows employed to create ecogeographical variables (EGVs). 

The geodata, processing workflows, and exact R commands used to prepare all the EGVs are detailed 
in the {bookdown} [document](https://aavotins.github.io/HiQBioDiv_EGVs/). The [Data](./Data/Geodata/) directory 
contains a file tree structure with placeholder *.md files. Recreating this structure, filling the directories 
with data and executing command lines will replicate our work. Another option for replicating the file tree structure is 
to clone the [template](https://github.com/aavotins/HiQBioDiv_FileTree) repository. Regardless of the 
option chosen, it is the user's responsibility to acquire the geodata itself.

Our workflows rely heavily on the R package [{egvtools}](https://aavotins.github.io/egvtools/), which 
we created specifically for this purpose and which is guaranteed to work with a 
dedicated [container](https://hub.docker.com/repository/docker/aavotins/hiqbiodiv-container/general) even 
long after the project ends.
