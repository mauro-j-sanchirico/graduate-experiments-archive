%% Analyze rocket liftoff profile
% ------------------------------------------------------------------------
% @breif Performs altitude vs. time analysis
% ------------------------------------------------------------------------

function analyze_liftoff_profile( ...
    fignum, ...
    sim, ...
    cutoff ...
)

figure(fignum)
hold on
grid on

plot(sim.time_s, sim.pos_u_m, 'k', 'linewidth', 2);

xlim([0 cutoff])

title_str = sprintf('Liftoff Profile (before t = %f s)', cutoff);

title(title_str)
xlabel('Time (s)')
ylabel('Altitude (m)')
