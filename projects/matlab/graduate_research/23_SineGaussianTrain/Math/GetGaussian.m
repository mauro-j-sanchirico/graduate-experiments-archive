function d = GetGaussian(t, mu, sigma)

d = zeros(length(t), length(mu));

for i = 1:length(mu)
    d(:,i) = (1/(2*sqrt(2*pi*sigma^2)))*exp(-(t-mu(i)).^2./(2*sigma^2));
end

end
