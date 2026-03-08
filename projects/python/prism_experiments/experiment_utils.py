from prism.networks.ffnn import FFNN
from prism.comparison import compare_functions

from datetime import datetime
import numpy as np
import pandas as pd


##
# Utils
#
def get_dated_filename(filename):

    # datetime object containing current date and time
    now = datetime.now()
    dt_str = now.strftime("%Y-%m-%d_%H-%M-%S-%f")
    filename = filename + "_" + dt_str + ".pickle"
    return filename


##
# Data Structures
#
# Here we define the data structures required to perform experiemnts.
#


class AlphaCoefsStruct:

    coefs = None
    exponents = None
    coefs_float64 = None

    def __init__(self, coefs, exponents, coefs_float64):
        """Stores activation function alpha coefs"""
        self.coefs = coefs
        self.exponents = exponents
        self.coefs_float64 = coefs_float64


##
# Algorithms
#
# Here we define algorithms for performing experiments.  These
# algorithms define processes for generating a population of networks,
# introducing defects, and exectuing the full whitebox and blackbox
# defect detection processes.
#


def get_population_of_networks(
    n_per_group,
    hidden_nodes_list,
    inputs_list,
    activation_list,
    lr=0.01,
    momentum=0.1,
    rho=0.9,
    eps=1e-06,
    betas=(0.9, 0.99),
    use_gpu=True,
    optimizer_method="adam",
    weight_decay=0.01,
):
    """Gets a population of networks with the desired characteristics

    Arguments:
    n_per_group -- number of networks per group created in the population
    hidden_nodes_list -- number of hidden nodes for each network group
    inputs_list -- number of inputs for each network group

    Returns:
    population -- list of network objects
    metadata_df -- dataframe of test metadata
    """

    population = []

    # A data frame of all information about the population of networks
    # and their test results is maintained.  The data frame contains
    # information about the networks, their Psi-expansion errors,
    # the direct errors between the identified network vs. the origial
    # network, and the errors between the original network and the true
    # network under test.
    columns = [
        "activation",
        "n_inputs",
        "n_hidden",
        "true_defect",
        "fit_residual",
        "test_snr",
        "test_time",
        "max_weight_perturbation",
        "avg_weight_perturbation",
        "numpy_seed",
        "pytorch_seed",
        "e_asinh_psi",
        "e_mse_psi",
        "e_mae_psi",
        "e_male_psi",
        "e_asinh_direct",
        "e_mse_direct",
        "e_mae_direct",
        "e_male_direct",
        "e_asinh_true",
        "e_mse_true",
        "e_mae_true",
        "e_male_true",
    ]

    metadata = []

    for n_hidden in hidden_nodes_list:
        for n_inputs in inputs_list:
            for activation in activation_list:
                for idx in range(n_per_group):
                    net = FFNN(
                        net_type=activation,
                        n_inputs=n_inputs,
                        n_hidden=n_hidden,
                        lr=lr,
                        momentum=momentum,
                        rho=rho,
                        eps=eps,
                        betas=betas,
                        use_gpu=use_gpu,
                        optimizer_method=optimizer_method,
                        weight_decay=weight_decay,
                    )

                    metadata_row = [
                        activation,
                        n_inputs,
                        n_hidden,
                        None,
                        None,
                        None,
                        None,
                        None,
                        None,
                        None,
                        None,
                        None,
                        None,
                        None,
                        None,
                        None,
                        None,
                        None,
                        None,
                        None,
                        None,
                        None,
                        None,
                    ]

                    metadata.append(metadata_row)
                    population.append(net)

    metadata_df = pd.DataFrame(metadata, columns=columns)

    return population, metadata_df


