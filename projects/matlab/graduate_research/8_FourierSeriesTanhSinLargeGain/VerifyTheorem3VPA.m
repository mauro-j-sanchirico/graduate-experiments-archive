clc; clear; close all;

n_max = 6;
m_max = 6;
l_max = 200;

TestTheorem3(n_max, m_max, l_max);


% @breif Function for testing theorem 3 using numerical integration
% @details Numerically computes the Fourier Series of tanh(g*sin(x)) for
% several values of g.
% @param[in] n_max - Truncation of the Fourier Series
% @param[in] m_max - Truncation of hyperbolic tangent's exponential series
% @param[in] l_max - Truncation of exponential function's Taylor Series
function TestTheorem3(n_max, m_max, l_max)
    x = 0.01:0.01:pi;
    gamma_list = [pi];
    colors     = ['b'];
    legend_strs = {};
    figure;
    for gamma_idx = 1:length(gamma_list)
        n_sum = 0;
        for n = 1:n_max  
            m_sum = 0;
            for m = 1:m_max
                l_sum = 0;
                for l = 0:l_max
                    gamma_power = gamma_list(gamma_idx)^(l);
                    
                    q = (-1)^(vpa(m)+vpa(l))*(2)^(vpa(l)+1)*vpa(m)^(vpa(l))/factorial(vpa(l));
                    
                    integrand = sin((2*n-1)*x).*(sin(x).^(l));
                    integral = trapz(x, integrand);
                    l_sum = l_sum + q*integral*gamma_power;
                end
                m_sum = m_sum + l_sum;
            end
            n_sum = n_sum + (2/(2*n-1) + m_sum)*sin((2*n-1)*x);
        end
        y_approx = 2/pi*n_sum;
        y_truth = tanh(gamma_list(gamma_idx)*sin(x));
        plot(x, y_approx, '-', 'color', colors(gamma_idx), 'linewidth', 2);
        hold on;
        plot(x, y_truth, 'k--', 'linewidth', 2);
        legend_str = sprintf('\\gamma = %0.2f', gamma_list(gamma_idx));
        legend_strs{end+1} = legend_str;
        legend_strs{end+1} = 'Truth';
    end
    legend(legend_strs, 'location', 'southeast');
    grid on;
    grid minor;
    xlabel('x');
    ylabel('y(x)');
    title('Demonstration of Theorem 3');
    xlim([0 4.5]);
end