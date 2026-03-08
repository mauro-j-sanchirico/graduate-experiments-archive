function phi_sine_even = ComputePhiSineEven(j, k, phi)

if k >= j
    phi_sine_even = phi^(2*k+1-2*j);
else
    phi_sine_even = 0;
end

end
