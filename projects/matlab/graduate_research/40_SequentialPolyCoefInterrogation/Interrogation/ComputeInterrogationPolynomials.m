function interrogation_coefs = ComputeInterrogationPolynomials( ...
    mlp_params, nchoosek_table, alpha_coefs)

m_expansion_params = GetModifiedExpansionParams();
mlp_hyperparams = GetMLPHyperparams();

% flip to math ordering
alpha_coefs = fliplr(alpha_coefs);

no = 1;
big_m = m_expansion_params.m_index_max;
big_nh = mlp_hyperparams.num_hidden;

num_coefs = 2*big_m - 1;
interrogation_coefs = zeros(mlp_hyperparams.num_input, num_coefs);

% Loop through each active input
for ni = 1:mlp_hyperparams.num_input
    % Loop through each interrogation polynomial coef
    for k = 0:(2*big_m - 1)
        coef = 0;
        % Compute each interrogation polynomial coef
        for nh = 1:big_nh
            for m = (floor(k/2)+1):big_m
                j = 2*m - 1;
                alpha_2m_minus_1 = alpha_coefs(2*m);
                term = alpha_2m_minus_1 ...
                    * mlp_params.w_layer1(no, nh) ...
                    * (mlp_params.w_layer0(nh, ni))^k ...
                    * (mlp_params.b_layer0(nh))^(j-k) ...
                    * FastNChooseK(nchoosek_table, j, k);
                coef = coef + term;
            end
        end
        interrogation_coefs(ni, k+1) = coef;
    end
end

% flip to matlab ordering
interrogation_coefs = fliplr(interrogation_coefs);

% add the bias term
interrogation_coefs = ...
    AddPolynomials(interrogation_coefs, mlp_params.b_layer1);


