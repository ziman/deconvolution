% Original image
H = 0.01 * rand(100,100); H(40,60) = 1; H(70,10) = 1;
%H = double(imread('lena100.jpg')) / 255;
%H = zeros(2,2);

% Convolution kernel
%K = gkern(10, 10, 3, 3);
K = ones(1,11); K = K/sum(K);

% Convolved image
C = filter2(K,H);
%C = double(imread('1va.jpg'))(:,:,2);
%C = C - min(min(C));
%C = C / max(max(C));
%K = C(41:50,362:376);
[rows cols] = size(C);

% Iterative deconvolution, ziman
e = 0.1;
g = 2;
T = 100;
G = C;
Et = zeros(T,3);
GC = filter2(K,G);	% convolve the guess
E = C - GC;		% error of the convolution
ES = sum(sum(E .* E));
lg = 0;
tic;
for t = 1:T
	nG = G + e*filter2(K,E);	% correct the error
	nG(nG < 0) = 0;		% prevent oscillations 

	GC = filter2(K,nG);	% convolve the guess
	nE = C - GC;		% error of the convolution
	nES = sum(sum(nE .* nE));

	if nES < ES 
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
subp(3,2,1,0.01);
imshow(H);
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
