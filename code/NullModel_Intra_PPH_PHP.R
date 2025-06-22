#NUll model for PPH45
#Change intralayer links
#keep the row and column
#==============================================================================#
Txt_name_PP<-paste0("HMIModularity/01_Data/PPH_45/PP_",formatC(1:45, flag = '0', width = 2),".txt")
Txt_name_PH<-paste0("HMIModularity/01_Data/PPH_45/PH_",formatC(1:45, flag = '0', width = 2),".txt")

for (i in 1:45) {
  PP_01<-data.matrix(read.table(Txt_name_PP[i],header = TRUE))
  PH_01<-data.matrix(read.table(Txt_name_PH[i],header = TRUE))
  
  library(vegan)
  #commsim{vegan} Null Model algorithms
  PP_01_null_envir<-nullmodel(PP_01,"quasiswap")
  PP_01_null_total<-simulate(PP_01_null_envir, nsim=1000)
  PH_01_null_envir<-nullmodel(PH_01,"quasiswap")
  PH_01_null_total<-simulate(PH_01_null_envir, nsim=1000)
  
  Txt_name_PP_NullModel<-paste0("HMIModularity/01_Data/PPH_45/PP_",formatC(i:i, flag = '0', width = 2),"_",formatC(1:1000, flag = '0', width = 4),".txt")
  Txt_name_PH_NullModel<-paste0("HMIModularity/01_Data/PPH_45/PH_",formatC(i:i, flag = '0', width = 2),"_",formatC(1:1000, flag = '0', width = 4),".txt")
  for (j in 1:1000) {
    PP_NullModel<-PP_01_null_total[,,j]
    PP_NullModel<-as.data.frame(PP_NullModel)
    write.table (PP_NullModel, file =Txt_name_PP_NullModel[j], sep =" ", row.names =TRUE, col.names =TRUE, quote =TRUE)
    
    PH_NullModel<-PH_01_null_total[,,j]
    PH_NullModel<-as.data.frame(PH_NullModel)
    write.table (PH_NullModel, file =Txt_name_PH_NullModel[j], sep =" ", row.names =TRUE, col.names =TRUE, quote =TRUE)
  }
}

#==============================================================================#
#Null model for HPP87
#Change intralayer links
Txt_name_HP1<-paste0("HMIModularity/01_Data/HPP_87/HP1_",formatC(1:87, flag = '0', width = 2),".txt")
Txt_name_HP2<-paste0("HMIModularity/01_Data/HPP_87/HP2_",formatC(1:87, flag = '0', width = 2),".txt")

for (i in 1:87) {
  HP1_01<-data.matrix(read.table(Txt_name_HP1[i],header = TRUE))
  HP2_01<-data.matrix(read.table(Txt_name_HP2[i],header = TRUE))
  
  library(vegan)
  #commsim{vegan} Null Model algorithms
  HP1_01_null_envir<-nullmodel(HP1_01,"quasiswap")
  HP1_01_null_total<-simulate(HP1_01_null_envir, nsim=1000)
  HP2_01_null_envir<-nullmodel(HP2_01,"quasiswap")
  HP2_01_null_total<-simulate(HP2_01_null_envir, nsim=1000)
  
  Txt_name_HP1_NullModel<-paste0("HMIModularity/01_Data/HPP_87/HP1_",formatC(i:i, flag = '0', width = 2),"_",formatC(1:1000, flag = '0', width = 4),".txt")
  Txt_name_HP2_NullModel<-paste0("HMIModularity/01_Data/HPP_87/HP2_",formatC(i:i, flag = '0', width = 2),"_",formatC(1:1000, flag = '0', width = 4),".txt")
  for (j in 1:1000) {
    HP1_NullModel<-HP1_01_null_total[,,j]
    HP1_NullModel<-as.data.frame(HP1_NullModel)
    write.table (HP1_NullModel, file =Txt_name_HP1_NullModel[j], sep =" ", row.names =TRUE, col.names =TRUE, quote =TRUE)
    
    HP2_NullModel<-HP2_01_null_total[,,j]
    HP2_NullModel<-as.data.frame(HP2_NullModel)
    write.table (HP2_NullModel, file =Txt_name_HP2_NullModel[j], sep =" ", row.names =TRUE, col.names =TRUE, quote =TRUE)
  }
}
