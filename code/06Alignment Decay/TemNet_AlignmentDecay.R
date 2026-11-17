################################################################################
#Temporal network#
get_signif_stars <- function(p) {
  # 处理 NA 值，如果是 NA 则返回空字符串
  ifelse(is.na(p), "",
         ifelse(p < 0.001, "***",
                ifelse(p < 0.01, "**",
                       ifelse(p < 0.05, "*",
                              ifelse(p < 0.1, ".", " "))))
  )
}
safe_regression1 <- function(data) {
  # 尝试拟合模型
  model <- try(lm(MultiModularity ~ MonoHMI, data = data), silent = TRUE)
  
  # 错误处理：如果模型失败或系数为 NA
  if (inherits(model, "try-error")) {
    return(data.frame(
      slope = NA, std_error = NA, t_value = NA, p_value = NA,
      ci_lower = NA, ci_upper = NA
    ))
  }
  
  # 提取系数表
  coefs <- summary(model)$coefficients
  
  # 检查 MonoHMI 是否存在（防止模型降维等情况）
  if (!"MonoHMI" %in% rownames(coefs)) {
    return(data.frame(
      slope = NA, std_error = NA, t_value = NA, p_value = NA,
      ci_lower = NA, ci_upper = NA
    ))
  }
  
  # 提取斜率
  slope_val <- coefs["MonoHMI", "Estimate"]
  
  # 如果斜率本身就是 NA（例如数据完全共线性）
  if (is.na(slope_val)) {
    return(data.frame(
      slope = NA, std_error = NA, t_value = NA, p_value = NA,
      ci_lower = NA, ci_upper = NA
    ))
  }
  
  # 正常提取
  conf_int <- confint(model, "MonoHMI", level = 0.95)
  
  data.frame(
    slope = slope_val,
    std_error = coefs["MonoHMI", "Std. Error"],
    t_value = coefs["MonoHMI", "t value"],
    p_value = coefs["MonoHMI", "Pr(>|t|)"],
    ci_lower = conf_int[1],
    ci_upper = conf_int[2]
  )
}
safe_regression2 <- function(data) {
  # 尝试拟合模型
  model <- try(lm(MultiModularity ~ MultiHMI, data = data), silent = TRUE)
  
  # 错误处理：如果模型失败或系数为 NA
  if (inherits(model, "try-error")) {
    return(data.frame(
      slope = NA, std_error = NA, t_value = NA, p_value = NA,
      ci_lower = NA, ci_upper = NA
    ))
  }
  
  # 提取系数表
  coefs <- summary(model)$coefficients
  
  # 检查 MonoHMI 是否存在（防止模型降维等情况）
  if (!"MultiHMI" %in% rownames(coefs)) {
    return(data.frame(
      slope = NA, std_error = NA, t_value = NA, p_value = NA,
      ci_lower = NA, ci_upper = NA
    ))
  }
  
  # 提取斜率
  slope_val <- coefs["MultiHMI", "Estimate"]
  
  # 如果斜率本身就是 NA（例如数据完全共线性）
  if (is.na(slope_val)) {
    return(data.frame(
      slope = NA, std_error = NA, t_value = NA, p_value = NA,
      ci_lower = NA, ci_upper = NA
    ))
  }
  
  # 正常提取
  conf_int <- confint(model, "MultiHMI", level = 0.95)
  
  data.frame(
    slope = slope_val,
    std_error = coefs["MultiHMI", "Std. Error"],
    t_value = coefs["MultiHMI", "t value"],
    p_value = coefs["MultiHMI", "Pr(>|t|)"],
    ci_lower = conf_int[1],
    ci_upper = conf_int[2]
  )
}

#------------------------------------------------------------------------------#
dir_path <- "E:/Hosky's OneDrive/OneDrive/桌面/MATLAB/Hosky/2025-Modularity/04_NewHMI/04_Revise1/02_Result/"

# 建立模式字典
patterns <- list(
  HMI_monolayer = "^HMI2_mean_monolayer_total_TemNet_Random_Inter_NullModel_.*\\.csv$",
  HMI_multilayer = "^HMI2_mean_multilayer_total_TemNet_Random_Inter_NullModel_.*\\.csv$",
  Modularity_monolayer = "^Q_monolayer_max_total_TemNet_Random_Inter_NullModel_.*\\.csv$",
  Modularity_multilayer = "^Q_multilayer_max_total_TemNet_Random_Inter_NullModel_.*\\.csv$"
)

# 批量运行并存入列表
results <- lapply(patterns, function(p) {
  files <- list.files(path = dir_path, pattern = p, full.names = TRUE)
  do.call(cbind, lapply(files, function(f) as.matrix(read.csv(f, header = FALSE, sep = ","))))
})

