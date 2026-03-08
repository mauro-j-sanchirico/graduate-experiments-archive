function VisualizeAndCompareBigBetaVectors( ...
    number_partial_sum_terms_ns, ...
    big_beta_vector_from_equations, big_beta_vector_from_matricies, ...
    big_beta_a0_vector_from_equations, big_beta_a0_vector_from_matricies)

% Big Beta
figure('Renderer', 'painters', 'Position', [100 100 1100 500]);
subplot(311);
k = 0:(2*number_partial_sum_terms_ns - 1);
hb1 = bar( ...
    k, [big_beta_vector_from_equations big_beta_vector_from_matricies]);
xlabel('$$k$$');
ylabel('$$B$$');
grid on;
grid minor;
xticks(min(k):max(k));
title('$$B$$ Vector');
set(hb1(1), 'FaceColor', 'g');
set(hb1(2), 'FaceColor', 'c');
legend('Equations', 'Matricies');

subplot(312);
bar_y = [log10(abs(big_beta_vector_from_equations)) ...
         log10(abs(big_beta_vector_from_matricies))];
hb1 = bar(k, bar_y);
xlabel('$$k$$');
ylabel('$$\log_{10}(|B|)$$');
grid on;
grid minor;
xticks(min(k):max(k));
title('$$\log_{10}(|B|)$$ Vector');
set(hb1(1), 'FaceColor', 'g');
set(hb1(2), 'FaceColor', 'c');

subplot(313);
bar_y = [sign(big_beta_vector_from_equations) ...
         sign(big_beta_vector_from_matricies)];
hb1 = bar(k, bar_y);
xlabel('$$k$$');
ylabel('sign$$(B)$$');
grid on;
grid minor;
xticks(min(k):max(k));
title('sign$$(B)$$ Vector');
set(hb1(1), 'FaceColor', 'g');
set(hb1(2), 'FaceColor', 'c');

% Big Beta a0
k_evens = k(1:2:end);
figure('Renderer', 'painters', 'Position', [100 100 1100 500]);
subplot(311);
bar_y = ...
    [big_beta_a0_vector_from_equations big_beta_a0_vector_from_matricies];
hb1 = bar(k_evens, bar_y);
xlabel('$$k$$');
ylabel('$$B_{a0}$$');
grid on;
grid minor;
xticks(min(k):max(k));
title('$$B_{a0}$$ Vector');
set(hb1(1), 'FaceColor', 'g');
set(hb1(2), 'FaceColor', 'c');
legend('Equations', 'Matricies');

subplot(312);
bar_y = [log10(abs(big_beta_a0_vector_from_equations)) ...
         log10(abs(big_beta_a0_vector_from_matricies))];
hb1 = bar(k_evens, bar_y);
xlabel('$$k$$');
ylabel('$$\log_{10}(|B_{a0}|)$$');
grid on;
grid minor;
xticks(min(k):max(k));
title('$$\log_{10}(|B_{a0}|)$$ Vector');
set(hb1(1), 'FaceColor', 'g');
set(hb1(2), 'FaceColor', 'c');

subplot(313);
bar_y = [sign(big_beta_a0_vector_from_equations) ...
         sign(big_beta_a0_vector_from_matricies)];
hb1 = bar(k_evens, bar_y);
xlabel('$$k$$');
ylabel('sign$$(B_{a0})$$');
grid on;
grid minor;
xticks(min(k):max(k));
title('sign$$(B_{a0})$$ Vector');
set(hb1(1), 'FaceColor', 'g');
set(hb1(2), 'FaceColor', 'c');

end
