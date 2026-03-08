%% ComputeNuFunction
%
% @breif Computes the nu function analytically
%
% @details The nu function is an intermediate helper function used to
% compute the mu function analytically.
%
% @param[in] n - The n parameter of the nu function (integer)
%
% @param[in] k - The k parameter of the nu function (integer)
%
% @param[in] L - The L parameter of the nu function (integer)
%
% @returns The exact value of the nu function
%

function nu = ComputeNuFunction(n, k, L)

if k == L + n
    nu = -pi/2;
elseif k == L - n + 1
    nu = pi/2;
else
    nu = 0;
end

end

