#Step1：数据处理
#first interlayer link strength
#Hervías-Parejo S, Tur C, Heleno R, et al. 
#Species functional traits and abundance as drivers of multiplex ecological networks:first empirical quantification of inter-layer edge weights[J]. 
#Proceedings of the Royal Society B, 2020, 287(1939): 20202127.

data<-read.csv2("HMIModularity/01_Data/FirstInterLink/data.csv",header = TRUE,sep = ";")

#Calculate intralayer links weight
#In the pollination layer,pij/bj,
#pij is the number of individuals of bird species j on which pollen grains of the species i was detected
#bj is the number of birds of species j
#In the seed-dispersal layer,pij/bj,
#pij is the number of individuals of bird species j on which seeds of the species i were detected
#bj is the number of birds of species j

#Island:San Cristóbal (SC),pollination-bird-seed dispersal 49*9*32
SC_data<-data[which(data$Island=="San Cristobal"),]
SC_data<-SC_data[which(SC_data$Sample==1),]

##pollination layer
SC_data_Pollination<-SC_data[which(SC_data$pollen_grains>10),]
SC_Poll_Layer_DATA<-as.data.frame(matrix(0,
                                         length(unique(SC_data_Pollination$disperser.species)),
                                         length(unique(SC_data_Pollination$plant_sp))))
colnames(SC_Poll_Layer_DATA)<-unique(SC_data_Pollination$plant_sp)
row.names(SC_Poll_Layer_DATA)<-unique(SC_data_Pollination$disperser.species)
SC_Poll_Bird_Total<-c(38,74,69,214,105,340,12,28,77)

count<-0
for (bird_name in unique(SC_data_Pollination$disperser.species)) {
  count<-count+1
  data1<-SC_data_Pollination[which(SC_data_Pollination$disperser.species==bird_name),]
  for (plant_name in unique(data1$plant_sp)) {
    SC_Poll_Layer_DATA[bird_name,plant_name]<-length(which(data1$plant_sp==plant_name))/SC_Poll_Bird_Total[count]
  }
}

Txt_name<-paste0("HMIModularity/01_Data/FirstInterLink/","SC_pollination",".txt")
write.table (SC_Poll_Layer_DATA, file =Txt_name, sep =" ", row.names =TRUE, col.names =TRUE, quote =TRUE)
CSV_name<-paste0("HMIModularity/01_Data/FirstInterLink/","SC_pollination",".csv")
write.csv(SC_Poll_Layer_DATA, CSV_name, quote = TRUE)
#------------------------------------------------------------------------------#
##seed dispersal layer
SC_data_SeedDispersal<-SC_data[which(SC_data$X..seeds>=1),]
SC_Seed_Layer_DATA<-as.data.frame(matrix(0,
                                         length(unique(SC_data_SeedDispersal$disperser.species)),
                                         length(unique(SC_data_SeedDispersal$plant_sp))))
colnames(SC_Seed_Layer_DATA)<-unique(SC_data_SeedDispersal$plant_sp)
row.names(SC_Seed_Layer_DATA)<-unique(SC_data_SeedDispersal$disperser.species)
SC_Seed_Bird_Total<-c(38,74,69,214,105,340,12,28,77)
colnames(SC_Seed_Layer_DATA)[8]<-"noname"

count<-0
for (bird_name in unique(SC_data_SeedDispersal$disperser.species)) {
  count<-count+1
  data1<-SC_data_SeedDispersal[which(SC_data_SeedDispersal$disperser.species==bird_name),]
  for (plant_name in unique(data1$plant_sp)) {
    if (plant_name==""){
      SC_Seed_Layer_DATA[bird_name,"noname"]<-length(which(data1$plant_sp==plant_name))/SC_Seed_Bird_Total[count]
    }else{
      SC_Seed_Layer_DATA[bird_name,plant_name]<-length(which(data1$plant_sp==plant_name))/SC_Seed_Bird_Total[count]
    }
    
  }
}

Txt_name<-paste0("HMIModularity/01_Data/FirstInterLink/","SC_SeedDispersal",".txt")
write.table (SC_Seed_Layer_DATA, file =Txt_name, sep =" ", row.names =TRUE, col.names =TRUE, quote =TRUE)
CSV_name<-paste0("HMIModularity/01_Data/FirstInterLink/","SC_SeedDispersal",".csv")
write.csv(SC_Seed_Layer_DATA, CSV_name, quote = TRUE)

