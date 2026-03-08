%% Generate Bernoulli Table
%% Generates and Saves a Table of Bernoulli Numbers

clc; clear; close all;

file_path_name = '../Math/LookupTables/bernoulli_table';


%% Generate and save the Bernoulli Number table

num_bernoulli_numbers = 300;

bernoulli_table = zeros(1,num_bernoulli_numbers);

for n = 1:num_bernoulli_numbers
    
    bernoulli_table(n) = bernoulli(n-1);
    
end

save(file_path_name, 'bernoulli_table');
