function VisualizeLinearAndNonlinearSpringPosition( ...
    t_linear, x_distance_linear, t_nonlinear, x_distance_nonlinear, ...
    k_spring_const)

figure;
for idx = 1:length(k_spring_const)
    x_state = x_distance_linear{idx};
    x_pos = x_state(:,1);
    plot3( ...
        t_linear{idx}, k_spring_const(idx)*ones(size(x_pos)), ...
        x_pos, 'k');
    hold on;
end    
grid on;
grid minor;
title('Linear Spring Model Solutions');
zlabel('$$x$$');
ylabel('$$k$$');
xlabel('$$t$$');
view([-7 30]);

figure;
for idx = 1:length(k_spring_const)
    x_state = x_distance_nonlinear{idx};
    x_pos = x_state(:,1);
    plot3( ...
        t_nonlinear{idx}, k_spring_const(idx)*ones(size(x_pos)), ...
        x_pos, 'k');
    hold on;
end    
grid on;
grid minor;
title('Nonlinear Spring Model Solutions');
zlabel('$$x$$');
ylabel('$$k$$');
xlabel('$$t$$');
view([-7 30]);
end

