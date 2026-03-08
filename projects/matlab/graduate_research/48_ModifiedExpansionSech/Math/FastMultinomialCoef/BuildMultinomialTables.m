%% Builds trinomial indicies and coefficients tables
%% Lookup tables required for computing trinomial expansions efficiently

clc; clear; close all;

max_n = 90;  % Max exponent
max_m = 4;   % Max number of terms inside sum
k_span = 0:max_n;

%% Build the multinomial indicies table

% Initialize the table
multinomial_indicies_table = cell(1, max_m);

for m = 1:max_m
    multinomial_indicies_table{m} = cell(1, max_n);
end

% Populate the table
for m = 1:max_m
    
    % Populate a cell array with m instances of k_span
    k_cells = cell(1, m);
    for idx = 1:length(k_cells)
        k_cells{idx} = k_span;
    end

    % Get all combinations of the kspan
    k_combinations = combvec(k_cells{:});
    k_combinations = k_combinations';
    
    % Seach for the combinations that add up to the exponent n
    for n = 1:max_n
        tic;
        for idx = 1:length(k_combinations)
            k_combo = k_combinations(idx,:);
            if sum(k_combo) == n
                multinomial_indicies_table{m}{n} = [
                    multinomial_indicies_table{m}{n};
                    k_combo];
            end
        end
        t = toc;
        fprintf( ...
            ['Built multinomial index table entry for' ...
             'm = %i of %i, n = %i of %i, t = %f\n'], ...
            m, max_m, n, max_n, t);
    end
end

save('multinomial_indicies_table', 'multinomial_indicies_table');


%% Build the trinomial coefs table

% Initialize the table
multinomial_coefs_table = cell(1, max_m);

for m = 1:max_m
    multinomial_coefs_table{m} = cell(1, max_n);
end

% Populate the table
for m = 1:max_m
    for n = 1:max_n
        multinomial_indicies = multinomial_indicies_table{m}{n};

        tic;
        multinomial_coefs_table{m}{n} = containers.Map( ...
            'KeyType', 'double', ...
            'ValueType', 'double');
        
        for idx = 1:length(multinomial_indicies)
            k = multinomial_indicies(idx, :);
            multinomial_coef = factorial(vpa(n))/prod(factorial(vpa(k)));
            multi_index_key = GetMultiIndexKey(k);
            multinomial_coefs_table{m}{n}(multi_index_key) = ...
                double(multinomial_coef);
        end
        
        t = toc;
        
        fprintf( ...
            ['Built multinomial coef table entry for' ...
             'm = %i of %i, n = %i of %i, t = %f\n'], ...
             m, max_m, n, max_n, t);
    end
end

save('multinomial_coefs_table', 'multinomial_coefs_table');
