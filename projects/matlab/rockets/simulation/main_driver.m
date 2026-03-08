%% RSim Driver
%% Model Rocket Simulation
% 
% Main driver program for rsim.
%
% Loads tables, performs interpolations, runs the sim, performs analysis.
%
% Publish as PDF to get a full report on the simulation set up and
% results.

clc; clear; close all;

Date = datestr(now, 21);
disp(Date);

%% Setup

% Get the global constants
constants;

% Load tables
load mass_tables/qtrA3_mass.txt
load thrust_tables/qtrA3.txt
load drag_tables/qtrA3_drag.txt
load area_tables/qtrA3_area.txt

mass_table   = qtrA3_mass;
thrust_table = qtrA3;
drag_table   = qtrA3_drag;
area_table   = qtrA3_area;

% Set up a time array
time = 0:const.DT:12.0;

% Interpolate the tables for the given time array
interp_mass   = interp_table(mass_table, time);
interp_thrust = interp_table(thrust_table, time);
interp_drag   = interp_table(drag_table, time);
interp_area   = interp_table(area_table, time);

% Determine how much fuel is burned from motor spec sheet info
init_motor_mass_kg = 0.0061;
post_motor_mass_kg = 0.0038;

total_fuel_kg = init_motor_mass_kg - post_motor_mass_kg;

% Set up the rocket data to pass to the simulation
rocket.time_s         = time;
rocket.mass_kg        = interp_mass(:,2);
rocket.thrust_N       = interp_thrust(:,2);
rocket.drag_coef      = interp_drag(:,2);
rocket.area_m2        = interp_area(:,2);
rocket.init_az_deg    = 0;
rocket.init_el_deg    = 45;
rocket.launch_rod_m   = 0.3;
rocket.on_launch_pad  = true;
rocket.total_fuel_kg  = total_fuel_kg;
rocket.hit_earth      = false;


%% Simulation and Analysis

% Run the simulation
sim = rsim(rocket);

% Perform analysis
fignum = 1;
analyze_thrust_table(fignum, thrust_table, interp_thrust);

fignum = fignum + 1;
analyze_drag_table(fignum, drag_table, interp_drag);

fignum = fignum + 1;
analyze_area_table(fignum, area_table, interp_area);
fignum = fignum + 1;
analyze_mass_table(fignum, mass_table, interp_mass);

fignum = fignum + 1;
analyze_total_mass(fignum, sim);

fignum = fignum + 1;
analyze_range_vs_time(fignum, sim);

fignum = fignum + 1;
analyze_altitude_vs_time(fignum, sim);

fignum = fignum + 1;
cutoff = 1;
analyze_liftoff_profile(fignum, sim, cutoff);

fignum = fignum + 1;
analyze_3d_traj(fignum, sim);

%% Analyze multiple elevation angles

% Some choice to analyze

init_el_options = [10 20 30 45 60 70 80];

K = length(init_el_options);

fignum = fignum + 1;
figure(fignum)

fprintf('\n\nElevation angle analysis\n\n');

for i = 1:K
    
    % Reset the rocket

    rocket.time_s         = time;
    rocket.mass_kg        = interp_mass(:,2);
    rocket.thrust_N       = interp_thrust(:,2);
    rocket.drag_coef      = interp_drag(:,2);
    rocket.area_m2        = interp_area(:,2);
    rocket.init_az_deg    = 0;
    rocket.launch_rod_m   = 0.3;
    rocket.on_launch_pad  = true;
    rocket.total_fuel_kg  = total_fuel_kg;
    rocket.hit_earth      = false;
    
    rocket.init_el_deg = init_el_options(i);
    
    
    fprintf(' -- Sim %d ------------------------------------------\n', i);
    sim = rsim(rocket);
    fprintf(' ----------------------------------------------------\n\n');
    
    plot3(sim.pos_e_m, sim.pos_n_m, sim.pos_u_m, 'k', 'linewidth', 2);
    
    hold on
    
end

grid on

view([15 20])
title('Flight Paths for Several Elevation Angles');
xlabel('East (m)');
ylabel('North (m)');
zlabel('Up (m)');


