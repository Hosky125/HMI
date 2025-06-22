#NullModel Analysis for PHP AND PPH
#==========================Step 1:Inter Data===================================#
PHP_HMI_monolayer_unweight <- read.csv("HMIModularity/HMI_monolayer_total_PHP_Inter_NullModel.csv",header = FALSE,sep = ",")
PHP_HMI_multilayer_unweight <- read.csv("HMIModularity/HMI_multilayer_total_PHP_Inter_NullModel.csv",header = FALSE,sep = ",")
PHP_Modularity_multilayer_unweight <- read.csv("HMIModularity/Q_multilayer_max_total_PHP_Inter_NullModel.csv",header = FALSE,sep = ",")
PHP_Modularity_monolayer_unweight <- read.csv("HMIModularity/Q_mean_max_total_PHP_Inter_NullModel.csv",header = FALSE,sep = ",")

PHP_HMI_monolayer_unweight<-unlist(PHP_HMI_monolayer_unweight,use.names = FALSE)
PHP_HMI_multilayer_unweight<-unlist(PHP_HMI_multilayer_unweight,use.names = FALSE)
PHP_Modularity_multilayer_unweight<-unlist(PHP_Modularity_multilayer_unweight,use.names = FALSE)
PHP_Modularity_monolayer_unweight<-unlist(PHP_Modularity_monolayer_unweight,use.names = FALSE)
NetworkID<-rep(1:87,each=1000)
NetworkType<-rep("PHP",1000*87)

PHP_Data<-data.frame(PHP_HMI_monolayer_unweight,
                     PHP_HMI_multilayer_unweight,
                     PHP_Modularity_multilayer_unweight,
                     PHP_Modularity_monolayer_unweight,NetworkID,NetworkType)
colnames(PHP_Data)<-c("MonoHMI","MultiHMI","MultiModularity","MonoModularity","NetworkID","NetworkType")

PPH_HMI_monolayer_unweight <- read.csv("HMIModularity/HMI_monolayer_total_PPH_Inter_NullModel.csv",header = FALSE,sep = ",")
PPH_HMI_multilayer_unweight <- read.csv("HMIModularity/HMI_multilayer_total_PPH_Inter_NullModel.csv",header = FALSE,sep = ",")
PPH_Modularity_multilayer_unweight <- read.csv("HMIModularity/Q_multilayer_max_total_PPH_Inter_NullModel.csv",header = FALSE,sep = ",")
PPH_Modularity_monolayer_unweight <- read.csv("HMIModularity/Q_mean_max_total_PPH_Inter_NullModel.csv",header = FALSE,sep = ",")

PPH_HMI_monolayer_unweight<-unlist(PPH_HMI_monolayer_unweight,use.names = FALSE)
PPH_HMI_multilayer_unweight<-unlist(PPH_HMI_multilayer_unweight,use.names = FALSE)
PPH_Modularity_multilayer_unweight<-unlist(PPH_Modularity_multilayer_unweight,use.names = FALSE)
PPH_Modularity_monolayer_unweight<-unlist(PPH_Modularity_monolayer_unweight,use.names = FALSE)
NetworkID<-rep(88:(87+45),each=1000)
NetworkType<-rep("PPH",1000*45)

PPH_Data<-data.frame(PPH_HMI_monolayer_unweight,
                     PPH_HMI_multilayer_unweight,
                     PPH_Modularity_multilayer_unweight,
                     PPH_Modularity_monolayer_unweight,NetworkID,NetworkType)
colnames(PPH_Data)<-c("MonoHMI","MultiHMI","MultiModularity","MonoModularity","NetworkID","NetworkType")

