function [J_Tori J_Wasted J_Needed] = analyzeImpulseClever(A_Uke,  ...
                                                           A_Tori, ...
                                                           phi_Tori)
addpath ./Phasors
addpath ./Window

[A_R phi_R] = addPhasors(A_Uke, 0, A_Tori, phi_Tori);

[t_alpha t_beta] = getWindow(A_Uke, A_Tori, phi_Tori);

J_Tori = 4.*A_Tori;

AlphaTerm = 2.*A_Tori.*(1 - cos(phi_Tori - t_alpha));
BetaTerm  = 2.*A_Tori.*(1 + cos(phi_Tori - t_beta));
GammaTerm = 2.*A_Uke.*((t_beta-t_alpha) - cos(t_alpha) + cos(t_beta));

J_Wasted = AlphaTerm + BetaTerm + GammaTerm;
J_Needed = J_Tori - J_Wasted;
end