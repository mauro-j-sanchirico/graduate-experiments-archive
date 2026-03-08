%% EvalInterrogationPolynomial
%
% @breif Evaluates the output of a neural network using an expanded form
% of the neural network where entire neural network is expanded as a
% multivariate polynomial.
%
% @details Depending on the settings returned by GetAnalysisParameters the
% polynomial can either be evaluated using a condensed form (faster) or
% using a fully expanded form (very slow).
%
% @param[in] mlp_params - The MLP parameter struct
%
% @param[in] alpha_coefs - The alpha coefficients (i.e. the coefficients
% of the polynomial expansion of the hyperbolic tangent
%
% @param[in] mi_table - Precomputed multinomial indicies
%
% @param[in] mc_table - Precomputed multinomial coefficients
%
% @param[in] x - The input that the expanded neural network is to be
% evaluated on.
%
% @returns y - The output of the multivariate polynomial
%

function y = EvalInterrogationPolynomial( ...
    mlp_params, alpha_coefs, mi_table, mc_table, x)

m_expansion_params = GetModifiedExpansionParams();
mlp_hyperparams = GetMLPHyperparams();
analysis_params = GetAnalysisParams();

% Flip to math ordering
alpha_coefs = fliplr(alpha_coefs);

no = 1; % Number of outputs
big_ns = mlp_hyperparams.num_input + 1; % Number of terms in sum
n_points = size(x,2);
y = mlp_params.b_layer1(no);

for nh = 1:mlp_hyperparams.num_hidden

    % Get terms of the sum that is to be raised to the power of m
    % (theta_1 + theta_2 + ...  + theta_n)^j
    theta = zeros(big_ns, n_points);
    for idx = 1:mlp_hyperparams.num_input
        theta(idx, :) = mlp_params.w_layer0(nh, idx)*x(idx, :);
    end
    theta(big_ns, :) = mlp_params.b_layer0(nh);
    
    for m = 1:m_expansion_params.m_index_max
        
        j = 2*m - 1;
        
        if analysis_params.use_expanded_polynomials == false
            alpha_2m_minus_1 = alpha_coefs(2*m);
            term = ...
                alpha_2m_minus_1 ...
                * mlp_params.w_layer1(no, nh) ...
                * sum(theta).^j;
            y = y + term;
            
        else

            for k_idx = 1:length(mi_table{big_ns}{j})

                % Get the multi-index, k, and the multinomial coef, cm
                k = FastMultiIndex(mi_table, big_ns, j, k_idx);
                mc = FastMultinomialCoef(mc_table, big_ns, j, k);

                % Get the alpha coef
                alpha_2m_minus_1 = alpha_coefs(2*m);

                % Compute the term to be added
                term = alpha_2m_minus_1 ...
                    * mlp_params.w_layer1(no, nh) ...
                    * mc * ComputeMultiIndexPower(theta, k);

                y = y + term;

            end
        end
    end
end

