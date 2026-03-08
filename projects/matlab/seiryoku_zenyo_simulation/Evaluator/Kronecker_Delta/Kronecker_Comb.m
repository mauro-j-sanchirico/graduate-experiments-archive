% Kronecker Comb function
% Generates several Kronecker Combs (depending on the size of the P array)
% with different stretch and shift.  Assumes 'Out' parameter is already
% initialized.  Assumes P and phi arrays are the same size.

function Kronecker_Combs = Kronecker_Comb(t, phi, P, thresh)
Kronecker_Combs = zeros(length(t),length(P));
for i=1:length(phi)
    Kronecker_Combs(:,i) = [mod(t-phi(i),P(i))<thresh]';
end
end