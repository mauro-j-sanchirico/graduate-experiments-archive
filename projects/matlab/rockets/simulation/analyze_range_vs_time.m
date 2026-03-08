%% Analyze rocket range vs time
% ------------------------------------------------------------------------
% @breif Performs range vs. time analysis
% ------------------------------------------------------------------------

function analyze_range_vs_time( ...
    fignum, ...
    sim ...
)

figure(fignum)
hold on
grid on

range_m = sqrt(sim.pos_e_m.^2 + sim.pos_n_m.^2);

plot(sim.time_s, range_m, 'k', 'linewidth', 2);

title('Range vs. Time')
xlabel('Time (s)')
ylabel('Range (m)')
