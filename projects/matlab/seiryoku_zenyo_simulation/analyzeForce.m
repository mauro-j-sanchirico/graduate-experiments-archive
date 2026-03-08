% @file analyzeForce.m
%
% @brief Analyzes force for each moment in Uke Tori Randori
%
% @details Given two forces, F_Uke and F_Tori, this function uses
%          Closest Element Functionals (CEFs) to determine how much
%          force Tori is putting to good use (F_Needed) and how much
%          force Tori is wasting (F_Wasted) for each instant
%
%          analyzeForce assumes that F_Uke and F_Tori are the same size
%

function [F_R F_Wasted F_Needed] = analyzeForce(F_Uke, F_Tori)
addpath ./CEF
F_R = F_Uke + F_Tori;
F_Wasted = CEF(F_R, F_Uke) - F_Uke;
F_Needed = F_Tori - F_Wasted;
rmpath ./CEF
end