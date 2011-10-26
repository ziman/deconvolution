% Original image
I = double(imread('andromeda2011.jpg')) / 255;
%I = I(1:200,1:200,:);
R = I(:,:,1);
G = I(:,:,2);
B = I(:,:,3);
H = 0.299 * R + 0.587 * G + 0.114 * B;

% Convolution kernel
a = 9;
b = 6;
K = gkern(a,a,b,b);
K = double(imread('andromeda2011-kernel.png')) / 255;
K = K ./ sum(sum(K));

Z = zeros(200,200);
Z(100,100) = 1;

T = 20;
Et = zeros(T,3); G = H; GL = H;

%tic; [G, Et(:,1)] = dziman(H, K, T); toc
%tic; [G, Et(:,1), TL] = dlucy(H, K, T, 1); toc
tic; G = dlinear(H, K); toc

G = G + mean(I(1:end)) - mean(G(1:end));
G = G .* std(I(1:end)) ./ std(G(1:end));
G(G < 0) = 0;
G(G > 1) = 1;

% Paint graphs
figure(1);
clf;
subp(2,3,1,0.01);
F = Z;
F = ffilter(K,F);
imshow(F);
subp(2,3,2,0.01);
imshow(H);
subp(2,3,3,0.01);
imshow(G);
subp(2,1,2,0.02);
plot(log(Et));
legend('red','green','blue');

imwrite(G,'and.png');
