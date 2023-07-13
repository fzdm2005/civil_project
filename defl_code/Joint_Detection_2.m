function [ind3, x6, y6]= Joint_Detection_2 (profile, D, F, NS, B, Dir)
x = profile(:,1);
y = profile(:,2);
if strcmp(Dir,'down')
    y = 0-y;
end
x = x.';
y = y.';
z = csaps(x,y,0.000005,x);
z3 = y-z;
M = movmean(z3,23);
M2 =diff(M);
M3 = movmean(M2,9);
M4 = diff(M3);
X0 = ((F- x(1))/D)-1;
Del = B/D;
S = NS/D;
St = (NS/D)+Del;
x2 = x(3:end);
x4  =[];
while lt(St,(size(M4,2)-X0))
    C = X0 + S;
    Lb = C - Del;
    Ub = C + Del;
    W = M4 (Lb:Ub);
    [mm, I] = min(W);
    ind = Lb+I-1;
    x4 = horzcat(x4, ind);
    X0 = ind;
end 

N = size(x4,2);
x5 = x4+2;
y6 = [];
x6 = [];
ind3 = [];
for i = 1:N
    Lbb = x5(i)-(1/D);
    Ubb = x5(i)+(1/D);
    W = z3 (Lbb:Ubb);
    [m, I2] = max(W);
    ind2 = Lbb+I2-1;
    xx = x(ind2);
    yy = y(ind2);
    x6 = horzcat(x6, xx);
    y6 = horzcat(y6, yy);
    ind3 = horzcat(ind3, ind2);
end
if strcmp(Dir,'down')
    y = 0-y;
end
if strcmp(Dir,'down')
    y6 = 0-y6;
end

x6 = x6.';
y6 = y6.';
ind3 = ind3.'; 

%% plot
% plot(x,y)
% hold on
% scatter(x6,y6)
% xlabel('Distance (ft)') 
% ylabel('Elevation (in)') 
end