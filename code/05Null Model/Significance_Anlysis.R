# Analysis_data <- c(rep(0.5,1000))
# Fn<-ecdf(Analysis_data)
# plot(Fn)
# Fn(0.5)
# [1] 1
calculate_sign_result <- function(Data_Raw, Data_Inter) {
  SignResult <- data.frame(
    NetworkID = Data_Raw$NetworkID,
    P_lower = rep(NA_real_, nrow(Data_Raw)),
    P_upper = rep(NA_real_, nrow(Data_Raw)),
    P_value = rep(NA_real_, nrow(Data_Raw)),
    Label = rep("Not significant", nrow(Data_Raw))
  )
  
  for (row in seq_len(nrow(Data_Raw))) {
    network_id <- Data_Raw$NetworkID[row]
    observed_hmi <- Data_Raw[[1]][row]
    
    matched_rows <- which(Data_Inter$NetworkID == network_id)
    null_hmi <- Data_Inter[[1]][matched_rows]
    B <- length(null_hmi)
    
    p_lower <- (1 + sum(null_hmi <= observed_hmi)) / (B + 1)
    p_upper <- (1 + sum(null_hmi >= observed_hmi)) / (B + 1)
    
    SignResult$P_lower[row] <- p_lower
    SignResult$P_upper[row] <- p_upper
    SignResult$P_value[row] <- min(1, 2 * min(p_lower, p_upper))
    
    if (p_upper < 0.025) {
      SignResult$Label[row] <- "Significantly higher"
    } else if (p_lower < 0.025) {
      SignResult$Label[row] <- "Significantly lower"
    }
  }
  
  return(SignResult)
}
#=====================================Significance analysis====================#
#use Data_Raw and Data_Inter
#Plant-herbivore/host-parasitoid network#
PHP_HMI_monolayer_unweight <- read.csv("E:/Hosky's OneDrive/OneDrive/桌面/MATLAB/Hosky/2025-Modularity/04_NewHMI/03_Result/Inter1.0/HMI2_mean_monolayer_total_PHP_Inter_NullModel.csv",header = FALSE,sep = ",")
PHP_HMI_multilayer_unweight <- read.csv("E:/Hosky's OneDrive/OneDrive/桌面/MATLAB/Hosky/2025-Modularity/04_NewHMI/03_Result/Inter1.0/HMI2_mean_multilayer_total_PHP_Inter_NullModel.csv",header = FALSE,sep = ",")
PHP_Modularity_multilayer_unweight <- read.csv("E:/Hosky's OneDrive/OneDrive/桌面/MATLAB/Hosky/2025-Modularity/04_NewHMI/03_Result/Inter1.0//Q_multilayer_max_total_PHP_Inter_NullModel.csv",header = FALSE,sep = ",")
PHP_Modularity_monolayer_unweight <- read.csv("E:/Hosky's OneDrive/OneDrive/桌面/MATLAB/Hosky/2025-Modularity/04_NewHMI/03_Result/Inter1.0/Q_monolayer_max_total_PHP_Inter_NullModel.csv",header = FALSE,sep = ",")

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
DeleteID<-c(6,16,22,23,47,48,60)
for (ID in DeleteID) {
  DeleteIDIndex<-which(PHP_Data$NetworkID==ID)
  PHP_Data<-PHP_Data[-DeleteIDIndex,]
}

#Pollinator-plant-herbivore network#
PPH_HMI_monolayer_unweight <- read.csv("E:/Hosky's OneDrive/OneDrive/桌面/MATLAB/Hosky/2025-Modularity/04_NewHMI/03_Result/Inter1.0/HMI2_mean_monolayer_total_PPH_Inter_NullModel.csv",header = FALSE,sep = ",")
PPH_HMI_multilayer_unweight <- read.csv("E:/Hosky's OneDrive/OneDrive/桌面/MATLAB/Hosky/2025-Modularity/04_NewHMI/03_Result/Inter1.0/HMI2_mean_multilayer_total_PPH_Inter_NullModel.csv",header = FALSE,sep = ",")
PPH_Modularity_multilayer_unweight <- read.csv("E:/Hosky's OneDrive/OneDrive/桌面/MATLAB/Hosky/2025-Modularity/04_NewHMI/03_Result/Inter1.0/Q_multilayer_max_total_PPH_Inter_NullModel.csv",header = FALSE,sep = ",")
PPH_Modularity_monolayer_unweight <- read.csv("E:/Hosky's OneDrive/OneDrive/桌面/MATLAB/Hosky/2025-Modularity/04_NewHMI/03_Result/Inter1.0/Q_monolayer_max_total_PPH_Inter_NullModel.csv",header = FALSE,sep = ",")

