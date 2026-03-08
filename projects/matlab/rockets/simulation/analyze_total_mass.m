%% Analyze total mass profile (including fuel burned)
% ------------------------------------------------------------------------
% @breif Performs analysis on the total mass profile including fuel burn
% ------------------------------------------------------------------------

function analyze_total_mass( ...
    fignum, ...
    sim ...
)

figure(fignum)
hold on
grid on

plot(sim.time_s, sim.total_mass_kg, 'k', 'linewidth', 2);

title('Total Mass Profile (including fuel burned)')
xlabel('Time (s)')
ylabel('Mass (kg)')
