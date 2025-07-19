#NullModel Analysis for PHP AND PPH
#==========================Step 1:Inter Data===================================#
PHP_HMI_monolayer_unweight <- read.csv("HMIModularity/HMI_monolayer_total_PHP_Inter_NullModel.csv",header = FALSE,sep = ",")
PHP_Modularity_multilayer_unweight <- read.csv("HMIModularity/Q_multilayer_max_total_PHP_Inter_NullModel.csv",header = FALSE,sep = ",")
PHP_Modularity_monolayer_unweight <- read.csv("HMIModularity/Q_mean_max_total_PHP_Inter_NullModel.csv",header = FALSE,sep = ",")

PHP_HMI_monolayer_unweight<-unlist(PHP_HMI_monolayer_unweight,use.names = FALSE)
PHP_Modularity_multilayer_unweight<-unlist(PHP_Modularity_multilayer_unweight,use.names = FALSE)
PHP_Modularity_monolayer_unweight<-unlist(PHP_Modularity_monolayer_unweight,use.names = FALSE)
NetworkID<-rep(1:87,each=1000)
NetworkType<-rep("PHP",1000*87)

PHP_Data<-data.frame(PHP_HMI_monolayer_unweight,
                     PHP_Modularity_multilayer_unweight,
                     PHP_Modularity_monolayer_unweight,NetworkID,NetworkType)
colnames(PHP_Data)<-c("HMI","MultiModularity","MonoModularity","NetworkID","NetworkType")

PPH_HMI_monolayer_unweight <- read.csv("HMIModularity/HMI_monolayer_total_PPH_Inter_NullModel.csv",header = FALSE,sep = ",")
PPH_Modularity_multilayer_unweight <- read.csv("HMIModularity/Q_multilayer_max_total_PPH_Inter_NullModel.csv",header = FALSE,sep = ",")
PPH_Modularity_monolayer_unweight <- read.csv("HMIModularity/Q_mean_max_total_PPH_Inter_NullModel.csv",header = FALSE,sep = ",")

PPH_HMI_monolayer_unweight<-unlist(PPH_HMI_monolayer_unweight,use.names = FALSE)
PPH_Modularity_multilayer_unweight<-unlist(PPH_Modularity_multilayer_unweight,use.names = FALSE)
PPH_Modularity_monolayer_unweight<-unlist(PPH_Modularity_monolayer_unweight,use.names = FALSE)
NetworkID<-rep(88:(87+45),each=1000)
NetworkType<-rep("PPH",1000*45)

PPH_Data<-data.frame(PPH_HMI_monolayer_unweight,
                     PPH_Modularity_multilayer_unweight,
                     PPH_Modularity_monolayer_unweight,NetworkID,NetworkType)
colnames(PPH_Data)<-c("HMI","MultiModularity","MonoModularity","NetworkID","NetworkType")

