%Hervías-Parejo S, Tur C,Heleno R, Nogales M, Timóteo S, Traveset A.
%2020 Species functional traits and abundance as drivers of multiplex ecological networks:
%first empirical quantification of inter-layer edge weights. Proc. R. Soc. B 287: 20202127.

%Intralayer links weighted
%Interlayer links weighted

%pollination-seed dispersal

%SC(San Cristóbal) Island
interlayer_links_weight=[0.053 0.068 0.014 0.061 0.019 0.147 0.083 0.107 0.065];

%SX(Santa Cruz) Island
interlayer_links_weight=[0 0.066 0 0.059 0.015 0.093 0.102 0 0.02 0 0];

%-------------------------------------------------------------------------%
clc
clear

iterations = 1000;
monolayer_modularity = zeros(iterations, 1);
HMI1_min_monolayer_total = zeros(iterations, 1);
HMI1_max_monolayer_total = zeros(iterations, 1);
HMI1_mean_monolayer_total = zeros(iterations, 1);
HMI2_min_monolayer_total = zeros(iterations, 1);
HMI2_max_monolayer_total = zeros(iterations, 1);
HMI2_mean_monolayer_total = zeros(iterations, 1);

multilayer_modularity = zeros(iterations, 1);
HMI1_min_multilayer_total = zeros(iterations, 1);
HMI1_max_multilayer_total = zeros(iterations, 1);
HMI1_mean_multilayer_total = zeros(iterations, 1);
HMI2_min_multilayer_total = zeros(iterations, 1);
HMI2_max_multilayer_total = zeros(iterations, 1);
HMI2_mean_multilayer_total = zeros(iterations, 1);

HMI_monolayer_connector_score = cell(iterations, 1);
HMI_multilayer_connector_score = cell(iterations, 1);

SC_fileInfo = dir(fullfile(pwd, '01_DATA/First/SC/','*.csv'));
SC_fileNames = {SC_fileInfo.name}';
SC_filePath1 = fullfile(pwd,'01_DATA/First/SC/',SC_fileNames(1));
SC_filePath2 = fullfile(pwd,'01_DATA/First/SC/',SC_fileNames(2));

layer1data=importdata(SC_filePath1{1});
layer1data=layer1data.data;

layer2data=importdata(SC_filePath2{1});
layer2data=layer2data.data;

tic
p=parpool(60);
parfor i=1:iterations

    layer1data_randperm=randperm(size(layer1data,1));
    layer2data_randperm=randperm(size(layer2data,1));
    layer1_data = layer1data(layer1data_randperm,:);
    layer2_data = layer2data(layer2data_randperm,:);

    intra_data = {layer1_data,layer2_data};
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

    monolayer_modularity(i,1) = modularity;
    HMI1_min_monolayer_total(i,1) = HMI_min{1};
    HMI1_max_monolayer_total(i,1) = HMI_max{1};
    HMI1_mean_monolayer_total(i,1) = HMI_mean{1};
    HMI2_min_monolayer_total(i,1) = HMI_min{2};
    HMI2_max_monolayer_total(i,1) = HMI_max{2};
    HMI2_mean_monolayer_total(i,1) = HMI_mean{2};
    HMI_monolayer_connector_score{i,1} = {HMI_min{3},HMI_max{3},HMI_mean{3}};

    %%
    % Calculate multilayer modularity(without interlayer links weight)
    % Calculate HMI min
    % Calculate HMI max
    % Calculate HMI mean
    method = 'multilayer';
    inter_data=[0.053 0.068 0.014 0.061 0.019 0.147 0.083 0.107 0.065];
    [modularity, module_partition] = modularity_module_partition(intra_data,inter_data,method,layer,iter,networktype,inter_links_type);

    HMI_min = HomoMI(method,'min',module_partition,inter_data);
    HMI_max = HomoMI(method,'max',module_partition,inter_data);
    HMI_mean = HomoMI(method,'mean',module_partition,inter_data);

    multilayer_modularity(i,1) = modularity;
    HMI1_min_multilayer_total(i,1) = HMI_min{1};
    HMI1_max_multilayer_total(i,1) = HMI_max{1};
    HMI1_mean_multilayer_total(i,1) = HMI_mean{1};
    HMI2_min_multilayer_total(i,1) = HMI_min{2};
    HMI2_max_multilayer_total(i,1) = HMI_max{2};
    HMI2_mean_multilayer_total(i,1) = HMI_mean{2};
    HMI_multilayer_connector_score{i,1} = {HMI_min{3},HMI_max{3},HMI_mean{3}};
