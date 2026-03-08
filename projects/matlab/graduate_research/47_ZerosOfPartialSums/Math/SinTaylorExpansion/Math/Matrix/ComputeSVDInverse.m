function AInv = ComputeSVDInverse(A)

% Perform SVD on A
[U,S,V] = svd(A);

% A == U*S*V'  % Not needed, but you can check it yourself to confirm

% Calc number of singular values
s = diag(S);   % vector of singular values
tolerance = max(size(A))*eps(max(s));
p = sum(s>tolerance);

% Define spaces
Up = U(:,1:p);
Vp = V(:,1:p);
SpInv = spdiags( 1.0./s(1:p), 0, p, p );

% Calc AInv such that x = AInv * b
AInv = Vp * SpInv * Up';

end

