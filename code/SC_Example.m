clc
clear
%-------------------------------------------------------------------------%
layer=2;
Intra_data=cell(1,layer);

%import data
SC_fileInfo = dir(fullfile(pwd, 'DATA/First/SC/','*.txt'));
SC_fileNames = {SC_fileInfo.name}';

%A worked example of calculating HMI
% 构建完整的文件路径
SC_filePath1 = fullfile(pwd,'DATA/First/SC/',SC_fileNames(1));
SC_filePath2 = fullfile(pwd,'DATA/First/SC/',SC_fileNames(2));
SC_filePath3 = fullfile(pwd,'DATA/First/SC/',SC_fileNames(3));

% 读取文件
PH=importdata(SC_filePath1{1});
Intra_data{1}=PH.data;

PP=importdata(SC_filePath2{1});
Intra_data{2}=PP.data;

Inter_data=importdata(SC_filePath3{1});
Inter_data=Inter_data.data;
%Inter_data=[0.053 0.068 0.014 0.061 0.019 0.147 0.083 0.107 0.065];
%-------------------------------------------------------------------------%

%module partition by monolayer algorithm
[modularity, module_partition] = modularity_module_partition(Intra_data,Inter_data,"monolayer",layer,100,"bipartite","diagonal_coupling");
%module partition by monolayer algorithm
HMI=HomoMI("monolayer",module_partition,Inter_data)

%module partition by multilayer algorithm
[modularity, module_partition] = modularity_module_partition(Intra_data,Inter_data,"multilayer",layer,100,"bipartite","diagonal_coupling");
%module partition by multilayer algorithm
HMI=HomoMI("multilayer",module_partition,Inter_data)
