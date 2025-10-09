# libs ----
if(!require(terra)) {install.packages("terra"); require(terra)}
if(!require(sf)) {install.packages("sf"); require(sf)}
if(!require(sfarrow)) {install.packages("sfarrow"); require(sfarrow)}
if(!require(tidyverse)) {install.packages("tidyverse"); require(tidyverse)}
if(!require(curl)) {install.packages("curl"); require(curl)}

# templates ----
# 1km grid
tikls1km=sfarrow::st_read_parquet("./Templates/TemplateGrids/tikls1km_sauzeme.parquet")
telpai=tikls1km %>% 
  mutate(yes=1) %>% 
  summarise(yes=max(yes)) %>% 
  st_buffer(.,dist=10000)

# download and crop ----

links_names=read_csv("./Geodata/2024/CHELSA/CHELSAdownload_rename.csv")
links_names=links_names %>% 
  filter(todownload==1)

for(i in seq_along(links_names$localname)){
  print(i)
  sakums=Sys.time()
  links=links_names$weblocation[i]
  saving1="./Geodata/2024/CHELSA/draza.tif"
  saving2=paste0("./Geodata/2024/CHELSA/",links_names$localname[i])
  
  curl_download(url=links,destfile = saving1,quiet = FALSE)
  fails=rast(saving1)
  telpa=st_transform(telpai,crs=st_crs(fails))
  nogriezts=crop(fails,telpa,
                 filename=saving2,
                 overwrite=TRUE)
  unlink(saving1)
  beigas=Sys.time()
  ilgums=beigas-sakums
  print(ilgums)
}
