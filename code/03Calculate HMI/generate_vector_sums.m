function all_sums = generate_vector_sums(C)
    % 从cell数组生成所有可能的向量和
    
    [nrows, ncols] = size(C);
    
    % 分析cell结构
    non_empty_indices = cell(nrows, 1);
    for i = 1:nrows
        indices = [];
        for j = 1:ncols
            if ~isempty(C{i, j})
                indices = [indices, j];
            end
        end
        non_empty_indices{i} = indices;
    end
    
    % 计算组合总数
    total_combos = 1;
    for i = 1:nrows
        total_combos = total_combos * length(non_empty_indices{i});
    end
    
    % 预分配结果
    all_sums = cell(1, total_combos);
    
    if total_combos == 0
        return;
    end
    
    % 获取向量长度
    for i = 1:nrows
        for j = 1:ncols
            if ~isempty(C{i, j})
                vec_length = length(C{i, j});
                break;
            end
        end
    end
    
    % 递归生成所有组合的和
    combo_count = 0;
    
    function recursive_sum(row_idx, current_sum)
        if row_idx > nrows
            combo_count = combo_count + 1;
            all_sums{combo_count} = current_sum;
        else
            for idx = 1:length(non_empty_indices{row_idx})
                col_idx = non_empty_indices{row_idx}(idx);
                
                if row_idx == 1
                    new_sum = C{row_idx, col_idx};
                else
                    new_sum = current_sum + C{row_idx, col_idx};
                end
                
                recursive_sum(row_idx + 1, new_sum);
            end
        end
    end
    
    % 开始递归
    recursive_sum(1, zeros(1, vec_length));
end