function gamma = KikuSingleNeuron(time, measured_output_signal_y)

% Get the design flags
design_flags = GetDesignFlags();
number_of_harmonics_N = design_flags.number_of_harmonics_N;
number_of_taylor_terms_L = design_flags.number_of_taylor_terms_L;

% Kappa table
kappa_table_struct = load('kappa_table.mat');
kappa_table = double(kappa_table_struct.kappa_table);

% Downselect the portion of the kappa matrix for the given parameters
n_start = 1;
L_start = 0;
kappa_matrix = kappa_table( ...
    n_start+1:number_of_harmonics_N+1, ...
    L_start+1:number_of_taylor_terms_L+1);

% Measure the Fourier Series at Output
[~, fourier_coefs_b, ~, ~] = ComputeNumericalFourierSeries( ...
         time, measured_output_signal_y, number_of_harmonics_N);

% Construct the beta naught vector and beta vector
beta_0 = 2./(2*(1:number_of_harmonics_N)-1);
beta_0 = beta_0';

% Don't need the first fourier coefficient (it is always zero for the
% case handled here)
beta = fourier_coefs_b(2:end)'*pi/2;

% Apply LM Nonlinear Least Squares to Find Gamma
options = optimset('display', 'off');
options.Algorithm = 'levenberg-marquardt';
x0 = 1;

error_function = @(gamma) KikuErrorFunction( ...
    gamma, kappa_matrix, beta_0, beta);

gamma = lsqnonlin(error_function, x0, [], [], options);

end

