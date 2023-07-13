clc
clear
close all

%% The directory of your files
str = 'E:\TianKexin\Site List\';

%% dir set by depth-first walk
mFiles = [];
[mFiles, iFilesCount] = DeepTravel(str,mFiles,0);
mFiles = mFiles';
erd_set = regexp(mFiles, '.erd');
for i = 1:length(erd_set)
    if isempty(erd_set{i}) == 1
        continue
    end
    
    filepath = mFiles{i};
    if isempty(regexp(filepath, 'T1','once')) == 0
        [d_l,d_r] = erdRead_T12(filepath);
        savepath_T1 = erase(filepath,[".erd"," T2"," &"]);
        savepath_T2 = erase(filepath,[".erd"," T1"," &"]);
        xlswrite([savepath_T1,'_P_','.xlsx'],d_l);
        xlswrite([savepath_T2,'_P_','.xlsx'],d_r);
    elseif isempty(regexp(filepath, 'T3','once')) == 0
        [d_c] = erdRead_T3(filepath);
        savepath_T3 = erase(filepath,[".erd"]);
        xlswrite([savepath_T3,'_P_','.xlsx'],d_r);
    else 
        disp(['Find file: ', filepath,]);
        disp(' but not T1 or T3 found, pass');
        continue
    end
end