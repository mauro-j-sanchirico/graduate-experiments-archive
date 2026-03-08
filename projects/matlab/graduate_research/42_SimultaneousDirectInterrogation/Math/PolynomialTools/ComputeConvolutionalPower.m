function y = ComputeConvolutionalPower(x, p)

if p == 0
    y = 1;
else
    y = x;
    for idx = 1:p-1
        y = ComputeConvolution(x, y);
    end
end
