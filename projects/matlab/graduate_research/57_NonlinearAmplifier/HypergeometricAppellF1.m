function [ F ] = HypergeometricAppellF1( Alpha, Beta, BetaPrime, Gamma, x, y)
% Computes the Appel (First Bivariate) Hypergeometric Function : HypergeometricAppellF1( Alpha; Beta, BetaPrime; Gamma; x, y)
% 
% Created by Chris Arcadia Brown University 09/10/2016
%
% For more details please see:
%   * Bailey, W. N. "Appell's Hypergeometric Functions of Two Variables." Ch. 9 in Generalised Hypergeometric Series. Cambridge, England: Cambridge University Press, pp. 73-83 and 99-101, 1935.
%   * http://mathworld.wolfram.com/AppellHypergeometricFunction.html
%
% Example: 
%   F = HypergeometricAppellF1(1/2,n,-n,3/2,(z/L).^2,(H*(z/L)/(b+H)).^2);
% constants
integration_tolerance = 1e-12; % absolute error tolerance of TOL (default: 1.0e-6)
N = length(x);
% can compute F1 using the following simple integral (Bailey 1934, p. 77)
F = zeros(1,N);
if real(Alpha)>0 && real(Gamma-Alpha)>0 % check for intergral validness
    % computing equation (9) from the mathworld article
    G = gamma(Gamma)/(gamma(Alpha)*gamma(Gamma-Alpha));
    for n=1:N
        ulim = [0,1];
        U = @(u) u.^(Alpha-1) .* (1-u).^(Gamma-Alpha-1) .* (1-u.*x(n)).^(-Beta) .* (1-u.*y(n)).^(-BetaPrime); 
        I = integral(U,ulim(1),ulim(2),'AbsTol',integration_tolerance); 
        F(n) = G*I;
    end
else
    warning('cannot compute value')
    F = F*nan;
end
end