function [max_comp, max_start, max_end] = find_max_connected_component(judge_matrix)
    %输入:judge_matrix,表示各层节点是否划分为同一模块的判断矩阵
    
    % 依次找各个节点的连通分量
    result=cell(size(judge_matrix,2),3);
    for i=1:size(judge_matrix,2)
        index_start=[];
        index_end=[];
        index_Duration_length=[];
        useful_index = 0;
        %~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
        if sum(judge_matrix(:,i))==size(judge_matrix,1)
            index_start=1;
            index_end=size(judge_matrix,1);
            index_Duration_length=index_end-index_start+1;
        end
        %~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
        if sum(judge_matrix(:,i))~=size(judge_matrix,1)
            for j=1:size(judge_matrix,1)
                if judge_matrix(j,i)==1
                    useful_index=useful_index+1;
                    index_start(useful_index)=j;
                    %-----------------------------------------------------%
                    if j~=size(judge_matrix,1)
                        for k=(j+1):size(judge_matrix,1)
                            if judge_matrix(k,i)==0
                                index_end(useful_index)=k-1;
                                break;
                            end

                            if judge_matrix(k,i)==1
                                index_end(useful_index)=k;
                            end
                        end

                        index_Duration_length(useful_index)=index_end(useful_index)-index_start(useful_index)+1;
                    end
                    %-----------------------------------------------------%
                    if j==size(judge_matrix,1)
                        k=j;
                        if judge_matrix(k,i)==0
                            index_end(useful_index)=k-1;
                            break;
                        end

                        if judge_matrix(k,i)==1
                            index_end(useful_index)=k;
                        end
                        index_Duration_length(useful_index)=index_end(useful_index)-index_start(useful_index)+1;
                    end
                    %-----------------------------------------------------%
                end
            end
        end
        %~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
        result{i,1}=index_start;
        result{i,2}=index_end;
        result{i,3}=index_Duration_length;
    end
    
    % 找到最大连通分量的对应标签
    max_comp=[];
    max_index=[];
    for i=1:size(judge_matrix,2)
        if isempty(result{i,3})
            max_comp=[max_comp,0];
            max_index=[max_index,0];
        end

        if ~isempty(result{i,3})
            max_comp=[max_comp,max(result{i,3})];
            index=find(result{i,3}==max(result{i,3}));%后续可以考虑加个比较，在算interlayer links weight时，涉及到多个max时，可以会有差异，应该所有的都算，然后再考虑最大的
            max_index=[max_index,index(1)];
        end
    end
    
    % 提取属于最大连通分量的节点索引
    max_start=[];
    max_end=[];
    for i=1:length(max_index)
        if max_index(i)==0
            max_start=[max_start,0];
            max_end=[max_end,0];
        end

        if max_index(i)~=0
            max_start=[max_start,result{i,1}(max_index(i))];
            max_end=[max_end,result{i,2}(max_index(i))];
        end
    end

end