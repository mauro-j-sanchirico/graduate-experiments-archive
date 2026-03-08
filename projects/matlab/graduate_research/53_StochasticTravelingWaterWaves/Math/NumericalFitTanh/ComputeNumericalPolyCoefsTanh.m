function coefs = ComputeNumericalPolyCoefsTanh(big_n, r, dx)
x = -r:dx:r;
y = tanh(x);
ws = warning('off','all');  % Turn off warnings for polyfitting
coefs = polyfit(x, y, big_n);
warning(ws);  % Turn warnings back on
end
