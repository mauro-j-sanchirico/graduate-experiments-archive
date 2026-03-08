%% Analyze rocket mass
% ------------------------------------------------------------------------
% @breif Performs analysis on the mass table
% ------------------------------------------------------------------------

function analyze_mass_table( ...
    fignum, ...
    mass_table, ...
    interp_mass ...
)

% Get the global constants
constants;

figure(fignum)
hold on
grid on

scatter(mass_table(:,1), mass_table(:,2), 'ok');
plot(interp_mass(:,1), interp_mass(:,2), 'k', 'linewidth', 2);

ylim([min(mass_table(:,2))*0.9 max(mass_table(:,2))*1.1]);

title('Body Mass Profile (not including fuel)')
xlabel('Time (s)')
ylabel('Mass (kg)')

legend('Mass Table', 'Interp. Mass')
