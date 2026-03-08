% @file CEF.m
%
% @brief Closest Element Functional (CEF)
%
% @details For each element of f, CEF returns the element of g
%          closest to it
%
%          h[i] = g[j] s.t. g[j] is the element of g closest to f[i]
%

function [h] = CEF(f,g)
L = length(f);
h = zeros(1,L);

for i = 1:L
    [m j] = min(abs(g - f(i)));
    h(i) = g(j);
end    
end