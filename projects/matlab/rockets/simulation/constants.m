%% Constants
% ------------------------------------------------------------------------
% @brief Global simulation constants
% @details All constants stored in a 'const' struct
% ------------------------------------------------------------------------

const.EPS       = eps;    % Simulation precision
const.DT        = 0.001;  % Time step length
const.RHO       = 1.184;  % Density of air at 25C (75F)
const.RAD2DEG   = 180/pi; % Radians to degrees conversion
const.DEG2RAD   = pi/180; % Degrees to radians conversion
const.GE        = 0;      % Acceleration due to gravity (east)
const.GN        = 0;      % Acceleration due to gravity (north)
const.GU        = 9.81;   % Acceleration due to gravity (up - m/s/s)
const.HIT_EARTH = -0.1;   % Below this height (m) impact is declared