PPH_HMI_monolayer_unweight<-unlist(PPH_HMI_monolayer_unweight,use.names = FALSE)
PPH_HMI_multilayer_unweight<-unlist(PPH_HMI_multilayer_unweight,use.names = FALSE)
PPH_Modularity_multilayer_unweight<-unlist(PPH_Modularity_multilayer_unweight,use.names = FALSE)
PPH_Modularity_monolayer_unweight<-unlist(PPH_Modularity_monolayer_unweight,use.names = FALSE)
NetworkID<-rep(1:45,each=1000)
NetworkType<-rep("PPH",1000*45)

PPH_Data<-data.frame(PPH_HMI_monolayer_unweight,
                     PPH_HMI_multilayer_unweight,
                     PPH_Modularity_multilayer_unweight,
                     PPH_Modularity_monolayer_unweight,NetworkID,NetworkType)
colnames(PPH_Data)<-c("MonoHMI","MultiHMI","MultiModularity","MonoModularity","NetworkID","NetworkType")

DeleteID<-c(1,3,4,11,12,13,15,16,17,25,28,31,33,34,35,41,42,43)
for (ID in DeleteID) {
  DeleteIDIndex<-which(PPH_Data$NetworkID==ID)
  PPH_Data<-PPH_Data[-DeleteIDIndex,]
}
PPH_Data$NetworkID <- PPH_Data$NetworkID+87

Data_Inter<-rbind(PHP_Data,PPH_Data)
Data_Inter$NetworkID<-as.factor(Data_Inter$NetworkID)

#============================Step 2:Raw Data===================================#
PHP_HMI_monolayer_unweight <- read.csv("E:/Hosky's OneDrive/OneDrive/桌面/MATLAB/Hosky/2025-Modularity/04_NewHMI/03_Result/Inter1.0/HMI_monolayer_total_PHP_Raw.csv",header = FALSE,sep = ",")
PHP_HMI_monolayer_unweight <- PHP_HMI_monolayer_unweight[,6]
PHP_HMI_multilayer_unweight <- read.csv("E:/Hosky's OneDrive/OneDrive/桌面/MATLAB/Hosky/2025-Modularity/04_NewHMI/03_Result/Inter1.0/HMI_multilayer_total_PHP_Raw.csv",header = FALSE,sep = ",")
PHP_HMI_multilayer_unweight <- PHP_HMI_multilayer_unweight[,6]
PHP_Modularity_multilayer_unweight <- read.csv("E:/Hosky's OneDrive/OneDrive/桌面/MATLAB/Hosky/2025-Modularity/04_NewHMI/03_Result/Inter1.0/Q_multilayer_max_total_PHP_Raw.csv",header = FALSE,sep = ",")
PHP_Modularity_monolayer_unweight <- read.csv("E:/Hosky's OneDrive/OneDrive/桌面/MATLAB/Hosky/2025-Modularity/04_NewHMI/03_Result/Inter1.0/Q_monolayer_max_total_PHP_Raw.csv",header = FALSE,sep = ",")

PHP_HMI_monolayer_unweight<-unlist(PHP_HMI_monolayer_unweight,use.names = FALSE)
PHP_HMI_multilayer_unweight<-unlist(PHP_HMI_multilayer_unweight,use.names = FALSE)
PHP_Modularity_multilayer_unweight<-unlist(PHP_Modularity_multilayer_unweight,use.names = FALSE)
PHP_Modularity_monolayer_unweight<-unlist(PHP_Modularity_monolayer_unweight,use.names = FALSE)
NetworkID<-rep(1:87,each=1)
NetworkType<-rep("PHP",1*87)

PHP_Data<-data.frame(PHP_HMI_monolayer_unweight,
                     PHP_HMI_multilayer_unweight,
                     PHP_Modularity_multilayer_unweight,
                     PHP_Modularity_monolayer_unweight,NetworkID,NetworkType)
