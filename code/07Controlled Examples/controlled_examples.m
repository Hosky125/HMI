%% R2-1: Controlled examples with known module assignments
clc
clear

% Examples 1 and 2 have six connector species and known correspondence
% between module labels across layers.
partition_p = [1 1 1 2 2 2];
partition_q = [1 1 2 1 2 2];

% Example 1: Same adjacent partition pairs, with the two aligned transitions
% for species 3 and 4 either consecutive or separated.
consecutive = [partition_q; partition_p; partition_p; partition_p; partition_q];
interrupted = [partition_p; partition_p; partition_q; partition_q; partition_p];

% Example 2: Fix partitions and total weight (10). Assign the two larger
% weights either to aligned species 1 and 2 or to switching species 3 and 4.
fixed_partition = [partition_p; partition_q];

% Examples 3 and 4: Split species 1-6 into groups of four and two, and
% reverse that transition for merging. Species 7-8 stay grouped together.
% Labels are assigned independently so HMI uses overlap to match modules.
coarse_partition = [1 1 1 1 1 1 2 2];
fine_partition = [2 2 2 2 3 3 1 1];
split_partition = [coarse_partition; fine_partition];
merged_partition = [fine_partition; coarse_partition];

controlled_partitions = {consecutive; interrupted; fixed_partition; fixed_partition; ...
                         split_partition; merged_partition};
controlled_weights = {[]; []; [3 3 1 1 1 1]; [1 1 3 3 1 1]; []; []};
controlled_methods = {'multilayer'; 'multilayer'; 'multilayer'; 'multilayer'; ...
                      'monolayer'; 'monolayer'};
scenario = ["Consecutive alignment"; "Interrupted alignment"; ...
            "Higher weights on aligned species"; "Higher weights on switching species"; ...
            "Module splitting"; "Module merging"];
layer_counts = cellfun(@(partition) size(partition,1),controlled_partitions);
has_weights = ~cellfun(@isempty,controlled_weights);
empty_scores = zeros(numel(scenario),1);
controlled_results = table(scenario, layer_counts, has_weights, string(controlled_methods), ...
    empty_scores, empty_scores, empty_scores, empty_scores, empty_scores, ...
    'VariableNames',{'Scenario','Layers','Weighted','PartitionMethod','HMI', ...
                     'HMI_min','HMI_max','MeanAdjacentRI','MeanAdjacentNMI'});

for case_idx = 1:height(controlled_results)
    assignments = controlled_partitions{case_idx};
    matching_method = controlled_methods{case_idx};
    link_weights = controlled_weights{case_idx};
    hmi = HomoMI(matching_method,'mean',assignments,link_weights);
    hmi_min = HomoMI(matching_method,'min',assignments,link_weights);
    hmi_max = HomoMI(matching_method,'max',assignments,link_weights);
    controlled_results.HMI(case_idx) = hmi{2};  % Same longest-run index as column 6 below.
    controlled_results.HMI_min(case_idx) = hmi_min{2};
    controlled_results.HMI_max(case_idx) = hmi_max{2};

    adjacent_scores = zeros(size(assignments,1)-1,2);
    for pair_idx = 1:size(adjacent_scores,1)
        [adjacent_scores(pair_idx,1), adjacent_scores(pair_idx,2)] = ...
            RI_NMI(assignments(pair_idx,:),assignments(pair_idx+1,:));
    end
    controlled_results.MeanAdjacentRI(case_idx) = mean(adjacent_scores(:,1));
    controlled_results.MeanAdjacentNMI(case_idx) = mean(adjacent_scores(:,2));
end
writetable(controlled_results,'R2-1_controlled_examples.csv');