The code folder contains all the code files used in this study ("Introducing the Homo-Module Index (HMI) to Quantify Cross-Layer Modular Alignment in Multilayer Ecological Networks").

Among them, the MATLAB function HomoMI (method, module_partition, interlayer_links_weight) is used to calculate HMI.
HomoMI (method, module_partition, interlayer_links_weight) requires three parameters: 
'method' specifies the module partitioning approach ("multilayer" or "monolayer"), 
'module_partition' represents a matrix of node module partition, and 
'interlayer_links_weight' represents a weight matrix of interlayer links if considered, or 0 otherwise.
