library(terra)
library(tidyverse)
library(ggthemes)

faili=data.frame(fails=list.files("./RasterGrids_100m/2024/Scaled/",full.names=TRUE,pattern="*.tif"))

for(i in seq_along(faili$fails)){
  print(i)
  sakums=Sys.time()
  
  slanis=rast(faili$fails[i])
  #plot(slanis)
  nosaukumam=names(slanis)
  slanis_df=terra::as.data.frame(slanis, xy=TRUE)
  names(slanis_df)[3]="vertibas"
  slanis_df=slanis_df %>% 
    filter(!is.na(vertibas))
  zemaka=as.numeric(quantile(slanis_df$vertibas,0.025))
  augstakajai=as.numeric(quantile(slanis_df$vertibas,0.975))
  augstaka=ifelse(zemaka==augstakajai,max(slanis_df$vertibas)-0.05*max(slanis_df$vertibas),augstakajai)

  slanis_df=slanis_df %>% 
    mutate(vertibas=ifelse(vertibas<zemaka,zemaka,
                           ifelse(vertibas>augstaka,augstaka,vertibas)))
  ggplot(slanis_df,aes(x,y,fill=vertibas))+
    geom_raster()+
    theme_map()+
    scale_fill_gradientn(paste0(nosaukumam,"\n"),colours = terrain.colors(11),
                         breaks=c(zemaka,augstaka),
                         labels=c("Low","High"))+
    coord_fixed()+
    theme(legend.position="inside",
          legend.position.inside=c(0.01,0.7),
          #legend.direction = "horizontal",
          legend.text=element_text(size=12),
          legend.title = element_text(size=14),
          legend.background = element_blank(),
          plot.background = element_rect(fill="lightgrey"))
  # 900 * 538
  ggsave(filename=paste0("./RasterGrids_100m/2024/maps4book/",nosaukumam,".png"),
         height=179,width=300,units="mm",dpi=300)
  
  beigas=Sys.time()
  ilgums=beigas-sakums
  print(ilgums)
}

