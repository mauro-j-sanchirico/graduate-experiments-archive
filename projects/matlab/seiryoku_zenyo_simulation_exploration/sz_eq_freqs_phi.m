function [Wasted_Impulse Needed_Impulse] = sz_eq_freqs_phi(phi)
tmin = 0;
tmax = 2*pi;
dt   = 0.01;

t = tmin:dt:tmax;

Uke_Max_Force = 1;
Uke_Force     = Uke_Max_Force.*sin(t);
Uke_Direction = sign(Uke_Force);
Uke_Max_Array = Uke_Max_Force.*Uke_Direction;

Tori_Max_Force = 1;
Tori_Force     = Tori_Max_Force.*sin(t+phi);
Tori_Max_array = Tori_Max_Force.*ones(1,length(t));

Result_Force     = Uke_Force + Tori_Force;
Result_Direction = sign(Result_Force); 

Debanna = abs(Result_Force) > Uke_Max_Force;

Wasted_Force =   not(Debanna).*Tori_Force ...
               + Debanna     .*(Uke_Max_Array - Uke_Force);
           
Needed_Force = Tori_Force - Wasted_Force;

Wasted_Impulse = trapz(t,abs(Wasted_Force));
Needed_Impulse = trapz(t,abs(Needed_Force));

end