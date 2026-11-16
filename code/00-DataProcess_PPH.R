#Data process for PPH tripartite networks
#PPH:pollinator_plant_herbivore
#unweighted network
#Select connector species(plants) that connect both pollinator and herbivore
#at least 5 connector species
#==============================================================================#
PPH_Total<-read.csv("pollinator_plant_herbivore.csv",header = TRUE)

PPH_Total[which(PPH_Total$herbivore=="ge.48" & PPH_Total$network_number==5),3]<-"he.48"
PPH_Total[which(PPH_Total$herbivore=="pl.15" & PPH_Total$network_number==7),3]<-"he.15"

Txt_name_PP<-paste0("PP_",formatC(1:length(unique(PPH_Total$network_number)), flag = '0', width = 2),".txt")
Txt_name_PH<-paste0("PH_",formatC(1:length(unique(PPH_Total$network_number)), flag = '0', width = 2),".txt")

for (network_number in 1:length(unique((PPH_Total$network_number)))) {
  
  PPH_01<-PPH_Total[which(PPH_Total$network_number==network_number),]
  DeleteRow<-which(PPH_01$pollinator=="" | PPH_01$herbivore=="")
  if ( length(DeleteRow)>0){
    PPH_01<-PPH_01[-DeleteRow,]
  }
  #　Check Data
  # unique(PPH_01$pollinator)
  # unique(PPH_01$plant)
  # unique(PPH_01$herbivore)
  #----------------------------------------------------------------------------#
  #构造PP空数据集
  PP_data_frame<-as.data.frame(matrix(0,nrow = length(unique(PPH_01$plant)),
                                        ncol = length(unique(PPH_01$pollinator))))
  row.names(PP_data_frame)<-unique(PPH_01$plant)
  colnames(PP_data_frame)<-unique(PPH_01$pollinator)
  #构造PH空数据集
  PH_data_frame<-as.data.frame(matrix(0,nrow = length(unique(PPH_01$plant)),
                                        ncol = length(unique(PPH_01$herbivore))))
  row.names(PH_data_frame)<-unique(PPH_01$plant)
  colnames(PH_data_frame)<-unique(PPH_01$herbivore)
  #----------------------------------------------------------------------------#
  #空数据集填充
  for (i in unique(PPH_01$plant)) {
    for (j in unique(PPH_01$pollinator)) {
      index<-which(PPH_01$plant==i & PPH_01$pollinator==j)
      if (length(index)>0){
        PP_data_frame[i,j]<-length(index)
      }
    }
  }
  #sum(PP_data_frame)
  
  for (i in unique(PPH_01$plant)) {
    for (j in unique(PPH_01$herbivore)) {
      index<-which(PPH_01$plant==i & PPH_01$herbivore==j)
      if (length(index)>0){
        PH_data_frame[i,j]<-length(index)
      }
    }
  }
  #sum(PH_data_frame)
  #----------------------------------------------------------------------------#
  #Transform into an unweighted network
  PP_data_frame<-as.matrix(PP_data_frame)
  PP_data_frame[which(PP_data_frame>1)]<-1
  PP_data_frame<-as.data.frame(PP_data_frame)
  
  PH_data_frame<-as.matrix(PH_data_frame)
  PH_data_frame[which(PH_data_frame>1)]<-1
  PH_data_frame<-as.data.frame(PH_data_frame)
  #----------------------------------------------------------------------------#
  write.table (PP_data_frame, file =Txt_name_PP[network_number], sep =" ", row.names =TRUE, col.names =TRUE, quote =TRUE)
  write.table (PH_data_frame, file =Txt_name_PH[network_number], sep =" ", row.names =TRUE, col.names =TRUE, quote =TRUE)
}
#==============================================================================#
