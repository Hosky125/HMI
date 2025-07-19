This respository contains all the code files used in this manuscript: "Introducing the Homo-Module Index (HMI) to Quantify Cross-Layer Modular Alignment in Multilayer Ecological Networks".

## Major functions
### **multilayer_module_partition (intra_data, inter_data, method, layer, iter, networktype, inter_links_type)**

**Discription**
<br> This function performs module partition and calculates modularity for a multilayer network, based on GenLouvain method.

**Parameters**
<br>**intra_data** A three-dimensional array that represents the layers. Each layer is a matrix desribing intralayer interactions, and  rows and columns should be matched across layers. 
<br>**inter_data** A matrix to represent interlayer links if considered (Rows indicate interlayers, columns indicate connector nodes,values indicate weights), or NaN otherwise.
<br>**method** The module partitioning approach ("multilayer" or "monolayer"). The "multilayer" algorithm performs module partition on all layer as a whole, while the "monolayer" algorithm performs module partition for each layer independently.
<br>**layer** The number of layers.
<br>**iter** The number of iterations for module partitioning.
<br>**networktype** The type of network within each layer("bipartite" or "unipartite").
<br>**inter_links_type** The mode of interlayer links ("diagonal_coupling" or "multiplex").

**Value**
<br> Return a matrix indicating the module membership of connector nodes (rows indicate layers, column indicate connector nodes, and values indicate module membership) and the modularity metric (a value for multilayer algorithm and an average value for monolayer algorithm).

### **HomoMI (method, module_partition, inter_data)** 
**Discription**
<br> This function calculates Homo-Module Index.

**Parameters**
<br>**method** The module partitioning approach ("multilayer" or "monolayer"). 
<br>**module_partition** A matrix indicating the module membership of connector nodes (rows indicate layers, column indicate connector nodes, and values indicate module membership)
<br>**inter_data** A matrix to represent interlayer links if considered (Rows indicate interlayers, columns indicate connector nodes,values indicate weights), or NaN otherwise.

**Value**
<br> Return the HMI value.

## Examples of showing cross-layer module alignment and calculating HMI through a diagonally coupled toy network
------
![image](https://github.com/Hosky125/HMI/blob/main/Figure1.jpg)
```
%diagonal coupling network
%-----------------------------------------------------%
%module partition by monolayer algorithm
%without interlayer links weight
%Figure (a)
module_partition=[1 1;2 2]
HomoMI("monolayer",module_partition,NaN)

%module partition by monolayer algorithm
%without interlayer links weight
%Figure (b)
module_partition=[1 1;2 3]
HomoMI("monolayer",module_partition,NaN)

%module partition by multilayer algorithm
%without interlayer links weight
%Figure (c)
module_partition=[1 1;1 1]
HomoMI("multilayer",module_partition,NaN)

%module partition by multilayer algorithm
%without interlayer links weight
%Figure (d)
module_partition=[1 1;1 2]
HomoMI("multilayer",module_partition,NaN)

%module partition by multilayer algorithm
%without interlayer links weight
%Figure (e)
module_partition=[1 1;2 3]
HomoMI("multilayer",module_partition,NaN)
```

Schematic_Example1.m in the code folder is the example code for calculating the HMI of the diagonal coupling toy network (see Figure 1 in the main text of the manuscript).

## A worked example of calculating HMI
We showcase the calculation of HMI with an empirical weighted two-layer networks of bird pollination and dispersal from Hervías-Parejo et al. (2020). This example uses bird pollination and dispersal data from San Cristobal(SC) Island.

### Step 1: Import data
```
layer = 2;
Intra_Data = cell(1,layer);
layer1 = importdata('SC_pollination.txt');
Intra_Data{1} = layer1.data;
layer2 = importdata('SC_SeedDispersal.txt');
Intra_Data{2} = layer2.data;

Inter_Data = importdata('inter_weight.txt');
Inter_Data = Inter_Data.data;
```
### Step 2: Calculate modularity and obtain module partition
Before calculating modularity and obtaining module partition, the GenLouvain function needs to be installed  (https://github.com/GenLouvain/GenLouvain). 

We follow Pilosof et al.(2017) to modify the GenLouvain code by changing the null model Pijs, see **generate_monolayer_networks_supra_adjacency_matrix.m** (applicable to generating supra adjacency matrix in monolayer networks), **generate_multilayer_networks_supra_adjacency_matrix.m** (applicable to generating supra adjacency matrix in diagnol coupling networks) and **generate_multilayer_modularity_matrix.m** (applicable to generating supra adjacency matrix in bipartite multilayer networks or multiplex networks) in the code folder.
```
%module partition by monolayer algorithm
[modularity, module_partition] = multilayer_module_partition(Intra_data,Inter_data,"monolayer",layer,100,"bipartite","diagonal_coupling")
%module partition by multilayer algorithm
[modularity, module_partition] = multilayer_module_partition(Intra_data,Inter_data,"multilayer",layer,100,"bipartite","diagonal_coupling")
```
### Step 3: Calculate HMI
```
%module partition by monolayer algorithm
HMI=HomoMI("monolayer",module_partition,Inter_data)
%module partition by multilayer algorithm
HMI=HomoMI("multilayer",module_partition,Inter_data)
```

## Other functions to process data and analysis in the manuscript

**R codes to process data**

DataProcess_PHP.R, DataProcess_PPH.R, DataProcess_TemNet_EMLN.R and DataProcess_SpaNet_EMLN.R in the code folder are used to preprocess PHP, PPH, temporal and spatial networks.
<br>NullModel_Intra_PPH_PHP.R, NullModel_Intra_TemNet.R and NullModel_Intra_SpaNet.R in the code folder are used to shuffle intralayer links.
<br>NullModel_HMI_MultiModularity_Analysis.R is the code for statistical analysis and plotting.

**matlab codes for analysis**
<br>PHP87_Raw_HMI_Modularity.m, PHP87_NullModel_Inter_HMI_Modularity.m, PHP87_NullModel_Intra_HMI_Modularity.m, PHP87_NullModel_Hybrid_HMI_Modularity.m,
<br>PPH45_Raw_HMI_Modularity.m, PPH45_NullModel_Inter_HMI_Modularity.m, PPH45_NullModel_Intra_HMI_Modularity.m, PPH45_NullModel_Hybrid_HMI_Modularity.m,
<br>TemNet_Raw_HMI_Modularity.m, TemNet_NullModel_Inter_HMI_Modularity.m, TemNet_NullModel_Intra_HMI_Modularity.m, TemNet_NullModel_Hybrid_HMI_Modularity.m,
<br>SpaNet_Raw_HMI_Modularity.m, SpaNet_NullModel_Inter_HMI_Modularity.m, SpaNet_NullModel_Intra_HMI_Modularity.m, SpaNet_NullModel_Hybrid_HMI_Modularity.m
in the code folder are used to partition modules and compute HMI, monomodularity, multilayer modularity for different types of empirical networks.


## **References**
Hervías-Parejo S, Tur C,Heleno R, Nogales M, Timóteo S, Traveset A.2020 Species functional traits and abundance as drivers of multiplex ecological networks:first empirical quantification of inter-layer edge weights. Proc. R. Soc. B 287: 20202127.