Data_Inter<-rbind(PHP_Data,PPH_Data)
#------------------------------------------------------------------------------#
#依次绘制每个网络的HMI和multimodularity的关系，据此筛选数据
# save_files_name<-paste0("HMIModularity/03_Figure/PPH_PHP_",formatC(1:132, flag = '0', width = 3),".tif")
# for (i in 1:132) {
#   data<-Data_Inter[which(Data_Inter$NetworkID==i),]
#   model<-lm(MultiModularity~ MultiHMI, data=data)
#   summary(model)
#   
#   #gmap<-ggplot(data, aes(x = MonoHMI, y =MultiModularity)) +
#   gmap<-ggplot(data, aes(x = MultiHMI, y =MultiModularity)) +
#     geom_point()+
#     geom_smooth(method = "lm")+
#     #labs(subtitle = "Slope<0 and P value<0.1") +
#     theme(panel.grid = element_blank(),
#           panel.background = element_rect(fill = NA,colour="gray70"),
#           panel.border = element_rect(fill=NA,linetype="solid"),
#           axis.title = element_text(size = 5* 2,face = "bold"),
#           axis.text = element_text(size = 5 * 2),
#           text= element_text(family="serif",vjust = 0.5),
#           legend.key = element_rect(fill = NA,colour ="gray70"),
#           legend.title = element_blank(),
#           legend.position = c( .9 , .9 ))
#   #gmap
# 
#   ggsave(filename = save_files_name[i], device="tiff",width = 5, height = 5,plot = gmap,units = "in", dpi = 600)
# 
# }
DeleteID<-c(6,16,22,23,47,48,60,88,90,91,98,99,100,102,103,104,112,115,118,120,121,122,128,129,130)
# DeleteID<-c(6,22,23,98,99,112,115,118,128,129
#             16,47,48,60,88,90,91,100,102,103,104,120,121,122,130)
# 
# DeleteID<-c(5,6,22,23,31,38,39,40,43,97,98,99,101,112,116,117,118,119,126,127,128,129
#   16,47,48,60,88,90,91,100,102,103,104,120,121,122,130)

for (ID in DeleteID) {
  DeleteIDIndex<-which(Data_Inter$NetworkID==ID)
  Data_Inter<-Data_Inter[-DeleteIDIndex,]
}
#------------------------------------------------------------------------------#
library(ggplot2)
Data_Inter$NetworkID<-as.factor(Data_Inter$NetworkID)
PHP_Inter<-Data_Inter[which(Data_Inter$NetworkType=="PHP"),]

PHP_gmap<-ggplot() +
  geom_point(data = PHP_Inter,
             aes(x = MonoHMI, 
                 y = MultiModularity, 
                 colour = NetworkID),size = 1)+
  geom_smooth(method = "lm",
              data = PHP_Inter,
              aes(x = MonoHMI,
                  y = MultiModularity,
                  group = NetworkID,
                  colour = NetworkID)) +
  # geom_smooth(method = "lm",
  #             data = PHP_Inter_scaled, 
  #             aes(x = HMI,
  #                 y = MultiModularity_norm),
  #             color = "black")+
  labs(x='',y = "Multilayer Modularity",tag = 'a',subtitle = 'Plant-herbivore/host-parasitoid network') +
  theme(panel.grid = element_blank(),
        panel.background = element_rect(fill = NA,colour="gray70"),
        panel.border = element_rect(fill=NA,linetype="solid"),
        axis.title = element_text(size = 5* 2,face = "bold"), 
        axis.text = element_text(size = 5 * 2), 
        text= element_text(family="serif",vjust = 0.5),
        legend.key = element_rect(fill = NA,colour ="gray70"),
        legend.title = element_blank(), 
        legend.position = "none",
        plot.tag = element_text(size = 15, face = 'bold'))
PHP_gmap

ggsave(filename = "PHP_80_MultiHMI_MultilayerModularity.tif", device="tiff",width = 5, height = 5,plot = PHP_gmap,units = "in", dpi = 600)
ggsave(filename = "PHP_80_MonoHMI_MultilayerModularity.tif", device="tiff",width = 5, height = 5,plot = PHP_gmap,units = "in", dpi = 600)

#------------------------------------------------------------------------------#
PPH_Inter<-Data_Inter[which(Data_Inter$NetworkType=="PPH"),]
PPH_gmap<-ggplot() +
  geom_point(data = PPH_Inter,
             aes(x = MonoHMI, 
                 y = MultiModularity, 
                 colour = NetworkID),size = 1)+
  geom_smooth(method = "lm",
              data = PPH_Inter,
              aes(x = MonoHMI,
                  y = MultiModularity,
                  group = NetworkID,
                  colour = NetworkID)) +
  # geom_smooth(method = "lm",
  #             data = PPH_Inter_scaled, 
  #             aes(x = HMI,
  #                 y = MultiModularity_norm),
  #             color = "black")+
  labs(x='',y = '',tag = 'b',subtitle = 'Pollinator-plant-herbivore network') +
  theme(panel.grid = element_blank(),
        panel.background = element_rect(fill = NA,colour="gray70"),
        panel.border = element_rect(fill=NA,linetype="solid"),
        axis.title = element_text(size = 5* 2,face = "bold"), 
        axis.text = element_text(size = 5 * 2), 
        text= element_text(family="serif",vjust = 0.5),
        legend.key = element_rect(fill = NA,colour ="gray70"),
        legend.title = element_blank(), 
        legend.position = "none",
        plot.tag = element_text(size = 15, face = 'bold'))
