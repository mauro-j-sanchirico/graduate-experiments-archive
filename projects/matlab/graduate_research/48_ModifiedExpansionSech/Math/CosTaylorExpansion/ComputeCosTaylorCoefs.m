%% ComputeSinTaylorCoefs
%
% @breif Computes the Taylor series expansion coeffcients of a cosine
%
% @param[in] number_terms_big_m - the number of partial sum terms to use
% in the expansion
%
% @returns taylor_coefs - the coefficients of the Taylor series expansion
%
function taylor_coefs = ComputeCosTaylorCoefs(number_terms_big_m)

taylor_coefs = zeros(1, number_terms_big_m);

for m_index = 0:(number_terms_big_m-1)
    taylor_coefs(m_index+1) = ComputeCosTaylorCoef(m_index);
end

end
