clear; clc; close all;

tmin = 0;
tmax = 2*pi;
dt   = 0.01;

t = tmin:dt:tmax;

Uke_Max_Force = 1;
Uke_Force     = Uke_Max_Force.*sin(t);
Uke_Direction = sign(Uke_Force);
Uke_Max_Array = Uke_Max_Force.*Uke_Direction;

Tori_Max_Force = 0.8;
Tori_Force     = Tori_Max_Force.*sin(t);
Tori_Max_array = Tori_Max_Force.*ones(1,length(t));

Result_Force     = Uke_Force + Tori_Force;
Result_Direction = sign(Result_Force); 

Debanna = abs(Result_Force) > Uke_Max_Force;

Wasted_Force =   not(Debanna).*Tori_Force ...
               + Debanna     .*(Uke_Max_Array - Uke_Force);
           
Needed_Force = Tori_Force - Wasted_Force;

figure(1)
hold on
plot(t, Uke_Force, 'b');
plot(t, Tori_Force, 'c');
plot(t, Result_Force, 'm');
plot(t, Uke_Max_Array, '.b');
plot(t, Debanna, 'color', 'k');
plot(t, Wasted_Force, 'color', 'r', 'LineWidth', 3);
plot(t, Needed_Force, 'color', 'g', 'LineWidth', 3);
hold off

legend('Force Applied by Uke          (N)', ...
       'Force Applied by Tori         (N)', ...
       'Resultant Force               (N)', ...
       'Maximum Force Uke can apply   (N)', ...
       'Debanna    (1 = True, 0 = False)', ...
       'Force Wasted by Tori          (N)', ...
       'Force Actually needed by tori (N)');
   
xlabel('Time (s)');
ylabel('Force (N)');

Wasted_Impulse = trapz(t,abs(Wasted_Force));
Needed_Impulse = trapz(t,abs(Needed_Force));

sz_eq_freqs_with_respect_to_phi