colnames(PHP_Data)<-c("MonoHMI","MultiHMI","MultiModularity","MonoModularity","NetworkID","NetworkType")
DeleteID<-c(6,16,22,23,47,48,60)
for (ID in DeleteID) {
  DeleteIDIndex<-which(PHP_Data$NetworkID==ID)
  PHP_Data<-PHP_Data[-DeleteIDIndex,]
}

PPH_HMI_monolayer_unweight <- read.csv("E:/Hosky's OneDrive/OneDrive/桌面/MATLAB/Hosky/2025-Modularity/04_NewHMI/03_Result/Inter1.0/HMI_monolayer_total_PPH_Raw.csv",header = FALSE,sep = ",")
PPH_HMI_monolayer_unweight <- PPH_HMI_monolayer_unweight[,6]
PPH_HMI_multilayer_unweight <- read.csv("E:/Hosky's OneDrive/OneDrive/桌面/MATLAB/Hosky/2025-Modularity/04_NewHMI/03_Result/Inter1.0/HMI_multilayer_total_PPH_Raw.csv",header = FALSE,sep = ",")
PPH_HMI_multilayer_unweight <- PPH_HMI_multilayer_unweight[,6]
PPH_Modularity_multilayer_unweight <- read.csv("E:/Hosky's OneDrive/OneDrive/桌面/MATLAB/Hosky/2025-Modularity/04_NewHMI/03_Result/Inter1.0/Q_multilayer_max_total_PPH_Raw.csv",header = FALSE,sep = ",")
PPH_Modularity_monolayer_unweight <- read.csv("E:/Hosky's OneDrive/OneDrive/桌面/MATLAB/Hosky/2025-Modularity/04_NewHMI/03_Result/Inter1.0/Q_monolayer_max_total_PPH_Raw.csv",header = FALSE,sep = ",")

PPH_HMI_monolayer_unweight<-unlist(PPH_HMI_monolayer_unweight,use.names = FALSE)
PPH_HMI_multilayer_unweight<-unlist(PPH_HMI_multilayer_unweight,use.names = FALSE)
PPH_Modularity_multilayer_unweight<-unlist(PPH_Modularity_multilayer_unweight,use.names = FALSE)
PPH_Modularity_monolayer_unweight<-unlist(PPH_Modularity_monolayer_unweight,use.names = FALSE)
NetworkID<-rep(1:45,each=1)
NetworkType<-rep("PPH",1*45)

PPH_Data<-data.frame(PPH_HMI_monolayer_unweight,
                     PPH_HMI_multilayer_unweight,
                     PPH_Modularity_multilayer_unweight,
                     PPH_Modularity_monolayer_unweight,NetworkID,NetworkType)
colnames(PPH_Data)<-c("MonoHMI","MultiHMI","MultiModularity","MonoModularity","NetworkID","NetworkType")
DeleteID<-c(1,3,4,11,12,13,15,16,17,25,28,31,33,34,35,41,42,43)
for (ID in DeleteID) {
  DeleteIDIndex<-which(PPH_Data$NetworkID==ID)
  PPH_Data<-PPH_Data[-DeleteIDIndex,]
}
PPH_Data$NetworkID <- PPH_Data$NetworkID+87

Data_Raw<-rbind(PHP_Data,PPH_Data)
#------------------------------------------------------------------------------#

#HMI显著性分析
SignResult <- calculate_sign_result(Data_Raw, Data_Inter)
PHP_SignResult<-SignResult[which(SignResult$NetworkID<=87),]
PPH_SignResult<-SignResult[which(SignResult$NetworkID>87),]
#------------------------------------------------------------------------------#
#Temporal network#
TemNet_HMI_monolayer_unweight <- read.csv("E:/Hosky's OneDrive/OneDrive/桌面/MATLAB/Hosky/2025-Modularity/04_NewHMI/03_Result/HMI2_mean_monolayer_total_TemNet_Inter_NullModel.csv",header = FALSE,sep = ",")
TemNet_HMI_multilayer_unweight <- read.csv("E:/Hosky's OneDrive/OneDrive/桌面/MATLAB/Hosky/2025-Modularity/04_NewHMI/03_Result/HMI2_mean_multilayer_total_TemNet_Inter_NullModel.csv",header = FALSE,sep = ",")
TemNet_Modularity_multilayer_unweight <- read.csv("E:/Hosky's OneDrive/OneDrive/桌面/MATLAB/Hosky/2025-Modularity/04_NewHMI/03_Result/Q_multilayer_max_total_TemNet_Inter_NullModel.csv",header = FALSE,sep = ",")
TemNet_Modularity_monolayer_unweight <- read.csv("E:/Hosky's OneDrive/OneDrive/桌面/MATLAB/Hosky/2025-Modularity/04_NewHMI/03_Result/Q_monolayer_max_total_TemNet_Inter_NullModel.csv",header = FALSE,sep = ",")

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
TemNet_Data_Inter <- TemNet_Data

