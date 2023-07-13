clear
clc
%% read data
path = uigetdir('C:\Users\ktian\Desktop\Site List');
s_12 = dir([path '\*T1*T2.erd']);
s_3 = dir([path '\*T3.erd']);
len = inf;
num = length(s_12);
for i = 1:num
    fname_12 = s_12(i).name;
    fname_3 = s_3(i).name;
    d_12 = importdata([path,'\',fname_12]);
    d_3 = importdata([path,'\',fname_3]);
    len = min(len, min(length(d_12.data), length(d_3.data)));
    data_l{i} = d_12.data(:,2);
    data_r{i} = d_12.data(:,3);
    data_c{i} = d_3.data(:,2);
end
for i = 1:num
    data_l{i} = data_l{i}(1:len);
    data_r{i} = data_r{i}(1:len);
    data_c{i} = data_c{i}(1:len);
    data_mean_l{i} = data_l{i} - mean(data_l{i});
    data_mean_r{i} = data_r{i} - mean(data_r{i});
    data_mean_c{i} = data_c{i} - mean(data_c{i});
end

dis_mtx_l = inf(num);
dis_mtx_r = inf(num);
dis_mtx_c = inf(num);
for i = 1:num
    for j = i:num
        if i == j
            continue;
        end
        dis_mtx_l(i,j) = dtw(data_mean_l{i},data_mean_l{j});
        dis_mtx_r(i,j) = dtw(data_mean_r{i},data_mean_r{j});
        dis_mtx_c(i,j) = dtw(data_mean_c{i},data_mean_c{j});
        dis_mtx_l(j,i) = dis_mtx_l(i,j);
        dis_mtx_r(j,i) = dis_mtx_r(i,j);
        dis_mtx_c(j,i) = dis_mtx_c(i,j);
    end
end
%%
[dist_min,loc] = min([min(dis_mtx_l(:)),min(dis_mtx_r(:)),min(dis_mtx_c(:))]);
title=["distance","elv"];

dt = 0.0833333333333333;
d_star = -3;
d_end = (len-1)*dt + d_star;
dist = d_star:dt:d_end;
if loc == 1
    [r,c] = find(dis_mtx_l==dist_min);
    result = [title;dist',data_l{r(1)}];
    xlswrite([path,'\','selected_l_',num2str(r(1)),'.xls'],result);
    disp(['test l number ',num2str(r(1)),'has been chosen']);
elseif loc == 2
    [r,c] = find(dis_mtx_r==dist_min);
    result = [title;dist',data_r{r(1)}];
    xlswrite([path,'\','selected_r_',num2str(r(1)),'.xls'],result);
    disp(['test r number ',num2str(r(1)),' has been chosen']);
else
    [r,c] = find(dis_mtx_c==dist_min);
    result = [title;dist',data_r{r(1)}];
    xlswrite([path,'\','selected_c_',num2str(r(1)),'.xls'],result);
    disp(['test c number ',num2str(r(1)),'has been chosen']);
end
postion = [r(1),c(1)];


