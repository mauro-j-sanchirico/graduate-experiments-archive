function y = EvalInterrogationPolynomial( ...
    active_input_ni, mlp_params, alpha_coefs, x)

m_expansion_params = GetModifiedExpansionParams();
mlp_hyperparams = GetMLPHyperparams();
nchoosek_table_struct = load('./Math/FastNChooseK/nchoosek_table.mat');
nchoosek_table = nchoosek_table_struct.nchoosek_table;

% flip to math ordering
alpha_coefs = fliplr(alpha_coefs);

no = 1;
big_m = m_expansion_params.m_index_max;
big_nh = mlp_hyperparams.num_hidden;
ni = active_input_ni;

y = mlp_params.b_layer1(no);

for k = 0:(2*big_m - 1)
    for nh = 1:big_nh
        for m = (floor(k/2)+1):big_m
            j = 2*m - 1;
            alpha_2m_minus_1 = alpha_coefs(2*m);
            term = alpha_2m_minus_1 ...
                * mlp_params.w_layer1(no, nh) ...
                * (mlp_params.w_layer0(nh, ni))^k ...
                * (mlp_params.b_layer0(nh))^(j-k) ...
                * FastNChooseK(nchoosek_table, j, k) ...
                * x(ni, :).^k;
            y = y + term;
        end
    end
end

