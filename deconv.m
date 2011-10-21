% Original image
%H = 0.01 * rand(100,100); H(40,60) = 1; H(70,10) = 1;
%H = imread('lena100.jpg');
%H = zeros(2,2);

% Convolution kernel
M = gkern(10, 10, 3, 3);
%M = ones(1,21); M = M/sum(M);

% Convolved image
%C = filter2(M,H);
C = double(imread('stars-small.jpg'));
C = C - min(min(C));
C = C / max(max(C));
M = C(59:64,172:187);
[rows cols] = size(C);

% Iterative deconvolution, ziman
e = 0.003;
T = 50;
G = zeros(rows,cols);
Et = zeros(T,3);
for t = 1:T
	GC = filter2(M,G);	% convolve the guess
	E = C - GC;		% error of the convolution
	G = G + e*filter2(M,E);	% correct the error
	G(G < 0) = 0;		% prevent oscillations 
	Et(t,1) = sum(sum(E .* E)) / (rows*cols);
end;

% Iterative deconvolution, lucy
TL = 25;
GL = ones(rows,cols);
MC = filter2(M,C);
for t = 1:TL
	GL = GL .* (MC ./ filter2(M,filter2(M,GL)));
	GC = filter2(M,GL);	% convolve the guess
	E = C - GC;		% error of the convolution
	Et(t,2) = sum(sum(E .* E)) / (rows*cols);
end;
Et(TL:T,3) = Et(TL,2);

% Paint graphs
clf;
subp(3,2,1,0.01);
imshow(C);
subp(3,2,2,0.01);
imshow(C);

subp(3,2,3,0.01);
imshow(G);
subp(3,2,4,0.01);
imshow(GL);

ax = subp(3,2,5,0.05);
plot(log(Et));
p = get(ax, 'Position');
p(3) = 0.94;
set(ax, 'Position', p);
legend('ziman','Richardson-Lucy','extension');
