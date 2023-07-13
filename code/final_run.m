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

%% save all data into P_sbSite Map:  P_sbSite (# of subset)('morning'/'afternoon'/'noon')('L'/'R'/'C')
P_sbSite = containers.Map('KeyType','char','ValueType','any');  % P_sbSite (# of subset)('morning'/'afternoon'/'noon')('L'/'R'/'C')

sb_sct = {'0217','0218','0219','0220','0215','0216','0213','0214','0259','0221','0222','0223','0224'};
jt_spc =[15,15,15,15,15,15,15,15,20,15,15,15,15];
section = {[0,679.83],[679.83,1825.58],[1825.58,2640.17],[2640.17,3679.92],[4147.92,4981.75],[4981.75,5433.08],[6302.83,7344.83],...
    [7344.83,8409.42],[8409.42,9216.67],[9216.67,9922.67],[9922.67,11025.50],[11025.50,11840.42],[11840.42,Inf]};
time_set = {'morning','afternoon','noon'};
num_sct = length(sb_sct);

for i = 1:num_sct
    P_sbSite(sb_sct{i}) = containers.Map('KeyType','char','ValueType','any'); 
    map = P_sbSite(sb_sct{i});
    map('morning') = containers.Map('KeyType','char','ValueType','any');
    map('afternoon') = containers.Map('KeyType','char','ValueType','any');
    map('noon') = containers.Map('KeyType','char','ValueType','any');
end
    

for i = 1:length(erd_set)
    if isempty(erd_set{i}) == 1
        continue
    end
    
    
    filepath = mFiles{i};
    if regexpi(filepath, 'Afternoon') 
        key_time = 'afternoon';
    elseif regexpi(filepath, 'morning') 
        key_time = 'morning';
    elseif regexpi(filepath, 'noon') 
        key_time = 'noon';
    end
    
    split = find(filepath=='\');
    save_path_root = [filepath(1:split(end-2)),'subsection\'];
    %mkdir(save_path_root); 

        
    loc_flag = 0;
    
    if isempty(regexp(filepath, 'T1','once')) == 0
        [d_l,d_r] = erdRead_T12(filepath);
        loc_flag = 1;
    elseif isempty(regexp(filepath, 'T3','once')) == 0
        [d_c] = erdRead_T3(filepath);
        savepath_T3 = erase(filepath,[".erd"]);
        loc_flag = 3;
        %xlswrite([savepath_T3,'_P_','.xlsx'],d_r);
    else 
        disp(['Find file: ', filepath,]);
        disp(' but not T1 or T3 found, pass');
        continue
    end
    
    if loc_flag == 1
        for k = 1: num_sct
            indx = rangeSelect(d_l(:,1),section{k});
            dt = d_l(indx(1):indx(2),:);
            map_section = P_sbSite(sb_sct{k});
            map_section_time = map_section(key_time);
            map_section_time('L') = dt; 
            indx = rangeSelect(d_r(:,1),section{k});
            dt = d_r(indx(1):indx(2),:);
            map_section_time('R') = dt; 
        end
    
    elseif loc_flag == 3
        for k = 1: num_sct       
            indx = rangeSelect(d_c(:,1),section{k});
            dt = d_c(indx(1):indx(2),:);
            map_section = P_sbSite(sb_sct{k});
            map_section_time = map_section(key_time);
            map_section_time('C') = dt; 
        end
    end
    
end

%% create ind3 array
for i = 1 : num_sct
    s = sb_sct{i};
    spc = jt_spc(i);
    map_section = P_sbSite(s);
    key_time = 'morning'; % PL of morning is used for creating ind3
    key_loc = 'L';
    map_sct_time = map_section(key_time);
    P = map_sct_time(key_loc);
    P(:,1) = P(:,1) - P(1,1); % start from zero
    [ind3, x6, y6]= Joint_Detection_3 (P, 1/12, spc, spc, 3, Dir);
    map_section('ind3') = ind3;
end
    
%% save dataset as .mat
save_path = save_path_root;
mkdir(save_path);
filename = 'wholeDataMap.mat';
save([save_path,filename],'P_sbSite');
%% final result
for i = 1:num_sct
    s = sb_sct{i};
    map_section = P_sbSite(s);
    ind3 = map_section('ind3');
    %time_set = map_section.keys;
    for j = 1: length(time_set)
        key_time = time_set{j};
        map_sct_time = map_section(key_time);
        if isa(map_sct_time, 'double')
            continue
        end
        loc_set = map_sct_time.keys;
        for k = 1 : length(loc_set)
            key_loc = loc_set{k};
            P = map_sct_time(key_loc);
            P(:,1) = P(:,1) - P(1,1); % start from zero
            tr_P = P(ind3(1)+1:end,2);
            [X,ZF,ZC, C_PSG, C_L]= Curling_Warping_2 (P, ind3, Dir);
            save_path = [save_path_root, s,'\',key_time,'\',key_loc,'\'];
            mkdir(save_path);
            
            
            file_tr_p = [save_path,'truncated_P_',key_loc,'.csv'];
            file_zf = [save_path,'ZF_',key_loc,'.csv'];
            file_cl = [save_path,'C_L_',key_loc,'.xlsx'];
            file_psg = [save_path,'C_PSG_',key_loc,'.xlsx'];
            
            
            csvwrite(file_tr_p,tr_P);
            csvwrite(file_zf,ZF);
            xlswrite(file_psg,C_PSG);
            xlswrite(file_cl,C_L);

            
        end


    end
    disp(['finished ', num2str(i),'/',num2str(num_sct)]);
end
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
