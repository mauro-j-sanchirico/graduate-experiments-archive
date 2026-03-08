%% Analyze rocket cross sectional area
% ------------------------------------------------------------------------
% @breif Performs analysis on the cross sectional area table
% ------------------------------------------------------------------------

function analyze_area_table( ...
    fignum, ...
    area_table, ...
    interp_area ...
)

figure(fignum)
hold on
grid on

scatter(area_table(:,1), area_table(:,2), 'ok');
plot(interp_area(:,1), interp_area(:,2), 'k', 'linewidth', 2);

ylim([min(area_table(:,2))*0.9 max(area_table(:,2))*1.1]);

title('Cross Sectional Area Profile')
xlabel('Time (s)')
ylabel('Cross Sectional Area (m^2)')

legend('Drag Coef', 'Interp. Drag Coef.')