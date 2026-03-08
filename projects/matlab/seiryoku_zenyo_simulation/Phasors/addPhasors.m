% @file addPhasors.m
%
% @brief adds two phasors
%

function [A3 phi3] = addPhasors(A1, phi1, A2, phi2)

delta_phi = phi1 - phi2;

A3 = sqrt(A1.^2 + A2.^2 + 2.*A1.*A2.*cos(delta_phi));

phi3 = atan2( A1.*sin(phi1)+A2.*sin(phi2), ...
              A1.*cos(phi1)+A2.*cos(phi2));
end