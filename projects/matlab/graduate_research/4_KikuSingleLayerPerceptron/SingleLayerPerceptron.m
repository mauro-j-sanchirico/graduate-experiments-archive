%% SingleLayerPerceptron
%
% @brief Applies single layer perceptron processing to x with weights w
%
% @details Uses tanh as a nonlinear output function
%
% @param[in] w - 1xm row vector of perceptron weights
%
% @param[in] x_matrix - mxn matrix where m is model order and n is number
% of data points.
%
% @returns y - 1xn output vector of perceptron outputs (1 for each of the
% n data points passed in via x_matrix)
%
function [y] = SingleLayerPerceptron(w, x_matrix)
y = tanh(w*x_matrix);
end

