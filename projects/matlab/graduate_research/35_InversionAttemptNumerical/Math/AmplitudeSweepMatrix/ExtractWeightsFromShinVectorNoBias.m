function [w10_layer1_shin_algo, w11_layer1_shin_algo] = ...
    ExtractWeightsFromShinVectorNoBias( ...
        shin_vector_fmincon_no_bias, number_partial_sum_terms_ns, ...
        m_table, k_table)

master_index = 1;
breakout_flag = false;
w11_layer0_squared = [];
w11_layer1_squared = [];

for m = 1:number_partial_sum_terms_ns
    for k = 0:(2*m - 1)
        if (2*m-1) == k
            % Get the aux indicies for computation of constraints
            aux_index_1 = GetIndexFromMK( ...
                m_table, k_table, m + 1, k + 2);
            
            w11_layer0_squared = ...
                shin_vector_fmincon_no_bias(aux_index_1) ...
              / shin_vector_fmincon_no_bias(master_index);
          
            if ~isnan(w11_layer0_squared) && ~isempty(w11_layer0_squared)
                breakout_flag = true;
            end
                  
        end
        
        if breakout_flag == true
            break;
        end
        
        master_index = master_index + 1;
    
    end
    
    if breakout_flag == true
        break;
    end
end

w10_layer1_shin_algo = sqrt(w11_layer0_squared);
w11_layer1_shin_algo = 0;
    
end

