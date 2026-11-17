% The function to generate inter-guild subnetworks with random connectance and species1 number(n_species1) and species2 number(n_species2)
% This code was written by Haotian Zhang on October 13, 2025.
% 要求species1的度都不为0,species2的度也都不为0
function interaction_matrix = generateBipartiteMatrix1(n_species1, n_species2, connectance)
    % 生成随机二分网络相互作用矩阵
    % 输入:
    %   n_species1 - 第一类物种数量，行
    %   n_species2 - 第二类物种数量，列
    %   connectance - 连接度（0到1之间）
    % 输出:
    %   bipartite_matrix - n_species1 × n_species2 的相互作用矩阵
    
   % 计算目标边数
    max_possible_edges = n_species1 * n_species2;
    target_edges = round(connectance * max_possible_edges);
    min_edges = max(n_species1, n_species2); % 确保边数至少能满足每行每列都有连接
    
    % 初始化邻接矩阵
    A = zeros(n_species1, n_species2);
    
    % 步骤1: 确保每行至少有一个连接
    for i = 1:n_species1
        available_cols = find(sum(A, 1) == 0); % 尚未连接的列
        if isempty(available_cols)
            % 如果所有列都已连接，随机选择一列
            col = randi(n_species2);
        else
            % 随机选择一个尚未连接的列
            col = available_cols(randi(length(available_cols)));
        end
        A(i, col) = 1;
    end
    
    % 步骤2: 确保每列至少有一个连接
    for j = 1:n_species2
        if sum(A(:, j)) == 0 % 如果该列还没有连接
            available_rows = find(sum(A, 2) == 1); % 寻找只有单一连接的行
            if isempty(available_rows)
                available_rows = 1:n_species1;
            end
            row = available_rows(randi(length(available_rows)));
            A(row, j) = 1;
        end
    end
    
    current_edges = sum(A(:));
    
    % 步骤3: 添加剩余的边以达到目标连通性
    if current_edges < target_edges
        edges_to_add = target_edges - current_edges;
        
        % 获取所有可能的边位置（零元素位置）
        [zero_rows, zero_cols] = find(A == 0);
        zero_indices = randperm(length(zero_rows));
        
        % 随机添加边
        for k = 1:min(edges_to_add, length(zero_indices))
            idx = zero_indices(k);
            A(zero_rows(idx), zero_cols(idx)) = 1;
        end
    end
    
    interaction_matrix = A;
end