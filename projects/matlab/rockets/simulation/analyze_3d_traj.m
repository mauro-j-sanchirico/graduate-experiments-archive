%% Analyze 3D Trajectory
% ------------------------------------------------------------------------
% @breif Performs 3D Trajectory Analysis
% ------------------------------------------------------------------------

function analyze_3d_traj( ...
    fignum, ...
    sim ...
)

figure(fignum)

plot3(sim.pos_e_m, sim.pos_n_m, sim.pos_u_m, 'k', 'linewidth', 2);

title('Trajectory')
xlabel('East (m)')
ylabel('North (m)')
zlabel('Up (m)')

grid on
