HP1_file_path <- paste0("HMIModularity/01_Data/PHP_87/HP1_",formatC(1:87, flag = '0', width = 2),".txt")
HP2_file_path <- paste0("HMIModularity/01_Data/PHP_87/HP2_",formatC(1:87, flag = '0', width = 2),".txt")
save_file <- paste0("PHP_",formatC(1:87, flag = '0', width = 2),"_monolayer_module_partition",".txt")

#monolayer networks-------------------------------------------------------------
L_HP1_HP2_Mean<-NULL
timestart<-Sys.time()
for (i in 1:87) {
  #读取网络数据
  HP1 <- read.table(HP1_file_path[i])
  HP1 <- as.matrix(HP1)
  HP2 <- read.table(HP2_file_path[i])
  HP2 <- as.matrix(HP2)
  
  library(infomapecology)
  library(emln)
  library(bipartite)
  #----------------------------------------------------------------------------#
  HP1<- create_monolayer_network(HP1, bipartite = T,directed = F, group_names = c('Plants','Herbivores'))
  HP1 <- run_infomap_monolayer(HP1, infomap_executable='Infomap',flow_model = 'undirected',
                               silent=T,trials=100, two_level=T,seed=123)
  
  HP1_module <- HP1$modules
  HP1_H<-HP1_module[which(HP1_module$node_group=="Herbivores"),]
  HP1_H<-HP1_H$module_level1
  HP1_L<-HP1$L
  #----------------------------------------------------------------------------#
  HP2<- create_monolayer_network(HP2, bipartite = T, directed = F, group_names = c('Parasitoids','Herbivores'))
  HP2 <- run_infomap_monolayer(HP2, infomap_executable='Infomap',flow_model = 'undirected',
                               silent=T, trials=100, two_level=T, seed=123)
  
  HP2_module <- HP2$modules
  HP2_H<-HP2_module[which(HP2_module$node_group=="Herbivores"),]
  HP2_H<-HP2_H$module_level1
  HP2_L<-HP2$L
  #----------------------------------------------------------------------------#
  HP1_HP2_module <- rbind(HP1_H,HP2_H)
  L_HP1_HP2_Mean <- rbind(L_HP1_HP2_Mean,c(HP1_L,HP2_L,(HP1_L+HP2_L)/2))
  write.table(HP1_HP2_module, file = save_file[i], sep = "\t", row.names = FALSE, col.names = FALSE)
}
timeend<-Sys.time()
runningtime<-timeend-timestart
runningtime #Time difference of 2.497471 mins
#Calculated HMI used MATLAB Code HomoMI()

#multilayer networks------------------------------------------------------------
save_file <- paste0("PHP_",formatC(1:87, flag = '0', width = 2),"_multilayer_module_partition",".txt")

L_multilayer<-NULL
timestart<-Sys.time()
for (i in 1:87) {
  #读取网络数据
  HP1 <- read.table(HP1_file_path[i])
  HP1 <- as.matrix(HP1)
  HP2 <- read.table(HP2_file_path[i])
  HP2 <- as.matrix(HP2)
 
  library(infomapecology)
  library(emln)
  library(bipartite)
  #----------------------------------------------------------------------------#
  #interlayer links信息，数据格式为data.frame,第一列为layer_from,第二列为node_from，第三列为layer_to，第四列为node_to，第五列为weight。
  data_interlayer<-data.frame(matrix(0,nrow(HP1),5))
  data_interlayer[,1]<-'Herbivory'
  data_interlayer[,3]<-'Parasitoidism'
  data_interlayer[,2]<-row.names(HP1)
  data_interlayer[,4]<-row.names(HP2)
  data_interlayer[,5]<-rep(1, nrow(HP1))
  colnames(data_interlayer)<-c("layer_from","node_from","layer_to","node_to","weight")
  
  #layer信息，数据格式为tbl_df,第一列为layer_id,第二列为layer_name
  library(tibble)
  data_layer<-tibble(layer_id=1:2,
                     layer_name=c('Herbivory','Parasitoidism'))
  
  #nodes信息，数据格式为data.frame,第一列为node_name;第二列为type,指各个节点的类别（比如plant/animal/host/paras）
  data_nodes<-data.frame(matrix(0,nrow(HP1),2))
  data_nodes[,1]<-row.names(HP1)
  data_nodes[,2]<-"Herbivores"
  colnames(data_nodes)<-c("node_name","type")
  
  multilayer_network <- create_multilayer_network(list_of_layers = list(HP1,HP2),
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
  multilayer_module <- multilayer_module[which(multilayer_module$type=="Herbivores"),]
  multilayer_module <- cbind(multilayer_module[which(multilayer_module$layer_id==1),'module'],
                             multilayer_module[which(multilayer_module$layer_id==2),'module'])
  multilayer_module <- t(multilayer_module)
  
  HP1_HP2_module <- multilayer_module
  L_multilayer <- rbind(L_multilayer,multilayer_infomap$L)
  write.table(HP1_HP2_module, file = save_file[i], sep = "\t", row.names = FALSE, col.names = FALSE)
}
timeend<-Sys.time()
runningtime<-timeend-timestart
runningtime #Time difference of 1.964768 mins
#Calculated HMI used MATLAB Code HomoMI()