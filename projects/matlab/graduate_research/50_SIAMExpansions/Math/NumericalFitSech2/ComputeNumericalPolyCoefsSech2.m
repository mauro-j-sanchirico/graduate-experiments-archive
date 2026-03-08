function coefs = ComputeNumericalPolyCoefsSech2(big_n, r, dx)
x = -r:dx:r;
y = sech(x).^2;
ws = warning('off','all');  % Turn off warnings for polyfitting
coefs = polyfit(x, y, big_n);
warning(ws);  % Turn warnings back on
end
