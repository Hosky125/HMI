function HMI_MEAN=HomoMI(method,strategy,module_partition,inter_data)
%"method" indicates the method adopted for module partition.
%"strategy" indicates the criterion based on which the number of modules is determined, which can be maximum(max), minimum(min) or average(mean=(max+min)/2).
%"monolayer" indicates that each layer independently divides the modules.
% For monolayer, the module indexes of nodes divided at different layers are inconsistent.
%"multilayer" indicates that the nodes of all layers are placed together for module partition.
% For multilayer, the module indexes of node division are consistent.
%"module_partition" represents the module partitioning situation of connector species(for example, m) in the n-layer network.
% It is an n*m matrix, and each row represents the module partitioning of one layer.
%If interlayer links weights is not taken into account, the interlayer_links_weight input is a matrix of (n-1)*m
%If interlayer links weights is not taken into account, the interlayer_links_weight input is 0
%-------------------------------------------------------------------------%
%-------------------------------------------------------------------------%
%%
if string('min')==strategy
    %calculate judge matrix
    judge_matrix=calculate_judge_matrix(method,strategy,module_partition);
    HMI_TOTAL = {};
    for i = 1:size(judge_matrix,2)
        %calculate HMI
        % size(module_partition,1) % layer
        % size(module_partition,2) % number of connector species

        %Case1:without interlayer links weight
        if size(inter_data,2)~=size(module_partition,2)
            %find max connected component
            max_comp = find_max_connected_component(judge_matrix{i},inter_data);

            HMI = sum((1/size(module_partition,2)) * (sum(judge_matrix{i})/(size(module_partition,1)-1)));
            % sum(sum(judge_matrix{i}))/((size(module_partition,1)-1)*size(module_partition,2))
            % CI = sum(max_comp)/size(module_partition,2); % CI=ConsistencyIndex
            NCI = (sum(max_comp)/size(module_partition,2))/(size(module_partition,1)-1); % NCI=NormalizedConsistencyIndex
            HMI_TOTAL{i,1} = HMI;
            HMI_TOTAL{i,2} = NCI;
            HMI_TOTAL{i,3} = max_comp/(size(module_partition,1)-1);
        end

        %Case2:with interlayer links weight
        if size(inter_data,2)==size(module_partition,2)
            %find max connected component
            max_comp = find_max_connected_component(judge_matrix{i},inter_data);

            HMI = sum(sum(inter_data .* judge_matrix{i}))/sum(sum(inter_data));
            NCI = sum(max_comp)/sum(sum(inter_data));
            HMI_TOTAL{i,1} = HMI;
            HMI_TOTAL{i,2} = NCI;
            HMI_TOTAL{i,3} = max_comp./sum(inter_data);
        end
    end

    HMI = [];
    NCI = [];
    MaxComp = [];
    for i = 1:size(HMI_TOTAL,1)
        HMI = [HMI;HMI_TOTAL{i,1}];
        NCI = [NCI;HMI_TOTAL{i,2}];
        MaxComp = [MaxComp;HMI_TOTAL{i,3}];
    end

    if size(MaxComp,1)>1
        HMI_MEAN = {mean(HMI),mean(NCI),mean(MaxComp)};
    else
        HMI_MEAN = {HMI,NCI,MaxComp};
    end
end

%%
if string('max')==strategy
    %calculate judge matrix
    judge_matrix=calculate_judge_matrix(method,strategy,module_partition);
    HMI_TOTAL = {};
    for i = 1:size(judge_matrix,2)
        %calculate HMI
        % size(module_partition,1) % layer
        % size(module_partition,2) % number of connector species

        %Case1:without interlayer links weight
        if size(inter_data,2)~=size(module_partition,2)
            %find max connected component
            max_comp = find_max_connected_component(judge_matrix{i},inter_data);

            HMI = sum((1/size(module_partition,2)) * (sum(judge_matrix{i})/(size(module_partition,1)-1)));
            % sum(sum(judge_matrix{i}))/((size(module_partition,1)-1)*size(module_partition,2))
            % CI = sum(max_comp)/size(module_partition,2); % CI=ConsistencyIndex
            NCI = (sum(max_comp)/size(module_partition,2))/(size(module_partition,1)-1); % NCI=NormalizedConsistencyIndex
            HMI_TOTAL{i,1} = HMI;
            HMI_TOTAL{i,2} = NCI;
            HMI_TOTAL{i,3} = max_comp/(size(module_partition,1)-1);
        end

        %Case2:with interlayer links weight
        if size(inter_data,2)==size(module_partition,2)
            %find max connected component
            max_comp = find_max_connected_component(judge_matrix{i},inter_data);

            HMI = sum(sum(inter_data .* judge_matrix{i}))/sum(sum(inter_data));
            NCI = sum(max_comp)/sum(sum(inter_data));
            HMI_TOTAL{i,1} = HMI;
            HMI_TOTAL{i,2} = NCI;
            HMI_TOTAL{i,3} = max_comp./sum(inter_data);
        end
    end

    HMI = [];
    NCI = [];
    MaxComp = [];
    for i = 1:size(HMI_TOTAL,1)
        HMI = [HMI;HMI_TOTAL{i,1}];
        NCI = [NCI;HMI_TOTAL{i,2}];
        MaxComp = [MaxComp;HMI_TOTAL{i,3}];
    end

    if size(MaxComp,1)>1
        HMI_MEAN = {mean(HMI),mean(NCI),mean(MaxComp)};
    else
        HMI_MEAN = {HMI,NCI,MaxComp};
    end

