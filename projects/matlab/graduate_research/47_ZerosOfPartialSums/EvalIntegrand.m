function y = EvalIntegrand(x, k, t)
y = (x-t).^k.*sin((k+1).*pi/2 + t);
end

