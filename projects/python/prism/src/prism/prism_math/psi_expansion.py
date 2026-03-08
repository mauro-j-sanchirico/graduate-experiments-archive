from collections import OrderedDict
import numpy as np
import matplotlib.pyplot as plt

from prism.networks.ffnn import FFNN
from prism.prism_math.activation_coefs import get_alpha_coefs
from prism.prism_math.multinomials import \
    get_multinomial_coefs, compute_multiexponent, \
    compute_batch_multiexponent, compute_batch_multinomial_sum

def compute_psi_coefs(
        alpha_coefs, alpha_exponents,
        beta_network_params, mc_table,
        m_max=np.Inf):
    """Compute the psi-expansion of a given network

    Provides the coefficients of a multinomial basis representation of
    a given neural network from that networks weights and alpha
    coefficients.
    
    Params:
    alpha_coefs -- The alpha coefficients vector
    alpha_exponents -- The exponents cooresponding to each alpha coef
    beta_network_params -- The parameters of the network to be expanded
    mc_table -- A lookup table of multinomial 
    m_max -- Maximum activation coefficient to consider
    
    Returns:
    psi_coefs -- The multiprecision psi coefficients (computed at the
        precision of the multinomial coefficient table provided)
    psi_float64 -- Float 64 coefficient vector
    k_idx -- Linear indicies for the length of the coefficient vector
    """

    # Get needed info
    w1 = beta_network_params.get_w1()
    b1 = beta_network_params.get_b1()

    w2 = beta_network_params.get_w2()
    b2 = beta_network_params.get_b2()

    big_m = len(alpha_coefs) # Number of coefs in the alpha expansion
    big_nh, big_ni = w1.shape # Number of hidden nodes and number of inputs
    big_ns = big_ni + 1 # Number of terms inside the sum

    # Populate the Psi Coefficient Dictionary
    psi_coefs = OrderedDict()

    m_stop = min(big_m, m_max)

    for m in range(m_stop):

        j = alpha_exponents[m]
        alpha_coef = alpha_coefs[m]
        mcs = mc_table[(big_ns, j)]

        for k, mc in mcs.items():

            summation = 0

            for nh in range(big_nh):

                theta = np.hstack((w1[nh,:], b1[nh]))
                term = w2[:, nh][0] * compute_multiexponent(theta, k)
                summation += term

            psi_coefs[k] = alpha_coef * mc * summation

    k0 = (0,)*big_ns 
    psi_coefs[k0] = b2[0]

    psi_float64 = np.array(list(psi_coefs.values()), dtype=np.float64)
    k_idx = np.arange(0, psi_float64.shape[0])

    return psi_coefs, psi_float64, k_idx


def visual_test_psi_coefs():

    print('Loading the alpha coefs...')
    (alpha_relu_coefs,
     alpha_relu_exponents,
     alpha_relu_coefs_float64) = get_alpha_coefs(
        load_file='../coefs/relu_vmax7_bigm16_coefs_2021-01-17_20-26-23-931215.pickle')

    (alpha_tanh_coefs,
     alpha_tanh_exponents,
     alpha_tanh_coefs_float64) = get_alpha_coefs(
        load_file='../coefs/tanh_vmax7_bigm16_coefs_2021-01-17_20-24-13-875262.pickle')

    print('Getting the multinomial coefficient tables...')
    mc_table = get_multinomial_coefs(
        load_file='../coefs/multinomial_coefs_m_3_n_0-400_2021-01-10_20-19-13-878901.pickle')

    print('Instantiating the networks...')
    relu_net = FFNN(
        net_type='relu',
        n_inputs=2, n_hidden=3, lr=0.01, momentum=0.1,
        rho=0.9, eps=1e-06, betas=(0.9, 0.99),
        use_gpu=True, optimizer_method='adam')

    tanh_net = FFNN(
        net_type='tanh',
        n_inputs=2, n_hidden=3, lr=0.01, momentum=0.1,
        rho=0.9, eps=1e-06, betas=(0.9, 0.99),
        use_gpu=True, optimizer_method='adam')

    print('Getting a stimulus signal...')
    n_samples = 500
    t = np.linspace(0, 2*np.pi, n_samples)
    omega1 = 1.5
    omega2 = 1

    x1 = np.sin(omega1*t)
    x2 = np.sin(omega2*t)

    x = np.hstack(
        (x1.reshape(-1, 1), x2.reshape(-1, 1)))

    y = -2*(np.heaviside(t - np.pi, 0.5) - 0.5)

    print('Training the neural networks to fit some arbitrary output...')
    relu_net.fit(x, y, n_epochs=5)
    tanh_net.fit(x, y, n_epochs=5)

    print('Stimulating the networks...')
    n_samples = 75
    t = np.linspace(0, 2*np.pi, n_samples)
    omega1 = 5
    omega2 = 4

    x1 = 1*np.sin(omega1*t)
    x2 = 1*np.sin(omega2*t)

    x = np.hstack(
        (x1.reshape(-1, 1), x2.reshape(-1, 1)))

    y_relu_net = relu_net.infer(x)
    y_tanh_net = tanh_net.infer(x)

    y_relu_net = y_relu_net.reshape(-1)
    y_tanh_net = y_tanh_net.reshape(-1)

    print('Computing a psi tensor for the relu net...')
    psi_relu_coefs, psi_relu_float64, k_relu_idx = compute_psi_coefs(
        alpha_coefs=alpha_relu_coefs,
        alpha_exponents=alpha_relu_exponents,
        beta_network_params=relu_net,
        mc_table=mc_table)

    print('Computing a psi tensor for the tanh net...')
    psi_tanh_coefs, psi_tanh_float64, k_tanh_idx = compute_psi_coefs(
        alpha_coefs=alpha_tanh_coefs,
        alpha_exponents=alpha_tanh_exponents,
        beta_network_params=tanh_net,
        mc_table=mc_table)

    print('Computing the output via the psi coefficients...')
    y_relu_psi = compute_batch_multinomial_sum(x, psi_relu_coefs)
    y_tanh_psi = compute_batch_multinomial_sum(x, psi_tanh_coefs)

    y_relu_psi = y_relu_psi.reshape(-1)
    y_tanh_psi = y_tanh_psi.reshape(-1)

    # Visualize the response
    fig, axs = plt.subplots(2, 1, figsize=(8,6))
    axs[0].plot(t, x)
    axs[0].set_title('Input Signals')
    axs[0].legend(('x1', 'x2'))
    axs[0].set_xlabel('t')
    axs[1].plot(t, y_relu_net, linewidth=10, color='blue', alpha=0.5)
    axs[1].plot(t, y_relu_psi, linewidth=2, color='red')
    axs[1].plot(t, y_tanh_net, linewidth=10, color='navy', alpha=0.5)
    axs[1].plot(t, y_tanh_psi, linewidth=2, color='limegreen')
    axs[1].legend(('y_relu', 'y_relu_eq', 'y_tanh', 'y_tanh_eq'))

    # Visualize the Coefs
    fig, axs = plt.subplots(2,1, figsize=(8,6))
    axs[0].scatter(k_relu_idx, np.log(np.abs(psi_relu_float64)))
    axs[0].set_xlabel('k')
    axs[0].set_ylabel('ReLU Network')
    axs[0].set_title('Psi Coefs')
    axs[1].scatter(k_tanh_idx, np.log(np.abs(psi_tanh_float64)))
    axs[1].set_xlabel('k')
    axs[0].set_ylabel('Tanh Network')