end
delete(p);
toc

csvwrite('03_Result/HMI1_min_monolayer_total_FirstSC_Inter_NullModel.csv', HMI1_min_monolayer_total);
csvwrite('03_Result/HMI1_max_monolayer_total_FirstSC_Inter_NullModel.csv', HMI1_max_monolayer_total);
csvwrite('03_Result/HMI1_mean_monolayer_total_FirstSC_Inter_NullModel.csv', HMI1_mean_monolayer_total);
csvwrite('03_Result/HMI2_min_monolayer_total_FirstSC_Inter_NullModel.csv', HMI2_min_monolayer_total);
csvwrite('03_Result/HMI2_max_monolayer_total_FirstSC_Inter_NullModel.csv', HMI2_max_monolayer_total);
csvwrite('03_Result/HMI2_mean_monolayer_total_FirstSC_Inter_NullModel.csv', HMI2_mean_monolayer_total);

csvwrite('03_Result/HMI1_min_multilayer_total_FirstSC_Inter_NullModel.csv', HMI1_min_multilayer_total);
csvwrite('03_Result/HMI1_max_multilayer_total_FirstSC_Inter_NullModel.csv', HMI1_max_multilayer_total);
csvwrite('03_Result/HMI1_mean_multilayer_total_FirstSC_Inter_NullModel.csv', HMI1_mean_multilayer_total);
csvwrite('03_Result/HMI2_min_multilayer_total_FirstSC_Inter_NullModel.csv', HMI2_min_multilayer_total);
csvwrite('03_Result/HMI2_max_multilayer_total_FirstSC_Inter_NullModel.csv', HMI2_max_multilayer_total);
csvwrite('03_Result/HMI2_mean_multilayer_total_FirstSC_Inter_NullModel.csv', HMI2_mean_multilayer_total);

csvwrite('03_Result/Q_monolayer_max_total_FirstSC_Inter_NullModel.csv', monolayer_modularity);
csvwrite('03_Result/Q_multilayer_max_total_FirstSC_Inter_NullModel.csv', multilayer_modularity);

save('03_Result/HMI_monolayer_connector_score_FirstSC_Inter_NullModel.mat',"HMI_monolayer_connector_score")
save('03_Result/HMI_multilayer_connector_score_FirstSC_Inter_NullModel.mat',"HMI_multilayer_connector_score")
%-------------------------------------------------------------------------%

%%
iterations = 1000;
monolayer_modularity = zeros(iterations, 1);
HMI1_min_monolayer_total = zeros(iterations, 1);
HMI1_max_monolayer_total = zeros(iterations, 1);
HMI1_mean_monolayer_total = zeros(iterations, 1);
HMI2_min_monolayer_total = zeros(iterations, 1);
HMI2_max_monolayer_total = zeros(iterations, 1);
HMI2_mean_monolayer_total = zeros(iterations, 1);

multilayer_modularity = zeros(iterations, 1);
HMI1_min_multilayer_total = zeros(iterations, 1);
HMI1_max_multilayer_total = zeros(iterations, 1);
HMI1_mean_multilayer_total = zeros(iterations, 1);
HMI2_min_multilayer_total = zeros(iterations, 1);
HMI2_max_multilayer_total = zeros(iterations, 1);
HMI2_mean_multilayer_total = zeros(iterations, 1);

HMI_monolayer_connector_score = cell(iterations, 1);
HMI_multilayer_connector_score = cell(iterations, 1);

SX_fileInfo = dir(fullfile(pwd, '01_DATA/First/SX/','*.csv'));
SX_fileNames = {SX_fileInfo.name}';
SX_filePath1 = fullfile(pwd,'01_DATA/First/SX/',SX_fileNames(1));
SX_filePath2 = fullfile(pwd,'01_DATA/First/SX/',SX_fileNames(2));

layer1data=importdata(SX_filePath1{1});
layer1data=layer1data.data;

layer2data=importdata(SX_filePath2{1});
layer2data=layer2data.data;

