function v_matrix = ConstructVandermondeMatrix( ...
    x_samples, m_index_max, type)

x_samples = x_samples(:);

n_rows = length(x_samples);
m_cols = m_index_max + 1;
v_matrix = zeros(n_rows, m_cols, class(x_samples));

if strcmp(type, 'odd')
    % Leave even powers as zeros
    powers = 1:2:m_index_max;
    powers = fliplr(powers);
    v_matrix = x_samples(:).^powers;
elseif strcmp(type, 'even')
    % Leave odd powers as zeros
    powers = 0:2:m_index_max;
    powers = fliplr(powers);
    v_matrix = x_samples(:).^powers;
else
    % How MATLAB computes the vandermonde matrix - no exponents
    v_matrix(:,m_cols) = ones(length(x_samples), 1);
    for m_index = m_index_max:-1:1
        v_matrix(:,m_index) = x_samples.*v_matrix(:,m_index+1);
    end
end

end
