%% rsim
%% 3DOF Model Rocket Simulation
%
% @brief 3DOF simulation of a rocket flight
% @details Simple 3DOF rocket simulation sufficient for model rocket
%  flight test planning.  Models nonlinear drag and mass flow.  Does not
%  model rotation of the earth, roll effects, and coupling between state
%  variables.  The rocket is modeled as a point particle with time-varying
%  mass and time varying drag.  An ENU (East, North, Up) coordinate system
%  is used with launch location at the origin.
%
% @details During times when the rocket is thrusting, mass lost due to
%  fuel burned will be removed from the rocket's total mass; i.e. the mass
%  provided can vary with time but should not include mass loss due to
%  fuel burning.
%
% @param rocket - A struct describing the rocket to be simulated
%
% @returns sim - A struct containing all the simulation results
%
% @struct: rocket
% @member time_s - Monotonically increasing vector of N points in seconds
% @member mass_kg     - N element vector of mass (kg) values wrt time
% @member thrust_N    - N element vector of thrust (N) values wrt time
% @member drag_coef   - N element vector of drag coef. values wrt time
% @member area_m2     - N element vector of cross section area wrt time
% @member launch_rod_m  - Length in meters of the launch rod
% @member on_launch_pad - True if the rocket is still on the launch rod
% @member total_fuel_kg - Total mass of fuel on board in kilograms
% @member init_az_deg   - Initial azimuth angle in degrees
% @member init_el_deg   - Initial elevation angle in degrees
%

function [sim] = rsim(rocket)

% Validate user input

if length(rocket.mass_kg) ~= length(rocket.time_s)
    error('"mass_kg" vector must be same length as "time_s" vector.');
end

if length(rocket.thrust_N) ~= length(rocket.time_s)
    error('"thrust_N" vector must be same length as "time_s" vector')
end

if length(rocket.drag_coef) ~= length(rocket.time_s)
    error('"drag_coef" vector must be same length as "time_s" vector.');
end

if length(rocket.area_m2) ~= length(rocket.time_s)
    error('"area_m2" vector must be same length as "time_s" vector.');
end

% Get global constants

constants;

% Pre-initialize vectors so MATLAB won't have to resize them

N = length(rocket.time_s);
z = zeros(N, 1);

sim.time_s        = z;
sim.pos_e_m       = z;
sim.pos_n_m       = z;
sim.pos_u_m       = z;
sim.vel_e_mps     = z;
sim.vel_n_mps     = z;
sim.vel_u_mps     = z;
sim.total_mass_kg = z;
sim.fuel_kg       = z;

% Initialize the state variables

fprintf('[t = %f s]    IGNITION\n', sim.time_s(1));

sim.time_s = rocket.time_s;

sim.pos_e_m(1) = 0;
sim.pos_n_m(1) = 0;
sim.pos_u_m(1) = 0;   

sim.vel_e_mps(1) = 0;
sim.vel_n_mps(1) = 0;
sim.vel_u_mps(1) = 0;

sim.total_mass_kg(1) = rocket.mass_kg(1) + rocket.total_fuel_kg;

sim.fuel_kg(1) = rocket.total_fuel_kg;

% Calculate the total thrust by integrating the thrust table
total_thrust = trapz(rocket.time_s, rocket.thrust_N);

% Fly the rocket - on each iteration we are calculating the ith state
% using the (i-1)th state

