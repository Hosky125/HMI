The code folder contains all the code files used in this manuscript: "Introducing the Homo-Module Index (HMI) to Quantify Cross-Layer Modular Alignment in Multilayer Ecological Networks".

Among them, the MATLAB function HMI (data, method, iter, interlayer_links_weight) is used to calculate HMI.
HMI (data, method, iter, interlayer_links_weight) requires four parameters: 
'data' 数据格式为.txt，数据
'method' specifies the module partitioning approach ("multilayer" or "monolayer"), 
'iter' 模块划分的次数, and 
'interlayer_links_weight' represents a weight matrix of interlayer links if considered, or 0 otherwise.

Among them, the MATLAB function HMI (data, iter, method, module_partition, interlayer_links_weight) is used to calculate HMI.
HMI (data, method, module_partition, interlayer_links_weight) requires three parameters: 
'method' specifies the module partitioning approach ("multilayer" or "monolayer"), 
'module_partition' represents a matrix of node module partition, and 
'interlayer_links_weight' represents a weight matrix of interlayer links if considered, or 0 otherwise.

## A complete example of calculating HMI
Weighted two-layer networks of bird pollination and dispersal from Hervías-Parejo et al. (2020). This example uses bird pollination and dispersal data from SC(San Cristobal) Island.

References:
Hervías-Parejo S, Tur C,Heleno R, Nogales M, Timóteo S, Traveset A.2020 Species functional traits and abundance as drivers of multiplex ecological networks:first empirical quantification of inter-layer edge weights. Proc. R. Soc. B 287: 20202127.

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
Before calculating modularity and obtaining module partition, need to be installed GenLouvain, refer to https://github.com/GenLouvain/GenLouvain. We follow Pilosof et al.(2017) modify the GenLouvain code by changing the null model Pijs, see generate_monolayer_networks_supra_adjacency_matrix.m (applicable to generating supra adjacency matrix in monolayer networks), generate_multilayer_networks_supra_adjacency_matrix.m (applicable to generating supra adjacency matrix in diagnol coupling networks) and generate_multilayer_modularity_matrix.m (applicable to generating supra adjacency matrix in bipartite multilayer networks or multiplex networks) in the code folder.
```
%
[modularity, module_partition] = calculate_modularity_obtain_module_partition(Intra_data,Inter_data,"monolayer",layer,100,"bipartite","diagonal_coupling")
%
[modularity, module_partition] = calculate_modularity_obtain_module_partition(Intra_data,Inter_data,"multilayer",layer,100,"bipartite","diagonal_coupling")
```
### Step 3: Calculate HMI
```
HMI=HomoMI("monolayer",module_partition,Inter_data)
HMI=HomoMI("multilayer",module_partition,Inter_data)
```

## Example of calculating HMI through a diagonally coupled network
------
![image](https://github.com/Hosky125/HMI/blob/main/Figure1.jpg)
```
%diagonal coupling network
%-----------------------------------------------------%
%module partition by monolayer algorithm
%without interlayer links weight
%Figure (a)
module_partition=[1 1;2 2]
HomoMI("monolayer",module_partition,0)

%module partition by monolayer algorithm
%without interlayer links weight
%Figure (b)
module_partition=[1 1;2 3]
HomoMI("monolayer",module_partition,0)

%module partition by multilayer algorithm
%without interlayer links weight
%Figure (c)
module_partition=[1 1;1 1]
HomoMI("multilayer",module_partition,0)

%module partition by multilayer algorithm
%without interlayer links weight
%Figure (d)
module_partition=[1 1;1 2]
HomoMI("multilayer",module_partition,0)

%module partition by multilayer algorithm
%without interlayer links weight
%Figure (e)
module_partition=[1 1;2 3]
HomoMI("multilayer",module_partition,0)
```

Schematic_Example1.m in the code folder is the sample code for calculating the HMI of the diagonal coupling network (see Figure 1 in the main text of the manuscript).
Schematic_Example2.m in the code folder is the sample code for calculating the HMI of a temporal or spatial network.

We follow Pilosof et al.(2017) modify the GenLouvain code from http://netwiki.amath.unc.edu/GenLouvain/GenLouvain by changing the null model Pijs, see generate_monolayer_networks_supra_adjacency_matrix.m (applicable to generating supra adjacency matrix in monolayer networks), generate_multilayer_networks_supra_adjacency_matrix.m (applicable to generating supra adjacency matrix in diagnol coupling networks) and generate_multilayer_modularity_matrix.m (applicable to generating supra adjacency matrix in bipartite multilayer networks or multiplex networks) in the code folder.

DataProcess_PHP.R, DataProcess_PPH.R, DataProcess_TemNet_EMLN.R and DataProcess_SpaNet_EMLN.R in the code folder are used to preprocess data.
NullModel_Intra_PPH_PHP.R, NullModel_Intra_TemNet.R and NullModel_Intra_SpaNet.R in the code folder are used to shuffle intralayer links.
PHP87_Raw_HMI_Modularity.m, PHP87_NullModel_Inter_HMI_Modularity.m, PHP87_NullModel_Intra_HMI_Modularity.m, PHP87_NullModel_Hybrid_HMI_Modularity.m,
PPH45_Raw_HMI_Modularity.m, PPH45_NullModel_Inter_HMI_Modularity.m, PPH45_NullModel_Intra_HMI_Modularity.m, PPH45_NullModel_Hybrid_HMI_Modularity.m,
TemNet_Raw_HMI_Modularity.m, TemNet_NullModel_Inter_HMI_Modularity.m, TemNet_NullModel_Intra_HMI_Modularity.m, TemNet_NullModel_Hybrid_HMI_Modularity.m,
SpaNet_Raw_HMI_Modularity.m, SpaNet_NullModel_Inter_HMI_Modularity.m, SpaNet_NullModel_Intra_HMI_Modularity.m, SpaNet_NullModel_Hybrid_HMI_Modularity.m
in the code folder are used to partition modules and compute HMI, monomodularity, multilayer modularity.
NullModel_HMI_MultiModularity_Analysis.R in the code folder is used for statistical analysis and plotting.
