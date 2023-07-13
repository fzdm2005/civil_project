function [X,Z,ZF,Z_Fitted, ZC, C_PSG, C_L,RMSE, MAPE, R2,DFL]= Curling_Warping_3 (A, B, Dir)
F = size (B, 1)-1
Z_f = [];
Z_curl = [];
ZF = [];
Z_Fitted = [];
RMSE = [];
MAPE = [];
R2 = [];
Z = [];
DFL=[];
C_PSG = [];
C_L = [];
for i = 1:F
    st = B(i);
    fi = B(i+1);
    x = A(st:fi,1);
    z = A(st:fi,2);
    corr = z(1)+(((z(end)-z(1))/((x(end)-x(1)))).*(x- x(1)));
    z_corr = z-corr;
    [c,g,d] = fit_curling (x, z_corr, Dir);
    [z_f, z_curl] = filter_curling_s(x, z_corr, c.PSG, c.l);
    z_f = z_f - z_f(1);
    z_f_2 = z_f +corr;
    z_f_3 = z_f_2(2:end);
    size(z_f_3);
    ZF = vertcat (ZF,z_f_3);
    z_fitted = z - z_f;
    Z_Fitted = vertcat (Z_Fitted,z_fitted(2:end));
    Z = vertcat (Z,z(2:end));
    C_PSG = vertcat (C_PSG,repmat(c.PSG,size(z_fitted(2:end))));
    C_L = vertcat (C_L,repmat(c.l,size(z_fitted(2:end))));
    rmse = sqrt(mean((z_fitted-z).^2));
    RMSE = [RMSE;repmat(rmse,size(z_fitted(2:end)))];
    mape = mean(abs((z - z_fitted)./z));
    MAPE = [MAPE;repmat(mape,size(z_fitted(2:end)))];
    r2 = 1 - (sum((z_fitted - z).^2) / sum((z - mean(z)).^2));
    R2 = [R2;repmat(r2,size(z_fitted(2:end)))];
    dfl = max(abs(z_curl));
    DFL = [DFL;repmat(dfl,size(z_fitted(2:end)))];
end
size(ZF)
st = 1+B(1);
fi = B(end);
X = A(st:fi,1);
ZC = A(st:fi,2)-ZF;

end