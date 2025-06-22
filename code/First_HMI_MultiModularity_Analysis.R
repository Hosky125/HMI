#==========================Step 1:Inter Data===================================#
First_HMI_monolayer_unweight <- read.csv("HMIModularity/HMI_monolayer_total_First_Inter_NullModel.csv",header = FALSE,sep = ",")
First_Modularity_multilayer_unweight <- read.csv("HMIModularity/Q_multilayer_max_total_First_Inter_NullModel.csv",header = FALSE,sep = ",")
First_Modularity_monolayer_unweight <- read.csv("HMIModularity/Q_mean_max_total_First_Inter_NullModel.csv",header = FALSE,sep = ",")

First_HMI_monolayer_unweight<-unlist(First_HMI_monolayer_unweight,use.names = FALSE)
First_Modularity_multilayer_unweight<-unlist(First_Modularity_multilayer_unweight,use.names = FALSE)
First_Modularity_monolayer_unweight<-unlist(First_Modularity_monolayer_unweight,use.names = FALSE)
NetworkID<-rep(1:2,each=1000)
NetworkType<-rep("First",1000*2)

First_Data<-data.frame(First_HMI_monolayer_unweight,
                        First_Modularity_multilayer_unweight,
                        First_Modularity_monolayer_unweight,NetworkID,NetworkType)
colnames(First_Data)<-c("HMI","MultiModularity","MonoModularity","NetworkID","NetworkType")

First_Data_Inter<-First_Data
#------------------------------------------------------------------------------#
library(ggplot2)
First_Data_Inter$NetworkID<-as.factor(First_Data_Inter$NetworkID)
First_Data_Inter<-First_Data_Inter[which(First_Data_Inter$NetworkID==2),]
First_gmap<-ggplot() +
  geom_point(data = First_Data_Inter,
             aes(x = HMI, 
                 y = MultiModularity, 
                 colour = NetworkID),size = 1)+
  geom_smooth(method = "lm",
              data = First_Data_Inter,
              aes(x = HMI,
                  y = MultiModularity,
                  group = NetworkID),
              color = "black") +
  #labs(x='Homo-Module Index',y = 'Multilayer Modularity',tag = 'a',subtitle = 'First empirical quantification of interlayer link weights') +
  #labs(x='Homo-Module Index',y = 'Multilayer Modularity',tag = 'a',subtitle = 'Island:San Cristóbal') +
  labs(x='Homo-Module Index',y = '',tag = 'b',subtitle = 'Island:Santa Cruz') +
  theme(panel.grid = element_blank(),
        panel.background = element_rect(fill = NA,colour="gray70"),
        panel.border = element_rect(fill=NA,linetype="solid"),
        axis.title = element_text(size = 5* 2,face = "bold"), 
        axis.text = element_text(size = 5 * 2), 
        text= element_text(family="serif",vjust = 0.5),
        legend.key = element_rect(fill = NA,color = NA),
        legend.position = "none",
        plot.tag = element_text(size = 15, face = 'bold'))
First_gmap

ggsave(filename = "First_SC_HMI_MultilayerModularity.tif", device="tiff",width = 5, height = 5,plot = First_gmap,units = "in", dpi = 600)
ggsave(filename = "First_SX_HMI_MultilayerModularity.tif", device="tiff",width = 5, height = 5,plot = First_gmap,units = "in", dpi = 600)
ggsave(filename = "First_HMI_MultilayerModularity.tif", device="tiff",width = 5, height = 5,plot = First_gmap,units = "in", dpi = 600)
#------------------------------------------------------------------------------#