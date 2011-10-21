% Generate a w×h Gaussian kernel, within (sx,sy) stdevs.
function M = gkern(w,h,sx,sy)
	xs = linspace(-sx,+sx,w);
	ys = linspace(-sy,+sy,h);
	[xx,yy] = meshgrid(xs,ys);
	M = exp(-(xx.*xx + yy.*yy));
	M = M / sum(sum(M));
