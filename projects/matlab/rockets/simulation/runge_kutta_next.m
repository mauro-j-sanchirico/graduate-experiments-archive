%% runge_kutta_next
%% Multi-variable Runge-Kutta next step
%
% @brief Performs multi-variable Runge-Kutta and returns the next step
%
% @param f - Callable function handle of the form f(x, params).  Params
%   may be a struct containing other parameters not involved in the
%   Runge-Kutta approximation.  x is a vector to be updated.
%
% @param x_curr - Vector representing the current simulation state
%
% @param h      - Runge-Kutta time step
%
% @param params - Struct of params to pass to f
%

function [x_next] = runge_kutta_next(f, x_curr, h, params)
   
a = f(x_curr,          params);
b = f(x_curr + a*h./2, params);
c = f(x_curr + b*h./2, params);
d = f(x_curr + c*h,    params);

x_next = x_curr + h/6*(a + 2*b + 2*c + d);
