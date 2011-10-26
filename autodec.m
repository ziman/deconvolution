% Original image
I = double(imread('trails.jpg')) / 255;
H = 0.299 * I(:,:,1) + 0.587 * I(:,:,2) + 0.114 * I(:,:,3);

% Convolution kernel
K = double(imread('trails-kernel.png')) / 255;

T = 80;
Et = zeros(T,3); G = C; GL = C;

tic; [G, Et(:,1)] = dziman(H, K, T); toc
tic; [GL, Et(:,2), TL] = dlucy(H, K, T, 1); toc

Et(TL:T,3) = Et(TL,2);

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
