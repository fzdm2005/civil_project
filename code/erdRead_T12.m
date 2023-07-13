function [d_l,d_r] = erdRead_T12(filepath)
% return T1 and T2 data from .erd file
% [d_l,d_r] = erdRead(filepath), dir is the file path
% return [left data, right date, center data]
d_12 = importdata(filepath);
d_l = d_12.data(:,2);
d_r = d_12.data(:,3);
len = length(d_12.data);



info = d_12.textdata{2};
info = strsplit(string(info),',');
sp = str2double(info{6});

x_start = d_12.textdata{18};
x_start = strsplit(string(x_start),' ');
x_start = str2double(x_start{2});

x_end = (len-1)*sp + x_start;
dist = x_start:sp:x_end;
d_l = [dist',d_l];
d_r = [dist',d_r];



