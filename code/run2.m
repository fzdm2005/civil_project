% clc
% clear
% close all
%% The directory of your files
%str = 'E:\TianKexin\Site List\';
%root_path = [uigetdir('E:\TianKexin\Site List'),'\'];
% 
% answer = questdlg('Choose direction?', ...
% 	'Direction', ...
% 	'Up','Down','Up');
% % Handle response
% switch answer
%     case 'Up'
%         disp([answer])
%         direction = 'up';
%     case 'Down'
%         disp([answer ' coming right up.'])
%         direction = 'down';
% end

%% dir set by depth-first walk
mFiles = [];
[mFiles, iFilesCount] = DeepTravel(root_path,mFiles,0);
mFiles = mFiles';
erd_set = regexp(mFiles, 'P_\w*.xlsx');

%%
for i = 1:length(erd_set)
    if isempty(erd_set{i}) == 1
        continue
    end
    
    filepath = mFiles{i};
    ind_path = [root_path, 'ind3.xlsx'];
    save_path = [erase(filepath,[".xlsx","P_"]),'\'];
    mkdir(save_path);
    [X,ZF,ZC, C_PSG, C_L] = Curling_Warping (filepath, ind_path, direction);
    xlswrite([save_path,'C_PSG.xlsx'],C_PSG);
    xlswrite([save_path,'C_L.xlsx'],C_L);
    csvwrite([save_path,'ZF.csv'],ZF);
end