# 将列表中的结果分别提取为你需要的变量名
TemNet_HMI_monolayer_unweight <- as.data.frame(results$HMI_monolayer)
TemNet_HMI_multilayer_unweight <- as.data.frame(results$HMI_multilayer)
TemNet_Modularity_monolayer_unweight <- as.data.frame(results$Modularity_monolayer)
TemNet_Modularity_multilayer_unweight <- as.data.frame(results$Modularity_multilayer)
#------------------------------------------------------------------------------#
TemNet_HMI_monolayer_unweight<-unlist(TemNet_HMI_monolayer_unweight,use.names = FALSE)
TemNet_HMI_multilayer_unweight<-unlist(TemNet_HMI_multilayer_unweight,use.names = FALSE)
TemNet_Modularity_multilayer_unweight<-unlist(TemNet_Modularity_multilayer_unweight,use.names = FALSE)
TemNet_Modularity_monolayer_unweight<-unlist(TemNet_Modularity_monolayer_unweight,use.names = FALSE)
NetworkID<-rep(1:(length(TemNet_HMI_monolayer_unweight)/100),each=100)
NetworkType<-rep("TemNet",100*(length(TemNet_HMI_monolayer_unweight)/100))

TemNet_Data<-data.frame(TemNet_HMI_monolayer_unweight,
                        TemNet_HMI_multilayer_unweight,
                        TemNet_Modularity_multilayer_unweight,
                        TemNet_Modularity_monolayer_unweight,NetworkID,NetworkType)
colnames(TemNet_Data)<-c("MonoHMI","MultiHMI","MultiModularity","MonoModularity","NetworkID","NetworkType")

# DelectIndex <- which(TemNet_Data$MonoHMI==0)
# TemNet_Data <- TemNet_Data[-DelectIndex,]

library(dplyr)
library(broom)
library(ggplot2)

EffectsizeResult <- TemNet_Data %>%
  group_by(NetworkID) %>%
  do(safe_regression1(.)) %>%
  ungroup() %>%
  mutate(
    stars = get_signif_stars(p_value),
    label_x = ifelse(is.na(ci_upper), NA, ci_upper + (abs(ci_upper - ci_lower) * 0.1))
  )

EffectsizeResult <- EffectsizeResult %>%
  mutate(sort_order = order(-slope, na.last = TRUE)) %>% 
  mutate(
    NetworkID_Label = sprintf("%02d", NetworkID),
    NetworkID_Factor = factor(NetworkID_Label, 
                              levels = NetworkID_Label[sort_order]))
EffectsizeResult<-cbind(EffectsizeResult,rep(2:10, each = 5))
colnames(EffectsizeResult)<-c("NetworkID","slope","std_error","t_value","p_value","ci_lower","ci_upper","stars","label_x","sort_order","NetworkID_Label","NetworkID_Factor","LayerNum")

##
# gmap<-ggplot() +
#   geom_point(data = EffectsizeResult,
#              aes(x = LayerNum, 
#                  y = slope),size = 1)+
#   geom_smooth(method = "lm",
#               data = EffectsizeResult,
#               aes(x = LayerNum,
#                   y = slope),
#               color = "black",
#               fill = "gray70",  
#               alpha = 0.3,            
#               level = 0.95,   
#               se = TRUE) +
#   labs(x='Number of layers',y = 'Effect size') +
#   theme(panel.grid = element_blank(),
#         panel.background = element_rect(fill = NA,colour="gray70"),
#         panel.border = element_rect(fill=NA,linetype="solid"),
#         axis.title = element_text(size = 5* 2,face = "bold"), 
#         axis.text = element_text(size = 5 * 2), 
#         text= element_text(family="serif",vjust = 0.5),
#         legend.key = element_rect(fill = NA,color = NA),
#         legend.position = "none")
# gmap
# ggsave(filename = "FigureS5.tif", device="tiff",width = 5, height = 5,plot = gmap,units = "in", dpi = 600)
##

EffectsizeResult$LayerNum <- as.numeric(as.character(EffectsizeResult$LayerNum))
gmap <- ggplot(EffectsizeResult, aes(LayerNum, slope)) +
  geom_point(data = EffectsizeResult,
             aes(x = LayerNum, 
                 y = slope),size = 1.5)+
  # geom_smooth(
  #   aes(colour = "Linear fit"), method = "lm",
  #   formula = y ~ x, se = TRUE, level = 0.95,
  #   linetype = "dashed", fill = "#A34F23", alpha = 0.13
  # ) +
  geom_smooth(
    aes(colour = "Quadratic fit"), method = "lm",
    formula = y ~ x + I(x^2), se = TRUE, level = 0.95,
    fill = "#187378", alpha = 0.15
  ) +
  #stat_summary(fun = mean, geom = "point", shape = 23, size = 1.5,fill = "white", colour = "#263D49") +
  scale_colour_manual(values = c(
    "Linear fit" = "#A34F23",
    "Quadratic fit" = "#187378")) +
  scale_x_continuous(breaks = 2:10) +
  guides(fill = guide_legend(nrow = 1, byrow = FALSE)) +
  labs(x='Number of layers',y = 'Effect size',colour = NULL) +
  theme(panel.grid = element_blank(),
        panel.background = element_rect(fill = NA,colour="gray70"),
        panel.border = element_rect(fill=NA,linetype="solid"),
        axis.title = element_text(size = 8,face = "bold"), 
        axis.text = element_text(size = 8), 
        text= element_text(family="serif",vjust = 0.5),
        legend.key = element_rect(fill = NA,color = NA),
        #legend.position = c(0.30, 0.85))
        legend.position = "none")

gmap
ggsave(filename = "FigureS5_TemNet_AlignmentDecay2.tif", device="tiff",width = 8, height = 8,plot = gmap,units = "cm", dpi = 600, compression="lzw")
