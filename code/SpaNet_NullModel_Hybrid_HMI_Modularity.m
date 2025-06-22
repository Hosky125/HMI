clc
clear

iter=100;
iterations=1000;%1000次random null model
Q_Random_total=zeros(iterations,9);%monolayer modularity
HMI_Random_total=zeros(iterations,9);%monolayer HMI
Q_multilayer_Random_total=zeros(iterations,9);%multilayer modularity
HMI_multilayer_Random_total=zeros(iterations,9);%multilayer HMI

for ID=1:9
    ID
    SpaNet_NullModel_Data_Name = strcat("SpaNet",sprintf('%02d', ID),"_NullModel",".mat");
    load(SpaNet_NullModel_Data_Name)
    layer=size(SpaNet_NullModel_Data,2);

    %依次计算每层的monolayer HMI/mean monolayer modularity
    Q_Random=[];%存储每层每次循环的monolayer modularity
    HMI_Random=[];%存储每层每次循环的monolayer HMI
    Q_multilayer_Random=[];%存储每层每次循环的multilayer modularity
    HMI_multilayer_Random=[];%存储每层每次循环的multilayer HMI
    tic
    pp=parpool(60);
    parfor j=1:iterations
        Q_max=[];
        S_max=cell(1,layer);
        A=cell(1,layer);%用于存储随机打乱后的数据
        for k=1:layer
            data=SpaNet_NullModel_Data{j,k};
            data_randperm=randperm(size(data,1));
            data = data(data_randperm,:);
            data_randperm=randperm(size(data,2));
            data = data(:,data_randperm);

            % Modularity matrix for a monolayer network
            [B,mm]=generate_monolayer_networks_supra_adjacency_matrix(data,1);

            % Calculate monolayer modularity
            iter=100;
            Q_100=[];%1*100的向量，每列表示一次monolayer modularity
            S_100=cell(1,iter);%每列表示一次module partition

            for t=1:iter
                [S,Q] = genlouvain(B,10000,0,1,1);
                Q_100 = [Q_100 Q/(2*mm)];
                S_100{t} = S;
            end
            % find max monolayer modularity
            index=find(Q_100==max(Q_100));
            Q_max=[Q_max Q_100(index(1))];
            S_max{k}=S_100{index(1)};

            %-------------------------------------------------------------%
            %获得随机打乱后的各层网络
            %根据随机交换后的网络，需要根据该网络进行后续的multilayer modularity，这里需要加上modularity matrix
            % Transform the pxq matrix into (p+q)x(p+q)
            [p,q]=size(data);
            onemode=zeros(p+q,p+q);
            onemode(1:p, (p+1):(p+q))=data;
            onemode((p+1):(p+q), 1:p)=data';
            A{k}=onemode;
            %-------------------------------------------------------------%
        end
        %用于存储/计算，random mean monolayer modularity和monolayer HMI
        Q_Random=[Q_Random mean(Q_max)];
        module_partition=zeros(layer,size(S_max{1},1));
        for u=1:layer
            module_partition(u,:)=S_max{u};
        end
        HMI_Random=[HMI_Random HomoMI("monolayer",module_partition,0)];

        %=================================================================%
        %calculate multilayer modularity
        %step1: get modularity matrix for this multilayer network
        interlayer_links_weight=ones((layer-1),p+q);
        networktype="bipartite";
        interlayer_links_type="multiplex";
        [B,mm]=generate_multilayer_modularity_matrix(A,p,q,1,networktype,interlayer_links_type,interlayer_links_weight);

        iter=100;
        Q_multilayer_100=[];%1*100的向量，每列表示一次monolayer modularity
        S_multilayer_100=cell(1,iter);%92*100的矩阵，每列表示一次module partition
        for t=1:iter
            [S,Q] = genlouvain(B,10000,0,1,1);
            Q_multilayer_100 = [Q_multilayer_100 Q/(2*mm)];
            S_multilayer_100{t} = S;
        end
        % find max monolayer modularity
        index=find(Q_multilayer_100==max(Q_multilayer_100));
        Q_multilayer_Random=[Q_multilayer_Random Q_multilayer_100(index(1))];
        S_multilayer=S_multilayer_100{index(1)};

        module_partition=zeros(layer,p+q);
        for u=1:layer
            module_partition(u,:)=S_multilayer((1:(p+q))+(u-1)*(p+q),1)';
        end
        HMI_multilayer_Random=[HMI_multilayer_Random HomoMI("multilayer",module_partition,interlayer_links_weight)];
        %=================================================================%
    end
    delete(pp);
    toc

    Q_Random_total(:,ID)=Q_Random';
    HMI_Random_total(:,ID)=HMI_Random';
    Q_multilayer_Random_total(:,ID)=Q_multilayer_Random';
    HMI_multilayer_Random_total(:,ID)=HMI_multilayer_Random';

    csvwrite('HMI_monolayer_total_SpaNet_Hybrid_NullModel.csv', HMI_Random_total);
    csvwrite('HMI_multilayer_total_SpaNet_Hybrid_NullModel.csv', HMI_multilayer_Random_total);
    csvwrite('Q_mean_max_total_SpaNet_Hybrid_NullModel.csv', Q_Random_total);
    csvwrite('Q_multilayer_max_total_SpaNet_Hybrid_NullModel.csv', Q_multilayer_Random_total);

end