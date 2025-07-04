The code folder contains all the code files used in this manuscript: "Introducing the Homo-Module Index (HMI) to Quantify Cross-Layer Modular Alignment in Multilayer Ecological Networks".

Among them, the MATLAB function HomoMI (method, module_partition, interlayer_links_weight) is used to calculate HMI.
HomoMI (method, module_partition, interlayer_links_weight) requires three parameters: 
'method' specifies the module partitioning approach ("multilayer" or "monolayer"), 
'module_partition' represents a matrix of node module partition, and 
'interlayer_links_weight' represents a weight matrix of interlayer links if considered, or 0 otherwise.

#无权重的网络
##读取网络数据
##划分网络
##计算HMI

#有权重的网络
```
%Weighted two-layer networks of bird pollination and dispersal from Hervías-Parejo et al. (2020).
%Hervías-Parejo S, Tur C,Heleno R, Nogales M, Timóteo S, Traveset A.2020 Species functional traits and abundance as drivers of multiplex ecological networks:first empirical quantification of inter-layer edge weights. Proc. R. Soc. B 287: 20202127.
%SC(San Cristóbal) Island
% 读取文件
p_h=importdata('SC_pollination.txt');
p_h=p_h.data;
p_p=importdata('SC_SeedDispersal.txt');
p_p=p_p.data;

interlayer_links_weight=[0.053 0.068 0.014 0.061 0.019 0.147 0.083 0.107 0.065];
%-------------------------------------------------------------------------%
% 无intralayer links weight且无interlayer links weight时，
% 计算:monolayer HMI(无weight)和multilayer modularity
p_N=min(size(p_h,1),size(p_p,1));
% Calculate multilayer modularity(without interlayer links weight)
% generate multilayer networks supra adjacency matrix
[B_multilayer,mm_multilayer] = generate_multilayer_networks_supra_adjacency_matrix(p_h,p_p,1,interlayer_link_strength,0);

iter=100;
S1_multilayer_plant=zeros(p_N, iter);
S2_multilayer_plant=zeros(p_N, iter);
Q_multilayer_total=zeros(iter, 1);
h_N=size(p_h,2);

for j=1:iter
    [S_multilayer,Q_multilayer] = genlouvain(B_multilayer,10000,0,1,1);
    S1_multilayer_plant(:,j) = S_multilayer(1:p_N);
    S2_multilayer_plant(:,j) = S_multilayer((p_N+h_N+1):(p_N+h_N+p_N));
    Q_multilayer_total(j,1) = Q_multilayer/mm_multilayer;
end
 
index = find(Q_multilayer_total==max(Q_multilayer_total));
%calculate multilayer HMI(with interlayer links weight)
module_partition=[S1_multilayer_plant(:,index(1))';S2_multilayer_plant(:,index(1))'];
HomoMI("multilayer",module_partition,interlayer_link_strength);
```

Example of calculating HMI through a diagonally coupled network
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
