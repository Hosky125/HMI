clc
clear

fileInfo_monolayer = dir(fullfile(pwd, '01_DATA/SpaNet_Infomap/monolayer','*.txt'));
fileInfo_multilayer = dir(fullfile(pwd, '01_DATA/SpaNet_Infomap/multilayer','*.txt'));
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
    filePath = fullfile(pwd,'01_DATA/SpaNet_Infomap/monolayer',fileNames_monolayer(NetworkID));
    module_partition1 = readmatrix(filePath{1});
    filePath = fullfile(pwd,'01_DATA/SpaNet_Infomap/multilayer',fileNames_multilayer(NetworkID));
    module_partition2 = readmatrix(filePath{1});

    colHasNA1 = any(isnan(module_partition1), 1);        % 1×nCols 逻辑向量
    naColIdx1 = find(colHasNA1);

    colHasNA2 = any(isnan(module_partition2), 1);        % 1×nCols 逻辑向量
    naColIdx2 = find(colHasNA2);

    naColIdx = union(naColIdx1, naColIdx2);
    keepCols  = setdiff(1:size(module_partition1, 2), naColIdx);
    module_partition1 = module_partition1(:, keepCols);
    module_partition2 = module_partition2(:, keepCols);

    %%
    inter_data = [];
    %%
    % Calculate monolayer modularity
    % Calculate HMI min
    % Calculate HMI max
    % Calculate HMI mean
    method = 'monolayer';
    
    HMI_min = HomoMI(method,'min',module_partition1,inter_data);
    HMI_max = HomoMI(method,'max',module_partition1,inter_data);
    HMI_mean = HomoMI(method,'mean',module_partition1,inter_data);

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
%     filePath = fullfile(pwd,'01_DATA/SpaNet_Infomap/multilayer',fileNames_multilayer(NetworkID));
%     module_partition = importdata(filePath{1});

    HMI_min = HomoMI(method,'min',module_partition2,inter_data);
    HMI_max = HomoMI(method,'max',module_partition2,inter_data);
    HMI_mean = HomoMI(method,'mean',module_partition2,inter_data);

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

csvwrite('02_Result/HMI_monolayer_total_SpaNet_Raw_Infomap.csv', HMI_monolayer_total);
csvwrite('02_Result/HMI_multilayer_total_SpaNet_Raw_Infomap.csv', HMI_multilayer_total);