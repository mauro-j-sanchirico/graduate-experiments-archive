%% Interp Table
% ------------------------------------------------------------------------
% @breif Interpolates the given old_table at the specified query points
% @details Uses linear interpolation to produce new_table. The 2D array
%  new table will have column 1 with the query points and column 2 with
%  the interpolated values.
%
%  Old table and new table are expected to be vertical:
%  x  | f(x)
%  ---+-----
%  x1 | f(x1)
%  .  | .
%  .  | .
%  .  | .
%  xn | f(xn)
%
% @param old_table - 2D array, column one is x data, column 2 is f(x)
% @param queries   - Points to query the old table at (i.e. new x)
%
% @returns new_table - A 2D table of the new x values and the interpolated
%  f(x) values at those points.
% ------------------------------------------------------------------------

function [new_table] = interp_table(old_table, queries)

new_table = zeros(length(queries),2);

new_table(:, 1) = queries;
new_table(:, 2) = interp1(old_table(:, 1), old_table(:, 2), queries);
