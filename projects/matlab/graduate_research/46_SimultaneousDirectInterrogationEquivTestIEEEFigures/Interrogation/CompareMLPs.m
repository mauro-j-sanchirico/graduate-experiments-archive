%% CompareMLPs
%
% @breif Computes an error metric that can be used to compare MLPs
%
% @details Expands each MLP as a multinomial and compares their
% coefficients in a transformed space
%
% @param[in] mlp_params1 - The parameter struct of the first MLP
%
% @param[in] mlp_params2 - The parameter struct of the second MLP
%
% @param[in] alpha_coefs - The coefficients of the hyperbolic tangent
% expansion
%
% @param[in] mi_table - Pre-computed multinomial indicies
%
% @param[in] mc_table - Pre-computed multinomial coefficients
%
% @returns e - the error metric between the MLPs
%
% @returns psi_flat1, psi_flat2 - The flattened psi_tensors for each MLP
%

function [e, psi_flat1, psi_flat2] = CompareMLPs( ...
    mlp_params1, mlp_params2, alpha_coefs, mi_table, mc_table)

psi_tensor1 = ComputePsiTensor( ...
    mlp_params1, alpha_coefs, mi_table, mc_table);

psi_tensor2 = ComputePsiTensor( ...
    mlp_params2, alpha_coefs, mi_table, mc_table);

keys1 = psi_tensor1.keys();
keys2 = psi_tensor2.keys();

psi_flat1 = zeros(1, numel(keys1));
psi_flat2 = zeros(1, numel(keys2));

for idx = 1:numel(keys1)
    key1 = keys1(idx);
    key2 = keys2(idx);
    psi_flat1(idx) = psi_tensor1(key1{1});
    psi_flat2(idx) = psi_tensor2(key2{1});
end

% pslog
e = sum(abs(ComputePseudoLog(psi_flat1) - ComputePseudoLog(psi_flat2)));
