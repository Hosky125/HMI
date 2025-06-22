%Quantify the contribution of interlayer links to modular structure
%对所有网络随机匹配，构造出新的网络
%Case 1：without intralayer links weight and interlayer links weight
%计算每个网络1000次随机交换层间连接后的monolayer HMI和multilayer modularity

clc
clear

% 读取文件
% 使用 dir 函数获取当前路径下某个文件夹中所有 .csv 文件的信息
PPH_fileInfo = dir(fullfile(pwd, 'DATA/PPH_45_NullModel/','*.txt'));

% 初始化一个 cell 数组来存储所有文件名
PPH_fileNames = {PPH_fileInfo.name}';

PH_NullModel_Data=cell(1000,45);%1-45000
PP_NullModel_Data=cell(1000,45);%45001-90000

%将数据读取存储在cell中，每个元素为一个矩阵
tic
for i=1:45000

    % 构建完整的文件路径
    PH_filePath = fullfile(pwd,'DATA/PPH_45_NullModel/',PPH_fileNames(i));
    PP_filePath = fullfile(pwd,'DATA/PPH_45_NullModel/',PPH_fileNames(i+45000));

    m=mod(i,1000);
    if m==0
        m=1000;
    end
    n=ceil(i/1000);
    
    % 读取文件
    PH=importdata(PH_filePath{1});
    PH_NullModel_Data{m,n}=PH.data;

    PP=importdata(PP_filePath{1});
    PP_NullModel_Data{m,n}=PP.data;
end
toc
save("PPH45_NullModel","PH_NullModel_Data","PP_NullModel_Data")
load("PPH45_NullModel.mat")

iter=100;
iterations=1000;%1000次random null model
Q_mean_max_total = zeros(iterations, 45);
HMI_monolayer_total =  zeros(iterations, 45);
Q_multilayer_max_total = zeros(iterations, 45);
HMI_multilayer_total =  zeros(iterations, 45);

for j=1:45
    tic
    p=parpool(60);
    parfor i=1:iterations

        p_h = PH_NullModel_Data{i,j};
        p_p = PP_NullModel_Data{i,j};

        % Calculate monolayer modularity
        [B1,mm1] = generate_monolayer_networks_supra_adjacency_matrix(p_h,1);
        [B2,mm2] = generate_monolayer_networks_supra_adjacency_matrix(p_p,1);

        % 无intralayer links weight且无interlayer links weight时，
        % 计算:monolayer HMI(无weight)和multilayer modularity
        p_N=min(size(p_h,1),size(p_p,1));
        S1_plant=zeros(p_N, iter);
        S2_plant=zeros(p_N, iter);
        Q1_total=zeros(iter, 1);
        Q2_total=zeros(iter, 1);
        Q_mean=zeros(iter, 1);

        for k=1:iter
            [S1,Q1] = genlouvain(B1,10000,0,1,1);
            [S2,Q2] = genlouvain(B2,10000,0,1,1);
            S1_plant(:,k) = S1(1:p_N);
            S2_plant(:,k) = S2(1:p_N);
            Q1_total(k,1) = Q1/(2*mm1);
            Q2_total(k,1) = Q2/(2*mm2);
            Q_mean(k,1) = (Q1/(2*mm1)+Q2/(2*mm2))/2;
        end

        max(Q_mean);
        index = find(Q_mean==max(Q_mean));
        Q_mean_max_total(i,j) = max(Q_mean);
        % calculate monolayer HMI(unweight)
        module_partition=[S1_plant(:,index(1))';S2_plant(:,index(1))'];
        HMI_monolayer_total(i,j) = HomoMI("monolayer",module_partition,0);

        %=================================================================%
        % Calculate multilayer modularity(without interlayer links weight)
        interlayer_link_strength = ones(1,p_N);

        % generate multilayer networks supra adjacency matrix
        [B_multilayer,mm_multilayer] = generate_multilayer_networks_supra_adjacency_matrix(p_h,p_p,1,interlayer_link_strength,0);

        S1_multilayer_plant=zeros(p_N, iter);
        S2_multilayer_plant=zeros(p_N, iter);
        Q_multilayer_total=zeros(iter, 1);
        h_N=size(p_h,2);

        for k=1:iter
            [S_multilayer,Q_multilayer] = genlouvain(B_multilayer,10000,0,1,1);
            S1_multilayer_plant(:,k) = S_multilayer(1:p_N);
            S2_multilayer_plant(:,k) = S_multilayer((p_N+h_N+1):(p_N+h_N+p_N));
            Q_multilayer_total(k,1) = Q_multilayer/mm_multilayer;
        end

        Q_multilayer_max_total(i,j) = max(Q_multilayer_total);
        index = find(Q_multilayer_total==max(Q_multilayer_total));
        %calculate multilayer HMI(without interlayer links weight)
        module_partition=[S1_multilayer_plant(:,index(1))';S2_multilayer_plant(:,index(1))'];
        HMI_multilayer_total(i,j) = HomoMI("multilayer",module_partition,interlayer_link_strength);

    end
    delete(p);
    toc

    csvwrite('HMI_monolayer_total_PPH_Intra_NullModel.csv', HMI_monolayer_total);
    csvwrite('HMI_multilayer_total_PPH_Intra_NullModel.csv', HMI_multilayer_total);
    csvwrite('Q_mean_max_total_PPH_Intra_NullModel.csv', Q_mean_max_total);
    csvwrite('Q_multilayer_max_total_PPH_Intra_NullModel.csv', Q_multilayer_max_total);

end
%-------------------------------------------------------------------------%