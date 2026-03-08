clc; clear; close all;

n_max = 100;

nchoosek_table = zeros(n_max+1, n_max+1);

old_time = 0;

for n = 1:n_max
    tic;
    for k = 0:n
        nchoosek_table(n, k+1) = nchoosek(vpa(n), vpa(k));
    end
    t = toc;
    fprintf('Built n choose k table row %i / %i, t = %f\n', n, n_max, t);
    old_time = old_time + t;
end

save('nchoosek_table', 'nchoosek_table');

% benchmark performance
new_time = 0
for n = 1:n_max
    tic;
    for k = 0:n
        FastNChooseK(nchoosek_table, n, k);
    end
    t = toc;
    fprintf('Built n choose k table row %i / %i, t = %f\n', n, n_max, t);
    new_time = new_time + t;
end

old_time
new_time

speedup = old_time / new_time