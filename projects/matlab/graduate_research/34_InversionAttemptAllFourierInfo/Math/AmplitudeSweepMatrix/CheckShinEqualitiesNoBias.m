function [c_nl_inequalities, ceq] = CheckShinEqualitiesNoBias(...
    shin_vector, number_partial_sum_terms_ns, m_table, k_table, ...
    alpha_coefs, y_peak_measured, y_trough_measured)

master_index = 1;

% Algorithm epsilon for safe division
epsilon = 0.000000001;

% No nonlinear inequalities
c_nl_inequalities = [];

% Number of constraints is at most the number of partial sum terms times 2
% (to account for two sets of polynomial constraints) plus 2 constratints
% for the peak and trough power

ceq = zeros(2*number_partial_sum_terms_ns + 2, 1);

ceq_index = 1;

% Computation of y_peak and y_trough must match measurements
y_peak_sum = 0;
y_trough_sum = 0;

for m = 1:number_partial_sum_terms_ns
    
    inner_peak_sum = 0;
    inner_trough_sum = 0;
    alpha = alpha_coefs(m);

    for k = 0:(2*m - 1)
        if (2*m-1) == k
            
            % Get the aux indicies for computation of constraints
            aux_index_1 = GetIndexFromMK( ...
                m_table, k_table, m + 1, k + 2);
            aux_index_2 = GetIndexFromMK( ...
                m_table, k_table, m + 2, k + 4);
            
            % Safe division to prevent divide by zero during optimization
            if abs(shin_vector(master_index)) < epsilon
                denom1 = shin_vector(master_index) + epsilon;
            else
                denom1 = shin_vector(master_index);
            end
            
            if abs(shin_vector(aux_index_1)) < epsilon
                denom2 = shin_vector(aux_index_1) + epsilon;
                denom3 = shin_vector(aux_index_1).^k + epsilon;
            else
                denom2 = shin_vector(aux_index_1);
                denom3 = shin_vector(aux_index_1).^k;
            end
            
            if abs(shin_vector(aux_index_2)) < epsilon
                denom4 = shin_vector(aux_index_2).^(k+2) + epsilon;
            else
                denom4 = shin_vector(aux_index_2).^(k+2);
            end

            %denom1 = shin_vector(master_index);
            %denom2 = shin_vector(aux_index_1);
            %denom3 = shin_vector(aux_index_1).^k;
            %denom4 = shin_vector(aux_index_2).^(k+2)
            
            ratio1 = shin_vector(aux_index_1)/denom1;
            ratio2 = shin_vector(aux_index_2)/denom2;
            ratio3 = (shin_vector(master_index).^(k+2))/denom3;
            ratio4 = (shin_vector(aux_index_1).^(k+4))/denom4;

            if ~isempty(ratio1) && ~isempty(ratio2) ...
                && ~isnan(ratio1) && ~isnan(ratio2)
                delta = ratio2 - ratio1;
                ceq(ceq_index) = delta;
                ceq_index = ceq_index + 1;
            end
            
            if ~isempty(ratio3) && ~isempty(ratio4) ...
                && ~isnan(ratio3) && ~isnan(ratio4)
                delta = ratio4 - ratio3;
                ceq(ceq_index) = delta;
                ceq_index = ceq_index + 1;
            end
            
            % Compute the peak and trough sums
            binomial_coef = nchoosek(2*m-1, k);
            gamma_product = shin_vector(master_index);
            sign_term = (-1)^k;
            
            inner_peak_sum = inner_peak_sum + binomial_coef*gamma_product;
            inner_trough_sum = ...
                inner_trough_sum + binomial_coef*gamma_product*sign_term;
            
        end
        
        y_peak_sum = y_peak_sum + alpha*inner_peak_sum;
        y_trough_sum = y_trough_sum + alpha*inner_trough_sum;
        master_index = master_index + 1;
        
    end
end

ceq(ceq_index) = y_peak_sum - y_peak_measured;
ceq_index = ceq_index + 1;
ceq(ceq_index) = y_trough_sum - y_trough_measured;

end