for i = 2:N
    
    % --------------------------------------------------------------------
    % Calculate mass lost due to fuel burn
    %
    % Here we assme mass lost is proportional to thrust generated from
    % step i-1 to step i.  Over the entire burn period, we know we burn
    % all the fuel.  We burn more fuel when thrust is greater and less
    % fuel when thrust is smaller.
    % -------------------------------------------------------------------
    
    current_thrust = trapz( ...
        [sim.time_s(i-1) sim.time_s(i)], ...
        [rocket.thrust_N(i-1) rocket.thrust_N(i)] ...
    );

    thrust_ratio = current_thrust/total_thrust;
    
    fuel_burned_kg = thrust_ratio*rocket.total_fuel_kg;
    
    % --------------------------------------------------------------------
    % Update mass
    % --------------------------------------------------------------------
    
    sim.fuel_kg(i) = sim.fuel_kg(i-1) - fuel_burned_kg;
    
    sim.total_mass_kg(i) = rocket.mass_kg(i) + sim.fuel_kg(i);
    
    % --------------------------------------------------------------------
    % Update velocity
    % --------------------------------------------------------------------
    
    rocket.prev_idx = i-1;
    
    vel_enu = [sim.vel_e_mps(i-1) sim.vel_n_mps(i-1) sim.vel_u_mps(i-1)];
    
    vel_enu_next = runge_kutta_next( ...
        @rocket_acceleration, ...
        vel_enu, ...
        const.DT, ...
        rocket ...
    );
    
    % The rocket can't fall into the ground while on the launch pad
    if rocket.on_launch_pad && vel_enu_next(3) < 0
        vel_enu_next(3) = 0.0;
    end
    
    sim.vel_e_mps(i) = vel_enu_next(1);
    sim.vel_n_mps(i) = vel_enu_next(2);
    sim.vel_u_mps(i) = vel_enu_next(3);
    
    % --------------------------------------------------------------------
    % Update position
    %
    % There is no need to perform Runge-Kutta for the position states in
    % this simulation, since Runge-Kutta simplifies to the elementary
    % position formula:
    %
    % a=f(x)= v; b=f(x+h/2*a)= v; c=f(x+h/2*b)=v; d=f(x+h*c)=v;
    %
    % x(n+1) = x(n) + (h/6)*(a+2*b+2*c+d) = x(n) + (h/6)(6*v)
    % x(n+1) = x(n) + h*v
    % --------------------------------------------------------------------
    
    sim.pos_e_m(i) = sim.pos_e_m(i-1) + const.DT*sim.vel_e_mps(i-1);
    sim.pos_n_m(i) = sim.pos_n_m(i-1) + const.DT*sim.vel_n_mps(i-1);
    sim.pos_u_m(i) = sim.pos_u_m(i-1) + const.DT*sim.vel_u_mps(i-1);
    
    % --------------------------------------------------------------------
    % Check if the rocket is still on the launch pad by checking if the
    % total displacement is greater than the length of the launch rod
    % --------------------------------------------------------------------
    displacement = norm([sim.pos_e_m sim.pos_n_m sim.pos_u_m]);
    
    if displacement > rocket.launch_rod_m && rocket.on_launch_pad
        rocket.on_launch_pad = false;
        fprintf('[t = %f s]    LIFT OFF\n', sim.time_s(i));
    end
    
    % --------------------------------------------------------------------
    % Check if the rocket hit earth
    % --------------------------------------------------------------------
    
    if (sim.pos_u_m(i) < const.HIT_EARTH) && ~rocket.hit_earth
        rocket.hit_earth = true;
        fprintf('[t = %f s]    IMPACT\n', sim.time_s(i));
        break;
    end
    
end

if ~rocket.hit_earth
    fprintf('[t = %f s]    GAME OVER. NO IMPACT.\n', sim.time_s(i));
else
    fprintf('[t = %f s]    GAME OVER.\n', sim.time_s(i));
    
    % Truncate simulation variables
    sim.vel_e_mps = sim.vel_e_mps(1:i);
    sim.vel_n_mps = sim.vel_n_mps(1:i);
    sim.vel_u_mps = sim.vel_u_mps(1:i);
    
    sim.pos_e_m = sim.pos_e_m(1:i);
    sim.pos_n_m = sim.pos_n_m(1:i);
    sim.pos_u_m = sim.pos_u_m(1:i);
    
    sim.total_mass_kg = sim.total_mass_kg(1:i);
    
    sim.time_s = sim.time_s(1:i);
end