#------------------------------------------------------------------------------#
#Island:Santa Cruz (SX),pollination-bird-seed dispersal 57*11*34
SX_data<-data[which(data$Island=="Santa Cruz"),]
SX_data<-SX_data[which(SX_data$Sample==1),]

##pollination layer
SX_data_Pollination<-SX_data[which(SX_data$pollen_grains>10),]
SX_Poll_Layer_DATA<-as.data.frame(matrix(0,
                                         length(unique(SX_data_Pollination$disperser.species)),
                                         length(unique(SX_data_Pollination$plant_sp))))
colnames(SX_Poll_Layer_DATA)<-unique(SX_data_Pollination$plant_sp)
row.names(SX_Poll_Layer_DATA)<-unique(SX_data_Pollination$disperser.species)
SX_Poll_Bird_Total<-c(9,91,4,118,199,205,38,63,50,98,52)
count<-0
for (bird_name in unique(SX_data_Pollination$disperser.species)) {
  count<-count+1
  data1<-SX_data_Pollination[which(SX_data_Pollination$disperser.species==bird_name),]
  for (plant_name in unique(data1$plant_sp)) {
    SX_Poll_Layer_DATA[bird_name,plant_name]<-length(which(data1$plant_sp==plant_name))/SX_Poll_Bird_Total[count]
  }
}

Txt_name<-paste0("HMIModularity/01_Data/FirstInterLink/","SX_pollination",".txt")
write.table (SX_Poll_Layer_DATA, file =Txt_name, sep =" ", row.names =TRUE, col.names =TRUE, quote =TRUE)
CSV_name<-paste0("HMIModularity/01_Data/FirstInterLink/","SX_pollination",".csv")
write.csv(SX_Poll_Layer_DATA, CSV_name, quote = TRUE)
#------------------------------------------------------------------------------#

##seed dispersal layer
SX_data_SeedDispersal<-SX_data[which(SX_data$X..seeds>=1),]
SX_data_SeedDispersal<-SX_data_SeedDispersal[-which(SX_data_SeedDispersal$disperser.species=="Zenaida galapagoensis"),]

SX_Seed_Layer_DATA<-as.data.frame(matrix(0,
                                         length(unique(SX_data_SeedDispersal$disperser.species)),
                                         length(unique(SX_data_SeedDispersal$plant_sp))))
colnames(SX_Seed_Layer_DATA)<-unique(SX_data_SeedDispersal$plant_sp)
row.names(SX_Seed_Layer_DATA)<-unique(SX_data_SeedDispersal$disperser.species)
SX_Seed_Bird_Total<-c(9,91,21,118,199,205,38,63,50,98,52)
colnames(SX_Seed_Layer_DATA)[2]<-"noname"

count<-0
for (bird_name in unique(SX_data_SeedDispersal$disperser.species)) {
  count<-count+1
  data1<-SX_data_SeedDispersal[which(SX_data_SeedDispersal$disperser.species==bird_name),]
  for (plant_name in unique(data1$plant_sp)) {
    if (plant_name==""){
      SX_Seed_Layer_DATA[bird_name,"noname"]<-length(which(data1$plant_sp==plant_name))/SX_Seed_Bird_Total[count]
    }else{
      SX_Seed_Layer_DATA[bird_name,plant_name]<-length(which(data1$plant_sp==plant_name))/SX_Seed_Bird_Total[count]
    }
    
  }
}

Txt_name<-paste0("HMIModularity/01_Data/FirstInterLink/","SX_SeedDispersal",".txt")
write.table (SX_Seed_Layer_DATA, file =Txt_name, sep =" ", row.names =TRUE, col.names =TRUE, quote =TRUE)
CSV_name<-paste0("HMIModularity/01_Data/FirstInterLink/","SX_SeedDispersal",".csv")
write.csv(SX_Seed_Layer_DATA, CSV_name, quote = TRUE)

#==============================================================================#









































#unique(data$disperser.species)
data1<-data[which(data$disperser.species=="Geospiza fortis"),]
data1<-data1[which(data1$Island=="Santa Cruz"),]
#data1<-data1[which(data1$Island=="San Cristobal"),]
data1<-data1[which(data1$Sample==1),]

data2<-data1[which(data1$pollen_grains>10),]
data3<-data1[which(data1$X..seeds>=1),]
dim(data2)[1]
dim(data3)[1]

