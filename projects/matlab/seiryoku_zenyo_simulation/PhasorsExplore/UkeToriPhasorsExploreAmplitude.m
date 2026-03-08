%% Exploring result wave params as a function of input wave params
%
% @file UkeToriPhasorsExploreAmplitude.m
%
% @brief Exploration of result amplitude as functio of Uke amplitude,
%        Tori amplitude, and Tori phase for equal frequency Uke and 
%        Tori sine waves
%
% @details Set animation = true to run animation plots
%

%% Set Up

RAD_TO_DEG = 180/pi;

dA = 2;

A_Uke_min = -40;
A_Uke_max = 40;
A_Uke_axis = A_Uke_min:dA:A_Uke_max;

A_Tori_min = -40;
A_Tori_max = 40;
A_Tori_axis = A_Tori_min:dA:A_Tori_max;

[A_Uke A_Tori] = meshgrid(A_Uke_axis, A_Tori_axis);

phi_Tori_min = 0;
phi_Tori_max = 2*pi;

dphi = (phi_Tori_max - phi_Tori_min)/200;

phi_Tori_axis = phi_Tori_min:dphi:phi_Tori_max;


%% Animated Sequence 1

addpath ..\Phasors

n = 0;

animation = 0;

if animation == 1
    
for phi = phi_Tori_axis
    n=n+1;
    [A_R phi_R] = addPhasors(A_Uke, 0.*A_Uke, A_Tori, 0.*A_Tori+phi);
    
    figure(n)
       contour(A_Uke, A_Tori, A_R);
       hold on
       surf(A_Uke, A_Tori, A_R);
       colormap hsv
       alpha(0.4)
       view(40,24)
       
       xlabel('A_U');
       ylabel('A_T');
       zlabel('A_R');
       string_title = sprintf('Phi = %.2f deg', phi*RAD_TO_DEG);
       title(string_title);

       grid off
       zlim([0 A_Uke_max + A_Tori_max]);
       
    filename = sprintf('AmplitudeGIF1/slide%d', n);
    print('-dpng', '-r0', filename);
    
    close all
end
end

%% Animated Sequence 2

for phi = phi_Tori_axis
    n=n+1;
    [A_R phi_R] = addPhasors(A_Uke, 0.*A_Uke, A_Tori, 0.*A_Tori+phi);
    
    figure(n)
       contour(A_Uke, A_Tori, A_R);
       hold on
       surf(A_Uke, A_Tori, A_R);
       colormap hsv
       alpha(0.4)
       view(90,-90)
       
       xlabel('A_U');
       ylabel('A_T');
       zlabel('A_R');
       string_title = sprintf('Phi = %.2f deg', phi*RAD_TO_DEG);
       title(string_title);

       grid off
       zlim([0 A_Uke_max + A_Tori_max]);
       
    filename = sprintf('AmplitudeGIF2/slide%d', n);
    print('-dpng', '-r0', filename);
    
    close all
end

