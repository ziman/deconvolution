% Original image
I = double(imread('trails.jpg')) / 255;
H = 0.299 * I(:,:,1) + 0.587 * I(:,:,2) + 0.114 * I(:,:,3);

% Convolution kernel
cepstrum = (abs(fft2(log(abs(fft2(H))))));
cs = cepstrum(1:end);
[r,c] = size(cepstrum);
[jj ii] = meshgrid(1:c,1:r);
w = ii .* jj;
phiphi = atan((ii-1) ./ (jj-1));
phiphi(isnan(phiphi)) = 0;
cepstrum(1:2,1:2) = 0;
cepstrum(r-1:r,c-1:c) = 0;
cepstrum(r-1:r,1:2) = 0;
cepstrum(1:2,c-1:c) = 0;
cepstrum = (cepstrum - std(cs)) ./ mean(cs);

phi = sum(sum(w .* cepstrum .* phiphi)) / sum(sum(w .* cepstrum))

r2 = floor(r/2);
c2 = floor(c/2);
sc =	[ cepstrum(r2+1:r,c2+1:c), cepstrum(r2+1:r,1:c2)
	; cepstrum(1:r2,c2+1:c), cepstrum(1:r2,1:c2)];

K = double(imread('trails-kernel.png')) / 255;

T = 10;
Et = zeros(T,3); G = C; GL = C;

%tic; [G, Et(:,1)] = dziman(H, K, T); toc
tic; [GL, Et(:,2), TL] = dlucy(H, K, T, 1); toc

Et(TL:T,3) = Et(TL,2);

% Paint graphs
figure(1);
clf;
subp(2,3,1,0.01);
imagesc(sc);
subp(2,3,2,0.01);
imshow(C);

subp(2,3,3,0.01);
imshow(GL);
subp(2,1,2,0.02);
plot(log(Et));
legend('ziman','Richardson-Lucy','extension');

figure(2);
surf(cepstrum(1:10,1:10));