TemNet_HMI_monolayer_unweight <- read.csv("E:/Hosky's OneDrive/OneDrive/桌面/MATLAB/Hosky/2025-Modularity/04_NewHMI/03_Result/HMI_monolayer_total_TemNet_Raw.csv",header = FALSE,sep = ",")
TemNet_HMI_monolayer_unweight <- TemNet_HMI_monolayer_unweight[,6]
TemNet_HMI_multilayer_unweight <- read.csv("E:/Hosky's OneDrive/OneDrive/桌面/MATLAB/Hosky/2025-Modularity/04_NewHMI/03_Result/HMI_multilayer_total_TemNet_Raw.csv",header = FALSE,sep = ",")
TemNet_HMI_multilayer_unweight <- TemNet_HMI_multilayer_unweight[,6]
TemNet_Modularity_multilayer_unweight <- read.csv("E:/Hosky's OneDrive/OneDrive/桌面/MATLAB/Hosky/2025-Modularity/04_NewHMI/03_Result/Q_multilayer_max_total_TemNet_Raw.csv",header = FALSE,sep = ",")
TemNet_Modularity_monolayer_unweight <- read.csv("E:/Hosky's OneDrive/OneDrive/桌面/MATLAB/Hosky/2025-Modularity/04_NewHMI/03_Result/Q_monolayer_max_total_TemNet_Raw.csv",header = FALSE,sep = ",")

TemNet_HMI_monolayer_unweight<-unlist(TemNet_HMI_monolayer_unweight,use.names = FALSE)
TemNet_HMI_multilayer_unweight<-unlist(TemNet_HMI_multilayer_unweight,use.names = FALSE)
TemNet_Modularity_multilayer_unweight<-unlist(TemNet_Modularity_multilayer_unweight,use.names = FALSE)
TemNet_Modularity_monolayer_unweight<-unlist(TemNet_Modularity_monolayer_unweight,use.names = FALSE)
NetworkID<-rep(1:10,each=1)
NetworkType<-rep("TemNet",1*10)

TemNet_Data<-data.frame(TemNet_HMI_monolayer_unweight,
                        TemNet_HMI_multilayer_unweight,
                        TemNet_Modularity_multilayer_unweight,
                        TemNet_Modularity_monolayer_unweight,NetworkID,NetworkType)
colnames(TemNet_Data)<-c("MonoHMI","MultiHMI","MultiModularity","MonoModularity","NetworkID","NetworkType")
TemNet_Data_Raw <- TemNet_Data

#HMI显著性分析
TemNet_SignResult <- calculate_sign_result(TemNet_Data_Raw, TemNet_Data_Inter)
# TemNet_SignResult_counts <- data.frame(
#   label = c(">0.975", "0.025-0.975"),
#   count = c(10, 0)  
# )
#------------------------------------------------------------------------------#
#Spatial network#
SpaNet_HMI_monolayer_unweight <- read.csv("E:/Hosky's OneDrive/OneDrive/桌面/MATLAB/Hosky/2025-Modularity/04_NewHMI/03_Result/HMI2_mean_monolayer_total_SpaNet_Inter_NullModel.csv",header = FALSE,sep = ",")
SpaNet_HMI_multilayer_unweight <- read.csv("E:/Hosky's OneDrive/OneDrive/桌面/MATLAB/Hosky/2025-Modularity/04_NewHMI/03_Result/HMI2_mean_multilayer_total_SpaNet_Inter_NullModel.csv",header = FALSE,sep = ",")
SpaNet_Modularity_multilayer_unweight <- read.csv("E:/Hosky's OneDrive/OneDrive/桌面/MATLAB/Hosky/2025-Modularity/04_NewHMI/03_Result//Q_multilayer_max_total_SpaNet_Inter_NullModel.csv",header = FALSE,sep = ",")
SpaNet_Modularity_monolayer_unweight <- read.csv("E:/Hosky's OneDrive/OneDrive/桌面/MATLAB/Hosky/2025-Modularity/04_NewHMI/03_Result/Q_monolayer_max_total_SpaNet_Inter_NullModel.csv",header = FALSE,sep = ",")

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
SpaNet_Data_Inter <- SpaNet_Data

