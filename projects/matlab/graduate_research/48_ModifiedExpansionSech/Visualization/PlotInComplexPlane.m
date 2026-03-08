function PlotInComplexPlane(f_handle, real_max, imag_max, du)

real_axis = -real_max:du:real_max;
imag_axis = -imag_max:du:imag_max;

[real_mesh, imag_mesh] = meshgrid(real_axis, imag_axis);

z = f_handle(real_mesh + 1i*imag_mesh);

contour(real_mesh, imag_mesh, log10(abs(real(z))), 30);
%shading interp
view([0 90]);

end
