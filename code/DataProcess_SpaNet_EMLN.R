library(emln)
view_emln()#查看该包中的所有网络信息
#==============================================================================#
#筛选spatial network
Spatial_network<-search_emln(multilayer_network_type = "Spatial")
Spatial_network_ID<-Spatial_network$network_id

for (ID in Spatial_network_ID) {
  Spatial_network_01<-load_emln(ID)
  Spatial_network_01<-Spatial_network_01$extended_ids
  
  #==============================================================================#
  node_from<-NULL
  for (i in unique(Spatial_network_01$layer_from)) {
    layer_data<-Spatial_network_01[which(Spatial_network_01$layer_from==i),]
    node_from<-c(node_from,unique(layer_data$node_from))
  }
  node_from_ID<-unique(node_from)
  frequency_data <- as.data.frame(matrix(0,length(node_from_ID),2))
  colnames(frequency_data) <- c("nodefromID", "count")
  frequency_data[,1]<-node_from_ID
  for (j in 1:length(node_from_ID)) {
    frequency_data[j,2]<-length(which(node_from==node_from_ID[j]))
  }
  node_from_ID<-frequency_data[which(frequency_data$count==length(unique(Spatial_network_01$layer_from))),1]
  #==============================================================================#
  node_to<-NULL
  for (i in unique(Spatial_network_01$layer_to)) {
    layer_data<-Spatial_network_01[which(Spatial_network_01$layer_to==i),]
    node_to<-c(node_to,unique(layer_data$node_to))
  }
  node_to_ID<-unique(node_to)
  frequency_data <- as.data.frame(matrix(0,length(node_to_ID),2))
  colnames(frequency_data) <- c("nodetoID", "count")
  frequency_data[,1]<-node_to_ID
  for (j in 1:length(node_to_ID)) {
    frequency_data[j,2]<-length(which(node_to==node_to_ID[j]))
  }
  node_to_ID<-frequency_data[which(frequency_data$count==length(unique(Spatial_network_01$layer_to))),1]
  #==============================================================================#
  if (length(node_from_ID)>0 & length(node_to_ID)>0){
    for (layer in unique(Spatial_network_01$layer_from)) {
      layer_data<-Spatial_network_01[which(Spatial_network_01$layer_from==layer & Spatial_network_01$layer_to==layer),]
      Spatial_network_dataframe<-as.data.frame(matrix(0,length(node_from_ID),length(node_to_ID)))
      row.names(Spatial_network_dataframe)<-node_from_ID
      colnames(Spatial_network_dataframe)<-node_to_ID
      node_from_ID<-as.character(node_from_ID)
      node_to_ID<-as.character(node_to_ID)
      
      for (node_from in node_from_ID) {
        for (node_to in  node_to_ID) {
          index<-which(layer_data$node_from==node_from & layer_data$node_to==node_to)
          if (length(index)>0){
            Spatial_network_dataframe[node_from,node_to]<-1
          }
        }
      }
      
      Spatial_network_dataframe<-as.matrix(Spatial_network_dataframe)
      Spatial_network_dataframe[which(Spatial_network_dataframe>1)]<-1
      Spatial_network_dataframe<-as.data.frame(Spatial_network_dataframe)
      
      row.names(Spatial_network_dataframe)<-paste0("sp_r_",formatC(1:dim(Spatial_network_dataframe)[1], flag = '0', width = 3))
      colnames(Spatial_network_dataframe)<-paste0("sp_c_",formatC(1:dim(Spatial_network_dataframe)[2], flag = '0', width = 3))
      
      Txt_name<-paste0("HMIModularity/01_Data/SpatialNetwork/","Spatial_",formatC(ID, flag = '0', width = 2),"_layer_",formatC(layer, flag = '0', width = 2),".txt")
      write.table (Spatial_network_dataframe, file =Txt_name, sep =" ", row.names =TRUE, col.names =TRUE, quote =TRUE)
      CSV_name<-paste0("HMIModularity/01_Data/SpatialNetwork/","Spatial_",formatC(ID, flag = '0', width = 2),"_layer_",formatC(layer, flag = '0', width = 2),".csv")
      write.csv(Spatial_network_dataframe, CSV_name, quote = TRUE)
      
    }
  }
  
}


