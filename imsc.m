% Show an image without axes.
function y = imsc(X)
	y = imagesc(X);
	set(gca, 'visible', 'off');
