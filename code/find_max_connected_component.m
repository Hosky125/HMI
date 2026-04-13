function max_comp = find_max_connected_component(judge_matrix,inter_data)

    %%
    if size(inter_data,2)~=size(judge_matrix,2)
        inter_data = ones(size(judge_matrix,1),size(judge_matrix,2));
        max_comp = [];
        for j = 1:size(inter_data,2)
            current_len = 0;
            max_len = 0;
            for i = 1:size(inter_data,1)
                if judge_matrix(i,j) == 1
                    current_len = current_len + inter_data(i,j);
                else
                    current_len = 0;
                end

                if current_len > max_len
                    max_len = current_len;
                end
            end
            max_comp = [max_comp,max_len];
        end
    end

    %%
    if size(inter_data,2)==size(judge_matrix,2)
        max_comp = [];
        for j = 1:size(inter_data,2)
            current_len = 0;
            max_len = 0;
            for i = 1:size(inter_data,1)
                if judge_matrix(i,j) == 1
                    current_len = current_len + inter_data(i,j);
                else
                    current_len = 0;
                end

                if current_len > max_len
                    max_len = current_len;
                end
            end
            max_comp = [max_comp,max_len];
        end
    end

end
