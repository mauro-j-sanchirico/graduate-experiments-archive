% Kronecker Delta function
% The Kronecker Delta is 1 when its argument is zero, and zero otherwise.
% This function generats several shifted Kronecker Deltas.  The number
% of Kronecker Deltas created is determined by the number of elements
% in the phi array.
%
function Kronecker_Deltas = Kronecker_Delta(t, phi)
Kronecker_Deltas = zeros(length(t),length(phi));
for i=1:length(phi)
    Kronecker_Deltas(:,i) = (t-phi(i) == 0);
end
end
