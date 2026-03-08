% @file wastedImpulse.m
%
% @brief given two forces f, and g, calculates the wasted impulse and
%        needed (well used) impulse
%
% @details f and g should be the same length
%

function [J_Tori J_Wasted J_Needed] = analyzeImpulse(t, F_Uke, F_Tori)
addpath ./absImpulse
[F_R F_Wasted F_Needed] = analyzeForce(F_Uke, F_Tori);

J_Tori   = absImpulse(t, F_Tori);
J_Wasted = absImpulse(t, F_Wasted);
J_Needed = absImpulse(t, F_Needed);

rmpath ./absImpulse
end