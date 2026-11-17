clc
clear

load("PPH45_NullModel.mat")
layer1data_NullModel_Data = PH_NullModel_Data;
layer2data_NullModel_Data = PP_NullModel_Data;
NumberOfNetwork = size(layer1data_NullModel_Data,2);

iterations=1000;
monolayer_modularity = zeros(iterations, NumberOfNetwork);
HMI1_min_monolayer_total = zeros(iterations, NumberOfNetwork);
HMI1_max_monolayer_total = zeros(iterations, NumberOfNetwork);
HMI1_mean_monolayer_total = zeros(iterations, NumberOfNetwork);
HMI2_min_monolayer_total = zeros(iterations, NumberOfNetwork);
HMI2_max_monolayer_total = zeros(iterations, NumberOfNetwork);
HMI2_mean_monolayer_total = zeros(iterations, NumberOfNetwork);

multilayer_modularity = zeros(iterations, NumberOfNetwork);
HMI1_min_multilayer_total = zeros(iterations, NumberOfNetwork);
HMI1_max_multilayer_total = zeros(iterations, NumberOfNetwork);
HMI1_mean_multilayer_total = zeros(iterations, NumberOfNetwork);
HMI2_min_multilayer_total = zeros(iterations, NumberOfNetwork);
HMI2_max_multilayer_total = zeros(iterations, NumberOfNetwork);
HMI2_mean_multilayer_total = zeros(iterations, NumberOfNetwork);

HMI_monolayer_connector_score = cell(iterations, NumberOfNetwork);
HMI_multilayer_connector_score = cell(iterations, NumberOfNetwork);

for NetworkID=1:NumberOfNetwork
    NetworkID

    tic
    p=parpool(60);
    parfor i=1:iterations

        layer1data = layer1data_NullModel_Data{i,NetworkID};
        layer2data = layer2data_NullModel_Data{i,NetworkID};

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

        monolayer_modularity(i,NetworkID) = modularity;
        HMI1_min_monolayer_total(i,NetworkID) = HMI_min{1};
        HMI1_max_monolayer_total(i,NetworkID) = HMI_max{1};
        HMI1_mean_monolayer_total(i,NetworkID) = HMI_mean{1};
        HMI2_min_monolayer_total(i,NetworkID) = HMI_min{2};
        HMI2_max_monolayer_total(i,NetworkID) = HMI_max{2};
        HMI2_mean_monolayer_total(i,NetworkID) = HMI_mean{2};
        HMI_monolayer_connector_score{i,NetworkID} = {HMI_min{3},HMI_max{3},HMI_mean{3}};

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

        multilayer_modularity(i,NetworkID) = modularity;
        HMI1_min_multilayer_total(i,NetworkID) = HMI_min{1};
        HMI1_max_multilayer_total(i,NetworkID) = HMI_max{1};
        HMI1_mean_multilayer_total(i,NetworkID) = HMI_mean{1};
        HMI2_min_multilayer_total(i,NetworkID) = HMI_min{2};
        HMI2_max_multilayer_total(i,NetworkID) = HMI_max{2};
        HMI2_mean_multilayer_total(i,NetworkID) = HMI_mean{2};
        HMI_multilayer_connector_score{i,NetworkID} = {HMI_min{3},HMI_max{3},HMI_mean{3}};
    end
    delete(p);
    toc

    csvwrite('03_Result/HMI1_min_monolayer_total_PPH_Intra_NullModel.csv', HMI1_min_monolayer_total);
    csvwrite('03_Result/HMI1_max_monolayer_total_PPH_Intra_NullModel.csv', HMI1_max_monolayer_total);
    csvwrite('03_Result/HMI1_mean_monolayer_total_PPH_Intra_NullModel.csv', HMI1_mean_monolayer_total);
    csvwrite('03_Result/HMI2_min_monolayer_total_PPH_Intra_NullModel.csv', HMI2_min_monolayer_total);
    csvwrite('03_Result/HMI2_max_monolayer_total_PPH_Intra_NullModel.csv', HMI2_max_monolayer_total);
    csvwrite('03_Result/HMI2_mean_monolayer_total_PPH_Intra_NullModel.csv', HMI2_mean_monolayer_total);

    csvwrite('03_Result/HMI1_min_multilayer_total_PPH_Intra_NullModel.csv', HMI1_min_multilayer_total);
    csvwrite('03_Result/HMI1_max_multilayer_total_PPH_Intra_NullModel.csv', HMI1_max_multilayer_total);
    csvwrite('03_Result/HMI1_mean_multilayer_total_PPH_Intra_NullModel.csv', HMI1_mean_multilayer_total);
    csvwrite('03_Result/HMI2_min_multilayer_total_PPH_Intra_NullModel.csv', HMI2_min_multilayer_total);
    csvwrite('03_Result/HMI2_max_multilayer_total_PPH_Intra_NullModel.csv', HMI2_max_multilayer_total);
    csvwrite('03_Result/HMI2_mean_multilayer_total_PPH_Intra_NullModel.csv', HMI2_mean_multilayer_total);

    csvwrite('03_Result/Q_monolayer_max_total_PPH_Intra_NullModel.csv', monolayer_modularity);
    csvwrite('03_Result/Q_multilayer_max_total_PPH_Intra_NullModel.csv', multilayer_modularity);

    save('03_Result/HMI_monolayer_connector_score_PPH_Intra_NullModel.mat',"HMI_monolayer_connector_score")
    save('03_Result/HMI_multilayer_connector_score_PPH_Intra_NullModel.mat',"HMI_multilayer_connector_score")
end