length(unique(data2$Ring.number))
length(unique(data3$Ring.number))
length(unique(c(data2$Ring.number,data3$Ring.number)))

length(unique(data2$ref.))
length(unique(data3$ref.))
length(unique(c(data2$ref.,data3$ref.)))

data2$viable=='yes'
unique(data2$ref.)
unique(data3$ref.)
ref_data<-c(data2$ref.,data3$ref.)
table(ref_data)
unique(data2$Ring.number)
length(which(data2$disperser.species=="bird not marked"))
data2<-data[which(data$Island=="Santa Cruz"),]

################################################################################
#Island1:San Cristóbal (SC)
Island_1<-data[which(data$Island==unique(data$Island)[2]),]

#####layer1_seed_dispersal
Island_1_layer1<-Island_1[!is.na(Island_1$X..seeds),]
Island_1_layer1<-Island_1_layer1[-which(Island_1_layer1$viable=='no' | Island_1_layer1$plant_sp==""),]

Island_1_layer1_dataframe<-as.data.frame(matrix(0,length(unique(Island_1_layer1$disperser.species)),length(unique(Island_1_layer1$plant_sp))))
row.names(Island_1_layer1_dataframe)<-unique(Island_1_layer1$disperser.species)
colnames(Island_1_layer1_dataframe)<-unique(Island_1_layer1$plant_sp)
for (i in unique(Island_1_layer1$disperser.species)) {
  for (j in unique(Island_1_layer1$plant_sp)) {
    index<-which(Island_1_layer1$disperser.species==i & Island_1_layer1$plant_sp==j)
    if (length(index)>0){
      Island_1_layer1_dataframe[i,j]<-sum(Island_1_layer1[index,"X..seeds"])
    }
  }
}
# sum(Island_1_layer1_dataframe)
# sum(Island_1_layer1$X..seeds)
Island_1_layer1_dataframe[Island_1_layer1_dataframe>0]<-1#将大于0的全变为1

#####layer2_pollination
Island_1_layer2<-Island_1[!is.na(Island_1$pollen_grains),]
Island_1_layer2<-Island_1_layer2[which(Island_1_layer2$pollen_grains>10),]#Evidence of bird flower visitation was considered if more than 10 pollen grains of a given species were detected in the sample. #This threshold was set to reduce any erroneous inferences about visitation caused by pollen contamination

Island_1_layer2_dataframe<-as.data.frame(matrix(0,length(unique(Island_1_layer2$disperser.species)),length(unique(Island_1_layer2$plant_sp))))
row.names(Island_1_layer2_dataframe)<-unique(Island_1_layer2$disperser.species)
colnames(Island_1_layer2_dataframe)<-unique(Island_1_layer2$plant_sp)
for (i in unique(Island_1_layer2$disperser.species)) {
  for (j in unique(Island_1_layer2$plant_sp)) {
    index<-which(Island_1_layer2$disperser.species==i & Island_1_layer2$plant_sp==j)
    if (length(index)>0){
      Island_1_layer2_dataframe[i,j]<-sum(Island_1_layer2[index,"pollen_grains"])
    }
  }
}
# sum(Island_1_layer2_dataframe)
# sum(Island_1_layer2$pollen_grains)
Island_1_layer2_dataframe[Island_1_layer2_dataframe>0]<-1#将大于0的全变为1

#####存储
Txt_name_layer1<-paste0("01_Data/Data_05_First_interlayer_link/","Island_1_seed_dispersal_layer",".txt")
Txt_name_layer2<-paste0("01_Data/Data_05_First_interlayer_link/","Island_1_pollination_layer",".txt")

write.table (Island_1_layer1_dataframe, file =Txt_name_layer1, sep =" ", row.names =TRUE, col.names =TRUE, quote =TRUE)
write.table (Island_1_layer2_dataframe, file =Txt_name_layer2, sep =" ", row.names =TRUE, col.names =TRUE, quote =TRUE)
#画二分网络查看数据是否合适
library(bipartite)
plotweb(data.matrix(Island_1_layer1_dataframe),method="normal",empty=FALSE)#higher trophic level species (columns)-pollinator(传粉)-herbivore(食草) and lower trophic level species (rows)-plant
plotweb(data.matrix(Island_1_layer2_dataframe),method="normal",empty=FALSE)

