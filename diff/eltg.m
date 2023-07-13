clc 
clear
%%
filename = "E:\TianKexin\diff\Temperature data in different depth.xlsx";
filename_out = "E:\TianKexin\diff\Temperature data in different depth_eltg_result.xlsx";
data = readtable(filename);
%%
T = data(:,3:7);
n = size(T,2);
T = T{:,:};
D = repmat([0,6.4,8.9,11.4,16.5],height(T),1);
h = ones(height(T),1)*16.5;
T_ave = 0;
for i = 1:n-1
    T_ave = T_ave + (0.5 * (T(:,i) + T(:,i+1)).* (D(:,i) - D(:,i+1)))./(D(:,1) - D(:,n));
end
TM = 0;
for i = 1:n-1
    TM= TM + ((T(:,i) + T(:,i+1) - 2 * T_ave).* (D(:,i).^2 - D(:,i+1).^2));  
end
TM = TM*-0.25;
ELTG = -12*TM./h.^3;
data.ELTG = ELTG;
writetable(data,filename_out);