%% ComputeMuFunction
%
% @brief Computes the mu function analytically
%
% @details Processes the function differently for even or odd l arguments
%
% @param[in] n - The n argument of the mu function (integer)
%
% @param[in] L - The L argument of the mu function (integer)
%
% @returns The exact value of the mu function
%

function mu = ComputeMuFunction(n, L)
    % Check if the "L" argument is even or odd
    if mod(L,2) == 0
        % Handle the even case
        mu = (1/2^(L-1))*1/(2*n-1)*nchoosek(L,L/2);
        LE = L/2;
        for k=0:LE-1
            term1 = (-1)^(LE-k)/2^(L-2);
            term2 = (2*n-1)/(4*n^2-4*n+1-L^2+4*L*k-4*k^2);
            mu = mu + term1*term2*nchoosek(L,k);
        end
    else
        % Handle the odd case
        mu = 0;
        LE = (L-1)/2;
        for k = 0:LE
            nu = ComputeNuFunction(n, k, LE);
            mu = mu + 2^(1-L)*(-1)^(LE+k)*nchoosek(L,k)*nu;
        end
    end
end

