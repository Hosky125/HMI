The code folder contains all the code files used in this study ("Introducing the Homo-Module Index (HMI) to Quantify Cross-Layer Modular Alignment in Multilayer Ecological Networks").

Among them, the MATLAB function HomoMI (method, module_partition, interlayer_links_weight) is used to calculate HMI.
HomoMI (method, module_partition, interlayer_links_weight) requires three parameters: 
'method' specifies the module partitioning approach ("multilayer" or "monolayer"), 
'module_partition' represents a matrix of node module partition, and 
'interlayer_links_weight' represents a weight matrix of interlayer links if considered, or 0 otherwise.

We follow Pilosof et al.(2017) modify the GenLouvain code from http://netwiki.amath.unc.edu/GenLouvain/GenLouvain) by changing the null model Pijs, see generate_monolayer_networks_supra_adjacency_matrix.m (applicable to generating supra adjacency matrix in monolayer networks),generate_multilayer_networks_supra_adjacency_matrix.m (applicable to generating supra adjacency matrix in diagnol coupling networks) and generate_multilayer_modularity_matrix.m (applicable to generating supra adjacency matrix in bipartite multilayer networks or multiplex networks) in the code folder.

最好还有几个算HMI的示例，用不同类型网络。
The MATLAB codes to calculate HMI for unweighted or weighted multilayer networks are provided in GitHub (https://github.com/Hosky125/HMI). 
