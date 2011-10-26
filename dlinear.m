function y = dlinear(x,k)

[xr,xc] = size(x);
[kr,kc] = size(k);

k2 = zeros(xr,xc);
k2(1:kr,1:kc) = k;

f = fft2(k2);

c = 0.01;
f(abs(f) < c) = c;

y = abs(ifft2(fft2(x) ./ f));
