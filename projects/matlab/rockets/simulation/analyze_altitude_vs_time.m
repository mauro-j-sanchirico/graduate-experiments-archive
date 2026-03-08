%% Analyze rocket altitude vs time
% ------------------------------------------------------------------------
% @breif Performs altitude vs. time analysis
% ------------------------------------------------------------------------

function analyze_altitude_vs_time( ...
    fignum, ...
    sim ...
)

figure(fignum)
hold on
grid on

plot(sim.time_s, sim.pos_u_m, 'k', 'linewidth', 2);

title('Altitude vs. Time')
xlabel('Time (s)')
ylabel('Altitude (m)')
