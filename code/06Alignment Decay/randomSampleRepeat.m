function result = randomSampleRepeat(nRep, N, k)
% 从 1~N 中随机抽取 k 个不同的数，重复 nRep 次
%
% 输入：
%   nRep - 重复抽取的次数（正整数）
%   N    - 候选数字范围 1~N（正整数）
%   k    - 每次抽取的个数（正整数，且 k <= N）
%
% 输出：
%   result - nRep × k 矩阵，每行是一次抽取结果，行内元素互不相同
%
% 示例：
%   result = randomSampleRepeat(20, 50, 2);

    result = zeros(nRep, k);
    for i = 1:nRep
        result(i, :) = randperm(N, k);
    end
end