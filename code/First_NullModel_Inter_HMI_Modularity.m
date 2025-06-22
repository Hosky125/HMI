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
iter=100;
Q_mean_max_total = zeros(iterations, 2);
HMI_monolayer_total =  zeros(iterations, 2);
Q_multilayer_max_total = zeros(iterations, 2);
HMI_multilayer_total =  zeros(iterations, 2);

SC_fileInfo = dir(fullfile(pwd, '01_DATA/First/SC/','*.csv'));
SC_fileNames = {SC_fileInfo.name}';

% 构建完整的文件路径
SC_filePath1 = fullfile(pwd,'01_DATA/First/SC/',SC_fileNames(1));
SC_filePath2 = fullfile(pwd,'01_DATA/First/SC/',SC_fileNames(2));

% 读取文件
PH=importdata(SC_filePath1{1});
PH=PH.data;

PP=importdata(SC_filePath2{1});
PP=PP.data;

p_h = PH;
p_p = PP;

p_h_raw=p_h;
p_p_raw=p_p;

% 无intralayer links weight且无interlayer links weight时，
% 计算:monolayer HMI(无weight)和multilayer modularity
p_N=min(size(p_h,1),size(p_p,1));
S1_monolayer_total = zeros(p_N, iterations);
S2_monolayer_total = zeros(p_N, iterations);
S1_multilayer_total = zeros(p_N, iterations);
S2_multilayer_total = zeros(p_N, iterations);

tic
p=parpool(60);
parfor i=1:iterations
    p_h=p_h_raw;
    p_p=p_p_raw;

    ph_randperm=randperm(size(p_h,1));
    pp_randperm=randperm(size(p_p,1));
    p_h = p_h(ph_randperm,:);
    p_p = p_p(pp_randperm,:);

    % Calculate monolayer modularity
    [B1,mm1] = generate_monolayer_networks_supra_adjacency_matrix(p_h,1);
    [B2,mm2] = generate_monolayer_networks_supra_adjacency_matrix(p_p,1);

    S1_plant=zeros(p_N, iter);
    S2_plant=zeros(p_N, iter);
    Q1_total=zeros(iter, 1);
    Q2_total=zeros(iter, 1);
    Q_mean=zeros(iter, 1);

    for j=1:iter
        [S1,Q1] = genlouvain(B1,10000,0,1,1);
        [S2,Q2] = genlouvain(B2,10000,0,1,1);
        S1_plant(:,j) = S1(1:p_N);
        S2_plant(:,j) = S2(1:p_N);
        Q1_total(j,1) = Q1/(2*mm1);
        Q2_total(j,1) = Q2/(2*mm2);
        Q_mean(j,1) = (Q1/(2*mm1)+Q2/(2*mm2))/2;
    end

    max(Q_mean);
    index = find(Q_mean==max(Q_mean));
    Q_mean_max_total(i,1) = max(Q_mean);
    S1_monolayer_total(:,i) = S1_plant(:,index(1));
    S2_monolayer_total(:,i) = S2_plant(:,index(1));
    % calculate monolayer HMI(unweight)
    module_partition=[S1_plant(:,index(1))';S2_plant(:,index(1))'];
    HomoMI("monolayer",module_partition,0);
    HMI_monolayer_total(i,1) = HomoMI("monolayer",module_partition,0);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Calculate multilayer modularity(without interlayer links weight)
    interlayer_link_strength=[0.053 0.068 0.014 0.061 0.019 0.147 0.083 0.107 0.065];
%     interlayer_link_strength_raw=interlayer_link_strength;
%     interlayer_link_strength=interlayer_link_strength_raw;
%     inter_randperm=randperm(length(interlayer_link_strength));
%     interlayer_link_strength=interlayer_link_strength(1,inter_randperm);
    % generate multilayer networks supra adjacency matrix
    [B_multilayer,mm_multilayer] = generate_multilayer_networks_supra_adjacency_matrix(p_h,p_p,1,interlayer_link_strength,0);

    S1_multilayer_plant=zeros(p_N, iter);
    S2_multilayer_plant=zeros(p_N, iter);
    Q_multilayer_total=zeros(iter, 1);
    h_N=size(p_h,2);

    for j=1:iter
        [S_multilayer,Q_multilayer] = genlouvain(B_multilayer,10000,0,1,1);
        S1_multilayer_plant(:,j) = S_multilayer(1:p_N);
        S2_multilayer_plant(:,j) = S_multilayer((p_N+h_N+1):(p_N+h_N+p_N));
        Q_multilayer_total(j,1) = Q_multilayer/mm_multilayer;
    end

    max(Q_multilayer_total);
    Q_multilayer_max_total(i,1) = max(Q_multilayer_total);
    index = find(Q_multilayer_total==max(Q_multilayer_total));
    S1_multilayer_total(:, i) = S1_multilayer_plant(:,index(1));
    S2_multilayer_total(:, i) = S2_multilayer_plant(:,index(1));
    %calculate multilayer HMI(without interlayer links weight)
    module_partition=[S1_multilayer_plant(:,index(1))';S2_multilayer_plant(:,index(1))'];
    HMI_multilayer_total(i,1) = HomoMI("multilayer",module_partition,interlayer_link_strength);