#visweb(data.matrix(HP1_data_frame),clear=FALSE)
visweb(data.matrix(Island_1_layer1_dataframe),type="none",clear=FALSE)
#visweb(data.matrix(HP2_data_frame),clear=FALSE)
visweb(data.matrix(Island_1_layer2_dataframe),type="none",clear=FALSE)
################################################################################
#Island2:Santa Cruz (SX)
Island_2<-data[which(data$Island==unique(data$Island)[1]),]

#####layer1_seed_dispersal
Island_2_layer1<-Island_2[!is.na(Island_2$X..seeds),]
Island_2_layer1<-Island_2_layer1[-which(Island_2_layer1$viable=='no' | Island_2_layer1$plant_sp==""),]

Island_2_layer1_dataframe<-as.data.frame(matrix(0,length(unique(Island_2_layer1$disperser.species)),length(unique(Island_2_layer1$plant_sp))))
row.names(Island_2_layer1_dataframe)<-unique(Island_2_layer1$disperser.species)
colnames(Island_2_layer1_dataframe)<-unique(Island_2_layer1$plant_sp)
for (i in unique(Island_2_layer1$disperser.species)) {
  for (j in unique(Island_2_layer1$plant_sp)) {
    index<-which(Island_2_layer1$disperser.species==i & Island_2_layer1$plant_sp==j)
    if (length(index)>0){
      Island_2_layer1_dataframe[i,j]<-sum(Island_2_layer1[index,"X..seeds"])
    }
  }
}
# sum(Island_2_layer1_dataframe)
# sum(Island_2_layer1$X..seeds)
Island_2_layer1_dataframe[Island_2_layer1_dataframe>0]<-1#将大于0的全变为1

#####layer2_pollination
Island_2_layer2<-Island_2[!is.na(Island_2$pollen_grains),]
Island_2_layer2<-Island_2_layer2[which(Island_2_layer2$pollen_grains>10),]#Evidence of bird flower visitation was considered if more than 10 pollen grains of a given species were detected in the sample. #This threshold was set to reduce any erroneous inferences about visitation caused by pollen contamination

Island_2_layer2_dataframe<-as.data.frame(matrix(0,length(unique(Island_2_layer2$disperser.species)),length(unique(Island_2_layer2$plant_sp))))
row.names(Island_2_layer2_dataframe)<-unique(Island_2_layer2$disperser.species)
colnames(Island_2_layer2_dataframe)<-unique(Island_2_layer2$plant_sp)
for (i in unique(Island_2_layer2$disperser.species)) {
  for (j in unique(Island_2_layer2$plant_sp)) {
    index<-which(Island_2_layer2$disperser.species==i & Island_2_layer2$plant_sp==j)
    if (length(index)>0){
      Island_2_layer2_dataframe[i,j]<-sum(Island_2_layer2[index,"pollen_grains"])
    }
  }
}
# sum(Island_2_layer2_dataframe)
# sum(Island_2_layer2$pollen_grains)
Island_2_layer2_dataframe[Island_2_layer2_dataframe>0]<-1#将大于0的全变为1

#####存储
Txt_name_layer1<-paste0("01_Data/Data_05_First_interlayer_link/","Island_2_seed_dispersal_layer",".txt")
Txt_name_layer2<-paste0("01_Data/Data_05_First_interlayer_link/","Island_2_pollination_layer",".txt")

write.table (Island_2_layer1_dataframe, file =Txt_name_layer1, sep =" ", row.names =TRUE, col.names =TRUE, quote =TRUE)
write.table (Island_2_layer2_dataframe, file =Txt_name_layer2, sep =" ", row.names =TRUE, col.names =TRUE, quote =TRUE)

#画二分网络查看数据是否合适
library(bipartite)
plotweb(data.matrix(Island_2_layer1_dataframe),method="normal",empty=FALSE)#higher trophic level species (columns)-pollinator(传粉)-herbivore(食草) and lower trophic level species (rows)-plant
plotweb(data.matrix(Island_2_layer2_dataframe),method="normal",empty=FALSE)

#visweb(data.matrix(HP1_data_frame),clear=FALSE)
visweb(data.matrix(Island_2_layer1_dataframe),type="none",clear=FALSE)
#visweb(data.matrix(HP2_data_frame),clear=FALSE)
visweb(data.matrix(Island_2_layer2_dataframe),type="none",clear=FALSE)
