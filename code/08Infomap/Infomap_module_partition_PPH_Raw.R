PH_file_path <- paste0("HMIModularity/01_Data/PPH_45/PH_",formatC(1:45, flag = '0', width = 2),".txt")
PP_file_path <- paste0("HMIModularity/01_Data/PPH_45/PP_",formatC(1:45, flag = '0', width = 2),".txt")
save_file <- paste0("PPH_",formatC(1:45, flag = '0', width = 2),"_monolayer_module_partition",".txt")

#monolayer networks-------------------------------------------------------------
L_PH_PP_Mean<-NULL
timestart<-Sys.time()
for (i in 1:45) {
  #读取网络数据
  PH <- read.table(PH_file_path[i])
  PH <- as.matrix(PH)
  PP <- read.table(PP_file_path[i])
  PP <- as.matrix(PP)
  
  library(infomapecology)
  library(emln)
  library(bipartite)
  #----------------------------------------------------------------------------#
  PH<- create_monolayer_network(PH, bipartite = T,directed = F, group_names = c('Herbivores','Plants'))
  PH <- run_infomap_monolayer(PH, infomap_executable='Infomap',flow_model = 'undirected',
                               silent=T,trials=100, two_level=T,seed=123)
  
  PH_module <- PH$modules
  PH_H<-PH_module[which(PH_module$node_group=="Plants"),]
  PH_H<-PH_H$module_level1
  PH_L<-PH$L
  #----------------------------------------------------------------------------#
  PP<- create_monolayer_network(PP, bipartite = T, directed = F, group_names = c('Pollinators','Plants'))
  PP <- run_infomap_monolayer(PP, infomap_executable='Infomap',flow_model = 'undirected',
                               silent=T, trials=100, two_level=T, seed=123)
  
  PP_module <- PP$modules
  PP_H<-PP_module[which(PP_module$node_group=="Plants"),]
  PP_H<-PP_H$module_level1
  PP_L<-PP$L
  #----------------------------------------------------------------------------#
  PH_PP_module <- rbind(PH_H,PP_H)
  L_PH_PP_Mean <- rbind(L_PH_PP_Mean,c(PH_L,PP_L,(PH_L+PP_L)/2))
  write.table(PH_PP_module, file = save_file[i], sep = "\t", row.names = FALSE, col.names = FALSE)
}
timeend<-Sys.time()
runningtime<-timeend-timestart
runningtime #Time difference of 1.194848 mins
#Calculated HMI used MATLAB Code HomoMI()

#multilayer networks------------------------------------------------------------
save_file <- paste0("PPH_",formatC(1:45, flag = '0', width = 2),"_multilayer_module_partition",".txt")

L_multilayer<-NULL
timestart<-Sys.time()
for (i in 1:45) {
  #读取网络数据
  PH <- read.table(PH_file_path[i])
  PH <- as.matrix(PH)
  PP <- read.table(PP_file_path[i])
  PP <- as.matrix(PP)
  
  library(infomapecology)
  library(emln)
  library(bipartite)
  #----------------------------------------------------------------------------#
  #interlayer links信息，数据格式为data.frame,第一列为layer_from,第二列为node_from，第三列为layer_to，第四列为node_to，第五列为weight。
  data_interlayer<-data.frame(matrix(0,nrow(PH),5))
  data_interlayer[,1]<-'Herbivory'
  data_interlayer[,3]<-'Pollination'
  data_interlayer[,2]<-row.names(PH)
  data_interlayer[,4]<-row.names(PP)
  data_interlayer[,5]<-rep(1, nrow(PH))
  colnames(data_interlayer)<-c("layer_from","node_from","layer_to","node_to","weight")
  
  #layer信息，数据格式为tbl_df,第一列为layer_id,第二列为layer_name
  library(tibble)
  data_layer<-tibble(layer_id=1:2,
                     layer_name=c('Herbivory','Pollination'))
  
  #nodes信息，数据格式为data.frame,第一列为node_name;第二列为type,指各个节点的类别（比如plant/animal/host/paras）
  data_nodes<-data.frame(matrix(0,nrow(PH),2))
  data_nodes[,1]<-row.names(PH)
  data_nodes[,2]<-"Plants"
  colnames(data_nodes)<-c("node_name","type")
  
  multilayer_network <- create_multilayer_network(list_of_layers = list(PH,PP),
                                                  bipartite = T,
                                                  directed = F, 
                                                  interlayer_links = data_interlayer,
                                                  layer_attributes = data_layer,
                                                  physical_node_attributes = data_nodes )
  
  multilayer_infomap <- run_infomap_multilayer(multilayer_network, 
                                               infomap_executable='Infomap',
                                               flow_model = 'undirected', 
                                               silent = T,
                                               trials = 100, 
                                               seed = 123, 
                                               relax = F,
                                               temporal_network = F)
  
  #----------------------------------------------------------------------------#
  multilayer_module <- multilayer_infomap$modules
  multilayer_module <- multilayer_module[which(multilayer_module$type=="Plants"),]
  multilayer_module <- cbind(multilayer_module[which(multilayer_module$layer_id==1),'module'],
                             multilayer_module[which(multilayer_module$layer_id==2),'module'])
  multilayer_module <- t(multilayer_module)
  
  PH_PP_module <- multilayer_module
  L_multilayer <- rbind(L_multilayer,multilayer_infomap$L)
  write.table(PH_PP_module, file = save_file[i], sep = "\t", row.names = FALSE, col.names = FALSE)
}
timeend<-Sys.time()
runningtime<-timeend-timestart
runningtime #Time difference of 56.84185 secs
#Calculated HMI used MATLAB Code HomoMI()