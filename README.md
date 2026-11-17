This repository contains the code for calculating the Homo-Module Index (HMI) and reproducing the analyses in the manuscript (Introducing the Homo-Module Index to Quantify Cross-Layer Modular Alignment in Multilayer Ecological Networks). HMI measures how consistently connector species are assigned to corresponding modules across network layers.

## Core HMI workflow
<br>**Step 1: Data Process** Organize the interaction data for each layer into a matrix and save each matrix as a .txt or .csv file.
<br>**Step 2: Module Partition**  Use the generalized Louvain algorithm in MATLAB to partition the network. We provide two partitioning schemes. In the monolayer scheme, each layer is partitioned independently. In the multilayer scheme, all layers are partitioned jointly. Both schemes return a module assignment for each node in each layer.
<br>**Step 3: Calculate HMI** Use the module assignments from Step 2 as input to the MATLAB implementation of HMI. 
These three steps constitute the workflow for calculating HMI. If the interaction matrices are already prepared, start at Step 2. If module assignments are already available, start at Step 3.

## Major functions
### **multilayer_module_partition (intra_data, inter_data, method, layer, iter, networktype, inter_links_type)**

**Description**
<br> This function performs module partition and calculates modularity for a multilayer network, based on GenLouvain method.

**Parameters**
<br>**intra_data** A three-dimensional array that represents the layers. Each layer is a matrix desribing intralayer interactions, and  rows should be matched across layers. 
<br>**inter_data** A matrix to represent interlayer links if considered (Rows indicate interlayers, columns indicate connector nodes,values indicate weights), or NaN otherwise.
<br>**method** The module partitioning approach ("multilayer" or "monolayer"). The "multilayer" algorithm performs module partition on all layer as a whole, while the "monolayer" algorithm performs module partition for each layer independently.
<br>**layer** The number of layers.
<br>**iter** The number of iterations for module partitioning.
<br>**networktype** The type of network within each layer ("bipartite" or "unipartite").
<br>**inter_links_type** The mode of interlayer links ("diagonal_coupling" or "multiplex").

**Value**
<br> Return a matrix indicating the module membership of connector nodes (rows indicate layers, column indicate connector nodes, and values indicate module membership) and the modularity metric (a value for multilayer algorithm and an average value for monolayer algorithm).

### **HomoMI (method, strategy, module_partition, inter_data)** 
**Description**
<br> This function calculates Homo-Module Index.

**Parameters**
<br>**method** The module partitioning approach ("multilayer" or "monolayer"). 
<br>**strategy** The criterion based on which the number of modules is determined, which can be maximum(max), minimum(min) or average(mean=(max+min)/2).
<br>**module_partition** A matrix indicating the module membership of connector nodes (rows indicate layers, column indicate connector nodes, and values indicate module membership)
<br>**inter_data** A matrix to represent interlayer links if considered (Rows indicate interlayers, columns indicate connector nodes,values indicate weights), or NaN otherwise.

**Value**
<br> Return the HMI value.

**Note**

HomoMI.m requires the following four functions to run successfully: find_max_connected_component.m, calculate_judge_matrix.m, generate_matrices.m, and generate_vector_sums.m.

## Examples of showing cross-layer module alignment and calculating HMI through a diagonally coupled toy network
------
![image](https://github.com/Hosky125/HMI/blob/main/Figure1.jpg)
```
%diagonal coupling network
%-----------------------------------------------------%
%module partition by monolayer algorithm
%without interlayer links weight
%Figure 1(a)
inter_data = [];
module_partition=[1 1;2 2];
Result = HomoMI("monolayer",'mean',module_partition,inter_data);
HMI = Result{2}

%module partition by monolayer algorithm
%without interlayer links weight
%Figure 1(b)
inter_data = [];
module_partition=[1 1;2 3];
Result = HomoMI("monolayer",'mean',module_partition,inter_data);
HMI = Result{2}

%module partition by multilayer algorithm
%without interlayer links weight
%Figure 1(c)
inter_data = [];
module_partition=[1 1;1 1];
Result = HomoMI("multilayer",'mean',module_partition,inter_data);
HMI = Result{2}

%module partition by multilayer algorithm
%without interlayer links weight
%Figure 1(d)
inter_data = [];
module_partition=[1 1;1 2];
Result = HomoMI("multilayer",'mean',module_partition,inter_data);
HMI = Result{2}

%module partition by multilayer algorithm
%without interlayer links weight
%Figure 1(e)
inter_data = [];
module_partition=[1 1;2 3];
Result = HomoMI("multilayer",'mean',module_partition,inter_data);
HMI = Result{2}
```

Schematic_Example1.m in the code folder is the example code for calculating the HMI of the diagonal coupling toy network (see Figure 1 in the main text of the manuscript).

## A worked example of calculating HMI
We showcase the calculation of HMI with an empirical weighted two-layer network of bird pollination and dispersal from Hervías-Parejo et al. (2020). This example uses bird pollination and dispersal data from San Cristobal(SC) Island.

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
Before calculating modularity and obtaining module partition, the GenLouvain function needs to be installed  (https://github.com/GenLouvain/GenLouvain). We provide GenLouvain2.0.zip in the Code folder. Extract the archive and add the extracted folder to the MATLAB search path.

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
HMI=HomoMI("monolayer",'mean',module_partition,Inter_data)
%module partition by multilayer algorithm
HMI=HomoMI("multilayer",'mean',module_partition,Inter_data)
```

## Reproducing the manuscript analyses
<br>**05Null Model**
Generate randomized networks under the three null models used in the manuscript:
- N1 randomizes interlayer links while preserving intralayer structure.
- N2 randomizes intralayer interactions while retaining interlayer links.
- N3 randomizes both intralayer interactions and interlayer links.
For each randomized network, repeat the module detection and HMI calculation in 02Module Partition and 03Calculate HMI. Keep the network ID and randomization ID with each HMI and modularity value. The resulting N1 distributions are used to test whether observed HMI differs from random expectations. The randomized HMI and modularity values also provide inputs for the regression and standardization analyses in the manuscript.

<br>**06Alignment Decay**
Analyze how the fitted slope of the HMI–multilayer modularity relationship varies with the number of temporal layers. First, estimate a slope for each temporal network by regressing multilayer modularity on HMI across its N1 randomizations. Then relate the estimated slopes to the number of layers. This folder also contains the analyses that check the empirical pattern by omitting one network at a time and explore a wider range of layer counts using simulated temporal networks.

<br>**07Controlled Examples**
Run the four controlled examples with prescribed module assignments. The examples compare consecutive and interrupted alignment, redistribute interlayer weights while keeping module assignments fixed, and examine module correspondence under splitting and merging. 

<br>**08Infomap**
Use Infomap to obtain alternative module assignments for independent layer partitions and joint multilayer partitions. Match the exported module labels to species and layers before passing them to the HMI calculation in 03Calculate HMI.

## **References**
Hervías-Parejo S, Tur C,Heleno R, Nogales M, Timóteo S, Traveset A. 2020 Species functional traits and abundance as drivers of multiplex ecological networks:first empirical quantification of inter-layer edge weights. Proc. R. Soc. B 287: 20202127.
<br>Pilosof, S., M. A. Porter, M. Pascual, and S. Kéfi. 2017. The multilayer nature of ecological networks. Nature Ecology & Evolution 1:0101.