SpaNet_HMI_monolayer_unweight <- read.csv("E:/Hosky's OneDrive/OneDrive/桌面/MATLAB/Hosky/2025-Modularity/04_NewHMI/03_Result/HMI_monolayer_total_SpaNet_Raw.csv",header = FALSE,sep = ",")
SpaNet_HMI_monolayer_unweight <- SpaNet_HMI_monolayer_unweight[,6]
SpaNet_HMI_multilayer_unweight <- read.csv("E:/Hosky's OneDrive/OneDrive/桌面/MATLAB/Hosky/2025-Modularity/04_NewHMI/03_Result/HMI_multilayer_total_SpaNet_Raw.csv",header = FALSE,sep = ",")
SpaNet_HMI_multilayer_unweight <- SpaNet_HMI_multilayer_unweight[,6]
SpaNet_Modularity_multilayer_unweight <- read.csv("E:/Hosky's OneDrive/OneDrive/桌面/MATLAB/Hosky/2025-Modularity/04_NewHMI/03_Result//Q_multilayer_max_total_SpaNet_Raw.csv",header = FALSE,sep = ",")
SpaNet_Modularity_monolayer_unweight <- read.csv("E:/Hosky's OneDrive/OneDrive/桌面/MATLAB/Hosky/2025-Modularity/04_NewHMI/03_Result/Q_monolayer_max_total_SpaNet_Raw.csv",header = FALSE,sep = ",")

SpaNet_HMI_monolayer_unweight<-unlist(SpaNet_HMI_monolayer_unweight,use.names = FALSE)
SpaNet_HMI_multilayer_unweight<-unlist(SpaNet_HMI_multilayer_unweight,use.names = FALSE)
SpaNet_Modularity_multilayer_unweight<-unlist(SpaNet_Modularity_multilayer_unweight,use.names = FALSE)
SpaNet_Modularity_monolayer_unweight<-unlist(SpaNet_Modularity_monolayer_unweight,use.names = FALSE)
NetworkID<-rep(1:9,each=1)
NetworkType<-rep("SpaNet",1*9)

SpaNet_Data<-data.frame(SpaNet_HMI_monolayer_unweight,
                        SpaNet_HMI_multilayer_unweight,
                        SpaNet_Modularity_multilayer_unweight,
                        SpaNet_Modularity_monolayer_unweight,NetworkID,NetworkType)
colnames(SpaNet_Data)<-c("MonoHMI","MultiHMI","MultiModularity","MonoModularity","NetworkID","NetworkType")
SpaNet_Data_Raw <- SpaNet_Data

#HMI显著性分析
SpaNet_SignResult <- calculate_sign_result(SpaNet_Data_Raw, SpaNet_Data_Inter)
#SpaNet_SignResult$Label<-factor(SpaNet_SignResult$Label,levels = c(">0.975", "0.025-0.975"))
#------------------------------------------------------------------------------#
library(ggplot2)

#table(PHP_SignResult$Label)
gmap<-ggplot(PHP_SignResult, aes(x = Label)) +
  geom_bar(fill = "skyblue", color = "black",width = 0.5,  # 单个柱子的宽度
           position = position_dodge(width = 0.5)) +  # fill为填充色，color为边框色
  geom_text(
    aes(label = after_stat(count)),  # 使用stat计算频数
    stat = "count",                  # 指定统计方式为频数
    vjust = -0.5,                    # 标签垂直位置（负值=柱子上方）
    family = "serif", color = "black", size = 4)+
  scale_y_continuous(breaks = seq(0, 45, by = 15))+
  scale_x_discrete(name = "",labels = c("Significantly higher" = "Significant", "0.025-0.975" = "Not significant"))+
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
ggsave(filename = "R2_3_PHP_SignCount.tif", device="tiff",width = 5, height = 5,plot = gmap,units = "in", dpi = 600, compression="lzw")

