function HMI=HomoMI(method,module_partition,interlayer_links_weight)
%"method" indicates the method adopted for module partition. 
%"monolayer" indicates that each layer independently divides the modules. 
% For monolayer, the module indexes of nodes divided at different layers are inconsistent.
%"multilayer" indicates that the nodes of all layers are placed together for module partition.
% For multilayer, the module indexes of node division are consistent.
%"module_partition" represents the module partitioning situation of connector species(for example, m) in the n-layer network. 
% It is an n*m matrix, and each row represents the module partitioning of one layer.
%If interlayer links weights is not taken into account, the interlayer_links_weight input is a matrix of (n-1)*m
%If interlayer links weights is not taken into account, the interlayer_links_weight input is 0
%-------------------------------------------------------------------------%
%find smallest module number and which layer have this module number
%find smallest module number
smallest_module_find=[];%Used to record the layer number and the number of modules divided in each layer
for i=1:size(module_partition,1)
    smallest_module_find(i,1)=i;
    smallest_module_find(i,2)=length(unique(module_partition(i,:)));
end
smallest_module_number=min(smallest_module_find(:,2));
%which layer have this module number
if length(find(smallest_module_find(:,2)==smallest_module_number))==1
    smallest_module_layer_index=find(smallest_module_find(:,2)==smallest_module_number);

    smallest_module=module_partition(smallest_module_layer_index,:);
    smallest_module_index=unique(smallest_module);
    %---------------------------------------------------------------------%
    HMI=0;
    for i=1:length(unique(smallest_module))
        %for each module,find the nodes module partition in all layers, noted part_module_partition
        nodeindex=find(smallest_module==smallest_module_index(i));

        %When the number of nodes in the same module is equal to 1, the HMI of this module is 0
        if length(nodeindex)==1
            weight=0;
            links_weight=1;
        end

        %Only if the number of nodes in the same module is greater than or equal to 2, it is considered to calculate the HMI
        if length(nodeindex)>1
            part_module_partition=module_partition(:,nodeindex);

            %calculate judge matrix
            judge_matrix=calculate_judge_matrix(method,part_module_partition,smallest_module_layer_index);

            %find max connected component
            [max_comp, max_start, max_end] = find_max_connected_component(judge_matrix);

            %Case1:without interlayer links weight
            if size(interlayer_links_weight,2)~=size(module_partition,2)
                %size(part_module_partition,2)=|Rk|
                %size(module_partition,2)=|Z1|+|Z2|+...+|Zpj|
                %size(judge_matrix,1)=m-1
                %each element in max_comp=s-1
                weight=size(part_module_partition,2)/size(module_partition,2);
                links_weight=(1/size(part_module_partition,2))*(sum(max_comp/size(judge_matrix,1)));
            end

            %Case2:with interlayer links weight
            adj_judge_matrix=zeros(size(judge_matrix,1),size(judge_matrix,2));

            for j=1:length(max_comp)
                if max_comp(j)~=0
                    adj_judge_matrix((max_start(j):max_end(j)),j)=1;
                end
            end

            if size(interlayer_links_weight,2)==size(module_partition,2)
                part_interlayer_links_weight=interlayer_links_weight(:,nodeindex);
                if size(part_interlayer_links_weight,1)==1
                    weight=(sum(part_interlayer_links_weight))/(sum(interlayer_links_weight));
                    links_weight=(1/size(part_module_partition,2))*(sum((part_interlayer_links_weight.*adj_judge_matrix)./part_interlayer_links_weight));
                else
                    weight=(sum(sum(part_interlayer_links_weight)))/(sum(sum(interlayer_links_weight)));
                    links_weight=(1/size(part_module_partition,2))*(sum(sum(part_interlayer_links_weight.*adj_judge_matrix)./sum(part_interlayer_links_weight)));
                end

            end
        end
        HMI=HMI+weight*links_weight;
    end
    %---------------------------------------------------------------------%
else
    smallest_module_layer_index_set=find(smallest_module_find(:,2)==smallest_module_number);
    HMI_Total=[];
    for k=1:length(smallest_module_layer_index_set)
        smallest_module_layer_index=smallest_module_layer_index_set(k);

        %smallest_module_layer_index;
        smallest_module=module_partition(smallest_module_layer_index,:);
        smallest_module_index=unique(smallest_module);
        %-------------------------------------------------------------------------%
        HMI=0;
        for i=1:length(unique(smallest_module))
            %for each module,find the nodes module partition in all layers, noted part_module_partition
            nodeindex=find(smallest_module==smallest_module_index(i));

            %When the number of nodes in the same module is equal to 1, the HMI of this module is 0
            if length(nodeindex)==1
                weight=0;
                links_weight=1;
            end

            %Only if the number of nodes in the same module is greater than or equal to 2, it is considered to calculate the HMI
            if length(nodeindex)>1
                part_module_partition=module_partition(:,nodeindex);

                %calculate judge matrix
                judge_matrix=calculate_judge_matrix(method,part_module_partition,smallest_module_layer_index);

                %find max connected component
                [max_comp, max_start, max_end] = find_max_connected_component(judge_matrix);

                %Case1:without interlayer links weight
                if size(interlayer_links_weight,2)~=size(module_partition,2)
                    %size(part_module_partition,2)=|Rk|
                    %size(module_partition,2)=|Z1|+|Z2|+...+|Zpj|
                    %size(judge_matrix,1)=m-1
                    %each element in max_comp=s-1
                    weight=size(part_module_partition,2)/size(module_partition,2);
                    links_weight=(1/size(part_module_partition,2))*(sum(max_comp/size(judge_matrix,1)));
                end

                %Case2:with interlayer links weight
                adj_judge_matrix=zeros(size(judge_matrix,1),size(judge_matrix,2));

                for j=1:length(max_comp)
                    if max_comp(j)~=0
                        adj_judge_matrix((max_start(j):max_end(j)),j)=1;
                    end
                end

                if size(interlayer_links_weight,2)==size(module_partition,2)
                    part_interlayer_links_weight=interlayer_links_weight(:,nodeindex);
                    if size(part_interlayer_links_weight,1)==1
                        weight=(sum(part_interlayer_links_weight))/(sum(interlayer_links_weight));
                        links_weight=(1/size(part_module_partition,2))*(sum((part_interlayer_links_weight.*adj_judge_matrix)./part_interlayer_links_weight));
                    else
                        weight=(sum(sum(part_interlayer_links_weight)))/(sum(sum(interlayer_links_weight)));
                        links_weight=(1/size(part_module_partition,2))*(sum(sum(part_interlayer_links_weight.*adj_judge_matrix)./sum(part_interlayer_links_weight)));
                    end

                end
            end
            HMI=HMI+weight*links_weight;
        end
        %-----------------------------------------------------------------%
        HMI_Total=[HMI_Total,HMI];
    end
    %HMI=sum(HMI_Total)/length(HMI_Total);
    HMI=max(HMI_Total);
end

end