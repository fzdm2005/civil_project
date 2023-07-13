clc
clear
close all
%% DFS 
root_path = 'E:\TianKexin\subsection\';
mFiles = [];
[mFiles, iFilesCount] = DeepTravel(root_path,mFiles,0);
mFiles = mFiles';
%% selext target
target_set = regexp(mFiles, 'P_L1.xlsx');
%% modify
for i = 1:length(target_set)
    if isempty(target_set{i}) == 1
        continue
    end
    filepath = mFiles{i};
    s = xlsread(filepath);
    s(:,1) = s(:,1) - s(1,1); 
    save_path  = erase(filepath,[".xlsx"]);
    xlswrite([save_path,'_modified.xlsx'],s);
end