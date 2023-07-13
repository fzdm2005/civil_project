function [X,ZF,ZC, C_PSG, C_L]= Curling_Warping (F1, F2, Dir)
A = xlsread(F1);
B = xlsread(F2);
F = size (B, 1)-1
Z_f = [];
Z_curl = [];
ZF = [];
for i = 1:F
    st = B(i);
    fi = B(i+1);
    x = A(st:fi,1);
    z = A(st:fi,2);
    corr = z(1)+(((z(end)-z(1))/((x(end)-x(1)))).*(x- x(1)));
    z_corr = z-corr;
    [c,g,d] = fit_curling (x, z_corr, Dir);
    C_PSG(i) = c.PSG;
    C_L (i) = c.l;
    [z_f, z_curl] = filter_curling_s(x, z_corr, c.PSG, c.l);
    z_f = z_f - z_f(1);
    z_f_2 = z_f +corr;
    z_f_3 = z_f_2(2:end);
    size(z_f_3);
    ZF = vertcat (ZF,z_f_3);
end
size(ZF)
st = 1+B(1);
fi = B(end);
X = A(st:fi,1);
ZC = A(st:fi,2)-ZF;

end