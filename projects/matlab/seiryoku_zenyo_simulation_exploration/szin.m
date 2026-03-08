function [WastedForce NeededForce] = szin(ToriForce, UkeForce)

% Find Uke's range
UkeMax = max(UkeForce)
UkeMin = min(UkeForce)

% Result force is the sum of the force applied by Uke and Tori 
ResultForce = ToriForce + UkeForce;

% How much force did Tori actually have to use to get an equivalent
% result?
ClosestMatch


figure(1)
hold on
plot(UkeForce)
plot(ToriForce, 'c')
plot(ResultForce)
%plot(WastedForce, 'r')
%plot(NeededForce, 'g')
end