def introduce_random_defects(implemented_networks, implemented_metadata_df):
    """Introduces random defects into a population of networks

    Logs statistics about the defects introduced.  Operates
    on the lists passed by refference.

    Arguments:
    implemented_networks -- the implemented networks which are
        to have defects introduced into them
    implemented_metadata_df -- the metadata for the implemented
        networks; will be updated with the defect statistics

    Returns:
    None
    """

    for idx, network in enumerate(implemented_networks):

        if idx % 2 == 0:

            # If even index, don't perturb weights - no defect present
            implemented_metadata_df.loc[idx, "true_defect"] = False

            implemented_metadata_df.loc[idx, "max_weight_perturbation"] = 0

            implemented_metadata_df.loc[idx, "avg_weight_perturbation"] = 0

        else:

            # If odd index, perturb weights - defect present here
            w1 = network.get_w1()
            b1 = network.get_b1()
            w2 = network.get_w2()
            b2 = network.get_b2()

            rw1 = 2 * np.random.rand(w1.shape[0], w1.shape[1]) - 1
            rb1 = 2 * np.random.rand(b1.shape[0], b1.shape[1]) - 1
            rw2 = 2 * np.random.rand(w2.shape[0], w2.shape[1]) - 1
            rb2 = 2 * np.random.rand(b2.shape[0], b2.shape[1]) - 1

            a = np.random.rand(1)

            perturbation_w1 = a * rw1
            perturbation_b1 = a * rb1
            perturbation_w2 = a * rw2
            perturbation_b2 = a * rb2

            new_w1 = w1 + perturbation_w1
            new_b1 = b1 + perturbation_b1
            new_w2 = w2 + perturbation_w2
            new_b2 = b2 + perturbation_b2

            network.set_w1(new_w1)
            network.set_b1(new_b1)
            network.set_w2(new_w2)
            network.set_b2(new_b2)

            max_weight_perturbation = np.max(
                [
                    np.max(np.abs(perturbation_w1.flatten())),
                    np.max(np.abs(perturbation_b1.flatten())),
                    np.max(np.abs(perturbation_w2.flatten())),
                    np.max(np.abs(perturbation_b2.flatten())),
                ]
            )

            avg_weight_perturbation = np.mean(
                [
                    np.concatenate(
                        (
                            perturbation_w1.flatten(),
                            perturbation_b1.flatten(),
                            perturbation_w2.flatten(),
                            perturbation_b2.flatten(),
                        )
                    )
                ]
            )

            implemented_metadata_df.loc[
                idx, "max_weight_perturbation"
            ] = max_weight_perturbation

            implemented_metadata_df.loc[
                idx, "avg_weight_perturbation"
            ] = avg_weight_perturbation

            implemented_metadata_df.loc[idx, "true_defect"] = True


def get_interrogation_signal(
    n_samples, n_loops, n_inputs, freq_vector_rad, noise_amt=0.1
):
    """Generates an interrogation signal for a nonlinear system

    Usage:
    x = experiment_utils.get_interrogation_signal(
        n_samples=500, n_loops=5,
        n_inputs=3, freq_vector_rad=[1, 6/5, 11/10], noise_amt=1)

    Arguments:
    n_samples -- The number of samples per iteration
    n_loops -- Number of iterations of the signal
    n_inputs -- The number of signals to generate
    freq_vector_rad -- The vector of frequencies in radians
    noise_amt -- number that contols how much noise is added
        to increase test signal coverage

    Returns:
    x -- the interrogation signal
    """
    amplitudes = np.linspace(0, 1, n_loops)

    x_outer_list = []

    for amplitude in amplitudes:

        t = np.linspace(0, 8 * np.pi, n_samples)

        x_inner_list = []

        for omega_n in freq_vector_rad:

            omega_n = freq_vector_rad

            # Add frequency, phase, bias, and amplitude noise
            # to increase signal coverage
            nr = t.shape[0]
            noise_omega = noise_amt * (2 * np.random.rand(nr) - 1)
            noise_phi = noise_amt * (2 * np.random.rand(nr) - 1)

            omega_n += noise_omega

            x = amplitude * np.sin(omega_n * t + noise_phi)
            x_inner_list.append(x.reshape(-1, 1))

        x_stack = np.hstack(x_inner_list)
        x_outer_list.append(x_stack)

    x = np.vstack(x_outer_list)

    return x


def whitebox_test_population(
    original_networks,
    implemented_networks,
    implemented_metadata_df,
    alpha_dict,
    mc_dict,
    m_max,
    make_plots=False,
    threshold_psi=0.01,
    threshold_true=0.01,
):
    """Tests a population of networks using whitebox methods

    Computes the Psi coefficients of each network directly

    Arguments:
    original_networks -- the original networks
    implemented_networks -- the implemented networks
    implemented_metadata_df -- the metadata for the implemented
        networks; will be updated with the test statistics

    Returns:
    None
    """
    num_networks = len(original_networks)

    for idx, (network1, network2) in enumerate(
        zip(original_networks, implemented_networks)
    ):

        # Get the activation type
        activation_type = implemented_metadata_df.loc[idx, "activation"]

        n_inputs = implemented_metadata_df.loc[idx, "n_inputs"]

        mc_table = mc_dict[n_inputs + 1]

        alpha_coef_struct = alpha_dict[activation_type]

        wbe, runtime = compare_functions.compare_networks_psi_whitebox(
            alpha_coefs1=alpha_coef_struct.coefs,
            alpha_coefs2=alpha_coef_struct.coefs,
            alpha_exponents1=alpha_coef_struct.exponents,
            alpha_exponents2=alpha_coef_struct.exponents,
            beta_network_params1=network1,
            beta_network_params2=network2,
            mc_table=mc_table,
            m_max=m_max,
            eps=1e-8,
            make_plots=make_plots,
        )

        # Set the runtime
        implemented_metadata_df.loc[idx, "test_time"] = runtime

        # Set the whitebox errors - note we only set the psi errors
        # and true errors because the direct errors only are significant
        # for the blackbox algorithm

        # Set the Psi errors
        implemented_metadata_df.loc[idx, "e_asinh_psi"] = wbe.asinh_psi

        implemented_metadata_df.loc[idx, "e_mse_psi"] = wbe.mse_psi

        implemented_metadata_df.loc[idx, "e_mae_psi"] = wbe.mae_psi

        implemented_metadata_df.loc[idx, "e_male_psi"] = wbe.male_psi

        # Set the True errors
        implemented_metadata_df.loc[idx, "e_asinh_true"] = wbe.asinh_true

        implemented_metadata_df.loc[idx, "e_mse_true"] = wbe.mse_true

        implemented_metadata_df.loc[idx, "e_mae_true"] = wbe.mae_true

        implemented_metadata_df.loc[idx, "e_male_true"] = wbe.male_true

        print(
            "Processed {: <5} / {: <5} in {:.3f} s;"
            " e_male_psi = {:.2f}; e_mse_true = {:.2f};".format(
                idx + 1, num_networks, runtime, wbe.male_psi, wbe.mse_true
            )
        )


