function phi_sine_odd = ComputePhiSineOdd(j, k, phi)

if k >= j
    phi_sine_odd = phi^(2*k - 2*j);
else
    phi_sine_odd = 0;
end

end
