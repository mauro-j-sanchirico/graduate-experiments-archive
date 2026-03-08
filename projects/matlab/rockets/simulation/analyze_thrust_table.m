%% Analyze Thrust Table
% ------------------------------------------------------------------------
% @breif Performs analysis on the given thrust table
% @details Generates plots for the thrust table
% ------------------------------------------------------------------------

function analyze_thrust_table( ...
    fignum, ...
    thrust_table, ...
    interp_thrust ...
)

% Get the global constants
constants;

figure(fignum)
hold on
grid on

scatter(thrust_table(:,1), thrust_table(:,2), 'ok');
plot(interp_thrust(:,1), interp_thrust(:,2), 'k', 'linewidth', 2);

first_two_thrust_zeros = find(thrust_table(:,2) < const.EPS, 2);
last_thrust_idx = first_two_thrust_zeros(end);

xlim([thrust_table(1,1) thrust_table(last_thrust_idx,1)]);

title('Thrust Profile')
xlabel('Time (s)')
ylabel('Thrust (N)')

legend('Thrust Table', 'Interp. Thrust')

