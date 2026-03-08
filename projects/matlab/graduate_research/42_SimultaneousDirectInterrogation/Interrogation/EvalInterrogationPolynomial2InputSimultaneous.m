function y = EvalInterrogationPolynomial2InputSimultaneous( ...
    active_input_a, active_input_b, mlp_params, alpha_coefs, ...
    ti_table, tc_table, x)

m_expansion_params = GetModifiedExpansionParams();
mlp_hyperparams = GetMLPHyperparams();
analysis_params = GetAnalysisParams();

% flip to math ordering
alpha_coefs = fliplr(alpha_coefs);

no = 1;
big_m = m_expansion_params.m_index_max;
big_nh = mlp_hyperparams.num_hidden;
ni1 = active_input_a;
ni2 = active_input_b;

y = mlp_params.b_layer1(no);

for nh = 1:big_nh

    % Get terms of the sum that is to be raised to the power of m
    % (theta1 + theta2 + theta3)^j
    theta1 = mlp_params.w_layer0(nh, ni1)*x(ni1, :);
    theta2 = mlp_params.w_layer0(nh, ni2)*x(ni2, :);
    theta3 = mlp_params.b_layer0(nh);
    
    for m = 1:big_m
        
        j = 2*m - 1;
        
        if analysis_params.use_expanded_polynomials == false
            alpha_2m_minus_1 = alpha_coefs(2*m);
            term = ...
                alpha_2m_minus_1 ...
                * mlp_params.w_layer1(no, nh) ...
                * (theta1 + theta2 + theta3).^j;
            y = y + term;
            
        else

            for idx = 1:length(ti_table{j})

                % Get the trinomial index, k, and the trinomial coef, tc
                k = ti_table{j}(idx, :);
                tc = FastTrinomialCoef(tc_table, j, k);

                % Get the alpha coef
                alpha_2m_minus_1 = alpha_coefs(2*m);

                % Compute the term to be added
                term = alpha_2m_minus_1 ...
                    * mlp_params.w_layer1(no, nh) ...
                    * tc * theta1.^k(1) .* theta2.^k(2) .* theta3.^k(3);

                y = y + term;

            end
        end
    end
end

