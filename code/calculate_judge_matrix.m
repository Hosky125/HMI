function Judge_matrix = calculate_judge_matrix(method,strategy,module_partition)
%input:"method" indicates the method adopted for module partition.
%      "strategy" indicates the criterion based on which the number of modules is determined, which can be maximum(max), minimum(min) or average(mean=(max+min)/2).
%      "module_partition" represents the partition matrix of a certain module
%output:"Judge_matrix" indicates whether the module partition of the node in the two adjacent layers matches or not, where 1 indicates a match and 0 indicates a mismatch
%---------------------------------------------------------------------%
if "monolayer"==method
    %Judge the consistency of module partition at each layer
   
    judge_matrix={};
    same_index = [];
    for j=1:(size(module_partition,1)-1)
        data1=module_partition(j,:);
        data2=module_partition(j+1,:);
        %---------------------------------------------------------%
        if length(unique(data1))>length(unique(data2))
            maxdata=data1;
            mindata=data2;
            if string('min')==strategy
                Judge={};
                %The result of matching between independent nodes is regarded as 0
                mindataindex=unique(mindata);
                for i=1:length(mindataindex)
                    
                    index=find(mindata==mindataindex(i));
                    judge=zeros(1,length(data1));
                    if length(index)>1
                        sumindex=maxdata(index)+mindata(index);
                        frequency_table = tabulate(sumindex);
                        maxfrequency=max(frequency_table(:,2));
                        
                        if maxfrequency>1
                            neededsum=frequency_table(find(frequency_table(:,2)==maxfrequency),1);
                            for k=1:length(neededsum)
                                judge=zeros(1,length(data1));
                                judge(index(find(sumindex==neededsum(k))))=1;
                                Judge{i,k}=judge;
                            end
                        else
                            Judge{i,1}=judge;
                        end
                        
                    else
                        Judge{i,1}=judge;
                    end
                    
                end
            end
            
            if string('max')==strategy
                Judge={};
                %The result of matching between independent nodes is regarded as 0
                maxdataindex=unique(maxdata);
                for i=1:length(maxdataindex)
                    
                    index=find(maxdata==maxdataindex(i));
                    judge=zeros(1,length(data1));
                    if length(index)>1
                        sumindex=maxdata(index)+mindata(index);
                        frequency_table = tabulate(sumindex);
                        maxfrequency=max(frequency_table(:,2));
                        
                        if maxfrequency>1
                            neededsum=frequency_table(find(frequency_table(:,2)==maxfrequency),1);
                            for k=1:length(neededsum)
                                judge=zeros(1,length(data1));
                                judge(index(find(sumindex==neededsum(k))))=1;
                                Judge{i,k}=judge;
                            end
                        else
                            Judge{i,1}=judge;
                        end
                        
                    else
                        Judge{i,1}=judge;
                    end
                    
                end
            end
            judge = generate_vector_sums(Judge);
            for i=1:size(judge,2)
                judge_matrix{j,i}=judge{i};
            end
        end
        %---------------------------------------------------------%
        if length(unique(data1))<length(unique(data2))
            maxdata=data2;
            mindata=data1;
           if string('min')==strategy
                Judge={};
                %The result of matching between independent nodes is regarded as 0
                mindataindex=unique(mindata);
                for i=1:length(mindataindex)
                    
                    index=find(mindata==mindataindex(i));
                    judge=zeros(1,length(data1));
                    if length(index)>1
                        sumindex=maxdata(index)+mindata(index);
                        frequency_table = tabulate(sumindex);
                        maxfrequency=max(frequency_table(:,2));
                        
                        if maxfrequency>1
                            neededsum=frequency_table(find(frequency_table(:,2)==maxfrequency),1);
                            for k=1:length(neededsum)
                                judge=zeros(1,length(data1));
                                judge(index(find(sumindex==neededsum(k))))=1;
                                Judge{i,k}=judge;
                            end
                        else
                            Judge{i,1}=judge;
                        end
                        
                    else
                        Judge{i,1}=judge;
                    end
                    
                end
            end
            
            if string('max')==strategy
                Judge={};
                %The result of matching between independent nodes is regarded as 0
                maxdataindex=unique(maxdata);
                for i=1:length(maxdataindex)
                    
                    index=find(maxdata==maxdataindex(i));
                    judge=zeros(1,length(data1));
                    if length(index)>1
                        sumindex=maxdata(index)+mindata(index);
                        frequency_table = tabulate(sumindex);
                        maxfrequency=max(frequency_table(:,2));
                        
                        if maxfrequency>1
                            neededsum=frequency_table(find(frequency_table(:,2)==maxfrequency),1);
                            for k=1:length(neededsum)
                                judge=zeros(1,length(data1));
                                judge(index(find(sumindex==neededsum(k))))=1;
                                Judge{i,k}=judge;
                            end
                        else
                            Judge{i,1}=judge;
                        end
                        
                    else
                        Judge{i,1}=judge;
                    end
                    
                end
            end
            
            judge = generate_vector_sums(Judge);
            for i=1:size(judge,2)
                judge_matrix{j,i}=judge{i};
            end
        end
        %---------------------------------------------------------%
        if length(unique(data1))==length(unique(data2))
            same_index = [same_index,j];
            %---------------------------------------------------------%
            maxdata=data1;
            mindata=data2;
            Judge1 = {};
            %The result of matching between independent nodes is regarded as 0
            mindataindex=unique(mindata);
            for i=1:length(mindataindex)
                index=find(mindata==mindataindex(i));
                judge1=zeros(1,length(data1));
                if length(index)>1
                    sumindex=mindata(index)+maxdata(index);
                    frequency_table = tabulate(sumindex);
                    maxfrequency=max(frequency_table(:,2));
                    if maxfrequency>1
                        neededsum=frequency_table(find(frequency_table(:,2)==maxfrequency),1);
                        for k = 1:length(neededsum)
                             judge1=zeros(1,length(data1));
                             judge1(index(find(sumindex==neededsum(k))))=1;
                             Judge1{i,k} = judge1;
                        end
                    else
                        Judge1{i,1} = judge1;
                    end
                else
                    Judge1{i,1} = judge1;
                end
            end
            %---------------------------------------------------------%
            maxdata=data2;
            mindata=data1;
            
            Judge2 = {};
            %The result of matching between independent nodes is regarded as 0
            mindataindex=unique(mindata);
            for i=1:length(mindataindex)
                index=find(mindata==mindataindex(i));
                judge2=zeros(1,length(data1));
                if length(index)>1
                    sumindex=mindata(index)+maxdata(index);
                    frequency_table = tabulate(sumindex);
                    maxfrequency=max(frequency_table(:,2));
                    if maxfrequency>1
                        neededsum=frequency_table(find(frequency_table(:,2)==maxfrequency),1);
                        for k = 1:length(neededsum)
                             judge2=zeros(1,length(data1));
                             judge2(index(find(sumindex==neededsum(k))))=1;
                             Judge2{i,k} = judge2;
                        end
                    else
                        Judge2{i,1} = judge2;
                    end
                else
                    Judge2{i,1} = judge2;
                end
            end
            
            judge1 = generate_vector_sums(Judge1);
            for i=1:size(judge1,2)
                judge_matrix{j,i}=judge1{i};
            end
            judge2 = generate_vector_sums(Judge2);
            for i=1:size(judge2,2)
                judge_matrix{j,i+size(judge1,2)}=judge2{i};
            end
        end
        %-------------------------------------------------------------%
    end
  
    Judge_matrix = generate_matrices(judge_matrix);
end

%---------------------------------------------------------------------%
if "multilayer"==method
    %Judge the consistency of module partition at each layer
    judge_matrix=[];%A matrix of (n-1)*m
    for j=1:(size(module_partition,1)-1)
        data1=module_partition(j,:);
        data2=module_partition(j+1,:);

        judge = [];
        for i = 1:length(data1)
            judge = [judge,data1(i)==data2(i)];
        end
        
        judge_matrix(j,:)=judge;
    end
    Judge_matrix = {judge_matrix};
end
%---------------------------------------------------------------------%
    
end

