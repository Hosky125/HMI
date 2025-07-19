function judge_matrix = calculate_judge_matrix(method,part_module_partition,smallest_module_layer_index)
    %input:"method" indicates the method adopted for module partition. 
    %      "part_module_partition" represents the partition matrix of a certain module
    %      "samllest_module_layer_index" represents the layer where the minimum module partition is located
    %output:"judge_matrix" indicates whether the module partition of the node in the two adjacent layers matches or not, where 1 indicates a match and 0 indicates a mismatch
    %---------------------------------------------------------------------%
    if "monolayer"==method
        %Judge the consistency of module partition at each layer
        judge_matrix=[];%A matrix of (n-1)*m
        for j=1:(size(part_module_partition,1)-1)
            data1=part_module_partition(j,:);
            data2=part_module_partition(j+1,:);
            %-------------------------------------------------------------%
            if length(unique(data1))>length(unique(data2))
                maxdata=data1;
                mindata=data2;

                %The result of matching between independent nodes is regarded as 0
                judge=zeros(1,length(data1));
                mindataindex=unique(mindata);
                for i=1:length(mindataindex)
                    index=find(mindata==mindataindex(i));

                    if length(index)>1
                        sumindex=mindata(index)+maxdata(index);
                        frequency_table = tabulate(sumindex);
                        maxfrequency=max(frequency_table(:,2));
                        if maxfrequency>1
                            neededsum=frequency_table(find(frequency_table(:,2)==maxfrequency),1);
                            judge(index(find(sumindex==neededsum(1))))=1;%出现多个时，选择了第一个，后续可优化
                        end
                    end
                end
                judge_matrix(j,:)=judge;
            end
            %-------------------------------------------------------------%
            if length(unique(data1))<length(unique(data2))
                maxdata=data2;
                mindata=data1;

                %The result of matching between independent nodes is regarded as 0
                judge=zeros(1,length(data1));
                mindataindex=unique(mindata);
                for i=1:length(mindataindex)
                    index=find(mindata==mindataindex(i));

                    if length(index)>1
                        sumindex=mindata(index)+maxdata(index);
                        frequency_table = tabulate(sumindex);
                        maxfrequency=max(frequency_table(:,2));
                        if maxfrequency>1
                            neededsum=frequency_table(find(frequency_table(:,2)==maxfrequency),1);
                            judge(index(find(sumindex==neededsum(1))))=1;%出现多个时，选择了第一个，后续可优化
                        end
                    end
                end
                judge_matrix(j,:)=judge;
            end
            %-------------------------------------------------------------%
            if length(unique(data1))==length(unique(data2))
                %~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
                maxdata=data1;
                mindata=data2;

                %The result of matching between independent nodes is regarded as 0
                judge1=zeros(1,length(data1));
                mindataindex=unique(mindata);
                for i=1:length(mindataindex)
                    index=find(mindata==mindataindex(i));

                    if length(index)>1
                        sumindex=mindata(index)+maxdata(index);
                        frequency_table = tabulate(sumindex);
                        maxfrequency=max(frequency_table(:,2));
                        if maxfrequency>1
                            neededsum=frequency_table(find(frequency_table(:,2)==maxfrequency),1);
                            judge1(index(find(sumindex==neededsum(1))))=1;%出现多个时，选择了第一个，后续可优化
                        end
                    end
                end
                %~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
                maxdata=data2;
                mindata=data1;

                %The result of matching between independent nodes is regarded as 0
                judge2=zeros(1,length(data1));
                mindataindex=unique(mindata);
                for i=1:length(mindataindex)
                    index=find(mindata==mindataindex(i));

                    if length(index)>1
                        sumindex=mindata(index)+maxdata(index);
                        frequency_table = tabulate(sumindex);
                        maxfrequency=max(frequency_table(:,2));
                        if maxfrequency>1
                            neededsum=frequency_table(find(frequency_table(:,2)==maxfrequency),1);
                            judge2(index(find(sumindex==neededsum(1))))=1;%出现多个时，选择了第一个，后续可优化
                        end
                    end
                end
                
                if sum(judge1)>sum(judge2)
                    judge=judge1;
                else
                    judge=judge2;
                end
                judge_matrix(j,:)=judge;
                %~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
            end
            %-------------------------------------------------------------%
        end
    end
    %---------------------------------------------------------------------%
    if "multilayer"==method
        %Judge the consistency of module partition at each layer
        judge_matrix=[];%A matrix of (n-1)*m
        for j=1:(size(part_module_partition,1)-1)
            judge1 = part_module_partition(j,:)==part_module_partition(j+1,:);
            judge2 = part_module_partition(j+1,:)==part_module_partition(smallest_module_layer_index,:);
            judge1_2 = judge1+judge2;
            judge_matrix(j,:)=judge1_2==2;
        end
    end
    %---------------------------------------------------------------------%
end
