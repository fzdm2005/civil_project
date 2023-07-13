function [z_f, z_curl] = filter_curling_s(x, z, PSG, l)
b = 12*(x(end) - x(1));
x_bar = mean(x,1);
x = x-x_bar;
x = x*12;
x = x.';
y = x;
z_bar = mean(z,1);
z = z-z_bar;
v = 0.15;
z_0 = -PSG*(((1+v))*l*l);
La = b/(l*sqrt(8));
z_curl = -z_0*((2*cos(La)*cosh(La))/((sin(2*La))-sinh(2*La))).*(((-tan(La)+tanh(La)).*(cos(y/(l*sqrt(2))).*cosh(y/(l*sqrt(2)))))+((tan(La)+tanh(La)).*(sin(y/(l*sqrt(2))).*sinh(y/(l*sqrt(2))))));
z_curl = z_curl.';
z_f = z-z_curl;
z_curl = (z_curl)+z_bar;
z_f = (z_f)+z_bar;

end