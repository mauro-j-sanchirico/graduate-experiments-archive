%% Generate Binomial Table
%% Generates a Table of Binomial Coefficients

clc; clear; close all;

file_path_name = '../Math/LookupTables/binomial_table';


%% Generate and save the binomial table

num_n = 400;

binomial_table = vpa(zeros(num_n, num_n));

for n = 0:num_n
    fprintf('n = %i/%i\n', n, num_n);
    for k = 0:n
        binomial_table(n+1,k+1) = nchoosek(vpa(n),vpa(k));
    end
end

save(file_path_name, 'binomial_table');
