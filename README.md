# High-resolution ecogeographical variables for species distribution modelling describing Latvia, 2024

This repository form part of the "HiQBioDiv: High-resolution quantification of biodiversity for conservation and management" project, which is funded by the Latvian Council of Science (Ref. No. VPP-VARAM-DABA-2024/1-0002). The main code repository is available at [https://github.com/aavotins/HiQBioDiv](https://github.com/aavotins/HiQBioDiv), and the data are stored in a [Zenodo community repository](https://zenodo.org/communities/hiqbiodiv/records?q=&l=list&p=1&s=10&sort=newest).

Here, we provide a detailed description of the geodata used and the geoprocessing workflows employed to create ecogeographical variables (EGVs). 

The geodata, processing workflows, and exact R commands used to prepare all the EGVs are detailed in the {bookdown} [document](). The [Data](./Data/Geodata/) directory contains a file tree structure with placeholder *.md files. Another option to replicate the file tree is to fork the [template](https://github.com/aavotins/HiQBioDiv_FileTree) repository. Regardless of the option chosen, it is the user's responsibility to acquire the geodata.

Our workflows relay heavily on the R package [{egv_utilities}](), which we created specifically for this purpose and which is guaranteed to work with a dedicated [container]().
