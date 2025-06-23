The code folder contains all the code files used in this study ("Introducing the Homo-Module Index (HMI) to Quantify Cross-Layer Modular Alignment in Multilayer Ecological Networks").

Among them, the MATLAB function HomoMI (method, module_partition, interlayer_links_weight) is used to calculate HMI.
HomoMI (method, module_partition, interlayer_links_weight) requires three parameters: 
'method' specifies the module partitioning approach ("multilayer" or "monolayer"), 
'module_partition' represents a matrix of node module partition, and 
'interlayer_links_weight' represents a weight matrix of interlayer links if considered, or 0 otherwise.

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