Data_Inter<-rbind(PHP_Data,PPH_Data)
#------------------------------------------------------------------------------#
DeleteID<-c(6,16,22,23,47,48,60,88,90,91,98,99,100,102,103,104,112,115,118,120,121,122,128,129,130)

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
             aes(x = HMI, 
                 y = MultiModularity, 
                 colour = NetworkID),size = 1)+
  geom_smooth(method = "lm",
              data = PHP_Inter,
              aes(x = HMI,
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

ggsave(filename = "PHP_80_HMI_MultilayerModularity.tif", device="tiff",width = 5, height = 5,plot = PHP_gmap,units = "in", dpi = 600)
#------------------------------------------------------------------------------#
PPH_Inter<-Data_Inter[which(Data_Inter$NetworkType=="PPH"),]
PPH_gmap<-ggplot() +
  geom_point(data = PPH_Inter,
             aes(x = HMI, 
                 y = MultiModularity, 
                 colour = NetworkID),size = 1)+
  geom_smooth(method = "lm",
              data = PPH_Inter,
              aes(x = HMI,
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
ggsave(filename = "PPH_27_HMI_MultilayerModularity.tif", device="tiff",width = 5, height = 5,plot = PPH_gmap,units = "in", dpi = 600)

#============================Step 2:Raw Data===================================#
PHP_HMI_monolayer_unweight <- read.csv("HMIModularity/HMI_monolayer_total_PHP_Raw.csv",header = FALSE,sep = ",")
PHP_Modularity_multilayer_unweight <- read.csv("HMIModularity/Q_multilayer_max_total_PHP_Raw.csv",header = FALSE,sep = ",")
PHP_Modularity_monolayer_unweight <- read.csv("HMIModularity/Q_mean_max_total_PHP_Raw.csv",header = FALSE,sep = ",")

PHP_HMI_monolayer_unweight<-unlist(PHP_HMI_monolayer_unweight,use.names = FALSE)
PHP_Modularity_multilayer_unweight<-unlist(PHP_Modularity_multilayer_unweight,use.names = FALSE)
PHP_Modularity_monolayer_unweight<-unlist(PHP_Modularity_monolayer_unweight,use.names = FALSE)
NetworkID<-rep(1:87,each=1)
NetworkType<-rep("PHP",1*87)

PHP_Data<-data.frame(PHP_HMI_monolayer_unweight,
                     PHP_Modularity_multilayer_unweight,
                     PHP_Modularity_monolayer_unweight,NetworkID,NetworkType)
colnames(PHP_Data)<-c("HMI","MultiModularity","MonoModularity","NetworkID","NetworkType")

PPH_HMI_monolayer_unweight <- read.csv("HMIModularity/HMI_monolayer_total_PPH_Raw.csv",header = FALSE,sep = ",")
PPH_Modularity_multilayer_unweight <- read.csv("HMIModularity/Q_multilayer_max_total_PPH_Raw.csv",header = FALSE,sep = ",")
PPH_Modularity_monolayer_unweight <- read.csv("HMIModularity/Q_mean_max_total_PPH_Raw.csv",header = FALSE,sep = ",")

PPH_HMI_monolayer_unweight<-unlist(PPH_HMI_monolayer_unweight,use.names = FALSE)
PPH_Modularity_multilayer_unweight<-unlist(PPH_Modularity_multilayer_unweight,use.names = FALSE)
PPH_Modularity_monolayer_unweight<-unlist(PPH_Modularity_monolayer_unweight,use.names = FALSE)
NetworkID<-rep(88:(87+45),each=1)
NetworkType<-rep("PPH",1*45)

PPH_Data<-data.frame(PPH_HMI_monolayer_unweight,
                     PPH_Modularity_multilayer_unweight,
                     PPH_Modularity_monolayer_unweight,NetworkID,NetworkType)
colnames(PPH_Data)<-c("HMI","MultiModularity","MonoModularity","NetworkID","NetworkType")

Data_Raw<-rbind(PHP_Data,PPH_Data)
Data_Raw<-Data_Raw[-DeleteID,]
#------------------------------------------------------------------------------#
#=========================Step 3:Intra Data===================================#
PHP_HMI_monolayer_unweight <- read.csv("HMIModularity/HMI_monolayer_total_PHP_Intra_NullModel.csv",header = FALSE,sep = ",")
PHP_Modularity_multilayer_unweight <- read.csv("HMIModularity/Q_multilayer_max_total_PHP_Intra_NullModel.csv",header = FALSE,sep = ",")
PHP_Modularity_monolayer_unweight <- read.csv("HMIModularity/Q_mean_max_total_PHP_Intra_NullModel.csv",header = FALSE,sep = ",")

PHP_HMI_monolayer_unweight<-unlist(PHP_HMI_monolayer_unweight,use.names = FALSE)
PHP_Modularity_multilayer_unweight<-unlist(PHP_Modularity_multilayer_unweight,use.names = FALSE)
PHP_Modularity_monolayer_unweight<-unlist(PHP_Modularity_monolayer_unweight,use.names = FALSE)
NetworkID<-rep(1:87,each=1000)
NetworkType<-rep("PHP",1000*87)

PHP_Data<-data.frame(PHP_HMI_monolayer_unweight,
                     PHP_Modularity_multilayer_unweight,
                     PHP_Modularity_monolayer_unweight,NetworkID,NetworkType)
colnames(PHP_Data)<-c("HMI","MultiModularity","MonoModularity","NetworkID","NetworkType")

PPH_HMI_monolayer_unweight <- read.csv("HMIModularity/HMI_monolayer_total_PPH_Intra_NullModel.csv",header = FALSE,sep = ",")
PPH_Modularity_multilayer_unweight <- read.csv("HMIModularity/Q_multilayer_max_total_PPH_Intra_NullModel.csv",header = FALSE,sep = ",")
PPH_Modularity_monolayer_unweight <- read.csv("HMIModularity/Q_mean_max_total_PPH_Intra_NullModel.csv",header = FALSE,sep = ",")

PPH_HMI_monolayer_unweight<-unlist(PPH_HMI_monolayer_unweight,use.names = FALSE)
PPH_Modularity_multilayer_unweight<-unlist(PPH_Modularity_multilayer_unweight,use.names = FALSE)
PPH_Modularity_monolayer_unweight<-unlist(PPH_Modularity_monolayer_unweight,use.names = FALSE)
NetworkID<-rep(88:(87+45),each=1000)
NetworkType<-rep("PPH",1000*45)

PPH_Data<-data.frame(PPH_HMI_monolayer_unweight,
                     PPH_Modularity_multilayer_unweight,
                     PPH_Modularity_monolayer_unweight,NetworkID,NetworkType)
colnames(PPH_Data)<-c("HMI","MultiModularity","MonoModularity","NetworkID","NetworkType")

Data_Intra<-rbind(PHP_Data,PPH_Data)
#------------------------------------------------------------------------------#
for (ID in DeleteID) {
  DeleteIDIndex<-which(Data_Intra$NetworkID==ID)
  Data_Intra<-Data_Intra[-DeleteIDIndex,]
}
#=========================Step 4:Hybrid Data===================================#
PHP_HMI_monolayer_unweight <- read.csv("HMIModularity/HMI_monolayer_total_PHP_Hybrid_NullModel.csv",header = FALSE,sep = ",")
PHP_Modularity_multilayer_unweight <- read.csv("HMIModularity/Q_multilayer_max_total_PHP_Hybrid_NullModel.csv",header = FALSE,sep = ",")
PHP_Modularity_monolayer_unweight <- read.csv("HMIModularity/Q_mean_max_total_PHP_Hybrid_NullModel.csv",header = FALSE,sep = ",")

PHP_HMI_monolayer_unweight<-unlist(PHP_HMI_monolayer_unweight,use.names = FALSE)
PHP_Modularity_multilayer_unweight<-unlist(PHP_Modularity_multilayer_unweight,use.names = FALSE)
PHP_Modularity_monolayer_unweight<-unlist(PHP_Modularity_monolayer_unweight,use.names = FALSE)
NetworkID<-rep(1:87,each=1000)
NetworkType<-rep("PHP",1000*87)

PHP_Data<-data.frame(PHP_HMI_monolayer_unweight,
                     PHP_Modularity_multilayer_unweight,
                     PHP_Modularity_monolayer_unweight,NetworkID,NetworkType)
colnames(PHP_Data)<-c("HMI","MultiModularity","MonoModularity","NetworkID","NetworkType")

PPH_HMI_monolayer_unweight <- read.csv("HMIModularity/HMI_monolayer_total_PPH_Hybrid_NullModel.csv",header = FALSE,sep = ",")
PPH_Modularity_multilayer_unweight <- read.csv("HMIModularity/Q_multilayer_max_total_PPH_Hybrid_NullModel.csv",header = FALSE,sep = ",")
PPH_Modularity_monolayer_unweight <- read.csv("HMIModularity/Q_mean_max_total_PPH_Hybrid_NullModel.csv",header = FALSE,sep = ",")

PPH_HMI_monolayer_unweight<-unlist(PPH_HMI_monolayer_unweight,use.names = FALSE)
PPH_Modularity_multilayer_unweight<-unlist(PPH_Modularity_multilayer_unweight,use.names = FALSE)
PPH_Modularity_monolayer_unweight<-unlist(PPH_Modularity_monolayer_unweight,use.names = FALSE)
NetworkID<-rep(88:(87+45),each=1000)
NetworkType<-rep("PPH",1000*45)

PPH_Data<-data.frame(PPH_HMI_monolayer_unweight,
                     PPH_Modularity_multilayer_unweight,
                     PPH_Modularity_monolayer_unweight,NetworkID,NetworkType)
colnames(PPH_Data)<-c("HMI","MultiModularity","MonoModularity","NetworkID","NetworkType")

Data_Hybrid<-rbind(PHP_Data,PPH_Data)
#------------------------------------------------------------------------------#
for (ID in DeleteID) {
  DeleteIDIndex<-which(Data_Hybrid$NetworkID==ID)
  Data_Hybrid<-Data_Hybrid[-DeleteIDIndex,]
}
#==============================================================================#
#Z-Score,(raw-mean(random))/mean(random) or (raw-mean(random))/sd(random)
Data_Raw<-cbind(Data_Raw,
                rep(0,length(Data_Raw$HMI)),rep(0,length(Data_Raw$MultiModularity)),rep(0,length(Data_Raw$MonoModularity)),
                rep(0,length(Data_Raw$HMI)),rep(0,length(Data_Raw$MultiModularity)),rep(0,length(Data_Raw$MonoModularity)),
                rep(0,length(Data_Raw$HMI)),rep(0,length(Data_Raw$MultiModularity)),rep(0,length(Data_Raw$MonoModularity)))
colnames(Data_Raw)<-c("HMI","MultiModularity","MonoModularity","NetworkID","NetworkType",#Raw
                      "HMI1","MultiModularity1","MonoModularity1",#NullModel-change interlayer links
                      "HMI2","MultiModularity2","MonoModularity2",#NullModel-change intralayer links
                      "HMI3","MultiModularity3","MonoModularity3")##NullModel-change interlayer links and intralayer links
count<-0
for (i in unique(Data_Inter$NetworkID)) {
  count<-count+1
  HMI1<-Data_Inter[which(Data_Inter$NetworkID==i),1]
  MultiModularity1<-Data_Inter[which(Data_Inter$NetworkID==i),2]
  MonoModularity1<-Data_Inter[which(Data_Inter$NetworkID==i),3]
  Data_Raw[count,6]<-(Data_Raw[count,1]-mean(HMI1))/sd(HMI1)
  Data_Raw[count,7]<-(Data_Raw[count,2]-mean(MultiModularity1))/sd(MultiModularity1)
  Data_Raw[count,8]<-(Data_Raw[count,3]-mean(MonoModularity1))/sd(MonoModularity1)
  
  HMI2<-Data_Intra[which(Data_Intra$NetworkID==i),1]
  MultiModularity2<-Data_Intra[which(Data_Intra$NetworkID==i),2]
  MonoModularity2<-Data_Intra[which(Data_Intra$NetworkID==i),3]
  Data_Raw[count,9]<-(Data_Raw[count,1]-mean(HMI2))/sd(HMI2)
  Data_Raw[count,10]<-(Data_Raw[count,2]-mean(MultiModularity2))/sd(MultiModularity2)
  Data_Raw[count,11]<-(Data_Raw[count,3]-mean(MonoModularity2))/sd(MonoModularity2)
  
  HMI3<-Data_Hybrid[which(Data_Hybrid$NetworkID==i),1]
  MultiModularity3<-Data_Hybrid[which(Data_Hybrid$NetworkID==i),2]
  MonoModularity3<-Data_Hybrid[which(Data_Hybrid$NetworkID==i),3]
  Data_Raw[count,12]<-(Data_Raw[count,1]-mean(HMI3))/sd(HMI3)
  Data_Raw[count,13]<-(Data_Raw[count,2]-mean(MultiModularity3))/sd(MultiModularity3)
  Data_Raw[count,14]<-(Data_Raw[count,3]-mean(MonoModularity3))/sd(MonoModularity3)
}

#------------------------------------------------------------------------------#
# model<-lm(MultiModularity1~HMI1,data = Data_Raw)
# summary(model)
# 
# data<-Data_Raw[which(Data_Raw$NetworkType=="PPH"),]
# model<-lm(MultiModularity1~HMI1,data = data)
# summary(model)
# model<-lm(MultiModularity1~HMI1+MonoModularity1,data = data)
# summary(model)
# model<-lm(MultiModularity1~HMI1+MonoModularity1+HMI1:MonoModularity1,data = data)
# summary(model)
# 
# data<-Data_Raw[which(Data_Raw$NetworkType=="PHP"),]
# model<-lm(MultiModularity1~HMI1,data = data)
# summary(model)
# model<-lm(MultiModularity1~HMI1+MonoModularity1,data = data)
# summary(model)
# model<-lm(MultiModularity1~HMI1+MonoModularity1+HMI1:MonoModularity1,data = data)
# summary(model)

# library(glmm.hp)
# glmm.hp(model)
#------------------------------------------------------------------------------#
# data<-Data_Raw[which(Data_Raw$NetworkType=="PPH"),]
# model<-lm(MultiModularity2~HMI2,data = data)
# summary(model)
# model<-lm(MultiModularity2~HMI2+MonoModularity2,data = data)
# summary(model)
# model<-lm(MultiModularity2~HMI2+MonoModularity2+HMI2:MonoModularity2,data = data)
# summary(model)
# 
# data<-Data_Raw[which(Data_Raw$NetworkType=="PHP"),]
# model<-lm(MultiModularity2~HMI2,data = data)
# summary(model)
# model<-lm(MultiModularity2~HMI2+MonoModularity2,data = data)
# summary(model)
# model<-lm(MultiModularity2~HMI2+MonoModularity2+HMI2:MonoModularity2,data = data)
# summary(model)
# ------------------------------------------------------------------------------#
# data<-Data_Raw[which(Data_Raw$NetworkType=="PPH"),]
# model<-lm(MultiModularity3~HMI3,data = data)
# summary(model)
# model<-lm(MultiModularity3~HMI3+MonoModularity3,data = data)
# summary(model)
# model<-lm(MultiModularity3~HMI3+MonoModularity3+HMI3:MonoModularity3,data = data)
# summary(model)
# 
# data<-Data_Raw[which(Data_Raw$NetworkType=="PHP"),]
# model<-lm(MultiModularity3~HMI3,data = data)
# summary(model)
# model<-lm(MultiModularity3~HMI3+MonoModularity3,data = data)
# summary(model)
# model<-lm(MultiModularity3~HMI3+MonoModularity3+HMI3:MonoModularity3,data = data)
# summary(model)
#------------------------------------------------------------------------------#

#------------------------------------------------------------------------------#
# data<-as.data.frame(matrix(0,107*3,5))
# colnames(data)<-c("HMI","MultiModularity","MonoModularity","NullModel","NetworkType")
# data$HMI<-c(Data_Raw$HMI1,Data_Raw$HMI2,Data_Raw$HMI3)
# data$MultiModularity<-c(Data_Raw$MultiModularity1,Data_Raw$MultiModularity2,Data_Raw$MultiModularity3)
# data$MonoModularity<-c(Data_Raw$MonoModularity1,Data_Raw$MonoModularity2,Data_Raw$MonoModularity3)
# data$NullModel<-c(rep("N1",107),rep("N2",107),rep("N3",107))
# data$NetworkType<-c(Data_Raw$NetworkType,Data_Raw$NetworkType,Data_Raw$NetworkType)
# 
# library(ggplot2)
# gmap<-ggplot(data, aes(x = HMI, y =MultiModularity,color=NullModel)) +
#   geom_point()+
#   geom_smooth(method = "lm")+
#   #labs(y = "Multilayer Modularity") +
#   theme(panel.grid = element_blank(),
#         panel.background = element_rect(fill = NA,colour="gray70"),
#         panel.border = element_rect(fill=NA,linetype="solid"),
#         axis.title = element_text(size = 5* 2,face = "bold"), 
#         axis.text = element_text(size = 5 * 2), 
#         text= element_text(family="serif",vjust = 0.5),
#         legend.key = element_rect(fill = NA,colour ="gray70"),
#         legend.title = element_blank(),
#         legend.position = c(.9,.85))
# gmap
# 
# Data<-data[which(data$NetworkType=="PPH"),]
# library(ggplot2)
# gmap<-ggplot(Data, aes(x = HMI, y =MultiModularity,color=NullModel)) +
#   geom_point()+
#   geom_smooth(method = "lm")+
#   #labs(y = "Multilayer Modularity") +
#   theme(panel.grid = element_blank(),
#         panel.background = element_rect(fill = NA,colour="gray70"),
#         panel.border = element_rect(fill=NA,linetype="solid"),
#         axis.title = element_text(size = 5* 2,face = "bold"), 
#         axis.text = element_text(size = 5 * 2), 
#         text= element_text(family="serif",vjust = 0.5),
#         legend.key = element_rect(fill = NA,colour ="gray70"),
#         legend.title = element_blank(),
#         legend.position = c(.9,.85))
# gmap
# 
# Data<-data[which(data$NetworkType=="PHP"),]
# library(ggplot2)
# gmap<-ggplot(Data, aes(x = HMI, y =MultiModularity,color=NullModel)) +
#   geom_point()+
#   geom_smooth(method = "lm")+
#   #labs(y = "Multilayer Modularity") +
#   theme(panel.grid = element_blank(),
#         panel.background = element_rect(fill = NA,colour="gray70"),
#         panel.border = element_rect(fill=NA,linetype="solid"),
#         axis.title = element_text(size = 5* 2,face = "bold"), 
#         axis.text = element_text(size = 5 * 2), 
#         text= element_text(family="serif",vjust = 0.5),
#         legend.key = element_rect(fill = NA,colour ="gray70"),
#         legend.title = element_blank(),
#         legend.position = c(.9,.895))
# gmap

#==============================================================================#
#------------------------------------------------------------------------------#
#NullModel Analysis for Temporal Network
#==========================Step 1:Inter Data===================================#
TemNet_HMI_monolayer_unweight <- read.csv("HMIModularity/HMI_monolayer_total_TemNet_Inter_NullModel.csv",header = FALSE,sep = ",")
TemNet_Modularity_multilayer_unweight <- read.csv("HMIModularity/Q_multilayer_max_total_TemNet_Inter_NullModel.csv",header = FALSE,sep = ",")
TemNet_Modularity_monolayer_unweight <- read.csv("HMIModularity/Q_mean_max_total_TemNet_Inter_NullModel.csv",header = FALSE,sep = ",")

TemNet_HMI_monolayer_unweight<-unlist(TemNet_HMI_monolayer_unweight,use.names = FALSE)
TemNet_Modularity_multilayer_unweight<-unlist(TemNet_Modularity_multilayer_unweight,use.names = FALSE)
TemNet_Modularity_monolayer_unweight<-unlist(TemNet_Modularity_monolayer_unweight,use.names = FALSE)
NetworkID<-rep(1:10,each=1000)
NetworkType<-rep("TemNet",1000*10)

TemNet_Data<-data.frame(TemNet_HMI_monolayer_unweight,
                     TemNet_Modularity_multilayer_unweight,
                     TemNet_Modularity_monolayer_unweight,NetworkID,NetworkType)
colnames(TemNet_Data)<-c("HMI","MultiModularity","MonoModularity","NetworkID","NetworkType")

TemNet_Data_Inter<-TemNet_Data
#------------------------------------------------------------------------------#
TemNet_Data_Inter$NetworkID<-as.factor(TemNet_Data_Inter$NetworkID)
TemNet_Data_Inter<-cbind(TemNet_Data_Inter,rep(c(6,4,2,4,6,2,6,4,5,2),each=1000))
colnames(TemNet_Data_Inter)<-c("HMI","MultiModularity","MonoModularity","NetworkID","NetworkType","LayerNum")
TemNet_Data_Inter$LayerNum<-as.factor(TemNet_Data_Inter$LayerNum)
TemNet_gmap<-ggplot() +
  geom_point(data = TemNet_Data_Inter,
             aes(x = HMI, 
                 y = MultiModularity, 
                 colour = LayerNum),size = 1)+
  scale_color_manual(
    name = "",
    values = c("2" = "#E6F0FF", "4" = "#99C2FF", "5" = "#4D94FF","6" = "#0066CC"))+
    #values = c("2" = "#E8F5E9", "4" = "#A5D6A7", "5" = "#66BB6A","6" = "#2E7D32"))+
  geom_smooth(method = "lm",
              data = TemNet_Data_Inter,
              aes(x = HMI,
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
        legend.position = c(.343,.95),
        #legend.position = "none",
        legend.direction = "horizontal",
        plot.tag = element_text(size = 15, face = 'bold'))+
  guides(color = guide_legend(title = "Number of layer",title.position = "left",))
TemNet_gmap

ggsave(filename = "TemNet_HMI_MultilayerModularity.tif", device="tiff",width = 5, height = 5,plot = TemNet_gmap,units = "in", dpi = 600)
#------------------------------------------------------------------------------#
#Sample_Map.R
# library(cowplot)
# cowplot::plot_grid(PHP_gmap,
#                    PPH_gmap,
#                    TemNet_gmap,
#                    nrow = 1, align = 'hv')
# 
# ggsave('Fig2.pdf', width = 200, height = 180, units = 'mm')
#============================Step 2:Raw Data===================================#
TemNet_HMI_monolayer_unweight <- read.csv("HMIModularity/HMI_monolayer_total_TemNet_Raw.csv",header = FALSE,sep = ",")
TemNet_Modularity_multilayer_unweight <- read.csv("HMIModularity/Q_multilayer_max_total_TemNet_Raw.csv",header = FALSE,sep = ",")
TemNet_Modularity_monolayer_unweight <- read.csv("HMIModularity/Q_mean_max_total_TemNet_Raw.csv",header = FALSE,sep = ",")

TemNet_HMI_monolayer_unweight<-unlist(TemNet_HMI_monolayer_unweight,use.names = FALSE)
TemNet_Modularity_multilayer_unweight<-unlist(TemNet_Modularity_multilayer_unweight,use.names = FALSE)
TemNet_Modularity_monolayer_unweight<-unlist(TemNet_Modularity_monolayer_unweight,use.names = FALSE)
NetworkID<-rep(1:10,each=1)
NetworkType<-rep("TemNet",1*10)

TemNet_Data<-data.frame(TemNet_HMI_monolayer_unweight,
                     TemNet_Modularity_multilayer_unweight,
                     TemNet_Modularity_monolayer_unweight,NetworkID,NetworkType)
colnames(TemNet_Data)<-c("HMI","MultiModularity","MonoModularity","NetworkID","NetworkType")

TemNet_Data_Raw<-TemNet_Data
#------------------------------------------------------------------------------#
#=========================Step 3:Intra Data===================================#
TemNet_HMI_monolayer_unweight <- read.csv("HMIModularity/HMI_monolayer_total_TemNet_Intra_NullModel.csv",header = FALSE,sep = ",")
TemNet_Modularity_multilayer_unweight <- read.csv("HMIModularity/Q_multilayer_max_total_TemNet_Intra_NullModel.csv",header = FALSE,sep = ",")
TemNet_Modularity_monolayer_unweight <- read.csv("HMIModularity/Q_mean_max_total_TemNet_Intra_NullModel.csv",header = FALSE,sep = ",")

TemNet_HMI_monolayer_unweight<-unlist(TemNet_HMI_monolayer_unweight,use.names = FALSE)
TemNet_Modularity_multilayer_unweight<-unlist(TemNet_Modularity_multilayer_unweight,use.names = FALSE)
TemNet_Modularity_monolayer_unweight<-unlist(TemNet_Modularity_monolayer_unweight,use.names = FALSE)
NetworkID<-rep(1:10,each=1000)
NetworkType<-rep("TemNet",1000*10)

TemNet_Data<-data.frame(TemNet_HMI_monolayer_unweight,
                     TemNet_Modularity_multilayer_unweight,
                     TemNet_Modularity_monolayer_unweight,NetworkID,NetworkType)
colnames(TemNet_Data)<-c("HMI","MultiModularity","MonoModularity","NetworkID","NetworkType")

TemNet_Data_Intra<-TemNet_Data
#------------------------------------------------------------------------------#
#=========================Step 4:Hybrid Data===================================#
TemNet_HMI_monolayer_unweight <- read.csv("HMIModularity/HMI_monolayer_total_TemNet_Hybrid_NullModel.csv",header = FALSE,sep = ",")
TemNet_Modularity_multilayer_unweight <- read.csv("HMIModularity/Q_multilayer_max_total_TemNet_Hybrid_NullModel.csv",header = FALSE,sep = ",")
TemNet_Modularity_monolayer_unweight <- read.csv("HMIModularity/Q_mean_max_total_TemNet_Hybrid_NullModel.csv",header = FALSE,sep = ",")

TemNet_HMI_monolayer_unweight<-unlist(TemNet_HMI_monolayer_unweight,use.names = FALSE)
TemNet_Modularity_multilayer_unweight<-unlist(TemNet_Modularity_multilayer_unweight,use.names = FALSE)
TemNet_Modularity_monolayer_unweight<-unlist(TemNet_Modularity_monolayer_unweight,use.names = FALSE)
NetworkID<-rep(1:10,each=1000)
NetworkType<-rep("TemNet",1000*10)

TemNet_Data<-data.frame(TemNet_HMI_monolayer_unweight,
                     TemNet_Modularity_multilayer_unweight,
                     TemNet_Modularity_monolayer_unweight,NetworkID,NetworkType)
colnames(TemNet_Data)<-c("HMI","MultiModularity","MonoModularity","NetworkID","NetworkType")

TemNet_Data_Hybrid<-TemNet_Data
#------------------------------------------------------------------------------#
#==============================================================================#
#Z-Score,(raw-mean(random))/mean(random) or (raw-mean(random))/sd(random)
TemNet_Data_Raw<-cbind(TemNet_Data_Raw,
                       rep(0,length(TemNet_Data_Raw$HMI)),rep(0,length(TemNet_Data_Raw$MultiModularity)),rep(0,length(TemNet_Data_Raw$MonoModularity)),
                       rep(0,length(TemNet_Data_Raw$HMI)),rep(0,length(TemNet_Data_Raw$MultiModularity)),rep(0,length(TemNet_Data_Raw$MonoModularity)),
                       rep(0,length(TemNet_Data_Raw$HMI)),rep(0,length(TemNet_Data_Raw$MultiModularity)),rep(0,length(TemNet_Data_Raw$MonoModularity)))
colnames(TemNet_Data_Raw)<-c("HMI","MultiModularity","MonoModularity","NetworkID","NetworkType",#Raw
                             "HMI1","MultiModularity1","MonoModularity1",#NullModel-change interlayer links
                             "HMI2","MultiModularity2","MonoModularity2",#NullModel-change intralayer links
                             "HMI3","MultiModularity3","MonoModularity3")##NullModel-change interlayer links and intralayer links
count<-0
for (i in unique(TemNet_Data_Inter$NetworkID)) {
  count<-count+1
  HMI1<-TemNet_Data_Inter[which(TemNet_Data_Inter$NetworkID==i),1]
  MultiModularity1<-TemNet_Data_Inter[which(TemNet_Data_Inter$NetworkID==i),2]
  MonoModularity1<-TemNet_Data_Inter[which(TemNet_Data_Inter$NetworkID==i),3]
  TemNet_Data_Raw[count,6]<-(TemNet_Data_Raw[count,1]-mean(HMI1))/sd(HMI1)
  TemNet_Data_Raw[count,7]<-(TemNet_Data_Raw[count,2]-mean(MultiModularity1))/sd(MultiModularity1)
  TemNet_Data_Raw[count,8]<-(TemNet_Data_Raw[count,3]-mean(MonoModularity1))/sd(MonoModularity1)
  
  HMI2<-TemNet_Data_Intra[which(TemNet_Data_Intra$NetworkID==i),1]
  MultiModularity2<-TemNet_Data_Intra[which(TemNet_Data_Intra$NetworkID==i),2]
  MonoModularity2<-TemNet_Data_Intra[which(TemNet_Data_Intra$NetworkID==i),3]
  TemNet_Data_Raw[count,9]<-(TemNet_Data_Raw[count,1]-mean(HMI2))/sd(HMI2)
  TemNet_Data_Raw[count,10]<-(TemNet_Data_Raw[count,2]-mean(MultiModularity2))/sd(MultiModularity2)
  TemNet_Data_Raw[count,11]<-(TemNet_Data_Raw[count,3]-mean(MonoModularity2))/sd(MonoModularity2)
  
  HMI3<-TemNet_Data_Hybrid[which(TemNet_Data_Hybrid$NetworkID==i),1]
  MultiModularity3<-TemNet_Data_Hybrid[which(TemNet_Data_Hybrid$NetworkID==i),2]
  MonoModularity3<-TemNet_Data_Hybrid[which(TemNet_Data_Hybrid$NetworkID==i),3]
  TemNet_Data_Raw[count,12]<-(TemNet_Data_Raw[count,1]-mean(HMI3))/sd(HMI3)
  TemNet_Data_Raw[count,13]<-(TemNet_Data_Raw[count,2]-mean(MultiModularity3))/sd(MultiModularity3)
  TemNet_Data_Raw[count,14]<-(TemNet_Data_Raw[count,3]-mean(MonoModularity3))/sd(MonoModularity3)
}

#------------------------------------------------------------------------------#
#NullModel Analysis for Temporal Network
#==========================Step 1:Inter Data===================================#
SpaNet_HMI_monolayer_unweight <- read.csv("HMIModularity/HMI_monolayer_total_SpaNet_Inter_NullModel.csv",header = FALSE,sep = ",")
SpaNet_Modularity_multilayer_unweight <- read.csv("HMIModularity/Q_multilayer_max_total_SpaNet_Inter_NullModel.csv",header = FALSE,sep = ",")
SpaNet_Modularity_monolayer_unweight <- read.csv("HMIModularity/Q_mean_max_total_SpaNet_Inter_NullModel.csv",header = FALSE,sep = ",")

SpaNet_HMI_monolayer_unweight<-unlist(SpaNet_HMI_monolayer_unweight,use.names = FALSE)
SpaNet_Modularity_multilayer_unweight<-unlist(SpaNet_Modularity_multilayer_unweight,use.names = FALSE)
SpaNet_Modularity_monolayer_unweight<-unlist(SpaNet_Modularity_monolayer_unweight,use.names = FALSE)
NetworkID<-rep(1:9,each=1000)
NetworkType<-rep("SpaNet",1000*9)

SpaNet_Data<-data.frame(SpaNet_HMI_monolayer_unweight,
                        SpaNet_Modularity_multilayer_unweight,
                        SpaNet_Modularity_monolayer_unweight,NetworkID,NetworkType)
colnames(SpaNet_Data)<-c("HMI","MultiModularity","MonoModularity","NetworkID","NetworkType")

SpaNet_Data_Inter<-SpaNet_Data
#------------------------------------------------------------------------------#
library(ggplot2)
SpaNet_Data_Inter$NetworkID<-as.factor(SpaNet_Data_Inter$NetworkID)
#data<-SpaNet_Data_Inter[which(SpaNet_Data_Inter$NetworkID==2),]
SpaNet_gmap<-ggplot() +
  geom_point(data = SpaNet_Data_Inter,
             aes(x = HMI, 
                 y = MultiModularity, 
                 colour = NetworkID),size = 1)+
  geom_smooth(method = "lm",
              data = SpaNet_Data_Inter,
              aes(x = HMI,
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

ggsave(filename = "SpaNet_HMI_MultilayerModularity.tif", device="tiff",width = 5, height = 5,plot = SpaNet_gmap,units = "in", dpi = 600)
#------------------------------------------------------------------------------#
#============================Step 2:Raw Data===================================#
SpaNet_HMI_monolayer_unweight <- read.csv("HMIModularity/HMI_monolayer_total_SpaNet_Raw.csv",header = FALSE,sep = ",")
SpaNet_Modularity_multilayer_unweight <- read.csv("HMIModularity/Q_multilayer_max_total_SpaNet_Raw.csv",header = FALSE,sep = ",")
SpaNet_Modularity_monolayer_unweight <- read.csv("HMIModularity/Q_mean_max_total_SpaNet_Raw.csv",header = FALSE,sep = ",")

SpaNet_HMI_monolayer_unweight<-unlist(SpaNet_HMI_monolayer_unweight,use.names = FALSE)
SpaNet_Modularity_multilayer_unweight<-unlist(SpaNet_Modularity_multilayer_unweight,use.names = FALSE)
SpaNet_Modularity_monolayer_unweight<-unlist(SpaNet_Modularity_monolayer_unweight,use.names = FALSE)
NetworkID<-rep(1:9,each=1)
NetworkType<-rep("SpaNet",1*9)

SpaNet_Data<-data.frame(SpaNet_HMI_monolayer_unweight,
                        SpaNet_Modularity_multilayer_unweight,
                        SpaNet_Modularity_monolayer_unweight,NetworkID,NetworkType)
colnames(SpaNet_Data)<-c("HMI","MultiModularity","MonoModularity","NetworkID","NetworkType")

SpaNet_Data_Raw<-SpaNet_Data
#------------------------------------------------------------------------------#
#=========================Step 3:Intra Data===================================#
SpaNet_HMI_monolayer_unweight <- read.csv("HMIModularity/HMI_monolayer_total_SpaNet_Intra_NullModel.csv",header = FALSE,sep = ",")
SpaNet_Modularity_multilayer_unweight <- read.csv("HMIModularity/Q_multilayer_max_total_SpaNet_Intra_NullModel.csv",header = FALSE,sep = ",")
SpaNet_Modularity_monolayer_unweight <- read.csv("HMIModularity/Q_mean_max_total_SpaNet_Intra_NullModel.csv",header = FALSE,sep = ",")

SpaNet_HMI_monolayer_unweight<-unlist(SpaNet_HMI_monolayer_unweight,use.names = FALSE)
SpaNet_Modularity_multilayer_unweight<-unlist(SpaNet_Modularity_multilayer_unweight,use.names = FALSE)
SpaNet_Modularity_monolayer_unweight<-unlist(SpaNet_Modularity_monolayer_unweight,use.names = FALSE)
NetworkID<-rep(1:9,each=1000)
NetworkType<-rep("SpaNet",1000*9)

SpaNet_Data<-data.frame(SpaNet_HMI_monolayer_unweight,
                        SpaNet_Modularity_multilayer_unweight,
                        SpaNet_Modularity_monolayer_unweight,NetworkID,NetworkType)
colnames(SpaNet_Data)<-c("HMI","MultiModularity","MonoModularity","NetworkID","NetworkType")

SpaNet_Data_Intra<-SpaNet_Data
#------------------------------------------------------------------------------#
#=========================Step 4:Hybrid Data===================================#
SpaNet_HMI_monolayer_unweight <- read.csv("HMIModularity/HMI_monolayer_total_SpaNet_Hybrid_NullModel.csv",header = FALSE,sep = ",")
SpaNet_Modularity_multilayer_unweight <- read.csv("HMIModularity/Q_multilayer_max_total_SpaNet_Hybrid_NullModel.csv",header = FALSE,sep = ",")
SpaNet_Modularity_monolayer_unweight <- read.csv("HMIModularity/Q_mean_max_total_SpaNet_Hybrid_NullModel.csv",header = FALSE,sep = ",")

SpaNet_HMI_monolayer_unweight<-unlist(SpaNet_HMI_monolayer_unweight,use.names = FALSE)
SpaNet_Modularity_multilayer_unweight<-unlist(SpaNet_Modularity_multilayer_unweight,use.names = FALSE)
SpaNet_Modularity_monolayer_unweight<-unlist(SpaNet_Modularity_monolayer_unweight,use.names = FALSE)
NetworkID<-rep(1:9,each=1000)
NetworkType<-rep("SpaNet",1000*9)

SpaNet_Data<-data.frame(SpaNet_HMI_monolayer_unweight,
                        SpaNet_Modularity_multilayer_unweight,
                        SpaNet_Modularity_monolayer_unweight,NetworkID,NetworkType)
colnames(SpaNet_Data)<-c("HMI","MultiModularity","MonoModularity","NetworkID","NetworkType")

SpaNet_Data_Hybrid<-SpaNet_Data
#------------------------------------------------------------------------------#
#==============================================================================#
#Z-Score,(raw-mean(random))/mean(random) or (raw-mean(random))/sd(random)
SpaNet_Data_Raw<-cbind(SpaNet_Data_Raw,
                       rep(0,length(SpaNet_Data_Raw$HMI)),rep(0,length(SpaNet_Data_Raw$MultiModularity)),rep(0,length(SpaNet_Data_Raw$MonoModularity)),
                       rep(0,length(SpaNet_Data_Raw$HMI)),rep(0,length(SpaNet_Data_Raw$MultiModularity)),rep(0,length(SpaNet_Data_Raw$MonoModularity)),
                       rep(0,length(SpaNet_Data_Raw$HMI)),rep(0,length(SpaNet_Data_Raw$MultiModularity)),rep(0,length(SpaNet_Data_Raw$MonoModularity)))
colnames(SpaNet_Data_Raw)<-c("HMI","MultiModularity","MonoModularity","NetworkID","NetworkType",#Raw
                             "HMI1","MultiModularity1","MonoModularity1",#NullModel-change interlayer links
                             "HMI2","MultiModularity2","MonoModularity2",#NullModel-change intralayer links
                             "HMI3","MultiModularity3","MonoModularity3")##NullModel-change interlayer links and intralayer links
count<-0
for (i in unique(SpaNet_Data_Inter$NetworkID)) {
  count<-count+1
  HMI1<-SpaNet_Data_Inter[which(SpaNet_Data_Inter$NetworkID==i),1]
  MultiModularity1<-SpaNet_Data_Inter[which(SpaNet_Data_Inter$NetworkID==i),2]
  MonoModularity1<-SpaNet_Data_Inter[which(SpaNet_Data_Inter$NetworkID==i),3]
  SpaNet_Data_Raw[count,6]<-(SpaNet_Data_Raw[count,1]-mean(HMI1))/sd(HMI1)
  SpaNet_Data_Raw[count,7]<-(SpaNet_Data_Raw[count,2]-mean(MultiModularity1))/sd(MultiModularity1)
  SpaNet_Data_Raw[count,8]<-(SpaNet_Data_Raw[count,3]-mean(MonoModularity1))/sd(MonoModularity1)
  
  HMI2<-SpaNet_Data_Intra[which(SpaNet_Data_Intra$NetworkID==i),1]
  MultiModularity2<-SpaNet_Data_Intra[which(SpaNet_Data_Intra$NetworkID==i),2]
  MonoModularity2<-SpaNet_Data_Intra[which(SpaNet_Data_Intra$NetworkID==i),3]
  SpaNet_Data_Raw[count,9]<-(SpaNet_Data_Raw[count,1]-mean(HMI2))/sd(HMI2)
  SpaNet_Data_Raw[count,10]<-(SpaNet_Data_Raw[count,2]-mean(MultiModularity2))/sd(MultiModularity2)
  SpaNet_Data_Raw[count,11]<-(SpaNet_Data_Raw[count,3]-mean(MonoModularity2))/sd(MonoModularity2)
  
  HMI3<-SpaNet_Data_Hybrid[which(SpaNet_Data_Hybrid$NetworkID==i),1]
  MultiModularity3<-SpaNet_Data_Hybrid[which(SpaNet_Data_Hybrid$NetworkID==i),2]
  MonoModularity3<-SpaNet_Data_Hybrid[which(SpaNet_Data_Hybrid$NetworkID==i),3]
  SpaNet_Data_Raw[count,12]<-(SpaNet_Data_Raw[count,1]-mean(HMI3))/sd(HMI3)
  SpaNet_Data_Raw[count,13]<-(SpaNet_Data_Raw[count,2]-mean(MultiModularity3))/sd(MultiModularity3)
  SpaNet_Data_Raw[count,14]<-(SpaNet_Data_Raw[count,3]-mean(MonoModularity3))/sd(MonoModularity3)
}

#------------------------------------------------------------------------------#
#=====================================Significance analysis====================#
#use Data_Raw and Data_Inter

SignResult<-matrix(0,length(Data_Raw$NetworkID),3)
#HMI显著性分析
count<-0
for (i in Data_Raw$NetworkID) {
  Analysis_data<-Data_Inter[which(Data_Inter$NetworkID==i),1]
  Fn<-ecdf(Analysis_data)
  #plot(Fn)
  count<-count+1
  SignResult[count,1]<-i
  SignResult[count,2]<-Fn(Data_Raw[count,1])
  
}
SignResult[,3]<-"label"
SignResult[which(SignResult[,2]>0.975),3]<-">0.975"
SignResult[which(SignResult[,2]<0.025),3]<-"<0.025"
SignResult[which(SignResult[,3]=='label'),3]<-"0.025-0.975"
SignResult<-as.data.frame(SignResult)
colnames(SignResult)<-c("NetworkID","Value","Label")

SignResult$NetworkID<-as.numeric(SignResult$NetworkID)
PHP_SignResult<-SignResult[which(SignResult$NetworkID<=87),]
PPH_SignResult<-SignResult[which(SignResult$NetworkID>87),]
#------------------------------------------------------------------------------#
TemNet_SignResult<-matrix(0,length(TemNet_Data_Raw$NetworkID),3)
#HMI显著性分析
count<-0
for (i in TemNet_Data_Raw$NetworkID) {
  Analysis_data<-TemNet_Data_Inter[which(TemNet_Data_Inter$NetworkID==i),1]
  Fn<-ecdf(Analysis_data)
  #plot(Fn)
  count<-count+1
  TemNet_SignResult[count,1]<-i
  TemNet_SignResult[count,2]<-Fn(TemNet_Data_Raw[count,1])
  
}
TemNet_SignResult[,3]<-"label"
TemNet_SignResult[which(TemNet_SignResult[,2]>0.975),3]<-">0.975"
TemNet_SignResult[which(TemNet_SignResult[,2]<0.025),3]<-"<0.025"
TemNet_SignResult[which(TemNet_SignResult[,3]=='label'),3]<-"0.025-0.975"
TemNet_SignResult<-as.data.frame(TemNet_SignResult)
colnames(TemNet_SignResult)<-c("NetworkID","Value","Label")

TemNet_SignResult$Label<-factor(TemNet_SignResult$Label,levels = c(">0.975", "0.025-0.975"))

TemNet_SignResult_counts <- data.frame(
  label = c(">0.975", "0.025-0.975"),
  count = c(10, 0)  
)
#------------------------------------------------------------------------------#
SpaNet_SignResult<-matrix(0,length(SpaNet_Data_Raw$NetworkID),3)
#HMI显著性分析
count<-0
for (i in SpaNet_Data_Raw$NetworkID) {
  Analysis_data<-SpaNet_Data_Inter[which(SpaNet_Data_Inter$NetworkID==i),1]
  Fn<-ecdf(Analysis_data)
  #plot(Fn)
  count<-count+1
  SpaNet_SignResult[count,1]<-i
  SpaNet_SignResult[count,2]<-Fn(SpaNet_Data_Raw[count,1])
  
}
SpaNet_SignResult[,3]<-"label"
SpaNet_SignResult[which(SpaNet_SignResult[,2]>0.975),3]<-">0.975"
SpaNet_SignResult[which(SpaNet_SignResult[,2]<0.025),3]<-"<0.025"
SpaNet_SignResult[which(SpaNet_SignResult[,3]=='label'),3]<-"0.025-0.975"
SpaNet_SignResult<-as.data.frame(SpaNet_SignResult)
colnames(SpaNet_SignResult)<-c("NetworkID","Value","Label")

SpaNet_SignResult$Label<-factor(SpaNet_SignResult$Label,levels = c(">0.975", "0.025-0.975"))
#------------------------------------------------------------------------------#
library(ggplot2)
gmap<-ggplot(PHP_SignResult, aes(x = Label)) +
  geom_bar(fill = "skyblue", color = "black",width = 0.5,  # 单个柱子的宽度
           position = position_dodge(width = 0.5)) +  # fill为填充色，color为边框色
  geom_text(
    aes(label = after_stat(count)),  # 使用stat计算频数
    stat = "count",                  # 指定统计方式为频数
    vjust = -0.5,                    # 标签垂直位置（负值=柱子上方）
    family = "serif", color = "black", size = 4)+
  scale_y_continuous(breaks = seq(0, 45, by = 15))+
  scale_x_discrete(name = "",labels = c(">0.975" = "Significant", "0.025-0.975" = "Not significant"))+
  labs(x='',y = 'Count',tag = 'a',subtitle = 'Plant-herbivore/host-parasitoid network') +
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
gmap
ggsave(filename = "PHP_SignCount.tif", device="tiff",width = 5, height = 5,plot = gmap,units = "in", dpi = 600)

gmap<-ggplot(PPH_SignResult, aes(x = Label)) +
  geom_bar(fill = "skyblue", color = "black",width = 0.5,  # 单个柱子的宽度
           position = position_dodge(width = 0.5)) +  # fill为填充色，color为边框色
  geom_text(
    aes(label = after_stat(count)),  # 使用stat计算频数
    stat = "count",                  # 指定统计方式为频数
    vjust = -0.5,                    # 标签垂直位置（负值=柱子上方）
    family = "serif", color = "black", size = 4)+
  scale_y_continuous(breaks = c(0,5,10,15,20,25),  # 非等距刻度
                     labels = c("0", "5", "10", "15", "20", "25"))+
  scale_x_discrete(name = "",labels = c(">0.975" = "Significant", "0.025-0.975" = "Not significant"))+
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
gmap
ggsave(filename = "PPH_SignCount.tif", device="tiff",width = 5, height = 5,plot = gmap,units = "in", dpi = 600)

# gmap<-ggplot(TemNet_SignResult, aes(x = Label)) +
#   geom_bar(fill = "skyblue", color = "black") +  # fill为填充色，color为边框色
#   geom_text(
#     aes(label = after_stat(count)),  # 使用stat计算频数
#     stat = "count",                  # 指定统计方式为频数
#     vjust = -0.5,                    # 标签垂直位置（负值=柱子上方）
#     family = "serif", color = "black", size = 4)+
#   labs(x='',y = '',tag = 'c',subtitle = 'Temporal network') +
#   theme(panel.grid = element_blank(),
#         panel.background = element_rect(fill = NA,colour="gray70"),
#         panel.border = element_rect(fill=NA,linetype="solid"),
#         axis.title = element_text(size = 5* 2,face = "bold"), 
#         axis.text = element_text(size = 5 * 2), 
#         text= element_text(family="serif",vjust = 0.5),
#         legend.key = element_rect(fill = NA,colour ="gray70"),
#         legend.title = element_blank(), 
#         legend.position = "none",
#         plot.tag = element_text(size = 15, face = 'bold'))
# gmap

gmap<-ggplot(TemNet_SignResult_counts, aes(x = label, y = count)) +
  geom_col(fill = "skyblue", color = "black",width = 0.5,  # 单个柱子的宽度
           position = position_dodge(width = 0.5)  ) +
  geom_text(
    aes(label = count),  # 使用stat计算频数
    vjust = -0.5,                    # 标签垂直位置（负值=柱子上方）
    family = "serif", color = "black", size = 4)+
  labs(x='',y = 'Count',tag = 'c',subtitle = 'Temporal network') +
  scale_y_continuous(breaks = seq(0, 10, by = 2))+
  scale_x_discrete(name = "",labels = c(">0.975" = "Significant", "0.025-0.975" = "Not significant"))+
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
gmap
ggsave(filename = "TemNet_SignCount.tif", device="tiff",width = 5, height = 5,plot = gmap,units = "in", dpi = 600)

gmap<-ggplot(SpaNet_SignResult, aes(x = Label)) +
  geom_bar(fill = "skyblue", color = "black",width = 0.5,  # 单个柱子的宽度
           position = position_dodge(width = 0.5)) +  # fill为填充色，color为边框色
  geom_text(
    aes(label = after_stat(count)),  # 使用stat计算频数
    stat = "count",                  # 指定统计方式为频数
    vjust = -0.5,                    # 标签垂直位置（负值=柱子上方）
    family = "serif", color = "black", size = 4)+
  scale_y_continuous(breaks = c(0,2,4,6,8,10))+
  scale_x_discrete(name = "",labels = c(">0.975" = "Significant", "0.025-0.975" = "Not significant"))+
  labs(x='',y = '',tag = 'd',subtitle = 'Spatial network') +
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
gmap
ggsave(filename = "SpaNet_SignCount.tif", device="tiff",width = 5, height = 5,plot = gmap,units = "in", dpi = 600)
#------------------------------------------------------------------------------#
#===========================Standardized Raw HMI MultiModularity===============#
Data<-rbind(Data_Raw,TemNet_Data_Raw,SpaNet_Data_Raw)
# data<-Data[which(Data$NetworkType=="PPH"),]
# model<-lm(MultiModularity~HMI,data = data)
# summary(model)
# model<-lm(MultiModularity1~HMI1,data = data)
# summary(model)
# model<-lm(MultiModularity2~HMI2,data = data)
# summary(model)
# model<-lm(MultiModularity3~HMI3,data = data)
# summary(model)
# 
# data<-Data[which(Data$NetworkType=="PHP"),]
# model<-lm(MultiModularity~HMI,data = data)
# summary(model)
# model<-lm(MultiModularity1~HMI1,data = data)
# summary(model)
# model<-lm(MultiModularity2~HMI2,data = data)
# summary(model)
# model<-lm(MultiModularity3~HMI3,data = data)
# summary(model)
# 
# data<-Data[which(Data$NetworkType=="TemNet"),]
# #data<-data[-c(1,10),]
# model<-lm(MultiModularity~HMI,data = data)
# summary(model)
# model<-lm(MultiModularity1~HMI1,data = data)
# summary(model)
# model<-lm(MultiModularity2~HMI2,data = data)
# summary(model)
# model<-lm(MultiModularity3~HMI3,data = data)
# summary(model)

# data<-TemNet_Data_Raw[2:10,]
# model<-lm(MultiModularity3~HMI3,data = data)
# summary(model)
# ggplot(data, aes(x = HMI3, y =MultiModularity3)) +
#   geom_point()+
#   geom_smooth(method = "lm")

gmap<-ggplot(Data, aes(x = HMI1, y =MultiModularity1,color=NetworkType)) +
  geom_point()+
  geom_smooth(method = "lm")+
  labs(y = "Standardized Multilayer Modularity",x='',subtitle = "NullModel:shuffle interlayer links",tag = 'a') +
  theme(panel.grid = element_blank(),
        panel.background = element_rect(fill = NA,colour="gray70"),
        panel.border = element_rect(fill=NA,linetype="solid"),
        axis.title = element_text(size = 5* 2,face = "bold"), 
        axis.text = element_text(size = 5 * 2), 
        text= element_text(family="serif",vjust = 0.5),
        legend.key = element_rect(fill = NA,colour ="gray70"),
        legend.title = element_blank(), 
        legend.position = c(.10,.85),
        plot.tag = element_text(size = 15, face = 'bold'))
gmap

ggsave(filename = "NullModel1.tif", device="tiff",width = 5, height = 5,plot = gmap,units = "in", dpi = 600)

gmap<-ggplot(Data, aes(x = HMI2, y =MultiModularity2,color=NetworkType)) +
  geom_point()+
  geom_smooth(method = "lm")+
  labs(y = '',x="Standardized Homo-Module Index",subtitle = "NullModel:shuffle intralayer links",tag = 'b') +
  theme(panel.grid = element_blank(),
        panel.background = element_rect(fill = NA,colour="gray70"),
        panel.border = element_rect(fill=NA,linetype="solid"),
        axis.title = element_text(size = 5* 2,face = "bold"), 
        axis.text = element_text(size = 5 * 2), 
        text= element_text(family="serif",vjust = 0.5),
        legend.key = element_rect(fill = NA,colour ="gray70"),
        legend.title = element_blank(), 
        legend.position = c(.11,.85),
        plot.tag = element_text(size = 15, face = 'bold'))
gmap
ggsave(filename = "NullModel2.tif", device="tiff",width = 5, height = 5,plot = gmap,units = "in", dpi = 600)

gmap<-ggplot(Data, aes(x = HMI3, y =MultiModularity3,color=NetworkType)) +
  geom_point()+
  geom_smooth(method = "lm")+
  labs(y = '',x='',subtitle = "NullModel:shuffle both interlayer links and intralayer links",tag = 'c') +
  theme(panel.grid = element_blank(),
        panel.background = element_rect(fill = NA,colour="gray70"),
        panel.border = element_rect(fill=NA,linetype="solid"),
        axis.title = element_text(size = 5* 2,face = "bold"), 
        axis.text = element_text(size = 5 * 2), 
        text= element_text(family="serif",vjust = 0.5),
        legend.key = element_rect(fill = NA,colour ="gray70"),
        legend.title = element_blank(), 
        legend.position = c(.11,.85),
        plot.tag = element_text(size = 15, face = 'bold'))
gmap
ggsave(filename = "NullModel3.tif", device="tiff",width = 5, height = 5,plot = gmap,units = "in", dpi = 600)
#------------------------------------------------------------------------------#

Data1<-as.data.frame(matrix(0,126*3,4))
Data1[1:126,1]<-Data$MultiModularity1
Data1[127:(126*2),1]<-Data$MultiModularity2
Data1[253:(126*3),1]<-Data$MultiModularity3

Data1[1:126,2]<-Data$HMI1
Data1[127:(126*2),2]<-Data$HMI2
Data1[253:(126*3),2]<-Data$HMI3

Data1[1:126,3]<-"Null model 1"
Data1[127:(126*2),3]<-"Null model 2"
Data1[253:(126*3),3]<-"Null model 3"

Data1[1:126,4]<-Data$NetworkType
Data1[127:(126*2),4]<-Data$NetworkType
Data1[253:(126*3),4]<-Data$NetworkType

colnames(Data1)<-c("MultiModularity","HMI","NullModel","NetworkType")

DATA<-Data1[which(Data1$NetworkType=='PHP'),]
gmap<-ggplot(DATA, aes(x = HMI, y =MultiModularity,color=NullModel)) +
  geom_point()+
  geom_smooth(method = "lm")+
  labs(y = "Standardized Multilayer Modularity",x='',subtitle = "Plant-herbivore/host-parasitoid network",tag = 'a') +
  theme(panel.grid = element_blank(),
        panel.background = element_rect(fill = NA,colour="gray70"),
        panel.border = element_rect(fill=NA,linetype="solid"),
        axis.title = element_text(size = 5* 2,face = "bold"), 
        axis.text = element_text(size = 5 * 2), 
        text= element_text(family="serif",vjust = 0.5),
        legend.key = element_rect(fill = NA,colour ="gray70"),
        legend.title = element_blank(), 
        legend.position = c(.13,.89),
        plot.tag = element_text(size = 15, face = 'bold'))
gmap
ggsave(filename = "PHPNullModel.tif", device="tiff",width = 5, height = 5,plot = gmap,units = "in", dpi = 600)

DATA<-Data1[which(Data1$NetworkType=='PPH'),]
gmap<-ggplot(DATA, aes(x = HMI, y =MultiModularity,color=NullModel)) +
  geom_point()+
  geom_smooth(method = "lm")+
  labs(y = "",x='',subtitle = "Pollinator-plant-herbivore network",tag = 'b') +
  theme(panel.grid = element_blank(),
        panel.background = element_rect(fill = NA,colour="gray70"),
        panel.border = element_rect(fill=NA,linetype="solid"),
        axis.title = element_text(size = 5* 2,face = "bold"), 
        axis.text = element_text(size = 5 * 2), 
        text= element_text(family="serif",vjust = 0.5),
        legend.key = element_rect(fill = NA,colour ="gray70"),
        legend.title = element_blank(), 
        legend.position = c(.13,.89),
        plot.tag = element_text(size = 15, face = 'bold'))
gmap
ggsave(filename = "PPHNullModel.tif", device="tiff",width = 5, height = 5,plot = gmap,units = "in", dpi = 600)

DATA<-Data1[which(Data1$NetworkType=='TemNet'),]
gmap<-ggplot(DATA, aes(x = HMI, y =MultiModularity,color=NullModel)) +
  geom_point()+
  geom_smooth(method = "lm")+
  labs(y = "Standardized Multilayer Modularity",x='Standardized Homo-Module Index',subtitle = "Temporal network",tag = 'c') +
  theme(panel.grid = element_blank(),
        panel.background = element_rect(fill = NA,colour="gray70"),
        panel.border = element_rect(fill=NA,linetype="solid"),
        axis.title = element_text(size = 5* 2,face = "bold"), 
        axis.text = element_text(size = 5 * 2), 
        text= element_text(family="serif",vjust = 0.5),
        legend.key = element_rect(fill = NA,colour ="gray70"),
        legend.title = element_blank(), 
        legend.position = c(.13,.89),
        plot.tag = element_text(size = 15, face = 'bold'))
gmap
ggsave(filename = "TemNetNullModel.tif", device="tiff",width = 5, height = 5,plot = gmap,units = "in", dpi = 600)

DATA<-Data1[which(Data1$NetworkType=='SpaNet'),]
gmap<-ggplot(DATA, aes(x = HMI, y =MultiModularity,color=NullModel)) +
  geom_point()+
  geom_smooth(method = "lm")+
  labs(y = "",x='Standardized Homo-Module Index',subtitle = "Spatial network",tag = 'd') +
  theme(panel.grid = element_blank(),
        panel.background = element_rect(fill = NA,colour="gray70"),
        panel.border = element_rect(fill=NA,linetype="solid"),
        axis.title = element_text(size = 5* 2,face = "bold"), 
        axis.text = element_text(size = 5 * 2), 
        text= element_text(family="serif",vjust = 0.5),
        legend.key = element_rect(fill = NA,colour ="gray70"),
        legend.title = element_blank(), 
        legend.position = c(.13,.89),
        plot.tag = element_text(size = 15, face = 'bold'))
gmap
ggsave(filename = "SpaNetNullModel.tif", device="tiff",width = 5, height = 5,plot = gmap,units = "in", dpi = 600)
#==========================Relative contribution===============================#
library(glmm.hp)
library(car)
data<-Data[which(Data$NetworkType=="PPH"),]
model<-lm(MultiModularity1~HMI1,data = data)
summary(model)

model<-lm(MultiModularity2~HMI2,data = data)
summary(model)
model<-lm(MultiModularity2~MonoModularity2,data = data)
model<-lm(MultiModularity2~HMI2+MonoModularity2,data = data)
vif(model)
cor(data$HMI2,data$MultiModularity2)
summary(model)
glmm.hp(model)

model<-lm(MultiModularity3~HMI3,data = data)
summary(model)
model<-lm(MultiModularity3~MonoModularity3,data = data)
vif(model)
cor(data$HMI3,data$MultiModularity3)
summary(model)
glmm.hp(model)

#
data<-Data[which(Data$NetworkType=="PHP"),]
data<-data[-which(is.na(data$MonoModularity2)==1),]
model<-lm(MultiModularity1~HMI1,data = data)
summary(model)

model<-lm(MultiModularity2~HMI2,data = data)
summary(model)
model<-lm(MultiModularity2~MonoModularity2,data = data)
vif(model)
cor(data$HMI2,data$MonoModularity2)
summary(model)
glmm.hp(model)

model<-lm(MultiModularity3~HMI3,data = data)
summary(model)
model<-lm(MultiModularity3~MonoModularity3,data = data)
vif(model)
cor(data$HMI3,data$MonoModularity3)
summary(model)
glmm.hp(model)

#
data<-Data[which(Data$NetworkType=="TemNet"),]
model<-lm(MultiModularity1~HMI1,data = data)
summary(model)
model<-lm(MultiModularity2~HMI2,data = data)
summary(model)
model<-lm(MultiModularity2~MonoModularity2,data = data)
model<-lm(MultiModularity2~HMI2+MonoModularity2,data = data)
model<-lm(MultiModularity2~HMI2+MonoModularity2+HMI2:MonoModularity2,data = data)
vif(model)
cor(data$HMI2,data$MonoModularity2)
summary(model)
glmm.hp(model)

model<-lm(MultiModularity3~HMI3,data = data)
summary(model)
model<-lm(MultiModularity3~MonoModularity3,data = data)
model<-lm(MultiModularity3~HMI3+MonoModularity3,data = data)
model<-lm(MultiModularity3~HMI3+MonoModularity3+HMI3:MonoModularity3,data = data)
vif(model)
cor(data$HMI3,data$MonoModularity3)
summary(model)
glmm.hp(model)
#
data<-Data[which(Data$NetworkType=="SpaNet"),]
model<-lm(MultiModularity1~HMI1,data = data)
summary(model)
model<-lm(MultiModularity2~HMI2,data = data)
summary(model)
model<-lm(MultiModularity2~HMI2+MonoModularity2,data = data)
model<-lm(MultiModularity2~HMI2+MonoModularity2+HMI2:MonoModularity2,data = data)
vif(model)
cor(data$HMI2,data$MonoModularity2)
summary(model)
glmm.hp(model)
model<-lm(MultiModularity3~HMI3,data = data)
summary(model)
model<-lm(MultiModularity3~HMI3+MonoModularity3,data = data)
model<-lm(MultiModularity3~HMI3+MonoModularity3+HMI3:MonoModularity3,data = data)
vif(model)
cor(data$HMI3,data$MonoModularity3)
summary(model)
glmm.hp(model)
