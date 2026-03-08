%% Analyze rocket drag coef.
% ------------------------------------------------------------------------
% @breif Performs analysis on the drag table
% ------------------------------------------------------------------------

function analyze_drag_table( ...
    fignum, ...
    drag_table, ...
    interp_drag ...
)

figure(fignum)
hold on
grid on

scatter(drag_table(:,1), drag_table(:,2), 'ok');
plot(interp_drag(:,1), interp_drag(:,2), 'k', 'linewidth', 2);

ylim([min(drag_table(:,2))*0.9 max(drag_table(:,2))*1.1]);

title('Drag Coef. Profile')
xlabel('Time (s)')
ylabel('Drag Coef.')

legend('Drag Coef', 'Interp. Drag Coef.')
