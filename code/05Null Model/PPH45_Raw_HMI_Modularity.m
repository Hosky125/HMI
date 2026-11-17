clc
clear

fileInfo = dir(fullfile(pwd, '01_DATA/PPH_45','*.txt'));
fileNames = {fileInfo.name}';

NumberOfNetwork = length(fileInfo)/2;
monolayer_modularity = zeros(NumberOfNetwork,1);
HMI_monolayer_total = zeros(NumberOfNetwork,6);
HMI_monolayer_connector_score = cell(NumberOfNetwork,3);

multilayer_modularity = zeros(NumberOfNetwork,1);
HMI_multilayer_total = zeros(NumberOfNetwork,6);
HMI_multilayer_connector_score = cell(NumberOfNetwork,3);

for NetworkID=1:NumberOfNetwork
    NetworkID
    %%
    filePath1 = fullfile(pwd,'01_DATA/PPH_45',fileNames(NetworkID));
    filePath2 = fullfile(pwd,'01_DATA/PPH_45',fileNames(NetworkID+NumberOfNetwork));
   
    layer1data=importdata(filePath1{1});
    layer1data=layer1data.data;

    layer2data=importdata(filePath2{1});
    layer2data=layer2data.data;
    %%
    intra_data = {layer1data,layer2data};
    inter_data = [];
    layer = 2;
    iter = 100;
    networktype = 'bipartite';
    inter_links_type = 'diagonal_coupling';
    %%
    % Calculate monolayer modularity
    % Calculate HMI min
    % Calculate HMI max
    % Calculate HMI mean
    method = 'monolayer';
    [modularity, module_partition] = modularity_module_partition(intra_data,inter_data,method,layer,iter,networktype,inter_links_type);

    HMI_min = HomoMI(method,'min',module_partition,inter_data);
    HMI_max = HomoMI(method,'max',module_partition,inter_data);
    HMI_mean = HomoMI(method,'mean',module_partition,inter_data);

    monolayer_modularity(NetworkID,1) = modularity;

    HMI_monolayer_total(NetworkID,1) = HMI_min{1};
    HMI_monolayer_total(NetworkID,2) = HMI_max{1};
    HMI_monolayer_total(NetworkID,3) = HMI_mean{1};

    HMI_monolayer_total(NetworkID,4) = HMI_min{2};
    HMI_monolayer_total(NetworkID,5) = HMI_max{2};
    HMI_monolayer_total(NetworkID,6) = HMI_mean{2};

    HMI_monolayer_connector_score{NetworkID,1} = HMI_min{3};
    HMI_monolayer_connector_score{NetworkID,2} = HMI_max{3};
    HMI_monolayer_connector_score{NetworkID,3} = HMI_mean{3};

    %%
    % Calculate multilayer modularity(without interlayer links weight)
    % Calculate HMI min
    % Calculate HMI max
    % Calculate HMI mean
    method = 'multilayer';
    [modularity, module_partition] = modularity_module_partition(intra_data,inter_data,method,layer,iter,networktype,inter_links_type);

    HMI_min = HomoMI(method,'min',module_partition,inter_data);
    HMI_max = HomoMI(method,'max',module_partition,inter_data);
    HMI_mean = HomoMI(method,'mean',module_partition,inter_data);

    multilayer_modularity(NetworkID,1) = modularity;

    HMI_multilayer_total(NetworkID,1) = HMI_min{1};
    HMI_multilayer_total(NetworkID,2) = HMI_max{1};
    HMI_multilayer_total(NetworkID,3) = HMI_mean{1};

    HMI_multilayer_total(NetworkID,4) = HMI_min{2};
    HMI_multilayer_total(NetworkID,5) = HMI_max{2};
    HMI_multilayer_total(NetworkID,6) = HMI_mean{2};

    HMI_multilayer_connector_score{NetworkID,1} = HMI_min{3};
    HMI_multilayer_connector_score{NetworkID,2} = HMI_max{3};
    HMI_multilayer_connector_score{NetworkID,3} = HMI_mean{3};

end

csvwrite('03_Result/HMI_monolayer_total_PPH_Raw.csv', HMI_monolayer_total);
csvwrite('03_Result/HMI_multilayer_total_PPH_Raw.csv', HMI_multilayer_total);
csvwrite('03_Result/Q_monolayer_max_total_PPH_Raw.csv', monolayer_modularity);
csvwrite('03_Result/Q_multilayer_max_total_PPH_Raw.csv', multilayer_modularity);