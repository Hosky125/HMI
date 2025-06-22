clc
clear
%temporal multilayer networks(layers大于等于2层)
%calculate monolayer HMI/mean monolayer modularity/multilayer modularity
%calculate raw data and 1000 random data
%%需要处理数据，使其每层的数据是同维度的

Q_Random_total=zeros(1,10);%monolayer modularity
HMI_Random_total=zeros(1,10);%monolayer HMI
Q_multilayer_Random_total=zeros(1,10);%multilayer modularity
HMI_multilayer_Random_total=zeros(1,10);%multilayer HMI
for i=1:10
    i
    filepath = strcat(pwd,'\DATA\TemNet\Network',num2str(i,'%02d'),'\');
    %filename = dir([filepath,'*.txt']);
    filename = dir([filepath,'*.csv']);
    
    layer=length(filename);
    MonoData = cell(1,layer);
    %得到每层的数据，存储在MonoData中
    for j=1:layer
        subfilepath=strcat(filepath,filename(j).name);
        Data=importdata(subfilepath);
        MonoData{j}=Data.data;
    end
    

    %依次计算每层的monolayer HMI/mean monolayer modularity
    iterations=1;%随机打乱1000次
    Q_Random=[];%存储每层每次循环的monolayer modularity
    HMI_Random=[];%存储每层每次循环的monolayer HMI
    Q_multilayer_Random=[];%存储每层每次循环的multilayer modularity
    HMI_multilayer_Random=[];%存储每层每次循环的multilayer HMI
    tic
    for j=1:iterations
        Q_max=[];
        S_max=cell(1,layer);
        A=cell(1,layer);%用于存储随机打乱后的数据
        for k=1:layer
            data=MonoData{k};
            
            % Modularity matrix for a monolayer network
            [B,mm]=generate_monolayer_networks_supra_adjacency_matrix(data,1);

            % Calculate monolayer modularity
            iter=100;
            Q_100=[];%1*100的向量，每列表示一次monolayer modularity
            S_100=cell(1,iter);%92*100的矩阵，每列表示一次module partition

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
    toc
    
    Q_Random_total(:,i)=Q_Random';
    HMI_Random_total(:,i)=HMI_Random';
    Q_multilayer_Random_total(:,i)=Q_multilayer_Random';
    HMI_multilayer_Random_total(:,i)=HMI_multilayer_Random';

%     csvwrite('HMI_monolayer_total_TemNet_Raw.csv', HMI_Random_total);
%     csvwrite('Q_mean_max_total_TemNet_Raw.csv', Q_Random_total);
%     csvwrite('Q_multilayer_max_total_TemNet_Raw.csv', Q_multilayer_Random_total);
%     csvwrite('HMI_multilayer_total_TemNet_Raw.csv', HMI_multilayer_Random_total);
end
