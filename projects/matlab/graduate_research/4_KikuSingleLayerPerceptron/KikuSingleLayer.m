%% KikuSingleLayer
%
% @brief Single layer version of the Kiku perceptron interrogation
%
% @details Given the input matrix to a single layer perceptron with
% nonlinear activation and its cooresponding output matrix, returns the
% weights.  Assumes a hyperbolic tangent nonlinearity.
%
% @param[in] x_matrix - mxn input matrix where m is the model order and n
% is the number of data points
%
% @param[in] y_matrix - 1xn output vector where n is the number of data
% points
%
% @returns w - the weights of the SLP
%
function [w] = KikuSingleLayer(x_matrix, y)
w = atanh(y)/x_matrix;
end