def blackbox_test_population(
    original_networks,
    implemented_networks,
    implemented_metadata_df,
    alpha_dict,
    mc_dict,
    m_max,
    make_plots=False,
    n_fuzz_points=1000,
    measurement_snr=120,
    n_epochs=100,
    weight_decay=0.01,
    lr=1e-3,
    eps=1e-8,
):
    """Tests a population of networks using whitebox methods

    Computes the Psi coefficients of each network directly

    Arguments:
    original_networks -- the original networks
    implemented_networks -- the implemented networks
    implemented_metadata_df -- the metadata for the implemented
        networks; will be updated with the test statistics

    Returns:
    None
    """
    num_networks = len(original_networks)

    for idx, (network1, network2) in enumerate(
        zip(original_networks, implemented_networks)
    ):

        # Get the activation type
        activation_type = implemented_metadata_df.loc[idx, "activation"]

        n_inputs = implemented_metadata_df.loc[idx, "n_inputs"]

        mc_table = mc_dict[n_inputs + 1]

        alpha_coef_struct = alpha_dict[activation_type]

        x = np.random.rand(n_fuzz_points, network1.n_inputs)
        t = np.arange(0, n_fuzz_points, 1)

        (
            bbe,
            entropy,
            runtime,
            res,
        ) = compare_functions.compare_networks_psi_blackbox(
            alpha_coefs1=alpha_coef_struct.coefs,
            alpha_exponents1=alpha_coef_struct.exponents,
            network1=network1,
            network2=network2,
            mc_table=mc_table,
            interrogation_signal_x=x,
            t=t,
            measurement_snr=measurement_snr,
            n_epochs=n_epochs,
            m_max=m_max,
            weight_decay=weight_decay,
            lr=1e-3,
            make_plots=make_plots,
            eps=1e-8,
            make_logs=False,
        )

        # Set the runtime
        implemented_metadata_df.loc[idx, "test_time"] = runtime

        # Set the whitebox errors - note we only set the psi errors
        # and true errors because the direct errors only are significant
        # for the blackbox algorithm

        # Set the Psi errors
        implemented_metadata_df.loc[idx, "e_asinh_psi"] = bbe.asinh_psi

        implemented_metadata_df.loc[idx, "e_mse_psi"] = bbe.mse_psi

        implemented_metadata_df.loc[idx, "e_mae_psi"] = bbe.mae_psi

        implemented_metadata_df.loc[idx, "e_male_psi"] = bbe.male_psi

        # Set the True errors
        implemented_metadata_df.loc[idx, "e_asinh_true"] = bbe.asinh_true

        implemented_metadata_df.loc[idx, "e_mse_true"] = bbe.mse_true

        implemented_metadata_df.loc[idx, "e_mae_true"] = bbe.mae_true

        implemented_metadata_df.loc[idx, "e_male_true"] = bbe.male_true

        # Set the Direct errors
        implemented_metadata_df.loc[idx, "e_asinh_direct"] = bbe.asinh_direct

        implemented_metadata_df.loc[idx, "e_mse_direct"] = bbe.mse_direct

        implemented_metadata_df.loc[idx, "e_mae_direct"] = bbe.mae_direct

        implemented_metadata_df.loc[idx, "e_male_direct"] = bbe.male_direct

        print(
            "Processed {: <5} / {: <5} in {:.3f} s;"
            " e_male_psi = {:.2f}; e_mse_true = {:.2f};"
            " e_mse_direct = {:.2f};".format(
                idx + 1,
                num_networks,
                runtime,
                bbe.male_psi,
                bbe.mse_true,
                bbe.mse_true,
            )
        )
