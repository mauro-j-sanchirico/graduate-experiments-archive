% Assumes that t is a time array:
% 
% t = [ 1 2 3 4 5 6 ... ]
%
% Assumes F is a vertical function table with multiple colums
%
% F = [ 
% FA1    FB1   FC1
% FA2    FB2   FC2
% FA3    FB3   FC3
% ... ]
%
% Plots all colums of F with respect to t
function multiplot(t, F, type)
[~, width] = size(F);
t = t';
t = repmat(t,1,width);

if strcmp(type, 'stem')
    stem(t,F);
else
    plot(t,F);
end
end

