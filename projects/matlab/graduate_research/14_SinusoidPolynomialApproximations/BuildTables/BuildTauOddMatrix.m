% @breif Each column in the matrix is a power of t, each row is an element
% in the batch of all t data points
function tau_odd_matrix = BuildTauOddMatrix(K, t)

t = t';

N = length(t);

tau_odd_matrix = zeros(N, K);

for j = 0:K
    tau_odd_matrix(:,j+1) = t.^(2*j+1); % tau_odd_matrix(:,j) in C++
end

end
