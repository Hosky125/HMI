TemNet_monolayer_Infomap <- function(file_path, save_file, seed = 123) {
  
  csv_files <- list.files(path = file_path, pattern = "\\.csv$", full.names = TRUE)
  n_files <- length(csv_files)
  
  all_modules <- list()
  all_L_values <- numeric(n_files)
  
  for (i in seq_len(n_files)) {
    T_mat <- read.csv(csv_files[i], header = TRUE,row.names = 1,check.names = FALSE,stringsAsFactors = FALSE)
    T_mat <- as.matrix(T_mat)
    
    T_net <- create_monolayer_network(T_mat, bipartite = TRUE, directed = FALSE, group_names = c('Plants', 'Herbivores'))
    T_net <- run_infomap_monolayer(T_net, infomap_executable = 'Infomap', flow_model = 'undirected',
                                   silent = TRUE, trials = 100, two_level = TRUE, seed = seed)
    
    all_modules[[i]] <- T_net$modules$module_level1
    all_L_values[i] <- T_net$L
  }
  
  T_all_module <- do.call(rbind, all_modules)
  #T_all_module <- T_all_module[, colSums(is.na(T_all_module)) == 0, drop = FALSE]
  mean_L <- mean(all_L_values)
  TemNet_Mean_Row <- c(all_L_values, mean_L)
  
  write.table(T_all_module, file = save_file, sep = "\t", row.names = FALSE, col.names = FALSE)
}

TemNet_multilayer_Infomap <- function(file_path, save_file, seed = 123) {
  
  csv_files <- list.files(path = file_path, pattern = "\\.csv$", full.names = TRUE)
  csv_files <- sort(csv_files) # 确保顺序
  n_layers <- length(csv_files)
  
  T_list <- lapply(csv_files, function(file) {
    as.matrix(read.csv(file, header = TRUE,row.names = 1,check.names = FALSE,stringsAsFactors = FALSE))
  })
  
  layer_nodes <- c(colnames(T_list[[1]]),row.names(T_list[[1]]))
  n_nodes <- length(layer_nodes)
  layer_names <- paste0("T", 1:n_layers)
  
  interlayer_list <- list()
  for (i in 1:(n_layers - 1)) {
    interlayer_list[[i]] <- data.frame(
      layer_from = layer_names[i],
      node_from  = layer_nodes,
      layer_to   = layer_names[i + 1],
      node_to    = layer_nodes,
      weight     = 1,
      stringsAsFactors = FALSE
    )
  }
  data_interlayer <- do.call(rbind, interlayer_list)
  
  data_layer <- tibble(
    layer_id = 1:n_layers,
    layer_name = layer_names
  )
  
  data_nodes <- data.frame(
    node_name = layer_nodes,
    type = "all",
    stringsAsFactors = FALSE
  )
  
  multilayer_network <- create_multilayer_network(
    list_of_layers = T_list,
    bipartite = TRUE,
    directed = TRUE, 
    interlayer_links = data_interlayer,
    layer_attributes = data_layer,
    physical_node_attributes = data_nodes
  )
  
  multilayer_infomap <- run_infomap_multilayer(
    multilayer_network, 
    infomap_executable = 'Infomap',
    flow_model = 'undirected', 
    silent = TRUE,
    trials = 100, 
    seed = seed, 
    relax = FALSE,
    temporal_network = TRUE
  )
  
  multilayer_module <- multilayer_infomap$modules
  multilayer_module <- multilayer_module[which(multilayer_module$type == "all"),]
  
  module_list <- list()
  for (i in 1:n_layers) {
    layer_mod <- multilayer_module %>% 
      filter(layer_id == i) %>%
      arrange(match(node_name, layer_nodes)) %>%
      pull(module)
    
    module_list[[i]] <- layer_mod
  }
  
  T_all_module <- do.call(rbind, module_list)
  #T_all_module <- T_all_module[, colSums(is.na(T_all_module)) == 0, drop = FALSE]
  write.table(T_all_module, file = save_file, sep = "\t", row.names = FALSE, col.names = FALSE)
  
}
#------------------------------------------------------------------------------#
file_path <- paste0("HMIModularity/01_Data/TemNet/Network",formatC(1:10, flag = '0', width = 2))

save_file <- paste0("TemNet",formatC(1:10, flag = '0', width = 2),"_monolayer_module_partition",".txt")
#monolayer networks-------------------------------------------------------------
timestart<-Sys.time()
for (i in 1:10) {
  library(infomapecology)
  library(emln)
  library(bipartite)
  
  TemNet_monolayer_Infomap(file_path = file_path[i], save_file = save_file[i])
}
timeend<-Sys.time()
runningtime<-timeend-timestart
runningtime #Time difference of 39.87669 secs
#Calculated HMI used MATLAB Code HomoMI()


#multilayer networks------------------------------------------------------------
save_file <- paste0("TemNet",formatC(1:10, flag = '0', width = 2),"_multilayer_module_partition",".txt")

timestart<-Sys.time()
for (i in 1:10) {
  library(infomapecology)
  library(emln)
  library(bipartite)
  library(tibble)
  library(dplyr)
  
  TemNet_multilayer_Infomap(file_path = file_path[i], save_file = save_file[i])
}
timeend<-Sys.time()
runningtime<-timeend-timestart
runningtime #Time difference of 36.35065 secs
#Calculated HMI used MATLAB Code HomoMI()