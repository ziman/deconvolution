% Original image
I = double(imread('trails.jpg')) / 255;

H = 0.01 * rand(100,100); H(40,60) = 1; H(70,10) = 1;
H = 0.299 * I(:,:,1) + 0.587 * I(:,:,2) + 0.114 * I(:,:,3);
%H = zeros(2,2);

% Convolution kernel
%K = gkern(10, 10, 3, 3);
%K = ones(1,11); K = K/sum(K);
K = gkern(7,7,4,4);
K = double(imread('trails-kernel.png')) / 255;
%K = H(228:243,305:325);

% Rotated kernel
Ki = rot90(K,2);

% Convolved image
C = filter2(K,H);
C = H;
%C = double(imread('1va.jpg'))(:,:,2);
%C = C - min(min(C));
%C = C / max(max(C));
%K = C(41:50,362:376);
[rows cols] = size(C);

% Iterative deconvolution, ziman
e = 0.001;
g = 2;
T = 80;
G = C;
Et = zeros(T,3);
GC = filter2(K,G);	% convolve the guess
E = C - GC;		% error of the convolution
ES = sum(sum(E .* E));
lg = 0;
tic;
for t = 1:T
	nG = G + e*filter2(Ki,E);	% correct the error
	nG(nG < 0) = 0;		% prevent oscillations 

	GC = filter2(K,nG);	% convolve the guess
	nE = C - GC;		% error of the convolution
	nES = sum(sum(nE .* nE));

	if nES < 1.2*ES 
		if lg
			e = e*g;
		end;
		lg = 1;
		G = nG;
		E = nE;
		ES = nES;
	else
		e = e/g;
		lg = 0;
	end;
	if e == 0
		break;
	end;

	Et(t,1) = sum(sum(E .* E));
end;
toc

% Iterative deconvolution, lucy
TL = T;
GL = C;
KC = filter2(K,C);
tic;
for t = 1:TL
	GL = GL .* (KC ./ filter2(K,filter2(K,GL)));
	GC = filter2(K,GL);	% convolve the guess
	E = C - GC;		% error of the convolution
	ES = sum(sum(E .* E));
	if (t > 1) && (ES > Et(t-1,2))
		TL = t-1;
		break;
	end;
	Et(t,2) = ES;
end;
Et(TL:T,3) = Et(TL,2);
toc

%GL = GL - min(min(GL));
%GL = GL / max(max(GL));
%imwrite(GL, '1va-out.jpg');

% Paint graphs
clf;
subp(2,3,1,0.01);
imshow(G);
subp(2,3,2,0.01);
imshow(C);

subp(2,3,3,0.01);
imshow(GL);
subp(2,1,2,0.02);
plot(log(Et));
legend('ziman','Richardson-Lucy','extension');
