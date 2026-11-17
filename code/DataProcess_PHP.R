#Data process for HPP tripartite networks
#HPP:Plant_host_parasitoids
#unweighted network
#Select connector species(host) that connect both Plant and parasitoids
#at least 5 connector species
#==============================================================================#
HPP_Total<-read.csv("Plant_host_parasitoids.csv",header = TRUE)

Txt_name_HP1<-paste0("HP1_",formatC(1:length(unique(HPP_Total$network_number)), flag = '0', width = 2),".txt")
Txt_name_HP2<-paste0("HP2_",formatC(1:length(unique(HPP_Total$network_number)), flag = '0', width = 2),".txt")

for (network_number in 1:length(unique((HPP_Total$network_number)))) {
  
  HPP_01<-HPP_Total[which(HPP_Total$network_number==network_number),]
  DeleteRow<-which(HPP_01$plant=="" | HPP_01$parasitoid=="")
  if ( length(DeleteRow)>0){
    HPP_01<-HPP_01[-DeleteRow,]
  }
  
  #　Check Data
  # unique(HPP_01$plant)
  # unique(HPP_01$host)
  # unique(HPP_01$parasitoid)
  #----------------------------------------------------------------------------#
  #构造PP空数据集
  HP1_data_frame<-as.data.frame(matrix(0,nrow = length(unique(HPP_01$host)),
                                         ncol = length(unique(HPP_01$plant))))
  row.names(HP1_data_frame)<-unique(HPP_01$host)
  colnames(HP1_data_frame)<-unique(HPP_01$plant)
  #构造PH空数据集
  HP2_data_frame<-as.data.frame(matrix(0,nrow = length(unique(HPP_01$host)),
                                         ncol = length(unique(HPP_01$parasitoid))))
  row.names(HP2_data_frame)<-unique(HPP_01$host)
  colnames(HP2_data_frame)<-unique(HPP_01$parasitoid)
  #----------------------------------------------------------------------------#
  #空数据集填充
  for (i in unique(HPP_01$host)) {
    for (j in unique(HPP_01$plant)) {
      index<-which(HPP_01$host==i & HPP_01$plant==j)
      if (length(index)>0){
        HP1_data_frame[i,j]<-length(index)
      }
    }
  }
  #sum(HP1_data_frame)
  
  for (i in unique(HPP_01$host)) {
    for (j in unique(HPP_01$parasitoid)) {
      index<-which(HPP_01$host==i & HPP_01$parasitoid==j)
      if (length(index)>0){
        HP2_data_frame[i,j]<-length(index)
      }
    }
  }
  #sum(HP2_data_frame)
  #----------------------------------------------------------------------------#
  #Transform into an unweighted network
  HP1_data_frame<-as.matrix(HP1_data_frame)
  HP1_data_frame[which(HP1_data_frame>1)]<-1
  HP1_data_frame<-as.data.frame(HP1_data_frame)
  
  HP2_data_frame<-as.matrix(HP2_data_frame)
  HP2_data_frame[which(HP2_data_frame>1)]<-1
  HP2_data_frame<-as.data.frame(HP2_data_frame)
  #----------------------------------------------------------------------------#
  write.table (HP1_data_frame, file =Txt_name_HP1[network_number], sep =" ", row.names =TRUE, col.names =TRUE, quote =TRUE)
  write.table (HP2_data_frame, file =Txt_name_HP2[network_number], sep =" ", row.names =TRUE, col.names =TRUE, quote =TRUE)
}
#==============================================================================#