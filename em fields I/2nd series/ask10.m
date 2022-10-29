x = -1:0.1:1;
y = 0:0.1:1;
[X, Y] = meshgrid(x, y);

rt = (X.^2 + Y.^2).^(1/2);
phi = atan2(Y, X);

Jx = -sin(phi) .* exp(-rt);
Jy = cos(phi) .* exp(-rt);
figure(1);
quiver(X, Y, Jx, Jy, 1/2);

K0 = 1;
a = 1;
m0 = 4*pi*10^(-7);
B = K0 * m0 * exp(-rt/a);
figure(2);
clf;
colormap ("default");
surf(x, y, B);
shadong interp;