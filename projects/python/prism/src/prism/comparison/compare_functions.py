from copy import deepcopy
from collections import OrderedDict
import matplotlib.pyplot as plt
import numpy as np
import time

from prism.networks.ffnn import FFNN
from prism.prism_math.psi_expansion import compute_psi_coefs
from prism.prism_math.multinomials import \
    compute_batch_multiexponent, compute_batch_multinomial_sum
from prism.prism_math.signal_utils import awgn

##
# Whitebox Comparison Functions
#
# These functions provide a means of comparing two neural networks when
# the weights of both networks are accessible
#
class WhiteboxErrors:

    asinh_psi = None
    mae_psi = None
    mse_psi = None
    male_psi = None

    asinh_direct = None
    mae_direct = None
    mse_direct = None
    male_direct = None



def compare_networks_psi_whitebox(
        alpha_coefs1, alpha_coefs2,
        alpha_exponents1, alpha_exponents2,
        beta_network_params1, beta_network_params2,
        mc_table, m_max=np.Inf, eps=1e-8,
        n_fuzz_points=1000, make_plots=True):
    """Compares two networks by computing their Psi coefficients
    
    Arguments:
    alpha_coefs1 -- Activation coefs for the first network
    alpha_coefs2 -- Activation coefs for the second network
    alpha_exponents1 -- Exponents cooresponding to the alpha coefs
        for network 1
    alpha_exponents2 -- Exponents cooresponding to the alpha coefs
        for network 2
    beta_network_params1 -- the first network structure
    beta_network_params2 -- the second network structure
    mc_table -- The multinomial coefficient table
    m_max -- The maximum m index to use for the alpha coefs
    eps -- Epsilon to use for numerical computations
    n_fuzz_points -- Number of points to use to collect direct errors
    make_plots -- Flag to make useful visuals

    Returns:
    wbe -- The whitebox error metrics
    runtime -- The runtime of the test
    """

    s = time.perf_counter()

    _, psi1_float64, k_idxs1 = compute_psi_coefs(
        alpha_coefs1, alpha_exponents1,
        beta_network_params1, mc_table, m_max=m_max)

    _, psi2_float64, k_idxs2 = compute_psi_coefs(
        alpha_coefs2, alpha_exponents2,
        beta_network_params2, mc_table, m_max=m_max)

    if make_plots:
        fig, axs = plt.subplots(1, 1, figsize=(13,8))
        axs.plot(
            k_idxs1, np.log10(np.abs(psi1_float64)),
            marker='o', ls='none', mfc='none')
        axs.plot(
            k_idxs2, np.log10(np.abs(psi2_float64)),
            marker='x', ls='none', mfc='none')

    wbe = WhiteboxErrors()

    # Compute Psi Errors
    wbe.asinh_psi = np.sum(np.abs(
        np.arcsinh(psi1_float64/2.0) - np.arcsinh(psi2_float64/2.0)))
    wbe.mae_psi = np.mean(np.abs(psi1_float64 - psi2_float64))
    wbe.mse_psi = np.mean((psi1_float64 - psi2_float64)**2)
    wbe.male_psi = np.nanmean(
        np.abs(np.log(eps + abs(psi1_float64))
        - np.log(eps + abs(psi2_float64))))

    e = time.perf_counter()
    runtime = e - s

    # Run inference on some points
    x = np.random.rand(n_fuzz_points, beta_network_params1.n_inputs)
    y1 = beta_network_params1.infer(x)
    y2 = beta_network_params2.infer(x)

    # Compute true errors
    wbe.asinh_true = np.sum(np.abs(
        np.arcsinh(y1/2.0) - np.arcsinh(y2/2.0)))
    wbe.mae_true = np.mean(np.abs(y1 - y2))
    wbe.mse_true = np.mean((y1 - y2)**2)
    wbe.male_true = np.nanmean(
        np.abs(np.log(eps + abs(y1)) - np.log(eps + abs(y2))))

    return wbe, runtime


