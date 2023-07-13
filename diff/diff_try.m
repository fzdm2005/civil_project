clc
clear
%%
filename = "E:\TianKexin\diff\Temperature data in different depth.xlsx";
data = readtable(filename);
%%
T = data(:,3:7);
T = T{:,:};
x = -[0,6.4,8.9,11.4,16.5];
xx = linspace(min(x),max(x));
tt = T';
grad = zeros(length(tt),length(xx));
for i = 1:length(tt)
    y = tt(:,i);
    Y=csape(x,y,'not-a-knot');
    Fy=fnder(Y,1);
    grad(i,:) = fnval(Fy,xx);
end
%%
position = 0.75;
x1 = min(x)+(max(x) - min(x))*(1-position);
[~,Index] = min(abs(xx-x1));
plot(grad(:,Index));
gg = grad(:,Index);
filename_out = "E:\TianKexin\diff\Temperature data in different depth_grad075_result.xlsx";
data.grad = gg;
writetable(data,filename_out);

% s = std(grad);
% [g,index] = min(s);
% xx(index)

% Y=csape(x,y,'not-a-knot');
% Fy=fnder(Y,1);
% v = fnval(Fy,x);
% 
% x1 = linspace(min(x),max(x));
% plot(x,y,'+', x1, fnval(Y,x1)); hold on
% f1 = @(X) v(2)*(X-x(2)) + y(2);
% f2 = @(X) v(5)*(X-x(5)) + y(5);
% fplot(f1, [min(x), max(x)]);
% fplot(f2, [min(x), max(x)])