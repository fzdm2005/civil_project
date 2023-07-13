clc
clear
close all

%% The directory of your files
str = [uigetdir('E:\TianKexin\Site List\','Choose the root path of dataset'),'\'];
answer = questdlg('Choose the direction of this site','Direction Choose', ...
	'up', 'down','up');
Dir = answer; % for each site;
%% dir set by depth-first walk
mFiles = [];
[mFiles, iFilesCount] = DeepTravel(str,mFiles,0);
mFiles = mFiles';
erd_set = regexp(mFiles, '.erd');
%%
for i = 1:length(erd_set)
    if isempty(erd_set{i}) == 1
        continue
    end
    
    filepath = mFiles{i};    
    split = find(filepath=='.');
    save_path_root = [filepath(1:split(end)-1)];
    %mkdir(save_path_root); 
    
    if isempty(regexp(filepath, 'T1','once')) == 0
        [d_l,d_r] = erdRead_T12(filepath);
        loc_flag = 1;
        P = d_l;
        [ind3, x6, y6]= Joint_Detection_3 (P, 1/12, 20, 20, 3, Dir);
        [X,Z,ZF,Z_Fitted,ZC,C_PSG,C_L,RMSE, MAPE, R2, DFL]= Curling_Warping_3 (P, ind3, Dir);
        T = table(X, Z, Z_Fitted,DFL,RMSE,MAPE,R2,C_L,C_PSG);
        filename = [save_path_root,'_T1.xlsx'];
        writetable(T, filename);
        
        loc_flag = 2;
        P = d_r;
        [ind3, x6, y6]= Joint_Detection_3 (P, 1/12, 20, 20, 3, Dir);
        [X,Z,ZF,Z_Fitted,ZC,C_PSG,C_L,RMSE, MAPE, R2, DFL]= Curling_Warping_3 (P, ind3, Dir);
        T = table(X, Z, Z_Fitted,DFL,RMSE,MAPE,R2,C_L,C_PSG);
        filename = [save_path_root,'_T2.xlsx'];
        writetable(T, filename);
        
        
    elseif isempty(regexp(filepath, 'T3','once')) == 0
        [d_c] = erdRead_T3(filepath);
        P = d_c;
        [ind3, x6, y6]= Joint_Detection_3 (P, 1/12, 20, 20, 3, Dir);
        [X,Z,ZF,Z_Fitted,ZC,C_PSG,C_L,RMSE, MAPE, R2, DFL]= Curling_Warping_3 (P, ind3, Dir);
        T = table(X, Z, Z_Fitted,DFL,RMSE,MAPE,R2,C_L,C_PSG);
        filename = [save_path_root,'_T3.xlsx'];
        writetable(T, filename);
    else 
        disp(['Find file: ', filepath,]);
        disp(' but not T1 or T3 found, pass');
        continue
    end
    
end