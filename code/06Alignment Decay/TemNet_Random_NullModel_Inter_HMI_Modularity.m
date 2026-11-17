fileInfo = dir(fullfile(pwd, '01_DATA/TemNet_Random','.'));
fileInfo = fileInfo([fileInfo.isdir] & ~ismember({fileInfo.name}, {'.', '..'}));
iterations = 100;
NumberOfNetwork = length(fileInfo);
for NetworkID = 1:NumberOfNetwork
    NetworkID
    filepath = fullfile(pwd, '01_DATA', 'TemNet_Random', fileInfo(NetworkID).name);
    filename = dir(fullfile(filepath, '*.txt'));

    layer = length(filename);
    inter_data = [];
    iter = 100;
    networktype = 'bipartite';
    inter_links_type = 'multiplex';

    monolayer_modularity = zeros(iterations, 1);
    HMI1_min_monolayer = zeros(iterations, 1);
    HMI1_max_monolayer = zeros(iterations, 1);
    HMI1_mean_monolayer = zeros(iterations, 1);
    HMI2_min_monolayer = zeros(iterations, 1);
    HMI2_max_monolayer = zeros(iterations, 1);
    HMI2_mean_monolayer = zeros(iterations, 1);

    multilayer_modularity = zeros(iterations, 1);
    HMI1_min_multilayer = zeros(iterations, 1);
    HMI1_max_multilayer = zeros(iterations, 1);
    HMI1_mean_multilayer = zeros(iterations, 1);
    HMI2_min_multilayer = zeros(iterations, 1);
    HMI2_max_multilayer = zeros(iterations, 1);
    HMI2_mean_multilayer = zeros(iterations, 1);

    HMI_monolayer_connector_score  = cell(iterations, 1);
    HMI_multilayer_connector_score = cell(iterations, 1);

   
    for i = 1:iterations
        intra_data = cell(1, layer);
        for k = 1:layer
            subfilepath = fullfile(filepath, filename(k).name);
            data = importdata(subfilepath);
            idx = randperm(size(data, 1));
            data = data(idx, :);
            idx = randperm(size(data, 2));
            data = data(:, idx);
            intra_data{k} = data;
        end

        %% ---------- Monolayer ----------
        method = 'monolayer';
        [modularity_mono, module_partition_mono] = modularity_module_partition( ...
            intra_data, inter_data, method, layer, iter, networktype, inter_links_type);
        HMI_min_mono  = HomoMI(method, 'min',  module_partition_mono, inter_data);
        HMI_max_mono  = HomoMI(method, 'max',  module_partition_mono, inter_data);
        HMI_mean_mono = HomoMI(method, 'mean', module_partition_mono, inter_data);

        %% ---------- Multilayer ----------
        method = 'multilayer';
        [modularity_multi, module_partition_multi] = modularity_module_partition( ...
            intra_data, inter_data, method, layer, iter, networktype, inter_links_type);
        HMI_min_multi  = HomoMI(method, 'min',  module_partition_multi, inter_data);
        HMI_max_multi  = HomoMI(method, 'max',  module_partition_multi, inter_data);
        HMI_mean_multi = HomoMI(method, 'mean', module_partition_multi, inter_data);

        monolayer_modularity(iterations, 1)     = modularity_mono;
        HMI1_min_monolayer(iterations, 1)       = HMI_min_mono{1};
        HMI1_max_monolayer(iterations, 1)       = HMI_max_mono{1};
        HMI1_mean_monolayer(iterations, 1)      = HMI_mean_mono{1};
        HMI2_min_monolayer(iterations, 1)       = HMI_min_mono{2};
        HMI2_max_monolayer(iterations, 1)       = HMI_max_mono{2};
        HMI2_mean_monolayer(iterations, 1)      = HMI_mean_mono{2};
        HMI_monolayer_connector_score{iterations, 1} = ...
            {HMI_min_mono{3}, HMI_max_mono{3}, HMI_mean_mono{3}};

        multilayer_modularity(iterations, 1)    = modularity_multi;
        HMI1_min_multilayer(iterations, 1)      = HMI_min_multi{1};
        HMI1_max_multilayer(iterations, 1)      = HMI_max_multi{1};
        HMI1_mean_multilayer(iterations, 1)     = HMI_mean_multi{1};
        HMI2_min_multilayer(iterations, 1)      = HMI_min_multi{2};
        HMI2_max_multilayer(iterations, 1)      = HMI_max_multi{2};
        HMI2_mean_multilayer(iterations, 1)     = HMI_mean_multi{2};
        HMI_multilayer_connector_score{iterations, 1} = ...
            {HMI_min_multi{3}, HMI_max_multi{3}, HMI_mean_multi{3}};
    end

    csvwrite(strcat('02_Result/HMI1_min_monolayer_total_TemNet_Random_Inter_NullModel_', sprintf('%02d', NetworkID), '.csv'), HMI1_min_monolayer);
    csvwrite(strcat('02_Result/HMI1_max_monolayer_total_TemNet_Random_Inter_NullModel_', sprintf('%02d', NetworkID), '.csv'), HMI1_max_monolayer);
    csvwrite(strcat('02_Result/HMI1_mean_monolayer_total_TemNet_Random_Inter_NullModel_', sprintf('%02d', NetworkID), '.csv'), HMI1_mean_monolayer);
    csvwrite(strcat('02_Result/HMI2_min_monolayer_total_TemNet_Random_Inter_NullModel_', sprintf('%02d', NetworkID), '.csv'), HMI2_min_monolayer);
    csvwrite(strcat('02_Result/HMI2_max_monolayer_total_TemNet_Random_Inter_NullModel_', sprintf('%02d', NetworkID), '.csv'), HMI2_max_monolayer);
    csvwrite(strcat('02_Result/HMI2_mean_monolayer_total_TemNet_Random_Inter_NullModel_', sprintf('%02d', NetworkID), '.csv'), HMI2_mean_monolayer);

    csvwrite(strcat('02_Result/HMI1_min_multilayer_total_TemNet_Random_Inter_NullModel_', sprintf('%02d', NetworkID), '.csv'), HMI1_min_multilayer);
    csvwrite(strcat('02_Result/HMI1_max_multilayer_total_TemNet_Random_Inter_NullModel_', sprintf('%02d', NetworkID), '.csv'), HMI1_max_multilayer);
    csvwrite(strcat('02_Result/HMI1_mean_multilayer_total_TemNet_Random_Inter_NullModel_', sprintf('%02d', NetworkID), '.csv'), HMI1_mean_multilayer);
    csvwrite(strcat('02_Result/HMI2_min_multilayer_total_TemNet_Random_Inter_NullModel_', sprintf('%02d', NetworkID), '.csv'), HMI2_min_multilayer);
    csvwrite(strcat('02_Result/HMI2_max_multilayer_total_TemNet_Random_Inter_NullModel_', sprintf('%02d', NetworkID), '.csv'), HMI2_max_multilayer);
    csvwrite(strcat('02_Result/HMI2_mean_multilayer_total_TemNet_Random_Inter_NullModel_', sprintf('%02d', NetworkID), '.csv'), HMI2_mean_multilayer);

    csvwrite(strcat('02_Result/Q_monolayer_max_total_TemNet_Random_Inter_NullModel_', sprintf('%02d', NetworkID), '.csv'), monolayer_modularity);
    csvwrite(strcat('02_Result/Q_multilayer_max_total_TemNet_Random_Inter_NullModel_', sprintf('%02d', NetworkID), '.csv'), multilayer_modularity);

    save(strcat('02_Result/HMI_monolayer_connector_score_TemNet_Random_Inter_NullModel_', sprintf('%02d', NetworkID), '.mat'), 'HMI_monolayer_connector_score');
    save(strcat('02_Result/HMI_multilayer_connector_score_TemNet_Random_Inter_NullModel_', sprintf('%02d', NetworkID), '.mat'), 'HMI_multilayer_connector_score');
end