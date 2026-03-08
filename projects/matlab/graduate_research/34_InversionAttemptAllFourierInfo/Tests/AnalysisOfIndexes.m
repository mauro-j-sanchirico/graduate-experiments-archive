clc; clear; close all;

big_m = 9;

num_flat_sum_terms = 0;

fprintf('Printing indicies in form: (m,k)\n\n');

for m = 1:big_m
    
    num_terms_this_iteration = 0;
   
    for k = 0:(2*m-1)
        
        fprintf('(%i, %i)', m, k);
        
        num_terms_this_iteration = num_terms_this_iteration + 1;
        num_flat_sum_terms = num_flat_sum_terms + 1;
        
        if k ~= 2*m-1
            fprintf(', ');
        else
            fprintf('*, ')
        end
        
    end
    
    fprintf('\n');
    
end

fprintf('\nTotal number of terms counted = %i\n', num_flat_sum_terms);
fprintf('M*(M+1) = %i\n', big_m*(big_m+1));