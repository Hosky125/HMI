
NetPath <- paste0("HMIModularity/01_Data/TemNet/Network",formatC(1:10, flag = '0', width = 2),"/")

for (ID in 1:10) {
  csv_names <- list.files(path = NetPath[ID],pattern = "\\.csv$",full.names = FALSE)
  layer <- length(csv_names)
  for (i in 1:layer){
    eachlayerpath <- paste0(NetPath[ID],csv_names[i])
    TemNet_layer_data <- read.csv(eachlayerpath,header = FALSE,row.names = NULL,sep = ",")
    TemNet_layer_data <- TemNet_layer_data[-1,-1]
    TemNet_layer_data <- as.matrix(TemNet_layer_data)
    TemNet_layer_data <- matrix(as.integer(TemNet_layer_data), nrow = nrow(TemNet_layer_data))
    
    library(vegan)
    #commsim{vegan} Null Model algorithms
    TemNet_layer_data_null_envir<-nullmodel(TemNet_layer_data,"quasiswap")
    TemNet_layer_data_null_total<-simulate(TemNet_layer_data_null_envir, nsim=1000)
    
    Txt_name_NullModel<-paste0("HMIModularity/01_Data/TemNet_Intra_NullModel/Network",formatC(ID:ID, flag = '0', width = 2),"/","L",formatC(i:i, flag = '0', width = 2),"_",formatC(1:1000, flag = '0', width = 4),".txt")
    for (j in 1:1000) {
      NullModel<-TemNet_layer_data_null_total[,,j]
      NullModel<-as.data.frame(NullModel)
      write.table (NullModel, file =Txt_name_NullModel[j], sep =" ", row.names =TRUE, col.names =TRUE, quote =TRUE)
    }
    
  }
}
