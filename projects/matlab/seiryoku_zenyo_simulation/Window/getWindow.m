% @file getWindow.m
%
% @brief finds t_alpha and t_beta for a given A_Uke, A_Tori, phi_Tori
%
% @details getWindow performs no checking to make sure t_\alpha
%          t_\beta are real.
%
%          If t_\alpha and t_\beta are equal, or if t_\alpha and 
%          t_\beta both have imaginary parts, then there is no
%          "moment of oppurtunity" and all of Tori's impulse will
%          be wasted.
%

function [t_alpha t_beta] = getWindow(A_Uke, A_Tori, phi_Tori)
addpath ./Phasors
[A_R phi_R] = addPhasors(A_Uke, 0, A_Tori, phi_Tori);
rmpath ./Phasors

t_alpha = asin(A_Uke./A_R) + phi_R;
t_beta  = 2.*phi_R+pi-t_alpha;

end