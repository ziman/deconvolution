function [G, Et] = dziman(C, K, T)
Ki = rot90(K,2);
e = 0.01;
g = 2;
G = C;
Et = zeros(T,1);
GC = filter2(K,G);	% convolve the guess
E = C - GC;		% error of the convolution
ES = sum(sum(E .* E));
lg = 0;
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

	Et(t) = sum(sum(E .* E));
end;
