function [c,g,d] = fit_curling (x, z, Dir)
x = x-mean(x,1);
%converts from ft to in (units)
x = x*12;
B = x(end) - x(1);
z = z-mean(z,1);
b = B;
% l = [42];
if strcmp(Dir,'down')
    Lo = 0;
    Up = 10;
else 
    Lo = -10;
    Up = 0;
end
s = fitoptions('Method','NonlinearLeastSquares', 'Robust', 'LAR','StartPoint', [1e-3, 35], 'Lower', [Lo, 16], 'Upper', [Up, 56] );
f = fittype(@(PSG, l,  b, y) -PSG*((((1+0.15))*l*l)*((2*cos(b/(l*sqrt(8)))*cosh(b/(l*sqrt(8)))))/((sin(2*b/(l*sqrt(8))))+sinh(2*b/(l*sqrt(8)))))*(((-tan(b/(l*sqrt(8)))+tanh(b/(l*sqrt(8))))*(cos(y/(l*sqrt(2))).*cosh(y/(l*sqrt(2)))))+((tan(b/(l*sqrt(8)))+tanh(b/(l*sqrt(8))))*(sin(y/(l*sqrt(2))).*sinh(y/(l*sqrt(2)))))),'problem','b','options',s,'independent', 'y','dependent','z');          
[c,g,d] = fit(x,z,f,'problem',B);

end 