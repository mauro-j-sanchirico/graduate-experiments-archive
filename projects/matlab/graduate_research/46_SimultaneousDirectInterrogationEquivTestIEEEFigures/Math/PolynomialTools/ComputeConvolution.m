function big_y = ComputeConvolution(x, h)

m = length(x);
n = length(h);

big_x = [x, zeros(1,n)]; 
big_h = [h, zeros(1,m)];

if isa(x(1), 'sym') || isa(h(1), 'sym')
    big_y = sym(zeros(1, m + n - 1));
else
    big_y = zeros(1, m + n - 1);
end

for i = 1:n+m-1
    %big_y(i) = 0;
    for j=1:m
        if(i-j+1>0)
            big_y(i) = big_y(i) + big_x(j)*big_h(i-j+1);
        end
    end
end
end
