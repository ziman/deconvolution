function [G, Et, T] = dlucy(C, K, T, err)
G = C;
KC = filter2(K,C);
Et = zeros(T,1);
for t = 1:T
	G = G .* (KC ./ filter2(K,filter2(K,G)));

	if err
		GC = filter2(K,G);	% convolve the guess
		E = C - GC;		% error of the convolution
		ES = sum(sum(E .* E));
		if (t > 1) && (ES > Et(t-1))
			T = t-1;
			break;
		end;
		Et(t) = ES;
	end;
end;