table(PPH_SignResult$Label)
PPH_SignResult_counts <- data.frame(
  label = c("Significantly higher", "Not significant"),
  count = c(0, 27)
)
# gmap<-ggplot(PPH_SignResult, aes(x = Label)) +
#   geom_bar(fill = "skyblue", color = "black",width = 0.5,  # 单个柱子的宽度
#            position = position_dodge(width = 0.5)) +  # fill为填充色，color为边框色
#   geom_text(
#     aes(label = after_stat(count)),  # 使用stat计算频数
#     stat = "count",                  # 指定统计方式为频数
#     vjust = -0.5,                    # 标签垂直位置（负值=柱子上方）
#     family = "serif", color = "black", size = 4)+
#   scale_y_continuous(breaks = c(0,5,10,15,20,25),  # 非等距刻度
#                      labels = c("0", "5", "10", "15", "20", "25"))+
#   scale_x_discrete(name = "",labels = c(">0.975" = "Significant", "0.025-0.975" = "Not significant"))+
#   labs(x='',y = '',tag = 'b',subtitle = 'Pollinator-plant-herbivore network') +
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
gmap<-ggplot(PPH_SignResult_counts, aes(x = label, y = count)) +
  geom_col(fill = "skyblue", color = "black",width = 0.5,  # 单个柱子的宽度
           position = position_dodge(width = 0.5)  ) +
  geom_text(
    aes(label = count),  # 使用stat计算频数
    vjust = -0.5,                    # 标签垂直位置（负值=柱子上方）
    family = "serif", color = "black", size = 4)+
  labs(x='',y = '',tag = 'b',subtitle = 'Pollinator-plant-herbivore network') +
  scale_y_continuous(breaks = c(0,5,10,15,20,25),  # 非等距刻度
                    labels = c("0", "5", "10", "15", "20", "25"))+
  scale_x_discrete(name = "",labels = c("Significantly higher" = "Significant", "Not significant" = "Not significant"))+
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
ggsave(filename = "R2_3_PPH_SignCount.tif", device="tiff",width = 5, height = 5,plot = gmap,units = "in", dpi = 600, compression="lzw")

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


table(TemNet_SignResult$Label)
TemNet_SignResult_counts <- data.frame(
  label = c("Significantly higher", "Not significant"),
  count = c(10, 0)
)
gmap<-ggplot(TemNet_SignResult_counts, aes(x = label, y = count)) +
  geom_col(fill = "skyblue", color = "black",width = 0.5,  # 单个柱子的宽度
           position = position_dodge(width = 0.5)  ) +
  geom_text(
    aes(label = count),  # 使用stat计算频数
    vjust = -0.5,                    # 标签垂直位置（负值=柱子上方）
    family = "serif", color = "black", size = 4)+
  labs(x='',y = 'Count',tag = 'c',subtitle = 'Temporal network') +
  scale_y_continuous(breaks = seq(0, 10, by = 2))+
  scale_x_discrete(name = "",labels = c("Significantly higher" = "Significant", "Not significant" = "Not significant"))+
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
ggsave(filename = "R2_3_TemNet_SignCount.tif", device="tiff",width = 5, height = 5,plot = gmap,units = "in", dpi = 600, compression="lzw")

gmap<-ggplot(SpaNet_SignResult, aes(x = Label)) +
  geom_bar(fill = "skyblue", color = "black",width = 0.5,  # 单个柱子的宽度
           position = position_dodge(width = 0.5)) +  # fill为填充色，color为边框色
  geom_text(
    aes(label = after_stat(count)),  # 使用stat计算频数
    stat = "count",                  # 指定统计方式为频数
    vjust = -0.5,                    # 标签垂直位置（负值=柱子上方）
    family = "serif", color = "black", size = 4)+
  scale_y_continuous(breaks = c(0,2,4,6,8,10))+
  scale_x_discrete(name = "",labels = c("Significantly higher" = "Significant", "Not significant" = "Not significant"))+
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
ggsave(filename = "R2_3_SpaNet_SignCount.tif", device="tiff",width = 5, height = 5,plot = gmap,units = "in", dpi = 600, compression="lzw")
#------------------------------------------------------------------------------#