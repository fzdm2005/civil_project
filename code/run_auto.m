clc
clear
%%
site_set = {'E:\TianKexin\Site List\Story County\Site 21-22_US-30\Site 22_Nevada\SSI data\20200228\Afternoon\'};
%site_set = {'E:\TianKexin\Site List\Marshall County\Site 6_US-330\'};
dir_set = {'up'};
for i = 1:length(site_set)
    root_path = site_set{i};
    direction = dir_set{i};
    run_saving(root_path,direction);
end