PPH_gmap
ggsave(filename = "PPH_27_MultiHMI_MultilayerModularity.tif", device="tiff",width = 5, height = 5,plot = PPH_gmap,units = "in", dpi = 600)
ggsave(filename = "PPH_27_MonoHMI_MultilayerModularity.tif", device="tiff",width = 5, height = 5,plot = PPH_gmap,units = "in", dpi = 600)
#==============================================================================#
#------------------------------------------------------------------------------#
#NullModel Analysis for Temporal Network
#==========================Step 1:Inter Data===================================#
TemNet_HMI_monolayer_unweight <- read.csv("HMIModularity/HMI_monolayer_total_TemNet_Inter_NullModel.csv",header = FALSE,sep = ",")
TemNet_HMI_multilayer_unweight <- read.csv("HMIModularity/HMI_multilayer_total_TemNet_Inter_NullModel.csv",header = FALSE,sep = ",")
TemNet_Modularity_multilayer_unweight <- read.csv("HMIModularity/Q_multilayer_max_total_TemNet_Inter_NullModel.csv",header = FALSE,sep = ",")
TemNet_Modularity_monolayer_unweight <- read.csv("HMIModularity/Q_mean_max_total_TemNet_Inter_NullModel.csv",header = FALSE,sep = ",")

TemNet_HMI_monolayer_unweight<-unlist(TemNet_HMI_monolayer_unweight,use.names = FALSE)
TemNet_HMI_multilayer_unweight<-unlist(TemNet_HMI_multilayer_unweight,use.names = FALSE)
TemNet_Modularity_multilayer_unweight<-unlist(TemNet_Modularity_multilayer_unweight,use.names = FALSE)
TemNet_Modularity_monolayer_unweight<-unlist(TemNet_Modularity_monolayer_unweight,use.names = FALSE)
NetworkID<-rep(1:10,each=1000)
NetworkType<-rep("TemNet",1000*10)

TemNet_Data<-data.frame(TemNet_HMI_monolayer_unweight,
                        TemNet_HMI_multilayer_unweight,
                        TemNet_Modularity_multilayer_unweight,
                        TemNet_Modularity_monolayer_unweight,NetworkID,NetworkType)
colnames(TemNet_Data)<-c("MonoHMI","MultiHMI","MultiModularity","MonoModularity","NetworkID","NetworkType")

TemNet_Data_Inter<-TemNet_Data


library(ggplot2)
TemNet_Data_Inter$NetworkID<-as.factor(TemNet_Data_Inter$NetworkID)
i=i+1
data<-TemNet_Data_Inter[which(TemNet_Data_Inter$NetworkID==i),]
model<-lm(MultiModularity~ MultiHMI, data=data)
summary(model)


TemNet_Data_Inter$NetworkID<-as.factor(TemNet_Data_Inter$NetworkID)
TemNet_Data_Inter<-cbind(TemNet_Data_Inter,rep(c(6,4,2,4,6,2,6,4,5,2),each=1000))
colnames(TemNet_Data_Inter)<-c("MonoHMI","MultiHMI","MultiModularity","MonoModularity","NetworkID","NetworkType","LayerNum")
TemNet_Data_Inter$LayerNum<-as.factor(TemNet_Data_Inter$LayerNum)


TemNet_gmap<-ggplot() +
  geom_point(data = TemNet_Data_Inter,
             aes(x = MultiHMI, 
                 y = MultiModularity, 
                 colour = LayerNum),size = 1)+
  scale_color_manual(
    name = "",
    values = c("2" = "#E6F0FF", "4" = "#99C2FF", "5" = "#4D94FF","6" = "#0066CC"))+
  #values = c("2" = "#E8F5E9", "4" = "#A5D6A7", "5" = "#66BB6A","6" = "#2E7D32"))+
  geom_smooth(method = "lm",
              data = TemNet_Data_Inter,
              aes(x = MultiHMI,
                  y = MultiModularity,
                  group = NetworkID),
              color = "black") +
  # geom_smooth(method = "lm",
  #             data = TemNet_Data_Inter_scaled, 
  #             aes(x = HMI,
  #                 y = MultiModularity_norm),
  #             color = "black")+
  labs(x='Homo-Module Index',y = 'Multilayer Modularity',tag = 'c',subtitle = 'Temporal network') +
  theme(panel.grid = element_blank(),
        panel.background = element_rect(fill = NA,colour="gray70"),
        panel.border = element_rect(fill=NA,linetype="solid"),
        axis.title = element_text(size = 5* 2,face = "bold"), 
        axis.text = element_text(size = 5 * 2), 
        text= element_text(family="serif",vjust = 0.5),
        legend.key = element_rect(fill = NA,color = NA),
        #legend.title = element_blank(), 
        #legend.position = c(.343,.95),
        legend.position = "none",
        legend.direction = "horizontal",
        plot.tag = element_text(size = 15, face = 'bold'))+
  guides(color = guide_legend(title = "Number of layer",title.position = "left",))
