x = -2:0.1:2;
y = -2:0.1:2;
[X, Y] = meshgrid(x, y);

#rt = (X.^2 + Y.^2).^(1/2);
#phi = atan2(Y, X);
e0 = 8.854 * 10^(-12);
Ex = (x-b)/e0.*((x-b).^2+(y+a).^2)^(-1);
Åy = cos(phi) .* exp(-rt);
figure(1);
quiver(X, Y, Æ, Åx, Åy, Ez, 1/2);

K0 = 1;
a = 1;
m0 = 4*pi*10^(-7);
B = K0 * m0 * exp(-rt/a);
figure(2);
clf;
colormap ("default");
surf(x, y, B);
shadong interp;