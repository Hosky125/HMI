clc
clear

% 使用 dir 函数获取当前路径下某个文件夹中所有 .csv 文件的信息
PHP_fileInfo = dir(fullfile(pwd, 'DATA/PHP_87','*.txt'));
PHP_fileNames = {PHP_fileInfo.name}';

networksize = zeros(length(PHP_fileInfo)/2,4);%4列依次表示：ph的行数、ph的列数、pp的行数、pp的列数
linksnum = zeros(length(PHP_fileInfo)/2,2);%ph的连接数、pp的连接数
%connectance = zeros(69*174,1);

iterations = 1;
iter=100;
Q_mean_max_total = zeros(iterations, length(PHP_fileInfo)/2);
HMI_monolayer_total =  zeros(iterations, length(PHP_fileInfo)/2);
Q_multilayer_max_total = zeros(iterations, length(PHP_fileInfo)/2);
HMI_multilayer_total =  zeros(iterations, length(PHP_fileInfo)/2);

%测试PPH网络
count=0;
for php_index=1:87
        
    count=count+1;%用于计数网络数
    count
    % 构建完整的文件路径
    PHP_filePath1 = fullfile(pwd,'DATA/PHP_87',PHP_fileNames(php_index));
    PHP_filePath2 = fullfile(pwd,'DATA/PHP_87',PHP_fileNames(php_index+87));


    % 读取文件
    PH=importdata(PHP_filePath1{1});
    PH=PH.data;

    PP=importdata(PHP_filePath2{1});
    PP=PP.data;

    p_h = PH;
    p_p = PP;

    % 数据预处理，删除全0行或全0列
    if length(find(sum(p_h,2)==0))==0
        p_h = p_h;
    else
        index = find(sum(p_h,2)==0);
        p_h(index,:) = [];
    end

    if length(find(sum(p_p,2)==0))==0
        p_p = p_p;
    else
        index = find(sum(p_p,2)==0);
        p_p(index,:) = [];
    end

    if length(find(sum(p_h,1)==0))==0
        p_h = p_h;
    else
        index = find(sum(p_h,1)==0);
        p_h(:,index) = [];
    end

    if length(find(sum(p_p,1)==0))==0
        p_p = p_p;
    else
        index = find(sum(p_p,1)==0);
        p_p(:,index) = [];
    end

    % 匹配p_p与p_h,按照行数小的为标准
    if size(p_h,1)>size(p_p,1)
        p_p = p_p;
        % 随机选取 min个不重复的整数,并检查生成的数组是否有重复
        randomUniqueIntegers = randperm(size(p_h,1), size(p_p,1));%（默认行向量）
        if length(unique(randomUniqueIntegers)) == size(p_p,1)
            disp('所有数值均不重复！');
            p_h = p_h(randomUniqueIntegers,:);
        else
            disp('存在重复值！');
        end
    end

    if size(p_h,1)<size(p_p,1)
        p_h = p_h;
        randomUniqueIntegers = randperm(size(p_p,1), size(p_h,1));%（默认行向量）
        if length(unique(randomUniqueIntegers)) == size(p_h,1)
            disp('所有数值均不重复！');
            p_p = p_p(randomUniqueIntegers,:);
        else
            disp('存在重复值！');
        end
    end

    if size(p_h,1)==size(p_p,1)
        p_h = p_h;
        p_p = p_p;
    end

    % 再次检查数据,可能会出现全0列,需要删除全0列
    if length(find(sum(p_h,1)==0))==0
        p_h = p_h;
    else
        index = find(sum(p_h,1)==0);
        p_h(:,index) = [];
    end

    if length(find(sum(p_p,1)==0))==0
        p_p = p_p;
    else
        index = find(sum(p_p,1)==0);
        p_p(:,index) = [];
    end

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
    for i=1:iterations
        p_h=p_h_raw;
        p_p=p_p_raw;

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
        Q_mean_max_total(i,count) = max(Q_mean);
        S1_monolayer_total(:,i) = S1_plant(:,index(1));
        S2_monolayer_total(:,i) = S2_plant(:,index(1));
        % calculate monolayer HMI(unweight)
        module_partition=[S1_plant(:,index(1))';S2_plant(:,index(1))'];
        HomoMI("monolayer",module_partition,0);
        HMI_monolayer_total(i,count) = HomoMI("monolayer",module_partition,0);
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Calculate multilayer modularity(without interlayer links weight)
        interlayer_link_strength = ones(1,p_N);

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
        Q_multilayer_max_total(i,count) = max(Q_multilayer_total);
        index = find(Q_multilayer_total==max(Q_multilayer_total));
        S1_multilayer_total(:, i) = S1_multilayer_plant(:,index(1));
        S2_multilayer_total(:, i) = S2_multilayer_plant(:,index(1));
        %calculate multilayer HMI(without interlayer links weight)
        module_partition=[S1_multilayer_plant(:,index(1))';S2_multilayer_plant(:,index(1))'];
        HMI_multilayer_total(i,count) = HomoMI("multilayer",module_partition,interlayer_link_strength);
    end
    toc

    csvwrite('HMI_monolayer_total_PHP_Raw.csv', HMI_monolayer_total);
    csvwrite('HMI_multilayer_total_PHP_Raw.csv', HMI_multilayer_total);
    csvwrite('Q_mean_max_total_PHP_Raw.csv', Q_mean_max_total);
    csvwrite('Q_multilayer_max_total_PHP_Raw.csv', Q_multilayer_max_total);

end
