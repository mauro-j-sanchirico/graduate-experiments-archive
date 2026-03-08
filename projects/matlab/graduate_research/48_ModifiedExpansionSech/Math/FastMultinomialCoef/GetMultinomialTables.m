function [mi_table, mc_table] = GetMultinomialTables()
mi_struct = load('multinomial_indicies_table.mat');
mi_table = mi_struct.multinomial_indicies_table;
mc_struct = load('multinomial_coefs_table.mat');
mc_table = mc_struct.multinomial_coefs_table;
end
