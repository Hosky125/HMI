clc
clear

fileInfo = dir(fullfile(pwd, '01_DATA/SpaNet','.'));
fileInfo = fileInfo([fileInfo.isdir] & ~ismember({fileInfo.name}, {'.', '..'}));

NumberOfNetwork = length(fileInfo);
monolayer_modularity = zeros(NumberOfNetwork,1);
HMI_monolayer_total = zeros(NumberOfNetwork,6);
HMI_monolayer_connector_score = cell(NumberOfNetwork,3);

multilayer_modularity = zeros(NumberOfNetwork,1);
HMI_multilayer_total = zeros(NumberOfNetwork,6);
HMI_multilayer_connector_score = cell(NumberOfNetwork,3);

for NetworkID=1:NumberOfNetwork
    NetworkID
    filepath = strcat(pwd,'\01_DATA\SpaNet\Network',num2str(NetworkID,'%02d'),'\');
    filename = dir([filepath,'*.csv']);
    
    layer=length(filename);
    intra_data = cell(1,layer);
    inter_data = [];
    iter = 100;
    networktype = 'bipartite';
    inter_links_type = 'multiplex';
    
    for j=1:layer
        subfilepath=strcat(filepath,filename(j).name);
        Data=importdata(subfilepath);
        intra_data{j}=Data.data;
    end
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
csvwrite('03_Result/HMI_monolayer_total_SpaNet_Raw.csv', HMI_monolayer_total);
csvwrite('03_Result/HMI_multilayer_total_SpaNet_Raw.csv', HMI_multilayer_total);
csvwrite('03_Result/Q_monolayer_max_total_SpaNet_Raw.csv', monolayer_modularity);
csvwrite('03_Result/Q_multilayer_max_total_SpaNet_Raw.csv', multilayer_modularity);