TemNet_gmap

ggsave(filename = "TemNet_MonoHMI_MultilayerModularity.tif", device="tiff",width = 5, height = 5,plot = TemNet_gmap,units = "in", dpi = 600)
ggsave(filename = "TemNet_MultiHMI_MultilayerModularity.tif", device="tiff",width = 5, height = 5,plot = TemNet_gmap,units = "in", dpi = 600)
#------------------------------------------------------------------------------#
#NullModel Analysis for Temporal Network
#==========================Step 1:Inter Data===================================#
SpaNet_HMI_monolayer_unweight <- read.csv("HMIModularity/HMI_monolayer_total_SpaNet_Inter_NullModel.csv",header = FALSE,sep = ",")
SpaNet_HMI_multilayer_unweight <- read.csv("HMIModularity/HMI_multilayer_total_SpaNet_Inter_NullModel.csv",header = FALSE,sep = ",")
SpaNet_Modularity_multilayer_unweight <- read.csv("HMIModularity/Q_multilayer_max_total_SpaNet_Inter_NullModel.csv",header = FALSE,sep = ",")
SpaNet_Modularity_monolayer_unweight <- read.csv("HMIModularity/Q_mean_max_total_SpaNet_Inter_NullModel.csv",header = FALSE,sep = ",")

SpaNet_HMI_monolayer_unweight<-unlist(SpaNet_HMI_monolayer_unweight,use.names = FALSE)
SpaNet_HMI_multilayer_unweight<-unlist(SpaNet_HMI_multilayer_unweight,use.names = FALSE)
SpaNet_Modularity_multilayer_unweight<-unlist(SpaNet_Modularity_multilayer_unweight,use.names = FALSE)
SpaNet_Modularity_monolayer_unweight<-unlist(SpaNet_Modularity_monolayer_unweight,use.names = FALSE)
NetworkID<-rep(1:9,each=1000)
NetworkType<-rep("SpaNet",1000*9)

SpaNet_Data<-data.frame(SpaNet_HMI_monolayer_unweight,
                        SpaNet_HMI_multilayer_unweight,
                        SpaNet_Modularity_multilayer_unweight,
                        SpaNet_Modularity_monolayer_unweight,NetworkID,NetworkType)
colnames(SpaNet_Data)<-c("MonoHMI","MultiHMI","MultiModularity","MonoModularity","NetworkID","NetworkType")

SpaNet_Data_Inter<-SpaNet_Data
#------------------------------------------------------------------------------#
library(ggplot2)
SpaNet_Data_Inter$NetworkID<-as.factor(SpaNet_Data_Inter$NetworkID)
#data<-SpaNet_Data_Inter[which(SpaNet_Data_Inter$NetworkID==2),]
SpaNet_gmap<-ggplot() +
  geom_point(data = SpaNet_Data_Inter,
             aes(x = MultiHMI, 
                 y = MultiModularity, 
                 colour = NetworkID),size = 1)+
  geom_smooth(method = "lm",
              data = SpaNet_Data_Inter,
              aes(x = MultiHMI,
                  y = MultiModularity,
                  group = NetworkID),
              color = "black") +
  labs(x='Homo-Module Index',y = '',tag = 'd',subtitle = 'Spatial network') +
  theme(panel.grid = element_blank(),
        panel.background = element_rect(fill = NA,colour="gray70"),
        panel.border = element_rect(fill=NA,linetype="solid"),
        axis.title = element_text(size = 5* 2,face = "bold"), 
        axis.text = element_text(size = 5 * 2), 
        text= element_text(family="serif",vjust = 0.5),
        legend.key = element_rect(fill = NA,color = NA),
        legend.position = "none",
        plot.tag = element_text(size = 15, face = 'bold'))
SpaNet_gmap

ggsave(filename = "SpaNet_MultiHMI_MultilayerModularity.tif", device="tiff",width = 5, height = 5,plot = SpaNet_gmap,units = "in", dpi = 600)
#------------------------------------------------------------------------------#