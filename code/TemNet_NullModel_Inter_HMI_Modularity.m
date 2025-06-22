clc
clear
%temporal multilayer networks(layers���ڵ���2��)
%calculate monolayer HMI/mean monolayer modularity/multilayer modularity
%calculate raw data and 1000 random data
%%��Ҫ�������ݣ�ʹ��ÿ���������ͬά�ȵ�

Q_Random_total=zeros(1000,10);%monolayer modularity
HMI_Random_total=zeros(1000,10);%monolayer HMI
Q_multilayer_Random_total=zeros(1000,10);%multilayer modularity
HMI_multilayer_Random_total=zeros(1000,10);%multilayer HMI
for i=1:10
    i
    filepath = strcat(pwd,'\DATA\TemNet\Network',num2str(i,'%02d'),'\');
    %filename = dir([filepath,'*.txt']);
    filename = dir([filepath,'*.csv']);
    
    layer=length(filename);
    MonoData = cell(1,layer);
    %�õ�ÿ������ݣ��洢��MonoData��
    for j=1:layer
        subfilepath=strcat(filepath,filename(j).name);
        Data=importdata(subfilepath);
        MonoData{j}=Data.data;
    end
    

    %���μ���ÿ���monolayer HMI/mean monolayer modularity
    iterations=1000;%�������1000��
    Q_Random=[];%�洢ÿ��ÿ��ѭ����monolayer modularity
    HMI_Random=[];%�洢ÿ��ÿ��ѭ����monolayer HMI
    Q_multilayer_Random=[];%�洢ÿ��ÿ��ѭ����multilayer modularity
    HMI_multilayer_Random=[];%�洢ÿ��ÿ��ѭ����multilayer HMI
    tic
    pp=parpool(60);
    parfor j=1:iterations
        Q_max=[];
        S_max=cell(1,layer);
        A=cell(1,layer);%���ڴ洢������Һ������
        for k=1:layer
            data=MonoData{k};
            %�������,������н���,������н���
            data_randperm=randperm(size(data,1));
            data = data(data_randperm,:);
            data_randperm=randperm(size(data,2));
            data = data(:,data_randperm);
            
            % Modularity matrix for a monolayer network
            [B,mm]=generate_monolayer_networks_supra_adjacency_matrix(data,1);

            % Calculate monolayer modularity
            iter=100;
            Q_100=[];%1*100��������ÿ�б�ʾһ��monolayer modularity
            S_100=cell(1,iter);%92*100�ľ���ÿ�б�ʾһ��module partition

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
            %���������Һ�ĸ�������
            %�����������������磬��Ҫ���ݸ�������к�����multilayer modularity��������Ҫ����modularity matrix
            % Transform the pxq matrix into (p+q)x(p+q)
            [p,q]=size(data);
            onemode=zeros(p+q,p+q);
            onemode(1:p, (p+1):(p+q))=data;
            onemode((p+1):(p+q), 1:p)=data';
            A{k}=onemode;
            %-------------------------------------------------------------%
        end
        %���ڴ洢/���㣬random mean monolayer modularity��monolayer HMI
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
        Q_multilayer_100=[];%1*100��������ÿ�б�ʾһ��monolayer modularity
        S_multilayer_100=cell(1,iter);%92*100�ľ���ÿ�б�ʾһ��module partition
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
    
    Q_Random_total(:,i)=Q_Random';
    HMI_Random_total(:,i)=HMI_Random';
    Q_multilayer_Random_total(:,i)=Q_multilayer_Random';
    HMI_multilayer_Random_total(:,i)=HMI_multilayer_Random';
    
    csvwrite('HMI_monolayer_total_TemNet_Inter_NullModel.csv', HMI_Random_total);
    csvwrite('Q_mean_max_total_TemNet_Inter_NullModel.csv', Q_Random_total);
    csvwrite('Q_multilayer_max_total_TemNet_Inter_NullModel.csv', Q_multilayer_Random_total);
    csvwrite('HMI_multilayer_total_TemNet_Inter_NullModel.csv', HMI_multilayer_Random_total);

end