end
delete(p);
toc
%-------------------------------------------------------------------------%
SX_fileInfo = dir(fullfile(pwd, '01_DATA/First/SX/','*.csv'));
SX_fileNames = {SX_fileInfo.name}';

% 构建完整的文件路径
SX_filePath1 = fullfile(pwd,'01_DATA/First/SX/',SX_fileNames(1));
SX_filePath2 = fullfile(pwd,'01_DATA/First/SX/',SX_fileNames(2));

% 读取文件
PH=importdata(SX_filePath1{1});
PH=PH.data;

PP=importdata(SX_filePath2{1});
PP=PP.data;

p_h = PH;
p_p = PP;

p_h_raw=p_h;
p_p_raw=p_p;

% 无intralayer links weight且无interlayer links weight时，
% 计算:monolayer HMI(无weight)和multilayer modularity
p_N=min(size(p_h,1),size(p_p,1));
S1_monolayer_total = zeros(p_N, iterations);
S2_monolayer_total = zeros(p_N, iterations);
S1_multilayer_total = zeros(p_N, iterations);
S2_multilayer_total = zeros(p_N, iterations);

tic
p=parpool(60);
parfor i=1:iterations
    p_h=p_h_raw;
    p_p=p_p_raw;

    ph_randperm=randperm(size(p_h,1));
    pp_randperm=randperm(size(p_p,1));
    p_h = p_h(ph_randperm,:);
    p_p = p_p(pp_randperm,:);

    % Calculate monolayer modularity
    [B1,mm1] = generate_monolayer_networks_supra_adjacency_matrix(p_h,1);
    [B2,mm2] = generate_monolayer_networks_supra_adjacency_matrix(p_p,1);

    S1_plant=zeros(p_N, iter);
    S2_plant=zeros(p_N, iter);
    Q1_total=zeros(iter, 1);
    Q2_total=zeros(iter, 1);
    Q_mean=zeros(iter, 1);

    for j=1:iter
        [S1,Q1] = genlouvain(B1,10000,0,1,1);
        [S2,Q2] = genlouvain(B2,10000,0,1,1);
        S1_plant(:,j) = S1(1:p_N);
        S2_plant(:,j) = S2(1:p_N);
        Q1_total(j,1) = Q1/(2*mm1);
        Q2_total(j,1) = Q2/(2*mm2);
        Q_mean(j,1) = (Q1/(2*mm1)+Q2/(2*mm2))/2;
    end

    max(Q_mean);
    index = find(Q_mean==max(Q_mean));
    Q_mean_max_total(i,2) = max(Q_mean);
    S1_monolayer_total(:,i) = S1_plant(:,index(1));
    S2_monolayer_total(:,i) = S2_plant(:,index(1));
    % calculate monolayer HMI(unweight)
    module_partition=[S1_plant(:,index(1))';S2_plant(:,index(1))'];
    HomoMI("monolayer",module_partition,0);
    HMI_monolayer_total(i,2) = HomoMI("monolayer",module_partition,0);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Calculate multilayer modularity(without interlayer links weight)
    interlayer_link_strength=[0 0.066 0 0.059 0.015 0.093 0.102 0 0.02 0 0];
%     interlayer_link_strength_raw=interlayer_link_strength;
%     interlayer_link_strength=interlayer_link_strength_raw;
%     inter_randperm=randperm(length(interlayer_link_strength));
%     interlayer_link_strength=interlayer_link_strength(1,inter_randperm);
    % generate multilayer networks supra adjacency matrix
    [B_multilayer,mm_multilayer] = generate_multilayer_networks_supra_adjacency_matrix(p_h,p_p,1,interlayer_link_strength,0);

    S1_multilayer_plant=zeros(p_N, iter);
    S2_multilayer_plant=zeros(p_N, iter);
    Q_multilayer_total=zeros(iter, 1);
    h_N=size(p_h,2);

    for j=1:iter
        [S_multilayer,Q_multilayer] = genlouvain(B_multilayer,10000,0,1,1);
        S1_multilayer_plant(:,j) = S_multilayer(1:p_N);
        S2_multilayer_plant(:,j) = S_multilayer((p_N+h_N+1):(p_N+h_N+p_N));
        Q_multilayer_total(j,1) = Q_multilayer/mm_multilayer;
    end

    max(Q_multilayer_total);
    Q_multilayer_max_total(i,2) = max(Q_multilayer_total);
    index = find(Q_multilayer_total==max(Q_multilayer_total));
    S1_multilayer_total(:, i) = S1_multilayer_plant(:,index(1));
    S2_multilayer_total(:, i) = S2_multilayer_plant(:,index(1));
    %calculate multilayer HMI(without interlayer links weight)
    module_partition=[S1_multilayer_plant(:,index(1))';S2_multilayer_plant(:,index(1))'];
    HMI_multilayer_total(i,2) = HomoMI("multilayer",module_partition,interlayer_link_strength);
end
delete(p);
toc

csvwrite('HMI_monolayer_total_First_Inter_NullModel1.csv', HMI_monolayer_total);
csvwrite('HMI_multilayer_total_First_Inter_NullModel1.csv', HMI_multilayer_total);
csvwrite('Q_mean_max_total_First_Inter_NullModel1.csv', Q_mean_max_total);
csvwrite('Q_multilayer_max_total_First_Inter_NullModel1.csv', Q_multilayer_max_total);