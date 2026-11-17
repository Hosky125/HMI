PHP_Total<-read.csv("Plant_host_parasitoids.csv",header = TRUE)
PHP_lon_lat<-as.data.frame(matrix(0,length(unique(PHP_Total$network_number)),3))
for (ID in 1:length(unique(PHP_Total$network_number))) {
  data<-PHP_Total[which(PHP_Total$network_number==ID),]
  PHP_lon_lat[ID,1:2]<-data[1,5:6]
}
PHP_lon_lat[,3]<-'PHP'

PPH_Total<-read.csv("pollinator_plant_herbivore.csv",header = TRUE)
PPH_lon_lat<-as.data.frame(matrix(0,length(unique(PPH_Total$network_number)),3))
for (ID in 1:length(unique(PPH_Total$network_number))) {
  data<-PPH_Total[which(PPH_Total$network_number==ID),]
  PPH_lon_lat[ID,1:2]<-data[1,5:6]
}
PPH_lon_lat[,3]<-'PPH'

lon_lat<-rbind(PHP_lon_lat,PPH_lon_lat)
colnames(lon_lat)<-c('lon','lat','NetworkType')
DeleteID<-c(6,16,22,23,47,48,60,88,90,91,98,99,100,102,103,104,112,115,118,120,121,122,128,129,130)
lon_lat<-lon_lat[-DeleteID,]
#lon_lat[19,1]
lon_lat[19,1]<-11.5713346000
str(lon_lat)

# unique_lat<-unique(lon_lat$lat)
# unique_lon<-unique(lon_lat$lon)
lon_lat_size<-unique(lon_lat)
lon_lat_size<-cbind(lon_lat_size,rep(0))
colnames(lon_lat_size)<-c('Longitude','Latitude','Network type','Number of network')
for (i in 1:length(lon_lat_size$Longitude)) {
  lon_lat_size[i,4]<-length(which(lon_lat$lon==lon_lat_size[i,1] & lon_lat$lat==lon_lat_size[i,2] & lon_lat$NetworkType==lon_lat_size[i,3]))
}
#lon_lat_size$Longitude<-as.numeric(lon_lat_size$Longitude)
sum(lon_lat_size$`Number of network`)

library(emln)
Temporal_network<-search_emln(multilayer_network_type = "Temporal")
Temporal_network<-Temporal_network[which(Temporal_network$layer_num<50),]
TemNetID<-c(10,62,63,65,66,68,69)
count<-43
for (ID in TemNetID) {
  count<-count+1
  Temporal_network<-load_emln(ID)
  lon_lat_size[count,1]<-Temporal_network$layers$longitude[1]
  lon_lat_size[count,2]<-Temporal_network$layers$latitude[1]
  lon_lat_size[count,3]<-'TemNet'
  lon_lat_size[count,4]<-1
}

ID<-74
count<-count+1
#Temporal_network<-load_emln(ID)
# Temporal_network$layers$longitude[1]
# Temporal_network$layers$latitude[1]
lon_lat_size[count,1]<--126
lon_lat_size[count,2]<-42
lon_lat_size[count,3]<-'TemNet'
lon_lat_size[count,4]<-1

ID<-77
count<-count+1
# Temporal_network<-load_emln(ID)
# Temporal_network$layers$location
#Ithaca, New York
lon_lat_size[count,1]<--76.501884
lon_lat_size[count,2]<-42.443962
lon_lat_size[count,3]<-'TemNet'
lon_lat_size[count,4]<-1

library(emln)
TemNetID<-c(20,26,28,29,36,39,46,47,61)
count<-52
for (ID in TemNetID) {
  count<-count+1
  Spatial_network<-load_emln(ID)
  lon_lat_size[count,1]<-Spatial_network$layers$longitude[1]
  lon_lat_size[count,2]<-Spatial_network$layers$latitude[1]
  lon_lat_size[count,3]<-'SpaNet'
  lon_lat_size[count,4]<-1
}

lon_lat_size$Longitude<-as.numeric(lon_lat_size$Longitude)
lon_lat_size$Latitude<-as.numeric(lon_lat_size$Latitude)

# fix some labels for plotting 
lon_lat_size$`Network type` <- factor(lon_lat_size$`Network type`,
                    levels = c('PHP', 'PPH','TemNet','SpaNet'),
                    labels = c('Plant-herbivore/host-parasitoid network', 'Pollinator-plant-herbivore network','Temporal network','Spatial network'))

world <- map_data('world') %>% 
  as_tibble()

gmap <- ggplot() +
  geom_polygon(data=world, 
               aes(long, lat, group = group), colour=NA, fill='#CCCCCC', size=0) +
  geom_point(data = lon_lat_size,
             mapping = aes(x = Longitude, y = Latitude, colour = `Network type`, size = `Number of network`),#,shape = taxa),
             alpha = 0.6) +

  coord_map('mollweide', ylim = c(-60, 90), xlim = c(-180, 180)) +
  scale_x_continuous(breaks = seq(-180, 180, by = 30)) +
  scale_y_continuous(breaks = c(0, -23.5, 23.5, -60, 60)) +
  labs(x = '', 
       y = '',
       subtitle =  '') +
  theme_bw() +
  theme(panel.border = element_blank(),
        axis.ticks = element_blank(), 
        axis.text = element_blank(),
        legend.position = 'right',
        # legend.direction = 'horizontal',
        plot.subtitle = element_text(size = 15),
        plot.margin = unit(c(0,0,0,0), units = 'mm'),
        legend.margin = margin(),
        legend.box.spacing = unit(c(0,0,0,0), units = 'mm'),
        title = element_text(face = 'bold', size = 8),
        text= element_text(family="serif",vjust = 0.5),
        legend.text = element_text(size = 12, face = 'plain'),
        legend.title = element_text(size = 12, face = 'plain')) +
  guides(shape = guide_legend(ncol = 1, label.hjust = 0),
         colour = guide_legend(ncol = 1, label.hjust = 0))

gmap
ggsave(filename = "sample_map.tif", device="tiff",width = 15, height = 5,plot = gmap,units = "in", dpi = 600)