end

if string('mean')==strategy
    strategy = 'min';
    %calculate judge matrix
    judge_matrix=calculate_judge_matrix(method,strategy,module_partition);
    HMI_TOTAL = {};
    for i = 1:size(judge_matrix,2)
        %calculate HMI
        % size(module_partition,1) % layer
        % size(module_partition,2) % number of connector species

        %Case1:without interlayer links weight
        if size(inter_data,2)~=size(module_partition,2)
            %find max connected component
            max_comp = find_max_connected_component(judge_matrix{i},inter_data);

            HMI = sum((1/size(module_partition,2)) * (sum(judge_matrix{i})/(size(module_partition,1)-1)));
            % sum(sum(judge_matrix{i}))/((size(module_partition,1)-1)*size(module_partition,2))
            % CI = sum(max_comp)/size(module_partition,2); % CI=ConsistencyIndex
            NCI = (sum(max_comp)/size(module_partition,2))/(size(module_partition,1)-1); % NCI=NormalizedConsistencyIndex
            HMI_TOTAL{i,1} = HMI;
            HMI_TOTAL{i,2} = NCI;
            HMI_TOTAL{i,3} = max_comp/(size(module_partition,1)-1);
        end

        %Case2:with interlayer links weight
        if size(inter_data,2)==size(module_partition,2)
            %find max connected component
            max_comp = find_max_connected_component(judge_matrix{i},inter_data);

            HMI = sum(sum(inter_data .* judge_matrix{i}))/sum(sum(inter_data));
            NCI = sum(max_comp)/sum(sum(inter_data));
            HMI_TOTAL{i,1} = HMI;
            HMI_TOTAL{i,2} = NCI;
            HMI_TOTAL{i,3} = max_comp./sum(inter_data);
        end
    end

    HMI = [];
    NCI = [];
    MaxComp = [];
    for i = 1:size(HMI_TOTAL,1)
        HMI = [HMI;HMI_TOTAL{i,1}];
        NCI = [NCI;HMI_TOTAL{i,2}];
        MaxComp = [MaxComp;HMI_TOTAL{i,3}];
    end

    if size(MaxComp,1)>1
        HMI_MEAN1 = {mean(HMI),mean(NCI),mean(MaxComp)};
    else
        HMI_MEAN1 = {HMI,NCI,MaxComp};
    end

    %%
    strategy = 'max';
    %calculate judge matrix
    judge_matrix=calculate_judge_matrix(method,strategy,module_partition);
    HMI_TOTAL = {};
    for i = 1:size(judge_matrix,2)
        %calculate HMI
        % size(module_partition,1) % layer
        % size(module_partition,2) % number of connector species

        %Case1:without interlayer links weight
        if size(inter_data,2)~=size(module_partition,2)
            %find max connected component
            max_comp = find_max_connected_component(judge_matrix{i},inter_data);

            HMI = sum((1/size(module_partition,2)) * (sum(judge_matrix{i})/(size(module_partition,1)-1)));
            % sum(sum(judge_matrix{i}))/((size(module_partition,1)-1)*size(module_partition,2))
            % CI = sum(max_comp)/size(module_partition,2); % CI=ConsistencyIndex
            NCI = (sum(max_comp)/size(module_partition,2))/(size(module_partition,1)-1); % NCI=NormalizedConsistencyIndex
            HMI_TOTAL{i,1} = HMI;
            HMI_TOTAL{i,2} = NCI;
            HMI_TOTAL{i,3} = max_comp/(size(module_partition,1)-1);
        end

        %Case2:with interlayer links weight
        if size(inter_data,2)==size(module_partition,2)
            %find max connected component
            max_comp = find_max_connected_component(judge_matrix{i},inter_data);

            HMI = sum(sum(inter_data .* judge_matrix{i}))/sum(sum(inter_data));
            NCI = sum(max_comp)/sum(sum(inter_data));
            HMI_TOTAL{i,1} = HMI;
            HMI_TOTAL{i,2} = NCI;
            HMI_TOTAL{i,3} = max_comp./sum(inter_data);
        end
    end

    HMI = [];
    NCI = [];
    MaxComp = [];
    for i = 1:size(HMI_TOTAL,1)
        HMI = [HMI;HMI_TOTAL{i,1}];
        NCI = [NCI;HMI_TOTAL{i,2}];
        MaxComp = [MaxComp;HMI_TOTAL{i,3}];
    end

    if size(MaxComp,1)>1
        HMI_MEAN2 = {mean(HMI),mean(NCI),mean(MaxComp)};
    else
        HMI_MEAN2 = {HMI,NCI,MaxComp};
    end

    HMI_MEAN = {mean([HMI_MEAN1{1};HMI_MEAN2{1}]),mean([HMI_MEAN1{2};HMI_MEAN2{2}]),mean([HMI_MEAN1{3};HMI_MEAN2{3}])};
end


end
