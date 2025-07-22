function [modularity, module_partition] = modularity_module_partition(intra_data,inter_data,method,layer,iter,networktype,inter_links_type)

if "monolayer"==method
    Q_max=[];
    S_max=cell(1,layer);
    
    for k=1:layer
        data=intra_data{k};
        
        % modularity matrix for a monolayer network
        [B,mm]=generate_monolayer_networks_supra_adjacency_matrix(data,1);
        
        % calculate monolayer modularity
        Q_iter=[];%1*iter的向量，每列表示一次monolayer modularity
        S_iter=cell(1,iter);%92*100的矩阵，每列表示一次module partition
        
        for t=1:iter
            [S,Q] = genlouvain(B,10000,0,1,1);
            Q_iter = [Q_iter Q/(2*mm)];
            S_iter{t} = S;
        end
        
        % find max monolayer modularity
        index=find(Q_iter==max(Q_iter));
        Q_max=[Q_max Q_iter(index(1))];
        S_max{k}=S_iter{index(1)};
    end

    %save mean monolayer modularity and module partition
    modularity=mean(Q_max);

    if "multiplex"==inter_links_type
        module_partition=zeros(layer,size(S_max{1},1));
        for u=1:layer
            module_partition(u,:)=S_max{u}';
        end
    end

    if "diagonal_coupling"==inter_links_type
        module_partition=zeros(layer,size(intra_data{1},1));
        for u=1:layer
            module_partition_total=S_max{u};
            module_partition(u,:)=module_partition_total(1:size(intra_data{1},1));
        end
    end


end

if "multilayer"==method
    
    if "multiplex"==inter_links_type
        A=cell(1,layer);
        for k=1:layer
            data=intra_data{k};
            % Transform the pxq matrix into (p+q)x(p+q)
            [p,q]=size(data);
            onemode=zeros(p+q,p+q);
            onemode(1:p, (p+1):(p+q))=data;
            onemode((p+1):(p+q), 1:p)=data';
            A{k}=onemode;
        end
        
        if inter_data==0
            inter_data=ones((layer-1),p+q);
        end
        
        % generate multilayer networks supra adjacency matrix
        [B,mm]=generate_multilayer_modularity_matrix(A,p,q,1,networktype,inter_links_type,inter_data);
        
        Q_multilayer_iter=[];
        S_multilayer_iter=cell(1,iter);%(p+q)*iter的矩阵，每列表示一次module partition
        for t=1:iter
            [S,Q] = genlouvain(B,10000,0,1,1);
            Q_multilayer_iter = [Q_multilayer_iter Q/(2*mm)];
            S_multilayer_iter{t} = S;
        end
        % find max monolayer modularity
        index=find(Q_multilayer_iter==max(Q_multilayer_iter));
        modularity=Q_multilayer_iter(index(1));
        S_multilayer=S_multilayer_iter{index(1)};
        
        module_partition=zeros(layer,p+q);
        for u=1:layer
            module_partition(u,:)=S_multilayer((1:(p+q))+(u-1)*(p+q),1)';
        end
    
    end
    
    if "diagonal_coupling"==inter_links_type
        layer1=intra_data{1};
        layer2=intra_data{2};
        
        connector_num=min(size(layer1,1),size(layer2,1));
        if inter_data==0
            inter_data=ones(1,connector_num);
        end
        
        % generate multilayer networks supra adjacency matrix
        [B_multilayer,mm_multilayer] = generate_multilayer_networks_supra_adjacency_matrix(layer1,layer2,1,inter_data,0);

        S1_multilayer_plant=zeros(connector_num, iter);
        S2_multilayer_plant=zeros(connector_num, iter);
        Q_multilayer_total=zeros(iter, 1);
        col_num=size(layer1,2);

        for j=1:iter
            [S_multilayer,Q_multilayer] = genlouvain(B_multilayer,10000,0,1,1);
            S1_multilayer_plant(:,j) = S_multilayer(1:connector_num);
            S2_multilayer_plant(:,j) = S_multilayer((connector_num+col_num+1):(connector_num+col_num+connector_num));
            Q_multilayer_total(j,1) = Q_multilayer/mm_multilayer;
        end

        modularity= max(Q_multilayer_total);
        index = find(Q_multilayer_total==max(Q_multilayer_total));
        module_partition=[S1_multilayer_plant(:,index(1))';S2_multilayer_plant(:,index(1))'];
        
    end
end

end


