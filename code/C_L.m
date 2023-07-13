clear
clc
%%
str = [uigetdir('E:\TianKexin\Site List\','Choose the root path of dataset'),'\'];
%%
mFiles = [];
[mFiles, FilesCount] = DeepTravel(str,mFiles,0);
mFiles = mFiles';
target_set = regexp(mFiles, 'Processed data[\s\S]*C_L.xlsx');
%%
P = containers.Map('KeyType','char','ValueType','any');
h=waitbar(0,'please wait');
for i = 1: FilesCount
    str=['运行中...',num2str(i/FilesCount*100),'%'];
    waitbar(i/FilesCount,h,str);
    if isempty(target_set{i})
        continue;
    end
    filename = mFiles{i};
    index = find(filename == '\');
    siteName = filename(index(4)+1:index(5)-1);
    date = filename(index(6)+1:index(7)-1);
    timing = filename(index(7)+1:index(8)-1);
    data = xlsread(filename);
    rst.L_ave = mean(data);
    key_set = {siteName, date, timing};
    if isempty(P)
        P = writeMap([],key_set,rst);
    else
        writeMap(P,key_set,rst,"mean");
    end
    
end
delete(h);
%% write table
key_sites = P.keys;
timing = {'Morning', 'Noon', 'Afternoon'};
D = {};
f = 1;
for i = 1:length(key_sites)
    key_site = key_sites{i};
    P_cur = P(key_site);
    key_dates = P_cur.keys;
    for j = 1:length(key_dates)
        key_date = key_dates{j};
        P_cur = readMap(P,{key_site,key_date});
        val = zeros(1,length(timing));
        for k = 1:length(timing)
            tm = timing{k};
            if isKey(P_cur,tm)
                rst = P_cur(tm);
                value = rst.L_ave;
            else
                value = NaN;
            end
            val(k) = value;
        end
        rowval = {key_site, key_date,val(1),val(2),val(3)};
        D(f,:) = rowval;
        f = f+1;
    end
end
%%
T = cell2table(D,'VariableNames',{'SiteNo' 'Date' 'Morning' 'Noon' 'Afternoon'});
writetable(T,'L_ave_result.xlsx')