##
# Black Box Comparison
#
# These functions provide a means to compare two neural networks when
# one network is not accessible.
#
class BlackboxErrors:

    # Errors in the Psi-expansions derived from the interrogation signal
    asinh_psi = None
    mae_psi = None
    mse_psi = None
    male_psi = None

    # Direct Errors over the entire interrogation signal
    asinh_direct = None
    mae_direct = None
    mse_direct = None
    male_direct = None


def compare_networks_psi_blackbox(
        alpha_coefs1, alpha_exponents1,
        network1, network2,
        mc_table, interrogation_signal_x, t,
        measurement_snr, n_epochs=5,
        m_max=np.Inf, optimization_tolerance=1e-6,
        lr=1e-3, weight_decay=0,
        max_good_epochs=5, max_bad_epochs=5,
        lr_dec_factor=0.99, lr_inc_factor=1.01,
        eps=1e-8, make_plots=True, make_logs=True):
    """Compares two networks when one is a blackbox.
    
    This is a simulated comparison since in reality we
    do have access to the weights of both networks.  The blackbox
    interrogation step is simulated by adding measurement noise
    to the output of the blackbox network before fitting a new
    network to the input-output pairs.
    
    Arguments:
    alpha_coefs1 -- The alpha coefficient vector
    alpha_exponents1 -- The cooresponding alpha exponents
    network1 -- The first network object
    network2 -- The second network object (this one is the blackbox)
    mc_table -- The multinomial coefficients lookup table
    interrogation_signal_x -- The signal to stim both networks with
    t -- The vector of times at which the stim-response pairs are
        collected
    measurement_snr -- The signal to noise ratio applied when
        simulating the measurements
    n_epochs -- The number of epochs to fit the replicated network
    m_max -- The maximum index of the alpha coefficients
    optimization_tolerance -- The tolerance in the optimization
        when searching for the weights of the replicated network
    lr -- The learning rate
    weight_decay -- The regularization parameter
    max_good_epochs -- The maximum number of good epochs before
        increasing the learning rate
    max_bad_epochs -- The maximum number of bad epochs before
        decreasing the learning rate
    lr_dec_factor -- Factor to decrease the learning rate
    lr_inc_factor -- Factor to increase the learning rate
    eps -- Epsilon for numerical computations
    make_plots -- Set to True to make helpful visualizations
    
    Returns:
    bbe -- Blackbox errors
    entropy -- Computed entropy of the interrogation signal
    runtime -- The runtime of the test, not including auxilliary
        experimental computations, such as entropy calculation
    residual -- The residual of the blackbox fit; i.e. the error
        between the measured output of the blackbox network and
        the computed output of the replicated network.
    """

    s = time.perf_counter()

    # Get the Psi1 coefficients from the network we have access to
    if make_logs:
        print('*** Computing Psi coefs for known network...')

    psi1_dict, psi1_float64, k_idxs = compute_psi_coefs(
        alpha_coefs1, alpha_exponents1,
        network1, mc_table, m_max=m_max)

    y_reconstructed1 = compute_batch_multinomial_sum(
        interrogation_signal_x, psi1_dict)

    # Get the Psi2 coefficients numerically
    if make_logs:
        print('*** Stimulating blackbox network and collecting response...')

    # Stimulate network 1 to collect error metrics
    # Stimulate network 2 to extract the blackbox model
    y1 = network1.infer(interrogation_signal_x)
    y2_clean = network2.infer(interrogation_signal_x)
    y2 = awgn(y2_clean, measurement_snr)

    if make_logs:
        print('*** Expected network structure: n_inputs = {}, n_hidden={}, type={}'.format(
            network1.n_inputs, network1.n_hidden, network1.net_type))

    if make_logs:
        print('*** Instantiating replicated network...')

    network_replicated = FFNN(
        net_type=network1.net_type,
        n_inputs=network1.n_inputs,
        n_hidden=network1.n_hidden,
        lr=lr, momentum=0.0,
        use_gpu=True, optimizer_method='sgd',
        optimization_tolerance=optimization_tolerance,
        weight_decay=weight_decay,
        max_good_epochs=max_good_epochs,
        max_bad_epochs=max_bad_epochs,
        lr_dec_factor=lr_dec_factor,
        lr_inc_factor=lr_inc_factor)

    if make_logs:
        print('*** Initializing replicated network to expected values...')

    network_replicated.set_w1(network1.get_w1())
    network_replicated.set_b1(network1.get_b1())
    network_replicated.set_w2(network1.get_w2())
    network_replicated.set_b2(network1.get_b2())

    if make_logs:
        print('*** Initial weights:')
        print(network_replicated.get_w1())
        print(network_replicated.get_b1())
        print(network_replicated.get_w2())
        print(network_replicated.get_b2())
        print()

    if make_logs:
        print('*** Fitting replicated network to stimulus and response...')

    network_replicated.fit(
        interrogation_signal_x, y2, n_epochs=n_epochs, silent=True)

    if make_logs:
        print('*** Found weights:')
        print(network_replicated.get_w1())
        print(network_replicated.get_b1())
        print(network_replicated.get_w2())
        print(network_replicated.get_b2())
        print()

    # Use the alpha coefficients from the known network
    if make_logs:
        print('*** Computing Psi coefficients for replicated network...')
 
    psi2_dict, psi2_float64, k_idxs = compute_psi_coefs(
        alpha_coefs1, alpha_exponents1,
        network_replicated, mc_table, m_max=m_max)

    y_replicated = network_replicated.infer(interrogation_signal_x)
    residual = np.mean((y_replicated - y2)**2)

    y_reconstructed2 = compute_batch_multinomial_sum(
        interrogation_signal_x, psi2_dict)

    if make_plots:
        fig, axs = plt.subplots(1, 1, figsize=(13,8))
        axs.plot(
            k_idxs, np.log10(np.abs(psi1_float64)),
            marker='o', ls='none', mfc='none')
        axs.plot(
            k_idxs, np.log10(np.abs(psi2_float64)),
            marker='x', ls='none', mfc='none')

        axs.legend(('Psi1', 'Psi2'))
 
        fig, axs = plt.subplots(1, 1, figsize=(13,8))
        axs.plot(t, y1, lw=12)
        axs.plot(t, y2, lw=8)
        axs.plot(t, y_reconstructed1, lw=4)
        axs.plot(t, y_reconstructed2, lw=2)
        axs.legend(('y1', 'y2', 'y1 reconstructed', 'y2 reconstructed'))

    if make_logs:
        print('*** Computing error metrics...')

    bbe = BlackboxErrors()

    # Set the Psi errors
    bbe.asinh_psi = np.sum(np.abs(
        np.arcsinh(psi1_float64/2.0) - np.arcsinh(psi2_float64/2.0)))
    bbe.mae_psi = np.mean(np.abs(psi1_float64 - psi2_float64))
    bbe.mse_psi = np.mean((psi1_float64 - psi2_float64)**2)
    bbe.male_psi = np.nanmean(
        np.abs(np.log(eps + abs(psi1_float64)) - np.log(eps + abs(psi2_float64))))

    # Set the direct errors
    bbe.asinh_direct = np.mean(
        np.abs(np.arcsinh(y1/2.0) - np.arcsinh(y_replicated/2.0)))
    bbe.mae_direct = np.mean(np.abs(y1 - y_replicated))
    bbe.mse_direct = np.mean((y1 - y_replicated)**2)
    bbe.male_direct = np.nanmean(
        np.abs(np.log(eps + abs(y1)) - np.log(eps + abs(y_replicated))))

    # Set the true errors (inaccessible in a real test)
    bbe.asinh_true = np.mean(
        np.abs(np.arcsinh(y1/2.0) - np.arcsinh(y2_clean/2.0)))
    bbe.mae_true = np.mean(np.abs(y1 - y2_clean))
    bbe.mse_true = np.mean((y1 - y2_clean)**2)
    bbe.male_true = np.nanmean(
        np.abs(np.log(eps + abs(y1)) - np.log(eps + abs(y2_clean))))

    e = time.perf_counter()
    runtime = e - s

    # TODO: Set entropy
    entropy = 0

    return bbe, entropy, runtime, residual
