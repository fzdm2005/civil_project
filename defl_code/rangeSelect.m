function indx = rangeSelect(s,range)
% return index that x < s < y; 
% s = data vector(m x 1)
% range = [x,y] 
x = range(1);
y = range(2); 
[x1,indx(1)]=min(abs(s - x));
if y == inf
    indx(2) = length(s);
else
    [x2,indx(2)]=min(abs(s - y));
end