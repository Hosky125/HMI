clc
clear

fileInfo_monolayer = dir(fullfile(pwd, '01_DATA/PPH_45_Infomap/monolayer','*.txt'));
fileInfo_multilayer = dir(fullfile(pwd, '01_DATA/PPH_45_Infomap/multilayer','*.txt'));
fileNames_monolayer = {fileInfo_monolayer.name}';
fileNames_multilayer = {fileInfo_multilayer.name}';

NumberOfNetwork = length(fileInfo_monolayer);

HMI_monolayer_total = zeros(NumberOfNetwork,6);
HMI_monolayer_connector_score = cell(NumberOfNetwork,3);
HMI_multilayer_total = zeros(NumberOfNetwork,6);
HMI_multilayer_connector_score = cell(NumberOfNetwork,3);

for NetworkID=1:NumberOfNetwork
    NetworkID
    %%
    filePath = fullfile(pwd,'01_DATA/PPH_45_Infomap/monolayer',fileNames_monolayer(NetworkID));
    module_partition = importdata(filePath{1});
    
    %%
    inter_data = [];
    %%
    % Calculate monolayer modularity
    % Calculate HMI min
    % Calculate HMI max
    % Calculate HMI mean
    method = 'monolayer';
    
    HMI_min = HomoMI(method,'min',module_partition,inter_data);
    HMI_max = HomoMI(method,'max',module_partition,inter_data);
    HMI_mean = HomoMI(method,'mean',module_partition,inter_data);

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
    filePath = fullfile(pwd,'01_DATA/PPH_45_Infomap/multilayer',fileNames_multilayer(NetworkID));
    module_partition = importdata(filePath{1});

    HMI_min = HomoMI(method,'min',module_partition,inter_data);
    HMI_max = HomoMI(method,'max',module_partition,inter_data);
    HMI_mean = HomoMI(method,'mean',module_partition,inter_data);

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

csvwrite('02_Result/HMI_monolayer_total_PPH_Raw_Infomap.csv', HMI_monolayer_total);
csvwrite('02_Result/HMI_multilayer_total_PPH_Raw_Infomap.csv', HMI_multilayer_total);