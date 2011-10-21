function ax = subp(rows,cols,ix,border)
	ax = subplot(rows,cols,ix);
	w = 1.0 / cols;
	h = 1.0 / rows;
	l = w * mod(ix-1, cols);
	b = h * (rows - floor((ix-1) / cols) - 1);
	set(ax, 'Position', [l+border b+border w-2*border h-2*border]);
