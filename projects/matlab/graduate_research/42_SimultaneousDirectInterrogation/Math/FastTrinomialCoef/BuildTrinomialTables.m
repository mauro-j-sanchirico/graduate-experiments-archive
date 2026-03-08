%% Builds trinomial indicies and coefficients tables
%% Lookup tables required for computing trinomial expansions efficiently

clc; clear; close all;

max_n = 90;
k_span = 0:max_n;


%% Build the trinomial indicies table

k_combinations = combvec(k_span, k_span, k_span);
k_combinations = k_combinations';

trinomial_indicies_table = {};

for n = 1:max_n
     trinomial_indicies_table{n} = [];
     tic;
     for idx = 1:length(k_combinations)
         k_combo = k_combinations(idx,:);
         if sum(k_combo) == n
             trinomial_indicies_table{n} = [
                 trinomial_indicies_table{n};
                 k_combo];
         end
     end
     t = toc;
     fprintf( ...
       'Built trinomial index table entry for n = %i of %i, t = %f\n', ...
        n, max_n, t);
end

save('trinomial_indicies_table', 'trinomial_indicies_table');


%% Build the trinomial coefs table

trinomial_coefs_table = {};

for n = 1:max_n
    
     trinomial_indicies = trinomial_indicies_table{n};
     
     tic;
     trinomial_coefs_table{n} = [];
     
     for idx = 1:length(trinomial_indicies)
         
         k = trinomial_indicies(idx, :);
         
         numer = factorial(vpa(n));
         denom = factorial(vpa(k(1))) ...
             * factorial(vpa(k(2))) ...
             * factorial(vpa(k(3)));
         
         trinomial_coef = numer/denom;
         
         trinomial_coefs_table{n}(k(1)+1, k(2)+1, k(3)+1) = numer/denom;
     end
     t = toc;
     fprintf( ...
       'Built trinomial coef table entry for n = %i of %i, t = %f\n', ...
        n, max_n, t);
end

save('trinomial_coefs_table', 'trinomial_coefs_table');
