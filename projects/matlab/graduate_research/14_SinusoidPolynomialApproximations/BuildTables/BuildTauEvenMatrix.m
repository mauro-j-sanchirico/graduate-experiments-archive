% @breif Each column in the matrix is a power of t, each row is an element
% in the batch of all t data points
function tau_even_matrix = BuildTauEvenMatrix(K, t)

t = t';

N = length(t);

tau_even_matrix = zeros(N, K);

for j = 0:K
    tau_even_matrix(:,j+1) = t.^(2*j); % tau_even_matrix(:,j) in C++
end

end
