function [d_c] = erdRead_T3(filepath)
% return T1 and T2 data from .erd file
% [d_l,d_r] = erdRead(filepath), dir is the file path
% return [left data, right date, center data]
d_3 = importdata(filepath);
d_c = d_3.data(:,2);
len = length(d_3.data);

info = d_3.textdata{2};
info = strsplit(string(info),',');
sp = str2double(info{6});

x_start = d_3.textdata{18};
x_start = strsplit(string(x_start),' ');
x_start = str2double(x_start{2});

x_end = (len-1)*sp + x_start;
dist = x_start:sp:x_end;
d_c = [dist',d_c];