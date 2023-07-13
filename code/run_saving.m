function run_saving(root_path,direction)
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
    %ind_path = [root_path, 'ind3.xlsx'];
    idx = find(filepath=='\');
    path_tmn = filepath(1:idx(end)); % terminal path, looking for ind3.xlsx
    ind_path = [path_tmn, 'ind3.xlsx'];
    
    save_path = [erase(filepath,[".xlsx","P_"]),'\'];
    
    try 
        [X,ZF,ZC, C_PSG, C_L] = Curling_Warping (filepath, ind_path, direction);
        mkdir(save_path);
        xlswrite([save_path,'C_PSG.xlsx'],C_PSG);
        xlswrite([save_path,'C_L.xlsx'],C_L);
        csvwrite([save_path,'ZF.csv'],ZF);
        movefile(filepath,save_path);  
        copyfile(ind_path,[save_path,'ind3_save.xlsx']);  
        warning([filepath, ' success']);
    catch err
        disp(err);
        warning([filepath, ' did not success']);
    end
end