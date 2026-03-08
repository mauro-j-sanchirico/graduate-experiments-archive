%% ComputeSinTaylorCoefs
%
% @breif Computes the Taylor series expansion coeffcients of a sinusoid
%
% @param[in] number_terms_big_m - the number of partial sum terms to use
% in the expansion
%
% @returns taylor_coefs - the coefficients of the Taylor series expansion
%
function taylor_coefs = ComputeSinTaylorCoefs(number_terms_big_m)

taylor_coefs = zeros(1, number_terms_big_m);

for m_index = 1:number_terms_big_m
    taylor_coefs(m_index) = ComputeSinTaylorCoef(m_index);
end

end
