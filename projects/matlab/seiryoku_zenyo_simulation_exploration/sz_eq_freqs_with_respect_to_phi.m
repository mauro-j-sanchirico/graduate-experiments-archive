clc; clear;

phi_min=0;
dphi   =0.01;
phi_max=4*pi;

phi=phi_min:dphi:phi_max;

RAD_TO_DEG = 180/pi;

Wasted_Impulse = zeros(1,length(phi));
Needed_Impulse = zeros(1,length(phi));
Serioku_Zenyo  = zeros(1,length(phi));
Used_Impulse   = zeros(1,length(phi));

for i = 1:length(phi)
  [Wasted_Impulse(i) Needed_Impulse(i)] = sz_eq_freqs_phi(phi(i));
  Serioku_Zenyo(i) = Needed_Impulse(i)/Wasted_Impulse(i);
  Used_Impulse(i)  = Wasted_Impulse(i)+Needed_Impulse(i);
end

figure(2)
hold on
phi_deg = phi.*RAD_TO_DEG;
plot(phi_deg, Wasted_Impulse, 'r');
plot(phi_deg, Needed_Impulse, 'g');
plot(phi_deg, Used_Impulse,   'b');
plot(phi_deg, Serioku_Zenyo, 'color', 'c', 'LineWidth', 3);

legend('Wasted Impulse (N*s)', ...
       'Needed Impulse (N*s)', ...
       'Used Impulse   (N*s)', ...
       'Serioku Zenyo  (Pure Number)');
   
xlabel('Tori lags Uke (Degrees)');
axis([0 phi_max*RAD_TO_DEG 0 5]);
       