clc
clear

%%
xN = 10;
yN = 10;
xyCon = 0.20;
TemNet_pools = cell(1,50);

for i = 1:50
    TemNet_pools{1,i} = generateBipartiteMatrix(xN, yN, xyCon);
end

%%
layer_num = [2, 3, 4, 5, 6, 7, 8, 9, 10];
% ---------- 根目录 ----------
rootDir = fullfile(pwd, '01_DATA\TemNet_Random');
if ~exist(rootDir, 'dir')
    mkdir(rootDir);
end

for i = 1:length(layer_num)
    layer = layer_num(i);
    layerID = randomSampleRepeat(5, 50, layer);   % 5×layer

    for j = 1:5
        % ---------- 子文件夹 TemNet_XX_YY ----------
        folderName = sprintf('TemNet_%02d_%02d', layer, j);
        subDir = fullfile(rootDir, folderName);
        if ~exist(subDir, 'dir')
            mkdir(subDir);
        end

        for k = 1:layer
            layer_data = TemNet_pools{1, layerID(j, k)};
            % ---------- 文件名 layer_kk.txt ----------
            fileName = sprintf('layer_%02d.txt', k);
            filePath = fullfile(subDir, fileName);
            writematrix(layer_data, filePath);
        end
    end
end