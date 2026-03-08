% @file absImpulse.m
%
% @brief Takes the impulse of the absolute value of f
%
% @details J = integral( |f| ) dt
%

function [J] = absImpulse(t, f)
J = trapz(t,abs(f));
end
