%% rocket_acceleration
%% Rocket acceleration as a function of rocket velocity and time
%
% @breif Calculates ENU acceleration experienced by the rocket
%
% @details  The total force is the sum of the thrust, drag and gravity.
%  Defines a function: a(v, params) = F_thrust/mass + F_drag/mass + G
%  which is suitable for use in numerical integration algorithms to
%  determine v(t+h) from known v(t).
%
% @param vel_enu - ENU velocity vector
%
% @param rocket  - The rocket information struct.  Expected to have
%  'prev_idx' member added so this function knows where to look in the
%  mass and drag to tables to get current forces.
%
% @returns acceleration vector
%

function acc_enu = rocket_acceleration(vel_enu, rocket)

constants;

thrust    = rocket.thrust_N  (rocket.prev_idx);
mass      = rocket.mass_kg   (rocket.prev_idx);
drag_coef = rocket.drag_coef (rocket.prev_idx);
area      = rocket.area_m2   (rocket.prev_idx);

K = (0.5/mass)*(const.RHO)*drag_coef*area;

% If the rocket is still on the launch rod, get the thrust direction from
% the initial azimuth and elevation.  Otherwise, get the thrust direction
% from the previous velocity vector.

if rocket.on_launch_pad == 1
    
    az_rad = rocket.init_az_deg*const.DEG2RAD;
    el_rad = rocket.init_el_deg*const.DEG2RAD;
    
    [init_e, init_n, init_u] = sph2cart(az_rad, el_rad, 1);
    
    init_dir_hat = [init_e, init_n, init_u];
    
    acc_thrust_enu = init_dir_hat.*thrust./mass;
    
else
    
    vel_hat = vel_enu./norm(vel_enu);    
    acc_thrust_enu = vel_hat.*thrust./mass;
    
end

acc_drag_enu   = -K.*vel_enu.*abs(vel_enu);
acc_grav_enu   = [const.GE const.GN -const.GU];

acc_enu = acc_thrust_enu + acc_drag_enu + acc_grav_enu;
