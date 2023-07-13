function [filenames, profile, numfile] = erd_read(filepath)
% return first set of data in .erd file
% [d_l,d_r,d_c] = erdRead(dir), dir is the file path
% return [left data, right date, center data]
d_3 = importdata(filepath);
d_c = d_3.data(:,2:end);
len = length(d_3.data);

info = d_3.textdata{2};
info = strsplit(string(info),',');
sp = str2double(info{6});

x_start = d_3.textdata{18};
x_start = strsplit(string(x_start),' ');
x_start = str2double(x_start{2});

x_end = (len-1)*sp + x_start;
dist = x_start:sp:x_end;
profile = [dist',d_c];
num = size(profile);
fileroot = filepath(1:end-4);
if num(2) == 2
    filenames = [fileroot,'_C_result'];
    numfile = 1;
else
    filenames(1,:) = [fileroot,'_L_result'];
    filenames(2,:) = [fileroot,'_R_result'];
    numfile = 2;
end
    
    
