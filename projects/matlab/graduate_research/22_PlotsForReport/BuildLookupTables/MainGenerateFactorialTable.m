%% Generate Factorial Table
%% Generates and Saves a Table of Factorials

clc; clear; close all;

file_path_name = '../Math/LookupTables/factorial_table';


%% Generate and save the Factorial table

num_factorials = 400;

factorial_table = vpa(zeros(1,num_factorials));

for n = 1:num_factorials
    
    fprintf('Computing factorial %i/%i\n', n, num_factorials);
    
    factorial_table(n) = factorial(vpa(n-1));
    
end

save(file_path_name, 'factorial_table');
