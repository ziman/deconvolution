% Original image
rows = 100; cols = 100;
H = 0.05 * rand(rows,cols);
H(40,60) = 1;
H(70,10) = 1;
H = imread('lena100.jpg');

% Input to the algorithm:
M = ones(1,20);	% Convolution kernel
M = M/sum(M);
%M = gkern(10, 10, 3, 3);
C = filter2(M,H);	% Convolved image

% Iterative deconvolution
e = 0.2;
T = 300;
G = ones(rows,cols);
Et = zeros(T,1);
MC = filter2(M,C);
for t = 1:T
	G = G .* (MC ./ filter2(M,filter2(M,G)));
	%GC = filter2(M,G);	% convolve our guess
	%E = C - GC;		% error of the convolution
	%G = G + e*filter2(M,E);	% correct the error
	%G(G < 0) = 0;		% prevent fourier antibalance
	%Et(t) = sum(sum(E .* E));
end;

clf;
subp(3,3,1,0.01);
imsc(H);
subp(3,3,2,0.01);
imsc(C);
subp(3,3,3,0.01);
imsc(filter2(M,E));
%imsc(real(fft2(H)));

subp(3,3,4,0.03);
plot(H(40,:))
subp(3,3,5,0.03);
plot(C(40,:))
subp(3,3,6,0.03);
plot(log(Et'));

subp(3,3,7,0.01);
imsc(G);
subp(3,3,8,0.01);
imsc(GC);
subp(3,3,9,0.01);
imsc(abs(fft2(E)));
%imsc(abs(fft2(G)));
