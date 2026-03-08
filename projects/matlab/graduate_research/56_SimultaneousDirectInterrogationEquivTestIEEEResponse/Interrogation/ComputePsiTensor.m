%% ComputePsiTensor
%
% @breif Computes a tensor of all the coefficients of a multivariate
% polynomial expansion of a given neural network
%
% @param[in] mlp_params - The MLP parameter struct
%
% @param[in] alpha_coefs - The coefficients of the hyperbolic tangent
% expansion
%
% @param[in] mi_table - Pre-computed table of multinomial indicies
%
% @param[in] mc_table - Pre-computed table of multinomial coefficients
%
% @returns psi_tensor - The tensor of all the psi values
%

function psi_tensor = ComputePsiTensor( ...
    mlp_params, alpha_coefs, mi_table, mc_table)

% --------------------------------------------------------------------
% Get needed info
% --------------------------------------------------------------------
m_expansion_params = GetModifiedExpansionParams();
mlp_hyperparams = GetMLPHyperparams();
analysis_params = GetAnalysisParams();
big_ns = mlp_hyperparams.num_input + 1; % Number of terms in sum

% Flip to math ordering
alpha_coefs = fliplr(alpha_coefs);

% --------------------------------------------------------------------
% Initialize the psi tensor
% --------------------------------------------------------------------

% A hash table is used to keep track of psi tensor indicies to allow
% for flexible hyperdimensional indexing
psi_tensor = containers.Map('KeyType', 'double', 'ValueType', 'double');

for nh = 1:mlp_hyperparams.num_hidden
    m_stop = min( ...
        analysis_params.n_alpha_equiv_test, ...
        m_expansion_params.m_index_max);
    for m = 1:m_stop
        j = 2*m - 1;
        multi_index_length = length(mi_table{big_ns}{j});
        if analysis_params.n_multi_index_max == inf
            k_stop = multi_index_length;
        else
            k_stop = min( ...
                analysis_params.n_multi_index_max, multi_index_length);
        end
        for k_idx = 1:k_stop
            % Get the multi-index, k, and the multinomial coef, mc
            k = FastMultiIndex(mi_table, big_ns, j, k_idx);
            % Get a multi-index key for the hashmap
            k_key = GetMultiIndexKey(k);
            psi_tensor(k_key) = 0;
        end
    end
end

% -------------------------------------------------------------------
% Compute psi tensor elements
% -------------------------------------------------------------------
for nh = 1:mlp_hyperparams.num_hidden
    
    % Get terms of the sum that is to be raised to the power of m
    w = [mlp_params.w_layer0(nh, :) mlp_params.b_layer0(nh)];
    
    m_stop = min( ...
        analysis_params.n_alpha_equiv_test, ...
        m_expansion_params.m_index_max);
    
    for m = 1:m_stop
        
        j = 2*m - 1;
        
        multi_index_length = length(mi_table{big_ns}{j});
        
        if analysis_params.n_multi_index_max == inf
            k_stop = multi_index_length;
        else
            k_stop = min( ...
                analysis_params.n_multi_index_max, multi_index_length);
        end
        
        for k_idx = 1:k_stop

            % Get the multi-index, k, and the multinomial coef, mc
            k = FastMultiIndex(mi_table, big_ns, j, k_idx);
            mc = FastMultinomialCoef(mc_table, big_ns, j, k);

            % Get the alpha coef
            alpha_2m_minus_1 = alpha_coefs(2*m);

            % Compute the term to be added
            psi_tensor_element = ...
                alpha_2m_minus_1 ...
                * mc ...
                * mlp_params.w_layer1(nh) ...
                * ComputeMultiIndexPower(w',k);
            
            % Get a multi-index key for the hashmap
            k_key = GetMultiIndexKey(k);
            
            % Add the term
            psi_tensor(k_key) = psi_tensor(k_key) + psi_tensor_element;
            
        end
    end
end

end
