function M = gkern(w,h,sx,sy)
	xs = linspace(-sx,+sx,w);
	ys = linspace(-sy,+sy,h);
	[xx,yy] = meshgrid(xs,ys);
	M = exp(-(xx.*xx + yy.*yy));
	M = M / sum(sum(M));
