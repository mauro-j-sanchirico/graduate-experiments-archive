function VisualizeLinearAndNonlinearSpringForce( ...
    x_distance, f_linear_spring, f_nonlinear_spring, k_spring_const)

figure;
plot3( ...
    x_distance, k_spring_const*ones(size(x_distance)), ...
    f_linear_spring, 'k');
grid on;
grid minor;
title('Linear Spring Model: $$F_S(x) = kx$$');
zlabel('$$F_S$$');
ylabel('$$k$$');
xlabel('$$x$$');
view([-12 37]);

figure;
plot3( ...
    x_distance, k_spring_const*ones(size(x_distance)), ...
    f_nonlinear_spring, 'k');
grid on;
grid minor;
title('Nonlinear Spring Model: $$F_s(x) = \tanh(kx)$$');
zlabel('$$F_S$$');
ylabel('$$k$$');
xlabel('$$x$$');
view([-17 64]);

end

