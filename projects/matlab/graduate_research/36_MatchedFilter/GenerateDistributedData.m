% @breif Generates samples with a given PDF using inverse sampling method
% @details Samples a unique map generated from the inverse CDF of the
% given PDF.
% Sources:
% https://en.wikipedia.org/wiki/Inverse_transform_sampling
% https://matlabtricks.com/post-44/generate-random-numbers-with-a-given-distribution
% http://www.av8n.com/physics/arbitrary-probability.htm
% @param[in] float x0 - minimum x value
% @param[in] float x1 - maximum x value
% @param[in] float dx - smallest delta x
% 
function generated_data = GenerateDistributedData( ...
        x0, x1, dx, pdf_function_handle, num_samples)
    
    % Generate x, random values, PDF, and CDF
    x = x0:dx:x1;
    random_values = rand(1, num_samples);
    f_pdf = pdf_function_handle(x);
    f_pdf_norm = f_pdf/sum(f_pdf);
    big_f_cdf = cumsum(f_pdf_norm);
    
    % Create a unique copy of the CDF
    [unique_cdf, mask] = unique(big_f_cdf);
    
    % Keep only the X values that coorespond to unique elements of the CDF
    x_at_unique_cdf_elements = x(mask);
    
    % Inverse interpolation to achieve CDF(x) -> x projection
    % Interpolating CDF^(-1)(x) = x(unique_cdf(x)) and querying it at
    % random values having uniform distribution.
    generated_data = interp1( ...
        unique_cdf, x_at_unique_cdf_elements, random_values);
    
end