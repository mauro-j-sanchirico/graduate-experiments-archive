function big_h_max = ComputeHMaxProfile(k, d)

big_l_wavelength = 2*pi/k;
big_h_max = 0.142*big_l_wavelength*tanh(k*d); 

end