tic
p=parpool(60);
parfor i=1:iterations
    layer1data_randperm=randperm(size(layer1data,1));
    layer2data_randperm=randperm(size(layer2data,1));
    layer1_data = layer1data(layer1data_randperm,:);
    layer2_data = layer2data(layer2data_randperm,:);

    intra_data = {layer1_data,layer2_data};
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

    monolayer_modularity(i,1) = modularity;
    HMI1_min_monolayer_total(i,1) = HMI_min{1};
    HMI1_max_monolayer_total(i,1) = HMI_max{1};
    HMI1_mean_monolayer_total(i,1) = HMI_mean{1};
    HMI2_min_monolayer_total(i,1) = HMI_min{2};
    HMI2_max_monolayer_total(i,1) = HMI_max{2};
    HMI2_mean_monolayer_total(i,1) = HMI_mean{2};
    HMI_monolayer_connector_score{i,1} = {HMI_min{3},HMI_max{3},HMI_mean{3}};

    %%
    % Calculate multilayer modularity(without interlayer links weight)
    % Calculate HMI min
    % Calculate HMI max
    % Calculate HMI mean
    method = 'multilayer';
    inter_data=[0.00000001 0.066 0.00000001 0.059 0.015 0.093 0.102 0.00000001 0.02 0.00000001 0.00000001];
    [modularity, module_partition] = modularity_module_partition(intra_data,inter_data,method,layer,iter,networktype,inter_links_type);

    HMI_min = HomoMI(method,'min',module_partition,inter_data);
    HMI_max = HomoMI(method,'max',module_partition,inter_data);
    HMI_mean = HomoMI(method,'mean',module_partition,inter_data);

    multilayer_modularity(i,1) = modularity;
    HMI1_min_multilayer_total(i,1) = HMI_min{1};
    HMI1_max_multilayer_total(i,1) = HMI_max{1};
    HMI1_mean_multilayer_total(i,1) = HMI_mean{1};
    HMI2_min_multilayer_total(i,1) = HMI_min{2};
    HMI2_max_multilayer_total(i,1) = HMI_max{2};
    HMI2_mean_multilayer_total(i,1) = HMI_mean{2};
    HMI_multilayer_connector_score{i,1} = {HMI_min{3},HMI_max{3},HMI_mean{3}};
end
delete(p);
toc

csvwrite('03_Result/HMI1_min_monolayer_total_FirstSX_Inter_NullModel.csv', HMI1_min_monolayer_total);
csvwrite('03_Result/HMI1_max_monolayer_total_FirstSX_Inter_NullModel.csv', HMI1_max_monolayer_total);
csvwrite('03_Result/HMI1_mean_monolayer_total_FirstSX_Inter_NullModel.csv', HMI1_mean_monolayer_total);
csvwrite('03_Result/HMI2_min_monolayer_total_FirstSX_Inter_NullModel.csv', HMI2_min_monolayer_total);
csvwrite('03_Result/HMI2_max_monolayer_total_FirstSX_Inter_NullModel.csv', HMI2_max_monolayer_total);
csvwrite('03_Result/HMI2_mean_monolayer_total_FirstSX_Inter_NullModel.csv', HMI2_mean_monolayer_total);

csvwrite('03_Result/HMI1_min_multilayer_total_FirstSX_Inter_NullModel.csv', HMI1_min_multilayer_total);
csvwrite('03_Result/HMI1_max_multilayer_total_FirstSX_Inter_NullModel.csv', HMI1_max_multilayer_total);
csvwrite('03_Result/HMI1_mean_multilayer_total_FirstSX_Inter_NullModel.csv', HMI1_mean_multilayer_total);
csvwrite('03_Result/HMI2_min_multilayer_total_FirstSX_Inter_NullModel.csv', HMI2_min_multilayer_total);
csvwrite('03_Result/HMI2_max_multilayer_total_FirstSX_Inter_NullModel.csv', HMI2_max_multilayer_total);
csvwrite('03_Result/HMI2_mean_multilayer_total_FirstSX_Inter_NullModel.csv', HMI2_mean_multilayer_total);

csvwrite('03_Result/Q_monolayer_max_total_FirstSX_Inter_NullModel.csv', monolayer_modularity);
csvwrite('03_Result/Q_multilayer_max_total_FirstSX_Inter_NullModel.csv', multilayer_modularity);

save('03_Result/HMI_monolayer_connector_score_FirstSX_Inter_NullModel.mat',"HMI_monolayer_connector_score")
save('03_Result/HMI_multilayer_connector_score_FirstSX_Inter_NullModel.mat',"HMI_multilayer_connector_score")