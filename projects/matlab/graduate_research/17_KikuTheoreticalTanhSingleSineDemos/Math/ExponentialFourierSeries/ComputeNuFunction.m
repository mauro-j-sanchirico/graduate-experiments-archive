function nu = ComputeNuFunction(n, k, l_idx)

if k == l_idx + n
    nu = -pi/2;
elseif k == l_idx - n + 1;
    nu = pi/2;
else
    nu = 0;
end

end

